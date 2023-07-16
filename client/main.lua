local framework = GetFramework()
local ClothesMenu = Config.Scripts.ClothesMenu
local Progressbar = Config.Scripts.Progressbar
local Inventory = Config.Scripts.Inventory

Core = {
    PlayerData = {},
    FrameworkIsReady = function()
        if framework == 'ESX' then
            while not ESX do Wait(500); end 
            while ESX.GetPlayerData().job == nil do
                Citizen.Wait(500)
            end
            Core.PlayerData = ESX.GetPlayerData()
            return true
        elseif framework == 'QB' then
            while not QBCore do Wait(500); end
            while not QBCore.Functions.GetPlayerData().job do Wait(500); end
            Core.PlayerData = QBCore.Functions.GetPlayerData()
            return true
        end
        return true
    end,

    Notification = function(message, type)
        if not type then type = 'success' end
        if Config.CustomNotify then
            CustomNotify(type, message)
        else
            if framework == 'ESX' then
                ESX.ShowNotification(message, false, true, nil)
            elseif framework == 'QB' then
                QBCore.Functions.Notify(message, type)
            end
        end
    end,

    GetGender = function()
        if framework == 'ESX' then
            TriggerEvent('skinchanger:getSkin', function(skin)
                return skin.sex
            end)
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayerData().charinfo.gender
        end
    end,

    SetDefaultClothes = function()
        if ClothesMenu == 'qb-clothes' then
            TriggerServerEvent('qb-clothes:loadPlayerSkin')
        elseif ClothesMenu == 'esx_skin' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end 
    end,

    SetClothes = function(Clothes)
        for k,v in pairs(Clothes) do
            SetPedComponentVariation(PlayerPedId(), v["component_id"], v["drawable"], v["texture"], 0)
        end
    end,

    GetJob = function()
        if framework == 'ESX' then
            return ESX.GetPlayerData().job.name
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayerData().job.name
        end
    end,

    GetGrade = function(Clothes)
        if framework == 'ESX' then
            return ESX.GetPlayerData().job.grade_label
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayerData().job.grade.name
        end
    end,

    SpawnCar = function(spawn_name, coords, heading)
        if framework == 'ESX' then
            ESX.Game.SpawnVehicle(spawn_name, coords, heading, function(callback_vehicle)
                SetVehicleFixed(callback_vehicle)
                SetVehicleDeformationFixed(callback_vehicle)
                SetVehicleEngineOn(callback_vehicle, true, true)
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
            end)
        elseif framework == 'QB' then
            QBCore.Functions.SpawnVehicle(spawn_name, function(veh)
                SetEntityHeading(veh, heading)
                SetVehicleFixed(veh)
                SetVehicleDeformationFixed(veh)
                SetVehicleEngineOn(veh, true, true)
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
                SetVehicleEngineOn(veh, true, true)
            end, coords, true)    
        end
    end,

    DeleteCar = function(car_to_del)
        DeleteVehicle(car_to_del)
    end,

    loadModel = function(model)
        while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
        return model
    end,

    WayPoint = function(v1, v2)
        SetNewWaypoint(v1, v2)
    end,

    TriggerCallback = function(name, cb, ...)
        if framework == 'ESX' then
            ESX.TriggerServerCallback(name, cb, ...)
        elseif framework == 'QB' then
            QBCore.Functions.TriggerCallback(name, cb, ...)
        end
    end,

    Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
        if Progressbar == 'progressbar' then
            exports['progressbar']:Progress({
                name = name:lower(),
                duration = duration,
                label = label,
                useWhileDead = useWhileDead,
                canCancel = canCancel,
                controlDisables = disableControls,
                animation = animation,
                prop = prop,
                propTwo = propTwo,
            }, function(cancelled)
                if not cancelled then
                    if onFinish then
                        onFinish()
                    end
                else
                    if onCancel then
                        onCancel()
                    end
                end
            end)
        end
    end,

    PlayAnimation = function(animation, dict)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(1) end
        TaskPlayAnim(PlayerPedId(), dict, animation, 2.0, 2.0, -1, 49, 0, false, false, false)
    end,

    OpenShop = function(Shop, Items)
        if Inventory == 'qb-inventory' and framework == 'QB' then
            TriggerServerEvent("inventory:server:OpenInventory", "shop", Shop, Items)
        end
    end,

    GetPlayerData = function()
        if framework == 'ESX' then
            return ESX.GetPlayerData()
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayerData()
        end
    end,

    GetAccounts = function()
        if framework == 'ESX' then
            return Core.GetPlayerData().accounts
        elseif framework == 'QB' then
            return Core.GetPlayerData().money
        end
    end,

    GetAccount = function(account)
        if framework == 'ESX' then
            return Core.GetPlayerData().accounts[account].money
        elseif framework == 'QB' then
            return Core.GetPlayerData().money[account]
        end
    end,

    Debug = function(o)
        if type(o) == 'table' then
            local s = '{ '
            for k,v in pairs(o) do
               if type(k) ~= 'number' then k = '"'..k..'"' end
               s = s .. '['..k..'] = ' .. Core.Debug(v) .. ','
            end
            return s .. '} '
         else
            return tostring(o)
         end
    end,

    PauseMenu = function()
        return not IsPauseMenuActive()
    end
}

function GetLib()
	return Core
end