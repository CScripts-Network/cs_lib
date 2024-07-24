Config = {}
Config.DevMode = false -- Adds test commands and more to your server
Config.DebugMode = false -- Adds debug prints

Config.Scripts = {
    ClothesMenu = 'esx_skin', -- Supports: qb-clothes and esx_skin
    Progressbar = 'default', -- Supports: progressbar, ox-progressbar, ox-progresscircle and default
    ProgressCirclePos = 'bottom', -- Supports: middle or bottom ! ONLY USE IF YOU'RE USING OX-PROGRESSCIRCLE !
    Inventory = 'qb-inventory', -- Supports: qb-inventory and ox_inventory
    Notification = "ESX", -- Supports: QB, ESX, OKOK, OX, mythic, 17mov and CUSTOM
    HelpNotification = "ESX", -- Supports: default, ESX and QB
    TextUi = "CS_SIDEBTN" -- Supports: OKOK, CS_SIDEBTN, ESX, OX and QB
}

-- Functions
function CustomNotify(type, message)
    print(type, message) -- Put your custom notify trigger or export here (CLIENT)
end

function CustomNotifyServer(type, message)
    print(type, message) -- Put your custom notify trigger or export here (SERVER)
end

function GetFramework()
    if GetResourceState('qb-core'):find('started') then
        QBCore = exports['qb-core']:GetCoreObject()
        return 'QB'
    elseif GetResourceState('es_extended'):find('started') then
        ESX = exports['es_extended']:getSharedObject()
        return 'ESX'
    else
        return 'STANDALONE'
    end
end