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
	VFS.Include("LuaRules/Utilities/tech.lua")
	WG.Tech = Tech
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
    local btnClose = Chili.Button:New {
        width = 100,
        height = 40,
        right = 10,
        bottom = 10,
        caption = "Close",
        OnClick = { function() 
			Spring.PlaySoundFile("sounds/click.wav", 1, "ui")
            window:Dispose()
            window = nil
        end },
    }
    local lblTitle = Chili.Label:New {
        x = 10,
        y = 10,
        fontsize = 30,
        caption = "Upgrade ship",
    }

    local children = { btnClose, lblTitle }
    x, y = 10, 70
    for name, tech in pairs(Tech.GetTechTree()) do
        local btnTech, imgTech, lblTech
        local enabled = false
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
		local lvlCaption
		if tech.level == 5 then
			lvlCaption = "\255\0\255\0" .. tech.level .. "/5\b"
		elseif tech.level > 0 then
			lvlCaption = "\255\0\255\0" .. tech.level .. "\b/5"
		else
			lvlCaption = tech.level .. "/5"
		end
        lblTech = Chili.Label:New {
            right = 3,
            bottom = 3,
            caption = lvlCaption,
            align = "right",
        }
        btnTech = Chili.Button:New {
            caption = "",
            x = x + (tech.x or 60),
            y = y + (tech.y or 60),
            width = 60,
            height = 60,
            tooltip = Tech.GetTechTooltip(name),
            padding = {0, 0, 0, 0},
            itemPadding = {0, 0, 0, 0},
            backgroundColor = {0.5, 0.5, 0.5, 1},
            --focusColor      = {0.4, 0.4, 0.4, 1},
            children = {lblTech, imgTech},
            OnClick = { function(ctrl, x, y, button)
                if button == 1 then
                    UpgradeTech(name)
                end
            end},
        }
        techMapping[name] = { btnTech = btnTech, imgTech = imgTech, lblTech = lblTech }
        table.insert(children, btnTech)
    end
    window = Chili.Window:New {
        parent = screen0,
        x = 200,
        width = 300,
        bottom = 100,
        height = 700,
        draggable = false,
        resizable = false,
        children = children,
    }
end

function UpgradeTech(name)
	local upgraded, enabledTechs = Tech.UpgradeTech(name)
	if not upgraded then
		return false
	end
	local tech = Tech.GetTech(name)
	Spring.PlaySoundFile("sounds/click.wav", 1, "ui")
	if tech.level < 5 then
		techMapping[name].lblTech:SetCaption("\255\0\255\0" .. tech.level .. "\b/5")
	else
		techMapping[name].lblTech:SetCaption("\255\0\255\0" .. tech.level .. "/5\b")
	end
	local tooltip, value = Tech.GetTechTooltip(name)
	techMapping[name].btnTech.tooltip = tooltip

	Spring.SendLuaRulesMsg('upgrade|' .. name .. '|' .. tech.level .. '|' .. value)
    -- enable techs that depend on it
	for _, enabledTechName in pairs(enabledTechs) do
		local comps = techMapping[enabledTechName]
    	comps.imgTech.file = Tech.GetTech(enabledTechName).iconPath
    end
end