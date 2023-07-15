Config = {}

Config.CustomNotify = false

Config.Scripts = {
    ClothesMenu = 'qb-clothes' -- Supports: qb-clothes and esx_skin
}

-- Functions
function CustomNotify(type, message)
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