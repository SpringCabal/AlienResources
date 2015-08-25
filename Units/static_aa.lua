local Static_AA = Unit:New {
    footprintX			    = 8,
	footprintZ			    = 8,
	mass				    = 10e5,
    maxDamage               = 1500,
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

	sfxtypes               = {
		explosiongenerators = {
		  [[custom:explosion]],
		},
	},

	weapons                = {
		{
			def                = "beamLaser",
			onlyTargetCategory = "ufo",
		},
	},

	weaponDefs             = {
		beamLaser = {
			name                    = "Pulse laser",
			areaOfEffect            = 2,
			avoidFeature            = false,
			avoidFriendly           = false,
			avoidNeutral            = false,
			avoidGround             = false,
			coreThickness           = 0,
			craterBoost             = 0,
			craterMult              = 0,

			damage                  = {
				default = 4,
			},

			explosionGenerator      = [[custom:genericshellexplosion-large-sparks-burn]],
			interceptedByShieldType = 1,
			noSelfDamage            = true,
			range                   = 2000,
			reloadtime              = 0.01,
			rgbColor                = "0.8 0.2 0.2",
			soundTrigger            = true,
			thickness               = 5,
			tolerance               = 5000,
			turret                  = true,
			weaponType              = "LaserCannon",
			weaponVelocity          = 2500,
			soundstart  			= "pulse.wav",
		},
	},
}

local Strong_AA = Static_AA:New {
	name                = "Strong AA",
	weaponDefs             = {
		beamLaser = {
			explosionGenerator      = [[custom:genericshellexplosion-large-sparks-burn]],
			name                    = "Beam Laser",
			coreThickness           = 0.3,
			craterBoost             = 0,
			craterMult              = 0,

			damage                  = {
				default = 10,
			},
			rgbColor                = "0.5 0.1 0.9",
			thickness               = 25,
		},
	},
}

return lowerkeys({
    Static_AA       = Static_AA,
	Strong_AA 	    = Strong_AA,
})
