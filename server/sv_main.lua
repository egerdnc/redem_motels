RegisterNetEvent("motels:init")
AddEventHandler("motels:init", function()
    local src = source
    Wait(500)
    TriggerClientEvent("motels:getDoorList", -1, ROOM_CONFIG)
    
    TriggerEvent("redem:getPlayerFromId", src, function(user)
        TriggerClientEvent("motels:getUser", src, user)
        initMotels(src, user)
	end)
end)

RegisterServerEvent("motels:toggleDoor")
AddEventHandler("motels:toggleDoor", function(motelId, roomId, state)
    ROOM_CONFIG[motelId].rooms[roomId].locked = state
    TriggerClientEvent("motels:toggleDoor", -1, motelId, roomId, state)
end)

RegisterServerEvent("motels:rentRoom")
AddEventHandler("motels:rentRoom", function(motelId, roomId, target)
    local src = source
    TriggerEvent('redemrp:getPlayerFromId', src, function(user)
        if user.getMoney() >= 10 then
            user.removeMoney(tonumber(10))
            MySQL.Async.execute("UPDATE `keys` SET holder = @holder, roommate = @roommate WHERE `key` = @key", {
                ["@holder"] = user.getIdentifier(),
                ["@roommate"] = "",
                ["@key"] = "key_"..motelId.."_"..roomId
            })
            TriggerClientEvent("motels:updateOwnedKeys",src, motelId, roomId, true, "")
        else
            return
        end
    end)
end)

RegisterServerEvent("motels:unRent")
AddEventHandler("motels:unRent", function(holder, motelId, roomId)
    local src = source
    TriggerEvent('redemrp:getPlayerFromId', src, function(user)
        MySQL.Async.execute("UPDATE `keys` SET holder = @newholder, roommate = @roommate WHERE holder = @oldholder", {
            ["@newholder"] = "",
            ["@roommate"] = "",
            ["@oldholder"] = user.getIdentifier()
        })
        if user ~= nil then
            TriggerClientEvent("motels:updateOwnedKeys", src, motelId, roomId, false)
        end
    end) 
end)


RPC.Register("motels:getEmptyRoom", function(motelId)
    print(json.encode(motelId))
    local result = MySQL.Sync.fetchAll("SELECT * FROM `keys`")
    local el = {}
    for i = 1, #result, 1 do
        if result[i].key:sub(5, 5) == tostring(motelId.motelId) then
            if result[i].holder:len() < 5 then
                local roomId = tonumber(result[i].key:sub(7, result[i].key:len()))
                table.insert(el, {label = "Room-"..roomId, motelId = motelId.motelId, roomId = roomId})
            end
        end
    end
    if #el ~= 0 then
        print("true aga")
        return el
    else
        print("vallaha false agam")
        return false
    end
end)

function initMotels(src, user)
    local result = MySQL.Sync.fetchAll("SELECT * FROM `keys` WHERE holder = @holder", {['holder'] = user.getIdentifier()})
    print(json.encode(result))
    local data = {}

    if result ~= nil then
        for i = 1, #result, 1 do
            local l = result[i].key:len()
            local a = result[i].key:sub(5, 5)
            local b = result[i].key:sub(7, l)

            table.insert(data, {motelId = tonumber(a), roomId = tonumber(b), roommate = result[i].roommate})
        end
    end
    TriggerClientEvent("motels:getData", src, ROOM_CONFIG, data)
end