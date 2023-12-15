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

    DevMode = function()
        return Config.DevMode
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
        if not type then type = 'success' end
        if Config.Scripts.Notification == 'ESX' then
            Player.ShowNotification(message, false, true, nil)
        elseif Notification == 'OKOK' then
            TriggerClientEvent('okokNotify:Alert', source, type, message, 3000, type, false)
        elseif Config.Scripts.Notification == 'QB' then
            TriggerClientEvent('QBCore:Notify', source, message)
        else
            CustomNotifyServer(type, message)
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

    VersionCheck = function(github, script_name)
        local version = GetResourceMetadata(script_name, "version")
        PerformHttpRequest(github, function(err, ver, headers)
            local text = ver:gsub('%s+', '')
            if (text ~= nil) then
                if version == text then
                    print("        Youre version is up to date!        ")
                else
                    print("         Current Version: v"..version.."      ")
                    print("           New Version: v"..text.."          ")
                end
            end
        end, "GET", "", "")
    end,

    MakeItem = function(item, cb)
        if framework == 'QB' then
            QBCore.Functions.CreateUseableItem(item, function(source, item)
                local Player = QBCore.Functions.GetPlayer(source)
                if not Player.Functions.GetItemByName(item.name) then return end
                    cb(source)
            end)
        elseif framework == 'ESX' then
            ESX.RegisterUsableItem(item, function(source)
                cb()
            end)
        end
    end,

    RemoveItem = function(source, item, amount)
        local Player = Core.GetId(tonumber(source))
        if framework == 'ESX' then
            Player.removeInventoryItem(item, amount)
        elseif framework == 'QB' then
            Player.Functions.RemoveItem(item, amount)
        end
    end,

    ReplaceString = function(main_text, replace, replaceto)
        return string.gsub(main_text, replace, replaceto)
    end
}

local url = "https://raw.githubusercontent.com/CScripts-Network/cs_lib/main/version"
print(" ____________________________________________")
print("  ██████ ███████         ██      ██ ██████  ")
print(" ██      ██              ██      ██ ██   ██ ")
print(" ██      ███████         ██      ██ ██████  ")
print(" ██           ██         ██      ██ ██   ██ ")
print("  ██████ ███████ ███████ ███████ ██ ██████  ")
print("____________________________________________")
print("     Website:  https://cscripts.network     ")
Core.VersionCheck(url, 'cs_lib')


function GetLib()
	return Core
end