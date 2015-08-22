function widget:GetInfo()
	return {
		name    = 'Spaceship land and upgrade widget',
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
local canLand

include('keysym.h.lua')
local SPACE = KEYSYMS.SPACE

local vsx, vsy
local landTextColor = {1, 1, 1, 1}
local landText = "LAND"
local landTextSize = 30

local Chili, screen0

function widget:Initialize()
    Chili = WG.Chili
    screen0 = Chili.Screen0
    vsx, vsy = Spring.GetViewGeometry()
end

function widget:DrawScreen()
    if not canLand then
        return
    end
    gl.PushMatrix()
        gl.Color(landTextColor[1], landTextColor[2], landTextColor[3], landTextColor[4])
        local fw = gl.GetTextWidth(landText) * landTextSize
        gl.Text(landText, (vsx - fw) / 2,  vsy / 2 - 400, landTextSize)
    gl.PopMatrix()
end

function widget:Update()
    if ufoID then
        canLand = not Spring.GetUnitStates(ufoID).autoland
    end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitDefID == ufoDefID then
		ufoID = unitID
 		Spring.GiveOrderToUnit(unitID, CMD.IDLEMODE, {0}, {}) --no land
	end
end

function widget:KeyPress(key, mods, isRepeat)
    if ufoID and key == SPACE then
        local state = Spring.GetUnitStates(ufoID).autoland and 1 or 0
        if state == 0 then
            Spring.GiveOrderToUnit(ufoID, CMD.IDLEMODE, {1}, {})
            SpawnUpgradeUI()
        end
    end
end

function SpawnUpgradeUI()
    local window
    local _, maxHealth = Spring.GetUnitHealth(ufoID)
    local maxHealthOrig = maxHealth

    local btnClose = Chili.Button:New {
        width = 100,
        height = 40,
        right = 10,
        bottom = 10,
        caption = "Close",
        OnClick = { function() 
            window:Dispose()
            Spring.GiveOrderToUnit(ufoID, CMD.IDLEMODE, {0}, {})
        end },
    }
    local btnApply = Chili.Button:New {
        width = 100,
        height = 40,
        x = 10,
        bottom = 10,
        caption = "Apply",
        OnClick = { function() 
            Spring.SendLuaRulesMsg('upgrade|maxhealth|' .. maxHealth)
            maxHealthOrig = maxHealth
        end },
    }
    local lblTitle = Chili.Label:New {
        x = 10,
        y = 10,
        fontsize = 30,
        caption = "Upgrade ship",
    }
    local lblHealthTitle = Chili.Label:New {
        x = 10,
        y = 70,
        caption = "Health",
    }
    local lblHealthValue = Chili.Label:New {
        x = 140,
        y = 70,
        caption = tostring(maxHealth),
    }
    local btnIncreaseHealth = Chili.Button:New {
        x = 180,
        y = 60,
        width = 50,
        caption = "+",
        OnClick = { function()
            maxHealth =  maxHealth + 100
            lblHealthValue:SetCaption(tostring(maxHealth))
        end},
    }
    local btnDecreaseHealth = Chili.Button:New {
        x = 180,
        y = 80,
        width = 50,
        caption = "-",
        OnClick = { function()
            if maxHealth <= maxHealthOrig then
                return
            end
            maxHealth = maxHealth - 100
            lblHealthValue:SetCaption(tostring(maxHealth))
        end},
    }
    window = Chili.Window:New {
        parent = screen0,
        x = 100,
        width = 400,
        y = "50%",
        height = "30%",
        draggable = false,
        resizable = false,
        children = {
            btnClose,
            btnApply,
            lblTitle,
            lblHealthTitle,
            lblHealthValue,
            btnIncreaseHealth,
            btnDecreaseHealth
        },
    }
end