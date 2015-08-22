include "constants.lua"

-- pieces
local StrongpointNorthBottom = piece "StrongpointNorthBottom"
local StrongpointEastBottom = piece "StrongpointEastBottom"
local StrongpointSouthBottom = piece "StrongpointSouthBottom"
local StrongpointWestBottom = piece "StrongpointWestBottom"

local gun = {
	StrongpointNorthBottom,
	StrongpointEastBottom,
	StrongpointSouthBottom,
	StrongpointWestBottom,
}

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
