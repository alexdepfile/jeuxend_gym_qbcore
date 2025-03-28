local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('gym:UpdateProgress')
AddEventHandler('gym:UpdateProgress', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        exports['oxmysql']:execute('SELECT gym FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
            local currentGym = result[1] and result[1].gym or 0
            local newGym = math.min(currentGym + 5, 100) -- ✅ On ajoute 5, max 100

            -- ✅ Mettre à jour la base de données
            exports['oxmysql']:execute('UPDATE players SET gym = ? WHERE citizenid = ?', {newGym, Player.PlayerData.citizenid})

            -- ✅ Envoyer la progression mise à jour au client
            TriggerClientEvent('QBCore:Notify', src, "Ta progression Gym est maintenant de "..newGym.."/100", "success")
        end)
    end
end)
