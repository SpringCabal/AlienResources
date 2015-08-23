-- DISABLED
function widget:GetInfo()
	return {
		name    = 'Ability UI',
		desc    = '',
		author  = 'gajop',
		date    = 'August, 2015',
		license = 'GPL',
        layer = 60,
		enabled = true,
	}
end

local ufoID
local ufoDefID = UnitDefNames["ufo"].id

local disabledFontColor = { 1, 1, 1, .4}
local enabledFontColor = { 0, 0.8, 1, 1}

local disabledImage = "UI/tab-disabled.png"
local enabledImage = "UI/tab+circle.png"

local images, progressBars = {}, {}

local Chili, screen0
local weapons, abilities

function widget:Initialize()
    Chili = WG.Chili
    screen0 = Chili.Screen0
    vsx, vsy = Spring.GetViewGeometry()
    for _, unitID in pairs(Spring.GetAllUnits()) do
        self:UnitCreated(unitID, Spring.GetUnitDefID(unitID), Spring.GetUnitTeam(unitID))
    end
	weapons = WG.Tech.GetWeapons()
	abilities = WG.Tech.GetAbilities()
	SpawnUI()
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitDefID == ufoDefID then
		ufoID = unitID
	end
end

function SetAbilityEnabled(name, enabled)
	local imgAbility = images[name]
	local color = disabledFontColor
	local image = disabledImage
	if enabled then
		color = enabledFontColor
		image = enabledImage
	end
	imgAbility.file = image
	imgAbility.children[1].font.color = color
	local text = imgAbility.children[1].caption
 	imgAbility:RemoveChild(imgAbility.children[1])
 	imgAbility:AddChild(Chili.Label:New {
			caption = text,
			x = 16,
			y = 22,
			font = {
				color = color,
				size = 16,
			}
		}
	)
end

function MakeImage(name, text, i, enabled)
	local color = disabledFontColor
	local image = disabledImage
	if enabled then
		color = enabledFontColor
		image = enabledImage
	end
	local imgAbility = Chili.Image:New {
		file = image,
		x = 0,
		y = 400 + i * 50,
		width = 200,
		parent = screen0,
		children = {
			Chili.Label:New {
				caption = text,
				x = 16,
				y = 22,
				font = {
					color = color,
					size = 16,
				}
			},
		}
	}
	images[name] = imgAbility
end

function MakeAbility(name, text, i, enabled)
	local pbAbility = Chili.Progressbar:New {
		x = 0,
		bottom = 200 - i * 50,
		value = 0,
		width = 150,
		height = 30,
		parent = screen0,
	}
	local color = disabledFontColor
	if enabled or true then
		color = enabledFontColor
	end
	local lblAbility Chili.Label:New {
		caption = text,
		x = 10,
		bottom = 200 - i * 50 + 33,
		font = {
			color = color,
			shadow = true,
			size = 16,
		},
		parent = screen0,
	}
	progressBars[name] = { pbAbility, lblAbility }
end

function widget:Update()
	SpawnUI()
	UpdateUI()
end

function SpawnUI()
	for i, name in pairs(weapons) do
		local tech = WG.Tech.GetTech(name)
		if not tech.locked and images[name] == nil then
			MakeImage(name, "[".. i .. "] " .. tech.title, i - 1)
		end
	end
	for i, name in pairs(abilities) do
		local tech = WG.Tech.GetTech(name)
		if not tech.locked and progressBars[name] == nil then
			MakeAbility(name, "[".. tech.key:upper() .. "] " .. tech.title, i - 1)
		end
	end
end

function UpdateUI()
	for _, abilityName in pairs(abilities) do
		local tech = WG.Tech.GetTech(abilityName)
		local dur = Spring.GetGameRulesParam(abilityName .. "Duration") or 0
		local cd = Spring.GetGameRulesParam(abilityName .. "CD") or 0
		
		local comps = progressBars[abilityName]
		if comps ~= nil then
			local pbAbility = comps[1]
			if dur ~= 0 then -- ACTIVE
				pbAbility:SetColor({1, 1, 1, .9})
				pbAbility:SetValue(100 * dur / tech.ability.duration)
				pbAbility:SetCaption("Active [" .. math.ceil(dur / 30) .. "s]")
			elseif cd ~= 0 then -- COOLDOWN
				pbAbility:SetColor({0, 0.6, 0.8, .9})
				pbAbility:SetValue(100 * (tech.ability.cooldown - cd) / tech.ability.cooldown)
				pbAbility:SetCaption("CD [" .. math.ceil(cd / 30) .. "s]")
			else -- READY
				local v = 0.8 + 0.2 * math.sin(os.clock() * 10) / 3.14
				pbAbility:SetColor({v, v, v, .9})
				pbAbility:SetValue(100)
				pbAbility:SetCaption("=READY=")
			end
		end
	end
end

WG.UI = {}

function WG.UI.SetAbilityEnabled(name, enabled)
	SetAbilityEnabled(name, enabled)
end