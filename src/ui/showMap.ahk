#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

ShowMap(settings, mapHwnd1, imageData, gameMemoryData, ByRef uiData) {

    scale:= settings["scale"]
    leftMargin:= settings["leftMargin"]
    topMargin:= settings["topMargin"]
    opacity:= settings["opacity"]
    sFile := imageData["sFile"] ; downloaded map image
    levelNo:= gameMemoryData["levelNo"]
    levelScale := imageData["levelScale"]
    levelxmargin := imageData["levelxmargin"]
    levelymargin := imageData["levelymargin"]
    scale := levelScale * scale
    leftMargin := leftMargin + levelxmargin
    topMargin := topMargin + levelymargin

    if (settings["centerMode"]) {
        scale:= settings["centerModeScale"]
        serverScale := settings["serverScale"]
        opacity:= settings["centerModeOpacity"]
    } else {
        serverScale := 2
    }

    ; logInitMapSettings()

    StartTime := A_TickCount
    Angle := 45
    padding := 150
    If !pToken := Gdip_Startup()
    {
        MsgBox "Gdiplus failed to start. Please ensure you have gdiplus on your system"
        ExitApp
    }

    pBitmap := Gdip_CreateBitmapFromFile(sFile)
    If !pBitmap
    {
        WriteLog("ERROR: Could not load map image " sFile)
        ExitApp
    }
    Width := Gdip_GetImageWidth(pBitmap)
    Height := Gdip_GetImageHeight(pBitmap)

    if (imageData["prerotated"]) {
        RWidth := Width
        RHeight := Height
        Width := imageData["originalWidth"]
        Height := imageData["originalHeight"]
    } else {
        Gdip_GetRotatedDimensions(Width, Height, Angle, RWidth, RHeight)
    }

    scaledWidth := (RWidth * scale)
    scaledHeight := (RHeight * 0.5) * scale
    rotatedWidth := RWidth * scale
    rotatedHeight := RHeight * scale

    hbm := CreateDIBSection(rotatedWidth, rotatedHeight)
    hdc := CreateCompatibleDC()
    obm := SelectObject(hdc, hbm)
    Gdip_SetSmoothingMode(G, 4)
    G := Gdip_GraphicsFromHDC(hdc)

    if (!imageData["prerotated"]) {
        pBitmap := Gdip_RotateBitmapAtCenter(pBitmap, Angle) ; rotates bitmap for 45 degrees. Disposes of pBitmap.
    }

    drawMapImage()

    if (!settings["centerMode"]) {
        moveMapImage
    }
    ; win move is now handled in movePlayerMap.ahk

    ; WriteLog(scaledWidth " " scaledHeight " " RWidth " " RHeight " " xPosDot " " yPosDot)
    ; seed := gameMemoryData["mapSeed"]
    ; sOutput := A_ScriptDir "\" seed "_" levelNo ".png"
    ; Gdip_SaveBitmapToFile(pBitmap, sOutput)
    ; WriteLog(Width " " Height " " RWidth " " RHeight " " scale)

    SelectObject(hdc, obm)
    DeleteObject(hbm)
    DeleteDC(hdc)
    Gdip_DeleteGraphics(G)
    Gdip_DisposeImage(pBitmap)
    ElapsedTime := A_TickCount - StartTime
    ; WriteLogDebug("Drew map " ElapsedTime " ms taken")
    uiData := { "scaledWidth": scaledWidth, "scaledHeight": scaledHeight, "sizeWidth": Width, "sizeHeight": Height, "rotatedWidth": rotatedWidth, "rotatedHeight": rotatedHeight }

}

drawMapImage() {
    Gdip_DrawImage(G, pBitmap, 0, 0, scaledWidth, scaledHeight, 0, 0, RWidth, RHeight, opacity)
    UpdateLayeredWindow(mapHwnd1, hdc, 0, 0, scaledWidth, scaledHeight)
}

moveMapImage() {
    WinGetPos, windowLeftMargin, windowTopMargin , gameWidth, gameHeight, %gameWindowId%
    WinMove, ahk_id %mapHwnd1%,, windowLeftMargin+leftMargin, windowTopMargin+topMargin
    WinMove, ahk_id %unitHwnd1%,, windowLeftMargin+leftMargin, windowTopMargin+topMargin
}

logInitMapSettings() {
    WriteLog("maxGuiWidth := " maxGuiWidth)
    WriteLog("scale := " scale)
    WriteLog("leftMargin := " leftMargin)
    WriteLog("topMargin := " topMargin)
    WriteLog("opacity := " opacity)
    WriteLog(imageData["sFile"])
    WriteLog(imageData["leftTrimmed"])
    WriteLog(imageData["topTrimmed"])
    WriteLog(imageData["mapOffsetX"])
    WriteLog(imageData["mapOffsety"])
    WriteLog(imageData["mapwidth"])
    WriteLog(imageData["mapheight"])
    WriteLog(imageData["prerotated"])

    WriteLog(gameMemoryData["xPos"])
    WriteLog(gameMemoryData["yPos"])
}
