function widget:GetInfo()
	return {
		name    = 'Upgrade widget for spaceships',
		desc    = '',
		author  = 'gajop',
		date    = 'August, 2015',
		license = 'GPL',
        layer = 0,
		enabled = true,
	}
end

local ufoID
local ufoDefID = UnitDefNames["ufo"].id

local techTree = {
    armor = {
        name = "Armor upgrade (+20% armor)",
        tier = 1,
        x = 0,
        y = 0,
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    pulseLaser = {
        name = "Pulse laser (+10% damage)",
        tier = 1,
        x = 0,
        y = 60,
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    blackHoleGun = {
        name = "Black hole (+10% stun duration)",
        tier = 2,
        x = 80,
        y = 60,
        depends = { "pulseLaser" },
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    incendiaryBeamLaser = {
        name = "Incendiary beam laser (+15% fire duration)",
        tier = 1,
        x = 0,
        y = 120,
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    gravityBeam = {
        name = "Gravity beam (+20% strength)",
        tier = 2,
        x = 80,
        y = 120,
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
        depends = { "incendiaryBeamLaser" },
    },
    empBomb = {
        name = "EMP Bomb (+10% area of effect)",
        tier = 1,
        x = 0,
        y = 180,
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    missiles = {
        name = "Missiles (+10% amount)",
        tier = 2,
        x = 80,
        y = 180,
        depends = { "empBomb" },
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    shield = {
        name = "Shield (+25% strength)",
        tier = 1,
        x = 0,
        y = 270,
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    antiMissilePointDefense = {
        name = "Anti missile point defense (+20% recharge rate)",
        tier = 2,
        x = 80,
        y = 240,
        depends = { "shield" },
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    carrierDrones = {
        name = "Carrier drones (+1 drone)",
        tier = 2,
        x = 80,
        y = 300,
        depends = { "shield" },
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    haste = {
        name = "Haste (+5% speed)",
        tier = 1,
        x = 0,
        y = 390,
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    cloak = {
        name = "Cloak (+15% duration)",
        tier = 2,
        x = 80,
        y = 360,
        depends = { "haste" },
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    teleport = {
        name = "Teleport (+10% distance)",
        tier = 2,
        x = 80,
        y = 420,
        depends = { "haste" },
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
    independenceDayGun = {
        name = "Independence day gun (+20% damage)",
        tier = 3,
        x = 160,
        y = 240,
        depends = { "blackHoleGun", "incendiaryBeamLaser", "missiles", "antiMissilePointDefense", "carrierDrones", "cloak", "teleport" },
        iconPath = "LuaUI/Images/heart.png",
        iconDisabledPath = "LuaUI/Images/heart_off.png",
    },
}

include('keysym.h.lua')
local UPGRADE_KEY = KEYSYMS.T

local vsx, vsy
local landTextColor = {1, 1, 1, 1}
local landText = "LAND"
local landTextSize = 30

local Chili, screen0

function widget:Initialize()
    Chili = WG.Chili
    screen0 = Chili.Screen0
    vsx, vsy = Spring.GetViewGeometry()
    for _, unitID in pairs(Spring.GetAllUnits()) do
        self:UnitCreated(unitID, Spring.GetUnitDefID(unitID), Spring.GetUnitTeam(unitID))
    end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitDefID == ufoDefID then
		ufoID = unitID
	end
end

local window
function widget:KeyPress(key, mods, isRepeat)
    if ufoID and key == UPGRADE_KEY then
        if not window then
            SpawnUpgradeUI()
        else
            if window then
                window:Dispose()
                window = nil
            end
        end
    end
end

local techMapping = {}
function SpawnUpgradeUI()
--     local _, maxHealth = Spring.GetUnitHealth(ufoID)
--     local maxHealthOrig = maxHealth

    local btnClose = Chili.Button:New {
        width = 100,
        height = 40,
        right = 10,
        bottom = 10,
        caption = "Close",
        OnClick = { function() 
            window:Dispose()
            window = nil
        end },
    }
--     local btnApply = Chili.Button:New {
--         width = 100,
--         height = 40,
--         x = 10,
--         bottom = 10,
--         caption = "Upgrade",
--         OnClick = { function() 
--             Spring.SendLuaRulesMsg('upgrade|maxhealth|' .. maxHealth)
--             maxHealthOrig = maxHealth
--         end },
--     }
    local lblTitle = Chili.Label:New {
        x = 10,
        y = 10,
        fontsize = 30,
        caption = "Upgrade ship",
    }
--     local lblHealthTitle = Chili.Label:New {
--         x = 10,
--         y = 70,
--         caption = "Health",
--     }
--     local lblHealthValue = Chili.Label:New {
--         x = 140,
--         y = 70,
--         caption = tostring(maxHealth),
--     }
--     local btnIncreaseHealth = Chili.Button:New {
--         x = 180,
--         y = 60,
--         width = 50,
--         caption = "+",
--         OnClick = { function()
--             maxHealth =  maxHealth + 100
--             lblHealthValue:SetCaption(tostring(maxHealth))
--         end},
--     }
--     local btnDecreaseHealth = Chili.Button:New {
--         x = 180,
--         y = 80,
--         width = 50,
--         caption = "-",
--         OnClick = { function()
--             if maxHealth <= maxHealthOrig then
--                 return
--             end
--             maxHealth = maxHealth - 100
--             lblHealthValue:SetCaption(tostring(maxHealth))
--         end},
--     }
    local children = { btnClose, lblTitle }
    x, y = 10, 70
    for name, tech in pairs(techTree) do
        if tech.level == nil then
            tech.level = 0
        end
    
        local btnTech, imgTech, lblTech
        local enabled = false
        if tech.tier == 1 then
            tech.enabled = true
        end
        local file
        if tech.enabled then
            file = tech.iconPath
        else
            file = tech.iconDisabledPath
        end
        imgTech = Chili.Image:New {
            margin = {0, 0, 0, 0},
            x = 7,
            y = 7,
            width = 45,
            height = 45,
            file = file,
        }
        lblTech = Chili.Label:New {
            right = 3,
            bottom = 3,
            caption = tech.level .. "/5",
            align = "right",
        }
        btnTech = Chili.Button:New {
            caption = "",
            x = x + (tech.x or 60),
            y = y + (tech.y or 60),
            width = 60,
            height = 60,
            tooltip = GetBtnTooltip(tech, name),
            padding = {0, 0, 0, 0},
            itemPadding = {0, 0, 0, 0},
            backgroundColor = {0.5, 0.5, 0.5, 1},
            --focusColor      = {0.4, 0.4, 0.4, 1},
            children = {imgTech, lblTech},
            OnClick = { function(ctrl, x, y, button)
                if button == 1 then
                    UpgradeTech(tech, name)
                end
            end},
        }
        Spring.Echo(name, tech.tier)
        techMapping[name] = { btnTech = btnTech, imgTech = imgTech, lblTech = lblTech }
        table.insert(children, btnTech)
    end
    window = Chili.Window:New {
        parent = screen0,
        x = 100,
        width = 300,
        bottom = 100,
        height = 700,
        draggable = false,
        resizable = false,
        children = children,
    }
end

function GetBtnTooltip(tech, key)
    local tooltip = techTree[key].name
    local x1, x2 = tooltip:find("(%d+)")
    local val = tonumber(tooltip:sub(x1, x2))
    if tech.level > 0 then
        tooltip = tooltip:sub(1, x1-2) .. "\255\0\255\0+" .. (val*tech.level) ..  tooltip:sub(x2+1, x2+1) .. "\b" .. tooltip:sub(x2+2)
    end
    return tooltip, val*tech.level
end

function UpgradeTech(tech, key)
    if not tech.enabled then
        return false
    end
    tech.level = math.min(5, tech.level + 1)
    techMapping[key].lblTech:SetCaption(tech.level .. "/5")
	local tooltip, value = GetBtnTooltip(tech, key)
    techMapping[key].btnTech.tooltip = tooltip

	Spring.SendLuaRulesMsg('upgrade|' .. key .. '|' .. tech.level .. '|' .. value)
    -- enable techs that depend on it
    for name, comps in pairs(techMapping) do
        if techTree[name].depends then
            local enabled = true
            for _, depend in pairs(techTree[name].depends) do
                if techTree[depend].level == 0 then
                    enabled = false
                    break
                end
            end
            if enabled then
                comps.imgTech.file = techTree[key].iconPath
                techTree[name].enabled = true
            end
        end
    end
end