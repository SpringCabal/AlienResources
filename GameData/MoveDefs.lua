-- Wiki: http://springrts.com/wiki/Movedefs.lua
-- See also; http://springrts.com/wiki/Units-UnitDefs#Tag:movementClass

local moveDefs  =    {
    {
        name            =   "Bot1x1",
        footprintX      =   1,
        footprintZ      =   1,
        maxWaterDepth   =   20,
        maxSlope        =   55,
        crushStrength   =   5,
        heatmapping     =   false,
		speedModClass   =   0,
    },
	{
        name            =   "Tank2x2",
        footprintX      =   2,
        footprintZ      =   2,
        maxWaterDepth   =   20,
        maxSlope        =   55,
        crushStrength   =   5,
        heatmapping     =   false,
		speedModClass   =   2,
    },
	{
        name            =   "Car1x1",
        footprintX      =   2,
        footprintZ      =   2,
        maxWaterDepth   =   20,
        maxSlope        =   55,
        crushStrength   =   5,
        heatmapping     =   false,
		speedModClass   =   1,
    },
}

return moveDefs