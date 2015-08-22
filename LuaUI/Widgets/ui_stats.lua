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
    lblBiomass:SetCaption("\255\80\215\80[Icon]Biomass: " .. biomass .. "\b")
end

local function UpdateResearch()
    local research = Spring.GetGameRulesParam("research")
    lblResearch:SetCaption("\255\150\150\255[Icon]Research: " .. research .. "\b")
end

local function UpdateMetal()
    local metal = Spring.GetGameRulesParam("metal")
    lblMetal:SetCaption("\255\150\150\150[Icon]Metal: " .. metal .. "\b")
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
            size = 20,
        },
		caption = "",
    }
    lblResearch = Chili.Label:New {
        right = 200,
        width = 100,
        y = 10,
        height = 50,
		align = "left",
        parent = screen0,
        font = {
            size = 20,
        },
		caption = "",
    }
	
    lblMetal = Chili.Label:New {
        right = 400,
        width = 100,
        y = 10,
        height = 50,
        parent = screen0,
        font = {
            size = 20,
        },
		caption = "",
    }
    UpdateBiomass()
    UpdateResearch()
	UpdateMetal()
end