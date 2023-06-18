RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    lib.func.updateNUI('job', job)
end)

RegisterNetEvent("esx:setHiddenJob")
AddEventHandler("esx:setHiddenJob", function(job)
    lib.func.updateNUI('hiddenjob', job)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    lib.func.updateNUI('job', xPlayer.job)
    lib.func.updateNUI('hiddenjob', xPlayer.hiddenjob)
end)

AddStateBagChangeHandler('counter', 'global', function(name, key, value)
    lib.func.updateNUI('counter', value)
end)

AddStateBagChangeHandler('using', 'global', function(name, key, value)
    lib.cache.using = value
end)

RegisterCommand('+scoreboard', function()
    lib.func.globalThread(true)
end, false)

RegisterCommand('-scoreboard', function()
    lib.func.globalThread(false)
end, false)

RegisterKeyMapping('+scoreboard', 'Lista graczy', 'keyboard', 'Z')