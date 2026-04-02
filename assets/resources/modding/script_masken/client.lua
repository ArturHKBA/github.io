qb								= nil
playerGroup = nil
Config = {}

local incamera = false


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


function destorycam() 	
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    TriggerServerEvent('barbershop:removeposition')
end



function NeoSaveSkin()
	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin
	end)
	TriggerEvent('skinchanger:getSkin', function(skin)
	TriggerServerEvent('Neo:saveMask', skin)  
	end)
end 

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end 

local ClosesShops = {
    Base = { Header = {"Maskenladen", "Maskenladen"}, Color = {color_black}, HeaderColor = {255, 255, 255}, Title = "Willkommen!", Blocked = true },
    Data = { currentMenu = "Masken auswählen:", "Test" },
    Events = {  
        onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
			if btn.name == "~g~Maske kaufen" then  

				TaskPedSlideToCoord(PlayerPedId(), -1339.08, -1277.23, 4.88)
				DisplayRadar(true)                                           
				destorycam() 
				PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
				SetEntityInvincible(GetPlayerPed(-1), false)   
				FreezeEntityPosition(GetPlayerPed(-1), false)
				TriggerServerEvent('Neo:lebest')
				NeoSaveSkin()
				TriggerServerEvent('Neo:saveMask') 
				qb.ShowNotification("~g~Du hast die Maske\n~s~für ~s~$200~g~ gekauft!") 
				CloseMenu(true) 
				DrawSub('', 1)
				qb.TriggerServerCallback('qb_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
				end)

			elseif btn.name == "~r~Kauf abbrechen" then	
				 
				TaskPedSlideToCoord(PlayerPedId(), -1337.08, -1276.23, 4.88, 105)
			
				DisplayRadar(true) 
				TriggerServerEvent('Neo:lebest')			
				destorycam() 
				PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
				SetEntityInvincible(GetPlayerPed(-1), false)   
				FreezeEntityPosition(GetPlayerPed(-1), false)
				CloseMenu(true)
				DrawSub('', 1)
				qb.TriggerServerCallback('qb_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
				end)
				
			end
		end,  
		onSlide = function(menuData, currentButton, currentSlt, PMenu)
			
			local currentMenu, ped = menuData.currentMenu, GetPlayerPed(-1)
			if currentMenu == "Masken auswählen:" then  
				if currentSlt ~= 1 then return end
				local currentButton = currentButton.slidenum - 1
                mask1 = currentButton
				TriggerEvent('skinchanger:change', 'mask_1', mask1)
			end
			
			if currentMenu == "varianten: " then
				if currentSlt ~= 1 then return end 
				local currentButton = currentButton.slidenum - 1
                mask2 = currentButton
				TriggerEvent('skinchanger:change', 'mask_2', mask2)
			end
		end,
},
	Menu = {
		["Masken auswählen:"] = {
			b = {
				{name = "Maske auswählen:", slidemax = 130},
				{name = "varianten: ", ask = ">", askX = true},
				{name = "~g~Maske kaufen", ask = ">", askX = true},
				{name = "~r~Kauf abbrechen", ask = ">", askX = true}
			}
		}, 
		["Maske auswählen: "] = {
			b = {
				{name = "Maske auswählen:", slidemax = 130},
			}
		},
		["varianten: "] = {
			b = {
				{name = "varianten:", slidemax = 10},
			}
		},
	}
}

local listClotheshop = {
	{x = -1336.40, y = -1276.50, z = 4.64}
}


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(listClotheshop) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, listClotheshop[k].x, listClotheshop[k].y, listClotheshop[k].z)

            if dist <= 1.2 then
                qb.ShowHelpNotification("Drücke ~INPUT_TALK~ um das Maskenmenü zu ~g~öffnen.")
				if IsControlJustPressed(1,51) then 	
					PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)		
					SetEntityInvincible(GetPlayerPed(-1), true) 
		        	FreezeEntityPosition(GetPlayerPed(-1), true) 									
					SetEntityCoords(GetPlayerPed(-1), -1332.9627, -1277.15600, 4.5238-0.98, 0.0, 0.0, 0.0, 10)
					SetEntityHeading(GetPlayerPed(-1), 83.92835543)
					DisplayRadar(false) 
					local cam = {}				
					Citizen.Wait(1)
					cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)	
                    SetCamCoord(cam, -1328.06, -1267.10, 5.123, 0.0, 0.0, 200.455696105957, 15.0, false, 0)
                    RenderScriptCams(1000, 1000, 1000, 1000, 1000)
					PointCamAtCoord(cam, -1331.9627, -1267.15600, 5.6238)    
					-- Godmode              								 				
					DrawSub('~g~Du bist nun unantastbar!', 999999999)					
                    CreateMenu(ClosesShops) 
				end
            end
        end
    end  
end)
   
local blips = { {title="Maskenladen", colour=57, id=362, x = -1336.40, y = -1276.50, z = 4.64} } Citizen.CreateThread(function() for _, info in pairs(blips) do info.blip = AddBlipForCoord(info.x, info.y, info.z) SetBlipSprite(info.blip, info.id) SetBlipDisplay(info.blip, 4) SetBlipScale(info.blip, 0.8) SetBlipColour(info.blip, info.colour) SetBlipAsShortRange(info.blip, true) BeginTextCommandSetBlipName("STRING") AddTextComponentString(info.title) EndTextCommandSetBlipName(info.blip) end end) 
print("^0======================================================================^7") print("^0[^4Author^0] ^7:^0 ArturHKBA^7") print("^0[^2Lizenz^0] ^7:^0 ^5Dayrise.de^7") print("^0[^1Für^0] ^7:^0 ^5DayriseRP5^7") print("^0======================================================================^7") 