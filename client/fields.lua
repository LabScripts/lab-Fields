local DrugPlants = {}
local isPickingUp = false

ESX = nil
PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    Citizen.Wait(800)
    PlayerData = ESX.GetPlayerData() -- Setting PlayerData vars
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(Player)
    PlayerData = Player
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(Job)
    PlayerData.job = Job -- Setting PlayerJob on change or player loaded
end)

function GenerateDrugCoords(Field, spawnedPlantsA, DrugPlants)
	while true do
		Citizen.Wait(1)
		    local CoordX, CoordY

		    math.randomseed(GetGameTimer())
		    local modX = math.random(-20, 20)

		    Citizen.Wait(100)

		    math.randomseed(GetGameTimer())
		    local modY = math.random(-20, 20)

		    CoordX = Field.x + modX
		    CoordY = Field.y + modY
			CoordZ = Field.z

		    local coordZ = GetCoordZHeroin(CoordX, CoordY)
		    local coord = vector3(CoordX, CoordY, coordZ)

		    if ValidateHeroinCoord(coord, Field, spawnedPlantsA, DrugPlants) then
			    return coord
		    end
	end
end

function ValidateHeroinCoord(plantCoord, field, spawnedPlantsA, DrugPlants)
	    if spawnedPlantsA > 0 then
		    local validate = true

		    for k, v in pairs(DrugPlants) do
			    if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				    validate = false
			    end
		    end

		    if GetDistanceBetweenCoords(plantCoord, field, false) > 50 then
			    validate = false
		    end

		    return validate
	    else
		    return true
	    end
end

function GetCoordZHeroin(x, y)
	local groundCheckHeights = { 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 12.64
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        for k, v in pairs(Config.Fields) do
		    for k, v in pairs(v.DrugPlantsA) do
			    ESX.Game.DeleteObject(v)
		    end
        end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

    	for k, v in pairs(Config.Fields) do

			if GetDistanceBetweenCoords(coords, v.FieldCoords, true) < 50 then
				Citizen.CreateThread(function()
					while v.spawnedPlants < 15 do
						Citizen.Wait(0)
					 	v.DrugCoords = GenerateDrugCoords(v.FieldCoords, v.spawnedPlants, v.DrugPlantsA)
		
						ESX.Game.SpawnLocalObject(v.DrugProp, v.DrugCoords, function(obj)
							PlaceObjectOnGroundProperly(obj)
							FreezeEntityPosition(obj, true)
		
							table.insert(v.DrugPlantsA, obj)
							v.spawnedPlants = v.spawnedPlants + 1
						end)
					end
				end)

		        for i=1, #v.DrugPlantsA, 1 do
			        if GetDistanceBetweenCoords(coords, GetEntityCoords(v.DrugPlantsA[i]), false) < 1 then
				        nearbyObject, nearbyID = v.DrugPlantsA[i], i
			        end
		        end

		    if nearbyObject and IsPedOnFoot(playerPed) then

			    if not isPickingUp then
				    local plantcoords = GetEntityCoords(nearbyObject)
				    DrawText3Ds(plantcoords.x, plantcoords.y, plantcoords.z + 1.0, 'Press [~r~E~w~] to harvest ' .. v.label .. '.')
			    end

			    if IsControlJustReleased(0, 38) and not isPickingUp then
					local Job = 0
					if v.jobRestricted then 
						for i=1, #v.jobs, 1 do
							if PlayerData.job ~= nil and PlayerData.job.name == v.jobs[i] then
							 	Job = Job+1
							else
								Job = Job
							end
						end
							if Job > 0 then
				    			isPickingUp = true
						    	TriggerEvent("mythic_progbar:client:progress", {
							    	name = "harvesting",
							    	duration = v.duration,
							    	label = "Harvesting..",
							    	useWhileDead = false,
							    	canCancel = true,
							    	controlDisables = {
								    disableMovement = true,
								    disableCarMovement = false,
								    disableMouse = false,
								    disableCombat = true,
								    },
								    animation = {
									    animDict = v.animDict,
									    anim = v.anim
								    },
					  
							    }, function(status)
								    if not status then
								    ClearPedTasks(PlayerPedId())
								    FreezeEntityPosition(PlayerPedId(),false)
								    ESX.Game.DeleteObject(nearbyObject)		
									    table.remove(v.DrugPlantsA, nearbyID)
									    v.spawnedPlants = v.spawnedPlants - 1
										print('yes')		
									TriggerServerEvent('lab-fields:harvest', v.itemName, v.amount, v.label, v.neededCops)								  
								    end
							    end)
					    		isPickingUp = false
							else
								ESX.ShowNotification('You are not allowed to harvest this item.')
							end
					else
						isPickingUp = true
						    	TriggerEvent("mythic_progbar:client:progress", {
							    	name = "harvestheroin",
							    	duration = v.duration,
							    	label = "Harvesting..",
							    	useWhileDead = false,
							    	canCancel = true,
							    	controlDisables = {
								    disableMovement = true,
								    disableCarMovement = false,
								    disableMouse = false,
								    disableCombat = true,
								    },
								    animation = {
									    animDict = v.animDict,
									    anim = v.anim
								    },
					  
							    }, function(status)
								    if not status then
								    ClearPedTasks(PlayerPedId())
								    FreezeEntityPosition(PlayerPedId(),false)
								    ESX.Game.DeleteObject(nearbyObject)		
									    table.remove(v.DrugPlantsA, nearbyID)
									    v.spawnedPlants = v.spawnedPlants - 1
										print('yes')		
										TriggerServerEvent('lab-fields:harvest', v.itemName, v.amount, v.label, v.neededCops)								  
								    end
							    end)
					    		isPickingUp = false
					end
			    end
		    else
			    Citizen.Wait(500)
		    end
	end
    	end
	end
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end



Citizen.CreateThread(function()
	for k, v in pairs(Config.Fields) do
		if v.blip then
    		local coords = v.FieldCoords
        	k = AddBlipForCoord(coords)

			SetBlipHighDetail(k, true)
			SetBlipSprite (k, v.blipSprite)
			SetBlipScale  (k, Config.BlipSize)
			SetBlipColour (k, v.blipColour)
			SetBlipAsShortRange(k, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.label .. ' Field')
			EndTextCommandSetBlipName(k)
		end
	end
end)