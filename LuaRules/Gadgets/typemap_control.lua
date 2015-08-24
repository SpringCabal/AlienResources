--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Typemap Control",
    desc      = "Controls typemaps.",
    author    = "Google Frog",
    date      = "23 August 2015",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

local spGetGroundInfo = Spring.GetGroundInfo
local spSetTerrainTypeData = Spring.SetTerrainTypeData
local spSetMapSquareTerrainType = Spring.SetMapSquareTerrainType
local spGetGameFrame = Spring.GetGameFrame

--Spring.GetGroundInfo(number x, number z) --> string "terrain-type name", ...
--Spring.SetTerrainTypeData(1,2.0,1.0,1.0,1.0)
--Spring.SetMapSquareTerrainType(xPos,zPos,1)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if (not gadgetHandler:IsSyncedCode()) then
  return false  --  no unsynced code
end

local FIRE_TERRAIN   = 10
local IMPASSABLE     = 11
local NORMAL_TERRAIN = 1

local terrainWeaponDefs = {
	[WeaponDefNames["ufo_incendiarybeamlaser"].id] = {
		duration = 60,
		terrain = FIRE_TERRAIN
	}
}

local blockUnitDefs = {}

local DAMAGE_PERIOD = 2 -- how often damage is applied

for id, data in pairs(UnitDefs) do
	local cp = data.customParams
	if cp and cp.terrainblock_x then
		blockUnitDefs[id] = {
			x = tonumber(cp.terrainblock_x)/2,
			z = tonumber(cp.terrainblock_z or cp.terrainblock_x)/2,
		}
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local tempFire = {}

local blockMap = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function SetTerrain(x, z, timeout, terrain)
	if blockMap[x] and blockMap[x][z] then
		return false
	end
	tempFire[tostring(x) .. tostring(z)] = {
		x = x,
		z = z,
		timeout = timeout,
	}
	
	Spring.SetMapSquareTerrainType(x, z, terrain)
end

local function BlockArea(left, top, right, bot)
	left = math.floor((left + 4)/8)*8
	top = math.floor((top + 4)/8)*8
	right = math.floor((right + 4)/8)*8
	bot = math.floor((bot + 4)/8)*8

	for x = left, right, 8 do 
		blockMap[x] = blockMap[x] or {}
		
		for z = top, bot, 8 do 
			blockMap[x][z] = true
			
			Spring.SetMapSquareTerrainType(x, z, IMPASSABLE)
		end
	end
	
end

local function AddBlockingUnit(unitID, unitDefID)
	local data = blockUnitDefs[unitDefID]
	local x,_,z = Spring.GetUnitPosition(unitID)
	if x then
		BlockArea(x - data.x, z - data.z, x + data.x, z + data.z)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:Explosion(weaponID, px, py, pz, ownerID)
	if (terrainWeaponDefs[weaponID]) then
		px = math.floor((px + 4)/8)*8
		pz = math.floor((pz + 4)/8)*8
		
		local timeout = Spring.GetGameFrame() + 210
		
		local data = terrainWeaponDefs[weaponID]
		for x = -16, 16, 8 do 
			for z = -16, 16, 8 do 
				SetTerrain(px + x, pz + z, timeout, data.terrain)
			end
		end
	end
end

function gadget:UnitCreated(unitID, unitDefID)
	if blockUnitDefs[unitDefID] then
		AddBlockingUnit(unitID, unitDefID)
	end
end

function gadget:GameFrame(n)
	if n%20 == 0 then
		for key, data in pairs(tempFire) do
			if n > data.timeout then
				Spring.SetMapSquareTerrainType(data.x, data.z, NORMAL_TERRAIN)
				tempFire[key] = nil
			end
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:Initialize()
	Spring.SetTerrainTypeData(IMPASSABLE, 0, 0, 0, 0)
	Spring.SetTerrainTypeData(FIRE_TERRAIN, 0, 0, 0.8, 0.8)
	Spring.SetTerrainTypeData(NORMAL_TERRAIN, 1, 1, 1, 1)
	
	for w,_ in pairs(terrainWeaponDefs) do
		Script.SetWatchWeapon(w, true)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------