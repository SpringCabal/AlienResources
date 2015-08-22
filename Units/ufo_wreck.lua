local unitName  =  "ufo_wreck"

unitDef = {
	--Internal settings
	objectName             = "ufo_wreck.dae",
    name                   = "UFO Wreck",
    unitName               = unitName,
    script                 = unitName .. ".lua",
	
	canMove                = false,
	footprintX             = 2,
	footprintZ             = 2,
	
	useSmoothmesh          = false, -- Broken, do not use it.
	
	customParams           = {
		modelradius        = "18",
		midposoffset       = "0 0 0",
	},

	-- Abiltiies
	firestate              = 0,
	canStop                = true,
	collide                = true,
	upright                = true,
	
	-- Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales  = "128 32 128",
	collisionVolumeType    = "cylY",
	
	-- Attributes
	mass                   = 20000,
	maxDamage              = 1000,
    -- disable auto heal, healing will happen via repairs; additionally we'll use shields?
	autoHeal               = 0,
	idleAutoHeal           = 0,
	idleTime               = 1,
	
	-- Economy
	buildCostEnergy        = 100,
	buildCostMetal         = 100,
	buildTime              = 100,
}

return lowerkeys({[unitName] = unitDef})
