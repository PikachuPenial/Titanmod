GM.Name = "Titanmod"
GM.Author = "Penial"
GM.Email = "smile"
GM.Website = "https://github.com/PikachuPenial"

--Derives the gamemode with Sandbox if Developer Mode is enabled on server start.
if GetConVar("tm_developermode"):GetInt() == 1 then DeriveGamemode("sandbox") end

--Creating client ConVars, mostly for use in the Options menu.
if CLIENT then
    CreateClientConVar("tm_hitsounds", 1, true, false, "Enable/disable the hitsounds", 0, 1)
    CreateClientConVar("tm_killsound", 1, true, false, "Enable/disable the kill confirmation sound", 0, 1)
    CreateClientConVar("tm_menumusic", 1, true, false, "Enable/disable the Main Menu music", 0, 1)
    CreateClientConVar("tm_menumusicvolume", 0.90, true, false, "Increase or lower the volume of the Main Menu music", 0, 1)
    CreateClientConVar("tm_hitsoundtype", 0, true, false, "Switch between the multiple styles of hitsounds", 0, 2)
    CreateClientConVar("tm_killsoundtype", 0, true, false, "Switch between the multiple styles of kill sounds", 0, 1)
    CreateClientConVar("tm_menudof", 1, true, false, "Enable or disable Depth Of Field on certain in game menus", 0, 1)
    CreateClientConVar("tm_nadebind", KEY_4, true, true, "Determines the keybind that will begin cocking a grenade")
    CreateClientConVar("tm_mainmenubind", KEY_M, true, true, "Determines the keybind that will open the main menu")
    CreateClientConVar("tm_hidestatsfromothers", 0, true, true, "Determines if other players can see and/or compare your stats", 0, 1)

    CreateClientConVar("tm_hud_enable", 1, true, false, "Enable/disable any custom HUD elements created by the gamemode", 0, 1)
    CreateClientConVar("tm_hud_enablekill", 1, true, false, "Enable/disable the kill UI", 0, 1)
    CreateClientConVar("tm_hud_enabledeath", 1, true, false, "Enable/disable the death UI", 0, 1)
    CreateClientConVar("tm_hud_enablekillfeed", 1, true, false, "Enable/disable the kill feed", 0, 1)
    CreateClientConVar("tm_hud_font", "Arial", true, false, "Enable/disable any custom HUD elements created by the gamemode")
    CreateClientConVar("tm_hud_font_scale", 1, true, false, "Enable/disable any custom HUD elements created by the gamemode", 0.5, 1.5)
    CreateClientConVar("tm_hud_font_kill", 0, true, false, "Enable/disable the use of your custom font for the kill UI", 0, 1)
    CreateClientConVar("tm_hud_font_death", 0, true, false, "Enable/disable the use of your custom font for the death UI", 0, 1)
    CreateClientConVar("tm_hud_ammo_style", 0, true, false, "Adjusts the style and look of the ammo counter", 0, 1)
    CreateClientConVar("tm_hud_ammo_wep_text_color_r", 255, true, false, "Adjusts the red coloring for the weapon name text", 0, 255)
    CreateClientConVar("tm_hud_ammo_wep_text_color_g", 255, true, false, "Adjusts the green coloring for the weapon name text", 0, 255)
    CreateClientConVar("tm_hud_ammo_wep_text_color_b", 255, true, false, "Adjusts the blue coloring for the weapon name text", 0, 255)
    CreateClientConVar("tm_hud_ammo_bar_color_r", 150, true, false, "Adjusts the red coloring for the ammo bar", 0, 255)
    CreateClientConVar("tm_hud_ammo_bar_color_g", 100, true, false, "Adjusts the green coloring for the ammo bar", 0, 255)
    CreateClientConVar("tm_hud_ammo_bar_color_b", 50, true, false, "Adjusts the blue coloring for the ammo bar", 0, 255)
    CreateClientConVar("tm_hud_ammo_text_color_r", 255, true, false, "Adjusts the red coloring for the ammo text", 0, 255)
    CreateClientConVar("tm_hud_ammo_text_color_g", 255, true, false, "Adjusts the green coloring for the ammo text", 0, 255)
    CreateClientConVar("tm_hud_ammo_text_color_b", 255, true, false, "Adjusts the blue coloring for the ammo text", 0, 255)
    CreateClientConVar("tm_hud_health_size", 450, true, false, "Adjusts the size of the players health bar", 100, 1000)
    CreateClientConVar("tm_hud_health_offset_x", 0, true, false, "Adjusts the X offset of the players health bar", 0, ScrW())
    CreateClientConVar("tm_hud_health_offset_y", 0, true, false, "Adjusts the Y offset of the players health bar", 0, ScrH())
    CreateClientConVar("tm_hud_health_text_color_r", 255, true, false, "Adjusts the red coloring for the health text", 0, 255)
    CreateClientConVar("tm_hud_health_text_color_g", 255, true, false, "Adjusts the green coloring for the health text", 0, 255)
    CreateClientConVar("tm_hud_health_text_color_b", 255, true, false, "Adjusts the blue coloring for the health text", 0, 255)
    CreateClientConVar("tm_hud_health_color_high_r", 100, true, false, "Adjusts the red coloring for the health bar while on high health", 0, 255)
    CreateClientConVar("tm_hud_health_color_high_g", 180, true, false, "Adjusts the green coloring for the health bar while on high health", 0, 255)
    CreateClientConVar("tm_hud_health_color_high_b", 100, true, false, "Adjusts the blue coloring for the health bar while on high health", 0, 255)
    CreateClientConVar("tm_hud_health_color_mid_r", 180, true, false, "Adjusts the red coloring for the health bar while on medium health", 0, 255)
    CreateClientConVar("tm_hud_health_color_mid_g", 180, true, false, "Adjusts the green coloring for the health bar while on medium health", 0, 255)
    CreateClientConVar("tm_hud_health_color_mid_b", 100, true, false, "Adjusts the blue coloring for the health bar while on medium health", 0, 255)
    CreateClientConVar("tm_hud_health_color_low_r", 180, true, false, "Adjusts the red coloring for the health bar while on low health", 0, 255)
    CreateClientConVar("tm_hud_health_color_low_g", 100, true, false, "Adjusts the green coloring for the health bar while on low health", 0, 255)
    CreateClientConVar("tm_hud_health_color_low_b", 100, true, false, "Adjusts the blue coloring for the health bar while on low health", 0, 255)
    CreateClientConVar("tm_hud_killfeed_style", 0, true, false, "Switch the killfeed entries between ascending and descending", 0, 1)
    CreateClientConVar("tm_hud_killfeed_limit", 4, true, false, "Limit the amount of kill feed entries that are shown at one time", 1, 10)
    CreateClientConVar("tm_hud_killfeed_offset_x", 0, true, false, "Adjusts the X offset of the kill feed", 0, ScrW())
    CreateClientConVar("tm_hud_killfeed_offset_y", 45, true, false, "Adjusts the Y offset of the kill feed", 0, ScrH())
    CreateClientConVar("tm_hud_killdeath_offset_x", 0, true, false, "Adjusts the X offset of the kill and death UI", ScrW() / -2, ScrW() / 2)
    CreateClientConVar("tm_hud_killdeath_offset_y", 335, true, false, "Adjusts the Y offset of the kill and death UI", 0, ScrH())
    CreateClientConVar("tm_hud_reloadhint", 1, true, false, "Enable/disable the reload text when out of ammo", 0, 1)
    CreateClientConVar("tm_hud_loadouthint", 1, true, false, "Enable/disable the loadout info displaying on player spawn", 0, 1)
    CreateClientConVar("tm_hud_killaccolades", 1, true, false, "Enable/disable the accolade text on the kill UI", 0, 1)
    CreateClientConVar("tm_hud_killtracker", 0, true, false, "Enable/disable the weapon specific kill tracking on the UI", 0, 1)
end

--Disabling footsteps if a player is crouched.
hook.Add("PlayerFootstep", "MuteCrouchFootsteps", function(ply, pos, foot, sound, volume, ktoslishet)
    if !ply:Crouching() then return end
    return true
end)

--Disable the default HL2 death sound.
hook.Add("PlayerDeathSound", "OverrideDeathSound", function(ply)
    return true
end)

--Sets up keybinds.
hook.Add("PlayerButtonDown", "NadeCock", function(ply, button)
    if button == ply:GetInfoNum("tm_mainmenubind", KEY_M) and !ply:Alive() then
        net.Start("OpenMainMenu")
        net.Send(ply)
        ply:SetNWBool("mainmenu", true)
    end
    if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("+quicknade") end
    hook.Add("PlayerButtonUp", "NadeThrow", function(ply, button)
        if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("-quicknade") end
    end)
end)

--Model Array Formatting (Model ID, Model Name, Model Description, Unlock Style, Unlock Value)
modelArray = {}
modelArray[1] = {"models/player/Group03/male_02.mdl", "Male", "The default male character.", "default", "default"}
modelArray[2] = {"models/player/Group03/female_02.mdl", "Female", "The default female character.", "default", "default"}
modelArray[3] = {"models/player/Group01/male_03.mdl", "Casual Male", "Why so serious?", "default", "default"}
modelArray[4] = {"models/player/mossman.mdl", "Casual Female", "Why so serious?", "default", "default"}
modelArray[5] = {"models/player/Group03m/male_05.mdl", "Doctor", "I need a medic bag.", "default", "default"}
modelArray[6] = {"models/player/Group03m/female_06.mdl", "Nurse", "I need a medic bag.", "default", "default"}
modelArray[7] = {"models/player/barney.mdl", "Barney", "Not purple this time.", "default", "default"}
modelArray[8] = {"models/player/breen.mdl", "Breen", "i couldn't think of anything", "default", "default"}
modelArray[9] = {"models/player/kleiner.mdl", "Kleiner", "But in the end.", "default", "default"}
modelArray[10] = {"models/player/Group01/male_07.mdl", "Male 07", "The one, the only.", "kills", 100}
modelArray[11] = {"models/player/alyx.mdl", "Alyx", "ughhhhhhhhh.", "kills", 300}
modelArray[12] = {"models/player/hostage/hostage_04.mdl", "Scientist", "Bill Nye.", "kills", 500}
modelArray[13] = {"models/player/gman_high.mdl", "GMan", "Where is 3?", "kills", 1000}
modelArray[14] = {"models/player/p2_chell.mdl", "Chell", "Funny portal reference.", "kills", 2000}
modelArray[15] = {"models/player/leet.mdl", "Badass", "So cool.", "kills", 3000}
modelArray[16] = {"models/player/arctic.mdl", "Frozen", "I don't think it's cold in here.", "streak", 5}
modelArray[17] = {"models/player/riot.mdl", "Riot", "Tanto Addict.", "streak", 10}
modelArray[18] = {"models/player/gasmask.mdl", "Hazard Suit", "This isn't Rust.", "streak", 15}
modelArray[19] = {"models/player/police.mdl", "Officer", "Pick up the can.", "streak", 20}
modelArray[20] = {"models/player/combine_soldier_prisonguard.mdl", "Cobalt Soilder", "No green card?", "streak", 25}
modelArray[21] = {"models/walterwhite/playermodels/walterwhitechem.mdl", "Drug Dealer", "waltuh.", "streak", 30}
modelArray[22] = {"models/paynamia/bms/gordon_survivor_player.mdl", "Gordon", "", "headshot", 450}
modelArray[23] = {"models/player/darky_m/rust/arctic_hazmat.mdl", "Arctic", "", "headshot", 1000}
modelArray[24] = {"models/player/darky_m/rust/scientist.mdl", "Cobalt", "", "smackdown", 100}
modelArray[25] = {"models/titanfall2_playermodel/kanepm.mdl", "Kane", "", "smackdown", 200}
modelArray[26] = {"models/player/combine_super_soldier.mdl", "Super Soilder", "@Portanator", "clutch", 80}
modelArray[27] = {"models/player/darky_m/rust/spacesuit.mdl", "Spacesuit", "", "clutch", 160}
modelArray[28] = {"models/player/darky_m/rust/hazmat.mdl", "Hazmat", "", "longshot", 150}
modelArray[29] = {"models/player/darky_m/rust/nomad.mdl", "Nomad", "", "longshot", 350}
modelArray[30] = {"models/maxpayne3/ufe/ufepm.mdl", "UFE", "", "pointblank", 240}
modelArray[31] = {"models/kyo/ghot.mdl", "Ghost", "", "pointblank", 480}
modelArray[32] = {"models/captainbigbutt/vocaloid/miku_classic.mdl", "Miku", "", "killstreaks", 160}
modelArray[33] = {"models/Fate_Extella_Link/Astolfo/Astolfo.mdl", "Astolfo", "", "killstreaks", 360}
modelArray[34] = {"models/pacagma/humans/heroes/imc_hero_viper_player.mdl", "Viper", "", "buzzkills", 160}
modelArray[35] = {"models/auditor/titanfall2/cooper/chr_jackcooper.mdl", "Cooper", "", "buzzkills", 360}

--Calling Card Array Formatting (Image File, Card Name, Card Description, Unlock Style, Unlock Value)
cardArray = {}
cardArray[1] = {"cards/default/barrels.png", "Barrels", "kaboom.", "default", "default"}
cardArray[2] = {"cards/default/construct.png", "Construct", "A classic.", "default", "default"}
cardArray[3] = {"cards/default/grapple.png", "Grapple Hook", "360 no scope.", "default", "default"}
cardArray[4] = {"cards/default/industry.png", "Industry", "To dupe, or not to dupe.", "default", "default"}
cardArray[5] = {"cards/default/overhead.png", "Overhead", "Trees.", "default", "default"}
cardArray[6] = {"cards/default/specops.png", "Spec Ops", "NVG's and stuff.", "default", "default"}
cardArray[7] = {"cards/kills/pistoling.png", "Pistoling", "9x19 my beloved.", "kills", 300}
cardArray[8] = {"cards/kills/smoke.png", "Smoke", "Cool soilders doing things.", "kills", 1200}
cardArray[9] = {"cards/kills/titan.png", "Titan", "Titanfall 2 <3", "kills", 2500}
cardArray[10] = {"cards/kills/killstreak10.png", "Convoy", "helicoboptor.", "streak", 10}
cardArray[11] = {"cards/kills/killstreak20.png", "On Fire", "You did pretty well.", "streak", 20}
cardArray[12] = {"cards/kills/killstreak30.png", "Nuclear", "pumpkin eater.", "streak", 30}
cardArray[13] = {"cards/accolades/headshot_200.png", "Headshot You", "I headshot you.", "headshot", 200}
cardArray[14] = {"cards/accolades/headshot_750.png", "Headhunter", "S&W addict.", "headshot", 750}
cardArray[15] = {"cards/accolades/smackdown_50.png", "Karambit", "Movement players favorite.", "smackdown", 50}
cardArray[16] = {"cards/accolades/smackdown_150.png", "Samuri", "Fruit ninja enjoyer.", "smackdown", 150}
cardArray[17] = {"cards/accolades/clutch_40.png", "Desert Eagle", "crunch!", "clutch", 40}
cardArray[18] = {"cards/accolades/clutch_120.png", "Magnum", "even louder crunch!", "clutch", 120}
cardArray[19] = {"cards/accolades/longshot_80.png", "Down Sights", "Bipod down.", "longshot", 80}
cardArray[20] = {"cards/accolades/longshot_250.png", "Stalker", "buy awp bruv.", "longshot", 250}
cardArray[21] = {"cards/accolades/pointblank_125.png", "Showers", "Drip or drown BEAR.", "pointblank", 120}
cardArray[22] = {"cards/accolades/pointblank_450.png", "No Full Auto", "in buildings.", "pointblank", 300}
cardArray[23] = {"cards/accolades/killstreaks_80.png", "Soilder", "bang bang pow.", "killstreaks", 80}
cardArray[24] = {"cards/accolades/killstreaks_240.png", "Badass", "Never look back.", "killstreaks", 240}
cardArray[25] = {"cards/accolades/buzzkills_80.png", "Wobblers", "I. am. alive.", "buzzkills", 80}
cardArray[26] = {"cards/accolades/buzzkills_240.png", "Execution", "Bye bye.", "buzzkills", 240}
cardArray[27] = {"cards/color/red.png", "Red", "Solid red color.", "color", "color"}
cardArray[28] = {"cards/color/orange.png", "Orange", "Solid orange color.", "color", "color"}
cardArray[29] = {"cards/color/yellow.png", "Yellow", "Solid yellow color.", "color", "color"}
cardArray[30] = {"cards/color/lime.png", "Lime", "Solid lime color.", "color", "color"}
cardArray[31] = {"cards/color/cyan.png", "Cyan", "Solid cyan color.", "color", "color"}
cardArray[32] = {"cards/color/blue.png", "Blue", "Solid blue color.", "color", "color"}
cardArray[33] = {"cards/color/purple.png", "Purple", "Solid magenta color.", "color", "color"}
cardArray[34] = {"cards/color/pink.png", "Pink", "Solid pink color.", "color", "color"}
cardArray[35] = {"cards/color/brown.png", "Brown", "Solid brown color.", "color", "color"}
cardArray[36] = {"cards/color/gray.png", "Gray", "Solid gray color.", "color", "color"}
cardArray[37] = {"cards/color/white.png", "White", "Solid white color.", "color", "color"}
cardArray[38] = {"cards/color/black.png", "Black", "Solid black color.", "color", "color"}

--Mastery Cards
cardArray[39] = {"cards/mastery/aa12.png", "Close Up", "AA-12 mastery", "mastery", "tfa_ins2_aa12"}
cardArray[40] = {"cards/mastery/acrc.png", "Posted Up", "ACR-C mastery", "mastery", "tfa_ins2_acrc"}
cardArray[41] = {"cards/mastery/aek971.png", "Stalker", "AEK-971 mastery", "mastery", "tfa_ins2_aek971"}
cardArray[42] = {"cards/mastery/akms.png", "Sunset", "AKMS mastery", "mastery", "tfa_ins2_akms"}
cardArray[43] = {"cards/mastery/aks74u.png", "Loaded", "AKS-74U mastery", "mastery", "tfa_ins2_aks_r"}
cardArray[44] = {"cards/mastery/ak12.png", "Inspection", "AK-12 mastery", "mastery", "tfa_ins2_ak12"}
cardArray[45] = {"cards/mastery/ak400.png", "Overhead", "AK-400 mastery", "mastery", "tfa_ins2_ak400"}
cardArray[46] = {"cards/mastery/an94.png", "Hijacked", "AN-94 mastery", "mastery", "tfa_ins2_abakan"}
cardArray[47] = {"cards/mastery/ar57.png", "Ghost", "AR-57 mastery", "mastery", "tfa_ins2_ar57"}
cardArray[48] = {"cards/mastery/ash12.png", "Factory", "ASh-12 mastery", "mastery", "tfa_at_shak_12"}
cardArray[49] = {"cards/mastery/auga3.png", "Cute", "AUG A3 mastery", "mastery", "tfa_fml_csgo_aug"}
cardArray[50] = {"cards/mastery/asval.png", "Obesa", "AS-VAL mastery", "mastery", "tfa_inss_asval"}
cardArray[51] = {"cards/mastery/awm.png", "Dust II", "AWM mastery", "mastery", "tfa_ins2_warface_awm"}
cardArray[52] = {"cards/mastery/ax308.png", "Down Range", "AX-308 mastery", "mastery", "tfa_ins2_warface_ax308"}
cardArray[53] = {"cards/mastery/barrettm98b.png", "Ready", "Barrett M98B mastery", "mastery", "tfa_ins2_barrett_m98_bravo"}
cardArray[54] = {"cards/mastery/berettamx4.png", "House", "Barrett Mx4 mastery", "mastery", "tfa_ins2_mx4"}
cardArray[55] = {"cards/mastery/bren.png", "Flank", "Bren mastery", "mastery", "tfa_doibren"}
cardArray[56] = {"cards/mastery/btmp9.png", "Training", "B&T MP9 mastery", "mastery", "tfa_ins2_warface_bt_mp9"}
cardArray[57] = {"cards/mastery/cheyintervention.png", "Trickshot", "CheyTac M200 mastery", "mastery", "tfa_ins2_warface_cheytac_m200"}
cardArray[58] = {"cards/mastery/colt9mm.png", "Magazines", "Colt 9mm mastery", "mastery", "tfa_ins2_m4_9mm"}
cardArray[59] = {"cards/mastery/colt1911.png", "Relic", "Colt M1911 mastery", "mastery", "tfa_nam_m1911"}
cardArray[60] = {"cards/mastery/coltm45a1.png", "Legend", "Colt M45A1 mastery", "mastery", "tfa_ins2_colt_m45"}
cardArray[61] = {"cards/mastery/cz75.png", "Nuke", "CZ 75 B mastery", "mastery", "tfa_ins2_cz75"}
cardArray[62] = {"cards/mastery/cz805.png", "Attached", "CZ 805 mastery", "mastery", "tfa_ins2_cz805"}
cardArray[63] = {"cards/mastery/ddm4v5.png", "Carbine", "DDM4V5 mastery", "mastery", "tfa_ins2_ddm4v5"}
cardArray[64] = {"cards/mastery/deserteagle.png", "Mag Check", "Desert Eagle mastery", "mastery", "tfa_ins2_deagle"}
cardArray[65] = {"cards/mastery/dsr1.png", "Arena", "DSR-1 mastery", "mastery", "tfa_ins2_warface_amp_dsr1"}
cardArray[66] = {"cards/mastery/dualskorpion.png", "Celestial", "Dual Skorpions mastery", "mastery", "tfa_l4d2_skorpion_dual"}
cardArray[67] = {"cards/mastery/famasf1.png", "Siege", "Famas F1 mastery", "mastery", "tfa_ins2_famas"}
cardArray[68] = {"cards/mastery/fb_msbsb.png", "Left", "FB MSBS-B mastery", "mastery", "tfa_blast_lynx_msbsb"}
cardArray[69] = {"cards/mastery/fg42.png", "Glint", "FG 42 mastery", "mastery", "tfa_doifg42"}
cardArray[70] = {"cards/mastery/fiveseven.png", "Intergalactic", "Fiveseven mastery", "mastery", "tfa_ins2_fiveseven_eft"}
cardArray[71] = {"cards/mastery/fn2000.png", "Armory", "FN 2000 mastery", "mastery", "tfa_ins2_fn_2000"}
cardArray[72] = {"cards/mastery/fnfal.png", "Exposed", "FN FAL mastery", "mastery", "tfa_ins2_fn_fal"}
cardArray[73] = {"cards/mastery/fnp45.png", "ACP", "FNP-45 mastery", "mastery", "tfa_ins2_fnp45"}
cardArray[74] = {"cards/mastery/g28.png", "Rooftops", "G28 mastery", "mastery", "tfa_ins2_g28"}
cardArray[75] = {"cards/mastery/g36a1.png", "Aimpoint", "G36A1 mastery", "mastery", "tfa_ins2_g36a1"}
cardArray[76] = {"cards/mastery/glock17.png", "Ospery", "Glock 17 mastery", "mastery", "tfa_glk_gen4"}
cardArray[77] = {"cards/mastery/gsh18.png", "Skyscraper", "GSH-18 mastery", "mastery", "tfa_ins2_gsh18"}
cardArray[78] = {"cards/mastery/hk53.png", "Chains", "HK53 mastery", "mastery", "tfa_ins2_fml_hk53"}
cardArray[79] = {"cards/mastery/honeybadger.png", "Business", "Honey Badger mastery", "mastery", "tfa_ins2_cq300"}
cardArray[80] = {"cards/mastery/howatype64.png", "Cradle", "Howa Type 64 mastery", "mastery", "tfa_howa_type_64"}
cardArray[81] = {"cards/mastery/imbelia2.png", "Due Process", "Imbel IA2 mastery", "mastery", "tfa_ins2_imbelia2"}
cardArray[82] = {"cards/mastery/japaneseararebo.png", "Industry", "Japanese Ararebo master", "mastery", "tfa_ararebo_bf1"}
cardArray[83] = {"cards/mastery/km2000.png", "Flatgrass", "KM-2000 mastery", "mastery", "tfa_km2000_knife"}
cardArray[84] = {"cards/mastery/krissvector.png", "Narkotica", "KRISS Vector mastery", "mastery", "tfa_ins2_krissv"}
cardArray[85] = {"cards/mastery/ksg.png", "Flames", "KSG mastery", "mastery", "tfa_ins2_ksg"}
cardArray[86] = {"cards/mastery/ksvk.png", "Quickscope", "KSVK 12.7 mastery", "mastery", "tfa_blast_ksvk_cqb"}
cardArray[87] = {"cards/mastery/leeenfield.png", "Minecraft", "Lee-Enfield No. 4 master", "mastery", "tfa_doi_enfield"}
cardArray[88] = {"cards/mastery/lewis.png", "Plates", "Lewis mastery", "mastery", "tfa_doilewis"}
cardArray[89] = {"cards/mastery/lr300.png", "Oil Rig", "LR-300 mastery", "mastery", "tfa_ins2_zm_lr300"}
cardArray[90] = {"cards/mastery/m1garand.png", "Underworld", "M1 Garand mastery", "mastery", "tfa_doi_garand"}
cardArray[91] = {"cards/mastery/m14.png", "Bridge", "M14 mastery", "mastery", "tfa_ins2_m14retro"}
cardArray[92] = {"cards/mastery/m3grease.png", "Grease", "M3 Grease Gun mastery", "mastery", "tfa_doim3greasegun"}
cardArray[93] = {"cards/mastery/m4a1.png", "Modified", "M4A1 mastery", "mastery", "tfa_ins2_eftm4a1"}
cardArray[94] = {"cards/mastery/m9.png", "Full Metal", "M9 mastery", "mastery", "tfa_ins2_m9"}
cardArray[95] = {"cards/mastery/m79.png", "Cool With It", "M79 mastery", "mastery", "tfa_nam_m79"}
cardArray[96] = {"cards/mastery/m1918.png", "Bipod", "M1918 mastery", "mastery", "tfa_doim1918"}
cardArray[97] = {"cards/mastery/m1919.png", "Customs", "M1919 mastery", "mastery", "tfa_doim1919"}
cardArray[98] = {"cards/mastery/m249.png", "Roof Camper", "M249 mastery", "mastery", "tfa_ins2_minimi"}
cardArray[99] = {"cards/mastery/mac10.png", "Dev", "Mac 10 mastery", "mastery", "bocw_mac10_alt"}
cardArray[100] = {"cards/mastery/makarov.png", "Leaves", "Makarov mastery", "mastery", "tfa_ins2_pm"}
cardArray[101] = {"cards/mastery/maresleg.png", "High Optic", "Mare's Leg mastery", "mastery", "tfa_tfre_maresleg"}
cardArray[102] = {"cards/mastery/mas38.png", "Galaxy", "Mas 38 mastery", "mastery", "tfa_fml_lefrench_mas38"}
cardArray[103] = {"cards/mastery/mg34.png", "Heavy   ", "MG 34 mastery", "mastery", "tfa_doimg34"}
cardArray[104] = {"cards/mastery/mg42.png", "D-Day", "MG 42 mastery", "mastery", "tfa_doimg42"}
cardArray[105] = {"cards/mastery/mk23.png", "Uranium", "MK 23 mastery", "mastery", "tfa_ins2_mk23"}
cardArray[106] = {"cards/mastery/mk18.png", "Wednesday", "MK18 mastery", "mastery", "tfa_fml_inss_mk18"}
cardArray[107] = {"cards/mastery/mk14ebr.png", "Prepared", "Mk. 14 EBR mastery", "mastery", "tfa_ins2_mk14ebr"}
cardArray[108] = {"cards/mastery/model10.png", "Walter", "Model 10 mastery", "mastery", "tfa_ins2_swmodel10"}
cardArray[109] = {"cards/mastery/mosin.png", "Rebirth", "Mosin Nagant mastery", "mastery", "tfa_ins2_mosin_nagant"}
cardArray[110] = {"cards/mastery/mp40.png", "Reflection", "MP 40 mastery", "mastery", "tfa_doimp40"}
cardArray[111] = {"cards/mastery/mp443.png", "Bush", "MP-443 mastery", "mastery", "tfa_ins2_mp443"}
cardArray[112] = {"cards/mastery/mp5.png", "Mode Select", "MP5 mastery", "mastery", "tfa_inss2_hk_mp5a5"}
cardArray[113] = {"cards/mastery/mp5k.png", "H&K", "MP5K mastery", "mastery", "tfa_ins2_mp5k"}
cardArray[114] = {"cards/mastery/mp7a1.png", "Oilspill", "MP7A1 mastery", "mastery", "tfa_ins2_mp7"}
cardArray[115] = {"cards/mastery/mp18.png", "Modern", "MP18 mastery", "mastery", "tfa_ww1_mp18"}
cardArray[116] = {"cards/mastery/mr96.png", "Polish", "MR-96 mastery", "mastery", "tfa_ins2_mr96"}
cardArray[117] = {"cards/mastery/mts225.png", "Slug", "MTs225-12 mastery", "mastery", "tfa_ins2_mc255"}
cardArray[118] = {"cards/mastery/nova.png", "Dark Streets", "Nova mastery", "mastery", "tfa_ins2_nova"}
cardArray[119] = {"cards/mastery/orsist5000.png", "Reserve", "Orsis T-5000 mastery", "mastery", "tfa_ins2_warface_orsis_t5000"}
cardArray[120] = {"cards/mastery/osp18.png", "Irons", "OSP-18 mastery", "mastery", "tfa_l4d2_osp18"}
cardArray[121] = {"cards/mastery/otsgroza.png", "Bullpup", "OTs-14 Groza mastery", "mastery", "tfa_ins2_groza"}
cardArray[122] = {"cards/mastery/otspernach.png", "Speedloader", "OTs-33 Pernach mastery", "mastery", "tfa_ins2_ots_33_pernach"}
cardArray[123] = {"cards/mastery/owenmki.png", "Grid", "Owen Mk.I mastery", "mastery", "tfa_doiowen"}
cardArray[124] = {"cards/mastery/p90.png", "MISSING", "P90 mastery", "mastery", "tfa_fml_p90_tac"}
cardArray[125] = {"cards/mastery/pindad.png", "Labs", "PINDAD SS2-V1 mastery", "mastery", "tfa_blast_pindadss2"}
cardArray[126] = {"cards/mastery/pm9.png", "Akimbo", "PM-9 mastery", "mastery", "tfa_ins2_pm9"}
cardArray[127] = {"cards/mastery/ppsh41.png", "Mephitic", "PPSH-41 mastery", "mastery", "tfa_nam_ppsh41"}
cardArray[128] = {"cards/mastery/ppbizon.png", "Rainbow", "PP-Bizon mastery", "mastery", "tfa_fas2_ppbizon"}
cardArray[129] = {"cards/mastery/pzb39.png", "Exotic", "PzB 39 mastery", "mastery", "tfa_ww2_pbz39"}
cardArray[130] = {"cards/mastery/qbz97.png", "Hideout", "QBZ-97 mastery", "mastery", "tfa_ins2_norinco_qbz97"}
cardArray[131] = {"cards/mastery/qsz92.png", "yippee", "QSZ-92 mastery", "mastery", "tfa_ins2_qsz92"}
cardArray[132] = {"cards/mastery/remingtonm870.png", "Mastery", "Remington M870 master", "mastery", "tfa_ins2_remington_m870"}
cardArray[133] = {"cards/mastery/remingtonmsr.png", "Lightshow", "Remington MSR mastery", "mastery", "tfa_ins2_pd2_remington_msr"}
cardArray[134] = {"cards/mastery/rfb.png", "Extraction", "RFB mastery", "mastery", "tfa_ins2_rfb"}
cardArray[135] = {"cards/mastery/rk62.png", "Highway", "RK62 mastery", "mastery", "tfa_fml_rk62"}
cardArray[136] = {"cards/mastery/rpg7.png", "Damascus", "RPG-7 mastery", "mastery", "tfa_ins2_rpg7_scoped"}
cardArray[137] = {"cards/mastery/rpk74m.png", "Elcan", "RPK-74M mastery", "mastery", "tfa_ins2_rpk_74m"}
cardArray[138] = {"cards/mastery/sa80.png", "Groves", "SA80 mastery", "mastery", "tfa_ins2_l85a2"}
cardArray[139] = {"cards/mastery/sawedoff.png", "Halves", "Sawed Off mastery", "mastery", "tfa_ins2_izh43sw"}
cardArray[140] = {"cards/mastery/scarh.png", "Tilted", "SCAR-H mastery", "mastery", "tfa_ins2_scar_h_ssr"}
cardArray[141] = {"cards/mastery/scorpionevo.png", "Raid", "Scorpion Evo mastery", "mastery", "tfa_ins2_sc_evo"}
cardArray[142] = {"cards/mastery/sigp320.png", "Sauer", "SIG P320 mastery", "mastery", "tfa_ins2_p320_m18"}
cardArray[143] = {"cards/mastery/skorpion.png", "Black Hole", "Skorpion mastery", "mastery", "tfa_l4d2_skorpion"}
cardArray[144] = {"cards/mastery/sks.png", "Scav", "SKS mastery", "mastery", "tfa_ins2_sks"}
cardArray[145] = {"cards/mastery/spas.png", "Twelve Gauge", "SPAS-12 mastery", "mastery", "tfa_ins2_spas12"}
cardArray[146] = {"cards/mastery/spectrem4.png", "Mall", "Spectre M4 mastery", "mastery", "tfa_ins2_spectre"}
cardArray[147] = {"cards/mastery/spikex15.png", "Prototype", "Spike X15 mastery", "mastery", "tfa_ins2_saiga_spike"}
cardArray[148] = {"cards/mastery/sr2m.png", "Blueprint", "SR-2M Veresk mastery", "mastery", "tfa_ins2_sr2m_veresk"}
cardArray[149] = {"cards/mastery/sten.png", "Lens Flare", "Sten Mk.II mastery", "mastery", "tfa_doisten"}
cardArray[150] = {"cards/mastery/stevens620.png", "Mod", "Stevens 620 mastery", "mastery", "tfa_nam_stevens620"}
cardArray[151] = {"cards/mastery/stg44.png", "Wood", "StG44 mastery", "mastery", "tfa_doistg44"}
cardArray[152] = {"cards/mastery/sv98.png", "Vertigo", "SV-98 mastery", "mastery", "tfa_ins2_sv98"}
cardArray[153] = {"cards/mastery/sw500.png", "Companion", "S&W 500 mastery", "mastery", "tfa_ins2_s&w_500"}
cardArray[154] = {"cards/mastery/tanto.png", "Shipment", "Tanto mastery", "mastery", "tfa_japanese_exclusive_tanto"}
cardArray[155] = {"cards/mastery/tariq.png", "Dog", "Tariq mastery", "mastery", "tfa_ins_sandstorm_tariq"}
cardArray[156] = {"cards/mastery/thompsonm1928.png", "Typewritter", "Thompson M1928 master", "mastery", "tfa_doithompsonm1928"}
cardArray[157] = {"cards/mastery/thompson.png", "Suicide", "Thompson M1A1 master", "mastery", "tfa_doithompsonm1a1"}
cardArray[158] = {"cards/mastery/type81.png", "Leauge", "Type 81 mastery", "mastery", "tfa_ins2_type81"}
cardArray[159] = {"cards/mastery/typhoonf12.png", "Ultrakill", "Typhoon F12 mastery", "mastery", "tfa_ins2_typhoon12"}
cardArray[160] = {"cards/mastery/ump45.png", "Nuketown", "UMP .45 mastery", "mastery", "tfa_ins2_ump45"}
cardArray[161] = {"cards/mastery/ump9.png", "Waterfall", "UMP9 mastery", "mastery", "tfa_ins2_ump9"}
cardArray[162] = {"cards/mastery/uzi.png", "Alpha", "Uzi mastery", "mastery", "tfa_ins2_imi_uzi"}
cardArray[163] = {"cards/mastery/uzkbr99.png", "Rouge", "UZK-BR99 mastery", "mastery", "tfa_ins2_br99"}
cardArray[164] = {"cards/mastery/vhsd2.png", "Liminal Pool", "VHS-D2 mastery", "mastery", "tfa_ins2_vhsd2"}
cardArray[165] = {"cards/mastery/waltherp99.png", "Advisory", "Walther P99 mastery", "mastery", "tfa_ins2_walther_p99"}
cardArray[166] = {"cards/mastery/xm8.png", "Ragdoll", "XM8 mastery", "mastery", "tfa_ins2_xm8"}

--Leveling Cards
cardArray[167] = {"cards/leveling/10.png", "Mist", "shitty pattern", "level", 10}
cardArray[168] = {"cards/leveling/20.png", "Shift", "shitty pattern #2", "level", 20}
cardArray[169] = {"cards/leveling/30.png", "Powerhouse", "out of stock.", "level", 30}
cardArray[170] = {"cards/leveling/40.png", "Drainer", "@suomij", "level", 40}
cardArray[171] = {"cards/leveling/50.png", "Kitty", "ca t.", "level", 50}
cardArray[172] = {"cards/leveling/60.png", "Kill Yourself", "loser!", "level", 60}
cardArray[173] = {"cards/leveling/70.png", "Arctic", "so pretty.", "level", 70}
cardArray[174] = {"cards/leveling/80.png", "Shark", "why is their a negev", "level", 80}
cardArray[175] = {"cards/leveling/90.png", "Boss Up", "@walter", "level", 90}
cardArray[176] = {"cards/leveling/100.png", "Rig", "best map!", "level", 100}
cardArray[177] = {"cards/leveling/110.png", "Station", "worst map!", "level", 110}
cardArray[178] = {"cards/leveling/120.png", "Ray", "Gor.", "level", 120}
cardArray[179] = {"cards/leveling/130.png", "Dunes", "I LOVE CAPTAINBEAR", "level", 130}
cardArray[180] = {"cards/leveling/140.png", "Pyro", "I LOVE TEARDOWN", "level", 140}
cardArray[181] = {"cards/leveling/150.png", "Table", "table football <3", "level", 150}
cardArray[182] = {"cards/leveling/160.png", "Critters", "meep meep meep meep", "level", 160}
cardArray[183] = {"cards/leveling/170.png", "Sweat", "gg ez", "level", 170}
cardArray[184] = {"cards/leveling/180.png", "Walls", "true statement", "level", 180}
cardArray[185] = {"cards/leveling/190.png", "Dinner", "literally me", "level", 190}
cardArray[186] = {"cards/leveling/200.png", "Thunder", "KILL YOURSELF!", "level", 200}
cardArray[187] = {"cards/leveling/210.png", "David", "...", "level", 210}
cardArray[188] = {"cards/leveling/220.png", "Ohio", "USA <3", "level", 220}
cardArray[189] = {"cards/leveling/230.png", "Eyepatch", "so awesome", "level", 230}
cardArray[190] = {"cards/leveling/240.png", "Pro", "level 3 gulag enjoyer", "level", 240}
cardArray[191] = {"cards/leveling/250.png", "Stare", "so menacing", "level", 250}
cardArray[192] = {"cards/leveling/260.png", "Death", "Factory my beloved", "level", 260}
cardArray[193] = {"cards/leveling/270.png", "Monstor", "narkotica out!", "level", 270}
cardArray[194] = {"cards/leveling/280.png", "Meep", "hi!", "level", 280}
cardArray[195] = {"cards/leveling/290.png", "Superpowers", "bitch!", "level", 290}
cardArray[196] = {"cards/leveling/300.png", "Shocked", "300 levels of pain.", "level", 300}

--Pride cards
cardArray[197] = {"cards/pride/pride.png", "Pride", "Pride flag", "color", "color"}
cardArray[198] = {"cards/pride/trans.png", "Trans", "Trans flag", "color", "color"}
cardArray[199] = {"cards/pride/gay.png", "Gay", "Gay flag", "color", "color"}
cardArray[200] = {"cards/pride/lesbian.png", "Lesbian", "Lesbian flag", "color", "color"}
cardArray[201] = {"cards/pride/bi.png", "Bi", "Bi flag", "color", "color"}
cardArray[202] = {"cards/pride/pan.png", "Pan", "Pan flag", "color", "color"}
cardArray[203] = {"cards/pride/ace.png", "Ace", "Ace flag", "color", "color"}
cardArray[204] = {"cards/pride/nonbinary.png", "Nonbinary", "Nonbinary flag", "color", "color"}
cardArray[205] = {"cards/pride/genderfluid.png", "Genderfluid", "Genderfluid flag", "color", "color"}
cardArray[206] = {"cards/pride/zedo.png", "Zedo", "What's his name?", "color", "color"}

--Creating a leveling array, this removes the consistency of the leveling, using developer set XP requierments per level instead of a formula. Is this time consuming? Yes, very much, but its better trust me bro.
levelArray = {}
levelArray[1] = {1, 750} -- +75 XP
levelArray[2] = {2, 825}
levelArray[3] = {3, 900}
levelArray[4] = {4, 975}
levelArray[5] = {5, 1050}
levelArray[6] = {6, 1125}
levelArray[7] = {7, 1200}
levelArray[8] = {8, 1275}
levelArray[9] = {9, 1350}
levelArray[10] = {10, 1450} -- +100 XP
levelArray[11] = {11, 1550}
levelArray[12] = {12, 1650}
levelArray[13] = {13, 1750}
levelArray[14] = {14, 1850}
levelArray[15] = {15, 1950}
levelArray[16] = {16, 2050}
levelArray[17] = {17, 2150}
levelArray[18] = {18, 2250}
levelArray[19] = {19, 2350}
levelArray[20] = {20, 2475} -- +125 XP
levelArray[21] = {21, 2600}
levelArray[22] = {22, 2725}
levelArray[23] = {23, 2850}
levelArray[24] = {24, 2975}
levelArray[25] = {25, 3100}
levelArray[26] = {26, 3225}
levelArray[27] = {27, 3350}
levelArray[28] = {28, 3475}
levelArray[29] = {29, 3600}
levelArray[30] = {30, 3750} -- +150 XP
levelArray[31] = {31, 3900}
levelArray[32] = {32, 4050}
levelArray[33] = {33, 4200}
levelArray[34] = {34, 4350}
levelArray[35] = {35, 4500}
levelArray[36] = {36, 4650}
levelArray[37] = {37, 4800}
levelArray[38] = {38, 4950}
levelArray[39] = {39, 5100}
levelArray[40] = {40, 5275} -- +175 XP
levelArray[41] = {41, 5450}
levelArray[42] = {42, 5625}
levelArray[43] = {43, 5800}
levelArray[44] = {44, 5975}
levelArray[45] = {45, 6150}
levelArray[46] = {46, 6325}
levelArray[47] = {47, 6500}
levelArray[48] = {48, 6675}
levelArray[49] = {49, 6850}
levelArray[50] = {50, 7050} -- +200 XP
levelArray[51] = {51, 7250}
levelArray[52] = {52, 7450}
levelArray[53] = {53, 7650}
levelArray[54] = {54, 7850}
levelArray[55] = {55, 8075} -- +225 XP
levelArray[56] = {56, 8300}
levelArray[57] = {57, 8525}
levelArray[58] = {58, 8750}
levelArray[59] = {59, 8975}
levelArray[60] = {60, "prestige"}

--Hints, are displayed at the bottom of the death UI.
hintArray = {"Winning the match nets you bonus XP.", "Suppressors might make your gun sound badass, but it will also lower your damage.", "Be vigilant with the acidic flood while playing on the Mephitic map.", "Match Ammunition is a good choice for low accuracy weapons.", "Follow CaptainBear on the Steam Workshop!", "Switching to your secondary is 'usually' faster than reloading.", "To win a match, a player must have more score than the rest of the competing players.", "Bullets may not align with your crosshair or sight due to recoil and inaccuracy.", "Voice chat is proximity based, do with this information as you see fit.", "Magnum ammunition pairs extremely well with low damage weapons.", "Slug ammunition turns your traditional shotgun into a marksman rifle.", "Try personalizing yourself in the cuztomization menus.", "Crouching completely eliminates your footstep audio, embrace the sneaky.", "Underbarrel grenade launchers can be used by pressing Interact + Left Click.", "You can cycle through firing modes by using your Interact + Reload keys.", "All melee weapons can be thrown with the reload key.", "Air strafing is extremely useful, try to incorperate it into your playstyle.", "G.I.B ammunition is a good choice if you want to slow down hit opponents.", "Frag ammunition deafens hit players for a few seconds, and slows down their movement speed.", "Explosive barrels can be used as a funny distraction.", "Players can not shoot most weapons while submerged in water, use this to your advantage.", "Almost everything you do in game is tracked, check out the stats page to compare yourself with others.", "The grappling hook can easily be used to start favorable engagments.", "Jumping and/or being in mid air gives your weapons less accuracy.", "Sliding provides the same accuracy and recoil benefits as crouching.", "Chaining multiple accolades together can give a big score/XP boost.", "Accolades award good amounts of score and XP.", "Running any optic lowers your weapons ADS speed.", "Running any optic lowers your weapons ADS speed.", "There are over 125+ weapons, try to get consistent with many different loadouts.", "There is no scope glint, hardscope all you want.", "Hip fire is an effective strategy while on the move.", "Other players can see your flashlight, be cautious.", "Certain playermodels may shine or stand out in dark enviroments.", "Combine wall running and jumping for extremely unpredictable movement.", "Wall running through a chokepoint can catch opponents off guard.", "Wall jumping constantly allows for continuous climbing of said wall.", "All melee weapons have a left and right click attack, learn how effective each are.", "Attachments save throughout play sessions, tweak your guns once and you are done.", "Some snipers and hand cannons can one shot to the torso.", "Explosives hurt, don't aim downwards if you want to stay alive.", "Crouching drastically increases your accuracy and recoil control.", "Each weapon has its own distinct recoil pattern to master.", "Your grappling hook cooldown refreshes on each kill.", "Shooting the torso and/or head will guarintee good damage per shot.", "You can sprint and/or slide in any direction, not just forwards.", "Don't stand still, potshotters will have an easy time killing you.", "All projectiles are hitscan, there is no bullet velocity/drop to account for.", "The vehicles can be mounted and surfed on while playing the Bridge map.", "Bunny hopping will help perserve velocity after landing from a grapple/slide."}

--Removing unneccessary hooks for optimization purposes.
hook.Add("Initialize", "Optimization", function()
    hook.Remove("PlayerTick", "TickWidgets")
    if SERVER and timer.Exists("CheckHookTimes") then timer.Remove("CheckHookTimes") end
    if CLIENT then
        hook.Remove("RenderScreenspaceEffects", "RenderColorModify")
        hook.Remove("RenderScreenspaceEffects", "RenderBloom")
        hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
        hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
        hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
        hook.Remove("RenderScreenspaceEffects", "RenderSobel")
        hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
        hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
        hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
        hook.Remove("RenderScene", "RenderStereoscopy")
        hook.Remove("RenderScene", "RenderSuperDoF")
        hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
        hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
        hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
        hook.Remove("PostRender", "RenderFrameBlend")
        hook.Remove("PreRender", "PreRenderFrameBlend")
        hook.Remove("Think", "DOFThink")
        hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
        hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
        hook.Remove("PostDrawEffects", "RenderWidgets")
        hook.Remove("PostDrawEffects", "RenderHalos")
    end
end)