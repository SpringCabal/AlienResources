local unitName  =  "ufo"

unitDef = {
	--Internal settings
	objectName             = "ufo.dae",
    name                   = "UFO",
    unitName               = unitName,
    script                 = unitName .. ".lua",
	
	-- Movement
	acceleration           = 0.18,
	airHoverFactor         = 0.1, -- How much the unit moves while hovering on the spot
	brakeRate              = 0.5,
	maxVelocity            = 200,
	cruiseAlt              = 100,
	turnRate               = 0, -- Implement turning in script
	footprintX             = 2,
	footprintZ             = 2,
	
	useSmoothmesh          = false, -- Broken, do not use it.
	bankingAllowed         = false,
	canFly                 = true,
	floater                = true,
	hoverAttack            = true,
	canSubmerge            = false,
	turnInPlaceAngleLimit  = 180,
	
	customParams           = {
		modelradius        = [[18]],
		midposoffset       = [[0 0 0]],
	},

	-- Abiltiies
	builder                = false,
	canAttack              = true,
	canGuard               = true,
	canMove                = true,
	canPatrol              = true,
	canStop                = true,
	collide                = true,
	
	-- Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales  = "128 32 128",
	collisionVolumeType    = "cylY",
	
	-- Attributes
	mass                   = 200,
	maxDamage              = 1000,
	autoHeal               = 5,
	idleAutoHeal           = 5,
	idleTime               = 60,
	
	-- Economy
	buildCostEnergy        = 100,
	buildCostMetal         = 100,
	buildTime              = 100,
}

return lowerkeys({[unitName] = unitDef})
