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
    if msg_table[2] == "maxhealth" then
		local value = tonumber(msg_table[3])
        Spring.SetUnitMaxHealth(ufoID, value)
	end
end

function gadget:RecvLuaMsg(msg)
	HandleLuaMessage(msg)
end

