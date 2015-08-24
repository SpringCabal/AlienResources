-- File shared between LuaUI and LuaRules

-- also contains some GUI data that's not needed (x, y pos, etc.)
local techTree = {
	armor = {
		desc = "Armor upgrade (+20% armor)",
		maxLevel = 10,
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
		weapon = {},
	},
	incendiaryBeamLaser = {
		desc = "Incendiary beam laser (+15% fire duration)",
		title = "Napalm",
		tier = 1,
		x = 0,
		y = 120,
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
		weapon = {},
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
		weapon = {},
	},
	empBomb = {
		desc = "EMP Bomb (+10% area of effect)",
		title = "EMP bomb",
		tier = 1,
		x = 0,
		y = 180,
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
		weapon = {},
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
		desc = "Shield (+50% recharge speed)",
		title = "Shield",
		tier = 1,
		x = 0,
		y = 270,
		iconPath = "LuaUI/Images/shield.png",
		iconDisabledPath = "LuaUI/Images/shield_off.png",
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
		desc = "Haste (+30% speed)",
		title = "Haste",
		tier = 1,
		x = 0,
		y = 390,
		iconPath = "LuaUI/Images/haste.png",
		iconDisabledPath = "LuaUI/Images/haste_off.png",
		ability = {
			duration = 5,
			cooldown = 20,
		},
		key = "q",
	},
	cloak = {
		desc = "Cloak (-15% cooldown)",
		title = "Cloak",
		tier = 2,
		x = 80,
		y = 360,
		depends = { "haste" },
		iconPath = "LuaUI/Images/cloak.png",
		iconDisabledPath = "LuaUI/Images/cloak_off.png",
		ability = {
			duration = 5,
			cooldown = 60,
		},
		key = "c",
	},
	teleport = {
		desc = "Teleport (+30% distance)",
		title = "Teleport",
		tier = 2,
		x = 80,
		y = 420,
		depends = { "haste" },
		iconPath = "LuaUI/Images/heart.png",
		iconDisabledPath = "LuaUI/Images/heart_off.png",
		ability = {
			duration = 0,
			cooldown = 15,
		},
		key = "e",
	},
	independenceDayGun = {
		desc = "Independence day gun (+100% duration)",
		title = "God gun",
		maxLevel = 1,
		tier = 3,
		x = 160,
		y = 240,
		depends = { "blackHoleGun", "gravityBeam", "missiles", "antiMissilePointDefense", "carrierDrones", "cloak", "teleport" },
		iconPath = "LuaUI/Images/cleanse.png",
		iconDisabledPath = "LuaUI/Images/cleanse_off.png",
		key = "space",
		ability = {
			duration = 10,
			cooldown = 60,
		}
	},
}

Tech = {
	weapons = {},
	abilities = {}, -- non targetable/selectable weapons
	initialized = false,
	_converted = false,
	-- global configs
	maxLevel = 5, -- maximum level per tech if not defined
}

function Initialize()
	if Tech.initialized then
		return
	end
	Tech.initialized = true
	for name, tech in pairs(techTree) do
		tech.name = name
		tech.level = 0
		-- unlock armor
		if not tech.maxLevel then
			tech.maxLevel = Tech.maxLevel
		end
		if tech.name ~= "armor" then
			tech.locked = true
		else
			tech.locked = false
		end
		if tech.tier == 1 then
			tech.enabled = true
		else
			tech.enabled = false
		end
		if not tech.depends then
			tech.depends = {}
		end
		if tech.weapon then
			table.insert(Tech.weapons, name)
		end
		if tech.ability and Tech._converted == false then
			-- convert to frames
			tech.ability.duration = tech.ability.duration * 30
			tech.ability.cooldown = tech.ability.cooldown * 30
			table.insert(Tech.abilities, name)
		end
	end
	Tech._converted = true
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
	if tech.locked then
		local resources = Tech.GetUnlockResources(name)
		tooltip = tooltip .. "\n\255\2\180\250Unlock: " .. resources.research .. "\b"
	elseif tech.level ~= tech.maxLevel then
		local resources = Tech.GetUpgradeResources(name)
		tooltip = tooltip .. "\n\255\80\215\80Upgrade: " .. resources.biomass .. "\b"
	end
	return tooltip, val*tech.level
end

function Tech.UpgradeTech(name)
	local tech = techTree[name]
	if not Tech.CanUpgrade(name) then
		return false
	end	
	local resources = Tech.GetUpgradeResources(name)
	if Script.GetName() == "LuaRules" and Script.GetSynced() then
		for resName, value in pairs(resources) do
			local current = Spring.GetGameRulesParam(resName)
			Spring.SetGameRulesParam(resName, current - value)
		end
	end
	
	tech.level = tech.level + 1
	return true
end

function Tech.UnlockTech(name)
	if not Tech.CanUnlock(name) then
		return false
	end
	local tech = techTree[name]
	
	local resources = Tech.GetUnlockResources(name)
	if Script.GetName() == "LuaRules" and Script.GetSynced() then
		for resName, value in pairs(resources) do
			local current = Spring.GetGameRulesParam(resName)
			Spring.SetGameRulesParam(resName, current - value)
		end
	end
	
	tech.locked = false
	
	local enabledTechs = {}
	-- check new techs to enable
	for name, tech in pairs(techTree) do
		if not tech.enabled then
			local enabled = true
			for _, depend in pairs(tech.depends) do
				if not techTree[depend].enabled or techTree[depend].locked then
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

function Tech.GetAbilities()
	return Tech.abilities
end

function Tech.ResetTechTree()
	Tech.initialized = true
	Tech.weapons = {}
	Tech.abilities = {}
	Initialize()
end

function Tech.GetUpgradeResources(name)
	local tech = techTree[name]
	local resource = (2 * tech.tier - 1) * ((tech.level+1) * 500)
	return { biomass = resource }
end

function Tech.GetUnlockResources(name)
	local tech = techTree[name]
	local resource = (2 * tech.tier - 1) * 1000
	return { research = resource }
end

function Tech.CanUpgrade(name)
	local tech = techTree[name] 
	if tech.locked or not tech.enabled or tech.level >= tech.maxLevel then
		return false
	end
	local resources = Tech.GetUpgradeResources(name)
	for resName, value in pairs(resources) do
		if value > (Spring.GetGameRulesParam(resName) or 0) then
			return false
		end
	end
	return true
end

function Tech.CanUnlock(name)
	local tech = techTree[name]
	if not tech.locked or not tech.enabled then
		return false
	end
	local resources = Tech.GetUnlockResources(name)
	for resName, value in pairs(resources) do
		if value > (Spring.GetGameRulesParam(resName) or 0) then
			return false
		end
	end
	return true
end