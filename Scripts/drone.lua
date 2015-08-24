include "constants.lua"

-- pieces
local base = piece ("base");
local turret = piece ("turret");
local muzzle = piece('muzzle');

function script.Create()
	Spin(turret, z_axis, 2);
	Spin(base, z_axis, -1);
end

function script.QueryWeapon(num)
	return muzzle
end

function script.AimFromWeapon(num) 
	return muzzle
end

function script.AimWeapon(num, heading, pitch)
	return true
end

function script.Killed(recentDamage, maxHealth)
	return 0
end
