local qb = nil

TriggerEvent('qb:getSharedObject', function(obj) qb = obj end)

RegisterServerEvent("qb_polizeilager:weaponTakenOut")
AddEventHandler("qb_polizeilager:weaponTakenOut", function(weapon,giveAmmo)
    local xPlayer = qb.GetPlayerFromId(source)
    local id = qb.GetPlayerFromId(source).getIdentifier()
	
    if xPlayer then
    local id = qb.GetPlayerFromId(source).getIdentifier()
		MySQL.Async.fetchAll("SELECT weapons FROM user_polizeilager WHERE identifier='".. id .."'", {}, function(weapRow)
			local addWeaponToDB
			for k,v in pairs(weapRow) do
				addWeaponToDB = v.weapons
			end
			addWeaponToDB = addWeaponToDB .. weapon .. ", "
			MySQL.Async.execute("UPDATE user_polizeilager SET weapons='".. addWeaponToDB .."' WHERE identifier='".. id .."'", {}, function ()
			end)
		end)
        xPlayer.addWeapon(weapon, Config.AmmountOfAmmo)
		local DATE = os.date("%H:%M (%d.%m.%y)")
		local message = "**" ..GetPlayerName(source).. "** [" ..xPlayer.getIdentifier().. "] **|** hat **genommen** " .. qb.GetWeaponLabel(weapon) .. " aus dem Lager **|** " ..DATE
		PerformHttpRequest(""..Config.DiscordWebook.."", function(err, text, headers) end, 'POST', json.encode({username = "Lager", content = message}), { ['Content-Type'] = 'application/json' })
		TriggerClientEvent("qb:showNotification", source, "PLATZHALTER ~y~MENGE~s~ 1x ~r~" .. qb.GetWeaponLabel(weapon).."~r~")
    end
	
end)

RegisterServerEvent("qb_polizeilager:weaponInStock")
AddEventHandler("qb_polizeilager:weaponInStock", function(weapon,ammo,giveAmmo)
    local xPlayer = qb.GetPlayerFromId(source)
    local id = qb.GetPlayerFromId(source).getIdentifier()

    if xPlayer then
        xPlayer.removeWeapon(weapon, ammo)
		MySQL.Async.fetchAll("SELECT weapons FROM user_polizeilager WHERE identifier='".. id .."'", {}, function(weapRow)
			for k,v in pairs(weapRow) do
				removeWeaponFromDB = string.gsub(v.weapons,weapon .. ", ", "")
			end
			MySQL.Async.execute("UPDATE user_polizeilager SET weapons='".. removeWeaponFromDB .."' WHERE identifier='".. id .."'", {}, function ()
			end)
		end)
		local DATE = os.date("%H:%M (%d.%m.%y)")
		local message = "**" ..GetPlayerName(source).. "** [" ..xPlayer.getIdentifier().. "] **|** hat **gepackt** " .. qb.GetWeaponLabel(weapon) .. " zurück in das Lager **|** " ..DATE
		PerformHttpRequest(""..Config.DiscordWebook.."", function(err, text, headers) end, 'POST', json.encode({username = "Lager", content = message}), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("qb:showNotification", source, "PLATZHALTER ~y~MENGE~s~ 1x ~r~" .. qb.GetWeaponLabel(weapon) .. "~r~")
    end
	
end)

qb.RegisterServerCallback("qb_polizeilager:getWeaponState", function(source, cb)
    local id = qb.GetPlayerFromId(source).getIdentifier()
    MySQL.Async.fetchAll('SELECT weapons FROM user_polizeilager WHERE identifier = \"' .. id .. '\"', {}, function(rowsChanged)
        if next(rowsChanged) == nil then
            MySQL.Async.execute("INSERT INTO user_polizeilager (identifier,weapons) VALUES(\"" ..id .. "\",\"\")", {}, function () end)
            cb(nil)
        end
        cb(rowsChanged)
    end)
end)

qb.RegisterServerCallback("qb_polizeilager:checkPoliceOnline", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM user_polizeilager', {}, function(rowsChanged)
        local police = {}
        for k,v in pairs(rowsChanged) do
            local xPlayer = qb.GetPlayerFromIdentifier(v.identifier)
            if xPlayer ~= nil then
                table.insert(police,{id = v.identifier,name = GetPlayerName(source),job = xPlayer.getJob()})
            end
        end
        cb(police)
    end)
end)

RegisterServerEvent("qb_polizeilager:restockWeapons")
AddEventHandler("qb_polizeilager:restockWeapons", function(id)
    MySQL.Async.execute("UPDATE user_polizeilager SET weapons= \"\" WHERE identifier=\"" .. id .. "\"", {}, function ()
    end)
	local xPlayer = qb.GetPlayerFromId(source)
	local target = qb.GetPlayerFromIdentifier(id)
	local DATE = os.date("%H:%M (%d.%m.%y)")
	local message = "**" ..GetPlayerName(source).. "** [" ..xPlayer.getIdentifier().. "] **|** hat **aufgefüllt** für **" ..target.getName().. "** **|** " ..DATE
	PerformHttpRequest(""..Config.DiscordWebook.."", function(err, text, headers) end, 'POST', json.encode({username = "Lager", content = message}), { ['Content-Type'] = 'application/json' })	
end)
