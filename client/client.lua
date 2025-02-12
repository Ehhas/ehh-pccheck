IsMenuOpen = false
IsGettingChecked = false

lib.callback.register('ehh-pccheck:open-menu-for-player', function (id, adminId)
    if not IsGettingChecked and not IsMenuOpen then
        IsMenuOpen = true
        IsGettingChecked = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            isOpen = IsMenuOpen,
            IsTimmed = Config.IsTimmed,
            time = Config.TimeToJoinForPcCheck,
            invite = Config.DiscordInvite,
            id = id,
            adminId = adminId
        })
        return true
    end
    return false
end)

lib.callback.register('ehh-pccheck:close-menu-for-player', function (id)
    if IsGettingChecked and IsMenuOpen then
        IsMenuOpen = false
        IsGettingChecked = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            isOpen = IsMenuOpen,
        })
        return true
    end
    return false
end)

RegisterNUICallback('GetInvite', function(data)
    local invite = data.invite

    lib.setClipboard(invite)
end)

RegisterNUICallback('BanPlayerBecauseTime', function(data)
    local id = data.id
    local adminId = data.adminId
    if Config.IsAutoBanWithTime then
        if Config.IsAutoBan then
            if id then
                TriggerServerEvent('ehh-pccheck:Auto-ban-player', id, adminId)
            end
        else
            TriggerServerEvent('Ehh-pccheck:clientNotif', adminId, {
                title = 'Pc Check',
                description = 'The player\'s '.. id ..' has ran out of time',
                type = 'success'
            })
        end
    else
        TriggerServerEvent('Ehh-pccheck:clientNotif', adminId, {
            title = 'Pc Check',
            description = 'The player\'s '.. id ..' has ran out of time',
            type = 'success'
        })
    end
end)