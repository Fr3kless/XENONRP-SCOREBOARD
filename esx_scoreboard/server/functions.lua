ESX = exports['es_extended']:getSharedObject()

lib = {
    func = {},
    using = {},
    cache = {
        counter = {
            ['players'] = 0,
            ['police'] = 0,
            ['mechanik'] = 0,
            ['mechanik2'] = 0,
            ['admins'] = 0,
        }
    }
}

function CounterPlayers(what)
	return lib.cache.counter[what]
end

lib.func.updateCounter = function(data)
    if not data then
        return
    end

    if data.source == '*' then
        local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            lib.func.updateCounter({add = {'players', xPlayer.job.name}})
            if xPlayer.group ~= "user" then
                lib.func.updateCounter({add = {'admins', xPlayer.group}})
            end
        end
        return
    end

    local xPlayer = data.xPlayer or ESX.GetPlayerFromId(data.source)

    if data.disconnect then
        lib.func.updateCounter({source = data.source, remove = {'players', xPlayer.job.name}})
        if xPlayer.group ~= "user" then
            lib.func.updateCounter({source = data.source, remove = {'admins', xPlayer.group}})
        end
        return
    end

    local add = data.add or {}
    local remove = data.remove or {}

    for i=1, #add do
        if lib.cache.counter[add[i]] then
            lib.cache.counter[add[i]] = lib.cache.counter[add[i]] + 1
        end
    end

    for i=1, #remove do
        if lib.cache.counter[remove[i]] then
            lib.cache.counter[remove[i]] = lib.cache.counter[remove[i]] - 1
        end
    end

    GlobalState.counter = lib.cache.counter
end

exports('serverCounter', function(name)
    return lib.cache.counter[name]
end)

ESX.RegisterServerCallback('esx_scoreboard:getConnectedCops', function(source, cb)
	cb(lib.cache.counter)
end)
