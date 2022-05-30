ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)
function tableHasValue(tbl, value, k)
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end
function ShowAboveRadarMessage(message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	SetNotificationTextEntry("jamyfafi")
	AddLongString(message)
	return DrawNotification(0, 1)
end
function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end
function GetClosestPed2(vector, radius, modelHash, testFunction)
	if not vector or not radius then return end
	local handle, myped, veh = FindFirstPed(), GetPlayerPed(-1)
	local success, theVeh
	repeat
		local firstDist = GetDistanceBetweenCoords(GetEntityCoords(veh), vector.x, vector.y, vector.z)
		if firstDist < radius and veh ~= myped and (not modelHash or modelHash == GetEntityModel(veh)) and (not theVeh or firstDist < GetDistanceBetweenCoords(GetEntityCoords(theVeh), GetEntityCoords(veh))) and (not testFunction or testFunction(veh)) then
			theVeh = veh
		end
		success, veh = FindNextPed(handle)
	until not success
		EndFindPed(handle)

	return theVeh
end

locksound = false
local wait = 15
local count = 60
local dead = false
local deathTime, waitTime, deathCause = 0, 60 * 1000 * 0.05, {}
local put = nil


function setEntCoords(pos, ent, trustPos)
	if not pos or not pos.x or not pos.y or not pos.z or (ent and not DoesEntityExist(ent)) then return true end
	local x, y, z = pos.x, pos.y, pos.z + 1.0
	ent = ent or GetPlayerPed(-1)

	RequestCollisionAtCoord(x, y, z)
	NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local tempTimer = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - tempTimer > 3000 then
			break
		end

		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(ent, x, y, z)

	tempTimer = GetGameTimer()
	while not HasCollisionLoadedAroundEntity(ent) do
		if GetGameTimer() - tempTimer > 3000 then
			break
		end

		Citizen.Wait(0)
	end

	local foundNewZ, newZ
	if not trustPos then
		foundNewZ, newZ = GetGroundZCoordWithOffsets(x, y, z)
		tempTimer = GetGameTimer()
		while not foundNewZ do
			z = z + 10.0
			foundNewZ, newZ = GetGroundZCoordWithOffsets(x, y, z)
			Wait(0)

			if GetGameTimer() - tempTimer > 2000 then
				break
			end
		end
	end

	SetEntityCoordsNoOffset(ent, x, y, foundNewZ and newZ or z)
	NewLoadSceneStop()

	if type(pos) ~= "vector3" and pos.a then SetEntityHeading(ent, pos.a) end
	return true
end
local ScreenCoords = { baseX = 0.918, baseY = 0.984, titleOffsetX = 0.012, titleOffsetY = -0.012, valueOffsetX = 0.0785, valueOffsetY = -0.0165, pbarOffsetX = 0.047, pbarOffsetY = 0.0015 }
local Sizes = {	timerBarWidth = 0.165, timerBarHeight = 0.035, timerBarMargin = 0.038, pbarWidth = 0.0616, pbarHeight = 0.0105 }

local activeBars = {}

AddTimerBar = function(title, itemData)
	if not itemData then return end
	RequestStreamedTextureDict("timerbars", true)

	local barIndex = #activeBars + 1
	activeBars[barIndex] = {
		title = title,
		text = itemData.text,
		textColor = itemData.color or { 255, 255, 255, 255 },
		percentage = itemData.percentage,
		endTime = itemData.endTime,
		pbarBgColor = itemData.bg or { 155, 155, 155, 255 },
		pbarFgColor = itemData.fg or { 255, 255, 255, 255 }
	}

	return barIndex
end


RemoveTimerBar = function()
	activeBars = {}
	SetStreamedTextureDictAsNoLongerNeeded("timerbars")
end

UpdateTimerBar = function(barIndex, itemData)
	if not activeBars[barIndex] or not itemData then return end
	for k,v in pairs(itemData) do
		activeBars[barIndex][k] = v
	end
end

local HideHudComponentThisFrame = HideHudComponentThisFrame
local GetSafeZoneSize = GetSafeZoneSize
local DrawSprite = DrawSprite
local DrawText2 = DrawText2
local DrawRect = DrawRect
local SecondsToClock = SecondsToClock
local GetGameTimer = GetGameTimer
local textColor = { 200, 100, 100 }
local math = math

function SecondsToClock1(seconds)
	seconds = tonumber(seconds)

	if seconds <= 0 then
		return "00:00"
	else
		mins = string.format("%02.f", math.floor(seconds / 60))
		secs = string.format("%02.f", math.floor(seconds - mins * 60))
		return string.format("%s:%s", mins, secs)
	end
end

Citizen.CreateThread(function()
	while true do
		local attente = 250

		local safeZone = GetSafeZoneSize()
		local safeZoneX = (1.0 - safeZone) * 0.5
		local safeZoneY = (1.0 - safeZone) * 0.5

		if #activeBars > 0 then
			attente = 1
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)

			for i,v in pairs(activeBars) do
				local drawY = (ScreenCoords.baseY - safeZoneY) - (i * Sizes.timerBarMargin);
				DrawSprite("timerbars", "all_black_bg", ScreenCoords.baseX - safeZoneX, drawY, Sizes.timerBarWidth, Sizes.timerBarHeight, 0.0, 255, 255, 255, 160)
				DrawText2(0, v.title, 0.3, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.titleOffsetX, drawY + ScreenCoords.titleOffsetY, v.textColor, false, 2)

				if v.percentage then
					local pbarX = (ScreenCoords.baseX - safeZoneX) + ScreenCoords.pbarOffsetX;
					local pbarY = drawY + ScreenCoords.pbarOffsetY;
					local width = Sizes.pbarWidth * v.percentage;

					DrawRect(pbarX, pbarY, Sizes.pbarWidth, Sizes.pbarHeight, v.pbarBgColor[1], v.pbarBgColor[2], v.pbarBgColor[3], v.pbarBgColor[4])

					DrawRect((pbarX - Sizes.pbarWidth / 2) + width / 2, pbarY, width, Sizes.pbarHeight, v.pbarFgColor[1], v.pbarFgColor[2], v.pbarFgColor[3], v.pbarFgColor[4])
				elseif v.text then
					DrawText2(0, v.text, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, v.textColor, false, 2)
				elseif v.endTime then
					local remainingTime = math.floor(v.endTime - GetGameTimer())
					DrawText2(0, SecondsToClock1(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
				end
			end
		end
		Wait(attente)
	end
end)

function DrawText2(intFont, strText, floatScale, intPosX, intPosY, color, boolShadow, intAlign, addWarp)
	SetTextFont(intFont)
	SetTextScale(floatScale, floatScale)

	if boolShadow then
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
	end

	SetTextColour(color[1], color[2], color[3], 255)
	if intAlign == 0 then
		SetTextCentre(true)
	else
		SetTextJustification(intAlign or 1)
		if intAlign == 2 then
			SetTextWrap(.0, addWarp or intPosX)
		end
	end

	SetTextEntry("jamyfafi")
	AddLongString(strText)

	DrawText(intPosX, intPosY)
end

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

function Instructions(instructions, cam)
    local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(1) end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

	local counter = 0
    for _, instruction in pairs(instructions) do
		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(counter)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, instruction.key, true))
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(instruction.message)
        EndTextCommandScaleformString()
		PopScaleformMovieFunctionVoid()
		counter = counter + 1
	end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(70)
    PopScaleformMovieFunctionVoid()
    
    return scaleform
end

local TimerBar = nil
local Pourcent = .0;
local locksound = false

local pouvoireeload = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 
        local Player = GetPlayerPed(-1)
        isDead = dead
			if dead then 
				local foundPlayer = false
                local instructions = Instructions({{key = 37, message = "Respawn mode passif"}, {key = 24, message = "Respawn"}})
                Pourcent = .0
				local ped = GetPlayerPed(-1)
				StartScreenEffect("DeathFailOut", 0, 0)
				if not locksound then
					PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
					locksound = true
				end
				ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
				
				local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
                SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
				entity = GetClosestPed2(GetEntityCoords(GetPlayerPed(-1)),3.5)
				if not IsPedAPlayer(entity) and IsPedHuman(entity) then 
					DeleteEntity(entity)
				end
				DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				if HasScaleformMovieLoaded(scaleform) then
					PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				end
                Citizen.Wait(1000)
                while dead do
					
					SetEntityHealth(ped, 120)
					SetPedToRagdoll(ped, 1000, 1000, 0, 1, 1, 0)
					ResetPedRagdollTimer(ped)
                    SetFollowPedCamViewMode(0)
                    DisableControlAction(0, 0, true)
					DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
					PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
					BeginTextComponent("STRING")
					AddTextComponentString("~r~wasted")
					EndTextComponent()
					PopScaleformMovieFunctionVoid()
					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)

					if IsControlJustPressed(1, 24) then
						entity = GetClosestPed2(GetEntityCoords(GetPlayerPed(-1)),3.5)
						if not IsPedAPlayer(entity) and IsPedHuman(entity) then 
							DeleteEntity(entity)
						end
                        Pourcent = math.max(0, math.min(1.0, Pourcent + .08))
                        UpdateTimerBar(TimerBar, { percentage = Pourcent })
                    end
                    
					if not IsPedAPlayer(entity) and IsPedHuman(entity) then 
						DeleteEntity(entity)
					end
					deathTime = deathTime or GetGameTimer()
					local t = deathTime + waitTime
					local RespawnPressed = IsControlJustPressed(1, 37)
					
                    if Pourcent >= 1 then 
                        local playerPed = GetPlayerPed(-1)
						dead = false
						isDead = false
						locksound = false
                        DoScreenFadeOut(800)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
                        RemoveTimerBar()
						entity = GetClosestPed2(GetEntityCoords(GetPlayerPed(-1)),3.5)
						if not IsPedAPlayer(entity) and IsPedHuman(entity) then 
							DeleteEntity(entity)
						end
                        ClearPedBloodDamage(ped)
                        ClearPedBloodDamage(ped)
                        Citizen.Wait(10)
                        ClearPedTasksImmediately(playerPed)
						SetEntityHealth(playerPed, 200)
						Citizen.Wait(500)
						StopScreenEffect("DeathFailOut")
                        DoScreenFadeIn(800)
						NetworkSetScriptIsSafeForNetworkGame()
						ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 0.2)
                        NetworkSetLocalPlayerInvincibleTime(3000)
					end
					if (RespawnPressed or CallPressed) and (CallPressed or t < GetGameTimer()) then
                        local playerPed = GetPlayerPed(-1)
						dead = false
						isDead = false
						locksound = false
                        DoScreenFadeOut(800)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
                        RemoveTimerBar()
						entity = GetClosestPed2(GetEntityCoords(GetPlayerPed(-1)),3.5)
						if not IsPedAPlayer(entity) and IsPedHuman(entity) then 
							DeleteEntity(entity)
						end
                        ClearPedBloodDamage(ped)
                        ClearPedBloodDamage(ped)
                        Citizen.Wait(10)
                        ClearPedTasksImmediately(playerPed)
						SetEntityHealth(playerPed, 200)
						Citizen.Wait(500)
						StopScreenEffect("DeathFailOut")
                        local pPed = PlayerPedId()
						local pCoords = GetEntityCoords(pPed)
						local pSpawn = pCoords + math.random(30.0, 60.0)
						local players = GetClosestPed2(pSpawn,30.0)
						local pPlayerC = GetEntityCoords(players)
						local pDist = GetDistanceBetweenCoords(pSpawn, pPlayerC)
						if players then
							repeat 
								pSpawn = pSpawn + 1.0
								Wait(2)
								pDist = GetDistanceBetweenCoords(pSpawn, pPlayerC)
							until pDist > 30.0
						end

                        setEntCoords(pSpawn, pPed, false)
                        DoScreenFadeIn(800)
						NetworkSetScriptIsSafeForNetworkGame()
						ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 0.2)
						NetworkSetLocalPlayerInvincibleTime(5000)
						TriggerEvent('admin:passif', true)
                    end
                Citizen.Wait(0)
             end
        end   
    end
end)

AddEventHandler('zedkover:onPlayerKilled', function(_, tab)
	if not isDead or not dead then 
		TimerBar = AddTimerBar("RÉAPPARTITION:", { percentage = 0.0, bg= { 100 ,0, 0, 255}, fg = { 200, 0, 0, 255}})
	end
	local ped = GetPlayerPed(-1)
	dead = true
	isDead = true
	deathTime = GetGameTimer() or 0
	NetworkResurrectLocalPlayer(GetEntityCoords(ped), 0, true, true, false)
	SetEntityInvincible(GetPlayerPed(-1), true)
	SetEntityHealth(ped, 120)
	SetPedToRagdoll(ped, 1000, 1000, 0, 1, 1, 0)
end)

AddEventHandler('zedkover:onPlayerDied', function(_, _)
	if not isDead or not dead then 
		TimerBar = AddTimerBar("RÉAPPARTITION:", { percentage = 0.0, bg= { 100 ,0, 0, 255}, fg = { 200, 0, 0, 255}})
	end
	dead = true
	isDead = true
	local ped = GetPlayerPed(-1)
	deathTime = GetGameTimer() or 0
	NetworkResurrectLocalPlayer(GetEntityCoords(ped), 0, true, true, false)
	SetEntityInvincible(ped, true)
	SetEntityHealth(ped, 120)
end)

function setSobre()
    local ped = GetPlayerPed(-1)
    ClearPedBloodDamage(ped)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(ped, 0)
    SetPedIsDrunk(ped, false)
    SetCamEffect(0)
end

Citizen.CreateThread(function()
    local isDead = false
    local hasBeenDead = false
    local diedAt

    while true do
        Wait(0)

        local player = PlayerId()

        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()

            if IsPedFatallyInjured(ped) and not isDead then
                dead = true
                if not diedAt then
                    diedAt = GetGameTimer()
                end

                local killer, killerweapon = NetworkGetEntityKillerOfPlayer(player)
                local killerentitytype = GetEntityType(killer)
                local killertype = -1
                local killerinvehicle = false
                local killervehiclename = ''
                local killervehicleseat = 0
                if killerentitytype == 1 then
                    killertype = GetPedType(killer)
                    if IsPedInAnyVehicle(killer, false) == 1 then
                        killerinvehicle = true
                        killervehiclename = nil
                    else 
                        killerinvehicle = false
                    end
                end

                local killerid = GetPlayerByEntityID(killer)
                if killer ~= ped and killerid ~= nil and NetworkIsPlayerActive(killerid) then 
                    killerid = GetPlayerServerId(killerid)
                else 
                    killerid = -1
                end

                if killer == ped or killer == -1 then
                    TriggerEvent('zedkover:onPlayerDied', killertype, { table.unpack(GetEntityCoords(ped)) })
                    TriggerServerEvent('esx:killerlog',0, killertype, { table.unpack(GetEntityCoords(ped)) })
                    hasBeenDead = true
                else
                    TriggerServerEvent('esx:killerlog',1, killerid, {killertype=killertype, weaponhash = killerweapon, killerinveh=killerinvehicle, killervehseat=killervehicleseat, killervehname=killervehiclename, killerpos=table.unpack(GetEntityCoords(ped))})
                    TriggerEvent('zedkover:onPlayerKilled', killerid, {killertype=killertype, weaponhash = GetHashKey(killerweapon), killerinveh=killerinvehicle, killervehseat=killervehicleseat, killervehname=killervehiclename, killerpos=table.unpack(GetEntityCoords(ped))})
                    TriggerServerEvent('addXpPlayer', killerid, 225)
                    hasBeenDead = true
                end
            elseif not IsPedFatallyInjured(ped) then
                isDead = false
                diedAt = nil
            end

            if not hasBeenDead and diedAt ~= nil and diedAt > 0 then
                TriggerEvent('zedkover:onPlayerWasted', { table.unpack(GetEntityCoords(ped)) })

                hasBeenDead = true
            elseif hasBeenDead and diedAt ~= nil and diedAt <= 0 then
                hasBeenDead = false
            end
        end
    end
end)

RegisterCommand('focus', function()
    SetNuiFocus(false, false)
end)

function GetPlayerByEntityID(id)
    for i=0,255 do
        if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then 
            return i 
        end
    end
    return nil
end

local playersToHide = {}
local passif = false
local controlDisabled = {24,25,257,263,264,140,37}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		playersToHide = {}
		for k,v in ipairs(GetActivePlayers()) do
			playersToHide[GetPlayerServerId(v)] = true
		end

		SetPlayerCanDoDriveBy(PlayerId(), false)
	end
end)

RegisterNetEvent('admin:passif')
AddEventHandler('admin:passif', function(bool)
	local pPed = PlayerPedId()
	if bool then 
		passif = true 
		DisablePlayerFiring(pPed, true)
		for k,v in pairs(playersToHide) do
			local player = GetPlayerFromServerId(k)

			local otherPlayerPed = GetPlayerPed(player)
			if otherPlayerPed ~= GetPlayerPed(-1) then
				SetEntityAlpha(otherPlayerPed, 75, false)
			end
		end
		ShowAboveRadarMessage('Vous êtes entré dans le mode ~b~passif.')
	elseif not bool then 
		passif = false
		ResetEntityAlpha(pPed)
		DisablePlayerFiring(pPed, false)
		SetEntityCollision(GetPlayerPed(-1), true, true)
		for serverId,_ in pairs(playersToHide) do
			local player = GetPlayerFromServerId(serverId)

			if NetworkIsPlayerActive(player) then
				local otherPlayerPed = GetPlayerPed(player)
				ResetEntityAlpha(otherPlayerPed)
			end
		end
		SetEntityNoCollisionEntity(pPed, 0, 0)
		ShowAboveRadarMessage('Vous avez quitté le mode ~r~passif.')
	end
end)

RegisterCommand('passif', function()
	local pPed = PlayerPedId()
	if not passif then 
		passif = true
		DisablePlayerFiring(pPed, true)
		for k,v in pairs(playersToHide) do
			local player = GetPlayerFromServerId(k)

			local otherPlayerPed = GetPlayerPed(player)
			if otherPlayerPed ~= GetPlayerPed(-1) then
				SetEntityAlpha(otherPlayerPed, 75, false)
			end
		end
		ShowAboveRadarMessage('Vous êtes entré dans le mode ~b~passif.')
	elseif passif then 
		passif = false
		ResetEntityAlpha(pPed)
		DisablePlayerFiring(pPed, false)
		SetEntityCollision(GetPlayerPed(-1), true, true)
		for serverId,_ in pairs(playersToHide) do
			local player = GetPlayerFromServerId(serverId)

			if NetworkIsPlayerActive(player) then
				local otherPlayerPed = GetPlayerPed(player)
				ResetEntityAlpha(otherPlayerPed)
			end
		end
		SetEntityNoCollisionEntity(pPed, 0, 0)
		ShowAboveRadarMessage('Vous avez quitté le mode ~r~passif.')
	end
end)

Citizen.CreateThread(function()
	while true do 
		local attente = 500
		if passif then 
			attente = 1

			for _,v in pairs(controlDisabled) do
                DisableControlAction(0, v, true)
			end
			
			local playerPed = PlayerPedId()

			for serverId,_ in pairs(playersToHide) do
				local player = GetPlayerFromServerId(serverId)
	
				local otherPlayerPed = GetPlayerPed(player)
				SetEntityAlpha(otherPlayerPed, 75, false)
				NetworkSetLocalPlayerInvincibleTime(playerPed, 2)
				SetEntityNoCollisionEntity(playerPed, 0, 0)
			end
		end
		Wait(attente)
	end
end)
