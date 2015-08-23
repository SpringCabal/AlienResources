if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name 	= "Upgrades",
		desc	= "Spaceship upgrade.",
		author	= "gajop",
		date	= "August 2015",
		license	= "GNU GPL, v2 or later",
		layer	= 0,
		enabled = true
	}
end

local ufoID
local ufoDefID = UnitDefNames["ufo"].id

local function explode(div,str)
	if (div=='') then return 
		false 
	end
	local pos,arr = 0,{}
	-- for each divider found
	for st,sp in function() return string.find(str,div,pos,true) end do
		table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
		pos = sp + 1 -- Jump past current divider
	end
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
	return arr
end

function gadget:Initialize()
    Spring.SetGameRulesParam("biomass", 0)
    Spring.SetGameRulesParam("research", 0)
    Spring.SetGameRulesParam("metal", 0)
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
	if unitDefID == ufoDefID then
		ufoID = unitID
	end
end

function HandleLuaMessage(msg)
	local msg_table = explode('|', msg)
	if msg_table[1] ~= 'upgrade' then
        return
    end
	local tech = msg_table[2]
	local level = msg_table[3]
	local value = msg_table[4]
    if tech == "armor" then
		local newMaxHealth = UnitDefs[ufoDefID].health * (100 + value) / 100
        local hp, maxHP = Spring.GetUnitHealth(ufoID)
        local ratio = hp / maxHP
        Spring.SetUnitMaxHealth(ufoID, newMaxHealth)
        Spring.SetUnitHealth(ufoID, ratio * newMaxHealth) --scale current HP
	end
end

function gadget:RecvLuaMsg(msg)
	HandleLuaMessage(msg)
end

