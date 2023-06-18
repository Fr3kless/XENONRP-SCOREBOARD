AddEventHandler('esx:setJob', function(source, job, lastjob)
    lib.func.updateCounter({source = source, add = {job.name}, remove = {lastjob.name}})
end)

-- AddEventHandler('esx:setSecondJob', function(source, job, lastjob)
--     lib.func.updateCounter({source = source, add = {job.name}, remove = {lastjob.name}})
-- end)

AddEventHandler('esx:setGroup', function(source, group)
    if group ~= "user" then
        local xPlayer = ESX.GetPlayerFromId(source)
        lib.func.updateCounter({source = source, add = {'admins', xPlayer.group}})
    end
    Player(source).state.admin = (group ~= 'user')
    Player(source).state.group = group
end)

local zBlock = {}

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    lib.func.updateCounter({source = source, add = {'players', xPlayer.job.name}})
    if xPlayer.group ~= "user" then
        lib.func.updateCounter({source = source, add = {'admins', xPlayer.group}})
    end
    Player(xPlayer.source).state.admin = (xPlayer.group ~= 'user')
    Player(xPlayer.source).state.hex = xPlayer.identifier
    Player(xPlayer.source).state.group = xPlayer.group
    zBlock[source] = true
end)

RegisterCommand("zblock", function(source, args, raw)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.group == "admin" or xPlayer.group == "superadmin" or xPlayer.group == "best" then
        if zBlock[source] then
            Player(xPlayer.source).state.hex = ""
            Player(xPlayer.source).state.group = "user"
            zBlock[source] = false
        else
            Player(xPlayer.source).state.hex = xPlayer.identifier
            Player(xPlayer.source).state.group = xPlayer.group
            zBlock[source] = true
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(500)

        lib.func.updateCounter({source = '*'})
    end
end)

AddEventHandler('esx:playerDropped', function(source)
    lib.func.updateCounter({source = source, disconnect = true})
end)

RegisterNetEvent('tkn-scoreboard:toggle')
AddEventHandler('tkn-scoreboard:toggle', function(toggle)
    lib.using[source] = toggle
    GlobalState.using = lib.using
end)