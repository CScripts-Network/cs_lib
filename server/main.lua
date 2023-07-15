local framework = GetFramework()

Core = {
    GetId = function(src)
        if framework == 'ESX' then
            return ESX.GetPlayerFromId(src)
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayer(src)
        end
    end,

    RegisterCallback = function(name, cb)
        if ESX ~= nil then 
            ESX.RegisterServerCallback(name, cb)
        elseif QBCore ~= nil then
            QBCore.Functions.CreateCallback(name, cb)
        end
    end,

    GiveMoney = function(source, type, amount)
        local Player = Core.GetId(tonumber(source))
        if framework == 'ESX' then
            if type == 'bank' then
                Player.addMoney(tonumber(amount))
            else
                Player.addAccountMoney(type, tonumber(amount))
            end
        elseif framework == 'QB' then
            Player.Functions.AddMoney(type, tonumber(amount))
        end
    end,

    GiveItem = function(source, item, amount)
        local Player = Core.GetId(tonumber(source))
        if framework == 'ESX' then
            Player.addInventoryItem(item, amount)
        elseif framework == 'QB' then
            Player.Functions.AddItem(item, amount)
        end
    end,

    GetPlayers = function()
        if framework == 'ESX' then
            return ESX.GetPlayers()
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayers()
        end
    end,

    Notification = function(source, message, type)
        local Player = Core.GetId(tonumber(source))
        if not type then type = 'success' end
        if Config.CustomNotify then
            CustomNotifyServer(type, message)
        else
            if framework == 'ESX' then
                Player.ShowNotification(message, false, true, nil)
            elseif framework == 'QB' then
                TriggerClientEvent('QBCore:Notify', source, message)
            end
        end
    end,

    GetJob = function(source)
        local Player = Core.GetId(tonumber(source))
        if framework == 'ESX' then
            return Player.job.name
        elseif framework == 'QB' then
            return Player.PlayerData.job.name
        end
    end,

    SubMoney = function(source, type, amount)
        local Player = Core.GetId(tonumber(source))
        if framework == 'ESX' then
            if type == 'bank' then
                Player.removeMoney(tonumber(amount))
            else
                Player.removeAccountMoney(type, tonumber(amount))
            end
        elseif framework == 'QB' then
            Player.Functions.RemoveMoney(type, tonumber(amount))
        end
    end,
}

local version = GetResourceMetadata(GetCurrentResourceName(), "version")
local url = "https://raw.githubusercontent.com/CScripts-Network/cs_lib/main/version"
PerformHttpRequest(url, function(err, ver, headers)
    local text = ver:gsub('%s+', '')
    if (text ~= nil) then
            print(" ____________________________________________")
            print("  ██████ ███████         ██      ██ ██████  ")
            print(" ██      ██              ██      ██ ██   ██ ")
            print(" ██      ███████         ██      ██ ██████  ")
            print(" ██           ██         ██      ██ ██   ██ ")
            print("  ██████ ███████ ███████ ███████ ██ ██████  ")
            print("____________________________________________")
            print("   Discord: https://discord.gg/2kcXW3gRzg   ")
        if version == text then
            print("        Youre version is up to date!        ")
        else
            print("         Current Version: v"..version.."      ")
            print("           New Version: v"..text.."          ")
        end
    end
end, "GET", "", "")

function GetLib()
	return Core
end