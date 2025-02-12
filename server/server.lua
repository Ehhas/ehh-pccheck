Players = {}
PlayersChecked = {}

RegisterServerEvent('Ehh-pccheck:clientNotif', function (AdminId, Info)
    TriggerClientEvent('ox_lib:notify', AdminId, Info)
end)

function Notification(info)
    TriggerClientEvent('ox_lib:notify', source, info)
end

function SendToDiscord(name, message, color)
    local content = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
            },
        }
    }

    PerformHttpRequest(ServerConfig.Webhook, function(err, text, headers) end, "POST", json.encode({username = "Pc Check Logs", embeds = content}), {["Content-Type"] = "application/json"})
end

lib.addCommand('pccheck', {
    help = 'Opens a menu on the screen that he needs a pc check and stops them from moving',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
    },
    restricted = 'Config.AdminPermisions'
}, function(source, args, raw)
    local id = args.target
    local xPlayer = ESX.GetPlayerFromId(args.target)
 
    if id and xPlayer then
        if Players[id] == nil then
            lib.callback('ehh-pccheck:open-menu-for-player', id, function(result)
                if result and Players[id] == nil then
                    SendToDiscord('Pc Check summon', '**Player:** '..id..'\n **name:** '..GetPlayerName(id)..'\n **License of the one that got summoned:** '..GetPlayerIdentifierByType(id, "license")..'\n **Who summoned:** '..source..'\n **Who summoned name:** '.. GetPlayerName(source)..'\n **License of the one who summoned:** '..GetPlayerIdentifierByType(id, "license"), 16711680)
                    Notification({
                        title = 'Pc Check',
                        description = 'You have summoned the player for a pc check',
                        type = 'success'
                    })
                    Players[id] = true
                    PlayersChecked[id] = source
                elseif not result then
                    Notification({
                        title = 'Pc Check',
                        description = 'Something went wrong',
                        type = 'error'
                    })
                end
            end, id, source)
        elseif Players[id] == true then
            Notification({
                title = 'Pc Check',
                description = 'Player is already getting pc checked',
                type = 'error'
            })
        end
    elseif not id or not xPlayer or not id and not xPlayer then
        Notification({
            title = 'Pc Check',
            description = 'This player does not exist or is not in the game',
            type = 'error'
        })
    end
end)

lib.addCommand('pccheckcancel', {
    help = 'Closes the pc check menu',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id',
        },
    },
    restricted = 'Config.AdminPermisions'
}, function(source, args, raw)
    local id = args.target
    local xPlayer = ESX.GetPlayerFromId(args.target)

    if id and xPlayer then
        if Players[id] == true then
            lib.callback('ehh-pccheck:close-menu-for-player', id, function(result)
                if result and Players[id] == true then
                    SendToDiscord('Pc Check clear', '**Player:** '..id..'\n **name:** '..GetPlayerName(id)..'\n **License of the one that got pc checked:** '..string.gsub(GetPlayerIdentifierByType(id, "license"), "license:", "")..'\n **Discord Id of the one that got pc checked:** '..string.gsub(GetPlayerIdentifierByType(id, "discord"), "discord:", "")..'\n **Who was pc checking:** '..AdminId..'\n **Who was pc checking name:** '.. GetPlayerName(AdminId)..'\n **License of the one who was pc checking:** '..string.gsub(GetPlayerIdentifierByType(AdminId, "license"), "license:", "")..'\n **Discord Id of the one that was pc checking:** '..string.gsub(GetPlayerIdentifierByType(AdminId, "discord"), "discord:", ""), 16711680)
                    Players[id] = nil
                    Notification({
                        title = 'Pc Check',
                        description = 'You have confirmed that this player is clear and let him go',
                        type = 'success'
                    })
                elseif not result then
                    Notification({
                        title = 'Pc Check',
                        description = 'Something went wrong',
                        type = 'error'
                    })
                end
            end, id)
        elseif Players[id] == nil then
            Notification({
                title = 'Pc Check',
                description = 'This player is not getting pc checked',
                type = 'error'
            })
        end
    elseif not id or not xPlayer or not id and not xPlayer then
        Notification({
            title = 'Pc Check',
            description = 'This player does not exist or is not in the game',
            type = 'error'
        })
    end
end)

AddEventHandler('playerDropped', function (reason, resourceName, clientDropReason)
    if Players[source] then
        TriggerServerEvent('ehh-pccheck:Auto-ban-player', source, PlayersChecked[source])
    end
end)

RegisterServerEvent('ehh-pccheck:Auto-ban-player', function (id, AdminId)
    if Players[id] then
        if Config.IsAutoBan then
            if Config.BanType == 'fg' then
                exports[Config.AnticheatName]:fg_BanPlayer(id, 'This player left while getting pc checked or evaded a pc check')
                SendToDiscord('Pc Check ban', '**Player:** '..id..'\n **name:** '..GetPlayerName(id)..'\n **License of the one that got banned:** '..string.gsub(GetPlayerIdentifierByType(id, "license"), "license:", "")..'\n **Discord Id of the one that got banned:** '..string.gsub(GetPlayerIdentifierByType(id, "discord"), "discord:", "")..'\n **Who was pc checking:** '..AdminId..'\n **Who was pc checking name:** '.. GetPlayerName(AdminId)..'\n **License of the one who was pc checking:** '..string.gsub(GetPlayerIdentifierByType(AdminId, "license"), "license:", "")..'\n **Discord Id of the one that was pc checking:** '..string.gsub(GetPlayerIdentifierByType(AdminId, "discord"), "discord:", ""), 16711680)
            elseif Config.BanType == 'electron' then
                exports["ElectronAC"]:banPlayer(id, 'This player left while getting pc checked', 'This player was getting pc checked and left or ran out of time', true)
                SendToDiscord('Pc Check ban', '**Player:** '..id..'\n **name:** '..GetPlayerName(id)..'\n **License of the one that got banned:** '..string.gsub(GetPlayerIdentifierByType(id, "license"), "license:", "")..'\n **Discord Id of the one that got banned:** '..string.gsub(GetPlayerIdentifierByType(id, "discord"), "discord:", "")..'\n **Who was pc checking:** '..AdminId..'\n **Who was pc checking name:** '.. GetPlayerName(AdminId)..'\n **License of the one who was pc checking:** '..string.gsub(GetPlayerIdentifierByType(AdminId, "license"), "license:", "")..'\n **Discord Id of the one that was pc checking:** '..string.gsub(GetPlayerIdentifierByType(AdminId, "discord"), "discord:", ""), 16711680)
            elseif Config.BanType == 'EA' then
                TriggerEvent("EasyAdmin:addBan", id, 0, 'This player left while getting pc checked', GetPlayerName(AdminId))
                SendToDiscord('Pc Check ban', '**Player:** '..id..'\n **name:** '..GetPlayerName(id)..'\n **License of the one that got banned:** '..string.gsub(GetPlayerIdentifierByType(id, "license"), "license:", "")..'\n **Discord Id of the one that got banned:** '..string.gsub(GetPlayerIdentifierByType(id, "discord"), "discord:", "")..'\n **Who was pc checking:** '..AdminId..'\n **Who was pc checking name:** '.. GetPlayerName(AdminId)..'\n **License of the one who was pc checking:** '..string.gsub(GetPlayerIdentifierByType(AdminId, "license"), "license:", "")..'\n **Discord Id of the one that was pc checking:** '..string.gsub(GetPlayerIdentifierByType(AdminId, "discord"), "discord:", ""), 16711680)
            else end
        else end
    end
end)
