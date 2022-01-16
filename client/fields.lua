local isPickingUp = false
local SpawningWay = false

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

function GenerateCords(Field, spawnedPlantsA, DrugPlants)
	while true do
		Citizen.Wait(100)
		local CoordX, CoordY

		math.randomseed(GetGameTimer() + math.random(GetGameTimer()) + math.random())
		math.random(); math.random(); math.random(); 
		local modX = math.random(-20, 20)

		math.randomseed(GetGameTimer() + math.random(GetGameTimer()) + math.random())
		math.random(); math.random(); math.random(); 
		local modY = math.random(-20, 20)

		CoordX = Field.x + modX
		CoordY = Field.y + modY
		CoordZ = Field.z

		local coord = vector3(CoordX, CoordY, CoordZ)

		if EnsureCoords(coord, Field, spawnedPlantsA, DrugPlants) then
			return coord
		end
	end
end

function EnsureCoords(plantCoord, field, spawnedPlantsA, DrugPlants)
	if spawnedPlantsA > 0 then
		local Ensured = true

		for k, v in pairs(DrugPlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				Ensured = false
			end
		end

		if #(plantCoord - field) > 50 then
			Ensured = false
		end

		return Ensured
	else
		return true
	end
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in ipairs(Config.Fields) do
			for k, v in pairs(v.DrugPlantsA) do
				ESX.Game.DeleteObject(v)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local Cooldown = 1000
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for k, v in ipairs(Config.Fields) do
			if #(coords - v.FieldCoords) < 50 then
				Cooldown = 500
				if v.spawnedPlants < 15 and not SpawningWay then
					SpawningWay = true
					while v.spawnedPlants < 15 do
						Citizen.Wait(0)
						v.DrugCoords = GenerateCords(v.FieldCoords, v.spawnedPlants, v.DrugPlantsA)

						ESX.Game.SpawnLocalObject(
							v.DrugProp,
							v.DrugCoords,
							function(obj)
								PlaceObjectOnGroundProperly(obj)
								FreezeEntityPosition(obj, true)

								table.insert(v.DrugPlantsA, obj)
								v.spawnedPlants = v.spawnedPlants + 1
							end
						)
					end
					SpawningWay = false
				end

				for i = 1, #v.DrugPlantsA, 1 do
					if #(coords - GetEntityCoords(v.DrugPlantsA[i])) < 2 then
						nearbyObject, nearbyID = v.DrugPlantsA[i], i
					end
				end

				if nearbyObject and IsPedOnFoot(playerPed) then
					if not isPickingUp then
						Cooldown = 5
						local plantcoords = GetEntityCoords(nearbyObject)
						DrawText3Ds(plantcoords.x,plantcoords.y,plantcoords.z + 1.0,"[~HUD_COLOUR_CONTROLLER_MICHAEL~E~w~] Harvest " .. v.label .. ".")
					end

					if Config.PropOutline then
						if #(coords - GetEntityCoords(nearbyObject)) < 1.8 then
							SetEntityDrawOutline(nearbyObject, true)
							SetEntityDrawOutlineColor(Config.OutlineColor.r, Config.OutlineColor.g, Config.OutlineColor.b,1)
						else
							SetEntityDrawOutline(nearbyObject, false)
						end
					end

					if IsControlJustReleased(0, 38) and not isPickingUp then
						local Job = 0
						if v.jobs then 
							if PlayerData.job ~= nil and PlayerData.job.name and v.jobs[PlayerData.job.name] and v.jobs[PlayerData.job.name] <= PlayerData.job.grade then
								isPickingUp = true
								TriggerEvent("mythic_progbar:client:progress",
									{
										name = "harvesting",
										duration = v.duration,
										label = "Harvesting..",
										useWhileDead = false,
										canCancel = true,
										controlDisables = {
											disableMovement = true,
											disableCarMovement = false,
											disableMouse = false,
											disableCombat = true
										},
										animation = {
											animDict = v.animDict,
											anim = v.anim
										}
									},
									function(status)
										if not status then
											ClearPedTasks(PlayerPedId())
											FreezeEntityPosition(PlayerPedId(), false)
											ESX.Game.DeleteObject(nearbyObject)
											table.remove(v.DrugPlantsA, nearbyID)
											v.spawnedPlants = v.spawnedPlants - 1
											TriggerServerEvent("lab-fields:harvest", k)
											isPickingUp = false
										end
									end
								)
							else
								ESX.ShowNotification("You are not allowed to harvest this item.")
							end
						else
							isPickingUp = true
							TriggerEvent(
								"mythic_progbar:client:progress",
								{
									name = "harvestheroin",
									duration = v.duration,
									label = "Harvesting..",
									useWhileDead = false,
									canCancel = true,
									controlDisables = {
										disableMovement = true,
										disableCarMovement = false,
										disableMouse = false,
										disableCombat = true
									},
									animation = {
										animDict = v.animDict,
										anim = v.anim
									}
								},
								function(status)
									if not status then
										ClearPedTasks(PlayerPedId())
										FreezeEntityPosition(PlayerPedId(), false)
										ESX.Game.DeleteObject(nearbyObject)
										table.remove(v.DrugPlantsA, nearbyID)
										v.spawnedPlants = v.spawnedPlants - 1
										TriggerServerEvent("lab-fields:harvest", k)
										isPickingUp = false
									end
								end
							)
						end
					end
				end
			end
		end
		Citizen.Wait(Cooldown)
	end
end)


function DrawText3Ds(x, y, z, text)
	SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
	SetTextDropshadow(1, 1, 1, 1, 255)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
	for k2, v in ipairs(Config.Fields) do
		if v.blip then
			local coords = v.FieldCoords

			if v.blipRadius then
				local k = AddBlipForRadius(coords, 100.0)
				SetBlipHighDetail(k, true)
				SetBlipColour(k, 1)
				SetBlipAlpha (k, 128)
			end

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