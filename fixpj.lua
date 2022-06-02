local soymrx = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('resetskin:resetSkin')
AddEventHandler('resetskin:resetSkin', function()
    
    local uniforms = {
  
          male = {
              ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
              ['torso_1'] = 260,   ['torso_2'] = 23,
              ['decals_1'] = 0,   ['decals_2'] = 0,
              ['arms'] = 11,
              ['pants_1'] = 26,   ['pants_2'] = 6,
              ['shoes_1'] = 1,   ['shoes_2'] = 0,
              ['chain_1'] = 0,  ['chain_2'] = 0
          },
          female = {
              ['tshirt_1'] = 14,   ['tshirt_2'] = 0,
              ['torso_1'] = 269,    ['torso_2'] = 23,
              ['decals_1'] = 0,   ['decals_2'] = 0,
              ['arms'] = 9,
              ['pants_1'] = 0,   ['pants_2'] = 8,
              ['shoes_1'] = 1,    ['shoes_2'] = 1,
              ['chain_1'] = 0,    ['chain_2'] = 0
          }

    }
    local playerPed = PlayerPedId()
    local lastHealth = GetEntityHealth(playerPed) 
    local defaultModel = GetHashKey('a_m_y_stbla_02')
    SetEntityVisible(PlayerPedId(), false)
    RequestModel(defaultModel)
    while not HasModelLoaded(defaultModel) do
        Citizen.Wait(100)
    end
    SetPlayerModel(PlayerId(), defaultModel)
    
    
    SetPedDefaultComponentVariation(PlayerPedId())
    SetPedRandomComponentVariation(PlayerPedId(), true)
    SetModelAsNoLongerNeeded(defaultModel)
    FreezeEntityPosition(PlayerPedId(), false)
 
    Citizen.Wait(300)

    TriggerEvent('skinchanger:getSkin', function(skin)
  
        skin['sex'] = changeSex(skin['sex']) --cambiamos sexo
        TriggerEvent('skinchanger:loadSkin', skin)
        Citizen.Wait(300)
        skin['sex'] = changeSex(skin['sex'])
        TriggerEvent('skinchanger:loadSkin', skin)
        ESX.ShowNotification('~g~Skin recargada')
    end)
    Citizen.Wait(1000)
    TriggerEvent('skinchanger:getSkin', function(skin)
  
        if skin.sex == 0 then
            if uniforms.male ~= nil then
                TriggerEvent('skinchanger:loadClothes', skin, uniforms.male)
            else
                ESX.ShowNotification('~r~Error')
            end
        else
            if uniforms.female ~= nil then
                TriggerEvent('skinchanger:loadClothes', skin, uniforms.female)
            else
                ESX.ShowNotification('~r~Error')
            end
        end
    end)
    Citizen.Wait(300)

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    SetEntityHealth(GetPlayerPed(-1), lastHealth)
    SetEntityVisible(PlayerPedId(), true)
    ClearPedTasksImmediately(GetPlayerPed(-1))

    TriggerEvent('esx_tattooshop:cleanPlayer')


    
end)

function changeSex(sex)

    if sex == 0 then sex = 1 else sex = 0 end

    return sex

end

RegisterCommand("rskin", function(source, args, raw)
    TriggerEvent("resetskin:resetSkin")
end, false) 

RegisterNetEvent('lester:skin')
AddEventHandler('lester:skin', function()
    

    if soymrx == false then
        
        local modelHash = GetHashKey('player_one')
        local isMalePed = false

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

            if skin.sex == 1 then
                modelHash = GetHashKey('player_one')
                isMalePed = true
            end

            ESX.Streaming.RequestModel(0x9B22DBAF, function()
                SetPlayerModel(PlayerId(), 0x9B22DBAF)
                SetModelAsNoLongerNeeded(0x9B22DBAF)
                SetPedDefaultComponentVariation(PlayerPedId())

                if isMalePed == true then
                    local playerPed = PlayerPedId()
                    SetPedComponentVariation	(playerPed, 8, 0, 0, 2)
                    SetPedComponentVariation	(playerPed, 11,	0, 0, 2)
                    SetPedComponentVariation	(playerPed, 3, 1, 0, 2)
                    SetPedComponentVariation	(playerPed, 4, 0, 0, 2)
                    SetPedPropIndex	(playerPed, 0, 0, 0, 2)
                end

                TriggerEvent('esx:restoreLoadout')
            end)
        end)
            soymrx = true
    else
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            local isMale = skin.sex == 0

            TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                    TriggerEvent('esx:restoreLoadout')
                end)
            end)
        end)
            soymrx = false
    end

end)