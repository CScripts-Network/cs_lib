local framework = GetFramework()

Core = {
    GetId = function(src)
        if framework == 'ESX' then
            return ESX.GetPlayerFromId(src)
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayer(src)
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
    end
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