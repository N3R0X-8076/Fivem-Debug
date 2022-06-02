Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if GetEntityMaxHealth(PlayerPedId()) ~= 200 then
            SetEntityMaxHealth(PlayerPedId(), 200)
            SetEntityHealth(PlayerPedId(), 200)
        end
    end
end)