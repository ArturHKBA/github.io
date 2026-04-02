qb               = nil

TriggerEvent('qb:getSharedObject', function(obj) qb = obj end)

qb.RegisterServerCallback('autosperre:isFahrzeugOwner', function(source, cb, plate)
	local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT owner FROM owned_fahrzeuge WHERE owner = @owner AND plate = @plate', {
		['@owner'] = identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier)
		else
			cb(false)
		end
	end)
end)