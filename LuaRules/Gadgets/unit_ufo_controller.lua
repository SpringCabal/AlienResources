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

local aimx, aimy, aimz

-------------------------------------------------------------------
-------------------------------------------------------------------
-- Movement Functions

local function GiveClampedMoveGoal(unitID, x, z, radius)
	radius = radius or 16
	local cx, cz = Spring.Utilities.ClampPosition(x, z)
	local cy = Spring.GetGroundHeight(cx, cz)
	--Spring.MarkerAddPoint(cx, cy, cz)
	Spring.SetUnitMoveGoal(unitID, cx, cy, cz, radius, nil, false) -- The last argument is whether the goal is raw
	return true
end

local function MoveUFO(unitID, x, z, range, radius)
	if not (unitID and Spring.ValidUnitID(unitID)) then
		return
	end
	
	range = range or 1000
	
	local ux, uy, uz = Spring.GetUnitPosition(unitID)
	
	local moveVec = Vector.Norm(range, {x, z})
	
	GiveClampedMoveGoal(unitID, moveVec[1] + ux, moveVec[2] + uz, radius)
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
		if aimx then
			local env = Spring.UnitScript.GetScriptEnv(ufoID)
			Spring.UnitScript.CallAsUnit(ufoID, env.script.AimWeapons, aimx, aimy, aimz)
		end
		if weaponMessage and weaponMessage.frame + 2 <= frame then
			Spring.SetUnitTarget(ufoID, nil)
			weaponMessage = false
		end
	
		if (movementMessage and movementMessage.frame + 2 > frame) then
			MoveUFO(ufoID, movementMessage.x, movementMessage.z)
			ufoMoving = true
		else

			local vx, _, vz = Spring.GetUnitVelocity(ufoID)
			local speed = Vector.AbsVal(vx, vz)
			if ufoMoving or (speed > 6) then
				MoveUFO(ufoID, vx, vz, 20)
				ufoMoving = false
			end
			

			if weaponMessage then
				Spring.SetUnitTarget(ufoID, weaponMessage.x, weaponMessage.y, weaponMessage.z)
			end
			
			movementMessage = false
		end
		
		--local x, y, z = Spring.GetUnitPosition(ufoID)
		--Spring.SetGameRulesParam("ufo_x", x)
		--Spring.SetGameRulesParam("ufo_y", y)
		--Spring.SetGameRulesParam("ufo_z", z)
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
			movementMessage = false
		else
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
	if msg_table[1] == 'aimWeapon' then
		local x = tonumber(msg_table[2])
		local y = tonumber(msg_table[3])
		local z = tonumber(msg_table[4])
		
		if ufoID then
			aimx, aimy, aimz = x, y, z
		end
	end
end

function gadget:RecvLuaMsg(msg)
	HandleLuaMessage(msg)
end

