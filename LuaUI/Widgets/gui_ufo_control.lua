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

local function MovementControl()
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

local function WeaponControl()
	local mx, my, lmb, mmb, rmb = Spring.GetMouseState()
	if lmb then
		local _, pos = Spring.TraceScreenRay(mx, my, true)
		if pos then
			local x, y, z = pos[1], pos[2], pos[3]
			Spring.SendLuaRulesMsg('fireWeapon|' .. x .. '|' .. y .. '|' .. z )
		end
	end
end

function widget:GameFrame(n)
	MovementControl()
	WeaponControl()
end

function widget:MousePress(mx, my, button)
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	if button == 1 and not Spring.IsAboveMiniMap(mx, my) then
		local _, pos = Spring.TraceScreenRay(mx, my, true)
		if pos then
			local x, y, z = pos[1], pos[2], pos[3]
			Spring.SendLuaRulesMsg('fireWeapon|' .. x .. '|' .. y .. '|' .. z )
			return true
		end
	end	
end