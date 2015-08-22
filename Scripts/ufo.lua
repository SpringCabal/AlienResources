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
local innerHull = piece "InnerHull"
local outerhulls = {
	piece ("OuterHull"),
	piece ("OuterHullNE"),
	piece ("OuterHullNW"),
	piece ("OuterHullSE"),
}
local lightBeamEnabled = false

function script.SetBeamEnabled(newEnabled)
    Spring.SetUnitRulesParam(unitID, "beam_enabled", newEnabled and 1 or 0)
	lightBeamEnabled = newEnabled
end


function script.Create()
    
    for i=1, #railing do
		Spin(railing[i],z_axis, i%2*2-1 *5)
    end
	
	for i=1, #outerhulls do
		Spin(outerhulls[i],z_axis, 1)
    end
    
	Spin(innerHull,z_axis, -2)
	
    Spin(turbine, z_axis, 4);
    
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
