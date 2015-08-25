function widget:GetInfo()
	return {
		name      = 'Flaoting text',
		desc      = 'Displays floating text on events',
		author    = 'gajop',
		date      = 'August 2015',
		license   = 'GNU GPL v2',
		layer     = 0,
		enabled   = true,
		handler   = true,
	}
end

local events = {}
local majorEvent

local vsx, vsy

function WG.AddEvent(str, fontSize, color)
    table.insert(events, {
        str = str,
        fontSize = fontSize,
        timeout = 30,
        color = color,
    })
end

function widget:Initialize()
    vsx, vsy = Spring.GetViewGeometry()
end

function widget:DrawScreen()
    local startPos = vsy - 200
    gl.PushMatrix()
    for i = 1, #events do
        local event = events[i]
        local str, fontSize, timeout, color = event.str, event.fontSize, event.timeout, event.color
        local pos = startPos - event.timeout / 30 * 200
        local size = fontSize - math.abs(15 - event.timeout) / 30 * 12
        local fw = gl.GetTextWidth(str) * size
        gl.Color(color[1], color[2], color[3], color[4])
        gl.Text(event.str, vsx - fw - 50, pos, size)
    end
    gl.PopMatrix()
end

local lastResearch = 0
local lastBiomass = 0

function widget:GameFrame()
    for i = #events, 1, -1 do
        local event = events[i]
        event.timeout = event.timeout - 1
        if event.timeout <= 0 then
            table.remove(events, i)
        end
    end
	if Spring.GetGameFrame() % 5 ~= 0 then
		return
	end
	local research = Spring.GetGameRulesParam("research")
	local biomass = Spring.GetGameRulesParam("biomass")
	if research and lastResearch ~= research then
		WG.AddEvent("Research +" .. (research - lastResearch), 40, {0.0,0.3,0.8,1.0})
		lastResearch = research
		return -- Try not to spawn both the same frame
	end
	if biomass and lastBiomass ~= biomass then
		WG.AddEvent("Biomass +" .. (biomass - lastBiomass), 40, {0.1,0.8,0.2,1.0})
		lastBiomass = biomass
	end
end

function widget:Update()
end