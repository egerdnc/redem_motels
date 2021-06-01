-- RegisterCommand("lock", function()
--     if #OwnedKeys == 0 and #RoomMateData == 0 then
--         TriggerEvent("redem_roleplay:NotifyLeft", "Motel", "You have no room or dont have access to any room.", "generic_textures", "tick", 5000)
--         return
--     end
--      if #OwnedKeys > 0  then
--         local pedcoords = GetEntityCoords(PlayerPedId())

--         for i = 1, #OwnedKeys, 1 do
--             local motelId, roomId = OwnedKeys[i].motelId, OwnedKeys[i].roomId

--             if GetDistanceBetweenCoords(pedcoords, doorlist[motelId].rooms[roomId].door, true) <= 1.2 then
--                 ToggleDoor(motelId, roomId)
--                 return
--             end
--         end
--     end
--     -- if Config.roommate then
--         -- if #RoomMateData > 0 then
--             -- local pedcoords = GetEntityCoords(PlayerPedId())

--             -- for n = 1, #RoomMateData, 1 do
--                 -- local motelId, roomId = RoomMateData[n].motelId, RoomMateData[n].roomId

--                 -- if GetDistanceBetweenCoords(pedcoords, doorlist[motelId].rooms[roomId].door, true) <= 1.2 then
--                     -- ToggleDoor(motelId, roomId)
--                     -- return
--                 -- end
--             -- end
--         -- end
--     -- end
-- end)