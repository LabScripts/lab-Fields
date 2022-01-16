ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Logs
local discord = {
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

-- Get Enough Jobs Is in Server Or No
function HaveEnough(JobTable)
    local Have = true
    if ESX.GetExtendedPlayers then
        for k,v in pairs(JobTable) do
            local xPlayers = ESX.GetExtendedPlayers("job",k)
            if #xPlayers < v then
                Have = false
                break
            end
        end
    else
        local xPlayers = ESX.GetPlayers()
        local Connected = {}
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if JobTable[xPlayer.job.name] then
                if not Connected[xPlayer.job.name] then Connected[xPlayer.job.name] = 0 end
                Connected[xPlayer.job.name] = Connected[xPlayer.job.name] + 1
            end
        end
        for k,v in pairs(JobTable) do
            if Connected[k] < v then
                Have = false
                break
            end
        end
    end
    return Have
end

-- Harvesting Event
RegisterServerEvent('lab-fields:harvest')
AddEventHandler('lab-fields:harvest', function(Index)
    local Field = Config.Fields[Index]
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if Field.jobs or (Field.jobs[xPlayer.job.name] and Field.jobs[xPlayer.job.name] <= xPlayer.job.grade) then
        local IsThereEnoughJob = Field.neededJobs and HaveEnough(Field.neededJobs) or false
        if IsThereEnoughJob then
            local GivenItemName = Field.itemName
            math.randomseed(os.time() + math.random(os.time()) + math.random())
            math.random(); math.random(); math.random();
            local GivenItemCount = math.random(math.min(Field.amount.Min, Field.amount.Max),math.max(Field.amount.Min, Field.amount.Max))
            local Label = Field.label or ESX.GetItemLabel(GivenItemName)
            if xPlayer.canCarryItem(GivenItemName, GivenItemCount) then
                xPlayer.addInventoryItem(GivenItemName, GivenItemCount)
                xPlayer.showNotification('You harvested x' .. GivenItemCount .. ' ' .. Label .. '!')
                Log(':pill:  ' .. xPlayer.getName() ..  ' - ' .. xPlayer.getIdentifier(), '```Harvested: x'.. GivenItemCount .." " .. Label ..' (' .. GivenItemName ..').```')
            else
                xPlayer.showNotification('You can not carry more!')
            end
        else
            xPlayer.showNotification('Not enough Jobs online.')
        end
    else
        xPlayer.showNotification('You cant dot this in this job you have.')
    end
end)

-- Processing Event
RegisterServerEvent('lab-fields:process')
AddEventHandler('lab-fields:process', function(Index)
    local Lab = Config.Labs[Index]
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if Lab.jobs or (Lab.jobs[xPlayer.job.name] and Lab.jobs[xPlayer.job.name] <= xPlayer.job.grade) then
        local IsThereEnoughJob = Lab.neededJobs and HaveEnough(Lab.neededJobs) or true
        if IsThereEnoughJob then
            local givenItem = Lab.itemName
            math.randomseed(os.time() + math.random(os.time()) + math.random())
            math.random(); math.random(); math.random();
            local givenAmount = math.random(math.min(Lab.givenAmount.Min, Lab.givenAmount.Max),math.max(Lab.givenAmount.Min, Lab.givenAmount.Max))
            local givenLabel = Lab.givenLabel or ESX.GetItemLabel(givenItem)
            local neededItem = Lab.neededItem
            local neededAmount = Lab.neededAmount
            local neededLabel = Lab.neededLabel or ESX.GetItemLabel(neededItem)
            if xPlayer.canSwapItem(neededItem, neededAmount, givenItem, givenAmount) then
                xPlayer.removeInventoryItem(neededItem, neededAmount)
                xPlayer.addInventoryItem(givenItem, givenAmount)
                xPlayer.showNotification('You processed: x' .. neededAmount .. ' ' .. neededLabel .. ' Into: x' .. givenAmount .. ' ' .. givenLabel ..'.')
                Log(':pill:  ' .. xPlayer.getName() ..  ' - ' .. xPlayer.getIdentifier(), '```Processed: x' .. neededAmount .. ' ' .. neededLabel .. ' Into: x' .. givenAmount .. ' ' .. givenLabel ..'.```')
            else
                xPlayer.showNotification('You can not do this action!')
            end
        else
            xPlayer.showNotification('Not enough Jobs online.')
        end
    else
        xPlayer.showNotification('You cant dot this in this job you have.')
    end
end)
