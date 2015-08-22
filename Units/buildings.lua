local Building = Unit:New {
    customParams        = {
        radius = 30,
    },
    footprintX			    = 8,
	footprintZ			    = 8,
	mass				    = 10e5,
    maxDamage               = 10000,
    collisionVolumeScales   = '0 0 0',
    collisionVolumeType     = 'cylY',
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
    script                  = "building.lua",
}

local Building1 = Building:New {
    name                = "Building1",
}
local Building2 = Building:New {
    name                = "Building2",
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
