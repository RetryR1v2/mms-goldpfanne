local VORPcore = exports.vorp_core:GetCore()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-goldpfanne/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

exports.vorp_inventory:registerUsableItem(Config.GoldPanItem, function(data)
    local source = data.source
    TriggerClientEvent('mms-goldpfanne:client:startgoldpfanne',source)
end)

local function keysx(table)
    local keys = 0
    for k,v in pairs(table) do
       keys = keys + 1
    end
    return keys
end

RegisterServerEvent('mms-goldpfanne:server:addreward')
AddEventHandler('mms-goldpfanne:server:addreward', function()
	local _source = source
	local Character = VORPcore.getUser(_source).getUsedCharacter
	local chance =  math.random(1,10)
	local reward = {}
	for k,v in pairs(Config.Items) do 
		if v.chance >= chance then
			table.insert(reward,v)
		end
	end
	local chance2 = math.random(1,keysx(reward))
	local count = math.random(1,reward[chance2].amount)
	exports.vorp_inventory:canCarryItems(tonumber(_source), count, function(canCarry)
		exports.vorp_inventory:canCarryItem(tonumber(_source), reward[chance2].name,count, function(canCarry2)
			if canCarry and canCarry2 then
				exports.vorp_inventory:addItem(_source, reward[chance2].name, count)
				VORPcore.NotifyTip(_source, Config.YouFound .." "..reward[chance2].label, 5000)
			else
				VORPcore.NotifyTip(_source, Config.InvFull .." "..reward[chance2].label, 5000)
			end
		end)
	end) 
end)



--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()