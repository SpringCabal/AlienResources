if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "Unit Spawner",
		desc	= "Spawns units for the game.",
		author	= "Google Frog",
		date	= "24 August 2015",
		license	= "GNU GPL, v2 or later",
		layer	= 80,
		enabled = true
	}
end

-------------------------------------------------------------------
-------------------------------------------------------------------

local ufoUnitDefID = UnitDefNames["ufo"].id
local buildingDefID = UnitDefNames["building1"].id
local baseDefID = UnitDefNames["building4"].id

-------------------------------------------------------------------
-------------------------------------------------------------------

local ufoRespawnFrame 
local ufoID
local x, y, z

function gadget:Initialize()
	-- cleanup
    Spring.SetGameRulesParam("gameOver", 0)
    Spring.SetGameRulesParam("gameWon", 0)
	
	if Game.gameName == "Scenario Editor Alien resources" then
		gadgetHandler:RemoveGadget()
		return
	end
	
	for _, unitID in pairs(Spring.GetAllUnits()) do
        Spring.DestroyUnit(unitID)
    end
	
-- 	-- Spawn new things
-- 	ufoID = Spring.CreateUnit(ufoUnitDefID, 12000, 300, 18000, 0, 0)
-- 	
-- 	Spring.CreateUnit(buildingDefID, 13000, 300, 17000, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13200, 300, 17000, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13400, 300, 17000, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13600, 300, 17000, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13000, 300, 17500, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13200, 300, 17500, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13400, 300, 17500, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13600, 300, 17500, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13000, 300, 18000, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13200, 300, 18000, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13400, 300, 18000, 0, 1)
-- 	Spring.CreateUnit(buildingDefID, 13600, 300, 18000, 0, 1)
-- 	
-- 	Spring.CreateUnit(baseDefID, 8500, 300, 18000, 0, 1)
end

function gadget:UnitCreated(unitID, unitDefID) 
	if unitDefID == ufoUnitDefID then
		ufoID = unitID
		x, y, z = Spring.GetUnitPosition(ufoID)
		GG.SetUnitPermanentFallDamageImmunity(ufoID, true)
	end
end

function gadget:UnitDestroyed(unitID, unitDefID)
	if unitID == ufoID then
		-- 		Spring.SetGameRulesParam("gameOver", 1)
		-- 		Spring.SetGameRulesParam("gameWon", 0)
		-- 		actually let's just respawn the UFO at the initial place after some time
		ufoRespawnFrame = Spring.GetGameFrame() + 2 * 30
	end
end

function gadget:GameFrame()
	if ufoRespawnFrame == Spring.GetGameFrame() then
		Spring.CreateUnit(ufoUnitDefID, x, y, z, 0, 0)
		ufoRespawnFrame = nil
	end
end
