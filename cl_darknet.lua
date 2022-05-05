local RZS = {
    main = false,
    Pseudo = "Anonyme "..math.random(10,999),
    CheckBox = false,
    Index = 1,
    Message = '',
    Confirm = '',
}

ESX = nil

Citizen.CreateThread(function()
    while ESX==nil do TriggerEvent('esx:getSharedObject',function(a)ESX=a end)Citizen.Wait(100)end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()

    RMenu.Add('darknet', 'main', RageUI.CreateMenu(ConfigDarknet.name, ConfigDarknet.description))
    RMenu.Add('darknet', 'object_sell', RageUI.CreateSubMenu(RMenu:Get('darknet', 'main'), ConfigDarknet.name, ConfigDarknet.description))
    RMenu:Get('darknet', 'main').Closed = function()
        RZS.main = false
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)



function RzsMenu()
    if RZS.main then
        RZS.main = false
    else
        RZS.main = true
        RageUI.Visible(RMenu:Get('darknet', 'main'), true)

        Citizen.CreateThread(function()
            while RZS.main do

                Citizen.Wait(1)

                RageUI.IsVisible(RMenu:Get('darknet', 'main'), true, true, true, function()

                    RageUI.Button("Pseudo :", nil, {RightLabel = RZS.Pseudo }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RZS.Pseudo = DarknetKeyboardput("Entrez le pseudo que vous souhaitez !", "", 25)
                            if RZS.Pseudo == nil or RZS.Pseudo == '' then
                                RZS.Pseudo = "Anonyme "..math.random(10,999)
                            end
                        end
                    end)

                    RageUI.Button("Message dans le darknet", nil, {RightBadge = RageUI.BadgeStyle.Tick }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local BlackList_Word = false
                            RZS.Message = DarknetKeyboardput("Entrez le message que vous voulez publier !", "", 60)
                            if RZS.Message == nil or RZS.Message == '' then
                                RZS.Message = ''
                            else
                                for k,v in pairs(ConfigDarknet.Words_Blacklist) do
                                    if string.match(RZS.Message, v) then
                                        BlackList_Word = true
                                    end
                                end
                                if BlackList_Word then
                                    ESX.ShowNotification('~r~Un de vos mots est interdit !')
                                else
                                    TriggerServerEvent('rzs_darknet:notif', RZS.Pseudo, RZS.Message)
                                end
                            end
                        end
                    end)

                    RageUI.Button("Informations BlackMarket", nil , {RightLabel = "→→→"},true, function()
                    end, RMenu:Get('darknet', 'object_sell'))

                end, function()
                end)
                        
                RageUI.IsVisible(RMenu:Get('darknet', 'object_sell'), true, true, true, function()
                    RageUI.Separator('~p~↓ Armes ↓')
                    for k,v in pairs(ConfigDarknet.Armes) do
                        RageUI.Button(v.name.." [~g~"..ESX.Math.GroupDigits(v.prix).."$~s~]", v.informations, {RightLabel = "Vendeur : ~b~"..v.vendeur}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if ConfigDarknet.Buy_In then
                                    RZS.Confirm = ''
                                    RZS.Confirm = DarknetKeyboardput("Accepter la transaction de "..ESX.Math.GroupDigits(v.prix).."$ en tapant Confirmer:", "", 60)
                                    if RZS.Confirm == '' or RZS.Confirm == nil then
                                        RZS.Confirm = ''
                                        ESX.ShowNotification('~r~Transaction annulé !')
                                    else
                                        if RZS.Confirm == 'Confirmer' or RZS.Confirm == 'confirmer' then
                                            TriggerServerEvent('rzs_darknet:buy', 'weapon', v.name, v.label, v.prix)
                                        else
                                            ESX.ShowNotification('~r~Transaction annulé !')
                                        end
                                    end
                                else
                                    ESX.ShowNotification("Vendeur : ~b~"..v.vendeur.."\n~s~Numéro du vendeur : ~b~"..v.tel)
                                end
                            end
                        end)
                    end

                    RageUI.Separator('~b~↓ Objets ↓')
                    for k,v in pairs(ConfigDarknet.Objets) do
                        RageUI.Button(v.name.." [~g~"..ESX.Math.GroupDigits(v.prix).."$~s~]", v.informations, {RightLabel = "Vendeur : ~b~"..v.vendeur}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                if ConfigDarknet.Buy_In then
                                    RZS.Confirm = ''
                                    RZS.Confirm = DarknetKeyboardput("Accepter la transaction de "..ESX.Math.GroupDigits(v.prix).."$ en tapant Confirmer:", "", 60)
                                    if RZS.Confirm == '' or RZS.Confirm == nil then
                                        RZS.Confirm = ''
                                        ESX.ShowNotification('~r~Transaction annulé !')
                                    else
                                        if RZS.Confirm == 'Confirmer' or RZS.Confirm == 'confirmer' then
                                            TriggerServerEvent('rzs_darknet:buy', 'item', v.name, v.label, v.prix)
                                        else
                                            ESX.ShowNotification('~r~Transaction annulé !')
                                        end
                                    end
                                else
                                    ESX.ShowNotification("Vendeur : ~b~"..v.vendeur.."\n~s~Numéro du vendeur : ~b~"..v.tel)
                                end
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

RegisterKeyMapping(ConfigDarknet.Command, "Menu Darknet", "keyboard", ConfigDarknet.Touche)
RegisterCommand(ConfigDarknet.Command, function()
    local isAllow = true
    for k,v in pairs(ConfigDarknet.Job_Blacklist) do
        if ESX.PlayerData.job.name == v then
            isAllow = false
            ESX.ShowNotification(ConfigDarknet.AccesDeniedNotif)
        end
    end
    if isAllow then
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            RzsMenu()
        else
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, true)
            Wait(1250)
            ESX.ShowNotification('~r~Connexion au darknet en cours ...')
            Wait(1250)
            RzsMenu()
        end
    end
end)

function DarknetKeyboardput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end
