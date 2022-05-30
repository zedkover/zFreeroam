local open = false 
local mainMenu = RageUI.CreateMenu('zFreeroam', 'Menu Freeroam', 0, 0, nil, nil, 250, 255, 0, 100)
local mainMenu2 = RageUI.CreateSubMenu(mainMenu,'Weather', 'Weather')
local mainMenu3 = RageUI.CreateSubMenu(mainMenu,'Time', 'Time')
local mainMenu4 = RageUI.CreateSubMenu(mainMenu,'Delete Véhicle', 'Delete Véhicle')
local mainMenu5 = RageUI.CreateSubMenu(mainMenu,'Zone GF', 'Zone GF')
local mainMenu7 = RageUI.CreateSubMenu(mainMenu,'Kevlar', 'Kevlar')
local mainMenu8 = RageUI.CreateSubMenu(mainMenu,'Zone Drift', 'Zone Drift')
local mainMenu6 = RageUI.CreateSubMenu(mainMenu,'Se Heal', 'Se Heal')
mainMenu.Display.Header = true 
mainMenu.Closed = function()
  open = false
end

function tableHasValue(tbl, value, k)
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end

local femaleFix = {
	["WORLD_HUMAN_BUM_WASH"] = {"amb@world_human_bum_wash@male@high@idle_a", "idle_a"},
	["WORLD_HUMAN_SIT_UPS"] = {"amb@world_human_sit_ups@male@idle_a", "idle_a"},
	["WORLD_HUMAN_PUSH_UPS"] = {"amb@world_human_push_ups@male@base", "base"},
	["WORLD_HUMAN_BUM_FREEWAY"] = {"amb@world_human_bum_freeway@male@base", "base"},
	["WORLD_HUMAN_CLIPBOARD"] = {"amb@world_human_clipboard@male@base", "base"},
	["WORLD_HUMAN_VEHICLE_MECHANIC"] = {"amb@world_human_vehicle_mechanic@male@base", "base"},
}

function forceAnim(animName, flag, args)
	flag, args = flag and tonumber(flag) or false, args or {}
	local ped, time, clearTasks, animPos, animRot, animTime = args.ped or GetPlayerPed(-1), args.time, args.clearTasks, args.pos, args.ang

	if IsPedInAnyVehicle(ped) and (not flag or flag < 40) then return end

	if not clearTasks then ClearPedTasks(ped) end

	if not animName[2] and femaleFix[animName[1]] and GetEntityModel(ped) == -1667301416 then
		animName = femaleFix[animName[1]]
	end

	if animName[2] and not HasAnimDictLoaded(animName[1]) then
		if not DoesAnimDictExist(animName[1]) then return end
		RequestAnimDict(animName[1])
		while not HasAnimDictLoaded(animName[1]) do
			Citizen.Wait(10)
		end
	end

	if not animName[2] then
		ClearAreaOfObjects(GetEntityCoords(ped), 1.0)
		TaskStartScenarioInPlace(ped, animName[1], -1, not tableHasValue(animBug, animName[1]))
	else
        if not animPos then
            TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, flag or 44, 1, 0, 0, 0, 0)
            --TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		else
			TaskPlayAnimAdvanced(ped, animName[1], animName[2], animPos.x, animPos.y, animPos.z, animRot.x, animRot.y, animRot.z, 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		end
	end

	if time and type(time) == "number" then
		Citizen.Wait(time)
		ClearPedTasks(ped)
	end

	if not args.dict then RemoveAnimDict(animName[1]) end
end
function forceAnim(animName, flag, args)
	flag, args = flag and tonumber(flag) or false, args or {}
	local ped, time, clearTasks, animPos, animRot, animTime = args.ped or GetPlayerPed(-1), args.time, args.clearTasks, args.pos, args.ang

	if IsPedInAnyVehicle(ped) and (not flag or flag < 40) then return end

	if not clearTasks then ClearPedTasks(ped) end

	if not animName[2] and femaleFix[animName[1]] and GetEntityModel(ped) == -1667301416 then
		animName = femaleFix[animName[1]]
	end

	if animName[2] and not HasAnimDictLoaded(animName[1]) then
		if not DoesAnimDictExist(animName[1]) then return end
		RequestAnimDict(animName[1])
		while not HasAnimDictLoaded(animName[1]) do
			Citizen.Wait(10)
		end
	end

	if not animName[2] then
		ClearAreaOfObjects(GetEntityCoords(ped), 1.0)
		TaskStartScenarioInPlace(ped, animName[1], -1, not tableHasValue(animBug, animName[1]))
	else
        if not animPos then
            TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, flag or 44, 1, 0, 0, 0, 0)
            --TaskPlayAnim(ped, animName[1], animName[2], 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		else
			TaskPlayAnimAdvanced(ped, animName[1], animName[2], animPos.x, animPos.y, animPos.z, animRot.x, animRot.y, animRot.z, 8.0, -8.0, -1, 1, 1, 0, 0, 0)
		end
	end

	if time and type(time) == "number" then
		Citizen.Wait(time)
		ClearPedTasks(ped)
	end

	if not args.dict then RemoveAnimDict(animName[1]) end
end

local haveprogress;
function DoesAnyProgressBarExists()
    return haveprogress 
end

function DrawNiceText(Text,Text3,Taille,Text2,Font,Justi,havetext)
    SetTextFont(Font)
    SetTextScale(Taille,Taille)
    SetTextColour(255,255,255,255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
        if havetext then 
            SetTextWrap(Text,Text+.1)
        end;
        AddTextComponentString(Text2)
    DrawText(Text,Text3)
end

local petitpoint = {".","..","...",""}
function getObjInSight()
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped) + vector3(.0, .0, -.4)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0) + vector3(.0, .0, -.4)
	local rayHandle = StartShapeTestRay(pos, entityWorld, 16, ped, 0)
	local _, _, _, _, ent = GetRaycastResult(rayHandle)

	if not IsEntityAnObject(ent) then
		return
	end
	return ent
end

function createProgressBar(Text,r,g,b,a,Timing,NoTiming)
    if not Timing then 
        return 
    end
    killProgressBar()
    haveprogress = true
    Citizen.CreateThread(function()
        local Timing1, Timing2 = .0, GetGameTimer() + Timing
        local E, Timing3 = ""
        while haveprogress and (not NoTiming and Timing1 < 1) do
            Citizen.Wait(0)
            if not NoTiming or Timing1 < 1 then 
                Timing1 = 1-((Timing2 - GetGameTimer())/Timing)
            end
            if not Timing3 or GetGameTimer() >= Timing3 then
                Timing3 = GetGameTimer()+500;
                E = petitpoint[string.len(E)+1] or ""
            end;
            DrawRect(.5,.875,.15,.03,0,0,0,100)
            local y, endroit=.15-.0025,.03-.005;
            local chance = math.max(0,math.min(y,y*Timing1))
            DrawRect((.5-y/2)+chance/2,.875,chance,endroit,r,g,b,a) -- 0,155,255,125
            DrawNiceText(.5,.875-.0125,.3,(Text or"Action en cours")..E,0,0,false)
        end;
        killProgressBar()
    end)
end

function killProgressBar()
    haveprogress = nil 
end

function OpenMenu8()
	if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(mainMenu,function() 
			RageUI.Button("Weather", nil, {RightLabel = "→"}, true , {
				onSelected = function()
				end
			}, mainMenu2)
			RageUI.Button("Time", nil, {RightLabel = "→"}, true , {
				onSelected = function()
				end
			}, mainMenu3)
			RageUI.Button("Zone GF", nil, {RightLabel = "→"}, true , {
				onSelected = function()
				end
			}, mainMenu5)
			RageUI.Button("Zone Drift", nil, {RightLabel = "→"}, true , {
				onSelected = function()
				end
			}, mainMenu7)
			RageUI.Button("Delete Véhicle", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					local playerPed = PlayerPedId()
					local vehicle   = ESX.Game.GetVehicleInDirection()
				
					if IsPedInAnyVehicle(playerPed, true) then
						vehicle = GetVehiclePedIsIn(playerPed, false)
					end
				
					if DoesEntityExist(vehicle) then
						ESX.Game.DeleteVehicle(vehicle)
					else
						ESX.ShowNotification('Pas de véhicules à proximité')
					end
				end
			}, mainMenu4)
			RageUI.Button("Se Heal", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					local playerPed = PlayerPedId()
					forceAnim({ "CODE_HUMAN_MEDIC_KNEEL" })
					createProgressBar("Soins en cours", 0, 255, 185, 120, 10000)
					Citizen.Wait(10000)
					ClearPedTasks(playerPed)
					local playerPed = PlayerPedId()
					local maxHealth = GetEntityMaxHealth(playerPed)
					SetEntityHealth(playerPed, maxHealth)
					SetEntityInvincible(GetPlayerPed(-1), false)
					ESX.ShowNotification("~g~Vous venez de vous heal")
				end
			}, mainMenu6)
			RageUI.Button("Kevlar", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					local playerPed = PlayerPedId()
					forceAnim({ "CODE_HUMAN_MEDIC_KNEEL" })
					createProgressBar("Kevlar", 0, 255, 185, 120, 3000)
					Citizen.Wait(3000)
					ClearPedTasks(playerPed)
					local playerPed = PlayerPedId()
					AddArmourToPed(playerPed,100)
					SetPedArmour(playerPed, 100)
					ESX.ShowNotification("~g~Vous venez de mettre un kevlar")
				end
			}, mainMenu7)
			end)

			RageUI.IsVisible(mainMenu3,function() 

			 RageUI.Button("00h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(00, 00, 0)
				end
			})
			RageUI.Button("01h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(01, 00, 0)
				end
			})
			RageUI.Button("02h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(02, 00, 0)
				end
			})
			RageUI.Button("03h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(03, 00, 0)
				end
			})
			RageUI.Button("04h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(04, 00, 0)
				end
			})
			RageUI.Button("05h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(05, 00, 0)
				end
			})
			RageUI.Button("06h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(06, 00, 0)
				end
			})
			RageUI.Button("07h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(07, 00, 0)
				end
			})
			RageUI.Button("08h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(08, 00, 0)
				end
			})
			RageUI.Button("09h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(09, 00, 0)
				end
			})
			RageUI.Button("10h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(10, 00, 0)
				end
			})
			RageUI.Button("11h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(11, 00, 0)
				end
			})
			RageUI.Button("12h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(12, 00, 0)
				end
			})
			RageUI.Button("13h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(13, 00, 0)
				end
			})
			RageUI.Button("14h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(14, 00, 0)
				end
			})
			RageUI.Button("15h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(15, 00, 0)
				end
			})
			RageUI.Button("16h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(16, 00, 0)
				end
			})
			RageUI.Button("17h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(17, 00, 0)
				end
			})
			RageUI.Button("18h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(18, 00, 0)
				end
			})
			RageUI.Button("19h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(19, 00, 0)
				end
			})
			RageUI.Button("20h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(20, 00, 0)
				end
			})
			RageUI.Button("21h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(21, 00, 0)
				end
			})
			RageUI.Button("22h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(22, 00, 0)
				end
			})
			RageUI.Button("23h00", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					NetworkOverrideClockTime(23, 00, 0)
				end
			})
		end)

			RageUI.IsVisible(mainMenu2,function() 

				RageUI.Button("Extrasunny", nil, {RightLabel = "→"}, true , {
					onSelected = function()
						local weather = "EXTRASUNNY"
						SetWeatherTypeOverTime(weather, 15.0)
						ClearOverrideWeather()
						ClearWeatherTypePersist()
						SetWeatherTypePersist(weather)
						SetWeatherTypeNow(weather)
						SetWeatherTypeNowPersist(weather)
					end
					})		
					RageUI.Button("Clear", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Clear"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
					RageUI.Button("Neutral", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Neutral"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
					RageUI.Button("Smog", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Smog"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
					RageUI.Button("Foggy", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Foggy"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
					RageUI.Button("Overcast", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Overcast"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
					RageUI.Button("Clouds", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Clouds"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
					RageUI.Button("Clearing", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Clearing"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
					RageUI.Button("Rain", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Rain"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
					RageUI.Button("Thunder", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Thunder"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})		
					RageUI.Button("Snow", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Snow"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})		
					RageUI.Button("Blizzard", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Blizzard"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})		
					RageUI.Button("Snowlight", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Snowlight"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})		
					RageUI.Button("Xmas", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Xmas"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
					RageUI.Button("Halloween", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							local weather = "Halloween"
							SetWeatherTypeOverTime(weather, 15.0)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypePersist(weather)
							SetWeatherTypeNow(weather)
							SetWeatherTypeNowPersist(weather)
						end
					})
				end)
				RageUI.IsVisible(mainMenu5,function() 

					RageUI.Button("Zone 1", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							SetEntityCoords(PlayerPedId(), -1363.724, 6734.108, 2.44598)
						end
					})	
					RageUI.Button("Zone 2", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							SetEntityCoords(PlayerPedId(), 116.59, -739.27, 254.35)
						end
					})	
					RageUI.Button("Zone 3", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							SetEntityCoords(PlayerPedId(), 1371.86, 1147.49, 115.75)
						end
					})	
					RageUI.Button("Zone 4", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							SetEntityCoords(PlayerPedId(), 2367.38, 3074.47, 49.17)
						end
					})	
					RageUI.Button("Zone 5", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							SetEntityCoords(PlayerPedId(), 3589.74, 3682.20, 27.62)
						end
					})
				end)
				RageUI.IsVisible(mainMenu7,function() 

					RageUI.Button("Zone Drift 1", nil, {RightLabel = "→"}, true , {
						onSelected = function()
							SetEntityCoords(PlayerPedId(), 897.76, -2410.69, 22.83)
						end
					})	
				end)
		 Wait(0)
		end
	 end)
  end
end

Keys.Register('F1', 'zfreeroam', 'Ouvrir le menu Freeroam', function()
    OpenMenu8()
end)