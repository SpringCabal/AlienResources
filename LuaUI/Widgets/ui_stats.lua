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
-- local lblMetal

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Updating

local function UpdateBiomass()
    local biomass = Spring.GetGameRulesParam("biomass")
    lblBiomass:SetCaption("\255\80\215\80" .. biomass .. "\b")
end

local function UpdateResearch()
    local research = Spring.GetGameRulesParam("research")
    lblResearch:SetCaption("\255\2\180\250" .. research .. "\b")
end
--[[
local function UpdateMetal()
    local metal = Spring.GetGameRulesParam("metal")
    lblMetal:SetCaption("\255\150\150\150[Icon]Metal: " .. metal .. "\b")
end]]

function widget:GameFrame()
    UpdateBiomass()
    UpdateResearch()
-- 	UpdateMetal()
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
	
	local imBiomass = Chili.Image:New {
		file = "UI/biomass.png",
		y = 0,
		right = 10,
		parent = screen0,
		width = 50,
		height = 50,
	}
    lblBiomass = Chili.Label:New {
        right = 60,
        width = 100,
        y = 10,
        height = 40,
        parent = screen0,
        font = {
            size = 20,
        },
		caption = "",
    }
	local imResearch = Chili.Image:New {
		file = "UI/research.png",
		y = 0,
		right = 150,
		parent = screen0,
		width = 50,
		height = 50,
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
	
--     lblMetal = Chili.Label:New {
--         right = 400,
--         width = 100,
--         y = 10,
--         height = 50,
--         parent = screen0,
--         font = {
--             size = 20,
--         },
-- 		caption = "",
--     }
    UpdateBiomass()
    UpdateResearch()
	--UpdateMetal()
end