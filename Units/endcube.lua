local unitName  =  "endcube"

-- capture this = win game
unitDef = {
	--Internal settings
	objectName             = "cube.dae",
    name                   = "Endcube",
    unitName               = unitName,
    script                 = unitName .. ".lua",
	
	-- Movement
	acceleration           = 0.5,
	brakeRate              = 0.5,
	maxVelocity            = 40,
	turnRate               = 3000,
	footprintX             = 1,
	footprintZ             = 1,
	
    movementClass          = "Bot1x1",
	turnInPlace            = true,
	turnInPlaceSpeedLimit  = 1.6, 
	turnInPlaceAngleLimit  = 90,
	
	upright                = true,
	
	customParams           = {
		modelradius        = [[12]],
		midposoffset       = [[0 0 0]],
        -- Capture resources (all capturable units should have these fields defined)
        -- Use OOP maybe?
        biomass            = 0,
        research           = 0,
        metal              = 0, -- not to be confused with engine metal
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
	
	-- Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales  = "16 32 16",
	collisionVolumeType    = "cylY",
	
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
}

return lowerkeys({[unitName] = unitDef})
