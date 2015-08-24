local unitName  =  "drone"

unitDef = {
	--Internal settings
	objectName             = "citizen.dae",
    name                   = "Drone",
    unitName               = unitName,
    script                 = unitName .. ".lua",

	-- Movement
	acceleration           = 1.5,
	--airHoverFactor         = 0.1, -- How much the unit moves while hovering on the spot
    airHoverFactor         = -1, --allows it to land
	brakeRate              = 1.0,
	maxVelocity            = 800,
	cruiseAlt              = 200,
    verticalSpeed          = 20,
	turnRate               = 2000,
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
	firestate              = 2,
	movestate              = 2,
	builder                = false,
	canAttack              = true,
	canGuard               = true,
	canMove                = true,
	canPatrol              = true,
	canStop                = true,
	collide                = true,
	upright                = true,

	category               = "ufo",

	-- Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales  = "20 20 20",
	collisionVolumeType    = "sphere",

	-- Attributes
	mass                   = 50,
	maxDamage              = 300,
    -- small auto heal; additionally we'll use shields?
	autoHeal               = 5,
	idleAutoHeal           = 0,
	idleTime               = 1,

	-- Economy
	buildCostEnergy        = 100,
	buildCostMetal         = 100,
	buildTime              = 100,

	weapons                = {
		{
			def                = "beamLaser",
			onlyTargetCategory = "armed",
		},
	},

	weaponDefs             = {
		beamLaser = {
			name                    = "Beam Laser",
			areaOfEffect            = 32,
			avoidFeature            = false,
			avoidFriendly           = false,
			avoidNeutral            = false,
			avoidGround             = false,

			collideFriendly         = false,

			beamTime                = 0.01,
			beamTtl                 = 2,
			coreThickness           = 0.2,
			craterBoost             = 0,
			craterMult              = 0,

			damage                  = {
				default = 2,
			},

			interceptedByShieldType = 1,
			largeBeamLaser          = true,
			laserFlareSize          = 0.1,
			minIntensity            = 1,
			noSelfDamage            = true,
			range                   = 300,
			reloadtime              = 0.01,
			rgbColor                = "0.6 0.1 0.1",
			scrollSpeed             = 10,
			soundTrigger            = true,
			sweepfire               = false,
			thickness               = 20,
			tileLength              = 10000,
			tolerance               = 5000,
			turret                  = true,
			weaponType              = "BeamLaser",
			weaponVelocity          = 100,
			pulseSpeed				= 0.1,
		},
	},
}

return lowerkeys({[unitName] = unitDef})
