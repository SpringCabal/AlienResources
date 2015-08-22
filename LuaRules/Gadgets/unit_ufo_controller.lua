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

local function explode(div,str)
	if (div=='') then return 
		false 
	end
	local pos,arr = 0,{}
	-- for each divider found
	for st,sp in function() return string.find(str,div,pos,true) end do
		table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
		pos = sp + 1 -- Jump past current divider
	end
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
	return arr
end

-------------------------------------------------------------------
-------------------------------------------------------------------

local ufoUnitDefID = UnitDefNames["ufo"].id
local ufoID

local movementMessage
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
	end
end

function gadget:GameFrame(frame)
	if frame%1 ~= 0 then
		return
	end
	
	if ufoID then
		if (movementMessage and movementMessage.frame + 2 > frame) then
			MoveUfo(ufoID, movementMessage.x, movementMessage.z)
		else
			Spring.GiveOrderToUnit(ufoID, CMD.STOP, {}, {})
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
	local msg_table = explode('|', msg)
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
end

function gadget:RecvLuaMsg(msg)
	HandleLuaMessage(msg)
end

