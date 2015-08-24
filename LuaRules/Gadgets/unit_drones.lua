--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
   return {
      name      = "Drones",
      desc      = "Handles Drones",
      author    = "GoogleFrog",
      date      = "24 August 2015",
      license   = "GNU GPL, v2 or later",
      layer     = 0,
      enabled   = true
   }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local ufoDefID      = UnitDefNames["ufo"].id
local droneDefID    = UnitDefNames["drone"].id

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Vector = Spring.Utilities.Vector

local SPAWN_TEAM  = 0 -- teamID of spawned units

local drones = {}
local idleDrones = {}

local wantedDrones = 0
local spawnRate = 1/(2*30)

local spawnProgress = 0

local droneRadius = 300
local maxDroneRadiusSq = 1000^2

local ufoX, ufoY, ufoZ = 0, 0, 0

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Drone Handling

local function GetDistSqToUFO(x, z)
	return Vector.DistSq(x, z, ufoX, ufoZ)
end


local function UpdateDrone(unitID)
	if not (unitID and Spring.ValidUnitID(unitID)) then
		return
	end
	
	local x, _, z = Spring.GetUnitPosition(unitID)
	
	local command = CMD.FIGHT
	if GetDistSqToUFO(x, z) > maxDroneRadiusSq then
		command = CMD.MOVE
	end
	
	local rx, rz = Vector.PolarToCart(droneRadius*(1-math.random()^2), 2*math.pi*math.random(), true)
	Spring.Utilities.GiveClampedOrderToUnit(unitID, command, {ufoX + rx, 0, ufoZ + rz}, {})
end

local function UpdateDroneMovement()
	local drones = Spring.GetTeamUnitsByDefs(SPAWN_TEAM, droneDefID)
	if not drones then
		return
	end
	
	for i = 1, #drones do
		UpdateDrone(drones[i])
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Drone Spawning

local function UpdateDroneSpawning(deltaTime)
	local units = Spring.GetTeamUnitsCounts(SPAWN_TEAM)
	if (units[droneDefID] or 0) < wantedDrones then
		spawnProgress = (spawnProgress or 0) + spawnRate*deltaTime
		if spawnProgress > 1 then
			Spring.CreateUnit(droneDefID, ufoX, ufoY - 100, ufoZ, 0, SPAWN_TEAM, false, false)
			
			spawnProgress = spawnProgress - 1
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Callins

local function UpdateDroneParameters(newWanted, newDronePerSecond)
	wantedDrones = newWanted
	spawnRate = 1/(newDronePerSecond*30)
end

function gadget:GameFrame(n)
	ufoX = Spring.GetGameRulesParam("ufo_x") or 0
	ufoY = Spring.GetGameRulesParam("ufo_y") or 0
	ufoZ = Spring.GetGameRulesParam("ufo_z") or 0
	
	UpdateDroneSpawning(1)
	
	if n%15 == 0 then
		UpdateDroneMovement()
	end
end

function gadget:Initialize()
	GG.UpdateDroneParameters = UpdateDroneParameters
end
