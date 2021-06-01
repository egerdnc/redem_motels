function DisableControl()
    DisableControlAction(0, 73, false)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 30, true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 23, true)
    DisableControlAction(0, 288, true)
    DisableControlAction(0, 289, true)
    DisableControlAction(0, 170, true)
    DisableControlAction(0, 167, true)
    DisableControlAction(0, 73, true)
    DisableControlAction(2, 199, true)
    DisableControlAction(0, 47, true)
    DisableControlAction(0, 264, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
end

function TxtAtWorldCoord(x, y, z, txt, size, font, alpha)
    alpha = alpha or 255
    local s, sx, sy = GetScreenCoordFromWorldCoord(x, y ,z)
    if (sx > 0 and sx < 1) or (sy > 0 and sy < 1) then
        local s, sx, sy = GetHudScreenPositionFromWorldPosition(x, y, z)
        DrawTxt(txt, sx, sy, size, true, 255, 255, 255, alpha, true, font) -- Font 2 has some symbol conversions ex. @ becomes the rockstar logo
    end
end

function DrawTxt(str, x, y, size, enableShadow, r, g, b, a, centre, font)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(1, size)
    SetTextColor(math.floor(r), math.floor(g), math.floor(b), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    SetTextFontForCurrentCommand(font)
    DisplayText(str, x, y)
end