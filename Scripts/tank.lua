include "constants.lua"

-- pieces
local barrels = {piece "leftflare",
				piece "rightflare"}

				
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
	return 0
end
