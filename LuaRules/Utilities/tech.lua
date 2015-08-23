-- File shared between LuaUI and LuaRules

-- also contains some GUI data that's not needed (x, y pos, etc.)
local techTree = {
	armor = {
		desc = "Armor upgrade (+20% armor)",
		tier = 1,
		x = 0,
		y = 0,
		iconPath = "LuaUI/Images/armour.png",
		iconDisabledPath = "LuaUI/Images/armour_off.png",
	},
	pulseLaser = {
		desc = "Pulse laser (+10% damage)",
		title = "Pulse laser",
		tier = 1,
		x = 0,
		y = 60,
		iconPath = "LuaUI/Images/laser.png",
		iconDisabledPath = "LuaUI/Images/laser_off.png",
		weapon = {
		}
	},
	blackHoleGun = {
		desc = "Black hole (+10% stun duration)",
		title = "Black hole",
		tier = 2,
		x = 80,
		y = 60,
		depends = { "pulseLaser" },
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",

	},
	incendiaryBeamLaser = {
		desc = "Incendiary beam laser (+15% fire duration)",
		title = "Napalm",
		tier = 1,
		x = 0,
		y = 120,
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
	},
	gravityBeam = {
		desc = "Gravity beam (+20% strength)",
		title = "Gravity beam",
		tier = 2,
		x = 80,
		y = 120,
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
		depends = { "incendiaryBeamLaser" },
		weapon = {
		},
	},
	empBomb = {
		desc = "EMP Bomb (+10% area of effect)",
		title = "EMP bomb",
		tier = 1,
		x = 0,
		y = 180,
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
	},
	missiles = {
		desc = "Missiles (+10% amount)",
		title = "Missiles",
		tier = 2,
		x = 80,
		y = 180,
		depends = { "empBomb" },
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
	},
	shield = {
		desc = "Shield (+25% strength)",
		title = "Shield",
		tier = 1,
		x = 0,
		y = 270,
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
	},
	antiMissilePointDefense = {
		desc = "Anti missile point defense (+20% recharge rate)",
		tier = 2,
		x = 80,
		y = 240,
		depends = { "shield" },
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
	},
	carrierDrones = {
		desc = "Carrier drones (+1 drone)",
		title = "Drones",
		tier = 2,
		x = 80,
		y = 300,
		depends = { "shield" },
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
	},
	haste = {
		desc = "Haste (+5% speed)",
		title = "Haste",
		tier = 1,
		x = 0,
		y = 390,
		iconPath = "LuaUI/Images/haste.png",
		iconDisabledPath = "LuaUI/Images/haste_off.png",
	},
	cloak = {
		desc = "Cloak (+15% duration)",
		title = "Cloak",
		tier = 2,
		x = 80,
		y = 360,
		depends = { "haste" },
		iconPath = "LuaUI/Images/cloak.png",
		iconDisabledPath = "LuaUI/Images/cloak_off.png",
	},
	teleport = {
		desc = "Teleport (+10% distance)",
		title = "Teleport",
		tier = 2,
		x = 80,
		y = 420,
		depends = { "haste" },
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
	},
	independenceDayGun = {
		desc = "Independence day gun (+20% damage)",
		title = "God gun",
		tier = 3,
		x = 160,
		y = 240,
		depends = { "blackHoleGun", "incendiaryBeamLaser", "missiles", "antiMissilePointDefense", "carrierDrones", "cloak", "teleport" },
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
		weapon = {
		}
	},
}

Tech = {
	weapons = {},
	initialized = false,
}

function Initialize()
	if Tech.initialized then
		return
	end
	Tech.initialized = true
	for name, tech in pairs(techTree) do
		tech.name = name
		tech.level = 0
		if tech.tier == 1 then
			tech.enabled = true
		end
		if not tech.depends then
			tech.depends = {}
		end
		if tech.weapon then
			table.insert(Tech.weapons, name)
		end
	end
end

if not Tech.initialized then
	Initialize()
end

-- API

function Tech.GetTechTree()
	return techTree
end

-- returns the tooltip and the modified value
function Tech.GetTechTooltip(name)
	local tech = techTree[name]
	local tooltip = techTree[name].desc
	local x1, x2 = tooltip:find("(%d+)")
	local val = tonumber(tooltip:sub(x1, x2))
	if tech.level > 0 then
		tooltip = tooltip:sub(1, x1-2) .. "\255\0\255\0+" .. (val*tech.level) ..  tooltip:sub(x2+1, x2+1) .. "\b" .. tooltip:sub(x2+2)
	end
	return tooltip, val*tech.level
end

function Tech.UpgradeTech(name)
	local tech = techTree[name]
	if not tech.enabled or tech.level >= 5 then
		return false
	end
	tech.level = tech.level + 1
	local enabledTechs = {}
	-- check new techs to enable
	for name, tech in pairs(techTree) do
		if not tech.enabled then
			local enabled = true
			for _, depend in pairs(tech.depends) do
				if techTree[depend].level == 0 then
					enabled = false
					break
				end
			end
			if enabled then
				tech.enabled = true
				table.insert(enabledTechs, name)
			end
		end
	end
	return true, enabledTechs
end

function Tech.GetTech(name)
	return techTree[name]
end

function Tech.GetWeapons()
	return Tech.weapons
end