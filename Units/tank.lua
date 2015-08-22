local unitName  =  "tank"

unitDef = {
	--Internal settings
	objectName             = "tank.dae",
    name                   = "tank",
    unitName               = unitName,
    script                 = unitName .. ".lua",
	
	-- Movement
	acceleration           = 0.5,
	brakeRate              = 0.5,
	maxVelocity            = 30,
	turnRate               = 300,
	footprintX             = 1,
	footprintZ             = 1,
	
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
	
	-- Attributes
	category               = "land",
	
	mass                   = 100,
	maxDamage              = 1000,
	autoHeal               = 5,
	idleAutoHeal           = 5,
	idleTime               = 60,
	
	-- Economy
	buildCostEnergy        = 100,
	buildCostMetal         = 100,
	buildTime              = 100,
	maxWaterDepth          = 20,
	
	weapons                = {
		{
			def                = "missile",
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
			range                   = 420,
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

return lowerkeys({[unitName] = unitDef})
