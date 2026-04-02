qb = nil

Citizen.CreateThread(function()
	while qb == nil do
		TriggerEvent('qb:getSharedObject', function(obj) qb = obj end)
		Citizen.Wait(0)
	end 
	while qb.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = qb.GetPlayerData()
end)

RegisterNetEvent('qb:playerLoaded')
AddEventHandler('qb:playerLoaded', function(xPlayer)
	qb.PlayerData = xPlayer
end)

RegisterNetEvent('qb:setJob')
AddEventHandler('qb:setJob', function(job)
	qb.PlayerData.job = job
end)

-- Text in 3D:

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

local insideMarker = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		
		if (qb.PlayerData.job and qb.PlayerData.job.name == Config.PoliceDatabaseName) then
		for k,v in pairs(Config.LagerZones) do
			for i = 1, #v.Pos, 1 do
				local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				if (distance < 7.0) and insideMarker == false then
					DrawMarker(Config.LagerMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.975, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.LagerMarkerScale.x, Config.LagerMarkerScale.y, Config.LagerMarkerScale.z, Config.LagerMarkerColor.r,Config.LagerMarkerColor.g,Config.LagerMarkerColor.b,Config.LagerMarkerColor.a, false, true, 2, true, false, false, false)						
				end
				if (distance < 1.0) and insideMarker == false then
					DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.LagerDraw3DText)
					if IsControlJustPressed(0, Config.KeyToOpenLager) then
						qb.TriggerServerCallback('qb_policeLager:getWeaponState', function(stock) end)
						PoliceLager()
						insideMarker = true
						Citizen.Wait(500)
					end
				end
			end
		end

		for k,v in pairs(Config.SchutzwesteZones) do
			for i = 1, #v.Pos, 1 do
				local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				if (distance < 7.0) and insideMarker == false then
				DrawMarker(Config.SchutzwesteMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.975, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.SchutzwesteMarkerScale.x, Config.SchutzwesteMarkerScale.y, Config.SchutzwesteMarkerScale.z, Config.SchutzwesteMarkerColor.r,Config.SchutzwesteMarkerColor.g,Config.SchutzwesteMarkerColor.b,Config.SchutzwesteMarkerColor.a, false, true, 2, true, false, false, false)						
				end
				if (distance < 1.0 ) and insideMarker == false then
					DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.SchutzwesteDraw3DText)
					if IsControlJustPressed(0, Config.KeyToOpenSchutzweste) then
						SchutzwesteMenu()
						insideMarker = true
						Citizen.Wait(500)
					end
				end
			end
		end

		for k,v in pairs(Config.ZubehoerZones) do
			for i = 1, #v.Pos, 1 do
				local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				if (distance < 7.0) and insideMarker == false then
				DrawMarker(Config.ZubehoerMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.975, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.ZubehoerMarkerScale.x, Config.ZubehoerMarkerScale.y, Config.ZubehoerMarkerScale.z, Config.ZubehoerMarkerColor.r,Config.ZubehoerMarkerColor.g,Config.ZubehoerMarkerColor.b,Config.ZubehoerMarkerColor.a, false, true, 2, true, false, false, false)						
				end
				if (distance < 1.0 ) and insideMarker == false then
					DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.ZubehoerDraw3DText)
					if IsControlJustPressed(0, Config.KeyToOpenZubehoer) then
						ZubehoerMenu()
						insideMarker = true
						Citizen.Wait(500)
					end
				end
			end
		end
		end
		
	end
end)

PoliceLager = function()
	local elements = {
		{ label = Config.WeaponStorage, action = "weapon_menu" },
	}
	
	if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 3) then
        qb.Streaming.RequestAnimDict('mini@repair', function()
            TaskPlayAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
        end)
    end
	
	if tonumber(qb.PlayerData.job.grade) >= Config.RestockGrade then
		table.insert(elements, {label = Config.RestockWeapon, action = "restock_menu"})
	end
	
	qb.UI.Menu.Open('default', GetCurrentResourceName(), "qb_policeLager_main_menu",
		{
			title    = Config.PoliceLagerTitle,
			align    = "top-left",
			elements = elements
		},
	function(data, menu)
		local action = data.current.action

		if action == "weapon_menu" then
			WeaponMenu()
		elseif action == "restock_menu" then
			RestockMenu()
		end	
	end, function(data, menu)
		menu.close()
		insideMarker = false
		ClearPedSecondaryTask(GetPlayerPed(-1))
	end, function(data, menu)
	end)
end

function WeapSplit(inputstr, del)
    if del == nil then
            del = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..del.."]+)") do
            table.insert(t, str)
    end
    return t
end

function PedHasWeapon(hash)
	for k,v in pairs(qb.GetPlayerData().loadout) do
		if v.name == hash then
			return true
		end
	end
	return false
end

-- Waffen Menu:

WeaponMenu = function()
	local storage = nil
	local elements = {}
	local ped = GetPlayerPed(-1)
	qb.TriggerServerCallback("qb_policeLager:getWeaponState", function(stock)	
	local weapons = WeapSplit(stock[1].weapons, ", ")
	
	for k,v in pairs(Config.WeaponsInLager) do
		local takenOut = false
		for z,x in pairs(weapons) do
			if x == v.weaponHash then
				takenOut = true
				table.insert(elements,{label = v.label .. " --- "..('<span style="color:red;">%s</span>'):format("Taken out"), weaponhash = v.weaponHash, lendable = false})
			end
		end
		if takenOut == false then
			table.insert(elements,{label = v.label .. " --- "..('<span style="color:green;">%s</span>'):format("In Stock"), weaponhash = v.weaponHash, lendable = true})
		end
	end
	
	qb.UI.Menu.Open('default', GetCurrentResourceName(), "qb_policeLager_weapon_storage",
		{
			title    = Config.WeaponStorageTitle,
			align    = "top-left",
			elements = elements
		},
	function(data, menu)
		menu.close()
		
		if data.current.lendable == true then
			local giveAmmo = (GetWeaponClipSize(GetHashKey(data.current.weaponhash)) > 0)
			if data.current.weaponhash == "WEAPON_STUNGUN" then
				giveAmmo = false
			end
			TriggerServerEvent("qb_policeLager:weaponTakenOut", data.current.weaponhash, giveAmmo)
		elseif PedHasWeapon(data.current.weaponhash) then
			local giveAmmo = (GetWeaponClipSize(GetHashKey(data.current.weaponhash)) > 0)
			if data.current.weaponhash == "WEAPON_STUNGUN" then
				giveAmmo = false
			end
			TriggerServerEvent("qb_policeLager:weaponInStock", data.current.weaponhash,GetAmmoInPedWeapon(ped,GetHashKey(data.current.weaponhash)),giveAmmo)
		else
			qb.ShowNotification(Config.ContactSuperVisor)
		end
		
	end, function(data, menu)
		menu.close()
	end, function(data, menu)
	end)
	end)
end

-- Auffüllen:

function RestockMenu()
	local police = {}
	local elements = {}
	qb.TriggerServerCallback("qb_policeLager:checkPoliceOnline", function(list) police = list end)
	Citizen.Wait(250)
	for k,v in pairs(police) do
		if v.job.name == Config.PoliceDatabaseName then
			table.insert(elements, {label = v.name, id = v.id})
		end
	end
	if next(elements) ~= nil then
		qb.UI.Menu.Open('default', GetCurrentResourceName(), "qb_policeLager_restock_menu",
			{
				title    = Config.RestockWeaponTitle,
				align    = "top-left",
				elements = elements
			},
		function(data, menu)
			menu.close()
			exports['progressBars']:startUI((Config.RestockTimer * 1000), Config.Progress1)
			Citizen.Wait((Config.RestockTimer * 1000))
			TriggerServerEvent("qb_policeLager:restockWeapons",data.current.id)
		end, function(data, menu)
			
			menu.close()
		end, function(data, menu)
		end)
	else
		qb.ShowNotification(Config.NoPoliceOnline)
	end
end

-- Schutzweste Menu:

function SchutzwesteMenu()
	local ped = GetPlayerPed(-1)
	local elements = {}
	
	if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 3) then
        qb.Streaming.RequestAnimDict('mini@repair', function()
            TaskPlayAnim(GetPlayerPed(-1), 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 49, 0, 0, 0, 0)
        end)
    end
	
	qb.UI.Menu.Open('default', GetCurrentResourceName(), "qb_policeLager_Schutzweste_menu",
			{
				title    = Config.PoliceSchutzwesteTitle,
				align    = "top-left",
				elements = {
					{label = Config.Vest1, armor = 25},
					{label = Config.Vest2, armor = 50},
					{label = Config.Vest3, armor = 75},
					{label = Config.Vest4, armor = 100},
					{label = Config.RemoveVest, armor = 0},
			}
			},
		function(data, menu)
			SetPedArmour(ped,data.current.armor)
			if data.current.armor == 0 then
				exports['progressBars']:startUI((Config.RemoveVestTimer * 1000), Config.Progress2)
				Citizen.Wait((Config.RemoveVestTimer * 1000))
				SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 0, 0)
			else
				exports['progressBars']:startUI((Config.WearVestTimer * 1000), Config.Progress3)
				Citizen.Wait((Config.RemoveVestTimer * 1000))
				if data.current.armor == 25 then
					SetPedComponentVariation(ped, Config.VestVariation1.componentId, Config.VestVariation1.drawableId, Config.VestVariation1.textureId, Config.VestVariation1.paletteId)
				elseif data.current.armor == 50 then
					SetPedComponentVariation(ped, Config.VestVariation2.componentId, Config.VestVariation2.drawableId, Config.VestVariation2.textureId, Config.VestVariation2.paletteId)
				elseif data.current.armor == 75 then
					SetPedComponentVariation(ped, Config.VestVariation3.componentId, Config.VestVariation3.drawableId, Config.VestVariation3.textureId, Config.VestVariation3.paletteId)
				elseif data.current.armor == 100 then
					SetPedComponentVariation(ped, Config.VestVariation4.componentId, Config.VestVariation4.drawableId, Config.VestVariation4.textureId, Config.VestVariation4.paletteId)
				end
			end
						
			menu.close()
			insideMarker = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
		end, function(data, menu)
			menu.close()
			insideMarker = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
		end, function(data, menu)
		end)
end

-- Zubehör:

function ZubehoerMenu()
	local elements = {}
	local ped = GetPlayerPed(-1)
			
	for k,v in pairs(Config.WeaponsInLager) do
		if v.Zubehoer == true then
			table.insert(elements,{label = v.label, weaponhash = v.weaponHash, type = v.type, Zubehoer = v.Zubehoer, flashlight = v.flashlight, scope = v.scope, suppressor = v.suppressor})
		end
	end

	qb.UI.Menu.Open('default', GetCurrentResourceName(), "qb_policeLager_Zubehoer_menu",
		{
			title    = Config.ChooseWeaponTitle,
			align    = "top-left",
			elements = elements
		},
	function(data, menu)
			if data.current.weaponhash == data.current.weaponhash then
				if GetSelectedPedWeapon(ped) == GetHashKey(data.current.weaponhash) then
					ListOfZubehoer(data.current.type, data.current.label, data.current.weaponhash, data.current.Zubehoer, data.current.flashlight, data.current.scope, data.current.suppressor)
				else
					qb.ShowNotification(Config.WeaponMustBeInHand)
				end
			end	
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

-- Zubehör Menu:

function ListOfZubehoer(type,name,weaponhash,Zubehoer,flashlight,scope,suppressor)
	local elements = {}
	
	local ped = GetPlayerPed(-1)
			
	if flashlight then
		local state = HasPedGotWeaponComponent(ped, weaponhash, flashlight)
		local text
		
		if state then
			text = "Taschenlampe: "..('<span style="color:green;">%s</span>'):format("An")
		else
			text = "Taschenlampe: "..('<span style="color:red;">%s</span>'):format("Aus")
		end
		
		table.insert(elements, {
			label = text,
			value = flashlight,
			state = not state
		})
	end
			
	if scope then
		local state = HasPedGotWeaponComponent(ped, weaponhash, scope)
		local text
		
		if state then
			text = "Zielfernrohr: "..('<span style="color:green;">%s</span>'):format("An")
		else
			text = "Zielfernrohr: "..('<span style="color:red;">%s</span>'):format("Aus")
		end
		
		table.insert(elements, {
			label = text,
			value = scope,
			state = not state
		})
	end
			
	if suppressor then
		local state = HasPedGotWeaponComponent(ped, weaponhash, suppressor)
		local text
		
		if state then
			text = "Schalldämpfer: "..('<span style="color:green;">%s</span>'):format("An")
		else
			text = "Schalldämpfer: "..('<span style="color:red;">%s</span>'):format("Aus")
		end
		
		table.insert(elements, {
			label = text,
			value = suppressor,
			state = not state
		})
	end

	qb.UI.Menu.Open('default', GetCurrentResourceName(), 'policeLager_list_of_Zubehoer', {
		title    = Config.ZubehoerTitle,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local newData = data.current
		
		if data.current.value == flashlight then
			if data.current.state then
				newData.label = "Taschenlampe: "..('<span style="color:green;">%s</span>'):format("An")
				GiveWeaponComponentToPed(ped, weaponhash, data.current.value)
				qb.ShowNotification(string.format(Config.FlashlightEquipped,name))
			else
				newData.label = "Taschenlampe: "..('<span style="color:red;">%s</span>'):format("Aus")
				RemoveWeaponComponentFromPed(ped, weaponhash, data.current.value)
				qb.ShowNotification(string.format(Config.FlashlightRemove,name))
			end
		elseif data.current.value == scope then
			if data.current.state then
				newData.label = "Zielfernrohr: "..('<span style="color:green;">%s</span>'):format("An")
				GiveWeaponComponentToPed(ped, weaponhash, data.current.value)
				qb.ShowNotification(string.format(Config.ScopeEquipped,name))
			else
				newData.label = "Zielfernrohr: "..('<span style="color:red;">%s</span>'):format("Aus")
				RemoveWeaponComponentFromPed(ped, weaponhash, data.current.value)
				qb.ShowNotification(string.format(Config.ScopeRemove,name))
			end
		elseif data.current.value == suppressor then
			if data.current.state then
				newData.label = "Schalldämpfer: "..('<span style="color:green;">%s</span>'):format("An")
				GiveWeaponComponentToPed(ped, weaponhash, data.current.value)
				qb.ShowNotification(string.format(Config.SuppressorEquipped,name))
			else
				newData.label = "Schalldämpfer: "..('<span style="color:red;">%s</span>'):format("Aus")
				RemoveWeaponComponentFromPed(ped, weaponhash, data.current.value)
				qb.ShowNotification(string.format(Config.SuppressorRemove,name))
			end
		end
				
		newData.state = not data.current.state
		menu.update({value = data.current.value}, newData)
		menu.refresh()
	end, function(data, menu)
		menu.close()		
	end)
end
