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
local N_0 = KEYSYMS.N_0
local N_9 = KEYSYMS.N_9

local ufoID
local ufoDefID = UnitDefNames["ufo"].id

local cloak = 0

local weapons, abilities
local currentWeapon

local aimWeapons = {
	["incendiaryBeamLaser"] = true,
	["gravityBeam"] = true,
}

-------------------------------------------------------------------
-------------------------------------------------------------------
-- Camera

local LOOK_FORWARDS = 12

local AVERAGE_SPEEDS = 12
local curIndex = 1
local lastXSpeed = {average = 0}
local lastYSpeed = {average = 0}
local lastZSpeed = {average = 0}

local mouseControl = false

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
		--local x = Spring.GetGameRulesParam("ufo_x") or 0
		--local y = Spring.GetGameRulesParam("ufo_y") or 0
		--local z = Spring.GetGameRulesParam("ufo_z") or 0
		
		local vx, vy, vz = Spring.GetUnitVelocity(ufoID)
		local x, y, z = Spring.GetUnitViewPosition(ufoID)

		x, y, z = x + vx*LOOK_FORWARDS, y + vy*LOOK_FORWARDS, z + vz*LOOK_FORWARDS
		
		-- Apparent unit speed
		local sx, sy, sz = x - lx, y - ly, z - lz
		lx, ly, lz = x, y, z
		
		--Spring.Echo(math.floor(sx), math.floor(sz))
		
		--Spring.Echo(math.floor(x - wx), math.floor(z - wz))
		--local ux, uy, uz = Spring.GetUnitPosition(ufoID)
		--Spring.Echo(math.floor(x - ux), math.floor(z - uz))
		
		
		sx = UpdateSpeed(sx, lastXSpeed)
		sy = UpdateSpeed(sy, lastYSpeed)
		sz = UpdateSpeed(sz, lastZSpeed)
		
		curIndex = curIndex + 1
		if curIndex > AVERAGE_SPEEDS then
			curIndex = 1
		end
		
		--Spring.Echo(math.floor(sx), math.floor(sz))
		
		-- has a slight delay which makes it smooth and gives a hint in which direction we're moving
		cx, cy, cz = cx + sx, cy + sy, cz + sz
		--Spring.SetCameraTarget(cx, cy + 25, cz, 0.4)
		
		local newState = {
			px = cx,
			py = cy + 25,
			pz = cz,
			mode = 1,
			flipped = -1,
			fov = 45,
			height = 2000,
			angle = 0.4,
		}
		Spring.SetCameraState(newState, 0.4)
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
		if aimWeapons[currentWeapon] then
			Spring.SendLuaRulesMsg('fireWeapon')
		else
			local _, pos = Spring.TraceScreenRay(mx, my, true)
			if pos then
				local x, y, z = pos[1], pos[2], pos[3]
				Spring.SendLuaRulesMsg('fireWeapon|' .. x .. '|' .. y .. '|' .. z )
			end
		end
	end
end

local lastx, lasty, lastz

local function AimingControl()
	local mx, my = Spring.GetMouseState()
	local _, pos = Spring.TraceScreenRay(mx, my, true)
	if pos then
		local x, y, z = pos[1], pos[2], pos[3]
		--if x ~= lastx or y ~= lasty or z ~= lastz then
			lastx, lasty, lastz = x, y, z
			Spring.SendLuaRulesMsg('aimWeapon|' .. x .. '|' .. y .. '|' .. z )
		--end
	end
end

-- handles weapon switching and abilities
function widget:KeyPress(key, mods, isRepeat)
	if ufoID then
		for _, abilityName in pairs(abilities) do
			local cd = Spring.GetGameRulesParam(abilityName .. "CD") or 0
			local tech = WG.Tech.GetTech(abilityName)
			if not tech.locked and Spring.GetKeyCode(tech.key) == key and cd == 0 then
				Spring.SendLuaRulesMsg('ability|' .. abilityName)
				return
			end
		end
		if key >= N_0 and key <= N_9 then
			local num = key - N_0
			local weaponName = weapons[num]
			if weaponName == nil or weaponName == currentWeapon or WG.Tech.GetTech(weaponName).locked then 
				return
			end
			WG.UI.SetAbilityEnabled(weaponName, true)
			if currentWeapon ~= nil then
				WG.UI.SetAbilityEnabled(currentWeapon, false)
			end
			currentWeapon = weaponName
			Spring.PlaySoundFile("sounds/select.wav")
			Spring.SendLuaRulesMsg('changeWeapon|' .. weaponName)
		end
	end
end

function widget:GameFrame(n)
	-- disable all movement and weapon control when landed/landing (OLD STUFF)
	-- if not ufoID or Spring.GetUnitStates(ufoID).autoland then 
	
	if not ufoID then
		return
	end
	
	AimingControl()
	MovementControl()
	
	if mouseControl then
		WeaponControl()
	end
	
	UpdateCamera()

end

function widget:Update()
	--UpdateCamera()
end

function widget:MousePress(mx, my, button)
	local alt, ctrl, meta, shift = Spring.GetModKeyState()
	if button == 1 and not Spring.IsAboveMiniMap(mx, my) then
		local _, pos = Spring.TraceScreenRay(mx, my, true)
		if pos then
			local x, y, z = pos[1], pos[2], pos[3]
			Spring.SendLuaRulesMsg('fireWeapon|' .. x .. '|' .. y .. '|' .. z )
			mouseControl = true
			return (Spring.GetGameRulesParam("devMode") ~= 1)
		end
	end	
end

function widget:MouseRelease(mx, my, button)
	if button == 1 then
		mouseControl = false
	end
end

-------------------------------------------------------------------
-------------------------------------------------------------------

function widget:Initialize()
	for _, unitID in pairs(Spring.GetAllUnits()) do
		self:UnitCreated(unitID, Spring.GetUnitDefID(unitID), Spring.GetUnitTeam(unitID))
	end
	weapons = WG.Tech.GetWeapons()
	abilities = WG.Tech.GetAbilities()
end

function widget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitDefID == ufoDefID then
		ufoID = unitID
		if currentWeapon ~= nil then
			WG.UI.SetAbilityEnabled(currentWeapon, true)
		end
	end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	if ufoID == unitID then
		ufoID = nil
		currentWeapon = nil
	end
end