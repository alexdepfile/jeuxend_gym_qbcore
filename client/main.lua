local QBCore = exports['qb-core']:GetCoreObject()
local training = false
local durationGym = 10000

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Vérification en permanence

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, location in pairs(Config.Locations) do
            local distance = #(playerCoords - location.coords)

            -- Vérification de la distance et affichage
            if distance < location.viewDistance then
                -- ✅ Affiche le texte 3D
                DrawText3D(location.coords.x, location.coords.y, location.coords.z + 1.0, location.Text3D)

                -- ✅ Affiche une boîte 3D pour le debug
                if Config.Debug then
                    DrawMarker(1, location.coords.x, location.coords.y, location.coords.z - 1.0, 
                        0, 0, 0, 0, 0, 0, 
                        0.5, 0.5, 0.5, 
                        255, 0, 0, 150, false, false, 2, false, nil, nil, false)
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local scale = 1.2 -- ✅ Augmenté pour être bien visible

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextOutline() -- ✅ Bordure noire
    SetTextDropShadow() -- ✅ Ombre pour plus de visibilité
    SetTextEdge(2, 0, 0, 0, 255) -- ✅ Contour noir renforcé
    SetTextColour(255, 255, 255, 255) -- Blanc pur
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)

    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end


-- Vérification de la proximité et interaction avec "E"
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, location in pairs(Config.Locations) do
            local distance = #(playerCoords - location.coords)

            if distance < 1.5 then
                DrawText3D(location.coords.x, location.coords.y, location.coords.z + 1.0, location.Text3D)
                if IsControlJustReleased(0, 38) and not training then -- "E" pour interagir
                    StartExercise(location)
                end
            end
        end
    end
end)

-- Fonction pour commencer l'exercice
function StartExercise(location)
    local playerPed = PlayerPedId()
    training = true

    -- Créer et attacher les haltères si défini dans Config
    local prop = nil
    if location.prop then
        prop = CreateObject(GetHashKey(location.prop), GetEntityCoords(playerPed), true, true, true)
        AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    end

    -- Démarrer l'animation
    TaskStartScenarioInPlace(playerPed, location.animation, 0, true)

    -- Obtenir l'objet Skillbar
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()

    -- Lancer la barre de progression
    Skillbar.Start({
        duration = durationGym, -- 3 secondes
        pos = 20, -- Position fixe
        width = 30, -- Large pour éviter tout échec
    }, function() -- Succès
        QBCore.Functions.Notify("Exercice terminé avec succès !", "success")
    end, function() -- Échec (forcé en succès)
        QBCore.Functions.Notify("Exercice terminé avec succès !", "success")
    end)

	  -- ✅ Mise à jour de la progression gym en base
	  TriggerServerEvent('gym:UpdateProgress')

    -- Fin de l'exercice
    Citizen.SetTimeout(durationGym, function()
        ClearPedTasks(playerPed) -- Arrêter l'animation après la durée du skillbar
        training = false

        -- Supprimer l'haltère si présent
        if prop then
            DeleteEntity(prop)
        end
    end)
end


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

-- Fonction pour afficher le texte 3D
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
