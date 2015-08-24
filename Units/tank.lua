
local Tank = Unit:New {
	--Internal settings
	objectName             = "tank.dae",
    name                   = "tank",
    unitName               = "tank",
    script                 = "tank" .. ".lua",

	sfxtypes               = {
		explosiongenerators = {
		  [[custom:explosion]],
		},
	},
	
	-- Movement
	acceleration           = 0.5,
	brakeRate              = 0.5,
	maxVelocity            = 30,
	turnRate               = 300,
	footprintX             = 2,
	footprintZ             = 2,
	
    movementClass          = "Bot1x1",
	turnInPlace            = true,
	turnInPlaceSpeedLimit  = 1.6, 
	turnInPlaceAngleLimit  = 90,
	
	upright                = true,
	
	customParams           = {
        -- Capture resources (all capturable units should have these fields defined)
        -- Use OOP maybe?
        biomass            = 0,
        research           = 0,
        metal              = 10, -- not to be confused with engine metal
		
		modelradius        = [[30]],
		midposoffset       = [[0 25 0]],
		
		abduct_mult        = 0.2,
	},
	
	-- Abiltiies
	builder                = false,
	canAttack              = true,
	canGuard               = true,
	canMove                = true,
	canPatrol              = true,
	canStop                = true,
	collide                = true,
	leaveTracks            = false, -- Todo, add tracks
	
	movestate              = 2,
	
	collisionVolumeOffsets = "0 0 8",
	collisionVolumeScales  = "50 50 70",
	collisionVolumeType    = "cylZ",
	
	-- Attributes
	category               = "land armed",
	
	mass                   = 100,
	maxDamage              = 1500,
	autoHeal               = 5,
	idleAutoHeal           = 5,
	idleTime               = 60,
	
	-- Economy
	buildCostEnergy        = 100,
	buildCostMetal         = 100,
	buildTime              = 100,
	maxWaterDepth          = 0,
	maxSlope               = 55,
	
	weapons                = {
		{
			def                = "missile",
			onlyTargetCategory = "ufo",
		},
	},
	
	weaponDefs             = {

		missile = {
			name                    = "AA Missile",
			areaOfEffect            = 24,
			burst                   = 2,
			burstrate               = 0.7,
			canattackground         = false,
			--cegTag                  = [[missiletrailbluebig]],
			craterBoost             = 0,
			craterMult              = 0,
			cylinderTargeting       = 3,

			collisionsize = 20,
			targetable              = 1,
			
			damage                  = {
				default = 100,
			},

			--explosionGenerator      = [[custom:FLASH2]],
			fireStarter             = 70,
			flightTime              = 3,
			guidance                = true,
			impactOnly              = true,
			impulseBoost            = 0,
			impulseFactor           = 0.4,
			interceptedByShieldType = 2,
			leadLimit               = 0,
			lineOfSight             = true,
			model                   = [[missile.dae]],
			noSelfDamage            = true,
			range                   = 720,
			reloadtime              = 15,
			renderType              = 1,
			selfprop                = true,
			smokedelay              = [[0.1]],
			smokeTrail              = true,
			--soundHit                = [[explosion/ex_med11]],
			--soundStart              = [[weapon/missile/missile_fire3]],
			startsmoke              = [[1]],
			startVelocity           = 700,
			--texture2                = [[AAsmoketrail]],
			tracks                  = true,
			turnRate                = 70000,
			turret                  = true,
			weaponAcceleration      = 200,
			weaponTimer             = 5,
			weaponType              = "MissileLauncher",
			weaponVelocity          = 1000,
		},
	},
}

local Small_Tank = Tank:New {
	name                = "small_tank",
	maxDamage           = 750,
	maxVelocity         = 60,
	weaponDefs             = {
		missile = {
			damage = {
				default = 25,
			},
		}
	},
}

return lowerkeys({
    Tank        = Tank,
	Small_Tank = Small_Tank,
})
