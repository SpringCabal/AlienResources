if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "UFO Abduction",
		desc	= "Implements main abduction weapon of the UFO.",
		author	= "Google Frog (help from xponen impulse float toggle)",
		date	= "22 August 2015",
		license	= "GNU GPL, v2 or later",
		layer	= 10,
		enabled = true
	}
end

-------------------------------------------------------------------
-------------------------------------------------------------------

local GRAVITY = Game.gravity/30/30
local RAD_PER_ROT = (math.pi/(2^15))

local ufoUnitDefID = UnitDefNames["ufo"].id
local ufoID

local Vector = Spring.Utilities.Vector

-------------------------------------------------------------------
-------------------------------------------------------------------

local function FloatUnitInDirection(unitID, x, y, z, speed, hAccel, vAccel)
	
	local dx, dy, dz = Spring.GetUnitVelocity(unitID)
	
	local vx, vy, vz = Vector.Norm(speed, x, y, z)
	
	local dyCorrection = math.min(vAccel, vy + GRAVITY - dy)
	
	local dxCorrection = vx - dx
	local dzCorrection = vz - dz
	
	dxCorrection, dzCorrection = Vector.Norm(hAccel, dxCorrection, dzCorrection)
	
	local headingInRadian = Spring.GetUnitHeading(unitID)*RAD_PER_ROT --get current heading
	Spring.SetUnitRotation(unitID, 0, -headingInRadian, 0) --restore current heading. This force unit to stay upright/prevent tumbling.TODO: remove negative sign if Spring no longer mirror input anymore 
	Spring.AddUnitImpulse(unitID, 0, -4, 0) --Note: -4/+4 hax is for impulse capacitor  (Spring 91 only need -1/+1, Spring 94 require at least -4/+4). TODO: remove -4/+4 hax if no longer needed
	Spring.AddUnitImpulse(unitID, dxCorrection, 4 + dyCorrection, dzCorrection)
end

local function SetAbductionArea(ax, ay, az, grabDistance, radius, speed)
	
	local units = Spring.GetUnitsInCylinder(ax, az, radius)
	
	for i = 1, #units do
		local unitID = units[i]
		if unitID ~= ufoID then
			local _,_,_,ux,uy,uz = Spring.GetUnitPosition(unitID, true)
			local unitHeight = Spring.GetUnitHeight(unitID)
			
			if ay - uy < grabDistance + unitHeight then
				Spring.Echo("Unit Captured")
				Spring.DestroyUnit(unitID)
			else
				FloatUnitInDirection(unitID, ax - ux, ay - uy, az - uz, speed, 0.1, GRAVITY + 0.1)
			end
		end
	end

end

-------------------------------------------------------------------
-------------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID)
	if ufoUnitDefID == unitDefID then
		ufoID = unitID
	end
end

function gadget:GameFrame(frame)
	if ufoID then
		local x,y,z = Spring.GetUnitPosition(ufoID)
		if not x then
			return
		end
		
		SetAbductionArea(x, y, z, 20, 100, 8)
	end
end

function gadget:Initialize()
	
end
