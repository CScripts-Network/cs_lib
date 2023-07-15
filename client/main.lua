local framework = GetFramework()
local ClothesMenu = Config.Scripts.ClothesMenu

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

    GetJob = function(Clothes)
        if framework == 'ESX' then
            return ESX.GetPlayerData().job.name
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayerData().job.name
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
    end
}

function GetLib()
	return Core
end