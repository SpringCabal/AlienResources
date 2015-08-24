include "constants.lua"

local base = piece 'base' 
local barrel = piece 'barrel' 
local stalk = piece 'stalk'
local turret = piece 'turret' 
local muzzle = piece 'muzzle' 

local explodePieces = {barrel, turret, stalk, base}

local SIG_AIM = 2

function script.Killed(recentDamage, maxHealth)
	local flags = SFX.FIRE+SFX.SMOKE+SFX.NO_HEATCLOUD+SFX.EXPLODE_ON_HIT;
	for i=1,#explodePieces do
		EmitSfx(explodePieces[i],1024);
		Explode(explodePieces[i],flags);
		Sleep(math.random(400));
	end
	return 0
end

function script.AimWeapon(num, heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)

	Turn(stalk, z_axis, heading, math.rad(100))
 	Turn(turret, x_axis, -pitch, math.rad(50))
	WaitForTurn(stalk, z_axis)
 	WaitForTurn(turret, x_axis)
	return true
end

function script.AimFromWeapon()
	return barrel
end

function script.QueryWeapon()
	return muzzle
end
