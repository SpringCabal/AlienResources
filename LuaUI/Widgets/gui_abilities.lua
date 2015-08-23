-- DISABLED
function widget:GetInfo()
	return {
		name    = 'Ability UI',
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

local disabledFontColor = { 1, 1, 1, .4}
local enabledFontColor = { 0, 0.8, 1, 1}

local disabledImage = "UI/tab-disabled.png"
local enabledImage = "UI/tab+circle.png"

local images = {}

local Chili, screen0

function widget:Initialize()
    Chili = WG.Chili
    screen0 = Chili.Screen0
    vsx, vsy = Spring.GetViewGeometry()
    for _, unitID in pairs(Spring.GetAllUnits()) do
        self:UnitCreated(unitID, Spring.GetUnitDefID(unitID), Spring.GetUnitTeam(unitID))
    end
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
			y = 0,
			font = {
				color = color,
				outline = true,
				autoOutlineColor = true,
				shadow = false,
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
				y = 0,
				font = {
					color = color,
					outline = true,
					autoOutlineColor = true,
					shadow = false,
					size = 16,
				}
			},
		}
	}
	images[name] = imgAbility
end

function SpawnUI()
	MakeImage("pulse", "[1] Pulse laser", 0)
	MakeImage("gravityBeam", "[2] Gravity beam", 1)
	MakeImage("independenceDayGun", "[3] Cleanse", 2)
end

WG.UI = {}

function WG.UI.SetAbilityEnabled(name, enabled)
	SetAbilityEnabled(name, enabled)
end