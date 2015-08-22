include "constants.lua"

-- pieces
local StrongpointNorthBottom = piece "LowgunMuzzle"
local StrongpointEastBottom = piece "LowgunMuzzleSE"
local StrongpointSouthBottom = piece "LowgunMuzzleNE"
local StrongpointWestBottom = piece "LowgunMuzzleNW"

local gun = {
	StrongpointNorthBottom,
	StrongpointEastBottom,
	StrongpointSouthBottom,
	StrongpointWestBottom,
}

local lightDisabled = {
    radius = 200,
    radiusOscilation = 50,
    period = 15,
    color = {0.69, 0.61, 0.85, 0.3}
}
local lightEnabled = {
    radius = 150,
    radiusOscilation = 60,
    period = 3,
    color = {0.7, 0.7, 0.8, 0.5},
}
local lightBeamEnabled = false
local maxHeight = UnitDefNames["ufo"].wantedHeight

function script.SetBeamEnabled(newEnabled)
    lightBeamEnabled = newEnabled
end

function LightUpdate()
    while true do
        local x, y, z = Spring.GetUnitPosition(unitID)
        local altitude = y - Spring.GetGroundHeight(x, z)
        Spring.SetUnitRulesParam(unitID, "flashlight_x", x)
        Spring.SetUnitRulesParam(unitID, "flashlight_z", z)
        local light = lightDisabled
        if lightBeamEnabled then
            light = lightEnabled
        end
        local r, ro, p, c = light.radius, light.radiusOscilation, light.period, light.color
        local radius = math.sin(Spring.GetGameFrame() / p) / 3.14 * ro + r
        -- smaller radius if landing/landed
        radius = altitude / maxHeight * radius
        Spring.SetUnitRulesParam(unitID, "flashlight_size", radius)
        Spring.SetUnitRulesParam(unitID, "flashlight_color_r", c[1])
        Spring.SetUnitRulesParam(unitID, "flashlight_color_g", c[2])
        Spring.SetUnitRulesParam(unitID, "flashlight_color_b", c[3])
        Spring.SetUnitRulesParam(unitID, "flashlight_color_a", c[4])
        
        Sleep(30)
    end
end

function script.Create()
    local x, _, z = Spring.GetUnitPosition(unitID)
    StartThread(LightUpdate)
end

function script.QueryWeapon(num) 
	return gun[num] 
end

function script.AimFromWeapon(num) 
	return gun[num] 
end

function script.AimWeapon(num, heading, pitch)
	return true
end

function script.Killed(recentDamage, maxHealth)
	return 0
end
