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

local helipadDefID = UnitDefNames["helipad"].id

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
	
    local enabled = false
	for i = 1, #units do
		local unitID = units[i]
		if unitID ~= ufoID and Spring.GetUnitDefID(unitID) ~= helipadDefID then
			local _,_,_,ux,uy,uz = Spring.GetUnitPosition(unitID, true)
			local unitHeight = Spring.GetUnitHeight(unitID)
			
			if ay - uy < grabDistance + unitHeight then
                local udef = UnitDefs[Spring.GetUnitDefID(unitID)]
                local biomass = Spring.GetGameRulesParam("biomass")
                local research = Spring.GetGameRulesParam("research")
                local metal = Spring.GetGameRulesParam("metal")
                Spring.SetGameRulesParam("biomass", biomass + udef.customParams.biomass)
                Spring.SetGameRulesParam("research", research + udef.customParams.research)
                Spring.SetGameRulesParam("metal", metal + udef.customParams.metal)
				Spring.DestroyUnit(unitID)
			else
                enabled = true
				FloatUnitInDirection(unitID, ax - ux, ay - uy, az - uz, speed, 0.5, GRAVITY + 0.4)
			end
		end
	end
    local env = Spring.UnitScript.GetScriptEnv(ufoID)
    Spring.UnitScript.CallAsUnit(ufoID, env.script.SetBeamEnabled, enabled)
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
    -- cleanup
	for _, unitID in pairs(Spring.GetAllUnits()) do
        Spring.DestroyUnit(unitID)
    end
end
