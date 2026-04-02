local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local testQTE       			= 0
qb 			    			= nil
local test_poochQTE 			= 0
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

Citizen.CreateThread(function()
	while qb == nil do
		TriggerEvent('qb:getSharedObject', function(obj) qb = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('qb_farmkürbis:hasEnteredMarker', function(zone)

	qb.UI.Menu.CloseAll()
	
	if zone == 'CatchKürbis' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('carry_for_leaves')
		CurrentActionData = {}
	elseif zone == 'KürbisSaft' then
		if testQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('take_kürbis_saft')
			CurrentActionData = {}
		end
	elseif zone == 'SellKürbisSaft' then
		if test_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('sell_kürbis_saft')
			CurrentActionData = {}
		end
	end
end)

AddEventHandler('qb_farmkürbis:hasExitedMarker', function(zone)
	CurrentAction = nil
	qb.UI.Menu.CloseAll()

	if zone == 'CatchKürbis' then
		TriggerServerEvent('qb_farmkürbis:stopHarvesttest')
	elseif zone == 'KürbisSaft' then
	TriggerServerEvent('qb_farmkürbis:stopTransformtest')
	elseif zone == 'SellKürbisSaft' then
		TriggerServerEvent('qb_farmkürbis:stopSelltest')
	end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

	end
end)

if Config.ShowBlips then

	Citizen.CreateThread(function()
		for k,v in pairs(Config.Zones) do
			local blip = AddBlipForCoord(v.x, v.y, v.z)

			SetBlipSprite (blip, v.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour (blip, v.color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
		end
	end)
end


RegisterNetEvent('qb_farmkürbis:ReturnInventory')
AddEventHandler('qb_farmkürbis:ReturnInventory', function(testNbr, testpNbr, jobName, currentZone)
	testQTE			= testNbr
	test_poochQTE	= testpNbr
	myJob			= jobName
	TriggerEvent('qb_farmkürbis:hasEnteredMarker', currentZone)
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerServerEvent('qb_farmkürbis:GetUserInventory', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('qb_farmkürbis:hasExitedMarker', lastZone)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			qb.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) and IsPedOnFoot(PlayerPedId()) then
				if CurrentAction == 'CatchKürbis' then
					TriggerServerEvent('qb_farmkürbis:startHarvesttest')
				elseif CurrentAction == 'KürbisSaft' then
					TriggerServerEvent('qb_farmkürbis:startTransformtest')
				elseif CurrentAction == 'SellKürbisSaft' then
					TriggerServerEvent('qb_farmkürbis:startSelltest')
				end
				
				CurrentAction = nil
			end
		end
	end
end)
