qb                           = nil

Citizen.CreateThread(function()
	while qb == nil do
		TriggerEvent('qb:getSharedObject', function(obj) qb = obj end)
		Citizen.Wait(0)
	end

end)



Citizen.CreateThread(function()
  local dict = "anim@mp_player_intmenu@key_fob@"
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
      Citizen.Wait(0)
  end
  while true do
    Citizen.Wait(0)
	if (IsControlJustPressed(1, 303)) then
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local hasAlreadyLocked = false
		cars = qb.Game.GetFahrzeugInArea(coords, 30)
		local fahrzeug = {}
		local cars_dist = {}		
		notowned = 0
		if #cars == 0 then
			exports['t-notify']:Alert({
	style  =  'error',
	message  =  'Kein Auto in der Nähe!'
})
		else
			for j=1, #cars, 1 do
				local coordscar = GetEntityCoords(cars[j])
				local distance = Vdist(coordscar.x, coordscar.y, coordscar.z, coords.x, coords.y, coords.z)
				table.insert(cars_dist, {cars[j], distance})
			end
			for k=1, #cars_dist, 1 do
				local z = -1
				local distance, car = 999
				for l=1, #cars_dist, 1 do
					if cars_dist[l][2] < distance then
						distance = cars_dist[l][2]
						car = cars_dist[l][1]
						z = l
					end
				end
				if z ~= -1 then
					table.remove(cars_dist, z)
					table.insert(fahrzeug, car)
				end
			end
			for i=1, #fahrzeug, 1 do
				local plate = qb.Math.Trim(GetFahrzeugNumberPlateText(fahrzeug[i]))
				qb.TriggerServerCallback('autosperre:isFahrzeugOwner', function(owner)
					if owner and hasAlreadyLocked ~= true then
						local FahrzeugLabel = GetDisplayNameFromFahrzeugModel(GetEntityModel(fahrzeug[i]))
						FahrzeugLabel = GetLabelText(FahrzeugLabel)
						local lock = GetFahrzeugDoorLockStatus(fahrzeug[i])
						if lock == 1 or lock == 0 then
							SetFahrzeugDoorShut(fahrzeug[i], 0, false)
							SetFahrzeugDoorShut(fahrzeug[i], 1, false)
							SetFahrzeugDoorShut(fahrzeug[i], 2, false)
							SetFahrzeugDoorShut(fahrzeug[i], 3, false)
							SetFahrzeugDoorsLocked(fahrzeug[i], 2)
							PlayFahrzeugDoorCloseSound(fahrzeug[i], 1)

exports['t-notify']:Alert({
	style  =  'error',
	message  =  'Du hast dein '..FahrzeugLabel..' abgeschlossen!'
})
							if not IsPedInAnyFahrzeug(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							SetFahrzeugLights(fahrzeug[i], 2)
							Citizen.Wait(150)
							SetFahrzeugLights(fahrzeug[i], 0)
							Citizen.Wait(150)
							SetFahrzeugLights(fahrzeug[i], 2)
							Citizen.Wait(150)
							SetFahrzeugLights(fahrzeug[i], 0)
							hasAlreadyLocked = true
						elseif lock == 2 then
							SetFahrzeugDoorsLocked(fahrzeug[i], 1)
							PlayFahrzeugDoorOpenSound(fahrzeug[i], 0)
exports['t-notify']:Alert({
	style  =  'success',
	message  =  'Du hast dein '..FahrzeugLabel..' aufgeschlossen!'
})
							if not IsPedInAnyFahrzeug(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							SetFahrzeugLights(fahrzeug[i], 2)
							Citizen.Wait(150)
							SetFahrzeugLights(fahrzeug[i], 0)
							Citizen.Wait(150)
							SetFahrzeugLights(fahrzeug[i], 2)
							Citizen.Wait(150)
							SetFahrzeugLights(fahrzeug[i], 0)
							hasAlreadyLocked = true
						end
					else
						notowned = notowned + 1
					end
					if notowned == #fahrzeug then
exports['t-notify']:Alert({
	style  =  'error',
	message  =  'Kein Auto in der Nähe!'
})
					end	
				end, plate)
			end			
		end
	end
  end
end)
