local Static_AA = Unit:New {
    footprintX			    = 8,
	footprintZ			    = 8,
	mass				    = 10e5,
    maxDamage               = 10000,
    pushResistant           = true,
    blocking                = false,
    canMove                 = false,
    canGuard                = false,
    canPatrol               = false,
    canRepeat               = false,
    stealth				    = true,
	turnRate			    = 0,
	upright				    = true,
    sightDistance		    = 0,
    yardMap                 = "oooooooo oooooooo oooooooo oooooooo oooooooo oooooooo oooooooo oooooooo",

	category               = "land armed",
	
    name                = "Static AA",
    script              = "static_aa.lua",
	
	 customParams        = {
		modelradius        = [[40]],
		midposoffset       = [[0 50 0]],
		
		terrainblock_x     = 64,
		terrainblock_z     = 64,
    },
	
    footprintX			    = 6,
	footprintZ			    = 6,
	-- Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales  = "50 60 50",
	collisionVolumeType    = "cylY",
	
	
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
				default = 20,
			},

			interceptedByShieldType = 1,
			largeBeamLaser          = true,
			laserFlareSize          = 0.1,
			minIntensity            = 1,
			noSelfDamage            = true,
			range                   = 2000,
			reloadtime              = 0.01,
			rgbColor                = "0.5 0.1 0.9",
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

return lowerkeys({
    Static_AA       = Static_AA,
})
