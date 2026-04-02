qb 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingTest    = {}
local PlayersTransformingTest  = {}
local PlayersSellingTest       = {}

TriggerEvent('qb:getSharedObject', function(obj) qb = obj end)

function CountCops()
	local xPlayers = qb.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = qb.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

local function HarvestTest(source)

	SetTimeout(Config.TimeToFarm, function()
		if PlayersHarvestingTest[source] then
			local xPlayer = qb.GetPlayerFromId(source)
			local test = xPlayer.getInventoryItem('kürbis')

			if test.limit ~= -1 and test.count >= 50 then
				TriggerClientEvent('qb:showNotification', source, _U('bag_full'))
			else
				xPlayer.addInventoryItem('kürbis', 1)
				HarvestTest(source)
			end
		end
	end)
end

RegisterServerEvent('qb_farmkürbis:startHarvestTest')
AddEventHandler('qb_farmkürbis:startHarvestTest', function()
	local _source = source

	if not PlayersHarvestingTest[_source] then
		PlayersHarvestingTest[_source] = true

		TriggerClientEvent('qb:showNotification', _source, _U('take_kürbis'))
		HarvestTest(_source)
	else
		print(('qb_farmkürbis: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('qb_farmkürbis:stopHarvestTest')
AddEventHandler('qb_farmkürbis:stopHarvestTest', function()
	local _source = source

	PlayersHarvestingTest[_source] = false
end)

local function TransformTest(source)

	SetTimeout(Config.TimeToProcess, function()
		if PlayersTransformingTest[source] then
			local xPlayer = qb.GetPlayerFromId(source)
			local testQuantity = xPlayer.getInventoryItem('kürbis').count
			local pooch = xPlayer.getInventoryItem('cake_kürbis')

			if 10 ~= -1 and pooch.count >= 10 then
				TriggerClientEvent('qb:showNotification', source, _U('you_do_not_have_enough_kürbis'))
			elseif testQuantity < 5 then
				TriggerClientEvent('qb:showNotification', source, _U('you_do_not_have_any_more_kürbis'))
			else
				xPlayer.removeInventoryItem('kürbis', 5)
				xPlayer.addInventoryItem('cake_kürbis', 1)

				TransformTest(source)
			end
		end
	end)
end

RegisterServerEvent('qb_farmkürbis:startTransformTest')
AddEventHandler('qb_farmkürbis:startTransformTest', function()
	local _source = source

	if not PlayersTransformingTest[_source] then
		PlayersTransformingTest[_source] = true

		TriggerClientEvent('qb:showNotification', _source, _U('transform_cake_kürbis'))
		TransformTest(_source)
	else
		print(('qb_farmkürbis: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('qb_farmkürbis:stopTransformTest')
AddEventHandler('qb_farmkürbis:stopTransformTest', function()
	local _source = source

	PlayersTransformingTest[_source] = false
end)

local function SellTest(source)

	SetTimeout(Config.TimeToSell, function()
		if PlayersSellingTest[source] then
			local xPlayer = qb.GetPlayerFromId(source)
			local poochQuantity = xPlayer.getInventoryItem('cake_kürbis').count

			if poochQuantity == 0 then
				TriggerClientEvent('qb:showNotification', source, _U('you_do_not_have_cake_kürbis'))
			else
				xPlayer.removeInventoryItem('cake_kürbis', 1)
				xPlayer.addMoney(88)
				TriggerClientEvent('qb:showNotification', source, _U('saft'))
				

				SellTest(source)
			end
		end
	end)
end

RegisterServerEvent('qb_farmkürbis:startSellTest')
AddEventHandler('qb_farmkürbis:startSellTest', function()
	local _source = source

	if not PlayersSellingTest[_source] then
		PlayersSellingTest[_source] = true

		TriggerClientEvent('qb:showNotification', _source, _U('sell_cake_kürbis'))
		SellTest(_source)
	else
		print(('qb_farmkürbis: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('qb_farmkürbis:stopSellTest')
AddEventHandler('qb_farmkürbis:stopSellTest', function()
	local _source = source

	PlayersSellingTest[_source] = false
end)

RegisterServerEvent('qb_farmkürbis:GetUserInventory')
AddEventHandler('qb_farmkürbis:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = qb.GetPlayerFromId(_source)
	TriggerClientEvent('qb_farmkürbis:ReturnInventory',
		_source,
		xPlayer.getInventoryItem('kürbis').count,
		xPlayer.getInventoryItem('cake_kürbis').count,
		xPlayer.job.name,
		currentZone
	)
end)
