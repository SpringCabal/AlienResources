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

local ufoID
local ufoDefID = UnitDefNames["ufo"].id

-------------------------------------------------------------------
-------------------------------------------------------------------
-- Camera

local LOOK_FORWARDS = 7

local AVERAGE_SPEEDS = 12
local curIndex = 1
local lastXSpeed = {average = 0}
local lastYSpeed = {average = 0}
local lastZSpeed = {average = 0}

local lx, ly, lz = 0, 0, 0

local cx, cy, cz = 0, 0, 0

local function UpdateSpeed(newVal, values)
	newVal = newVal/AVERAGE_SPEEDS
	values.average = values.average - (values[curIndex] or 0) + newVal
	values[curIndex] = newVal
	return values.average
end

-- follow camera
local function UpdateCamera()
	if ufoID and not Spring.GetUnitIsDead(ufoID) and (Spring.GetGameRulesParam("devMode") ~= 1) then
		local x, y, z = Spring.GetUnitViewPosition(ufoID)
		local vx, vy, vz = Spring.GetUnitVelocity(ufoID)
		
		--local ux, uy, uz = Spring.GetUnitPosition(ufoID)
		--Spring.Echo(math.floor(x - ux), math.floor(z - uz))
		
		x, y, z = x + vx*LOOK_FORWARDS, y + vy*LOOK_FORWARDS, z + vz*LOOK_FORWARDS
		
		-- Apparent unit speed
		local sx, sy, sz = x - lx, y - ly, z - lz
		lx, ly, lz = x, y, z
		
		sx = UpdateSpeed(sx, lastXSpeed)
		sy = UpdateSpeed(sy, lastYSpeed)
		sz = UpdateSpeed(sz, lastZSpeed)
		
		curIndex = curIndex + 1
		if curIndex > AVERAGE_SPEEDS then
			curIndex = 1
		end
		
		Spring.Echo(math.floor(sx), math.floor(sz))
		
		-- has a slight delay which makes it smooth and gives a hint in which direction we're moving
		cx, cy, cz = cx + sx, cy + sy, cz + sz
		Spring.SetCameraTarget(cx, cy + 25, cz, 0.11)
	end
end

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

local lastx, lasty, lastz

local function AimingControl()
	local mx, my = Spring.GetMouseState()
	local _, pos = Spring.TraceScreenRay(mx, my, true)
	if pos then
		local x, y, z = pos[1], pos[2], pos[3]
		if x ~= lastx or y ~= lasty or z ~= lastz then
			lastx, lasty, lastz = x, y, z
			Spring.SendLuaRulesMsg('aimWeapon|' .. x .. '|' .. y .. '|' .. z )
		end
	end
end


function widget:Initialize()
	for _, unitID in pairs(Spring.GetAllUnits()) do
		self:UnitCreated(unitID, Spring.GetUnitDefID(unitID), Spring.GetUnitTeam(unitID))
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitDefID == ufoDefID then
		ufoID = unitID
	end
end

function widget:GameFrame(n)
	-- disable all movement and weapon control when landed/landing
	if not ufoID or Spring.GetUnitStates(ufoID).autoland then
		return
	end
	MovementControl()
	WeaponControl()
	AimingControl()
	
	UpdateCamera()
end

function widget:Update()
	--UpdateCamera()
end

function widget:MousePress(mx, my, button)
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	if button == 1 and not Spring.IsAboveMiniMap(mx, my) and (Spring.GetGameRulesParam("devMode") ~= 1) then
		local _, pos = Spring.TraceScreenRay(mx, my, true)
		if pos then
			local x, y, z = pos[1], pos[2], pos[3]
			Spring.SendLuaRulesMsg('fireWeapon|' .. x .. '|' .. y .. '|' .. z )
			return true
		end
	end	
end
