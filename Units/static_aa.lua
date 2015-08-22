local Static_AA = Unit:New {
    customParams        = {
        radius = 0,
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
    yardMap                 = "oooooooo oooooooo oooooooo oooooooo oooooooo oooooooo oooooooo oooooooo",

    name                = "Static AA",
    script              = "static_aa.lua",
    onoffable               = true,
    isAirbase = true,
}

return lowerkeys({
    Static_AA       = Static_AA,
})
