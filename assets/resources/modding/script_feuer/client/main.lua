Version = GetResourceMetadata(GetCurrentResourceName(), "version")

TriggerEvent("chat:addTemplate", "feuer_script", '<div style="text-indent: 0 !important; padding: 0.5vw; margin: 0.05vw; color: rgba(255,255,255,0.9);background-color: rgba(250,26,56, 0.8); border-radius: 4px;"><b>{0}</b> {1} </div>')

TriggerEvent('chat:addSuggestion', '/startefeuer', 'Feuer spawn', {
	{
		name = "verteilen",
		help = "Wie oft kann sich das Feuer ausbreiten?" 
	},
	{
		name = "chance",
		help = "Wie schnell breitet sich das Feuer aus?"
	},
	{
		name = "dispatch",
		help = "true oder false"
	},
	{
		name = "dispatchMessage",
		help = "Legt eine benutzerdefinierte Versandnachricht fest (leer lassen, um sie automatisch zu generieren)"
	}
})

TriggerEvent('chat:addSuggestion', '/feuerstop', 'Feuer wird gestoppt', {
	{
		name = "index",
		help = "Feuer Index"
	}
})

TriggerEvent('chat:addSuggestion', '/allefeuerstoppen', 'Feuer wird gestoppt')

TriggerEvent('chat:addSuggestion', '/registerscenario', 'Neue Feuer konfiguration')

TriggerEvent('chat:addSuggestion', '/flammen', 'Flammen werden hinzugefügt', {
	{
		name = "scenarioID",
		help = "Das Szenario"
	},
	{
		name = "spread",
		help = "Wie oft kann sich die Flamme ausbreiten?"
	},
	{
		name = "chance",
		help = "0-100 chance?"
	}
})

TriggerEvent('chat:addSuggestion', '/flammenentfernen', 'Entfernt flammen', {
	{
		name = "scenarioID",
		help = "Feuer ID"
	},
	{
		name = "flammeID",
		help = "Flammen ID"
	}
})

TriggerEvent('chat:addSuggestion', '/scenarioentfernen', 'Szene wird gelöscht', {
	{
		name = "scenarioID",
		help = "Feuer ID"
	}
})

TriggerEvent('chat:addSuggestion', '/scenariostarte', 'Szene wird gestartet', {
	{
		name = "scenarioID",
		help = "Feuer ID"
	},
	{
		name = "triggerDispatch",
		help = "true / false"
	}
})

TriggerEvent('chat:addSuggestion', '/scenariostoppen', 'Szenario wird gestoppt', {
	{
		name = "scenarioID",
		help = "Feuer ID"
	}
})

TriggerEvent('chat:addSuggestion', '/feuerwhitelist', 'Feuer Whitelist', {
	{
		name = "action",
		help = "add / remove"
	},
	{
		name = "playerID",
		help = "The player's server ID"
	}
})

TriggerEvent('chat:addSuggestion', '/feuerladen', 'Whitelist laden')

/*TriggerEvent('chat:addSuggestion', '/feuerdispatch', 'Verwaltet WHITELIST', {
	{
		name = "action",
		help = "hinzufügen / entfernen / scenario"
	},
	{
		name = "playerID / scenarioID",
		help = "Die Server/Szenario ID des Spielers"
	},
	{
		name = "dispatchMessage",
		help = "Legt eine benutzerdefinierte Nachricht für das Szenario fest"
	}
})*/

TriggerEvent('chat:addSuggestion', '/erinnern', 'GPS', {
	{
		name = "dispatchID",
		help = "The identifier"
	}
})

TriggerEvent('chat:addSuggestion', '/löschen', 'Entfernt.', {
	{
		name = "dispatchID",
		help = "Dispatch blip"
	}
})

TriggerEvent('chat:addSuggestion', '/randomfeuer', 'Random feuer spawner', {
	{
		name = "action",
		help = "hinzufügen / entfernen / aktivieren / deaktivieren"
	},
	{
		name = "u52",
		help = "Scenario ID zurücksetzen."
	}
})

TriggerEvent('chat:addSuggestion', '/setscenarioschwierigkeit', 'Schwierigkeit', {
	{
		name = "scenarioID",
		help = "Scenario ID"
	},
	{
		name = "Schwierigkeit",
		help = "Schwierigkeit / 0 für DEFAULT"
	}
})

RegisterNetEvent('playerSpawned')
AddEventHandler(
	'playerSpawned',
	function()
		print("Requested synchronization..")
		TriggerServerEvent('feuerManager:requestSync')
	end
)

RegisterNetEvent('onClientResourceStart')
AddEventHandler(
	'onClientResourceStart',
	function(resourceName)
		if resourceName == GetCurrentResourceName() then
			TriggerServerEvent('feuerManager:checkWhitelist')

			if Config.Dispatch.toneSources then
				while not RequestScriptAudioBank('toneaudio/feuer_script_alarm', false) do
					Citizen.Wait(10)
				end
			end
		end
	end
)

AddEventHandler(
	'onClientResourceStop',
	function(resourceName)
		if resourceName == GetCurrentResourceName() then
			ReleaseScriptAudioBank('toneaudio/feuer_script_alarm')
		end
	end
)

RegisterCommand(
	'remindme',
	function(source, args, rawCommand)
		local dispatchNumber = tonumber(args[1])
		if not dispatchNumber then
			sendMessage("Invalid argument.")
			return
		end

		local success = Dispatch:remind(dispatchNumber)

		if not success then
			sendMessage("Couldn't find the specified dispatch.")
			return
		end
	end,
	false
)

RegisterCommand(
	'cleardispatch',
	function(source, args, rawCommand)
		Dispatch:clear(tonumber(args[1]))
	end,
	false
)

RegisterCommand(
	'startfeuer',
	function(source, args, rawCommand)
		local maxSpread = tonumber(args[1])
		local probability = tonumber(args[2])
		local triggerDispatch = args[3] == "true"

		table.remove(args, 1)
		table.remove(args, 1)
		table.remove(args, 1)

		local dispatchMessage = next(args) and table.concat(args, " ") or nil

		TriggerServerEvent('feuerManager:command:startfeuer', GetEntityCoords(PlayerPedId()), maxSpread, probability, triggerDispatch, dispatchMessage)
	end,
	false
)

RegisterCommand(
	'registerscenario',
	function(source, args, rawCommand)
		local coords = nil

		local x = tonumber(args[1])
		local y = tonumber(args[2])
		local z = tonumber(args[3])

		if x and y and z then
			coords = vector3(x, y, z)
		end

		TriggerServerEvent('feuerManager:command:registerscenario', coords or GetEntityCoords(PlayerPedId()))
	end,
	false
)

RegisterCommand(
	'addflamme',
	function(source, args, rawCommand)
		local scenarioID = tonumber(args[1])
		local spread = tonumber(args[2])
		local chance = tonumber(args[3])

		local coords = nil

		local x = tonumber(args[4])
		local y = tonumber(args[5])
		local z = tonumber(args[6])

		if x and y and z then
			coords = vector3(x, y, z)
		end

		if scenarioID and spread and chance then
			TriggerServerEvent('feuerManager:command:addflamme', scenarioID, coords or GetEntityCoords(PlayerPedId()), spread, chance)
		end
	end,
	false
)

RegisterCommand(
	'registerfeuer',
	function(source, args, rawCommand)
		ExecuteCommand("registerscenario" .. rawCommand:sub(13))
	end,
	false
)

RegisterCommand(
	'removeregisteredfeuer',
	function(source, args, rawCommand)
		ExecuteCommand("removescenario" .. rawCommand:sub(21))
	end,
	false
)

RegisterCommand(
	'startregisteredfeuer',
	function(source, args, rawCommand)
		ExecuteCommand("startscenario" .. rawCommand:sub(20))
	end,
	false
)

RegisterCommand(
	'stopregisteredfeuer',
	function(source, args, rawCommand)
		ExecuteCommand("stopscenario" .. rawCommand:sub(19))
	end,
	false
)

RegisterNetEvent('feuerClient:synchronizeflamme')
AddEventHandler(
	'feuerClient:synchronizeflamme',
	function(feuer)
		syncInProgress = true
		feuer:removeAll(
			function()
				for k, v in pairs(feuer) do
					for _k, _v in ipairs(v) do
						feuer:createflamme(k, _k, _v.c)
					end
				end
				syncInProgress = false
			end
		)
	end
)

RegisterNetEvent('feuerClient:removefeuer')
AddEventHandler(
	'feuerClient:removefeuer',
	function(feuerIndex)
		while syncInProgress do
			Citizen.Wait(10)
		end
		syncInProgress = true
		feuer:remove(feuerIndex)
		syncInProgress = false
	end
)

RegisterNetEvent('feuerClient:removeAllfeuer')
AddEventHandler(
	'feuerClient:removeAllfeuer',
	function()
		while syncInProgress do
			Citizen.Wait(10)
		end
		syncInProgress = true
		feuer:removeAll(
			function()
				syncInProgress = false
			end
		)
	end
)

RegisterNetEvent("feuerClient:removeflamme")
AddEventHandler(
    "feuerClient:removeflamme",
	function(feuerIndex, flammeIndex)
		while syncInProgress do
			Citizen.Wait(10)
		end
		syncInProgress = true
		feuer:removeflamme(feuerIndex, flammeIndex)
		syncInProgress = false
    end
)

RegisterNetEvent("feuerClient:createflamme")
AddEventHandler(
    "feuerClient:createflamme",
	function(feuerIndex, flammeIndex, coords)
		while syncInProgress do
			Citizen.Wait(10)
		end
		syncInProgress = true
		feuer:createflamme(feuerIndex, flammeIndex, coords)
		syncInProgress = false
    end
)

if Config.Dispatch.enabled == true then
	RegisterNetEvent('fd:dispatch')
	AddEventHandler(
		'fd:dispatch',
		function(coords)
			local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
			local streetName = GetStreetNameFromHashKey(streetName)
			local text = ("feuer near %s."):format((crossingRoad > 0) and streetName .. " / " .. GetStreetNameFromHashKey(crossingRoad) or streetName)
			TriggerServerEvent('feuerDispatch:create', text, coords)
		end
	)
end

RegisterNetEvent('feuerClient:createDispatch')
AddEventHandler(
	'feuerClient:createDispatch',
	function(dispatchNumber, coords)
		Dispatch:create(dispatchNumber, coords)
	end
)

RegisterNetEvent('feuerClient:playTone')
AddEventHandler(
	'feuerClient:playTone',
	function()
		Dispatch:playTone()
	end
)
