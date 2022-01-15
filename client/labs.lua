local isProcessing = false

Citizen.CreateThread(function()
	while true do
		
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
        local sleep = 1000

        for k,v in pairs(Config.Labs) do
            local Distance = #(coords - v.LabCoords)
            if Distance < 10 and Distance > 1.5 then
                sleep = 5
                DrawMarker(2, v.LabCoords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, false, false, 2, true, false, false, false)
            elseif Distance <= 1.5 then
                sleep = 5
                DrawMarker(2, v.LabCoords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, false, false, 2, true, false, false, false)
                DrawText3Ds(v.LabCoords.x, v.LabCoords.y, v.LabCoords.z+0.3, '[~HUD_COLOUR_CONTROLLER_MICHAEL~E~w~] Process: ~r~x' .. v.neededAmount  .. ' ' .. v.neededLabel .. '~w~ Into: ~g~x' .. v.givenAmount .. ' ' .. v.givenLabel .. '~w~.')
                if IsControlJustReleased(0, 38) and not isProcessing then
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
				    			isProcessing = true
						    	TriggerEvent("mythic_progbar:client:progress", {
							    	name = "processing",
							    	duration = v.duration,
							    	label = "Processing..",
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
										print('yes')		
                                    TriggerServerEvent('lab-fields:process', v.neededItem, v.neededAmount, v.neededLabel, v.givenItem, v.givenAmount, v.givenLabel, v.neededCops)								  		  
								    end
							    end)
					    		isProcessing = false
							else
								ESX.ShowNotification('You are not allowed to process this item.')
							end
					else
						isProcessing = true
						    	TriggerEvent("mythic_progbar:client:progress", {
							    	name = "processing",
							    	duration = v.duration,
							    	label = "Processing..",
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
										print('yes')		
									TriggerServerEvent('lab-fields:process', v.neededItem, v.neededAmount, v.neededLabel, v.givenItem, v.givenAmount, v.givenLabel, v.neededCops)								  
								    end
							    end)
					    		isProcessing = false
					end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)


Citizen.CreateThread(function()
	for k, v in pairs(Config.Labs) do
		if v.blip then
    		local coords = v.LabCoords

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
			AddTextComponentString(v.givenLabel .. ' Lab')
			EndTextCommandSetBlipName(k)
		end
	end
end)