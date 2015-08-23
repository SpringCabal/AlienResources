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
		}
		
		local restockTime = LoadCustomParam(ud, "restock_time")
		if restockTime then
			spawnerDefs[i].civRate = spawnerDefs[i].civilians/restockTime
			spawnerDefs[i].sciRate = spawnerDefs[i].scientists/restockTime
		end
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

local ufoX, ufoZ, ufoScareRadiusSq = 0, 0, 0

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
	return Vector.DistSq(x, z, ufoX, ufoZ)
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
	
	if not data.wandering then
		Spring.SetUnitRulesParam(unitID, "selfMoveSpeedChange", 1)
		GG.UpdateUnitAttributes(unitID)
	end
	
	data.wandering = true
	
	if spawners[data.spawnID] and not spawners[data.spawnID].active then
		return
	end
	
	idleWanderer = idleWanderer or {}
	
	idleWanderer[unitID] = true
end

local function WandererWander(unitID)
	if not (unitID and Spring.ValidUnitID(unitID) and wanderers[unitID]) then
		RemoveThing(unitID, wanderers)
		return
	end
	
	local data = wanderers[unitID]
	
	local rx, rz = Vector.PolarToCart(data.wanderRadius*math.random(), 2*math.pi*math.random(), true)
	
	Spring.Utilities.GiveClampedOrderToUnit(unitID, CMD.MOVE, {data.x + rx, 0, data.z + rz}, {})
end

local function WandererCheckFlee(unitID)
	if not (unitID and wanderers[unitID]) then
		RemoveThing(unitID, wanderers)
		return
	end
	
	local data = wanderers[unitID]
	
	if not data.wandering then
		return
	end
	
	local x,_,z = Spring.GetUnitPosition(unitID)
	
	if GetDistSqToUFO(x, z) < ufoScareRadiusSq then
		local fx, fz = Vector.Norm(150, x - ufoX, z - ufoZ)
		Spring.Utilities.GiveClampedOrderToUnit(unitID, CMD.MOVE, {x + fx, 0, z + fz}, {})
		data.wandering = false
		
		Spring.SetUnitRulesParam(unitID, "selfMoveSpeedChange", 2.5)
		GG.UpdateUnitAttributes(unitID)
		
		if idleWanderer and idleWanderer[unitID] then
			idleWanderer[unitID] = nil
		end
	end
end

local function RemoveWanderer(unitID, unitDefID)
	if not (unitID and wanderers[unitID]) then
		RemoveThing(unitID, wanderers)
		return
	end
	
	local data = wanderers[unitID]
	
	local spawnerData = data.spawnID and spawners[data.spawnID]
	
	if spawnerData then
		spawnerData.wanderers[unitID] = nil
		if unitDefID == civilianDefID then
			spawnerData.civilians = spawnerData.civilians - 1
		elseif unitDefID == scientistDefID then
			spawnerData.scientists = spawnerData.scientists - 1
		end
	end
	
	RemoveThing(unitID, wanderers)
end

local function UpdateAllWanderers(frame)
	for unitID,_ in pairs(wanderers) do
		WandererCheckFlee(unitID)
	end
	
	if idleWanderer then
		for unitID,_ in pairs(idleWanderer) do
			WandererWander(unitID)
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
		local sx, sz = Vector.PolarToCart(spawnDef.wanderRadius*math.random(), 2*math.pi*math.random(), true)
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
	
	--// Update whether the spawned units should move.
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
	
	--// Make the first lot of spawned units.
	if data.doInitialSpawn then
		for i = 1, data.spawnDef.civilians do
			if SpawnWanderer(civilianDefID, data) then
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
	
	--// Replace dead units
	if ufoDistSq > UFO_DIST_SPAWN then
		if data.civilians < data.spawnDef.civilians then
			data.civStock = (data.civStock or 0) + data.spawnDef.civRate*deltaTime
			if data.civStock > 1 then
				if SpawnWanderer(civilianDefID, data) then
					data.civilians = data.civilians + 1
				end
				data.civStock = data.civStock - 1
			end
		end
		
		if data.scientists < data.spawnDef.scientists then
			data.sciStock = (data.sciStock or 0) + data.spawnDef.sciRate*deltaTime
			if data.sciStock > 1 then
				if SpawnWanderer(scientistDefID, data) then
					data.scientists = data.scientists + 1
				end
				data.sciStock = data.sciStock - 1
			end
		end
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

local function UpdateAllSpawners(frame)
	if frame%5 == 0 then
		for unitID, data in pairs(spawners) do
			SpawnerUpdate(unitID, 5)
		end
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
	ufoX = Spring.GetGameRulesParam("ufo_x") or 0
	ufoZ = Spring.GetGameRulesParam("ufo_z") or 0
	ufoScareRadiusSq = (Spring.GetGameRulesParam("ufo_scare_radius") or 0)^2
	
	UpdateAllSpawners(n)
	UpdateAllWanderers(n)
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	if spawnerDefs[unitDefID] then
		AddSpawner(unitID, unitDefID)
	elseif unitDefID == carDefID then
		--AddCar(unitID, unitDefID)
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	if spawners[unitID] then
		RemoveSpawner(unitID, unitDefID)
	elseif wanderers[unitID] then
		RemoveWanderer(unitID, unitDefID)
	end
end

function gadget:Initialize()
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		local unitDefID = Spring.GetUnitDefID(unitID)
		--gadget:UnitCreated(unitID, unitDefID)
	end
end