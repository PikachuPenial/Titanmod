GM.Name = "Titanmod"
GM.Author = "Penial"
GM.Email = "pissoff"
GM.Website = "https://github.com/PikachuPenial"

--Derives the gamemode with Sandbox if Developer Mode is enabled on server start.
if GetConVar("tm_developermode"):GetInt() == 1 then DeriveGamemode("sandbox") end

--Creating client ConVars, mostly for use in the Options menu.
if !ConVarExists("tm_enableui") then CreateConVar("tm_enableui", "1", FCVAR_ARCHIVE, "Enable/disable any custom UI elements created by the gamemode",0,1) end
if !ConVarExists("tm_enablekillpopup") then CreateConVar("tm_enablekillpopup", "1", FCVAR_ARCHIVE, "Completely show/hide the kill popup",0,1) end
if !ConVarExists("tm_enabledeathpopup") then CreateConVar("tm_enabledeathpopup", "1", FCVAR_ARCHIVE, "Completely show/hide the death popup",0,1) end
if !ConVarExists("tm_healthanchor") then CreateConVar("tm_healthanchor", "0", FCVAR_ARCHIVE, "Changes the corner of the screen that holds your health bar",0,1) end
if !ConVarExists("tm_ammostyle") then CreateConVar("tm_ammostyle", "0", FCVAR_ARCHIVE, "Switch between a numeric value and a bar to display your weapons ammo",0,1) end
if !ConVarExists("tm_hitsounds") then CreateConVar("tm_hitsounds", "1", FCVAR_ARCHIVE, "Enable or disable the hitsounds",0,1) end
if !ConVarExists("tm_killsound") then CreateConVar("tm_killsound", "1", FCVAR_ARCHIVE, "Enable or disable the kill sound",0,1) end
if !ConVarExists("tm_menumusic") then CreateConVar("tm_menumusic", "1", FCVAR_ARCHIVE, "Enable or disable the Main Menu music",0,1) end
if !ConVarExists("tm_menumusicvolume") then CreateConVar("tm_menumusicvolume", "0.90", FCVAR_ARCHIVE, "Increase or lower the volume of the Main Menu music",0,1) end
if !ConVarExists("tm_enableaccolades") then CreateConVar("tm_enableaccolades", "1", FCVAR_ARCHIVE, "Enable or disable the accolade popup in the kill UI",0,1) end
if !ConVarExists("tm_reloadhints") then CreateConVar("tm_reloadhints", "1", FCVAR_ARCHIVE, "Enable or disable the reload text when out of ammo",0,1) end
if !ConVarExists("tm_killuianchor") then CreateConVar("tm_killuianchor", "0", FCVAR_ARCHIVE, "Switch between anchoring the kill UI at the top and the bottom of the screen",0,1) end
if !ConVarExists("tm_deathuianchor") then CreateConVar("tm_deathuianchor", "0", FCVAR_ARCHIVE, "Switch between anchoring the death UI at the top and the bottom of the screen",0,1) end
if !ConVarExists("tm_cardpfpoffset") then CreateConVar("tm_cardpfpoffset", "0", FCVAR_ARCHIVE, "Moves the Profile Picture of the player around their playercard.",0,160) end
if !ConVarExists("tm_hitsoundtype") then CreateConVar("tm_hitsoundtype", "0", FCVAR_ARCHIVE, "Switch between the multiple styles of hitsounds",0,3) end
if !ConVarExists("tm_killsoundtype") then CreateConVar("tm_killsoundtype", "0", FCVAR_ARCHIVE, "Switch between the multiple styles of kill sounds",0,3) end
if !ConVarExists("tm_streamermode") then CreateConVar("tm_streamermode", "0", FCVAR_ARCHIVE, "Switch between the multiple styles of kill sounds",0,1) end
if CLIENT then CreateClientConVar("tm_nadebind", KEY_4, true, true, "Determines the keybind that will begin cocking a grenade.") end
if CLIENT then CreateClientConVar("tm_hidestatsfromothers", 0, true, true, "Determines if other players can see and/or compare your stats.", 0, 1) end

--Disabling footsteps if a player is crouched.
hook.Add("PlayerFootstep", "MuteCrouchFootsteps", function(ply, pos, foot, sound, volume, ktoslishet)
	if !ply:Crouching() then return end
	return true
end)

--Sets up the keybind for grenade throwing.
hook.Add("PlayerButtonDown", "NadeCock", function(ply, button)
    if button == ply:GetInfoNum("tm_nadebind", KEY_4) then
        ply:ConCommand("+quicknade")
    end

    hook.Add("PlayerButtonUp", "NadeThrow", function(ply, button)
        if button == ply:GetInfoNum("tm_nadebind", KEY_4) then
            ply:ConCommand("-quicknade")
        end
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
modelArray[32] = {"models/player/custom_player/legacy/ctm_gendarmerie_variantc.mdl", "General", "", "killstreaks", 160}
modelArray[33] = {"models/player/custom_player/legacy/ctm_gendarmerie_variantb.mdl", "Guard", "", "killstreaks", 360}
modelArray[34] = {"models/captainbigbutt/vocaloid/miku_classic.mdl", "Hatsune Miku", "Easter Egg reward", "special", "name"}

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
cardArray[43] = {"cards/mastery/aks74u.png", "Loaded", "AKS-74U mastery", "mastery", "tfa_inss_aks74u"}
cardArray[44] = {"cards/mastery/ak12_rpk.png", "Inspection", "AK-12 RPK mastery", "mastery", "tfa_ismc_ak12_rpk"}
cardArray[45] = {"cards/mastery/ak400.png", "Overhead", "AK-400 mastery", "mastery", "tfa_ins2_ak400"}
cardArray[46] = {"cards/mastery/amp_dsr1.png", "Arena", "AMP DSR-1 mastery", "mastery", "tfa_ins2_warface_amp_dsr1"}
cardArray[47] = {"cards/mastery/an94.png", "Hijacked", "AN-94 mastery", "mastery", "tfa_ins2_abakan"}
cardArray[48] = {"cards/mastery/ar15.png", "Modified", "AR-15 mastery", "mastery", "tfa_ins2_cw_ar15"}
cardArray[49] = {"cards/mastery/ar57.png", "Ghost", "AR-57 mastery", "mastery", "tfa_ins2_ar57"}
cardArray[50] = {"cards/mastery/ash12.png", "Factory", "ASh-12 mastery", "mastery", "tfa_at_shak_12"}
cardArray[51] = {"cards/mastery/asval.png", "Zedo Pride", "AS-VAL mastery", "mastery", "tfa_inss_asval"}
cardArray[52] = {"cards/mastery/awm.png", "Dust II", "AWM mastery", "mastery", "tfa_ins2_warface_awm"}
cardArray[53] = {"cards/mastery/ax308.png", "Down Range", "AX-308 mastery", "mastery", "tfa_ins2_warface_ax308"}
cardArray[54] = {"cards/mastery/barrettm98b.png", "Ready", "Barrett M98B mastery", "mastery", "tfa_ins2_barrett_m98_bravo"}
cardArray[55] = {"cards/mastery/berettamx4.png", "House", "Barrett Mx4 mastery", "mastery", "tfa_ins2_mx4"}
cardArray[56] = {"cards/mastery/bren.png", "Flank", "Bren mastery", "mastery", "tfa_doibren"}
cardArray[57] = {"cards/mastery/btmp9.png", "Training", "B&T MP9 mastery", "mastery", "tfa_ins2_warface_bt_mp9"}
cardArray[58] = {"cards/mastery/cheyintervention.png", "Trickshot", "CheyTac M200 mastery", "mastery", "tfa_ins2_warface_cheytac_m200"}
cardArray[59] = {"cards/mastery/colt9mm.png", "Magazines", "Colt 9mm mastery", "mastery", "tfa_ins2_m4_9mm"}
cardArray[60] = {"cards/mastery/colt1911.png", "Relic", "Colt M1911 mastery", "mastery", "tfa_new_m1911"}
cardArray[61] = {"cards/mastery/coltm45a1.png", "Legend", "Colt M45A1 mastery", "mastery", "tfa_ins2_colt_m45"}
cardArray[62] = {"cards/mastery/cz75.png", "Nuke", "CZ 75 B mastery", "mastery", "tfa_ins2_cz75"}
cardArray[63] = {"cards/mastery/cz805.png", "Attached", "CZ 805 mastery", "mastery", "tfa_ins2_cz805"}
cardArray[64] = {"cards/mastery/ddm4v5.png", "Carbine", "DDM4V5 mastery", "mastery", "tfa_ins2_ddm4v5"}
cardArray[65] = {"cards/mastery/deserteagle.png", "Mag Check", "Desert Eagle mastery", "mastery", "tfa_ins2_deagle"}
cardArray[66] = {"cards/mastery/famasf1.png", "Siege", "Famas F1 mastery", "mastery", "tfa_ins2_famas"}
cardArray[67] = {"cards/mastery/fb_msbsb.png", "Left", "FB MSBS-B mastery", "mastery", "tfa_blast_lynx_msbsb"}
cardArray[68] = {"cards/mastery/fg42.png", "Glint", "FG 42 mastery", "mastery", "tfa_doifg42"}
cardArray[69] = {"cards/mastery/fiveseven.png", "Intergalactic", "Fiveseven mastery", "mastery", "tfa_ins2_fiveseven_eft"}
cardArray[70] = {"cards/mastery/fn2000.png", "Armory", "FN 2000 mastery", "mastery", "tfa_ins2_fn_2000"}
cardArray[71] = {"cards/mastery/fnfal.png", "Exposed", "FN FAL mastery", "mastery", "tfa_ins2_fn_fal"}
cardArray[72] = {"cards/mastery/fnp45.png", "ACP", "FNP-45 mastery", "mastery", "tfa_ins2_fnp45"}
cardArray[73] = {"cards/mastery/g28.png", "Rooftops", "G28 mastery", "mastery", "tfa_ins2_g28"}
cardArray[74] = {"cards/mastery/galil.png", "Chains", "Galil mastery", "mastery", "tfa_new_inss_galil"}
cardArray[75] = {"cards/mastery/glock17.png", "Ospery", "Glock 17 mastery", "mastery", "tfa_new_glock17"}
cardArray[76] = {"cards/mastery/gsh18.png", "Skyscraper", "GSH-18 mastery", "mastery", "tfa_ins2_gsh18"}
cardArray[77] = {"cards/mastery/honeybadger.png", "Business", "Honey Badger mastery", "mastery", "tfa_ins2_cq300"}
cardArray[78] = {"cards/mastery/howatype64.png", "Cradle", "Howa Type 64 mastery", "mastery", "tfa_howa_type_64"}
cardArray[79] = {"cards/mastery/hkmg36.png", "Aimpoint", "H&K MG36 mastery", "mastery", "tfa_ins2_hk_mg36"}
cardArray[80] = {"cards/mastery/hkmp5.png", "Mode Select", "H&K MP5A5 mastery", "mastery", "tfa_inss2_hk_mp5a5"}
cardArray[81] = {"cards/mastery/imbelia2.png", "Due Process", "Imbel IA2 mastery", "mastery", "tfa_ins2_imbelia2"}
cardArray[82] = {"cards/mastery/izhsawedoff.png", "Halves", "IZH43 Sawed Off master", "mastery", "tfa_ins2_izh43sw"}
cardArray[83] = {"cards/mastery/japaneseararebo.png", "Industry", "Japanese Ararebo master", "mastery", "tfa_ararebo_bf1"}
cardArray[84] = {"cards/mastery/km2000.png", "Flatgrass", "KM-2000 mastery", "mastery", "tfa_km2000_knife"}
cardArray[85] = {"cards/mastery/krissvector.png", "Narkotica", "KRISS Vector mastery", "mastery", "tfa_ins2_krissv"}
cardArray[86] = {"cards/mastery/ksg.png", "Flames", "KSG mastery", "mastery", "tfa_ins2_ksg"}
cardArray[87] = {"cards/mastery/ksvk.png", "Quickscope", "KSVK 12.7 mastery", "mastery", "tfa_blast_ksvk_cqb"}
cardArray[88] = {"cards/mastery/leeenfield.png", "Minecraft", "Lee-Enfield No. 4 master", "mastery", "tfa_doi_enfield"}
cardArray[89] = {"cards/mastery/lewis.png", "Plates", "Lewis mastery", "mastery", "tfa_doilewis"}
cardArray[90] = {"cards/mastery/lr300.png", "Oil Rig", "LR-300 mastery", "mastery", "tfa_ins2_zm_lr300"}
cardArray[91] = {"cards/mastery/m1garand.png", "Underworld", "M1 Garand mastery", "mastery", "tfa_doi_garand"}
cardArray[92] = {"cards/mastery/m14.png", "Bridge", "M14 mastery", "mastery", "tfa_ins2_m14retro"}
cardArray[93] = {"cards/mastery/m3grease.png", "Grease", "M3 Grease Gun mastery", "mastery", "tfa_doim3greasegun"}
cardArray[94] = {"cards/mastery/m9.png", "Full Metal", "M9 mastery", "mastery", "tfa_ins2_m9"}
cardArray[95] = {"cards/mastery/m79.png", "Cool With It", "M79 mastery", "mastery", "tfa_nam_m79"}
cardArray[96] = {"cards/mastery/m1918.png", "Bipod", "M1918 mastery", "mastery", "tfa_doim1918"}
cardArray[97] = {"cards/mastery/m1919.png", "Customs", "M1919 mastery", "mastery", "tfa_doim1919"}
cardArray[98] = {"cards/mastery/mac10.png", "Dev", "Mac 10 mastery", "mastery", "bocw_mac10_alt"}
cardArray[99] = {"cards/mastery/makarov.png", "Leaves", "Makarov mastery", "mastery", "tfa_inss_makarov"}
cardArray[100] = {"cards/mastery/maresleg.png", "High Optic", "Mare's Leg mastery", "mastery", "tfa_tfre_maresleg"}
cardArray[101] = {"cards/mastery/mas38.png", "Galaxy", "Mas 38 mastery", "mastery", "tfa_fml_lefrench_mas38"}
cardArray[102] = {"cards/mastery/mg34.png", "Heavy   ", "MG 34 mastery", "mastery", "tfa_doimg34"}
cardArray[103] = {"cards/mastery/mg42.png", "D-Day", "MG 42 mastery", "mastery", "tfa_doimg42"}
cardArray[104] = {"cards/mastery/minimi.png", "Roof Camper", "Minimi Para mastery", "mastery", "tfa_ins2_minimi"}
cardArray[105] = {"cards/mastery/mk23.png", "Uranium", "MK 23 mastery", "mastery", "tfa_ins2_mk23"}
cardArray[106] = {"cards/mastery/mk18.png", "Wednesday", "MK18 mastery", "mastery", "tfa_fml_inss_mk18"}
cardArray[107] = {"cards/mastery/mk14ebr.png", "Prepared", "Mk. 14 EBR mastery", "mastery", "tfa_ins2_mk14ebr"}
cardArray[108] = {"cards/mastery/model10.png", "Walter", "Model 10 mastery", "mastery", "tfa_ins2_swmodel10"}
cardArray[109] = {"cards/mastery/mosin.png", "Rebirth", "Mosin Nagant mastery", "mastery", "tfa_ins2_mosin_nagant"}
cardArray[110] = {"cards/mastery/mp40.png", "Reflection", "MP 40 mastery", "mastery", "tfa_doimp40"}
cardArray[111] = {"cards/mastery/mp443.png", "Bush", "MP-443 mastery", "mastery", "tfa_ins2_mp443"}
cardArray[112] = {"cards/mastery/mp5k.png", "H&K", "MP5K mastery", "mastery", "tfa_ins2_mp5k"}
cardArray[113] = {"cards/mastery/mp7a1.png", "Oilspill", "MP7A1 mastery", "mastery", "tfa_inss_mp7_new"}
cardArray[114] = {"cards/mastery/mp18.png", "Modern", "MP18 mastery", "mastery", "tfa_ww1_mp18"}
cardArray[115] = {"cards/mastery/mr96.png", "Polish", "MR-96 mastery", "mastery", "tfa_ins2_mr96"}
cardArray[116] = {"cards/mastery/mts225.png", "Slug", "MTs225-12 mastery", "mastery", "tfa_ins2_mc255"}
cardArray[117] = {"cards/mastery/nova.png", "Dark Streets", "Nova mastery", "mastery", "tfa_ins2_nova"}
cardArray[118] = {"cards/mastery/orsist5000.png", "Reserve", "Orsis T-5000 mastery", "mastery", "tfa_ins2_warface_orsis_t5000"}
cardArray[119] = {"cards/mastery/osp18.png", "Irons", "OSP-18 mastery", "mastery", "tfa_l4d2_osp18"}
cardArray[120] = {"cards/mastery/otsgroza.png", "Bullpup", "OTs-14 Groza mastery", "mastery", "tfa_ins2_groza"}
cardArray[121] = {"cards/mastery/otspernach.png", "Speedloader", "OTs-33 Pernach mastery", "mastery", "tfa_ins2_ots_33_pernach"}
cardArray[122] = {"cards/mastery/owenmki.png", "Grid", "Owen Mk.I mastery", "mastery", "tfa_doiowen"}
cardArray[123] = {"cards/mastery/p90.png", "MISSING", "P90 mastery", "mastery", "tfa_fml_p90_tac"}
cardArray[124] = {"cards/mastery/pindad.png", "Labs", "PINDAD SS2-V1 mastery", "mastery", "tfa_blast_pindadss2"}
cardArray[125] = {"cards/mastery/pm9.png", "Akimbo", "PM-9 mastery", "mastery", "tfa_ins2_pm9"}
cardArray[126] = {"cards/mastery/ppsh41.png", "Mephitic", "PPSH-41 mastery", "mastery", "tfa_nam_ppsh41"}
cardArray[127] = {"cards/mastery/ppbizon.png", "Rainbow", "PP-Bizon mastery", "mastery", "tfa_fas2_ppbizon"}
cardArray[128] = {"cards/mastery/pzb39.png", "Exotic", "PzB 39 mastery", "mastery", "tfa_ww2_pbz39"}
cardArray[129] = {"cards/mastery/qbz97.png", "Hideout", "QBZ-97 mastery", "mastery", "tfa_ins2_norinco_qbz97"}
cardArray[130] = {"cards/mastery/qsz92.png", "yippee", "QSZ-92 mastery", "mastery", "tfa_ins2_qsz92"}
cardArray[131] = {"cards/mastery/remingtonm870.png", "Mastery", "Remington M870 master", "mastery", "tfa_ins2_remington_m870"}
cardArray[132] = {"cards/mastery/remingtonmsr.png", "Lightshow", "Remington MSR mastery", "mastery", "tfa_ins2_pd2_remington_msr"}
cardArray[133] = {"cards/mastery/rfb.png", "Extraction", "RFB mastery", "mastery", "tfa_ins2_rfb"}
cardArray[134] = {"cards/mastery/rk62.png", "Highway", "RK62 mastery", "mastery", "tfa_fml_rk62"}
cardArray[135] = {"cards/mastery/rpg7.png", "Damascus", "RPG-7 mastery", "mastery", "tfa_ins2_rpg7_scoped"}
cardArray[136] = {"cards/mastery/rpk74m.png", "Elcan", "RPK-74M mastery", "mastery", "tfa_ins2_rpk_74m"}
cardArray[137] = {"cards/mastery/sa80.png", "Groves", "SA80 mastery", "mastery", "tfa_ins2_l85a2"}
cardArray[138] = {"cards/mastery/scarh.png", "Tilted", "SCAR-H mastery", "mastery", "tfa_ins2_scar_h_ssr"}
cardArray[139] = {"cards/mastery/scorpionevo.png", "Raid", "Scorpion Evo mastery", "mastery", "tfa_ins2_sc_evo"}
cardArray[140] = {"cards/mastery/sigp226.png", "Sauer", "SIG P226 mastery", "mastery", "tfa_new_p226"}
cardArray[141] = {"cards/mastery/sks.png", "Scav", "SKS mastery", "mastery", "tfa_ins2_sks"}
cardArray[142] = {"cards/mastery/spas.png", "Twelve Gauge", "SPAS-12 mastery", "mastery", "tfa_ins2_spas12"}
cardArray[143] = {"cards/mastery/spectrem4.png", "Mall", "Spectre M4 mastery", "mastery", "tfa_ins2_spectre"}
cardArray[144] = {"cards/mastery/spikex15.png", "Prototype", "Spike X15 mastery", "mastery", "tfa_ins2_saiga_spike"}
cardArray[145] = {"cards/mastery/sr2m.png", "Blueprint", "SR-2M Veresk mastery", "mastery", "tfa_ins2_sr2m_veresk"}
cardArray[146] = {"cards/mastery/sten.png", "Lens Flare", "Sten Mk.II mastery", "mastery", "tfa_doisten"}
cardArray[147] = {"cards/mastery/stevens620.png", "Mod", "Stevens 620 mastery", "mastery", "tfa_nam_stevens620"}
cardArray[148] = {"cards/mastery/steyraug.png", "Cute", "Steyr AUG mastery", "mastery", "tfa_inss_aug"}
cardArray[149] = {"cards/mastery/stg44.png", "Wood", "StG44 mastery", "mastery", "tfa_doistg44"}
cardArray[150] = {"cards/mastery/sv98.png", "Vertigo", "SV-98 mastery", "mastery", "tfa_ins2_sv98"}
cardArray[151] = {"cards/mastery/sw500.png", "Companion", "S&W 500 mastery", "mastery", "tfa_ins2_s&w_500"}
cardArray[152] = {"cards/mastery/tanto.png", "Shipment", "Tanto mastery", "mastery", "tfa_japanese_exclusive_tanto"}
cardArray[153] = {"cards/mastery/tariq.png", "Dog", "Tariq mastery", "mastery", "tfa_ins_sandstorm_tariq"}
cardArray[154] = {"cards/mastery/thompsonm1928.png", "Typewritter", "Thompson M1928 master", "mastery", "tfa_doithompsonm1928"}
cardArray[155] = {"cards/mastery/thompson.png", "Suicide", "Thompson M1A1 master", "mastery", "tfa_doithompsonm1a1"}
cardArray[156] = {"cards/mastery/type81.png", "Leauge", "Type 81 mastery", "mastery", "tfa_ins2_type81"}
cardArray[157] = {"cards/mastery/typhoonf12.png", "Ultrakill", "Typhoon F12 mastery", "mastery", "tfa_ins2_typhoon12"}
cardArray[158] = {"cards/mastery/ump45.png", "Nuketown", "UMP .45 mastery", "mastery", "tfa_ins2_ump45"}
cardArray[159] = {"cards/mastery/ump9.png", "Waterfall", "UMP9 mastery", "mastery", "tfa_ins2_ump9"}
cardArray[160] = {"cards/mastery/uzi.png", "Alpha", "Uzi mastery", "mastery", "tfa_ins2_imi_uzi"}
cardArray[161] = {"cards/mastery/uzkbr99.png", "Rouge", "UZK-BR99 mastery", "mastery", "tfa_ins2_br99"}
cardArray[162] = {"cards/mastery/vhsd2.png", "Liminal Pool", "VHS-D2 mastery", "mastery", "tfa_ins2_vhsd2"}
cardArray[163] = {"cards/mastery/waltherp99.png", "Advisory", "Walther P99 mastery", "mastery", "tfa_ins2_walther_p99"}
cardArray[164] = {"cards/mastery/xm8.png", "Ragdoll", "XM8 mastery", "mastery", "tfa_ins2_xm8"}

--Leveling Cards
cardArray[165] = {"cards/leveling/10.png", "Mist", "shitty pattern", "level", 10}
cardArray[166] = {"cards/leveling/20.png", "Shift", "shitty pattern #2", "level", 20}
cardArray[167] = {"cards/leveling/30.png", "Powerhouse", "out of stock.", "level", 30}
cardArray[168] = {"cards/leveling/40.png", "Drainer", "@suomij", "level", 40}
cardArray[169] = {"cards/leveling/50.png", "Kitty", "ca t.", "level", 50}
cardArray[170] = {"cards/leveling/60.png", "Kill Yourself", "loser!", "level", 60}
cardArray[171] = {"cards/leveling/70.png", "Arctic", "so pretty.", "level", 70}
cardArray[172] = {"cards/leveling/80.png", "Shark", "why is their a negev", "level", 80}
cardArray[173] = {"cards/leveling/90.png", "Boss Up", "@walter", "level", 90}
cardArray[174] = {"cards/leveling/100.png", "Rig", "best map!", "level", 100}
cardArray[175] = {"cards/leveling/110.png", "Station", "worst map!", "level", 110}
cardArray[176] = {"cards/leveling/120.png", "Ray", "Gor.", "level", 120}
cardArray[177] = {"cards/leveling/130.png", "Dunes", "I LOVE CAPTAINBEAR", "level", 130}
cardArray[178] = {"cards/leveling/140.png", "Pyro", "I LOVE TEARDOWN", "level", 140}
cardArray[179] = {"cards/leveling/150.png", "Table", "table football <3", "level", 150}
cardArray[180] = {"cards/leveling/160.png", "Critters", "meep meep meep meep", "level", 160}
cardArray[181] = {"cards/leveling/170.png", "Sweat", "gg ez", "level", 170}
cardArray[182] = {"cards/leveling/180.png", "Walls", "true statement", "level", 180}
cardArray[183] = {"cards/leveling/190.png", "Dinner", "literally me", "level", 190}
cardArray[184] = {"cards/leveling/200.png", "Thunder", "KILL YOURSELF!", "level", 200}
cardArray[185] = {"cards/leveling/210.png", "David", "...", "level", 210}
cardArray[186] = {"cards/leveling/220.png", "Ohio", "USA <3", "level", 220}
cardArray[187] = {"cards/leveling/230.png", "Eyepatch", "so awesome", "level", 230}
cardArray[188] = {"cards/leveling/240.png", "Pro", "level 3 gulag enjoyer", "level", 240}
cardArray[189] = {"cards/leveling/250.png", "Stare", "so menacing", "level", 250}
cardArray[190] = {"cards/leveling/260.png", "Death", "Factory my beloved", "level", 260}
cardArray[191] = {"cards/leveling/270.png", "Monstor", "narkotica out!", "level", 270}
cardArray[192] = {"cards/leveling/280.png", "Meep", "hi!", "level", 280}
cardArray[193] = {"cards/leveling/290.png", "Superpowers", "bitch!", "level", 290}
cardArray[194] = {"cards/leveling/300.png", "Shocked", "300 levels of pain.", "level", 300}

--Map Array Formatting (Map ID, Map Name, Map Description, Map Image)
mapArray = {}
mapArray[1] = {"tm_arctic", "Arctic", "Snowy close quarters combat.", "maps/thumb/tm_arctic.png"}
mapArray[2] = {"tm_bridge", "Bridge", "Speeding cars act as hazards during your fights.", "maps/thumb/tm_bridge.png"}
mapArray[3] = {"tm_cradle", "Cradle", "Wide and open with many grapple spots.", "maps/thumb/tm_cradle.png"}
mapArray[4] = {"tm_darkstreets", "Dark Streets", "Limited movement and narrow chokepoints.", "maps/thumb/tm_darkstreets.png"}
mapArray[5] = {"tm_firingrange", "Firing Range", "Free weapon spawning, force disabled progression.", "maps/thumb/tm_firingrange.png"}
mapArray[6] = {"tm_grid", "Grid", "Open, vibrant rooms connected via maze-like hallways.", "maps/thumb/tm_grid.png"}
mapArray[7] = {"tm_liminal_pool", "Liminal Pool", "Prone to sniping, many movemeny opportunities", "maps/thumb/tm_liminal_pool.png"}
mapArray[8] = {"tm_mall", "Mall", "Spacious shopping center with long sightlines.", "maps/thumb/tm_mall.png"}
mapArray[9] = {"tm_mephitic", "Mephitic", "Dark facility with a continuous acid flood.", "maps/thumb/tm_mephitic.png"}
mapArray[10] = {"tm_nuketown", "Nuketown", "Cult classic, predictible spawns and engagements.", "maps/thumb/tm_nuketown.png"}
mapArray[11] = {"tm_rig", "Rig", "Dark and rainy oil rig.", "maps/thumb/tm_rig.png"}
mapArray[12] = {"tm_shipment", "Shipment", "Extremely small and chaotic.", "maps/thumb/tm_shipment.png"}
mapArray[13] = {"tm_station", "Station", "A vertical and open battleground.", "maps/thumb/tm_station.png"}

availableMaps = {"tm_darkstreets", "tm_grid", "tm_liminal_pool", "tm_mephitic", "tm_nuketown", "tm_cradle", "tm_mall", "tm_bridge", "tm_shipment", "tm_station", "tm_rig", "tm_arctic", "skip"} -- "skip" will have the map vote end in a continue if it ties with another map, requiring a majority vote for a new map.

--Creating a leveling array, this removes the consistency of the leveling, using developer set XP requierments per level instead of a formula. Is this time consuming? Yes, very much, but it feels more polished IMO.
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

--Hint Array, no use as of now.
hintArray = {}
hintArray[1] = {"Crouching drastically increases your accuracy and recoil control."}
hintArray[2] = {"Each weapon has its own distinct recoil pattern to master."}
hintArray[3] = {"Your grappling hook cooldown refreshes on each kill."}
hintArray[4] = {"Shooting the torso and/or head will guarintee good damage per shot."}
hintArray[5] = {"You can sprint and/or slide in any direction, not just forwards."}
hintArray[6] = {"Don't stand still, potshotters will have an easy time killing you."}
hintArray[7] = {"All bullet based projectiles are hitscan, there is no bullet velocity/drop to account for."}
hintArray[8] = {"The vehicles can be mounted and surfed on while playing the Bridge map."}
hintArray[9] = {"Bunny hopping will help perserve velocity after landing from a grapple/slide."}
hintArray[10] = {"Explosives hurt, don't aim downwards if you want to stay alive."}
hintArray[11] = {"Some snipers and hand cannons can one shot to the torso."}
hintArray[12] = {"Attachments save throughout play sessions, tweak your guns once and you are done."}
hintArray[13] = {"All melee weapons have a left and right click attack, learn how effective each are."}
hintArray[14] = {"Wall jumping constantly allows for continuous climbing of said wall."}
hintArray[15] = {"Wall running through a chokepoint can catch opponents off guard."}
hintArray[16] = {"Combine wall running and jumping for extremely unpredictable movement."}
hintArray[17] = {"Certain playermodels may shine or stand out in dark enviroments."}
hintArray[18] = {"Other players can see your flashlight, be cautious."}
hintArray[19] = {"Hip fire is an effective strategy while on the move."}
hintArray[20] = {"There is no scope glint (as of now.) Hardscope all you want."}
hintArray[21] = {"There are over 125+ weapons, try to get consistent with many different loadouts."}
hintArray[22] = {"Running any optic lowers your weapons ADS speed."}
hintArray[23] = {"Accolades award good amounts of score and XP."}
hintArray[24] = {"Chaining multiple accolades together can give a big score/XP boost."}
hintArray[25] = {"The map vote is not mandatory, not voting for a map will auto vote for you."}
hintArray[26] = {"Sliding provides the same accuracy and recoil benefits as crouching."}
hintArray[27] = {"Jumping or being in mid air gives your weapons less accuracy."}
hintArray[28] = {"The grappling hook can easily be used to start favorable engagments."}
hintArray[29] = {"Almost everything you do in game is tracked, check out the stats page to compare yourself with others."}
hintArray[30] = {"Players can not shoot most weapons while submerged in water, use this to your advantage."}
hintArray[31] = {"Explosive barrels can be used as a funny distraction."}
hintArray[32] = {"Frag ammunition deafens hit players for a few seconds, and slows down their movement speed."}
hintArray[33] = {"G.I.B ammunition is a good choice if you want to slow down hit opponents."}
hintArray[34] = {"Air strafing is extremely useful movement tech, try to incorperate it into your playstyle."}
hintArray[35] = {"All melee weapons can be thrown with the reload key."}
hintArray[36] = {"You can cycle through firing modes by using your Interact + Reload keys."}
hintArray[37] = {"Underbarrel grenade launchers can be used by pressing Interact + Left Click."}
hintArray[38] = {"Crouching completely eliminates your footstep audio for other players. Embrace the sneaky."}
hintArray[39] = {"Try personalizing yourself in the customize menus."}
hintArray[40] = {"Slug ammunition turns your traditional shotgun into a marksman rifle."}
hintArray[41] = {"Magnum ammunition pairs extremely well with low damage weapons."}
hintArray[42] = {"Voice chat is proximity based, do with this information as you see fit."}
hintArray[43] = {"Health regeneration begins after not taking damage for 3.5 seconds."}
hintArray[44] = {"Bullets may not align with your crosshair or sight due to recoil."}
hintArray[45] = {"To win a match, a player must have more score than the rest of the competing players."}
hintArray[46] = {"Switching to your secondary is 'usually' faster than reloading."}
hintArray[47] = {"Follow CaptainBear on the Steam Workshop!"}
hintArray[48] = {"Match Ammunition is a good choice for low accuracy weapons."}
hintArray[49] = {"You can climb onto the houses while playing on the Nuketown map."}
hintArray[50] = {"Be vigilant with the acid flood while playing on the Mephitic map."}
hintArray[51] = {"Suppressors might make your gun sound badass, but it will also lower your damage."}

--ConVars for the gamemode will be under this comment, this is used to set up default client settings, and server side stuff.
--Server Side
if SERVER then
    --Disabling NoClip/Tinnitus
    RunConsoleCommand("sbox_noclip", "0")

    --Proximity Voice Chat
    RunConsoleCommand("sv_maxVoiceAudible", "750")

    --Dynamic Height
    RunConsoleCommand("sv_ec2_dynamicheight", "0")
    RunConsoleCommand("sv_ec2_dynamicheight_min", "42")
    RunConsoleCommand("sv_ec2_dynamicheight_max", "64")

    --Sliding
    RunConsoleCommand("sv_qslide_duration", "1")
    RunConsoleCommand("sv_qslide_speedmult", "1.55")

    --Player Acceleration
    RunConsoleCommand("sv_airaccelerate", "1000")

    --Server Side TFA Configuration
    RunConsoleCommand("sv_tfa_allow_dryfire", "1")
    RunConsoleCommand("sv_tfa_ammo_detonation", "0")
    RunConsoleCommand("sv_tfa_ammo_detonation_chain", "0")
    RunConsoleCommand("sv_tfa_ammo_detonation_mode", "0")
    RunConsoleCommand("sv_tfa_arrow_lifetime", "30")
    RunConsoleCommand("sv_tfa_attachments_alphabetical", "0")
    RunConsoleCommand("sv_tfa_attachments_enabled", "1")
    RunConsoleCommand("sv_tfa_backcompat_patchswepthink", "0")
    RunConsoleCommand("sv_tfa_ballistics_bullet_damping_air", "1.00")
    RunConsoleCommand("sv_tfa_ballistics_bullet_damping_water", "3.00")
    RunConsoleCommand("sv_tfa_ballistics_bullet_life", "10.00")
    RunConsoleCommand("sv_tfa_ballistics_bullet_velocity", "1.00")
    RunConsoleCommand("sv_tfa_ballistics_custom_gravity", "0")
    RunConsoleCommand("sv_tfa_ballistics_custom_gravity_value", "0")
    RunConsoleCommand("sv_tfa_ballistics_enabled", "0")
    RunConsoleCommand("sv_tfa_ballistics_mindist", "-1")
    RunConsoleCommand("sv_tfa_ballistics_substeps", "1")
    RunConsoleCommand("sv_tfa_bullet_doordestruction", "1")
    RunConsoleCommand("sv_tfa_bullet_doordestruction_keep", "1")
    RunConsoleCommand("sv_tfa_bullet_penetration", "1")
    RunConsoleCommand("sv_tfa_bullet_penetration_power_mul", "1.00")
    RunConsoleCommand("sv_tfa_bullet_randomseed", "0")
    RunConsoleCommand("sv_tfa_bullet_ricochet", "0")
    RunConsoleCommand("sv_tfa_cmenu", "1")
    RunConsoleCommand("sv_tfa_crosshair_showplayer", "0")
    RunConsoleCommand("sv_tfa_crosshair_showplayerteam", "0")
    RunConsoleCommand("sv_tfa_damage_mult_max", "1.05")
    RunConsoleCommand("sv_tfa_damage_mult_min", "0.95")
    RunConsoleCommand("sv_tfa_damage_multiplier", "1.05")
    RunConsoleCommand("sv_tfa_damage_multiplier_npc", "1.05")
    RunConsoleCommand("sv_tfa_default_clip", "1000")
    RunConsoleCommand("sv_tfa_door_respawn", "-1")
    RunConsoleCommand("sv_tfa_dynamicaccuracy", "1")
    RunConsoleCommand("sv_tfa_fixed_crosshair", "1")
    RunConsoleCommand("sv_tfa_force_multiplier", "0")
    RunConsoleCommand("sv_tfa_fx_penetration_decal", "0")
    RunConsoleCommand("sv_tfa_holdtype_dynamic", "1")
    RunConsoleCommand("sv_tfa_jamming", "0")
    RunConsoleCommand("sv_tfa_melee_doordestruction", "1")
    RunConsoleCommand("sv_tfa_melee_blocking_stun_enabled", "1")
    RunConsoleCommand("sv_tfa_melee_blocking_stun_time", "0.65")
    RunConsoleCommand("sv_tfa_melee_blocking_anglemult", "1")
    RunConsoleCommand("sv_tfa_melee_blocking_deflection", "1")
    RunConsoleCommand("sv_tfa_melee_blocking_timed", "1")
    RunConsoleCommand("sv_tfa_melee_damage_ply", "0.65")
    RunConsoleCommand("sv_tfa_nearlyempty", "1")
    RunConsoleCommand("sv_tfa_npc_burst", "0")
    RunConsoleCommand("sv_tfa_npc_randomize_atts", "0")
    RunConsoleCommand("sv_tfa_penetration_hardlimit", "100")
    RunConsoleCommand("sv_tfa_penetration_hitmarker", "1")
    RunConsoleCommand("sv_tfa_range_modifier", "0.80")
    RunConsoleCommand("sv_tfa_recoil_legacy", "0")
    RunConsoleCommand("sv_tfa_recoil_mul_p", "0.9")
    RunConsoleCommand("sv_tfa_recoil_mul_p_npc", "1")
    RunConsoleCommand("sv_tfa_recoil_mul_y", "0.9")
    RunConsoleCommand("sv_tfa_recoil_mul_y_npc", "1")
    RunConsoleCommand("sv_tfa_recoil_viewpunch_mul", "1.65")
    RunConsoleCommand("sv_tfa_scope_gun_speed_scale", "0")
    RunConsoleCommand("sv_tfa_soundscale", "1")
    RunConsoleCommand("sv_tfa_spread_legacy", "0")
    RunConsoleCommand("sv_tfa_spread_multiplier", "0.8")
    RunConsoleCommand("sv_tfa_sprint_enabled", "1")
    RunConsoleCommand("sv_tfa_unique_slots", "1")
    RunConsoleCommand("sv_tfa_weapon_strip", "0")
    RunConsoleCommand("sv_tfa_weapon_weight", "1")
    RunConsoleCommand("sv_tfa_worldmodel_culldistance", "30")

    --Flashlight
    RunConsoleCommand("tpf_sv_light_forward_offset", "15")
    RunConsoleCommand("tpf_sv_max_bright", "255")
    RunConsoleCommand("tpf_sv_max_farz", "750")
    RunConsoleCommand("tpf_sv_max_fov", "75")

    --Grappling Hook
    if GetConVar("tm_developermode"):GetInt() == 1 then
        RunConsoleCommand("frest_Cooldowng", "0")
    else
        RunConsoleCommand("frest_Cooldowng", "18")
    end
    RunConsoleCommand("frest_range", "850")
end

--Client Side
if CLIENT then
    --Client Side TFA Configuration
    RunConsoleCommand("cl_tfa_3dscope", "1")
    RunConsoleCommand("cl_tfa_3dscope_overlay", "0")
    RunConsoleCommand("cl_tfa_3dscope_quality", "0")
    RunConsoleCommand("cl_tfa_attachments_persist_enabled", "1")
    RunConsoleCommand("cl_tfa_ballistics_fx_bullet", "0")
    RunConsoleCommand("cl_tfa_ballistics_fx_tracers_adv", "1")
    RunConsoleCommand("cl_tfa_ballistics_fx_tracers_mp", "0")
    RunConsoleCommand("cl_tfa_ballistics_fx_tracers_style", "2")
    RunConsoleCommand("cl_tfa_ballistics_mp", "1")
    RunConsoleCommand("cl_tfa_debug_animations", "0")
    RunConsoleCommand("cl_tfa_debug_cache", "0")
    RunConsoleCommand("cl_tfa_debug_crosshair", "0")
    RunConsoleCommand("cl_tfa_debug_rt", "0")
    RunConsoleCommand("cl_tfa_fx_ads_dof_hd", "0")
    RunConsoleCommand("cl_tfa_fx_ejectionsmoke", "0")
    RunConsoleCommand("cl_tfa_fx_ejectionlife", "0")
    RunConsoleCommand("cl_tfa_fx_gasblur", "0")
    RunConsoleCommand("cl_tfa_fx_impact_enabled", "0")
    RunConsoleCommand("cl_tfa_fx_impact_ricochet_enabled", "0")
    RunConsoleCommand("cl_tfa_fx_impact_ricochet_sparklife", "0")
    RunConsoleCommand("cl_tfa_fx_impact_ricochet_sparks", "0")
    RunConsoleCommand("cl_tfa_fx_muzzleflashsmoke", "0")
    RunConsoleCommand("cl_tfa_fx_muzzlesmoke", "0")
    RunConsoleCommand("cl_tfa_fx_muzzlesmoke_limited", "1")
    RunConsoleCommand("cl_tfa_fx_rtscopeblur_intensity", "0.01")
    RunConsoleCommand("cl_tfa_fx_rtscopeblur_mode", "0")
    RunConsoleCommand("cl_tfa_fx_rtscopeblur_passes", "1")
    RunConsoleCommand("cl_tfa_gunbob_custom", "1")
    RunConsoleCommand("cl_tfa_gunbob_invertsway", "1")
    RunConsoleCommand("cl_tfa_hud_ammodata_fadein", "0.20")
    RunConsoleCommand("cl_tfa_hud_crosshair_color_enemy_b", "0")
    RunConsoleCommand("cl_tfa_hud_crosshair_color_enemy_g", "0")
    RunConsoleCommand("cl_tfa_hud_crosshair_color_enemy_r", "255")
    RunConsoleCommand("cl_tfa_hud_crosshair_color_friendly_b", "0")
    RunConsoleCommand("cl_tfa_hud_crosshair_color_friendly_g", "255")
    RunConsoleCommand("cl_tfa_hud_crosshair_color_friendly_r", "0")
    RunConsoleCommand("cl_tfa_hud_crosshair_color_team", "0")
    RunConsoleCommand("cl_tfa_hud_crosshair_length_use_pixels", "0")
    RunConsoleCommand("cl_tfa_hud_enabled", "0")
    RunConsoleCommand("cl_tfa_hud_hangtime", "1")
    RunConsoleCommand("cl_tfa_hud_hitmarker_3d_shotguns", "1")
    RunConsoleCommand("cl_tfa_hud_hitmarker_fadetime", "0.04")
    RunConsoleCommand("cl_tfa_hud_hitmarker_solidtime", "0.10")
    RunConsoleCommand("cl_tfa_inspect_hide", "0")
    RunConsoleCommand("cl_tfa_inspect_hide_hud", "0")
    RunConsoleCommand("cl_tfa_inspect_hide_in_screenshots", "0")
    RunConsoleCommand("cl_tfa_inspect_newbars", "1")
    RunConsoleCommand("cl_tfa_inspect_spreadinmoa", "1")
    RunConsoleCommand("cl_tfa_inspection_bokeh_radius", "0.010")
    RunConsoleCommand("cl_tfa_ironsights_resight", "1")
    RunConsoleCommand("cl_tfa_ironsights_responsive", "0")
    RunConsoleCommand("cl_tfa_ironsights_responsive_timer", "0.1750")
    RunConsoleCommand("cl_tfa_laser_color_b", "0")
    RunConsoleCommand("cl_tfa_laser_color_g", "0")
    RunConsoleCommand("cl_tfa_laser_color_r", "255")
    RunConsoleCommand("cl_tfa_laser_trails", "1")
    RunConsoleCommand("cl_tfa_legacy_shells", "0")
    RunConsoleCommand("cl_tfa_scope_sensitivity_3d", "2")
    RunConsoleCommand("cl_tfa_scope_sensitivity_autoscale", "1")
    RunConsoleCommand("cl_tfa_viewbob_animated", "1")
    RunConsoleCommand("cl_tfa_viewbob_intensity", "1.00")
    RunConsoleCommand("cl_tfa_viewmodel_flip", "0")
    RunConsoleCommand("cl_tfa_viewmodel_nearwall", "1")
    RunConsoleCommand("cl_tfa_viewmodel_offset_fov", "0")
    RunConsoleCommand("cl_tfa_viewmodel_offset_x", "1.00")
    RunConsoleCommand("cl_tfa_viewmodel_offset_y", "1")
    RunConsoleCommand("cl_tfa_viewmodel_offset_z", "0")
    RunConsoleCommand("cl_tfa_viewmodel_vp_enabled", "1")
    RunConsoleCommand("cl_tfa_viewmodel_vp_max_vertical", "1")
    RunConsoleCommand("cl_tfa_viewmodel_vp_max_vertical_is", "1")
    RunConsoleCommand("cl_tfa_viewmodel_vp_pitch", "1")
    RunConsoleCommand("cl_tfa_viewmodel_vp_pitch_is", "1")
    RunConsoleCommand("cl_tfa_viewmodel_vp_vertical", "1")
    RunConsoleCommand("cl_tfa_viewmodel_vp_vertical_is", "1")
    RunConsoleCommand("cl_tfa_viewmodel_vp_yaw", "1")
    RunConsoleCommand("cl_tfa_viewmodel_vp_yaw_is", "1")

    --ADS FX
    RunConsoleCommand("cl_aimingfx_ca_enabled", "0")
    RunConsoleCommand("cl_aimingfx_vignette_enabled", "1")
    RunConsoleCommand("cl_aimingfx_vignette_intensity_initially_multiplier", "0.75")
    RunConsoleCommand("cl_aimingfx_vignette_intensity_sighted_multiplier", "0.60")

    --Sliding
    RunConsoleCommand("cl_qslide_view", "0")

    --Voice Chat animations
    RunConsoleCommand("cl_vmanip_voicechat", "0")

    --Flashlight
    RunConsoleCommand("tpf_should_load_defaults", "0")
    RunConsoleCommand("tpf_cl_bright", "255")
    RunConsoleCommand("tpf_cl_farz", "750")
    RunConsoleCommand("tpf_cl_fov", "75")
    RunConsoleCommand("tpf_cl_shadows", "0")
end