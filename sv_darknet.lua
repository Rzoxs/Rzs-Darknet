ESX = nil
local servername = "Kyro"
local license = 'joK7CXHdaGOD2pOft3gxgnAYxVnmJ7Ya1WC85S4p'

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('rzs_darknet:notif')
AddEventHandler('rzs_darknet:notif', function(pseudo, message)
    local src = source
    local args = msg
    if player ~= false then
        local name = GetPlayerName(source)
        local xPlayers	= ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name ~= "police" then
                TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'VPS', pseudo, ''..message..'', 'CHAR_LESTER_DEATHWISH', 0)
            end
        end
    end
end)

RegisterServerEvent('rzs_darknet:buy')
AddEventHandler('rzs_darknet:buy', function(type, name, label, prix)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getMoney()

    if type == "weapon" then
        if xPlayer.hasWeapon(label) then
            TriggerClientEvent('esx:showNotification', source, "~r~Vous avez déjà un exemplaire sur vous !")
        else
            if xMoney >= prix then
                xPlayer.removeMoney(prix)
                xPlayer.addWeapon(label, 250)
                TriggerClientEvent('esx:showNotification', source, "~p~Vous achetez "..name.." au prix de ~b~" ..ESX.Math.GroupDigits(prix).. "$")
            else
                TriggerClientEvent('esx:showNotification', source, "~p~Il vous manque~b~ "..ESX.Math.GroupDigits(prix-xMoney).."$")
            end
        end
    elseif type == "item" then
        if xMoney >= prix then
            xPlayer.removeMoney(prix)
            xPlayer.addInventoryItem(label, 1)
            TriggerClientEvent('esx:showNotification', source, "~p~Vous achetez "..name.." au prix de ~b~" ..ESX.Math.GroupDigits(prix).. "$")
        else
            TriggerClientEvent('esx:showNotification', source, "~p~Il vous manque~b~ "..ESX.Math.GroupDigits(prix-xMoney).."$")
        end
    end
end)