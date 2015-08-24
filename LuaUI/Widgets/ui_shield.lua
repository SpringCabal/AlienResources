-- WIP (mostly a copy of the ui_health, but too many globals to bother abstracting)
function widget:GetInfo()
	return {
		name    = 'Shield Bar',
		desc    = 'Displays players shield bar',
		author  = 'gajop, Bluestone, Funkencool',
		date    = 'April, 2015',
		license = 'GNU GPL v2',
        layer = 0,
		enabled = true,
	}
end

local Chili, window

local spGetTeamnameources = Spring.GetTeamnameources
local spGetMyTeamID      = Spring.GetMyTeamID
local myTeamID = spGetMyTeamID()

local images = {
	Health  = 'luaui/images/heart.png',
}

local meter = {}
local ufoID
local ufoDefID = UnitDefNames["ufo"].id

-------------------------------------------

local hpcolormap      = { {1.0, 0.0, 0.0, 1.0}, {0.2, 0.00, 0.8, 1.0}, {0.0, 0.0, 1.0, 1.0}}

function GetColor(colormap,slider)
  local coln = #colormap
  if (slider>=1) then
    local col = colormap[coln]
    return col[1],col[2],col[3],col[4]
  end
  if (slider<0) then slider=0 elseif(slider>1) then slider=1 end
  local posn  = 1+(coln-1) * slider
  local iposn = math.floor(posn)
  local aa    = posn - iposn
  local ia    = 1-aa

  local col1,col2 = colormap[iposn],colormap[iposn+1]

  return col1[1]*ia + col2[1]*aa, col1[2]*ia + col2[2]*aa,
         col1[3]*ia + col2[3]*aa, col1[4]*ia + col2[4]*aa
end

-------------------------------------------

local function initWindow()
	local screen0 = Chili.Screen0
	
	window = Chili.Panel:New {
		parent    = screen0,
		padding   = {0,0,0,0},
	}

end

local function makeBar(name)
	
	local control = Chili.Control:New{
		parent    = window,
		x         = '10%',
		y         = 0,
		height    = '100%',
		width     = '90%',
		padding   = {10,10,10,10},
	}
	
	Chili.Image:New{
		parent = window,
		file   = images[name],
		height = '100%',
		width  = '8%',
		x      = '5%', 
		y      = 0, 
        bottom = 0,
	}

	meter[name] = Chili.Progressbar:New{
		parent = control, 
		x      = 0, 
        y      = 0,
		bottom = 0, 
		right  = 0,
	}
	
end


local function resizeUI(vsx,vsy)
    window:SetPos(vsx*0.35, vsy*(1-0.10-0.01), vsx*0.17, vsy*0.05) 
end
function widget:ViewResize(vsx,vsy)
	resizeUI(vsx,vsy)
end

-- Updates 
local function SetBarValue(name,value,maxValue)
	meter[name]:SetValue(value)
    meter[name]:SetMinMax(0, maxValue)
	meter[name]:SetCaption(tostring(math.floor(value)) .. '/' .. tostring(math.floor(maxValue)))
end
function SetBarColor(name,slider)
    local r,g,b,a = GetColor(hpcolormap,slider) 
    meter[name]:SetColor(r,g,b,a)
end

-------------------------------------------
-- Callins
-------------------------------------------

function updateHealthBar()
	local h, mh = 0, 1000
	local h = Spring.GetGameRulesParam("shieldPower") or 0
	
    h = math.max(0, h)
    SetBarValue('Health', h, mh)
    SetBarColor('Health', h/mh)
end

function widget:GameFrame(n)
    updateHealthBar()
end

function widget:CommandsChanged()
	myTeamID = spGetMyTeamID()
end

function widget:Initialize()
	Spring.SendCommands('resbar 0')
	Chili = WG.Chili
	initWindow()
	makeBar('Health')
    if Spring.GetGameFrame()>0 then
        updateHealthBar()
    end
    
    local vsx,vsy = Spring.GetViewGeometry()
    resizeUI(vsx,vsy)
end

function widget:UnitCreated(unitID, unitDefID)
	if ufoDefID == unitDefID then
		ufoID = unitID
	end
end

function widget:UnitDestroyed(unitID, unitDefID)
	if unitID == ufoID then
		ufoID = nil
	end
end

function widget:Shutdown()
	Spring.SendCommands('resbar 1')
end
