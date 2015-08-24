include "constants.lua"

local base = piece 'base' 
local barrel = piece 'barrel' 
local stalk = piece 'stalk'
local turret = piece 'turret' 
local muzzle = piece 'muzzle' 

local SIG_AIM = 2

function script.Killed(recentDamage, maxHealth)
	return 0
end

function script.AimWeapon(num, heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)

	Turn(stalk, z_axis, heading, math.rad(100))
 	Turn(turret, x_axis, -pitch, math.rad(50))
	WaitForTurn(stalk, y_axis)
 	WaitForTurn(turret, x_axis)
	return true
end

function script.AimFromWeapon()
	return barrel
end

function script.QueryWeapon()
	return muzzle
end