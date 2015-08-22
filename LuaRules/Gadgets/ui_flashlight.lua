function gadget:GetInfo()
  return {
    name      = "Flashlight effect",
    desc      = "Flashlight effect",
    author    = "gajop",
    date      = "August 2015",
    license   = "GNU GPL, v2 or later",
    layer     = -10,
    enabled   = true,
  }
end

LOG_SECTION = "flashlight"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--UNSYNCED
if Script.GetSynced() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

VFS.Include("LuaUI/widgets/glVolumes.lua")

local flashlightIDCount = 1
local flashlights = {}
local flashlightUnit = {}

local FLASHLIGHT_SIZE = 150
local FLASHLIGHT_COLOR = {0.69, 0.61, 0.85, 0.3}

-- purpleish
-- 0.69, 0.61, 0.85, 0.3
-- yellowish
-- 0.941, 0.901, 0.549, 0.3

function gadget:DrawWorldPreUnit()
    gl.PushMatrix()
    for _, f in pairs(flashlights) do
        local x, z, size, c = f.x, f.z, f.size, f.color
        gl.Color(c[1], c[2], c[3], c[4])
        if x ~= nil then
            gl.Utilities.DrawGroundCircle(x, z, size)
        end
    end
    gl.PopMatrix()
end

-- (optional) size
-- (optional) color is an array in format {r, g, b, a}
function CreateFlashlight(x, z, size, color)
    local id = flashlightIDCount
    flashlights[id] = {}
    flashlightIDCount = flashlightIDCount + 1
    UpdateFlashlight(id, x, z, size, color)
    return id
end

-- (optional) size
-- (optional) color is an array in format {r, g, b, a}
function UpdateFlashlight(id, x, z, size, color)
    if not flashlights[id] then
        Spring.Log(LOG_SECTION, LOG.ERROR, "No flashlight with id: " .. tostring(id))
        return
    end
    flashlights[id] = {
        x = x,
        z = z,
        size = size or FLASHLIGHT_SIZE,
        color = color or FLASHLIGHT_COLOR,
    }
end

function RemoveFlashlight(id)
    if not flashlights[id] then
        Spring.Log(LOG_SECTION, LOG.ERROR, "No flashlight with id: " .. tostring(id))
        return
    end
    flashlights[id] = nil
end

GG.flashlights = flashlights

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Unit Handling

function gadget:UnitCreated(unitID)
	if Spring.GetUnitIsDead(unitID) then
		return
	end
	
	local x = Spring.GetUnitRulesParam(unitID, "flashlight_x")
	if x then
		local z = Spring.GetUnitRulesParam(unitID, "flashlight_z") or 100
		local size = Spring.GetUnitRulesParam(unitID, "flashlight_size") or 100
		local cr, cg, cb, ca = 
         Spring.GetUnitRulesParam(unitID, "flashlight_color_r"),
         Spring.GetUnitRulesParam(unitID, "flashlight_color_g"), Spring.GetUnitRulesParam(unitID, "flashlight_color_b"), Spring.GetUnitRulesParam(unitID, "flashlight_color_a")
		flashlightUnit[unitID] = CreateFlashlight(x, z, size, {cr, cg, cb, ca})
	end
end

function gadget:UnitDestroyed(unitID)
	if flashlightUnit[unitID] then
		RemoveFlashlight(flashlightUnit[unitID])
	end
end


function gadget:GameFrame()
	for unitID, index in pairs(flashlightUnit) do
		local x = Spring.GetUnitRulesParam(unitID, "flashlight_x")
		local z = Spring.GetUnitRulesParam(unitID, "flashlight_z") or 100
		local size = Spring.GetUnitRulesParam(unitID, "flashlight_size") or 100
		local cr, cg, cb, ca = 
         Spring.GetUnitRulesParam(unitID, "flashlight_color_r"),
         Spring.GetUnitRulesParam(unitID, "flashlight_color_g"), Spring.GetUnitRulesParam(unitID, "flashlight_color_b"), Spring.GetUnitRulesParam(unitID, "flashlight_color_a")

		UpdateFlashlight(index, x, z, size, {cr, cg, cb, ca})
	end
end


function gadget:Initialize()
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		gadget:UnitCreated(unitID)
	end
end