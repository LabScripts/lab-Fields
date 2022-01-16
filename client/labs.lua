local isProcessing = false

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local sleep = 1000

		for k, v in ipairs(Config.Labs) do
			local Distance = #(coords - v.LabCoords)
			if Distance < 10 and Distance > 1.5 then
				sleep = 5
				DrawMarker(2,v.LabCoords,0.0,0.0,0.0,0,0.0,0.0,0.3,0.3,0.2,255,255,255,255,false,false,2,true,false,false,false)
			elseif Distance <= 1.5 then
				sleep = 5
				DrawMarker(2,v.LabCoords,0.0,0.0,0.0,0,0.0,0.0,0.3,0.3,0.2,255,255,255,255,false,false,2,true,false,false,false)
				DrawText3Ds(v.LabCoords.x,v.LabCoords.y,v.LabCoords.z + 0.3,"[~HUD_COLOUR_CONTROLLER_MICHAEL~E~w~] Process: ~r~x" ..v.neededAmount .." " ..v.neededLabel .. "~w~ Into: ~g~x" .. v.givenAmount .. " " .. v.givenLabel .. "~w~.")
				if IsControlJustReleased(0, 38) and not isProcessing then
					if v.jobs then
						if PlayerData.job ~= nil and PlayerData.job.name and v.jobs[PlayerData.job.name] and v.jobs[PlayerData.job.name] <= PlayerData.job.grade then
							isProcessing = true
							TriggerEvent(
								"mythic_progbar:client:progress",
								{
									name = "processing",
									duration = v.duration,
									label = "Processing..",
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
										TriggerServerEvent("lab-fields:process", k)
										isProcessing = false
									end
								end
							)
						else
							ESX.ShowNotification("You are not allowed to process this item.")
						end
					else
						isProcessing = true
						TriggerEvent(
							"mythic_progbar:client:progress",
							{
								name = "processing",
								duration = v.duration,
								label = "Processing..",
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
									TriggerServerEvent("lab-fields:process", k)
									isProcessing = false
								end
							end
						)
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	for k2, v in ipairs(Config.Labs) do
		if v.blip then
			local coords = v.LabCoords

			if v.blipRadius then
				local k = AddBlipForRadius(coords, 100.0)
				SetBlipHighDetail(k, true)
				SetBlipColour(k, 1)
				SetBlipAlpha(k, 128)
			end

			k = AddBlipForCoord(coords)

			SetBlipHighDetail(k, true)
			SetBlipSprite(k, v.blipSprite)
			SetBlipScale(k, Config.BlipSize)
			SetBlipColour(k, v.blipColour)
			SetBlipAsShortRange(k, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.givenLabel .. " Lab")
			EndTextCommandSetBlipName(k)
		end
	end
end)
