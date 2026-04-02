RegisterServerEvent("dyr_TogDfltSrnMuted_s")
AddEventHandler("dyr_TogDfltSrnMuted_s", function(toggle)
	TriggerClientEvent("dyr_TogDfltSrnMuted_c", -1, source, toggle)
end)

RegisterServerEvent("dyr_SetarSirenState_s")
AddEventHandler("dyr_SetarSirenState_s", function(newstate)
	TriggerClientEvent("dyr_SetarSirenState_c", -1, source, newstate)
end)

RegisterServerEvent("dyr_TogPwrcallState_s")
AddEventHandler("dyr_TogPwrcallState_s", function(toggle)
	TriggerClientEvent("dyr_TogPwrcallState_c", -1, source, toggle)
end)

RegisterServerEvent("dyr_SetAirManuState_s")
AddEventHandler("dyr_SetAirManuState_s", function(newstate)
	TriggerClientEvent("dyr_SetAirManuState_c", -1, source, newstate)
end)

RegisterServerEvent("dyr_TogIndicState_s")
AddEventHandler("dyr_TogIndicState_s", function(newstate)
	TriggerClientEvent("dyr_TogIndicState_c", -1, source, newstate)
end)
