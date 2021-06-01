doorlist = {}
OwnedKeys = {}
RoomMateData = nil
PlayerData = nil
MenuData = {}

RegisterNetEvent("motels:getDoorList")
AddEventHandler("motels:getDoorList", function(pData)
    doorlist = pData
end)

RegisterNetEvent("motels:getUser")
AddEventHandler("motels:getUser", function(user)
    PlayerData = user
end)

RegisterNetEvent("motels:getData")
AddEventHandler("motels:getData", function(pDoors, pKeys)
    doorlist = pDoors
    OwnedKeys = pKeys
end)

RegisterNetEvent("motels:toggleDoor")
AddEventHandler("motels:toggleDoor", function(motelId, roomId, state)
    print("got those from server", motelId, roomId, state)
    doorlist[motelId].rooms[roomId].locked = state
end)

RegisterNetEvent("motels:updateOwnedKeys")
AddEventHandler("motels:updateOwnedKeys", function(motelId, roomId, action, roommate)
    if not action then
        for i = 1, #OwnedKeys, 1 do
            if OwnedKeys[i].motelId == motelId and OwnedKeys[i].roomId == roomId then
                table.remove(OwnedKeys, i)
                break
            end
        end
    elseif action then
        table.insert(OwnedKeys, {motelId = motelId, roomId = roomId})
        TriggerEvent("redem_roleplay:NotifyLeft", "Motel", "You received the key Room-"..roomId.." in "..doorlist[motelId].info.name..".", "generic_textures", "tick", 6000)
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent("motels:init")
    Wait(5000)
    StartOwnerChecks()
    StartMarkersCheck()
    TriggerEvent("redemrp_menu_base:getData",function(call)
        MenuData = call
    end)
    while true do
        Wait(1)
        for i = 1, #doorlist, 1 do
            local playercoords = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(playercoords, doorlist[i].info.coords, false) <= 95.0 then
                for j = 1, #doorlist[i].rooms, 1 do
                    if doorlist[i].rooms[j].obj == nil or not DoesEntityExist(doorlist[i].rooms[j].obj) then
                        doorlist[i].rooms[j].obj = GetClosestObjectOfType(doorlist[i].rooms[j].door, 1.2, doorlist[i].info.doorhash, false, false, false)
                        FreezeEntityPosition(doorlist[i].rooms[j].obj, doorlist[i].rooms[j].locked)
                    else
                        FreezeEntityPosition(doorlist[i].rooms[j].obj, doorlist[i].rooms[j].locked)
                        if doorlist[i].rooms[j].locked then
                            SetEntityHeading(doorlist[i].rooms[j].obj, doorlist[i].rooms[j].h)
                            FreezeEntityPosition(doorlist[i].rooms[j].obj, doorlist[i].rooms[j].locked)
                        end
                    end
                    Citizen.Wait(1)
                end
            end
            Citizen.Wait(100)
        end
    end
end)

function StartOwnerChecks()
    for i = 1, #doorlist, 1 do
            Citizen.CreateThread(function()
                local motelId = i

                while true do
                    local pedcoords = GetEntityCoords(PlayerPedId())
                    local dst = GetDistanceBetweenCoords(pedcoords, doorlist[motelId].info.reception.x, doorlist[motelId].info.reception.y, doorlist[motelId].info.reception.z, true)

                    if dst <= 3.0 then
                       --DrawText3D(doorlist[motelId].info.reception.x, doorlist[motelId].info.reception.y, doorlist[motelId].info.reception.z, "[~r~E~w~] Resepsiyon", 0.40)
                       --DrawMarker(1, doorlist[motelId].info.reception.x, doorlist[motelId].info.reception.y, doorlist[motelId].info.reception.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 236, 236, 80, 155, false, false, 2, false, 0, 0, 0, 0)
                        if dst <= 2.0 and IsControlJustReleased(0, 0xCEFD9220) then
                            OpenAutonomous(motelId)
                        end
                        Citizen.Wait(1)
                    else
                        Citizen.Wait(1000)
                    end
                end
            end)
            return
    end
end

function StartMarkersCheck()
    Citizen.CreateThread(function()
        while true do
            local pedcoords = GetEntityCoords(PlayerPedId())

            for i = 1, #OwnedKeys, 1 do
                if GetDistanceBetweenCoords(pedcoords, doorlist[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].stash, true) <= 1.0 then
                    TxtAtWorldCoord(doorlist[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].stash[1], doorlist[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].stash[2], doorlist[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].stash[3], "~r~Storage", 0.6, 1)
                end
                if GetDistanceBetweenCoords(pedcoords, doorlist[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].clothe, true) <= 0.8 then
                    TxtAtWorldCoord(doorlist[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].clothe[1], doorlist[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].clothe[2], doorlist[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].clothe[3], "~r~Dressing Cabinet", 0.6, 1)
                end
            end
            Citizen.Wait(1)
        end
    end)
end

function OpenAutonomous(motelId)
    receptionOpen = true
    Citizen.CreateThread(function()
        while receptionOpen do
            DisableControl()
            Citizen.Wait(1)
        end
    end)
    local elements = {}
    local hasRoom = false
    if OwnedKeys == nil then
        hasRoom = false
    else
        for i = 1, #OwnedKeys, 1 do
            if OwnedKeys[i].motelId == motelId then
                hasRoom = true
                break
            end
        end
    end

    if not hasRoom then
        elements = {{label = "Rent a room", value = 1}}
    elseif hasRoom then
        elements = {{label = "Cancel the rental", value = 2}}
    end

    MenuData.CloseAll()
    MenuData.Open("default", GetCurrentResourceName(), "motel-menu", {
        title = "Motel Menu",
        align = "top-left",
        elements = elements
    }, function(data, menu)
        if data.current.value == 1 then
            RentRoom(motelId)
        elseif data.current.value == 2 then
            UnRentRoom(motelId)
        end
    end, function(data, menu)
        receptionOpen = false
        menu.close()
    end)
end


function RentRoom(motelId)
    local result = RPC.CallAsync("motels:getEmptyRoom", { motelId = motelId })
    if result ~= false then
        MenuData.CloseAll()
        MenuData.Open("default", GetCurrentResourceName(), "rent-unrent", {
            title = "Bos Odalar",
            align = "top-left",
            elements = result
        }, function(data, menu)
            local s = data.current
            if s.roomId ~= nil then
                MenuData.Open("default", GetCurrentResourceName(), "rent-sure", {
                    title = "Kiralamayı Onaylıyormusunuz?",
                    align = "top-left",
                    elements = {{label = "Evet", value = true}, {label = "Hayir", value = false}}
                }, function(data2, menu2)
                    if data2.current.value == true then
                        MenuData.CloseAll()
                        receptionOpen = false
                        TriggerServerEvent("motels:rentRoom", s.motelId, s.roomId)
                    else
                        menu2.close()
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end
        end, function(data, menu)
            receptionOpen = false
            menu.close()
        end)
    elseif not result then
        TriggerEvent("redem_roleplay:NotifyLeft", "Motel", "There is no any available rooms.", "generic_textures", "tick", 5000)
    end
end

function UnRentRoom(motelId)
    local el = {}
    for i = 1, #OwnedKeys, 1 do
        if OwnedKeys[i].motelId == motelId then
            table.insert(el, {label = "Room-"..OwnedKeys[i].roomId, motelId = motelId, roomId = OwnedKeys[i].roomId})
        end
    end

    MenuData.CloseAll()
    MenuData.Open("default", GetCurrentResourceName(), "unrent-room", {
        title = "Odalarınız",
        align = "top-left",
        elements = el
    }, function(data, menu)
        local s = data.current
        if s.roomId ~= nil then
            MenuData.Open("default", GetCurrentResourceName(), "unrent-sure", {
                title = "Eminmisiniz?",
                align = "top-left",
                elements = {{label = "Evet", value = true}, {label = "Hayir", value = false}}
            }, function(data2, menu2)
                if data2.current.value == true then
                    MenuData.CloseAll()
                    receptionOpen = false
                    TriggerServerEvent("motels:unRent", false, s.motelId, s.roomId)
                else
                    menu2.close()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        receptionOpen = false
        menu.close()
    end)
end

function ToggleDoor(motelId, roomId)
    print(motelId, roomId, not doorlist[motelId].rooms[roomId].locked)
    DoorAnim()
    TriggerServerEvent("motels:toggleDoor", motelId, roomId, not doorlist[motelId].rooms[roomId].locked)
end

function DoorAnim()
    prop_name = 'P_KEY02X'
	local ped = PlayerPedId()
        local p1 = GetEntityCoords(ped, true)
        --local p2 = Config.DoorList[doorID].textCoords
        --local dx = p2.x - p1.x
        --local dy = p2.y - p1.y

        --local heading = GetHeadingFromVector_2d(dx, dy)
        --SetPedDesiredHeading( ped, heading )

	local x,y,z = table.unpack(GetEntityCoords(ped, true))
	local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
	local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Finger12")

	if not IsEntityPlayingAnim(ped, "script_common@jail_cell@unlock@key", "action", 3) then
		local waiting = 0
		if not HasAnimDictLoaded("script_common@jail_cell@unlock@key") then
			RequestAnimDict("script_common@jail_cell@unlock@key")
			while not HasAnimDictLoaded("script_common@jail_cell@unlock@key") do
				Citizen.Wait(100)
				RequestAnimDict("script_common@jail_cell@unlock@key")
			end
		end
			Wait(100)
		TaskPlayAnim(ped, 'script_common@jail_cell@unlock@key', 'action', 8.0, -8.0, 2500, 31, 0, true, 0, false, 0, false)
		RemoveAnimDict("script_common@jail_cell@unlock@key")
			Wait(750)
		AttachEntityToEntity(prop, ped,boneIndex, 0.02, 0.0120, -0.00850, 0.024, -160.0, 200.0, true, true, false, true, 1, true)
			Wait(250)
		TriggerServerEvent('redemrp_doorlocks:updateState', doorID, state, function(cb) end)
			Wait(1500)
		ClearPedSecondaryTask(ped)
		DeleteObject(prop)
	end
end























RegisterCommand("lock", function()
    if #OwnedKeys == 0 and #RoomMateData == 0 then
        TriggerEvent("redem_roleplay:NotifyLeft", "Motel", "You have no room or dont have access to any room.", "generic_textures", "tick", 5000)
        return
    end
     if #OwnedKeys > 0  then
        local pedcoords = GetEntityCoords(PlayerPedId())

        for i = 1, #OwnedKeys, 1 do
            local motelId, roomId = OwnedKeys[i].motelId, OwnedKeys[i].roomId

            if GetDistanceBetweenCoords(pedcoords, doorlist[motelId].rooms[roomId].door, true) <= 1.5 then
                print("toggleing door", motelId, roomId)
                ToggleDoor(motelId, roomId)
                return
            end
        end
    end
    -- if Config.roommate then
        -- if #RoomMateData > 0 then
            -- local pedcoords = GetEntityCoords(PlayerPedId())

            -- for n = 1, #RoomMateData, 1 do
                -- local motelId, roomId = RoomMateData[n].motelId, RoomMateData[n].roomId

                -- if GetDistanceBetweenCoords(pedcoords, doorlist[motelId].rooms[roomId].door, true) <= 1.2 then
                    -- ToggleDoor(motelId, roomId)
                    -- return
                -- end
            -- end
        -- end
    -- end
end)
