if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "UFO Controller",
		desc	= "Handles UFO control input.",
		author	= "Google Frog",
		date	= "22 August 2015",
		license	= "GNU GPL, v2 or later",
		layer	= 10,
		enabled = true
	}
end

-------------------------------------------------------------------
-------------------------------------------------------------------

local sqrt = math.sqrt

local Vector = Spring.Utilities.Vector

-------------------------------------------------------------------
-------------------------------------------------------------------

local ufoUnitDefID = UnitDefNames["ufo"].id
local ufoID

local movementMessage
local weaponMessage
local ufoMoving

-------------------------------------------------------------------
-------------------------------------------------------------------
-- Movement Functions

function GiveClampedMoveGoal(unitID, x, z)
	local cx, cz = Spring.Utilities.ClampPosition(x, z)
	local cy = Spring.GetGroundHeight(cx, cz)
	--Spring.MarkerAddPoint(cx, cy, cz)
	Spring.SetUnitMoveGoal(unitID, cx, cy, cz, 16, nil) -- The last argument is whether the goal is raw
	return true
end

local function MoveUfo(unitID, x, z)
	if not (unitID and Spring.ValidUnitID(unitID)) then
		return
	end
	
	local ux, uy, uz = Spring.GetUnitPosition(unitID)
	
	local moveVec = Vector.Norm(200, {x, z})
	
	GiveClampedMoveGoal(unitID, moveVec[1] + ux, moveVec[2] + uz)
end

-------------------------------------------------------------------
-------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID)
	if ufoUnitDefID == unitDefID then
		ufoID = unitID
        Spring.GiveOrderToUnit(unitID, CMD.IDLEMODE, {0}, {}) --no land
	end
end

function gadget:GameFrame(frame)
	if ufoID then
		if weaponMessage and weaponMessage.frame + 2 <= frame then
			Spring.SetUnitTarget(ufoID, nil)
			weaponMessage = false
		end
	
		if (movementMessage and movementMessage.frame + 2 > frame) then
			MoveUfo(ufoID, movementMessage.x, movementMessage.z)
		else
			Spring.GiveOrderToUnit(ufoID, CMD.STOP, {}, {})
			if weaponMessage then
				Spring.SetUnitTarget(ufoID, weaponMessage.x, weaponMessage.y, weaponMessage.z)
			end
			
			movementMessage = false
		end
	else
		Spring.CreateUnit(ufoUnitDefID, 3000, 300, 3000, 0, 0)
	end
end

function gadget:Initialize()
	
end

-------------------------------------------------------------------
-------------------------------------------------------------------
-- Handling messages

function HandleLuaMessage(msg)
	local msg_table = Spring.Utilities.ExplodeMessage('|', msg)
	if msg_table[1] == 'movement' then
		local x = tonumber(msg_table[2])
		local z = tonumber(msg_table[3])
		
		if x == 0 and z == 0 then
			ufoMoving = false
			movementMessage = false
		else
			ufoMoving = true
			movementMessage = {
				frame = Spring.GetGameFrame(),
				x = x,
				z = z
			}
		end
	end
	
	if msg_table[1] == 'fireWeapon' then
		local x = tonumber(msg_table[2])
		local y = tonumber(msg_table[3])
		local z = tonumber(msg_table[4])
		
		if ufoID then
			Spring.SetUnitTarget(ufoID, x, y, z)
			
			weaponMessage = {
				frame = Spring.GetGameFrame(),
				x = x,
				y = y,
				z = z
			}
		end
	end
end

function gadget:RecvLuaMsg(msg)
	HandleLuaMessage(msg)
end

