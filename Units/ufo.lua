local unitName  =  "ufo"

unitDef = {
	--Internal settings
	objectName             = "ufo.dae",
    name                   = "UFO",
    unitName               = unitName,
    script                 = unitName .. ".lua",
	
	-- Movement
	acceleration           = 0.9,
	--airHoverFactor         = 0.1, -- How much the unit moves while hovering on the spot
    airHoverFactor         = -1, --allows it to land
	brakeRate              = 0.5,
	maxVelocity            = 500,
	cruiseAlt              = 450,
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
		modelradius        = "18",
		midposoffset       = "0 0 0",
	},

	-- Abiltiies
	firestate              = 0,
	builder                = false,
	canAttack              = true,
	canGuard               = true,
	canMove                = true,
	canPatrol              = true,
	canStop                = true,
	collide                = true,
	upright                = true,
	
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
	
	weapons                = {
		{
			def                = "gravityBeam",
			onlyTargetCategory = "land",
		},
		{
			def                = "gravityBeam",
			onlyTargetCategory = "land",
		},
		{
			def                = "gravityBeam",
			onlyTargetCategory = "land",
		},
		{
			def                = "gravityBeam",
			onlyTargetCategory = "land",
		},
	},
	
	weaponDefs             = {

		gravityBeam = {
			name                    = "Gravity Beam",
			areaOfEffect            = 128,
			avoidFeature            = false,
			avoidFriendly           = false,
			avoidNeutral            = false,
			avoidGround             = false,
			beamTime                = 0.01,
			beamTtl                 = 2,
			coreThickness           = 0,
			craterBoost             = 0,
			craterMult              = 0,

			customParams            = {
				impulse             = "-60",
				normaldamage        = "0",
			},

			damage                  = {
				default = 2,
			},

			interceptedByShieldType = 1,
			largeBeamLaser          = true,
			laserFlareSize          = 0,
			minIntensity            = 1,
			noSelfDamage            = true,
			range                   = 10000,
			reloadtime              = 0.02,
			rgbColor                = "0.2 0.2 0.2",
			scrollSpeed             = 10,
			soundTrigger            = true,
			sweepfire               = false,
			thickness               = 7,
			tileLength              = 100,
			tolerance               = 5000,
			turret                  = true,
			weaponType              = "BeamLaser",
			weaponVelocity          = 500,
		},
	},
}

return lowerkeys({[unitName] = unitDef})
