ESX.Trace = function(str)

	if Config.EnableDebug then

		print('ESX> ' .. str)

	end

end



ESX.SetTimeout = function(msec, cb)

	local id = ESX.TimeoutCount + 1



	SetTimeout(msec, function()

		if ESX.CancelledTimeouts[id] then

			ESX.CancelledTimeouts[id] = nil

		else

			cb()

		end

	end)



	ESX.TimeoutCount = id



	return id

end



ESX.ClearTimeout = function(id)

	ESX.CancelledTimeouts[id] = true

end



ESX.RegisterServerCallback = function(name, cb)

	ESX.ServerCallbacks[name] = cb

end



ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)

	if ESX.ServerCallbacks[name] ~= nil then

	   ESX.ServerCallbacks[name](source, cb, ...)

	else

		print('zFramework: TriggerServerCallback => [' .. name .. '] does not exist')

	end

end



ESX.SavePlayer = function(xPlayer, cb)

	local asyncTasks = {}

	xPlayer.setLastPosition(xPlayer.getCoords())



	-- User accounts

	for i=1, #xPlayer.accounts, 1 do

		if ESX.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] ~= xPlayer.accounts[i].money then

			table.insert(asyncTasks, function(cb)

				MySQL.Async.execute('UPDATE user_accounts SET `money` = @money WHERE identifier = @identifier AND name = @name', {

					['@money']      = xPlayer.accounts[i].money,

					['@identifier'] = xPlayer.identifier,

					['@name']       = xPlayer.accounts[i].name

				}, function(rowsChanged)

					cb()

				end)

			end)



			ESX.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] = xPlayer.accounts[i].money

		end

	end


	table.insert(asyncTasks, function(cb)

		MySQL.Async.execute('UPDATE users SET `loadout` = @loadout, `position` = @position WHERE identifier = @identifier', {

			['@loadout']    = json.encode(xPlayer.getLoadout()),

			['@position']   = json.encode(xPlayer.getLastPosition()),

			['@identifier'] = xPlayer.identifier

		}, function(rowsChanged)

			cb()

		end)

	end)



	Async.parallel(asyncTasks, function(results)

		RconPrint('[SAUVEGARDE] ' .. xPlayer.name .. "^7\n")



		if cb ~= nil then

			cb()

		end

	end)

end



ESX.SavePlayers = function(cb)

	local asyncTasks = {}

	local xPlayers   = ESX.GetPlayers()



	for i=1, #xPlayers, 1 do

		table.insert(asyncTasks, function(cb)

			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			ESX.SavePlayer(xPlayer, cb)

		end)

	end



	Async.parallelLimit(asyncTasks, 8, function(results)

		RconPrint('[SAVED] SAUVEGARDE TOUT LES JOUEURS' .. "\n")



		if cb ~= nil then

			cb()

		end

	end)

end



ESX.StartDBSync = function()

	function saveData()

		ESX.SavePlayers()

		SetTimeout(10 * 60 * 1000, saveData)

	end



	SetTimeout(10 * 60 * 1000, saveData)

end



ESX.GetPlayers = function()

	local sources = {}



	for k,v in pairs(ESX.Players) do

		table.insert(sources, k)

	end



	return sources

end





ESX.GetPlayerFromId = function(source)

	return ESX.Players[tonumber(source)]

end



ESX.GetPlayerFromIdentifier = function(identifier)

	for k,v in pairs(ESX.Players) do

		if v.identifier == identifier then

			return v

		end

	end

end



ESX.CreatePickup = function(type, name, count, label, player)

	local pickupId = (ESX.PickupId == 65635 and 0 or ESX.PickupId + 1)



	ESX.Pickups[pickupId] = {

		type  = type,

		name  = name,

		count = count

	}



	TriggerClientEvent('esx:pickup', -1, pickupId, label, player)

	ESX.PickupId = pickupId

end