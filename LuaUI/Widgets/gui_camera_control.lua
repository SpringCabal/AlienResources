--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Disable camera control",
		desc      = "Disables camera zooming and panning",
		author    = "gajop, ashdnazg",
		date      = "WIP",
		license   = "GPLv2",
		version   = "0.1",
		layer     = -1000,
		enabled   = true,  --  loaded by default?
		handler   = true,
		api       = true,
		hidden    = true,
	}
end

include("Widgets/COFCtools/Interpolate.lua")

local CAMERA_DIST = 1500
local CAMERA_SMOOTHNESS = 2

local ufoDefID = UnitDefNames["ufo"].id
local ufoID
local lastx, lasty, lastz

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitDefID == ufoDefID then
		ufoID = unitID
	end
end

function widget:Initialize()
	for _, unitID in ipairs(Spring.GetAllUnits()) do
		local unitDefID = Spring.GetUnitDefID(unitID)
		Spring.Echo(unitDefID, ufoDefID)
		widget:UnitCreated(unitID, unitDefID)
	end
	
    for k, v in pairs(Spring.GetCameraState()) do
       Spring.Echo(k .. " = " .. tostring(v) .. ",")
    end
    -- local devMode = true
    -- if devMode then
        -- widgetHandler:RemoveWidget(widget)
        -- return
    -- end
	Spring.SendCommands("viewspring")
	local cs = Spring.GetCameraState()
	cs.dist = CAMERA_DIST
	cs.rx = 2.7
	cs.rz = 0
	cs.ry = 0
	cs.dx = 0
	cs.dy = -1
	cs.dz = -0.5
	Spring.SetCameraState(cs, 0)
end

function widget:DrawScreen()
	Interpolate()
end

function widget:Shutdown()
end

function widget:GameFrame(n)
	if not ufoID then
		return
	end
	local cs = Spring.GetCameraState()
	local ux, uy, uz = Spring.GetUnitPosition(ufoID)
	if lastx then
		cs.px, cs.py, cs.pz = (ux + lastx) / 2, (uy + lasty) / 2 + 25, (uz + lastz) / 2
		OverrideSetCameraStateInterpolate(cs, CAMERA_SMOOTHNESS)
	end
	lastx, lasty, lastz = ux, uy, uz
end

function widget:MouseWheel(up,value)
    -- uncomment this to disable zoom/panning
    --return true
end