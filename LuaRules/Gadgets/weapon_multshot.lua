if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "Weapon Multshot",
		desc	= "Implements main abduction weapon of the UFO.",
		author	= "Google Frog (help from xponen impulse float toggle)",
		date	= "22 August 2015",
		license	= "GNU GPL, v2 or later",
		layer	= 10,
		enabled = true
	}
end

-------------------------------------------------------------------
-------------------------------------------------------------------

local ufoID
local ufoDefID = UnitDefNames["ufo"].id

-------------------------------------------------------------------
-------------------------------------------------------------------
local function SetPulseLaserShots(shots)
	if not ufoID then
		return
	end
	Spring.SetUnitWeaponState(ufoID, 19, {
		projectiles = shots,
	})
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitDefID == ufoDefID then
		ufoID = unitID
	end
end

function gadget:Initialize()
	GG.SetPulseLaserShots = SetPulseLaserShots
end
