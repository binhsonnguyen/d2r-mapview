#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


ReadItems(d2rprocess, startingOffset, ByRef items) {
    ; items
    items := []
    itemsOffset := startingOffset + (4 * 1024)
    Loop, 256
    {
        newOffset := itemsOffset + (8 * (A_Index - 1))
        itemAddress := d2rprocess.BaseAddress + newOffset
        itemUnit := d2rprocess.read(itemAddress, "Int64")
        
        while (itemUnit > 0) { ; keep following the next pointer
            itemType := d2rprocess.read(itemUnit + 0x00, "UInt") ; item is 4
            
            if (itemType == 4) {
                txtFileNo := d2rprocess.read(itemUnit + 0x04, "UInt")
                
                ;itemLoc - 0 in inventory, 1 equipped, 2 in belt, 3 on ground, 4 cursor, 5 dropping, 6 socketed
                itemLoc := d2rprocess.read(itemUnit + 0x0C, "UInt")
                ;WriteLog(txtFileNo " " itemLoc " " itemType)
                if (itemLoc == 3 or itemLoc == 5) {
                    pUnitData := d2rprocess.read(itemUnit + 0x10, "Int64")

                    ; itemQuality - 5 is set, 7 is unique (6 rare, 4, magic)
                    itemQuality := d2rprocess.read(pUnitData, "UInt")
                    isRune := false
                    if (txtFileNo >= 629 and txtFileNo <= 642) {
                        isRune:= true
                    }

                    pPath := d2rprocess.read(itemUnit + 0x38, "Int64")  
                    itemx := d2rprocess.read(pPath + 0x10, "UShort")
                    itemy := d2rprocess.read(pPath + 0x14, "UShort")

                    name := getItemName(txtFileNo)
                    item := {"txtFileNo": txtFileNo, "name": name, "itemLoc": itemLoc, "itemQuality": itemQuality, "isRune": isRune, "itemx": itemx, "itemy": itemy }
                    ;WriteLog("txtFileNo: " txtFileNo ", name: " name ", itemLoc: " itemLoc ", itemQuality: " itemQuality ", isRune: " isRune ", itemx: " itemx ", itemy: " itemy)
                    items.push(item)
                }
            }
            itemUnit := d2rprocess.read(itemUnit + 0x150, "Int64")  ; get next item
        }
    } 
    SetFormat Integer, D
}


getItemName(txtFileNo) {
    switch (txtFileNo) {
        case 0: return "Hand Axe" 
        case 1: return "Axe" 
        case 2: return "Double Axe" 
        case 3: return "Military Pick" 
        case 4: return "War Axe" 
        case 5: return "Large Axe" 
        case 6: return "Broad Axe" 
        case 7: return "Battle Axe" 
        case 8: return "Great Axe" 
        case 9: return "Giant Axe" 
        case 10: return "Wand" 
        case 11: return "Yew Wand" 
        case 12: return "Bone Wand" 
        case 13: return "Grim Wand" 
        case 14: return "Club" 
        case 15: return "Scepter" 
        case 16: return "Grand Scepter" 
        case 17: return "War Scepter" 
        case 18: return "Spiked Club" 
        case 19: return "Mace" 
        case 20: return "Morning Star" 
        case 21: return "Flail" 
        case 22: return "War Hammer" 
        case 23: return "Maul" 
        case 24: return "Great Maul" 
        case 25: return "Short Sword" 
        case 26: return "Scimitar" 
        case 27: return "Saber" 
        case 28: return "Falchion" 
        case 29: return "Crystal Sword" 
        case 30: return "Broad Sword" 
        case 31: return "Long Sword" 
        case 32: return "War Sword" 
        case 33: return "Two-Handed Sword" 
        case 34: return "Claymore" 
        case 35: return "Giant Sword" 
        case 36: return "Bastard Sword" 
        case 37: return "Flamberge" 
        case 38: return "Great Sword" 
        case 39: return "Dagger" 
        case 40: return "Dirk" 
        case 41: return "Kriss" 
        case 42: return "Blade" 
        case 43: return "Throwing Knife" 
        case 44: return "Throwing Axe" 
        case 45: return "Balanced Knife" 
        case 46: return "Balanced Axe" 
        case 47: return "Javelin" 
        case 48: return "Pilum" 
        case 49: return "Short Spear" 
        case 50: return "Glaive" 
        case 51: return "Throwing Spear" 
        case 52: return "Spear" 
        case 53: return "Trident" 
        case 54: return "Brandistock" 
        case 55: return "Spetum" 
        case 56: return "Pike" 
        case 57: return "Bardiche" 
        case 58: return "Voulge" 
        case 59: return "Scythe" 
        case 60: return "Poleaxe" 
        case 61: return "Halberd" 
        case 62: return "War Scythe" 
        case 63: return "Short Staff" 
        case 64: return "Long Staff" 
        case 65: return "Gnarled Staff" 
        case 66: return "Battle Staff" 
        case 67: return "War Staff" 
        case 68: return "Short Bow" 
        case 69: return "Hunter's Bow" 
        case 70: return "Long Bow" 
        case 71: return "Composite Bow" 
        case 72: return "Short Battle Bow" 
        case 73: return "Long Battle Bow" 
        case 74: return "Short War Bow" 
        case 75: return "Long War Bow" 
        case 76: return "Light Crossbow" 
        case 77: return "Crossbow" 
        case 78: return "Heavy Crossbow" 
        case 79: return "Repeating Crossbow" 
        case 80: return "Rancid Gas Potion" 
        case 81: return "Oil Potion" 
        case 82: return "Choking Gas Potion" 
        case 83: return "Exploding Potion" 
        case 84: return "Strangling Gas Potion" 
        case 85: return "Fulminating Potion" 
        case 86: return "Decoy Gidbinn" 
        case 87: return "The Gidbinn" 
        case 88: return "Wirt's Leg" 
        case 89: return "Horadric Malus" 
        case 90: return "Hellforge Hammer" 
        case 91: return "Horadric Staff" 
        case 92: return "Staff of Kings" 
        case 93: return "Hatchet" 
        case 94: return "Cleaver" 
        case 95: return "Twin Axe" 
        case 96: return "Crowbill" 
        case 97: return "Naga" 
        case 98: return "Military Axe" 
        case 99: return "Bearded Axe" 
        case 100: return "Tabar" 
        case 101: return "Gothic Axe" 
        case 102: return "Ancient Axe" 
        case 103: return "Burnt Wand" 
        case 104: return "Petrified Wand" 
        case 105: return "Tomb Wand" 
        case 106: return "Grave Wand" 
        case 107: return "Cudgel" 
        case 108: return "Rune Scepter" 
        case 109: return "Holy Water Sprinkler" 
        case 110: return "Divine Scepter" 
        case 111: return "Barbed Club" 
        case 112: return "Flanged Mace" 
        case 113: return "Jagged Star" 
        case 114: return "Knout" 
        case 115: return "Battle Hammer" 
        case 116: return "War Club" 
        case 117: return "Martel de Fer" 
        case 118: return "Gladius" 
        case 119: return "Cutlass" 
        case 120: return "Shamshir" 
        case 121: return "Tulwar" 
        case 122: return "Dimensional Blade" 
        case 123: return "Battle Sword" 
        case 124: return "Rune Sword" 
        case 125: return "Ancient Sword" 
        case 126: return "Espandon" 
        case 127: return "Dacian Falx" 
        case 128: return "Tusk Sword" 
        case 129: return "Gothic Sword" 
        case 130: return "Zweihander" 
        case 131: return "Executioner Sword" 
        case 132: return "Poignard" 
        case 133: return "Rondel" 
        case 134: return "Cinquedeas" 
        case 135: return "Stilleto" 
        case 136: return "Battle Dart" 
        case 137: return "Francisca" 
        case 138: return "War Dart" 
        case 139: return "Hurlbat" 
        case 140: return "War Javelin" 
        case 141: return "Great Pilum" 
        case 142: return "Simbilan" 
        case 143: return "Spiculum" 
        case 144: return "Harpoon" 
        case 145: return "War Spear" 
        case 146: return "Fuscina" 
        case 147: return "War Fork" 
        case 148: return "Yari" 
        case 149: return "Lance" 
        case 150: return "Lochaber Axe" 
        case 151: return "Bill" 
        case 152: return "Battle Scythe" 
        case 153: return "Partizan" 
        case 154: return "Bec-de-Corbin" 
        case 155: return "Grim Scythe" 
        case 156: return "Jo Staff" 
        case 157: return "Quarterstaff" 
        case 158: return "Cedar Staff" 
        case 159: return "Gothic Staff" 
        case 160: return "Rune Staff" 
        case 161: return "Edge Bow" 
        case 162: return "Razor Bow" 
        case 163: return "Cedar Bow" 
        case 164: return "Double Bow" 
        case 165: return "Short Siege Bow" 
        case 166: return "Long Siege Bow" 
        case 167: return "Rune Bow" 
        case 168: return "Gothic Bow" 
        case 169: return "Arbalest" 
        case 170: return "Siege Crossbow" 
        case 171: return "Ballista" 
        case 172: return "Chu-Ko-Nu" 
        case 173: return "Khalim's Flail" 
        case 174: return "Khalim's Will" 
        case 175: return "Katar" 
        case 176: return "Wrist Blade" 
        case 177: return "Hatchet Hands" 
        case 178: return "Cestus" 
        case 179: return "Claws" 
        case 180: return "Blade Talons" 
        case 181: return "Scissors Katar" 
        case 182: return "Quhab" 
        case 183: return "Wrist Spike" 
        case 184: return "Fascia" 
        case 185: return "Hand Scythe" 
        case 186: return "Greater Claws" 
        case 187: return "Greater Talons" 
        case 188: return "Scissors Quhab" 
        case 189: return "Suwayyah" 
        case 190: return "Wrist Sword" 
        case 191: return "War Fist" 
        case 192: return "Battle Cestus" 
        case 193: return "Feral Claws" 
        case 194: return "Runic Talons" 
        case 195: return "Scissors Suwayyah" 
        case 196: return "Tomahawk" 
        case 197: return "Small Crescent" 
        case 198: return "Ettin Axe" 
        case 199: return "War Spike" 
        case 200: return "Berserker Axe" 
        case 201: return "Feral Axe" 
        case 202: return "Silver-edged Axe" 
        case 203: return "Decapitator" 
        case 204: return "Champion Axe" 
        case 205: return "Glorious Axe" 
        case 206: return "Polished Wand" 
        case 207: return "Ghost Wand" 
        case 208: return "Lich Wand" 
        case 209: return "Unearthed Wand" 
        case 210: return "Truncheon" 
        case 211: return "Mighty Scepter" 
        case 212: return "Seraph Rod" 
        case 213: return "Caduceus" 
        case 214: return "Tyrant Club" 
        case 215: return "Reinforced Mace" 
        case 216: return "Devil Star" 
        case 217: return "Scourge" 
        case 218: return "Legendary Mallet" 
        case 219: return "Ogre Maul" 
        case 220: return "Thunder Maul" 
        case 221: return "Falcata" 
        case 222: return "Ataghan" 
        case 223: return "Elegant Blade" 
        case 224: return "Hydra Edge" 
        case 225: return "Phase Blade" 
        case 226: return "Conquest Sword" 
        case 227: return "Cryptic Sword" 
        case 228: return "Mythical Sword" 
        case 229: return "Legend Sword" 
        case 230: return "Highland Blade" 
        case 231: return "Balrog Blade" 
        case 232: return "Champion Sword" 
        case 233: return "Colossal Sword" 
        case 234: return "Colossus Blade" 
        case 235: return "Bone Knife" 
        case 236: return "Mithral Point" 
        case 237: return "Fanged Knife" 
        case 238: return "Legend Spike" 
        case 239: return "Flying Knife" 
        case 240: return "Flying Axe" 
        case 241: return "Winged Knife" 
        case 242: return "Winged Axe" 
        case 243: return "Hyperion Javelin" 
        case 244: return "Stygian Pilum" 
        case 245: return "Balrog Spear" 
        case 246: return "Ghost Glaive" 
        case 247: return "Winged Harpoon" 
        case 248: return "Hyperion Spear" 
        case 249: return "Stygian Pike" 
        case 250: return "Mancatcher" 
        case 251: return "Ghost Spear" 
        case 252: return "War Pike" 
        case 253: return "Ogre Axe" 
        case 254: return "Colossus Voulge" 
        case 255: return "Thresher" 
        case 256: return "Cryptic Axe" 
        case 257: return "Great Poleaxe" 
        case 258: return "Giant Thresher" 
        case 259: return "Walking Stick" 
        case 260: return "Stalagmite" 
        case 261: return "Elder Staff" 
        case 262: return "Shillelagh" 
        case 263: return "Archon Staff" 
        case 264: return "Spider Bow" 
        case 265: return "Blade Bow" 
        case 266: return "Shadow Bow" 
        case 267: return "Great Bow" 
        case 268: return "Diamond Bow" 
        case 269: return "Crusader Bow" 
        case 270: return "Ward Bow" 
        case 271: return "Hydra Bow" 
        case 272: return "Pellet Bow" 
        case 273: return "Gorgon Crossbow" 
        case 274: return "Colossus Crossbow" 
        case 275: return "Demon Crossbow" 
        case 276: return "Eagle Orb" 
        case 277: return "Sacred Globe" 
        case 278: return "Smoked Sphere" 
        case 279: return "Clasped Orb" 
        case 280: return "Jared's Stone" 
        case 281: return "Stag Bow" 
        case 282: return "Reflex Bow" 
        case 283: return "Maiden Spear" 
        case 284: return "Maiden Pike" 
        case 285: return "Maiden Javelin" 
        case 286: return "Glowing Orb" 
        case 287: return "Crystalline Globe" 
        case 288: return "Cloudy Sphere" 
        case 289: return "Sparkling Ball" 
        case 290: return "Swirling Crystal" 
        case 291: return "Ashwood Bow" 
        case 292: return "Ceremonial Bow" 
        case 293: return "Ceremonial Spear" 
        case 294: return "Ceremonial Pike" 
        case 295: return "Ceremonial Javelin" 
        case 296: return "Heavenly Stone" 
        case 297: return "Eldritch Orb" 
        case 298: return "Demon Heart" 
        case 299: return "Vortex Orb" 
        case 300: return "Dimensional Shard" 
        case 301: return "Matriarchal Bow" 
        case 302: return "Grand Matron Bow" 
        case 303: return "Matriarchal Spear" 
        case 304: return "Matriarchal Pike" 
        case 305: return "Matriarchal Javelin" 
        case 306: return "Cap" 
        case 307: return "Skull Cap" 
        case 308: return "Helm" 
        case 309: return "Full Helm" 
        case 310: return "Great Helm" 
        case 311: return "Crown" 
        case 312: return "Mask" 
        case 313: return "Quilted Armor" 
        case 314: return "Leather Armor" 
        case 315: return "Hard Leather Armor" 
        case 316: return "Studded Leather" 
        case 317: return "Ring Mail" 
        case 318: return "Scale Mail" 
        case 319: return "Chain Mail" 
        case 320: return "Breast Plate" 
        case 321: return "Splint Mail" 
        case 322: return "Plate Mail" 
        case 323: return "Field Plate" 
        case 324: return "Gothic Plate" 
        case 325: return "Full Plate Mail" 
        case 326: return "Ancient Armor" 
        case 327: return "Light Plate" 
        case 328: return "Buckler" 
        case 329: return "Small Shield" 
        case 330: return "Large Shield" 
        case 331: return "Kite Shield" 
        case 332: return "Tower Shield" 
        case 333: return "Gothic Shield" 
        case 334: return "Leather Gloves" 
        case 335: return "Heavy Gloves" 
        case 336: return "Chain Gloves" 
        case 337: return "Light Gauntlets" 
        case 338: return "Gauntlets" 
        case 339: return "Boots" 
        case 340: return "Heavy Boots" 
        case 341: return "Chain Boots" 
        case 342: return "Light Plated Boots" 
        case 343: return "Greaves" 
        case 344: return "Sash" 
        case 345: return "Light Belt" 
        case 346: return "Belt" 
        case 347: return "Heavy Belt" 
        case 348: return "Plated Belt" 
        case 349: return "Bone Helm" 
        case 350: return "Bone Shield" 
        case 351: return "Spiked Shield" 
        case 352: return "War Hat" 
        case 353: return "Sallet" 
        case 354: return "Casque" 
        case 355: return "Basinet" 
        case 356: return "Winged Helm" 
        case 357: return "Grand Crown" 
        case 358: return "Death Mask" 
        case 359: return "Ghost Armor" 
        case 360: return "Serpentskin Armor" 
        case 361: return "Demonhide Armor" 
        case 362: return "Trellised Armor" 
        case 363: return "Linked Mail" 
        case 364: return "Tigulated Mail" 
        case 365: return "Mesh Armor" 
        case 366: return "Cuirass" 
        case 367: return "Russet Armor" 
        case 368: return "Templar Coat" 
        case 369: return "Sharktooth Armor" 
        case 370: return "Embossed Plate" 
        case 371: return "Chaos Armor" 
        case 372: return "Ornate Armor" 
        case 373: return "Mage Plate" 
        case 374: return "Defender" 
        case 375: return "Round Shield" 
        case 376: return "Scutum" 
        case 377: return "Dragon Shield" 
        case 378: return "Pavise" 
        case 379: return "Ancient Shield" 
        case 380: return "Demonhide Gloves" 
        case 381: return "Sharkskin Gloves" 
        case 382: return "Heavy Bracers" 
        case 383: return "Battle Gauntlets" 
        case 384: return "War Gauntlets" 
        case 385: return "Demonhide Boots" 
        case 386: return "Sharkskin Boots" 
        case 387: return "Mesh Boots" 
        case 388: return "Battle Boots" 
        case 389: return "War Boots" 
        case 390: return "Demonhide Sash" 
        case 391: return "Sharkskin Belt" 
        case 392: return "Mesh Belt" 
        case 393: return "Battle Belt" 
        case 394: return "War Belt" 
        case 395: return "Grim Helm" 
        case 396: return "Grim Shield" 
        case 397: return "Barbed Shield" 
        case 398: return "Wolf Head" 
        case 399: return "Hawk Helm" 
        case 400: return "Antlers" 
        case 401: return "Falcon Mask" 
        case 402: return "Spirit Mask" 
        case 403: return "Jawbone Cap" 
        case 404: return "Fanged Helm" 
        case 405: return "Horned Helm" 
        case 406: return "Assault Helmet" 
        case 407: return "Avenger Guard" 
        case 408: return "Targe" 
        case 409: return "Rondache" 
        case 410: return "Heraldic Shield" 
        case 411: return "Aerin Shield" 
        case 412: return "Crown Shield" 
        case 413: return "Preserved Head" 
        case 414: return "Zombie Head" 
        case 415: return "Unraveller Head" 
        case 416: return "Gargoyle Head" 
        case 417: return "Demon Head" 
        case 418: return "Circlet" 
        case 419: return "Coronet" 
        case 420: return "Tiara" 
        case 421: return "Diadem" 
        case 422: return "Shako" 
        case 423: return "Hydraskull" 
        case 424: return "Armet" 
        case 425: return "Giant Conch" 
        case 426: return "Spired Helm" 
        case 427: return "Corona" 
        case 428: return "Demonhead" 
        case 429: return "Dusk Shroud" 
        case 430: return "Wyrmhide" 
        case 431: return "Scarab Husk" 
        case 432: return "Wire Fleece" 
        case 433: return "Diamond Mail" 
        case 434: return "Loricated Mail" 
        case 435: return "Boneweave" 
        case 436: return "Great Hauberk" 
        case 437: return "Balrog Skin" 
        case 438: return "Hellforge Plate" 
        case 439: return "Kraken Shell" 
        case 440: return "Lacquered Plate" 
        case 441: return "Shadow Plate" 
        case 442: return "Sacred Armor" 
        case 443: return "Archon Plate" 
        case 444: return "Heater" 
        case 445: return "Luna" 
        case 446: return "Hyperion" 
        case 447: return "Monarch" 
        case 448: return "Aegis" 
        case 449: return "Ward" 
        case 450: return "Bramble Mitts" 
        case 451: return "Vampirebone Gloves" 
        case 452: return "Vambraces" 
        case 453: return "Crusader Gauntlets" 
        case 454: return "Ogre Gauntlets" 
        case 455: return "Wyrmhide Boots" 
        case 456: return "Scarabshell Boots" 
        case 457: return "Boneweave Boots" 
        case 458: return "Mirrored Boots" 
        case 459: return "Myrmidon Greaves" 
        case 460: return "Spiderweb Sash" 
        case 461: return "Vampirefang Belt" 
        case 462: return "Mithril Coil" 
        case 463: return "Troll Belt" 
        case 464: return "Colossus Girdle" 
        case 465: return "Bone Visage" 
        case 466: return "Troll Nest" 
        case 467: return "Blade Barrier" 
        case 468: return "Alpha Helm" 
        case 469: return "Griffon Headress" 
        case 470: return "Hunter's Guise" 
        case 471: return "Sacred Feathers" 
        case 472: return "Totemic Mask" 
        case 473: return "Jawbone Visor" 
        case 474: return "Lion Helm" 
        case 475: return "Rage Mask" 
        case 476: return "Savage Helmet" 
        case 477: return "Slayer Guard" 
        case 478: return "Akaran Targe" 
        case 479: return "Akaran Rondache" 
        case 480: return "Protector Shield" 
        case 481: return "Gilded Shield" 
        case 482: return "Royal Shield" 
        case 483: return "Mummified Trophy" 
        case 484: return "Fetish Trophy" 
        case 485: return "Sexton Trophy" 
        case 486: return "Cantor Trophy" 
        case 487: return "Heirophant Trophy" 
        case 488: return "Blood Spirit" 
        case 489: return "Sun Spirit" 
        case 490: return "Earth Spirit" 
        case 491: return "Sky Spirit" 
        case 492: return "Dream Spirit" 
        case 493: return "Carnage Helm" 
        case 494: return "Fury Visor" 
        case 495: return "Destroyer Helm" 
        case 496: return "Conqueror Crown" 
        case 497: return "Guardian Crown" 
        case 498: return "Sacred Targe" 
        case 499: return "Sacred Rondache" 
        case 500: return "Ancient Shield" 
        case 501: return "Zakarum Shield" 
        case 502: return "Vortex Shield" 
        case 503: return "Minion Skull" 
        case 504: return "Hellspawn Skull" 
        case 505: return "Overseer Skull" 
        case 506: return "Succubus Skull" 
        case 507: return "Bloodlord Skull" 
        case 508: return "Elixir" 
        case 509: return "Healing Potion" 
        case 510: return "Mana Potion" 
        case 511: return "Full Healing Potion" 
        case 512: return "Full Mana Potion" 
        case 513: return "Stamina Potion" 
        case 514: return "Antidote Potion" 
        case 515: return "Rejuvenation Potion" 
        case 516: return "Full Rejuvenation Potion" 
        case 517: return "Thawing Potion" 
        case 518: return "Tome of Town Portal" 
        case 519: return "Tome of Identify" 
        case 520: return "Amulet" 
        case 521: return "Amulet of the Viper" 
        case 522: return "Ring" 
        case 523: return "Gold" 
        case 524: return "Scroll of Inifuss" 
        case 525: return "Key to the Cairn Stones" 
        case 526: return "Arrows" 
        case 527: return "Torch" 
        case 528: return "Bolts" 
        case 529: return "Scroll of Town Portal" 
        case 530: return "Scroll of Identify" 
        case 531: return "Heart" 
        case 532: return "Brain" 
        case 533: return "Jawbone" 
        case 534: return "Eye" 
        case 535: return "Horn" 
        case 536: return "Tail" 
        case 537: return "Flag" 
        case 538: return "Fang" 
        case 539: return "Quill" 
        case 540: return "Soul" 
        case 541: return "Scalp" 
        case 542: return "Spleen" 
        case 543: return "Key" 
        case 544: return "The Black Tower Key" 
        case 545: return "Potion of Life" 
        case 546: return "A Jade Figurine" 
        case 547: return "The Golden Bird" 
        case 548: return "Lam Esen's Tome" 
        case 549: return "Horadric Cube" 
        case 550: return "Horadric Scroll" 
        case 551: return "Mephisto's Soulstone" 
        case 552: return "Book of Skill" 
        case 553: return "Khalim's Eye" 
        case 554: return "Khalim's Heart" 
        case 555: return "Khalim's Brain" 
        case 556: return "Ear" 
        case 557: return "Chipped Amethyst" 
        case 558: return "Flawed Amethyst" 
        case 559: return "Amethyst" 
        case 560: return "Flawless Amethyst" 
        case 561: return "Perfect Amethyst" 
        case 562: return "Chipped Topaz" 
        case 563: return "Flawed Topaz" 
        case 564: return "Topaz" 
        case 565: return "Flawless Topaz" 
        case 566: return "Perfect Topaz" 
        case 567: return "Chipped Sapphire" 
        case 568: return "Flawed Sapphire" 
        case 569: return "Sapphire" 
        case 570: return "Flawless Sapphire" 
        case 571: return "Perfect Sapphire" 
        case 572: return "Chipped Emerald" 
        case 573: return "Flawed Emerald" 
        case 574: return "Emerald" 
        case 575: return "Flawless Emerald" 
        case 576: return "Perfect Emerald" 
        case 577: return "Chipped Ruby" 
        case 578: return "Flawed Ruby" 
        case 579: return "Ruby" 
        case 580: return "Flawless Ruby" 
        case 581: return "Perfect Ruby" 
        case 582: return "Chipped Diamond" 
        case 583: return "Flawed Diamond" 
        case 584: return "Diamond" 
        case 585: return "Flawless Diamond" 
        case 586: return "Perfect Diamond" 
        case 587: return "Minor Healing Potion" 
        case 588: return "Light Healing Potion" 
        case 589: return "Healing Potion" 
        case 590: return "Greater Healing Potion" 
        case 591: return "Super Healing Potion" 
        case 592: return "Minor Mana Potion" 
        case 593: return "Light Mana Potion" 
        case 594: return "Mana Potion" 
        case 595: return "Greater Mana Potion" 
        case 596: return "Super Mana Potion" 
        case 597: return "Chipped Skull" 
        case 598: return "Flawed Skull" 
        case 599: return "Skull" 
        case 600: return "Flawless Skull" 
        case 601: return "Perfect Skull" 
        case 602: return "Herb" 
        case 603: return "Small Charm" 
        case 604: return "Large Charm" 
        case 605: return "Grand Charm" 
        case 606: return "Small Red Potion" 
        case 607: return "Large Red Potion" 
        case 608: return "Small Blue Potion" 
        case 609: return "Large Blue Potion" 
        case 610: return "El Rune" 
        case 611: return "Eld Rune" 
        case 612: return "Tir Rune" 
        case 613: return "Nef Rune" 
        case 614: return "Eth Rune" 
        case 615: return "Ith Rune" 
        case 616: return "Tal Rune" 
        case 617: return "Ral Rune" 
        case 618: return "Ort Rune" 
        case 619: return "Thul Rune" 
        case 620: return "Amn Rune" 
        case 621: return "Sol Rune" 
        case 622: return "Shael Rune" 
        case 623: return "Dol Rune" 
        case 624: return "Hel Rune" 
        case 625: return "Io Rune" 
        case 626: return "Lum Rune" 
        case 627: return "Ko Rune" 
        case 628: return "Fal Rune" 
        case 629: return "Lem Rune" 
        case 630: return "Pul Rune" 
        case 631: return "Um Rune" 
        case 632: return "Mal Rune" 
        case 633: return "Ist Rune" 
        case 634: return "Gul Rune" 
        case 635: return "Vex Rune" 
        case 636: return "Ohm Rune" 
        case 637: return "Lo Rune" 
        case 638: return "Sur Rune" 
        case 639: return "Ber Rune" 
        case 640: return "Jah Rune" 
        case 641: return "Cham Rune" 
        case 642: return "Zod Rune" 
        case 643: return "Jewel" 
        case 644: return "Malah's Potion" 
        case 645: return "Scroll of Knowledge" 
        case 646: return "Scroll of Resistance" 
        case 647: return "Key of Terror" 
        case 648: return "Key of Hate" 
        case 649: return "Key of Destruction" 
        case 650: return "Diablo's Horn" 
        case 651: return "Baal's Eye" 
        case 652: return "Mephisto's Brain" 
        case 653: return "Token of Absolution" 
        case 654: return "Twisted Essence of Suffering" 
        case 655: return "Charged Essense of Hatred" 
        case 656: return "Burning Essence of Terror" 
        case 657: return "Festering Essence of Destruction" 
        case 658: return "Standard of Heroes"
    }
    return ""
}