#SingleInstance, Force
#Include %A_ScriptDir%\include\classMemory.ahk
#Include %A_ScriptDir%\include\logging.ahk
SetWorkingDir, %A_ScriptDir%

readGameMemory(playerOffset, startingOffset, ByRef gameMemoryData) {

    if (_ClassMemory.__Class != "_ClassMemory")
    {
        WriteLog("Missing classMemory.ahk dependency. Quitting")
        ExitApp
    }

    d2r := new _ClassMemory(gameWindowId, "", hProcessCopy) 

    if !isObject(d2r) 
    {
        WriteLog(gameWindowId " not found, please make sure game is running first")
        ExitApp
    }

    ;WriteLog("Looking for Level No address at player offset " playerOffset)
    startingAddress := d2r.BaseAddress + playerOffset
    playerUnit := d2r.read(startingAddress, "Int64")

    ; get the level number
    pPathAddress := playerUnit + 0x38
    pPath := d2r.read(pPathAddress, "Int64")
    pRoom1 := pPath + 0x20
    pRoom1Address := d2r.read(pRoom1, "Int64")
    pRoom2 := pRoom1Address + 0x18
    pRoom2Address := d2r.read(pRoom2, "Int64")
    pLevel := pRoom2Address + 0x90
    pLevelAddress := d2r.read(pLevel, "Int64")
    dwLevelNo := pLevelAddress + 0x1F8
    levelNo := d2r.read(dwLevelNo, "UInt")
    if (!levelNo) {
        WriteLog("Did not find level num at address " dwLevelNo " using player offset " playerOffset) 
    }

    ; get the map seed
    startingAddress := d2r.BaseAddress + playerOffset
    playerUnit := d2r.read(startingAddress, "Int64")

    ; get the map seed
    pAct := playerUnit + 0x20
    actAddress := d2r.read(pAct, "Int64")

    if (actAddress) {
        mapSeedAddress := actAddress + 0x14
        if (mapSeedAddress) {
            mapSeed := d2r.read(mapSeedAddress, "UInt")
            ;WriteLogDebug("Found seed " mapSeed " at address " mapSeedAddress)
        } else {
            WriteLogDebug("Did not find seed " mapSeed " at address " mapSeedAddress)
        }
    }

    ; get the level number
    actAddress := d2r.read(pAct, "Int64")
    pActUnk1 := actAddress + 0x70
    aActUnk2 := d2r.read(pActUnk1, "Int64")
    aDifficulty := aActUnk2 + 0x830
    difficulty := d2r.read(aDifficulty, "UShort")

    if ((difficulty != 0) & (difficulty != 1) & (difficulty != 2)) {
        WriteLog("Did not find " difficulty " difficulty at " aDifficulty " using player offset " playerOffset) 
    }

    ; player position
    pPath := playerUnit + 0x38
    pathAddress := d2r.read(pPath, "Int64")
    xPosAddress := pathAddress + 0x02
    yPosAddress := pathAddress + 0x06
    xPos := d2r.read(xPosAddress, "UShort")
    yPos := d2r.read(yPosAddress, "UShort")

    if (!xPos) {
        WriteLog("Did not find position at " xPosAddress " using player offset " playerOffset) 
    }
    if (!yPos) {
        WriteLog("Did not find position at " xPosAddress " using player offset " playerOffset) 
    }
    ;WriteLog("XPos " xPos " yPos " yPos)
    ;WriteLog("Map Seed " mapSeed)

    ; monsters
    mobs := []
    monstersOffset := 0x20AF660 + 1024
    Loop, 128
    {

        newOffset := monstersOffset + (8 * (A_Index - 1))
        mobAddress := d2r.BaseAddress + newOffset
        mobUnit := d2r.read(mobAddress, "Int64")

        if (mobUnit) {
            mobType := d2r.read(mobUnit + 0x00, "UInt")
            txtFileNo := d2r.read(mobUnit + 0x04, "UInt")
            unitId := d2r.read(mobUnit + 0x08, "UInt")
            mode := d2r.read(mobUnit + 0x0c, "UInt")
            pUnitData := d2r.read(mobUnit + 0x10, "Int64")
            pPath := d2r.read(mobUnit + 0x38, "Int64")
            if (mode != 0 && mode != 12) {
                isUnique := d2r.read(pUnitData + 0x18, "UShort")
                monx := d2r.read(pPath + 0x02, "UShort")
                mony := d2r.read(pPath + 0x06, "UShort")
                isBoss := 0
                textTitle := getBossName(txtFileNo)
                if (textTitle) {
                    isBoss:= 1
                } else {
                    if (isUnique > 0) {
                        textTitle := getSuperUniqueName(txtFileNo)
                    }
                }
                mob := {"txtFileNo": txtFileNo, "x": monx, "y": mony, "isUnique": isUnique, "isBoss": isBoss, "textTitle": textTitle }
                mobs.push(mob)
            }
        }
    } 
    gameMemoryData := {"mapSeed": mapSeed, "difficulty": difficulty, "levelNo": levelNo, "xPos": xPos, "yPos": yPos, "mobs": mobs }
}

getBossName(txtFileNo) {
    switch (txtFileNo) {
        case "156": return "Andariel"
        case "211": return "Duriel"
        case "229": return "Radament"
        case "242": return "Mephisto"
        case "243": return "Diablo"
        case "250": return "Summoner"
        case "256": return "Izual"
        case "267": return "Bloodraven"
        case "333": return "Diabloclone"
        case "365": return "Griswold"
        case "526": return "Nihlathakboss"
        case "544": return "Baalcrab"
        case "570": return "Baalclone"
        case "704": return "Uber Mephisto"
        case "705": return "Uber Diablo"
        case "706": return "Uber Izual"
        case "707": return "Uber Andariel"
        case "708": return "Uber Duriel"
        case "709": return "Uber Baal"
    }
    return ""
}



getSuperUniqueName(txtFileNo) {
    switch (txtFileNo) {
        case "0": return "Bonebreak"
        case "5": return "Corpsefire"
        case "11": return "Pitspawn Fouldog"
        case "20": return "Rakanishu"
        case "24": return "Treehead WoodFist"
        case "31": return "Fire Eye"
        case "45": return "The Countess"
        case "47": return "Sarina the Battlemaid"
        case "62": return "Baal Subject 1"
        case "66": return "Flamespike the Crawler"
        case "75": return "Fangskin"
        case "83": return "Bloodwitch the Wild"
        case "92": return "Beetleburst"
        case "97": return "Leatherarm"
        case "103": return "Ancient Kaa the Soulless"
        case "105": return "Baal Subject 2"
        case "120": return "The Tormentor"
        case "125": return "Web Mage the Burning"
        case "129": return "Stormtree"
        case "138": return "Icehawk Riftwing"
        case "160": return "Coldcrow"
        case "276": return "Boneash"
        case "281": return "Witch Doctor Endugu"
        case "284": return "Coldworm the Burrower"
        case "299": return "Taintbreeder"
        case "306": return "Grand Vizier of Chaos"
        case "308": return "Riftwraith the Cannibal"
        case "312": return "Lord De Seis"
        ; case "345": return "Council Member"
        ; case "346": return "Council Member"
        ; case "347": return "Council Member"
        case "362": return "Winged Death"
        case "402": return "The Smith"
        case "409": return "The Feature Creep"
        case "437": return "Bonesaw Breaker"
        case "440": return "Pindleskin"
        case "443": return "Threash Socket"
        case "449": return "Frozenstein"
        case "453": return "Megaflow Rectifier"
        case "472": return "Anodized Elite"
        case "475": return "Vinvear Molech"
        case "479": return "Siege Boss"
        case "481": return "Sharp Tooth Sayer"
        case "494": return "Dac Farren"
        case "496": return "Magma Torquer"
        case "501": return "Snapchip Shatter"
        case "508": return "Axe Dweller"
        case "529": return "Eyeback Unleashed"
        case "533": return "Blaze Ripper"
        case "540": return "Ancient Barbarian 1"
        case "541": return "Ancient Barbarian 2"
        case "542": return "Ancient Barbarian 3"
        case "557": return "Baal Subject 3"
        case "558": return "Baal Subject 4"
        case "571": return "Baal Subject 5"
        case "735": return "The Cow King"
        case "736": return "Dark Elder"
    }
    return ""
}