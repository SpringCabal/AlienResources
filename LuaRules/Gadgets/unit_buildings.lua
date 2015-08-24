--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
   return {
      name      = "Explosions",
      desc      = "Handles explosions",
      author    = "gajop",
      date      = "August 2015",
      license   = "GNU GPL, v2 or later",
      layer     = 0,
      enabled   = true
   }
end

local explode = {
	[UnitDefNames["building1"].id] = true,
	[UnitDefNames["building2"].id] = true,
	[UnitDefNames["building3"].id] = true,
	[UnitDefNames["building4"].id] = true,
	[UnitDefNames["building4bigtank"].id] = true,
	[UnitDefNames["static_aa"].id] = true,
	[UnitDefNames["strong_aa"].id] = true,
	[UnitDefNames["tank"].id] = true,
	[UnitDefNames["small_tank"].id] = true,
}

function gadget:UnitDestroyed(unitID, unitDefID)
	if explode[unitDefID] then
		local x, y, z = Spring.GetUnitPosition(unitID)
		Spring.PlaySoundFile("sounds/explosion.wav", 2, x, y, z)
	end
end