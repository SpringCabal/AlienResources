function widget:GetInfo()
	return {
		name      = 'Stats',
		desc      = 'Display game information',
		author    = 'gajop',
		date      = 'August 2015',
		license   = 'GNU GPL v2',
		layer     = 0,
		enabled   = true,
		handler   = true,
	}
end
local lblBiomass
local lblResearch
local lblMetal

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Updating

local function UpdateBiomass()
    local biomass = Spring.GetGameRulesParam("biomass")
    lblBiomass:SetCaption("\255\30\144\255Biomass: " .. biomass .. "\b")
end

local function UpdateResearch()
    local research = Spring.GetGameRulesParam("research")
    lblResearch:SetCaption("\255\255\165\0Research: " .. research .. "\b")
end

local function UpdateMetal()
    local metal = Spring.GetGameRulesParam("metal")
    lblMetal:SetCaption("\255\255\255\0Metal: " .. metal .. "\b")
end

function widget:GameFrame()
    UpdateBiomass()
    UpdateResearch()
	UpdateMetal()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Display Managment

function widget:Initialize()
	if (not WG.Chili) then
		widgetHandler:RemoveWidget()
		return
	end

	Chili = WG.Chili
	screen0 = Chili.Screen0
	
	local screenWidth, screenHeight = Spring.GetWindowGeometry()
	
    lblBiomass = Chili.Label:New {
        right = 10,
        width = 100,
        y = 10,
        height = 40,
        parent = screen0,
        font = {
            size = 24,
        },
		caption = "",
    }
    lblResearch = Chili.Label:New {
        x = screenWidth/2 - 60,
        width = 100,
        y = 10,
        height = 50,
		align = "left",
        parent = screen0,
        font = {
            size = 32,
        },
		caption = "",
    }
	
    lblMetal = Chili.Label:New {
        right = 10,
        width = 100,
        bottom = 45,
        height = 50,
        parent = screen0,
        font = {
            size = 24,
        },
		caption = "",
    }
    UpdateBiomass()
    UpdateResearch()
	UpdateMetal()
end