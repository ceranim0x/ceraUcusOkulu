

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

local flightblip = {
    {title="Uçuş Okulu", colour=27, id=307, x = -1006.7, y = -2962.88, z = 13.95} -- you can change the blip here
}

Citizen.CreateThread(function()

for _, info in pairs(flightblip) do
  info.blip = AddBlipForCoord(info.x, info.y, info.z)
  SetBlipSprite(info.blip, info.id)
  SetBlipDisplay(info.blip, 4)
  SetBlipScale(info.blip, 0.9)
  SetBlipColour(info.blip, info.colour)
  SetBlipAsShortRange(info.blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(info.title)
  EndTextCommandSetBlipName(info.blip)
end
end)

function flightnoti(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- flight school menu

function OpenFlightActionsMenu()
	local elements = {
		{label = "Lisans Ver", value = 'give_flight'},
		{label = "Lisansa El Koy", value = 'remove_flight'}
	}

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = "Patron Eylemleri", value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'flight_actions_menu',
	{
		title    = 'Uçuş Okulu',
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
	    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if data.current.value == 'give_flight' then
			TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'flylic')
		elseif data.current.value == 'remove_flight' then
			ShowLicense(closestPlayer)
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'flightschool', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'flight_actions_menu'
		CurrentActionMsg  = ''
		CurrentActionData = {}
	end)
end

function ShowLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label and data.licenses[i].type then
					table.insert(elements, {
						label = data.licenses[i].label,
						type = data.licenses[i].type
					})
				end
			end
		end
		
		if ESX.PlayerData.job.name == 'flightschool' then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license',
		{
			title    = 'Lisansa El Koy',
			align    = 'top-right',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification('You revoked the players license', data.current.label, targetName)
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), 'Lisansa El Koyuldu', data.current.label)
			
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)
			
			ESX.SetTimeout(300, function()
				ShowLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

-- Teleport to the airfield
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
            DrawMarker(0, -955.57, -2966.75, 13.95, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 0, 0, 100, 0, 0, 0, 0) -- araç
			DrawMarker(0, -939.63, -2979.96, 13.95, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 0, 0, 100, 0, 0, 0, 0) -- helikopter
            DrawMarker(0, -974.83, -2999.92, 13.95, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 0, 0, 100, 0, 0, 0, 0) -- uçak
   end
end)

--[[Citizen.CreateThread(function(source)
    while true do
      Citizen.Wait(0)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
      local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -955.15, -2051.93, 8.4) -- change the last 3 values to change the coords
    if dist <= 1.2 then
	  flightnoti('~r~E ~w~basarak alana git!')
	  if IsControlJustReleased(0, 38) then
	  ESX.Game.Teleport(PlayerPedId(-1), {x = -1147.74, y = -2825.29, z = 12.96 }) -- these coords are where you spawn at the airfield
      end
	end
  end
end)

-- Teleport back to the flight school

Citizen.CreateThread(function(source)
    while true do
      Citizen.Wait(0)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
      local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -1148.54, -2826.75, 12.96) -- change the last 3 values to change the coords
    if dist <= 1.2 then
	  flightnoti('~r~E ~w~basarak uçuş okuluna git!')
	  if IsControlJustReleased(0, 38) then
	  ESX.Game.Teleport(PlayerPedId(-1), {x = -954.53, y = -2053.27, z = 8.4 }) -- these coords are where you spawn at the flight school
      end
	end
  end
end)]]

-- Spawn the caddy

Citizen.CreateThread(function(source)
    while true do
      Citizen.Wait(0)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
      local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -955.57, -2966.75, 13.95) -- change the last 3 values to change the coords
    if dist <= 1.2 and ESX.PlayerData.job.name == 'flightschool' then
	  flightnoti('~r~E ~w~basarak araç çıkar!')
	  if IsControlJustReleased(0, 38) then
	  RequestModel(1560980623)
      while not HasModelLoaded(1560980623) do
      Citizen.Wait(0)
      end
	  CreateVehicle(1560980623, -963.54, -2966.17, 13.95, 121.8, true, true)
      end
	end
  end
end)

-- Spawn the plane

Citizen.CreateThread(function(source)
    while true do
      Citizen.Wait(0)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
      local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -974.83, -2999.92, 13.95) -- change the last 3 values to change the coords
    if dist <= 1.2 and ESX.PlayerData.job.name == 'flightschool' then
	  flightnoti('~r~E ~w~basarak uçak çıkar!')
	  if IsControlJustReleased(0, 38) then
	  RequestModel(-1673356438)
      while not HasModelLoaded(-1673356438) do
      Citizen.Wait(0)
      end
	  CreateVehicle(-1673356438, -980.59, -2997.17, 12.95, 60.72, true, true)
      end
	end
  end
end)

Citizen.CreateThread(function(source)
    while true do
      Citizen.Wait(0)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
	  local ped = GetPlayerPed(-1)
	  local pedLocation = GetEntityCoords(ped, 0)
      local dist = GetDistanceBetweenCoords(-980.59, -2997.17, 12.95,  pedLocation["x"], pedLocation["y"], pedLocation["z"], true)
	  vehicle = GetVehiclePedIsIn(ped, false)
    if dist <= 5.2 and ESX.PlayerData.job.name == 'flightschool' then
	  flightnoti('~r~E ~w~basarak uçağı geri koy, ~r~R~w~ basarak tamir et/depoyu doldur!')
	if IsControlJustReleased(0, 38) then
	  ESX.Game.DeleteVehicle(vehicle)
	elseif IsControlJustReleased(0, 45) then
	  SetVehicleUndriveable(vehicle,false)
	  SetVehicleFixed(vehicle)
	  healthBodyLast=1000.0
	  healthEngineLast=1000.0
	  healthPetrolTankLast=1000.0
	  SetVehicleEngineOn(vehicle, true, false )
      end
	end
  end
end)

-- Spawn the heli

Citizen.CreateThread(function(source)
    while true do
      Citizen.Wait(0)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
      local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, -939.63, -2979.96, 13.95) -- change the last 3 values to change the coords
	  local playerPed = PlayerPedId()
    if dist <= 1.2 and ESX.PlayerData.job.name == 'flightschool' then
	  flightnoti('~r~E ~w~basarak helikopter çıkar!')
	  if IsControlJustReleased(0, 38) then
	  RequestModel(-1660661558)
      while not HasModelLoaded(-1660661558) do
      Citizen.Wait(0)
      end
	  CreateVehicle(-1660661558, -944.46, -2978.46, 13.95, 60.08, true, true)
      end
	end
  end
end)

Citizen.CreateThread(function(source)
    while true do
      Citizen.Wait(0)
      local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
	  local ped = GetPlayerPed(-1)
	  local pedLocation = GetEntityCoords(ped, 0)
      local dist = GetDistanceBetweenCoords(-944.52, -2978.44, 14.05,  pedLocation["x"], pedLocation["y"], pedLocation["z"], true)
	  vehicle = GetVehiclePedIsIn(ped, false)
    if dist <= 5.2 and ESX.PlayerData.job.name == 'flightschool' then
	  flightnoti('~r~E ~w~basarak helikopteri geri koy, ~r~R~w~ basarak tamir et/depoyu doldur!')
	if IsControlJustReleased(0, 38) then
	  ESX.Game.DeleteVehicle(vehicle)
	elseif IsControlJustReleased(0, 45) then
	  SetVehicleUndriveable(vehicle,false)
	  SetVehicleFixed(vehicle)
	  healthBodyLast=1000.0
	  healthEngineLast=1000.0
	  healthPetrolTankLast=1000.0
	  SetVehicleEngineOn(vehicle, true, false )
      end
	end
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction and not IsDead then
			ESX.ShowHelpNotification(CurrentActionMsg)
		end

		if IsControlJustReleased(0, 167) and not IsDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'flightschool' then
			OpenFlightActionsMenu()
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)