local framework = GetFramework()
local ClothesMenu = Config.Scripts.ClothesMenu
local Progressbar = Config.Scripts.Progressbar
local ProgressCirclePos = Config.Scripts.ProgressCirclePos
local Inventory = Config.Scripts.Inventory
local Notification = Config.Scripts.Notification
local HelpNotification = Config.Scripts.HelpNotification
local TextUi = Config.Scripts.TextUi
local DebugMode = Config.DebugMode
local cam

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
        elseif framework == 'STANDALONE' then
            if DebugMode then
                print('[CS_LIB] Ready to run in standalone')
            end
            return true
        end
        return true
    end,

    Notification = function(message, type)
        if not type then type = 'success' end
        if Notification == 'ESX' then
            ESX.ShowNotification(message, false, true, nil)
        elseif Notification == 'OKOK' then
            exports['okokNotify']:Alert(type, message, 3000, type, false)
        elseif Notification == 'QB' then
            QBCore.Functions.Notify(message, type)
        elseif Notification == 'mythic' then
            exports['mythic_notify']:DoCustomHudText(type, message, 8000, {})
        elseif Notification == 'OX' then
            lib.notify({
                title = 'Notification',
                description = message,
                type = type
            })
        elseif Notification == '17mov' then
            exports["17mov_Hud"]:ShowNotification(message, type, 'Notification', 8000)
        elseif framework == 'STANDALONE' then
            AddTextEntry('cs_lib', message)
            BeginTextCommandThefeedPost('cs_lib')
            EndTextCommandThefeedPostTicker(false, true)
        else
            CustomNotify(type, message)
        end
    end,

    TextUI = function(id, message, color, position, btn)
        if not type then type = 'success' end
        if TextUi == 'ESX' then
            ESX.ShowHelpNotification(v.Hint)
        elseif TextUi == 'OKOK' then
            exports['okokTextUI']:Open(message, color, position)
        elseif TextUi == 'QB' then
            exports['qb-core']:DrawText(message, position)
        elseif TextUi == 'CS_SIDEBTN' then
            TriggerEvent('cs_sidebtn:add', id, message, btn)
        elseif TextUi == 'OX' then
            lib.showTextUI(message)
        end
    end,

    RemoveTextUI = function(id)
        if not type then type = 'success' end
        if TextUi == 'ESX' then
            if DebugMode then
                print('[ERROR] ESX ShowHelpNotification can`t be hidden/removed')
            end
        elseif TextUi == 'OKOK' then
            exports['okokTextUI']:Close()
        elseif TextUi == 'QB' then
            exports['qb-core']:HideText()
        elseif TextUi == 'CS_SIDEBTN' then
            TriggerEvent('cs_sidebtn:remove', id)
        elseif TextUi == 'OX' then
            lib.hideTextUI()
        end
    end,

    DevMode = function()
        return Config.DevMode
    end,

    GetGender = function()
        if framework == 'ESX' then
            TriggerEvent('skinchanger:getSkin', function(skin)
                return skin.sex
            end)
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayerData().charinfo.gender
        elseif framework == 'STANDALONE' then
            return '1'
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

    LoadDevCommands = function(Script, Commands)
        for k,v in pairs(Commands) do
            if DebugMode then
                print('['..Script..'] Loaded `'..v..'` command')
            end
        end
    end,

    GetJob = function()
        if framework == 'ESX' then
            return ESX.GetPlayerData().job.name
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayerData().job.name
        elseif framework == 'STANDALONE' then
            return 'STANDALONE'
        end
    end,

    GetGrade = function(Clothes)
        if framework == 'ESX' then
            return ESX.GetPlayerData().job.grade_label
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayerData().job.grade.name
        elseif framework == 'STANDALONE' then
            return 'unemployed'
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

    Progressbar = function(name, icon, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
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
        elseif Progressbar == 'default' then
            Progress({
                name = name:lower(),
                duration = duration,
                label = label,
                useWhileDead = useWhileDead,
                canCancel = canCancel,
                controlDisables = disableControls,
                animation = animation,
                prop = prop,
                propTwo = propTwo,
                icon = icon,
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
        elseif Progressbar == 'ox-progressbar' then
            if lib.progressBar({
                duration = duration,
                label = label,
                useWhileDead = useWhileDead,
                canCancel = canCancel,
                disable = disableControls,
                anim = animation,
                prop = prop
            })  then onFinish() else onCancel() end
        elseif Progressbar == 'ox-progresscircle' then
            if lib.progressCircle({
                duration = duration,
                position = ProgressCirclePos,
                useWhileDead = useWhileDead,
                canCancel = canCancel,
                disable = disableControls,
                anim = animation,
                prop = prop
            }) then onFinish() else onCancel() end
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

    OpenShop = function(Shop, Items, ox_id)
        if not ox_id then ox_id = 'success' end

        if Inventory == 'qb-inventory' and framework == 'QB' then
            TriggerServerEvent("inventory:server:OpenInventory", "shop", Shop, Items)
        elseif Inventory == 'ox_inventory' then
            exports.ox_inventory:openInventory('shop', { type = Shop, id = ox_id })
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
            local accounts = ESX.GetPlayerData().accounts
            for _, data in pairs(accounts) do
                if data.name == 'bank' and account == 'bank' then
                    return data.money
                elseif data.name == 'money' and account == 'cash' then
                    return data.money
                elseif data.name == 'black_money' and account == 'black_money' then
                    return data.money
                end
            end

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
    end,

    GetVehicleInDirection = function()
        local playerPed    = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed, 1)
        local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
        local rayHandle    = CastRayPointToPoint(playerCoords.x, playerCoords.y, playerCoords.z, inDirection.x, inDirection.y, inDirection.z, 10, playerPed, 0)
        local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        return vehicle
    end,

    DrawTimerProgressBar = function(idx, title, text, titleColor, textColor, usePlayerStyle)
        DrawTimerProgressBar(idx, title, text, titleColor, textColor, usePlayerStyle)
    end,

    PedRunAway = function(ped)
        FreezeEntityPosition(ped, false)
        SetBlockingOfNonTemporaryEvents(ped, false)
        SetEntityInvincible(ped, false)
        TaskSmartFleePed(ped, GetPlayerPed(PlayerId()), 100.0, -1)
    end,

    ReplaceNearProp = function(ped, dist, new_prop, old_prop)
        local PropNear = GetClosestObjectOfType(GetEntityCoords(ped), dist, GetHashKey(old_prop))
        if DoesEntityExist(PropNear) then
            CreateModelSwap(GetEntityCoords(PropNear), 0.5, GetHashKey(old_prop), GetHashKey(new_prop), false)
        end
    end,

    ReplaceString = function(main_text, replace, replaceto)
        return string.gsub(main_text, replace, replaceto)
    end,

    HelpNotification = function(text)
        if HelpNotification == 'default' then
            SetTextComponentFormat("STRING")
            AddTextComponentString(text)
            DisplayHelpTextFromStringLabel(0, 0, 1, 50)
        elseif HelpNotification == 'ESX' then
            ESX.ShowHelpNotification(text)
        elseif HelpNotification == 'QB' then
            QBCore.Functions.Notify(text)
        end
    end,

    PlayCutscene = function(typer)
        if IsPedMale(PlayerPedId()) then RequestCutsceneWithPlaybackList(typer, 31, 8)
            else RequestCutsceneWithPlaybackList(typer, 103, 8) end
    
            while not HasCutsceneLoaded() do Wait(10)  
        end
        StartCutscene(4)
    end,

    HelpNotify = function(message)
        AddTextEntry('cs_lib', message)
        BeginTextCommandDisplayHelp('cs_lib')
        EndTextCommandDisplayHelp(0, false, true, -1)
    end,

    SetPed = function(player, ped)
        if IsModelInCdimage(ped) and IsModelValid(ped) then
            RequestModel(ped)
            while not HasModelLoaded(ped) do
              Wait(0)
            end
            SetPlayerModel(player, ped)
            SetModelAsNoLongerNeeded(ped)
        end
    end,

    loadDict = function(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
        return dict
    end,

    GetClosestVehicleToPlayer = function()
        local plyPed = PlayerPedId()
        local plyPos = GetEntityCoords(plyPed, false)
        local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.0, 0.0)
        local radius = 3.0
        local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, radius, 10, plyPed, 7)
        local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
        return vehicle
    end,

    GetClosestPed = function(minDistance)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local closestPed = nil
        
        for _, ped in ipairs(GetGamePool('CPed')) do
            if ped ~= playerPed and not IsPedAPlayer(ped) then
                local pedCoords = GetEntityCoords(ped)
                local distance = GetDistanceBetweenCoords(playerCoords, pedCoords, true)
                if distance <= minDistance then
                    closestPed = ped
                    break
                end
            end
        end
        return closestPed
    end,

    OpenDialogWithPed = function(ped)
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 1.5, 0.3)
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped) + 180, 5)
        SetCamFov(cam, 40.0)
        SetPedCombatAttributes(ped, 46, true)                     
        SetPedFleeAttributes(ped, 0, 0)               
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityAsMissionEntity(ped, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedHearingRange(ped, 1.0)
        SetPedAlertness(ped, 0)
        ClearPedTasksImmediately(ped)
    end,

    CloseDialogWithPed = function(ped)
        if cam then
            SetCamActive(cam, false)
            RenderScriptCams(false, true, 500, true, true)
            DestroyCam(cam, false)
            cam = nil
        end
        SetPedCombatAttributes(ped, 46, false)                                 
        SetBlockingOfNonTemporaryEvents(ped, false)
        SetEntityAsMissionEntity(ped, false, false)
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        SetPedHearingRange(ped, 1.0)
        SetPedAlertness(ped, 0)
        TaskWanderStandard(ped, 10.0, 10)
    end
}

function GetLib()
	return Core
end