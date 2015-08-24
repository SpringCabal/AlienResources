local Building = Unit:New {
	mass				    = 10e5,
    maxDamage               = 10000,
	
    pushResistant           = true,
    blocking                = true,
    canMove                 = false,
    canGuard                = false,
    canPatrol               = false,
    canRepeat               = false,
    stealth				    = true,
	turnRate			    = 0,
	upright				    = true,
    sightDistance		    = 0,
    script                  = "building.lua",
}

local Building1 = Building:New {
    name                = "Building1",	
	
    customParams        = {
		modelradius        = [[60]],
		midposoffset       = [[0 50 0]],
    },
	
    footprintX			    = 6,
	footprintZ			    = 6,
	-- Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales  = "96 120 96",
	collisionVolumeType    = "box",
}

local Building2 = Building:New {
    name                = "Building2",
	
	customParams        = {
		modelradius        = [[60]],
		midposoffset       = [[0 80 0]],
    },
	
    footprintX			    = 4,
	footprintZ			    = 4,
	-- Hitbox
	collisionVolumeOffsets = "0 0 0",
	collisionVolumeScales  = "96 160 96",
	collisionVolumeType    = "box",
}

local Building3 = Building:New {
    name                = "Building3",
}

local Building4 = Building:New {
    name                = "Building4",
}

return lowerkeys({
    Building1       = Building1,
    Building2       = Building2,
    Building3       = Building3,
    Building4       = Building4,
})
