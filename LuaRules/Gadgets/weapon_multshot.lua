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

local function SetPDReload(mult)
	if not ufoID then
		return
	end
	Spring.SetUnitWeaponState(ufoID, 13, {
		reloadTime = 20*(1 - mult),
	})
	Spring.SetUnitWeaponState(ufoID, 14, {
		reloadTime = 20*(1 - mult),
	})
	Spring.SetUnitWeaponState(ufoID, 15, {
		reloadTime = 20*(1 - mult),
	})
	Spring.SetUnitWeaponState(ufoID, 16, {
		reloadTime = 20*(1 - mult),
	})
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitDefID == ufoDefID then
		ufoID = unitID
	end
end

function gadget:Initialize()
	GG.SetPulseLaserShots = SetPulseLaserShots
	GG.SetPDReload = SetPDReload
end
