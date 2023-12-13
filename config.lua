Config = {}
Config.DevMode = false -- Adds test commands and more to your server

Config.Scripts = {
    ClothesMenu = 'qb-clothes', -- Supports: qb-clothes and esx_skin
    Progressbar = 'default', -- Supports: progressbar and default
    Inventory = 'qb-inventory', -- Supports: qb-inventory
    Notification = "QB", -- Supports: QB, ESX, OKOK and CUSTOM
    TextUi = "CS_SIDEBTN" -- Supports: OKOK, CS_SIDEBTN, ESX and QB
}

-- Functions
function CustomNotify(type, message)
    print(type, message)
end
function CustomNotifyServer(type, message)
    print(type, message)
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