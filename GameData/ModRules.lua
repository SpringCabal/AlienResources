	--Wiki: http://springrts.com/wiki/Modrules.lua

local modRules = {
	movement = {
		allowPushingEnemyUnits    = true,
		allowCrushingAlliedUnits  = false,
		allowUnitCollisionDamage  = true,
		allowUnitCollisionOverlap = false,
		allowGroundUnitGravity    = true,
		allowDirectionalPathing   = true,
	},
	system = {
		pathFinderSystem = 0, -- legacy
	},
	
	experience = {
		experienceMult = 1.0; -- defaults to 1.0

		-- these are all used in the following form:
		--   value = defValue * (1 + (scale * (exp / (exp + 1))))
		powerScale  = 0;  -- defaults to 1.0
		healthScale = 0;  -- defaults to 0.7
		reloadScale = 0;  -- defaults to 0.4
	},
}

return modRules
