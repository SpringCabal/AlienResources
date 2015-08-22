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

local railing = {
	piece ("RailingInnerTop"),
	piece ("RailingOuterTop"),
	piece ("RailingInnerLow"),
	piece ("RailingOuterLow"),
}

local turbine = piece "Turbine"

local lightBeamEnabled = false

function script.SetBeamEnabled(newEnabled)
    Spring.SetUnitRulesParam(unitID, "beam_enabled", newEnabled and 1 or 0)
	lightBeamEnabled = newEnabled
end


function script.Create()
    
    for i=1, #railing do
		Spin(railing[i],z_axis, i%2*2-1 *5)
    end
    
    Spin(turbine, z_axis, 10);
    
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
