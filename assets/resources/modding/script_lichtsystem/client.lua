]]

local count_bcast_timer = 0
local delay_bcast_timer = 200

local count_sndclean_timer = 0
local delay_sndclean_timer = 400

local actv_ind_timer = false
local count_ind_timer = 0
local delay_ind_timer = 180

local actv_drsrnmute_temp = false
local srntone_temp = 0
local dsrn_mute = true

local state_indic = {}
local state_drsiren = {}
local state_pwrcall = {}
local state_airmanu = {}

local ind_state_o = 0
local ind_state_l = 1
local ind_state_r = 2
local ind_state_h = 3

local snd_drsiren = {}
local snd_pwrcall = {}
local snd_airmanu = {}

local eModelsWithFireSrn =
{
	"AMBULAN",
	"FIRETRUK",
	"AMBULANCE2",
	"FIRETRUK2",
	"FIRETRUK3",
	"FIRETRUK4",
	"FIRETRUK5",
	"AMBULANTRUK",
	"AMBULANTRUK2",
	"AMBULANCE",
	"AMBULANCE3",
	"LSFDTRUK",
	"LSFDTRUK2",
	"LSFDTRUK3",
	"LSFDTRUK4",
	"LSMD",
	"LSFD",
	"LSMDTRUK2",
	"LSMDTRUK3",
}

local eModelsWithPcall =
{	
	"AMBULAN",
	"FIRETRUK",
	"LGUARD",
	"AMBULANCE2",
	"FIRETRUK2",
	"FIRETRUK3",
	"FIRETRUK4",
	"FIRETRUK5",
	"AMBULANBACKUP",
	"AMBULANTRUK",
	"AMBULANTRUK2",
	"AMBULANCE",
	"AMBULANCE3",
	"LSFDTRUK",
	"LSFDTRUK2",
	"LSFDTRUK3",
	"LSFDTRUK4",
	"LSMD",
	"LSFD",
	"LSMDTRUK2",
	"LSMDTRUK3",
	"LSFDUNMARKED",
	"LSFDUNMARKED2",
	"LSMDUNMARKED",
	"LSMDUNMARKED2",
}

function ShowDebug(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function useFiretruckSiren(veh)
	local model = GetEntityModel(veh)
	for i = 1, #eModelsWithFireSrn, 1 do
		if model == GetHashKey(eModelsWithFireSrn[i]) then
			return true
		end
	end
	return false
end

function usePowercallAuxSrn(veh)
	local model = GetEntityModel(veh)
	for i = 1, #eModelsWithPcall, 1 do
		if model == GetHashKey(eModelsWithPcall[i]) then
			return true
		end
	end
	return false
end

function CleanupSounds()
	if count_sndclean_timer > delay_sndclean_timer then
		count_sndclean_timer = 0
		for k, v in pairs(state_drsiren) do
			if v > 0 then
				if not DoesEntityExist(k) or IsEntityDead(k) then
					if snd_drsiren[k] ~= nil then
						StopSound(snd_drsiren[k])
						ReleaseSoundId(snd_drsiren[k])
						snd_drsiren[k] = nil
						state_drsiren[k] = nil
					end
				end
			end
		end

		for k, v in pairs(state_pwrcall) do
			if v == true then
				if not DoesEntityExist(k) or IsEntityDead(k) then
					if snd_pwrcall[k] ~= nil then
						StopSound(snd_pwrcall[k])
						ReleaseSoundId(snd_pwrcall[k])
						snd_pwrcall[k] = nil
						state_pwrcall[k] = nil
					end
				end
			end
		end

		for k, v in pairs(state_airmanu) do
			if v == true then
				if not DoesEntityExist(k) or IsEntityDead(k) or IsVehicleSeatFree(k, -1) then
					if snd_airmanu[k] ~= nil then
						StopSound(snd_airmanu[k])
						ReleaseSoundId(snd_airmanu[k])
						snd_airmanu[k] = nil
						state_airmanu[k] = nil
					end
				end
			end
		end
	else
		count_sndclean_timer = count_sndclean_timer + 1
	end
end

function TogIndicStateForVeh(veh, newstate)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if newstate == ind_state_o then
			SetVehicleIndicatorLights(veh, 0, false)
			SetVehicleIndicatorLights(veh, 1, false)
		elseif newstate == ind_state_l then
			SetVehicleIndicatorLights(veh, 0, false)
			SetVehicleIndicatorLights(veh, 1, true)
		elseif newstate == ind_state_r then
			SetVehicleIndicatorLights(veh, 0, true)
			SetVehicleIndicatorLights(veh, 1, false)
		elseif newstate == ind_state_h then
			SetVehicleIndicatorLights(veh, 0, true)
			SetVehicleIndicatorLights(veh, 1, true)
		end
		state_indic[veh] = newstate
	end
end

function TogMuteDfltSrnForVeh(veh, toggle)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		DisableVehicleImpactExplosionActivation(veh, toggle)
	end
end


function SetdrSirenStateForVeh(veh, newstate)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if newstate ~= state_drsiren[veh] then


			if snd_drsiren[veh] ~= nil then
				StopSound(snd_drsiren[veh])
				ReleaseSoundId(snd_drsiren[veh])
				snd_drsiren[veh] = nil
			end

			if newstate == 1 then
				if useFiretruckSiren(veh) then
					TogMuteDfltSrnForVeh(veh, false)
				else
					snd_drsiren[veh] = GetSoundId()	
					PlaySoundFromEntity(snd_drsiren[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				end

			elseif newstate == 2 then
				snd_drsiren[veh] = GetSoundId()
				PlaySoundFromEntity(snd_drsiren[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
				TogMuteDfltSrnForVeh(veh, true)

			elseif newstate == 3 then
				snd_drsiren[veh] = GetSoundId()
				if useFiretruckSiren(veh) then
					PlaySoundFromEntity(snd_drsiren[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
				else
					PlaySoundFromEntity(snd_drsiren[veh], "VEHICLES_HORNS_POLICE_WARNING", veh, 0, 0, 0)
				end
				TogMuteDfltSrnForVeh(veh, true)
				
			else
				TogMuteDfltSrnForVeh(veh, true)
				
			end				
				
			state_drsiren[veh] = newstate
		end
	end
end

function TogPowercallStateForVeh(veh, toggle)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if toggle == true then
			if snd_pwrcall[veh] == nil then
				snd_pwrcall[veh] = GetSoundId()
				if usePowercallAuxSrn(veh) then
					PlaySoundFromEntity(snd_pwrcall[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
				else
					PlaySoundFromEntity(snd_pwrcall[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
				end
			end

		else
			if snd_pwrcall[veh] ~= nil then
				StopSound(snd_pwrcall[veh])
				ReleaseSoundId(snd_pwrcall[veh])
				snd_pwrcall[veh] = nil
			end
		end
		state_pwrcall[veh] = toggle
	end
end

function SetAirManuStateForVeh(veh, newstate)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if newstate ~= state_airmanu[veh] then
				
			if snd_airmanu[veh] ~= nil then
				StopSound(snd_airmanu[veh])
				ReleaseSoundId(snd_airmanu[veh])
				snd_airmanu[veh] = nil
			end

			if newstate == 1 then
				snd_airmanu[veh] = GetSoundId()
				if useFiretruckSiren(veh) then
					PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_FIRETRUCK_WARNING", veh, 0, 0, 0)
				else
					PlaySoundFromEntity(snd_airmanu[veh], "SIRENS_AIRHORN", veh, 0, 0, 0)
				end

			elseif newstate == 2 then
				snd_airmanu[veh] = GetSoundId()
				PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
			
			elseif newstate == 3 then
				snd_airmanu[veh] = GetSoundId()
				PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
			end				

			state_airmanu[veh] = newstate
		end
	end
end

function SetAirManuStateForVehClick(veh, newstate)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if newstate ~= state_airmanu[veh] then
				
			if snd_airmanu[veh] ~= nil then
				StopSound(snd_airmanu[veh])
				ReleaseSoundId(snd_airmanu[veh])
				snd_airmanu[veh] = nil
			end

			if newstate == 1 then
				snd_airmanu[veh] = GetSoundId()
				if useFiretruckSiren(veh) then
					PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_FIRETRUCK_WARNING", veh, 0, 0, 0)
					TriggerEvent("art_vehcontrol:ELSClick", "Upgrade", 0.7)
				else
					TriggerEvent("art_vehcontrol:ELSClick", "Upgrade", 0.7)
					PlaySoundFromEntity(snd_airmanu[veh], "SIRENS_AIRHORN", veh, 0, 0, 0)
				end

			elseif newstate == 2 then
				snd_airmanu[veh] = GetSoundId()
				TriggerEvent("art_vehcontrol:ELSClick", "Upgrade", 0.7)
				PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
			
			elseif newstate == 3 then
				snd_airmanu[veh] = GetSoundId()
				TriggerEvent("art_vehcontrol:ELSClick", "Upgrade", 0.7)
				PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
			end				

			state_airmanu[veh] = newstate
		end
	end
end

RegisterNetEvent("dyr_TogIndicState_c")
AddEventHandler("dyr_TogIndicState_c", function(sender, newstate)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				TogIndicStateForVeh(veh, newstate)
			end
		end
	end
end)

AddEventHandler('art_vehcontrol:ELSClick', function(soundFile, soundVolume)
SendNUIMessage({
  transactionType     = 'playSound',
  transactionFile     = soundFile,
  transactionVolume   = soundVolume
})
end)

RegisterNetEvent("dyr_TogDfltSrnMuted_c")
AddEventHandler("dyr_TogDfltSrnMuted_c", function(sender, toggle)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				TogMuteDfltSrnForVeh(veh, toggle)
			end
		end
	end
end)

RegisterNetEvent("dyr_SetdrSirenState_c")
AddEventHandler("dyr_SetdrSirenState_c", function(sender, newstate)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				SetdrSirenStateForVeh(veh, newstate)
			end
		end
	end
end)

RegisterNetEvent("dyr_TogPwrcallState_c")
AddEventHandler("dyr_TogPwrcallState_c", function(sender, toggle)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				TogPowercallStateForVeh(veh, toggle)
			end
		end
	end
end)

RegisterNetEvent("dyr_SetAirManuState_c")
AddEventHandler("dyr_SetAirManuState_c", function(sender, newstate)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				SetAirManuStateForVeh(veh, newstate)
			end
		end
	end
end)

RegisterNetEvent("Setdyr_SetAirManuState_clientclick")
AddEventHandler("Setdyr_SetAirManuState_clientclick", function(sender, newstate)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= GetPlayerPed(-1) then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				SetAirManuStateForVehClick(veh, newstate)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
			
			CleanupSounds()

			-- IM FAHRZEUG
			local playerped = GetPlayerPed(-1)		
			if IsPedInAnyVehicle(playerped, false) then	

				-- FAHRER
				local veh = GetVehiclePedIsUsing(playerped)	
				if GetPedInVehicleSeat(veh, -1) == playerped then
				
					DisableControlAction(0, 84, true)
					DisableControlAction(0, 83, true) 
					
					if state_indic[veh] ~= ind_state_o and state_indic[veh] ~= ind_state_l and state_indic[veh] ~= ind_state_r and state_indic[veh] ~= ind_state_h then
						state_indic[veh] = ind_state_o
					end

					if actv_ind_timer == true then	
						if state_indic[veh] == ind_state_l or state_indic[veh] == ind_state_r then
							if GetEntitySpeed(veh) < 6 then
								count_ind_timer = 0
							else
								if count_ind_timer > delay_ind_timer then
									count_ind_timer = 0
									actv_ind_timer = false
									state_indic[veh] = ind_state_o
									TogIndicStateForVeh(veh, state_indic[veh])
									count_bcast_timer = delay_bcast_timer
								else
									count_ind_timer = count_ind_timer + 1
								end
							end
						end
					end

					if GetVehicleClass(veh) == 18 then
						
						local actv_manu = false
						local actv_horn = false
						
						DisableControlAction(0, 86, true)
						DisableControlAction(0, 81, true)
						DisableControlAction(0, 82, true)
						DisableControlAction(0, 19, true)
						DisableControlAction(0, 85, true)
						DisableControlAction(0, 80, true)
					
						SetVehRadioStation(veh, "OFF")
						SetVehicleRadioEnabled(veh, false)
						
						if state_drsiren[veh] ~= 1 and state_drsiren[veh] ~= 2 and state_drsiren[veh] ~= 3 then
							state_drsiren[veh] = 0
						end
						if state_pwrcall[veh] ~= true then
							state_pwrcall[veh] = false
						end
						if state_airmanu[veh] ~= 1 and state_airmanu[veh] ~= 2 and state_airmanu[veh] ~= 3 then
							state_airmanu[veh] = 0
						end
						
						if useFiretruckSiren(veh) and state_drsiren[veh] == 1 then
							TogMuteDfltSrnForVeh(veh, false)
							dsrn_mute = false
						else
							TogMuteDfltSrnForVeh(veh, true)
							dsrn_mute = true
						end
						
						if not IsVehicleSirenOn(veh) and state_drsiren[veh] > 0 then
							SetdrSirenStateForVeh(veh, 0)
							count_bcast_timer = delay_bcast_timer
						end
						if not IsVehicleSirenOn(veh) and state_pwrcall[veh] == true then
							TogPowercallStateForVeh(veh, false)
							count_bcast_timer = delay_bcast_timer
						end

						if not IsPauseMenuActive() then
						
							if IsDisabledControlJustReleased(0, 85) or IsDisabledControlJustReleased(0, 246) then
								if IsVehicleSirenOn(veh) then
									TriggerEvent("art_vehcontrol:ELSClick", "Off", 0.7)
									SetVehicleSiren(veh, false)
								else
									TriggerEvent("art_vehcontrol:ELSClick", "On", 0.5)
									Citizen.Wait(150)
									SetVehicleSiren(veh, true)
									count_bcast_timer = delay_bcast_timer
								end		

							elseif IsDisabledControlJustReleased(0, 19) or IsDisabledControlJustReleased(0, 82) then
								local cstate = state_drsiren[veh]
								if cstate == 0 then
									if IsVehicleSirenOn(veh) then
										TriggerEvent("art_vehcontrol:ELSClick", "Upgrade", 0.7)
										SetdrSirenStateForVeh(veh, 1)
										count_bcast_timer = delay_bcast_timer
									end
								else
									TriggerEvent("art_vehcontrol:ELSClick", "Downgrade", 1)
									SetdrSirenStateForVeh(veh, 0)
									count_bcast_timer = delay_bcast_timer
								end

							elseif IsDisabledControlJustReleased(0, 172) then
								if state_pwrcall[veh] == true then
									TriggerEvent("art_vehcontrol:ELSClick", "Downgrade", 1)
									TogPowercallStateForVeh(veh, false)
									count_bcast_timer = delay_bcast_timer
								else
									if IsVehicleSirenOn(veh) then
										TriggerEvent("art_vehcontrol:ELSClick", "Upgrade", 0.7)
										TogPowercallStateForVeh(veh, true)
										count_bcast_timer = delay_bcast_timer
									end
								end
								
							end

							if state_drsiren[veh] > 0 then
								if IsDisabledControlJustReleased(0, 80) or IsDisabledControlJustReleased(0, 81) then
									if IsVehicleSirenOn(veh) then
										local cstate = state_drsiren[veh]
										local nstate = 1
										TriggerEvent("art_vehcontrol:ELSClick", "Upgrade", 0.7)
										if cstate == 1 then
											nstate = 2
										elseif cstate == 2 then
											nstate = 3
										else	
											nstate = 1
										end
										SetdrSirenStateForVeh(veh, nstate)
										count_bcast_timer = delay_bcast_timer
									end
								end
							end

							if state_drsiren[veh] < 1 then
								if IsDisabledControlPressed(0, 80) or IsDisabledControlPressed(0, 81) then
									actv_manu = true
								else
									actv_manu = false
								end
							else
								actv_manu = false
							end

							if IsDisabledControlPressed(0, 86) then
								actv_horn = true
							else
								actv_horn = false
							end
						
						end

						local hmanu_state_new = 0
						if actv_horn == true and actv_manu == false then
							hmanu_state_new = 1
						elseif actv_horn == false and actv_manu == true then
							hmanu_state_new = 2
						elseif actv_horn == true and actv_manu == true then
							hmanu_state_new = 3
						end
						if hmanu_state_new == 1 then
							if not useFiretruckSiren(veh) then
								if state_drsiren[veh] > 0 and actv_drsrnmute_temp == false then
									srntone_temp = state_drsiren[veh]
									SetdrSirenStateForVeh(veh, 0)
									actv_drsrnmute_temp = true
								end
							end

						else
							if not useFiretruckSiren(veh) then
								if actv_drsrnmute_temp == true then
									SetdrSirenStateForVeh(veh, srntone_temp)
									actv_drsrnmute_temp = false
								end
							end
						end
						if state_airmanu[veh] ~= hmanu_state_new then
							SetAirManuStateForVehClick(veh, hmanu_state_new)
							count_bcast_timer = delay_bcast_timer
						end	
					end

					if GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 21 then

						if not IsPauseMenuActive() then

							if IsDisabledControlJustReleased(0, 157) then
								local cstate = state_indic[veh]
								if cstate == ind_state_l then
									state_indic[veh] = ind_state_o
									actv_ind_timer = false
								else
									state_indic[veh] = ind_state_l
									actv_ind_timer = true
								end
								TogIndicStateForVeh(veh, state_indic[veh])
								count_ind_timer = 0
								count_bcast_timer = delay_bcast_timer	

							elseif IsDisabledControlJustReleased(0, 158) then
								local cstate = state_indic[veh]
								if cstate == ind_state_r then
									state_indic[veh] = ind_state_o
									actv_ind_timer = false
								else
									state_indic[veh] = ind_state_r
									actv_ind_timer = true
								end
								TogIndicStateForVeh(veh, state_indic[veh])
								count_ind_timer = 0
								count_bcast_timer = delay_bcast_timer

							elseif IsControlJustReleased(0, 160) then
								if GetLastInputMethod(0) then
									local cstate = state_indic[veh]
									if cstate == ind_state_h then
										state_indic[veh] = ind_state_o
									else
										state_indic[veh] = ind_state_h
									end
									TogIndicStateForVeh(veh, state_indic[veh])
									actv_ind_timer = false
									count_ind_timer = 0
									count_bcast_timer = delay_bcast_timer
								end
							end
						end

						if count_bcast_timer > delay_bcast_timer then
							count_bcast_timer = 0

							if GetVehicleClass(veh) == 18 then
								TriggerServerEvent("dyr_TogDfltSrnMuted_s", dsrn_mute)
								TriggerServerEvent("dyr_SetdrSirenState_s", state_drsiren[veh])
								TriggerServerEvent("dyr_TogPwrcallState_s", state_pwrcall[veh])
								TriggerServerEvent("dyr_SetAirManuState_s", state_airmanu[veh])
								TriggerEvent("Setdyr_SetAirManuState_clientclick")
							end

							TriggerServerEvent("dyr_TogIndicState_s", state_indic[veh])
						else
							count_bcast_timer = count_bcast_timer + 1
						end
					end
				end
			end
			
		Citizen.Wait(0)
	end
end)