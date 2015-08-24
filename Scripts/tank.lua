include "constants.lua"

-- pieces
local barrels = {
	piece "muzzleLeft",
	piece "muzzleRight"
}
				
local pieces = {
	piece "tubeLeft",
	piece "tubeRight",
	piece "turret",
	piece "base",
}
				
local currentBarrel = #barrels
function script.Create()

end

function script.QueryWeapon(num)
	
	return barrels[currentBarrel]
end

function script.AimFromWeapon(num) 
	return barrels[currentBarrel]
end

function script.AimWeapon(num, heading, pitch)
	return true
end

function script.Shot(num)
	currentBarrel = currentBarrel % #barrels + 1
end

function script.Killed(recentDamage, maxHealth)
	local flags = SFX.FIRE+SFX.SMOKE+SFX.NO_HEATCLOUD+SFX.EXPLODE_ON_HIT;
	for i=1,#pieces do
		EmitSfx(pieces[i],1024);
		Explode(pieces[i],flags);
		Sleep(math.random(400));
	end
	return 0
end
