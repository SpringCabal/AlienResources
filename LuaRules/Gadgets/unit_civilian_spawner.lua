--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
   return {
      name      = "Civilian Spawner and Handler",
      desc      = "Spawns Civilians, Scientists and Cars",
      author    = "GoogleFrog",
      date      = "23 August 2015",
      license   = "GNU GPL, v2 or later",
      layer     = 0,
      enabled   = true
   }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local carDefID       = UnitDefNames["civilian"].id
local civilianDefID  = UnitDefNames["civilian"].id
local scientistDefID = UnitDefNames["scientist"].id

local function LoadCustomParam(ud, key)
	return (ud and ud.customParams and ud.customParams[key] and tonumber(ud.customParams[key])) or nil
end

local spawnerDefs = {}

for i = 1, #UnitDefs do
	local ud = UnitDefs[i]
	if ud.customParams and (ud.customParams.wander_radius or ud.customParams.car_period) then
		spawnerDefs[i] = {
			carPeriod    = LoadCustomParam(ud, "car_period"),
			civilians    = LoadCustomParam(ud, "civilians"),
			scientists   = LoadCustomParam(ud, "scientists"),
			wanderRadius = LoadCustomParam(ud, "wander_radius"),
			restockTime  = LoadCustomParam(ud, "restock_time"),
		}
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local Vector = Spring.Utilities.Vector

local SPAWN_TEAM  = 1 -- teamID of spawned units

local UFO_DIST_SPAWN = 3500^2 -- Spawn wanderers if UFO is further from this
local UFO_DIST_ACTIVE = 3000^2 -- Move wanders if UFO is closer than this

local cars = {}      -- Units which move from one point to another
local wanderers = {} -- Units which wander around then go home
local spawners = {}  -- Units which spawn and recieve units

local idleWanderer = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Utility Functions

local function AddThing(key, thingTable, data)
	thingTable[key] = (data or true)
end

local function RemoveThing(key, thingTable)
	if not key then
		return
	end
	thingTable[key] = nil
end

local function GetDistSqToUFO(x, z)
	local ux = Spring.GetGameRulesParam("ufo_x") or 0
	local uz = Spring.GetGameRulesParam("ufo_z") or 0
	
	return Vector.DistSq(x, z, ux, uz)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Wanderer Handling

local function WandererStop(unitID)
	if not (unitID and Spring.ValidUnitID(unitID) and wanderers[unitID]) then
		RemoveThing(unitID, wanderers)
		return
	end
	
	Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, {})
end

local function WandererIdle(unitID)
	if not (unitID and Spring.ValidUnitID(unitID) and wanderers[unitID]) then
		RemoveThing(unitID, wanderers)
		return
	end
	
	local data = wanderers[unitID]
	
	if spawners[data.spawnID] and not spawners[data.spawnID].active then
		return
	end
	
	idleWanderer = idleWanderer or {}
	
	idleWanderer[unitID] = true
end

local function WandererMove(unitID)
	if not (unitID and Spring.ValidUnitID(unitID) and wanderers[unitID]) then
		RemoveThing(unitID, wanderers)
		return
	end
	
	local data = wanderers[unitID]

	local rx, rz = Vector.PolarToCart(data.wanderRadius*(1 - math.random()^2), 2*math.pi*math.random(), true)
	
	Spring.Utilities.GiveClampedOrderToUnit(unitID, CMD.MOVE, {data.x + rx, 0, data.z + rz}, {})
end

local function UpdateAllWanderers()
	if idleWanderer then
		for unitID,_ in pairs(idleWanderer) do
			WandererMove(unitID)
		end
		idleWanderer = false
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Spawner Handling

local function SpawnWanderer(unitDefID, spawnerData)
	
	local spawnDef = spawnerData.spawnDef
	
	for i = 1, 8 do
		local sx, sz = Vector.PolarToCart(spawnDef.wanderRadius*(1 - math.random()^2), 2*math.pi*math.random(), true)
		sx = spawnerData.x + sx
		sz = spawnerData.z + sz
		local sy = Spring.GetGroundHeight(sx, sz)
		
		if Spring.TestMoveOrder(unitDefID, sx, sy, sz) then
			local newID = Spring.CreateUnit(unitDefID, sx, sy, sz, 0, SPAWN_TEAM, false, false)
			if not newID then
				return false
			end
			
			Spring.SetUnitRotation(newID, 0, 2*math.pi*math.random(), 0)
			
			local newData = {
				unitID = newID,
				spawnID = spawnerData.unitID,
				wanderRadius = spawnDef.wanderRadius,
				x = spawnerData.x,
				z = spawnerData.z,
			}
			AddThing(newID, wanderers, newData)
			
			AddThing(newID, spawnerData.wanderers)
			WandererIdle(newID)
			
			return true
		end
	end
	
	return false
end

local function SpawnerUpdate(unitID, deltaTime)
	if not (unitID and Spring.ValidUnitID(unitID) and spawners[unitID]) then
		RemoveThing(unitID, spawners)
		return
	end
	
	local data = spawners[unitID]
	
	local ufoDistSq = GetDistSqToUFO(data.x, data.z)
	
	if ufoDistSq > UFO_DIST_ACTIVE then
		if data.active then
			data.active = false
			for wandererID, _ in pairs(data.wanderers) do
				WandererStop(wandererID)
			end
		end
	else
		if not data.active then
			data.active = true
			for wandererID, _ in pairs(data.wanderers) do
				WandererIdle(wandererID)
			end
		end
	end
	
	if data.doInitialSpawn then
		
		for i = 1, data.spawnDef.civilians do
			if SpawnWanderer(scientistDefID, data) then
				data.civilians = data.civilians + 1
			end
		end
	
		for i = 1, data.spawnDef.scientists do
			if SpawnWanderer(scientistDefID, data) then
				data.scientists = data.scientists + 1
			end
		end
	
		data.doInitialSpawn = nil
		return
	end
	
end

local function AddSpawner(unitID, unitDefID)
	
	local x,y,z = Spring.GetUnitPosition(unitID)
	
	local spawnDef = spawnerDefs[unitDefID]
	
	-- Spawners are static
	local data = {
		unitID = unitID,
		x = x,
		y = y,
		z = z,
		civilians = 0,
		scientists = 0,
		wanderers = {},
		spawnDef = spawnDef,
		doInitialSpawn = true,
	}
	
	AddThing(unitID, spawners, data)
end

local function RemoveSpawner(unitID)
	RemoveThing(unitID, spawners)
end

local function UpdateAllSpawners()
	for unitID, data in pairs(spawners) do
		SpawnerUpdate(unitID, deltaTime)
	end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Callins

function gadget:UnitIdle(unitID, unitDefID, unitTeam)
	if wanderers[unitID] then
		WandererIdle(unitID)
	end
	if cars[unitID] then
		CarIdle(unitID)
	end
end

function gadget:GameFrame(n)
	UpdateAllSpawners()
	UpdateAllWanderers()
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	if spawnerDefs[unitDefID] then
		AddSpawner(unitID, unitDefID)
	elseif unitDefID == carDefID then
		--AddCar(unitID, unitDefID)
	end
end

function gadget:Initialize()
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		local unitDefID = Spring.GetUnitDefID(unitID)
		gadget:UnitCreated(unitID, unitDefID)
	end
end