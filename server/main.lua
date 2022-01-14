ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Logs
discord = {
    ['webhook'] = '',
    ['name'] = 'DRUG FIELDS',
    ['image'] = 'https://media.discordapp.net/attachments/832929996578226216/913995687178416148/istockphoto-979955616-612x612.jpg.png?width=676&height=676'
}

function Log(name, message)
    local data = {
        {
            ["color"] = '15277667',
            ["title"] = "**".. name .."**",
            ["description"] = "**".. message .."**",
        }
    }
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end

-- Get Online Police
function CountCops()
    if Config.Legacy then
	    local xPlayers = ESX.GetExtendedPlayers()
	    CopsConnected = 0
	    for k,v in pairs(xPlayers) do
            if v.job.name == 'police' then
			    CopsConnected = CopsConnected + 1
		    end
	    end
	    SetTimeout(120 * 1000, CountCops)
    else
        local xPlayers = ESX.GetPlayers()
	    CopsConnected = 0
	    for i=1, #xPlayers, 1 do
		    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		    if xPlayer.job.name == 'police' then
			    CopsConnected = CopsConnected + 1
		    end
	    end
	    SetTimeout(120 * 1000, CountCops) -- Check every 2 minutes.
    end
end

CountCops()

-- Harvesting Event
RegisterServerEvent('lab-fields:harvest')
AddEventHandler('lab-fields:harvest', function(itemName, amount, label, neededCops)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)
    if CopsConnected >= neededCops then
	    if xPlayer.canCarryItem(itemName, amount) then
		    xPlayer.addInventoryItem(itemName, amount)
            xPlayer.showNotification('You harvested x' .. amount .. ' ' .. label .. '!')
            Log(':pill:  ' .. xPlayer.getName() ..  ' - ' .. xPlayer.getIdentifier(), '```Harvested: x'.. amount ..' ' .. label .. '.```')
	    else
            xPlayer.showNotification('You can not carry more!')
	    end
    else
        xPlayer.showNotification('Not enough police online.')
    end
end)

-- Processing Event
RegisterServerEvent('lab-fields:process')
AddEventHandler('lab-fields:process', function(neededItem, neededAmount, neededLabel, givenItem, givenAmount, givenLabel, neededCops)
    local xPlayer = ESX.GetPlayerFromId(source)
    if CopsConnected >= neededCops then
        if xPlayer.canSwapItem(neededItem, neededAmount, givenItem, givenAmount) then
            xPlayer.removeInventoryItem(neededItem, neededAmount)
            xPlayer.addInventoryItem(givenItem, givenAmount)
            xPlayer.showNotification('You processed: x' .. neededAmount .. ' ' .. neededLabel .. ' Into: x' .. givenAmount .. ' ' .. givenLabel ..'.')
            Log(':pill:  ' .. xPlayer.getName() ..  ' - ' .. xPlayer.getIdentifier(), '```Processed: x' .. neededAmount .. ' ' .. neededLabel .. ' Into: x' .. givenAmount .. ' ' .. givenLabel ..'.```')
        else
            xPlayer.showNotification('You can not do this action!')
        end
    else
        xPlayer.showNotification('Not enough police online.')
    end
end)
