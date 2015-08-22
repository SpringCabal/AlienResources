function widget:GetInfo()
	return {
		name 	= "Movement Control",
		desc	= "Controls unit movement directly with keyboard.",
		author	= "Google Frog",
		date	= "22 August 2015",
		license	= "GNU GPL, v2 or later",
		layer	= 20, 
		enabled = true
	}
end

-------------------------------------------------------------------
-------------------------------------------------------------------

include('keysym.h.lua')
local W = KEYSYMS.W
local S = KEYSYMS.S
local A = KEYSYMS.A
local D = KEYSYMS.D

-------------------------------------------------------------------
-------------------------------------------------------------------

function widget:GameFrame(frame)
	local x, z = 0, 0
	
	if Spring.GetKeyState(A) then
		x = x - 1
    end
	if Spring.GetKeyState(D) then
		x = x + 1
    end
	if Spring.GetKeyState(W) then
		z = z - 1
    end
	if Spring.GetKeyState(S) then
		z = z + 1
    end
	
	Spring.SendLuaRulesMsg('movement|' .. x .. '|' .. z)
end