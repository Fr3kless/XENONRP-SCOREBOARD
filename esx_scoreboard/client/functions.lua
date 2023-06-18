ESX = exports['es_extended']:getSharedObject();

local colors = {
	['trialsupport'] = {97, 248, 117},
	['support'] = {0, 255, 102},
	['mod'] = {0, 222, 255},
	['admin'] = {255, 0, 0},
	['superadmin'] = {255, 0, 0},
	['best'] = {119, 0, 255},
	['user'] = {255, 255, 255},
}

local nazwy = {
	['trialsupport'] = 'Trial Support',
	['support'] = 'Support',
	['mod'] = 'Moderator',
	['admin'] = 'Admin', 
	['superadmin'] = 'Head Admin',
	['best'] = 'MANAGEMENT',
	['user'] = 'Gracz',
}

local hexy = {
    ['steam:110000133f92534'] = 'Wojtek Zuzi',
    ['steam:110000155b0231f'] = 'WŁAŚCICIEL Antoś',
    ['steam:11000014cd16103'] = 'Ola Antosia',
    ['steam:110000146eb08c0'] = 'Zuzia Wojtka',
    ['steam:110000139db723f'] = 'ECPU POLSKA SIVEK',
    ['steam:11000015a67ff50'] = 'ECPU POLSKA NIKOS',
    ['steam:11000011a109159'] = 'Technical Leader',
    ['steam:11000010e16aae3'] = '~r~CFXMAFIA',
    ['steam:11000014fc4b633'] = '~r~CFXMAFIA',
    ['steam:11000011ceca421'] = '~r~CFXMAFIA',
    ['steam:1100001038ebf9a'] = '~r~CFXMAFIA',
    ['steam:11000014a9d88f9'] = '~r~CFXMAFIA',
}

lib = {
	store = {
		player = {},
		dict = 'amb@world_human_clipboard@male@idle_a',
		anim = 'idle_a'
	},
	cache = {
		players = {},
        using = {},
		toggled = false
	},
    func = {}
}

lib.func.canSee = function(ped)
    return lib.store.player.admin or IsEntityVisible(ped) == 1
end

lib.func.updateNUI = function(action, value)
    if action == 'job' or action == 'hiddenjob' then
        SendNUIMessage({action = 'update', data = {[action] = value.label..' - '..(value.name == 'unemployed' and 'Bezrobotny' or value.grade_name)}})
    elseif action == 'counter' then
        SendNUIMessage({action = 'update', data = value})
    elseif action == 'toggle' then
        SendNUIMessage({action = 'toggle', state = lib.cache.toggled})
    end
end

lib.func.globalThread = function(switch)
    lib.store.player.admin = LocalPlayer.state.admin or false
    lib.cache.toggled = switch
    lib.func.spawnProp()
    if lib.cache.toggled then
        lib.func.scrapingThread()
        lib.func.displayThread()
    end
end

lib.func.spawnProp = function()
    lib.func.updateNUI('toggle', lib.cache.toggled)
    if lib.store.player.admin then
        return
    end
    TriggerServerEvent('tkn-scoreboard:toggle', lib.cache.toggled)
    if lib.cache.toggled then
        if lib.func.canUseAnim(lib.store.player.ped) then
            lib.cache.prop = CreateObject(`p_cs_clipboard`, lib.store.player.coords, false)
            ESX.Streaming.RequestAnimDict(lib.store.dict, function()
                TaskPlayAnim(lib.store.player.ped, lib.store.dict, lib.store.anim, 8.0, -8.0, -1, 1, 0.0, false, false, false)
                AttachEntityToEntity(lib.cache.prop, lib.store.player.ped, GetPedBoneIndex(lib.store.player.ped, 36029), 0.1, 0.015, 0.12, 45.0, -130.0, 180.0, true, false, false, false, 0, true)
                RemoveAnimDict(lib.store.dict)
            end)
        end
    else
        ClearPedTasks(lib.store.player.ped)
        StopAnimTask(lib.store.player.ped, lib.store.dict, lib.store.anim, 1.0)
        DeleteEntity(lib.cache.prop)
    end
end

lib.func.canUseAnim = function(ped)
    if not LocalPlayer.state.dead and
    not IsPedInAnyVehicle(ped, false) and
    not IsPedFalling(ped) and
    not IsPedCuffed(ped) and
    not IsPedDiving(ped) and
    not IsPedInCover(ped, false) and
    not IsPedInParachuteFreeFall(ped) and
    GetPedParachuteState(ped) < 1 then
        return false
    else
        return false
    end
end

lib.func.scrapingThread = function()
    CreateThread(function()
        while lib.cache.toggled do
            for k,v in pairs(GetActivePlayers()) do
                if #(lib.store.player.coords - GetEntityCoords(GetPlayerPed(v))) < (lib.store.player.admin and 60 or 40) then
                    lib.cache.players[v] = {id = GetPlayerServerId(v), ped = GetPlayerPed(v), group = Player(GetPlayerServerId(v)).state.group, hex = Player(GetPlayerServerId(v)).state.hex}
                else
                    if lib.cache.players[v] then
                        lib.cache.players[v] = nil
                    end
                end
            end
            Wait(500)
            if not lib.store.player.admin and (not IsEntityPlayingAnim(lib.store.player.ped, lib.store.dict, lib.store.anim, 1) and lib.func.canUseAnim(lib.store.player.ped)) then
                lib.func.globalThread(false)
                break
            end
        end
    end)
end

lib.func.displayThread = function()
    CreateThread(function()
        while lib.cache.toggled do
            for k,v in pairs(lib.cache.players) do
                if lib.func.canSee(v.ped) then
                    lib.func.drawText3D(v.id, GetWorldPositionOfEntityBone(v.ped, GetPedBoneIndex(v.ped, 0x796E)), NetworkIsPlayerTalking(k), 0.9)
                    if v.hex then
                        if hexy[v.hex] then
                            lib.func.drawText3DGR(hexy[v.hex], GetWorldPositionOfEntityBone(v.ped, GetPedBoneIndex(v.ped, 0x796E)), colors[v.group], 0.55, 1)
                        else
                            lib.func.drawText3DGR(nazwy[v.group], GetWorldPositionOfEntityBone(v.ped, GetPedBoneIndex(v.ped, 0x796E)), colors[v.group], 0.55, 1)
                        end
                    end
                end
            end
            Wait(1)
        end
    end)
end

lib.func.drawText3DGR = function(text, coords, color, add, scale)
    if not color then color = {255, 255, 255} end
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + add)
	local scale = (1 / #(GetFinalRenderedCamCoord() - coords)) * scale
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    if onScreen then
        SetTextScale(1.0 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x,_y)
    end
end

lib.func.drawText3D = function(text, coords, talking, add)
    local color = (talking and {157, 3, 252} or {255, 255, 255})
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + add)
	local scale = (1 / #(GetFinalRenderedCamCoord() - coords)) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    if onScreen then
        SetTextScale(1.0 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x,_y)
    end
end

lib.func.refreshStates = function()
    lib.store.player.ped = PlayerPedId()
    lib.store.player.coords = GetEntityCoords(lib.store.player.ped)
    lib.store.player.admin = LocalPlayer.state.admin or false
end

CreateThread(function()
    while true do
        lib.func.refreshStates()
        Wait(500)
    end
end)

CreateThread(function()
    Wait(1000)
    lib.func.refreshStates()
    while true do
        Wait(0)
        local sleep = true
        for k,v in pairs(lib.cache.using) do
            if v then
                local player = GetPlayerFromServerId(k)
                local ped = GetPlayerPed(player)
                if ped ~= PlayerPedId() then
                    local coords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 0x796E))
                    if lib.func.canSee(ped) then
                        local dist = #(coords - lib.store.player.coords)
                        if dist <= 50.0 and dist ~= 0.0 then
                            sleep = false
                            lib.func.drawText3D('👁‍🗨', coords, false, 0.7)
                        end
                    end
                end
            end
        end
        if sleep then
            Wait(500)
        end
    end
end)