TriggerEvent('es:addGroupCommand', 'tp', 'admin', function(source, args, user)

	local x = tonumber(args[1])

	local y = tonumber(args[2])

	local z = tonumber(args[3])

	

	if x and y and z then

		TriggerClientEvent('esx:teleport', source, {

			x = x,

			y = y,

			z = z

		})

	else

		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Invalid coordinates!")

	end

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end, {help = "Teleport to coordinates", params = {{name = "x", help = "X coords"}, {name = "y", help = "Y coords"}, {name = "z", help = "Z coords"}}})

TriggerEvent('es:addGroupCommand', 'car', 'admin', function(source, args, user)

	TriggerClientEvent('esx:spawnVehicle', source, args[1])

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end, {help = _U('spawn_car'), params = {{name = "car", help = _U('spawn_car_param')}}})



TriggerEvent('es:addGroupCommand', 'cardel', 'mod', function(source, args, user)

	TriggerClientEvent('esx:deleteVehicle1', source)

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end, {help = _U('delete_vehicle')})



TriggerEvent('es:addGroupCommand', 'dv', 'mod', function(source, args, user)

	TriggerClientEvent('esx:deleteVehicle', source)

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end, {help = _U('delete_vehicle')})

TriggerEvent('es:addGroupCommand', 'disc', 'admin', function(source, args, user)

	DropPlayer(source, 'You have been disconnected')

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end)



TriggerEvent('es:addGroupCommand', 'disconnect', 'admin', function(source, args, user)

	DropPlayer(source, 'You have been disconnected')

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end, {help = _U('disconnect')})



TriggerEvent('es:addGroupCommand', 'clear', 'user', function(source, args, user)

	TriggerClientEvent('chat:clear', source)

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end, {help = _U('chat_clear')})



TriggerEvent('es:addGroupCommand', 'cls', 'user', function(source, args, user)

	TriggerClientEvent('chat:clear', source)

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end)



TriggerEvent('es:addGroupCommand', 'clsall', 'admin', function(source, args, user)

	TriggerClientEvent('chat:clear', -1)

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end)



TriggerEvent('es:addGroupCommand', 'clearall', 'admin', function(source, args, user)

	TriggerClientEvent('chat:clear', -1)

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end, {help = _U('chat_clear_all')})


TriggerEvent('es:addGroupCommand', 'clearloadout', 'admin', function(source, args, user)

	local xPlayer



	if args[1] then

		xPlayer = ESX.GetPlayerFromId(args[1])

	else

		xPlayer = ESX.GetPlayerFromId(source)

	end



	if not xPlayer then

		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Joueur Hors-Ligne.' } })

		return

	end



	for i=#xPlayer.loadout, 1, -1 do

		xPlayer.removeWeapon(xPlayer.loadout[i].name)

	end

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Pas assez de permissions' } })

end, {help = _U('command_clearloadout'), params = {{name = "playerId", help = _U('command_playerid_param')}}})

