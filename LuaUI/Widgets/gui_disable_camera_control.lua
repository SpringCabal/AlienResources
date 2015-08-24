--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Disable camera control",
		desc      = "Disables camera zooming and panning",
		author    = "gajop",
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

function widget:Initialize()
    --for k, v in pairs(Spring.GetCameraState()) do
    --    Spring.Echo(k .. " = " .. tostring(v) .. ",")
    --end
--     local devMode = (tonumber(Spring.GetModOptions().play_mode) or 0) == 0
--     if devMode then
--         widgetHandler:RemoveWidget(widget)
--         return
--     end
end

function widget:Shutdown()
end

function widget:MouseWheel(up,value)
    -- uncomment this to disable zoom/panning
    --return true
end