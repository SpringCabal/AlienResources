include "constants.lua"

-- pieces

local muzzle = {
	piece "LowgunMuzzle",
	piece "LowgunMuzzleSE",
	piece "LowgunMuzzleNE",
	piece "LowgunMuzzleNW",
}

local gun = {
	piece "Lowgun",
	piece "LowgunSE",
	piece "LowgunNE",
	piece "LowgunNW",
}

local gunBase = {
	piece "LowgunBase",
	piece "LowgunSEBase",
	piece "LowgunNEBase",
	piece "LowgunNWBase",
}

local gunHeading = { } -- populated in create

local railing = {
	piece "RailingInnerTop",
	piece "RailingOuterTop",
	piece "RailingInnerLow",
	piece "RailingOuterLow",
}

local turbine = piece "Turbine"
local innerHull = piece "InnerHull"
local outerhull = {
	piece "OuterHull",
	piece "OuterHullNE",
	piece "OuterHullNW",
	piece "OuterHullSE",
}

local lightBeamEnabled = false

local currentWeapon
local weapons = {}

local independencePiece = piece "independence"
local independenceWeapon

local SIG_INDEPENDENCE = 1
local function Independence()
	SetSignalMask(SIG_INDEPENDENCE)
	while true do
		EmitSfx(independencePiece, SFX.FIRE_WEAPON + independenceWeapon - 1)
		Sleep(33)
	end
end

function script.StartIndependence()
	Signal(SIG_INDEPENDENCE)
	Spring.SetUnitRulesParam(unitID, "beam_enabled", -1)
	lightBeamEnabled = -1
	StartThread(Independence)
end

function script.StopIndependence()
	Spring.SetUnitRulesParam(unitID, "beam_enabled", 0)
	lightBeamEnabled = 0
	Signal(SIG_INDEPENDENCE)
end

function script.SetCurrentWeapon(weaponName)
	currentWeapon = weaponName
end

function script.SetBeamEnabled(newEnabled)
	Spring.SetUnitRulesParam(unitID, "beam_enabled", newEnabled and 1 or 0)
	lightBeamEnabled = newEnabled
end

local function GetGunHeading(i)
	local ox, oy, oz = Spring.GetUnitPiecePosition(unitID, outerhull[i])
	local bx, by, bz = Spring.GetUnitPiecePosition(unitID, gunBase[i])
	return math.atan2(bx - ox, bz - oz)
end

local function AimGun(i, tx, ty, tz)
	local b = gunBase[i]
	local g = gun[i]
	local gh = GetGunHeading(i) - gunHeading[i]

	local px, py, pz = Spring.GetUnitPiecePosDir(unitID, b)
	local dx, dy, dz = tx - px, ty - py, tz - pz
	local dist = math.sqrt(dx * dx + dz * dz)
	local pitch = math.atan2(dy, dist)
	local heading = math.atan2(dx, dz) + gh


	Turn(g, x_axis, -pitch, 0)
	Turn(b, z_axis, heading, 0)
	--Turn(p, y_axis, 0, 0)
end

function script.AimWeapons(tx, ty, tz)
	for i = 1, #gun do
		if not gunHeading[i] then
			gunHeading[i] = GetGunHeading(i)
		end
		AimGun(i, tx, ty, tz)
	end
end


function script.Create()
	local weaponNames = GG.Tech.GetWeapons()
	for _, name in pairs(weaponNames) do
		weapons[name] = GG.Tech.GetTech(name).weapon
	end
	for i=1, #railing do
		Spin(railing[i],z_axis, i%2*2-1 *5)
	end

	for i=1, #outerhull do
		Spin(outerhull[i],z_axis, 1)
	end

	Spin(innerHull,z_axis, -2)

	Spin(turbine, z_axis, 4);

	Turn(independencePiece, x_axis, math.pi, 0)

	for i = 1,#UnitDef.weapons do
		if WeaponDefs[UnitDef.weapons[i].weaponDef].name:find("independence") then
			independenceWeapon = i
			break
		end
	end
end


local lastGun = 4

function script.QueryWeapon(num)
	if currentWeapon == "pulseLaser" then
		return lastGun
	end
	return muzzle[num % 4 + 1]
end

function script.AimFromWeapon(num)
	if currentWeapon == "pulseLaser" then
		return lastGun
	end
	return gun[num % 4 + 1]
end

function script.AimWeapon(num, heading, pitch)
	if not currentWeapon then
		return false
	end
	return WeaponDefs[UnitDef.weapons[num].weaponDef].name:find(currentWeapon:lower())
end

function script.Shot(num)
	if currentWeapon == "pulseLaser" then
		lastGun = lastGun % 4 + 1
	end
end

function script.Killed(recentDamage, maxHealth)
	return 0
end
