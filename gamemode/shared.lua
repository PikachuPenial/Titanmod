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
if !ConVarExists("tm_healthanchor") then CreateConVar("tm_healthanchor", "0", FCVAR_ARCHIVE, "Changes the corner of the screen that holds your health bar",0,2) end
if !ConVarExists("tm_ammostyle") then CreateConVar("tm_ammostyle", "0", FCVAR_ARCHIVE, "Switch between a numeric value and a bar to display your weapons ammo",0,3) end
if !ConVarExists("tm_showspeed") then CreateConVar("tm_showspeed", "0", FCVAR_ARCHIVE, "Enables a speed indicator at the top of your screen",0,1) end
if !ConVarExists("tm_hitsounds") then CreateConVar("tm_hitsounds", "0", FCVAR_ARCHIVE, "Enable or disable the hitsounds",0,1) end
if !ConVarExists("tm_menumusic") then CreateConVar("tm_menumusic", "1", FCVAR_ARCHIVE, "Enable or disable the Main Menu music",0,1) end
if !ConVarExists("tm_gameendmusic") then CreateConVar("tm_gameendmusic", "1", FCVAR_ARCHIVE, "Enable or disable the Game End music",0,1) end
if !ConVarExists("tm_menumusicvolume") then CreateConVar("tm_menumusicvolume", "0.90", FCVAR_ARCHIVE, "Increase or lower the volume of the Main Menu music",0,1) end
if !ConVarExists("tm_gameendmusicvolume") then CreateConVar("tm_gameendmusicvolume", "0.90", FCVAR_ARCHIVE, "Increase or lower the volume of the Game End music",0,1) end
if !ConVarExists("tm_communitymusic") then CreateConVar("tm_communitymusic", "0", FCVAR_ARCHIVE, "Enable or disable community requested Main Menu music",0,1) end
if !ConVarExists("tm_enableaccolades") then CreateConVar("tm_enableaccolades", "1", FCVAR_ARCHIVE, "Enable or disable the accolade popup in the kill UI",0,1) end
if !ConVarExists("tm_reloadhints") then CreateConVar("tm_reloadhints", "1", FCVAR_ARCHIVE, "Enable or disable the reload text when out of ammo",0,1) end
if !ConVarExists("tm_killuianchor") then CreateConVar("tm_killuianchor", "0", FCVAR_ARCHIVE, "Switch between anchoring the kill UI at the top and the bottom of the screen",0,1) end
if !ConVarExists("tm_deathuianchor") then CreateConVar("tm_deathuianchor", "0", FCVAR_ARCHIVE, "Switch between anchoring the death UI at the top and the bottom of the screen",0,1) end
if !ConVarExists("tm_cardpfpoffset") then CreateConVar("tm_cardpfpoffset", "0", FCVAR_ARCHIVE, "Moves the Profile Picture of the player around their playercard.",0,160) end

--Disabling footsteps if a player is crouched.
hook.Add("PlayerFootstep", "MuteCrouchFootsteps", function(ply, pos, foot, sound, volume, ktoslishet)
	if !ply:Crouching() then return end
	return true
end)

function GM:Initialize()
    --Weapon Array Formatting (Item Name/ID, Print Name)
	local weaponArray = {}
    weaponArray[1] = {"tfa_ins2_aa12", "AA-12"}
    weaponArray[2] = {"tfa_ins2_acrc", "ACR-C"}
    weaponArray[3] = {"tfa_ins2_aek971", "AEK-971"}
    weaponArray[4] = {"tfa_ins2_akms", "AKMS"}
    weaponArray[5] = {"tfa_inss_aks74u", "AKS-74U"}
    weaponArray[6] = {"tfa_ismc_ak12_rpk", "AK-12 (RPK)"}
    weaponArray[7] = {"tfa_ins2_ak400", "AK-400"}
    weaponArray[8] = {"tfa_ins2_warface_amp_dsr1", "AMP DSR-1"}
    weaponArray[9] = {"tfa_ins2_abakan", "AN-94"}
    weaponArray[10] = {"tfa_ins2_cw_ar15", "AR-15"}
    weaponArray[11] = {"tfa_ins2_ar57", "AR-57"}
    weaponArray[12] = {"tfa_at_shak_12", "ASh-12"}
    weaponArray[13] = {"tfa_inss_asval", "AS-VAL"}
    weaponArray[14] = {"tfa_ins2_warface_awm", "AWM"}
    weaponArray[15] = {"tfa_ins2_warface_ax308", "AX-308"}
    weaponArray[16] = {"tfa_ins2_barrett_m98_bravo", "Barrett M98B"}
    weaponArray[17] = {"tfa_ins2_mx4", "Beretta Mx4 Storm"}
    weaponArray[18] = {"tfa_doibren", "Bren"}
    weaponArray[19] = {"tfa_ins2_warface_bt_mp9", "B&T MP9"}
    weaponArray[20] = {"tfa_ins2_warface_cheytac_m200", "CheyTac M200"}
    weaponArray[21] = {"tfa_new_m1911", "Colt M1911"}
    weaponArray[22] = {"tfa_ins2_colt_m45", "Colt M45A1"}
    weaponArray[23] = {"tfa_ins2_cz75", "CZ 75 B"}
    weaponArray[24] = {"tfa_ins2_cz805", "CZ 805 BREN"}
    weaponArray[25] = {"tfa_ins2_ddm4v5", "DDM4V5"}
    weaponArray[26] = {"tfa_ins2_deagle", "Desert Eagle"}
    weaponArray[27] = {"tfa_ins2_famas", "Famas F1"}
    weaponArray[28] = {"tfa_blast_lynx_msbsb", "FB MSBS-B"}
    weaponArray[29] = {"tfa_doifg42", "FG 42"}
    weaponArray[30] = {"tfa_ins2_fiveseven_eft", "Fiveseven"}
    weaponArray[31] = {"tfa_ins2_fn_fal", "FN FAL"}
    weaponArray[32] = {"tfa_ins2_fnp45", "FNP-45"}
    weaponArray[33] = {"tfa_new_inss_galil", "Galil"}
    weaponArray[34] = {"tfa_new_glock17", "Glock 17"}
    weaponArray[35] = {"fres_grapple", "Grappling Hook"}
    weaponArray[36] = {"tfa_ins2_gsh18", "GSH-18"}
    weaponArray[37] = {"tfa_ins2_cq300", "Honey Badger"}
    weaponArray[38] = {"tfa_howa_type_64", "Howa Type 64"}
    weaponArray[39] = {"tfa_ins2_hk_mg36", "H&K MG36"}
    weaponArray[40] = {"tfa_inss2_hk_mp5a5", "H&K MP5A5"}
    weaponArray[41] = {"tfa_ins2_imbelia2", "Imbel IA2"}
    weaponArray[42] = {"tfa_ins2_izh43sw", "IZH-43 Sawed Off"}
    weaponArray[43] = {"tfa_ararebo_bf1", "Japanese Ararebo"}
    weaponArray[44] = {"tfa_km2000_knife", "KM-2000"}
    weaponArray[45] = {"tfa_ins2_krissv", "KRISS Vector"}
    weaponArray[46] = {"tfa_ins2_ksg", "KSG"}
    weaponArray[47] = {"tfa_blast_ksvk_cqb", "KSVK 12.7"}
    weaponArray[48] = {"tfa_doi_enfield", "Lee-Enfield No. 4"}
    weaponArray[49] = {"tfa_doilewis", "Lewis"}
    weaponArray[50] = {"tfa_doi_garand", "M1 Garand"}
    weaponArray[51] = {"tfa_doim3greasegun", "M3 Grease Gun"}
    weaponArray[52] = {"tfa_ins2_m9", "M9"}
    weaponArray[53] = {"tfa_ins2_m14retro", "M14"}
    weaponArray[54] = {"tfa_nam_m79", "M79"}
    weaponArray[55] = {"tfa_doim1918", "M1918"}
    weaponArray[56] = {"tfa_doim1919", "M1919"}
    weaponArray[57] = {"bocw_mac10_alt", "Mac 10"}
    weaponArray[58] = {"tfa_inss_makarov", "Makarov"}
    weaponArray[59] = {"tfa_fml_lefrench_mas38", "Mas 38"}
    weaponArray[60] = {"tfa_doimg34", "MG 34"}
    weaponArray[61] = {"tfa_doimg42", "MG 42"}
    weaponArray[62] = {"tfa_ins2_minimi", "Minimi Para"}
    weaponArray[63] = {"tfa_ins2_mk23", "MK 23"}
    weaponArray[64] = {"tfa_fml_inss_mk18", "MK18"}
    weaponArray[65] = {"tfa_ins2_mk14ebr", "Mk. 14 EBR"}
    weaponArray[66] = {"tfa_ins2_swmodel10", "Model 10"}
    weaponArray[67] = {"tfa_ins2_mosin_nagant", "Mosin Nagant"}
    weaponArray[68] = {"tfa_doimp40", "MP 40"}
    weaponArray[69] = {"tfa_ins2_mp5k", "MP5K"}
    weaponArray[70] = {"tfa_inss_mp7_new", "MP7A1"}
    weaponArray[71] = {"tfa_ww1_mp18", "MP18"}
    weaponArray[72] = {"tfa_ins2_mr96", "MR-96"}
    weaponArray[73] = {"tfa_ins2_mc255", "MTs225-12"}
    weaponArray[74] = {"tfa_ins2_nova", "Nova"}
    weaponArray[75] = {"tfa_ins2_warface_orsis_t5000", "Orsis T-5000"}
    weaponArray[76] = {"tfa_l4d2_osp18", "OSP-18"}
    weaponArray[77] = {"tfa_ins2_groza", "OTs-14 Groza"}
    weaponArray[78] = {"tfa_ins2_ots_33_pernach", "OTs-33 Pernach"}
    weaponArray[79] = {"tfa_doiowen", "Owen Mk.I"}
    weaponArray[80] = {"tfa_fml_p90_tac", "P90"}
    weaponArray[81] = {"tfa_new_pf940", "PF940"}
    weaponArray[82] = {"tfa_blast_pindadss2", "PINDAD SS2-V1"}
    weaponArray[83] = {"tfa_ins2_pm9", "PM-9"}
    weaponArray[84] = {"tfa_nam_ppsh41", "PPSH-41"}
    weaponArray[85] = {"tfa_fas2_ppbizon", "PP-Bizon"}
    weaponArray[86] = {"tfa_ww2_pbz39", "PzB 39"}
    weaponArray[87] = {"tfa_ins2_norinco_qbz97", "QBZ-97"}
    weaponArray[88] = {"tfa_ins2_qsz92", "QSZ-92"}
    weaponArray[89] = {"tfa_ins2_remington_m870", "Remington M870"}
    weaponArray[90] = {"tfa_ins2_pd2_remington_msr", "Remington MSR"}
    weaponArray[91] = {"tfa_ins2_rfb", "RFB"}
    weaponArray[92] = {"tfa_fml_rk62", "RK62"}
    weaponArray[93] = {"tfa_ins2_rpg7_scoped", "RPG-7"}
    weaponArray[94] = {"tfa_ins2_rpk_74m", "RPK-74M"}
    weaponArray[95] = {"tfa_ins2_l85a2", "SA80"}
    weaponArray[96] = {"tfa_ins2_scar_h_ssr", "SCAR-H SSR"}
    weaponArray[97] = {"tfa_ins2_sc_evo", "Scorpion Evo 3"}
    weaponArray[98] = {"tfa_new_p226", "SIG P226"}
    weaponArray[99] = {"tfa_ins2_sks", "SKS"}
    weaponArray[100] = {"tfa_ins2_spas12", "SPAS-12"}
    weaponArray[101] = {"tfa_ins2_spectre", "Spectre M4"}
    weaponArray[102] = {"tfa_ins2_saiga_spike", "Spike X15"}
    weaponArray[103] = {"tfa_ins2_sr2m_veresk", "SR-2M Veresk"}
    weaponArray[104] = {"tfa_doisten", "Sten Mk.II"}
    weaponArray[105] = {"tfa_nam_stevens620", "Stevens 620"}
    weaponArray[106] = {"tfa_inss_aug", "Steyr AUG"}
    weaponArray[107] = {"tfa_doistg44", "StG44"}
    weaponArray[108] = {"tfa_ins2_sv98", "SV-98"}
    weaponArray[109] = {"tfa_ins2_s&w_500", "S&W 500"}
    weaponArray[110] = {"tfa_japanese_exclusive_tanto", "Tanto"}
    weaponArray[111] = {"tfa_ins_sandstorm_tariq", "Tariq"}
    weaponArray[112] = {"st_stim_pistol", "TCo Stim Pistol"}
    weaponArray[113] = {"tfa_doithompsonm1928", "Thompson M1928"}
    weaponArray[114] = {"tfa_doithompsonm1a1", "Thompson M1A1"}
    weaponArray[115] = {"tfa_ins2_type81", "Type 81"}
    weaponArray[116] = {"tfa_ins2_typhoon12", "Typhoon F12 Custom"}
    weaponArray[117] = {"tfa_ins2_ump45", "UMP .45"}
    weaponArray[118] = {"tfa_ins2_ump9", "UMP9"}
    weaponArray[119] = {"tfa_ins2_imi_uzi", "Uzi"}
    weaponArray[120] = {"tfa_ins2_br99", "UZK-BR99"}
    weaponArray[121] = {"tfa_ins2_vhsd2", "VHS-D2"}
    weaponArray[122] = {"tfa_ins2_walther_p99", "Walther P99"}
    weaponArray[123] = {"tfa_ins2_wa2000", "WA-2000"}
    weaponArray[124] = {"tfa_ins2_xm8", "XM8"}

    --Model Array Formatting (Model ID, Model Name, Model Description, Unlock Style, Unlock Value)
    local modelArray = {}
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
    modelArray[16] = {"models/player/arctic.mdl", "Arctic", "I don't think it's cold in here.", "streak", 5}
    modelArray[17] = {"models/player/riot.mdl", "Riot", "Tanto Addict.", "streak", 10}
    modelArray[18] = {"models/player/gasmask.mdl", "Hazmat Suit", "This isn't Rust.", "streak", 15}
    modelArray[19] = {"models/player/police.mdl", "Officer", "Pick up the can.", "streak", 20}
    modelArray[20] = {"models/player/combine_soldier_prisonguard.mdl", "Cobalt Soilder", "No green card?", "streak", 25}
    modelArray[21] = {"models/walterwhite/playermodels/walterwhitechem.mdl", "Drug Dealer", "waltuh.", "streak", 30}
    modelArray[22] = {"models/cyanblue/fate/astolfo/astolfo.mdl", "Astolfo", "I was forced to do this.", "special", "name"}
    modelArray[23] = {"models/titanfall2_playermodel/kanepm.mdl", "Kane", "3 hour of beta playtime reward.", "special", "beta"}

    --Calling Card Array Formatting (Image File, Card Name, Card Description, Unlock Style, Unlock Value)
    local cardArray = {}
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
    cardArray[27] = {"cards/accolades/revenge_80.png", "Preperation", "stab stab.", "revenge", 300}
    cardArray[28] = {"cards/accolades/revenge_240.png", "Eyepatch", "", "revenge", 900}
    cardArray[29] = {"cards/color/red.png", "Red", "Solid red color.", "color", "color"}
    cardArray[30] = {"cards/color/orange.png", "Orange", "Solid orange color.", "color", "color"}
    cardArray[31] = {"cards/color/yellow.png", "Yellow", "Solid yellow color.", "color", "color"}
    cardArray[32] = {"cards/color/lime.png", "Lime", "Solid lime color.", "color", "color"}
    cardArray[33] = {"cards/color/cyan.png", "Cyan", "Solid cyan color.", "color", "color"}
    cardArray[34] = {"cards/color/blue.png", "Blue", "Solid blue color.", "color", "color"}
    cardArray[35] = {"cards/color/purple.png", "Magenta", "Solid magenta color.", "color", "color"}
    cardArray[36] = {"cards/color/pink.png", "Pink", "Solid pink color.", "color", "color"}
    cardArray[37] = {"cards/color/brown.png", "Brown", "Solid brown color.", "color", "color"}
    cardArray[38] = {"cards/color/gray.png", "Gray", "Solid gray color.", "color", "color"}
    cardArray[39] = {"cards/color/white.png", "White", "Solid white color.", "color", "color"}
    cardArray[40] = {"cards/color/black.png", "Black", "Solid black color.", "color", "color"}

    --Mastery Cards
    cardArray[41] = {"cards/mastery/aa12.png", "Close Up", "AA-12 mastery", "mastery", "tfa_ins2_aa12"}
    cardArray[42] = {"cards/mastery/acrc.png", "Posted Up", "ACR-C mastery", "mastery", "tfa_ins2_acrc"}
    cardArray[43] = {"cards/mastery/aek971.png", "Stalker", "AEK-971 mastery", "mastery", "tfa_ins2_aek971"}
    cardArray[44] = {"cards/mastery/akms.png", "Sunset", "AKMS mastery", "mastery", "tfa_ins2_akms"}
    cardArray[45] = {"cards/mastery/aks74u.png", "Loaded", "AKS-74U mastery", "mastery", "tfa_inss_aks74u"}
    cardArray[46] = {"cards/mastery/ak12_rpk.png", "Inspection", "AK-12 RPK mastery", "mastery", "tfa_ismc_ak12_rpk"}
    cardArray[47] = {"cards/mastery/ak400.png", "Overhead", "AK-400 mastery", "mastery", "tfa_ins2_ak400"}
    cardArray[48] = {"cards/mastery/amp_dsr1.png", "Arena", "AMP DSR-1 mastery", "mastery", "tfa_ins2_warface_amp_dsr1"}
    cardArray[49] = {"cards/mastery/an94.png", "Hijacked", "AN-94 mastery", "mastery", "tfa_ins2_abakan"}
    cardArray[50] = {"cards/mastery/ar15.png", "Modified", "AR-15 mastery", "mastery", "tfa_ins2_cw_ar15"}
    cardArray[51] = {"cards/mastery/ar57.png", "Ghost", "AR-57 mastery", "mastery", "tfa_ins2_ar57"}
    cardArray[52] = {"cards/mastery/ash12.png", "Factory", "ASh-12 mastery", "mastery", "tfa_at_shak_12"}
    cardArray[53] = {"cards/mastery/asval.png", "Zedo Pride", "AS-VAL mastery", "mastery", "tfa_inss_asval"}
    cardArray[54] = {"cards/mastery/awm.png", "Dust II", "AWM mastery", "mastery", "tfa_ins2_warface_awm"}
    cardArray[55] = {"cards/mastery/ax308.png", "Down Range", "AX-308 mastery", "mastery", "tfa_ins2_warface_ax308"}
    cardArray[56] = {"cards/mastery/barrettm98b.png", "Ready", "Barrett M98B mastery", "mastery", "tfa_ins2_barrett_m98_bravo"}
    cardArray[57] = {"cards/mastery/berettamx4.png", "House", "Barrett Mx4 mastery", "mastery", "tfa_ins2_mx4"}
    cardArray[58] = {"cards/mastery/bren.png", "Flank", "Bren mastery", "mastery", "tfa_doibren"}
    cardArray[59] = {"cards/mastery/btmp9.png", "Training", "B&T MP9 mastery", "mastery", "tfa_ins2_warface_bt_mp9"}
    cardArray[60] = {"cards/mastery/cheyintervention.png", "Trickshot", "CheyTac M200 mastery", "mastery", "tfa_ins2_warface_cheytac_m200"}
    cardArray[61] = {"cards/mastery/colt1911.png", "Relic", "Colt M1911 mastery", "mastery", "tfa_new_m1911"}
    cardArray[62] = {"cards/mastery/coltm45a1.png", "Legend", "Colt M45A1 mastery", "mastery", "tfa_ins2_colt_m45"}
    cardArray[63] = {"cards/mastery/cz75.png", "Nuke", "CZ 75 B mastery", "mastery", "tfa_ins2_cz75"}
    cardArray[64] = {"cards/mastery/cz805.png", "Attached", "CZ 805 BREN mastery", "mastery", "tfa_ins2_cz805"}
    cardArray[65] = {"cards/mastery/ddm4v5.png", "Carbine", "DDM4V5 mastery", "mastery", "tfa_ins2_ddm4v5"}
    cardArray[66] = {"cards/mastery/deserteagle.png", "Mag Check", "Desert Eagle mastery", "mastery", "tfa_ins2_deagle"}
    cardArray[67] = {"cards/mastery/famasf1.png", "Siege", "Famas F1 mastery", "mastery", "tfa_ins2_famas"}
    cardArray[68] = {"cards/mastery/fb_msbsb.png", "Left", "FB MSBS-B mastery", "mastery", "tfa_blast_lynx_msbsb"}
    cardArray[69] = {"cards/mastery/fg42.png", "Glint", "FG 42 mastery", "mastery", "tfa_doifg42"}
    cardArray[70] = {"cards/mastery/fiveseven.png", "Intergalactic", "Fiveseven mastery", "mastery", "tfa_ins2_fiveseven_eft"}
    cardArray[71] = {"cards/mastery/fnfal.png", "Exposed", "FN FAL mastery", "mastery", "tfa_ins2_fn_fal"}
    cardArray[72] = {"cards/mastery/fnp45.png", "ACP", "FNP-45 mastery", "mastery", "tfa_ins2_fnp45"}
    cardArray[73] = {"cards/mastery/placeholder.png", "", "Galil mastery", "mastery", "tfa_new_inss_galil"}
    cardArray[74] = {"cards/mastery/placeholder.png", "", "Glock 17 mastery", "mastery", "tfa_new_glock17"}
    cardArray[75] = {"cards/mastery/placeholder.png", "", "GSH-18 mastery", "mastery", "tfa_ins2_gsh18"}
    cardArray[76] = {"cards/mastery/honeybadger.png", "Business", "Honey Badger mastery", "mastery", "tfa_ins2_cq300"}
    cardArray[77] = {"cards/mastery/placeholder.png", "", "Howa Type 64 mastery", "mastery", "tfa_howa_type_64"}
    cardArray[78] = {"cards/mastery/placeholder.png", "", "H&K MG36 mastery", "mastery", "tfa_ins2_hk_mg36"}
    cardArray[79] = {"cards/mastery/placeholder.png", "", "H&K MP5A5 mastery", "mastery", "tfa_inss2_hk_mp5a5"}
    cardArray[80] = {"cards/mastery/placeholder.png", "", "Imbel IA2 mastery", "mastery", "tfa_ins2_imbelia2"}
    cardArray[81] = {"cards/mastery/placeholder.png", "", "IZH-43 Sawed Off mastery", "mastery", "tfa_ins2_izh43sw"}
    cardArray[82] = {"cards/mastery/placeholder.png", "", "Japanese Ararebo mastery", "mastery", "tfa_ararebo_bf1"}
    cardArray[83] = {"cards/mastery/placeholder.png", "", "KM-2000 mastery", "mastery", "tfa_km2000_knife"}
    cardArray[84] = {"cards/mastery/krissvector.png", "Narkotica", "KRISS Vector mastery", "mastery", "tfa_ins2_krissv"}
    cardArray[85] = {"cards/mastery/placeholder.png", "", "KSG mastery", "mastery", "tfa_ins2_ksg"}
    cardArray[86] = {"cards/mastery/placeholder.png", "", "KSVK 12.7 mastery", "mastery", "tfa_blast_ksvk_cqb"}
    cardArray[87] = {"cards/mastery/placeholder.png", "", "Lee-Enfield No. 4 mastery", "mastery", "tfa_doi_enfield"}
    cardArray[88] = {"cards/mastery/placeholder.png", "", "Lewis mastery", "mastery", "tfa_doilewis"}
    cardArray[89] = {"cards/mastery/placeholder.png", "", "M1 Garand mastery", "mastery", "tfa_doi_garand"}
    cardArray[90] = {"cards/mastery/placeholder.png", "", "M14 mastery", "mastery", "tfa_ins2_m14retro"}
    cardArray[91] = {"cards/mastery/placeholder.png", "", "M3 Grease Gun mastery", "mastery", "tfa_doim3greasegun"}
    cardArray[92] = {"cards/mastery/placeholder.png", "", "M9 mastery", "mastery", "tfa_ins2_m9"}
    cardArray[93] = {"cards/mastery/m79.png", "Cool With It", "M79 mastery", "mastery", "tfa_nam_m79"}
    cardArray[94] = {"cards/mastery/placeholder.png", "", "M1918 mastery", "mastery", "tfa_doim1918"}
    cardArray[95] = {"cards/mastery/placeholder.png", "", "M1919 mastery", "mastery", "tfa_doim1919"}
    cardArray[96] = {"cards/mastery/placeholder.png", "", "Mac 10 mastery", "mastery", "bocw_mac10_alt"}
    cardArray[97] = {"cards/mastery/placeholder.png", "", "Makarov mastery", "mastery", "tfa_inss_makarov"}
    cardArray[98] = {"cards/mastery/mas38.png", "Galaxy", "Mas 38 mastery", "mastery", "tfa_fml_lefrench_mas38"}
    cardArray[99] = {"cards/mastery/placeholder.png", "", "MG 34 mastery", "mastery", "tfa_doimg34"}
    cardArray[100] = {"cards/mastery/mg42.png", "D-Day", "MG 42 mastery", "mastery", "tfa_doimg42"}
    cardArray[101] = {"cards/mastery/minimi.png", "Roof Camper", "Minimi Para mastery", "mastery", "tfa_ins2_minimi"}
    cardArray[102] = {"cards/mastery/placeholder.png", "", "MK 23 mastery", "mastery", "tfa_ins2_mk23"}
    cardArray[103] = {"cards/mastery/placeholder.png", "", "MK18 mastery", "mastery", "tfa_fml_inss_mk18"}
    cardArray[104] = {"cards/mastery/placeholder.png", "", "Mk. 14 EBR mastery", "mastery", "tfa_ins2_mk14ebr"}
    cardArray[105] = {"cards/mastery/model10.png", "Walter", "Model 10 mastery", "mastery", "tfa_ins2_swmodel10"}
    cardArray[106] = {"cards/mastery/placeholder.png", "", "Mosin Nagant mastery", "mastery", "tfa_ins2_mosin_nagant"}
    cardArray[107] = {"cards/mastery/placeholder.png", "", "MP 40 mastery", "mastery", "tfa_doimp40"}
    cardArray[108] = {"cards/mastery/placeholder.png", "", "MP5K mastery", "mastery", "tfa_ins2_mp5k"}
    cardArray[109] = {"cards/mastery/mp7a1.png", "Oilspill", "MP7A1 mastery", "mastery", "tfa_inss_mp7_new"}
    cardArray[110] = {"cards/mastery/placeholder.png", "", "MP18 mastery", "mastery", "tfa_ww1_mp18"}
    cardArray[111] = {"cards/mastery/placeholder.png", "", "MR-96 mastery", "mastery", "tfa_ins2_mr96"}
    cardArray[112] = {"cards/mastery/placeholder.png", "", "MTs225-12 mastery", "mastery", "tfa_ins2_mc255"}
    cardArray[113] = {"cards/mastery/placeholder.png", "", "Nova mastery", "mastery", "tfa_ins2_nova"}
    cardArray[114] = {"cards/mastery/placeholder.png", "", "Orsis T-5000 mastery", "mastery", "tfa_ins2_warface_orsis_t5000"}
    cardArray[115] = {"cards/mastery/placeholder.png", "", "OSP-18", "mastery", "tfa_l4d2_osp18"}
    cardArray[116] = {"cards/mastery/placeholder.png", "", "OTs-14 Groza mastery", "mastery", "tfa_ins2_groza"}
    cardArray[117] = {"cards/mastery/placeholder.png", "", "OTs-33 Pernach mastery", "mastery", "tfa_ins2_ots_33_pernach"}
    cardArray[118] = {"cards/mastery/placeholder.png", "", "Owen Mk.I mastery", "mastery", "tfa_doiowen"}
    cardArray[119] = {"cards/mastery/placeholder.png", "", "P90 mastery", "mastery", "tfa_fml_p90_tac"}
    cardArray[120] = {"cards/mastery/placeholder.png", "", "PINDAD SS2-V1 mastery", "mastery", "tfa_blast_pindadss2"}
    cardArray[121] = {"cards/mastery/placeholder.png", "", "PM-9 mastery", "mastery", "tfa_ins2_pm9"}
    cardArray[122] = {"cards/mastery/placeholder.png", "", "PPSH-41 mastery", "mastery", "tfa_nam_ppsh41"}
    cardArray[123] = {"cards/mastery/placeholder.png", "", "PP-Bizon mastery", "mastery", "tfa_fas2_ppbizon"}
    cardArray[124] = {"cards/mastery/placeholder.png", "", "PzB 39 mastery", "mastery", "tfa_ww2_pbz39"}
    cardArray[125] = {"cards/mastery/placeholder.png", "", "QBZ-97 mastery", "mastery", "tfa_ins2_norinco_qbz97"}
    cardArray[126] = {"cards/mastery/placeholder.png", "", "QSZ-92 mastery", "mastery", "tfa_ins2_qsz92"}
    cardArray[127] = {"cards/mastery/remingtonm870.png", "Mastery", "Remington M870 master", "mastery", "tfa_ins2_remington_m870"}
    cardArray[128] = {"cards/mastery/placeholder.png", "", "Remington MSR mastery", "mastery", "tfa_ins2_pd2_remington_msr"}
    cardArray[129] = {"cards/mastery/placeholder.png", "", "RFB mastery", "mastery", "tfa_ins2_rfb"}
    cardArray[130] = {"cards/mastery/placeholder.png", "", "RK62 mastery", "mastery", "tfa_fml_rk62"}
    cardArray[131] = {"cards/mastery/rpg7.png", "Damascus", "RPG-7 mastery", "mastery", "tfa_ins2_rpg7_scoped"}
    cardArray[132] = {"cards/mastery/placeholder.png", "", "RPK-74M mastery", "mastery", "tfa_ins2_rpk_74m"}
    cardArray[133] = {"cards/mastery/placeholder.png", "", "SA80 mastery", "mastery", "tfa_ins2_l85a2"}
    cardArray[134] = {"cards/mastery/placeholder.png", "", "SCAR-H SSR mastery", "mastery", "tfa_ins2_scar_h_ssr"}
    cardArray[135] = {"cards/mastery/placeholder.png", "", "Scorpion Evo 3 mastery", "mastery", "tfa_ins2_sc_evo"}
    cardArray[136] = {"cards/mastery/placeholder.png", "", "SIG P226 mastery", "mastery", "tfa_new_p226"}
    cardArray[137] = {"cards/mastery/placeholder.png", "", "SKS mastery", "mastery", "tfa_ins2_sks"}
    cardArray[138] = {"cards/mastery/placeholder.png", "", "SPAS-12 mastery", "mastery", "tfa_ins2_spas12"}
    cardArray[139] = {"cards/mastery/placeholder.png", "", "Spectre M4 mastery", "mastery", "tfa_ins2_spectre"}
    cardArray[140] = {"cards/mastery/placeholder.png", "", "Spike X15 mastery", "mastery", "tfa_ins2_saiga_spike"}
    cardArray[141] = {"cards/mastery/placeholder.png", "", "SR-2M Veresk mastery", "mastery", "tfa_ins2_sr2m_veresk"}
    cardArray[142] = {"cards/mastery/placeholder.png", "", "Sten Mk.II mastery", "mastery", "tfa_doisten"}
    cardArray[143] = {"cards/mastery/placeholder.png", "", "Stevens 620 mastery", "mastery", "tfa_nam_stevens620"}
    cardArray[144] = {"cards/mastery/steyraug.png", "Cute", "Steyr AUG mastery", "mastery", "tfa_inss_aug"}
    cardArray[145] = {"cards/mastery/placeholder.png", "", "StG44 mastery", "mastery", "tfa_doistg44"}
    cardArray[146] = {"cards/mastery/placeholder.png", "", "SV-98 mastery", "mastery", "tfa_ins2_sv98"}
    cardArray[147] = {"cards/mastery/placeholder.png", "", "S&W 500 mastery", "mastery", "tfa_ins2_s&w_500"}
    cardArray[148] = {"cards/mastery/placeholder.png", "", "Tanto mastery", "mastery", "tfa_japanese_exclusive_tanto"}
    cardArray[149] = {"cards/mastery/placeholder.png", "", "Tariq mastery", "mastery", "tfa_ins_sandstorm_tariq"}
    cardArray[150] = {"cards/mastery/placeholder.png", "", "Thompson M1928 master", "mastery", "tfa_doithompsonm1928"}
    cardArray[151] = {"cards/mastery/thompson.png", "Suicide", "Thompson M1A1 master", "mastery", "tfa_doithompsonm1a1"}
    cardArray[152] = {"cards/mastery/placeholder.png", "", "Type 81 mastery", "mastery", "tfa_ins2_type81"}
    cardArray[153] = {"cards/mastery/placeholder.png", "", "Typhoon F12 Custom master", "mastery", "tfa_ins2_typhoon12"}
    cardArray[154] = {"cards/mastery/placeholder.png", "", "UMP .45 mastery", "mastery", "tfa_ins2_ump45"}
    cardArray[155] = {"cards/mastery/placeholder.png", "", "UMP9 mastery", "mastery", "tfa_ins2_ump9"}
    cardArray[156] = {"cards/mastery/placeholder.png", "", "Uzi mastery", "mastery", "tfa_ins2_imi_uzi"}
    cardArray[157] = {"cards/mastery/placeholder.png", "", "UZK-BR99 mastery", "mastery", "tfa_ins2_br99"}
    cardArray[158] = {"cards/mastery/placeholder.png", "", "VHS-D2 mastery", "mastery", "tfa_ins2_vhsd2"}
    cardArray[159] = {"cards/mastery/placeholder.png", "", "Walther P99 mastery", "mastery", "tfa_ins2_walther_p99"}
    cardArray[160] = {"cards/mastery/placeholder.png", "", "WA-2000 mastery", "mastery", "tfa_ins2_wa2000"}
    cardArray[161] = {"cards/mastery/placeholder.png", "", "XM8 mastery", "mastery", "tfa_ins2_xm8"}

    --Map Array Formatting (Map ID, Map Name, Map Description, Map Image)
    local mapArray = {}
    mapArray[1] = {"tm_darkstreets", "Dark Streets", "Limited movement and narrow chokepoints.", "maps/thumb/tm_darkstreets.png"}
    mapArray[2] = {"tm_grid", "Grid", "Open, vibrant rooms connected via maze-like hallways.", "maps/thumb/tm_grid.png"}
    mapArray[3] = {"tm_liminal_pool", "Liminal Pool", "Prone to sniping, many movemeny opportunities", "maps/thumb/tm_liminal_pool.png"}
    mapArray[4] = {"tm_mephitic", "Mephitic", "Dark facility with a continuous acid flood.", "maps/thumb/tm_mephitic.png"}
    mapArray[5] = {"tm_nuketown", "Nuketown", "Cult classic, predictible spawns and engagements.", "maps/thumb/tm_nuketown.png"}
    mapArray[6] = {"tm_rooftops", "Rooftops", "Mix of urban CQB and long range combat.", "maps/thumb/tm_rooftops.png"}
    mapArray[7] = {"tm_cradle", "Cradle", "Wide and open with many grapple spots.", "maps/thumb/tm_cradle.png"}
    mapArray[8] = {"tm_groves", "Groves", "Sandy environment with countless cover.", "maps/thumb/tm_groves.png"}
    mapArray[9] = {"tm_mall", "Mall", "Spacious shopping center with long sightlines.", "maps/thumb/tm_mall.png"}
    mapArray[10] = {"tm_bridge", "Bridge", "Speeding cars act as hazards during your fights.", "maps/thumb/tm_bridge.png"}

    weaponsArr = weaponArray
    modelArr = modelArray
    cardArr = cardArray
    mapArr = mapArray
end

--ConVars for the gamemode will under this comment, this is used to set up default client settings, and server side stuff.

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
    RunConsoleCommand("sv_tfa_ammo_detonation", "1")
    RunConsoleCommand("sv_tfa_ammo_detonation_chain", "1")
    RunConsoleCommand("sv_tfa_ammo_detonation_mode", "2")
    RunConsoleCommand("sv_tfa_arrow_lifetime", "30")
    RunConsoleCommand("sv_tfa_attachments_alphabetical", "0")
    RunConsoleCommand("sv_tfa_attachments_enabled", "1")
    RunConsoleCommand("sv_tfa_backcompat_patchswepthink", "1")
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
    RunConsoleCommand("sv_tfa_damage_multiplier_npc", "1.00")
    RunConsoleCommand("sv_tfa_default_clip", "1000")
    RunConsoleCommand("sv_tfa_door_respawn", "-1")
    RunConsoleCommand("sv_tfa_dynamicaccuracy", "1")
    RunConsoleCommand("sv_tfa_fixed_crosshair", "1")
    RunConsoleCommand("sv_tfa_force_multiplier", "1.00")
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
    RunConsoleCommand("sv_tfa_recoil_mul_p", "0.75")
    RunConsoleCommand("sv_tfa_recoil_mul_p_npc", "1")
    RunConsoleCommand("sv_tfa_recoil_mul_y", "0.75")
    RunConsoleCommand("sv_tfa_recoil_mul_y_npc", "1")
    RunConsoleCommand("sv_tfa_recoil_viewpunch_mul", "1.75")
    RunConsoleCommand("sv_tfa_scope_gun_speed_scale", "0")
    RunConsoleCommand("sv_tfa_soundscale", "1")
    RunConsoleCommand("sv_tfa_spread_legacy", "0")
    RunConsoleCommand("sv_tfa_spread_multiplier", "0")
    RunConsoleCommand("sv_tfa_sprint_enabled", "1")
    RunConsoleCommand("sv_tfa_unique_slots", "1")
    RunConsoleCommand("sv_tfa_weapon_strip", "0")
    RunConsoleCommand("sv_tfa_weapon_weight", "1")
    RunConsoleCommand("sv_tfa_worldmodel_culldistance", "-1")

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
    RunConsoleCommand("cl_tfa_3dscope_quality", "0")
    RunConsoleCommand("cl_tfa_attachments_persist_enabled", "1")
    RunConsoleCommand("cl_tfa_ballistics_fx_bullet", "1")
    RunConsoleCommand("cl_tfa_ballistics_fx_tracers_adv", "1")
    RunConsoleCommand("cl_tfa_ballistics_fx_tracers_style", "2")
    RunConsoleCommand("cl_tfa_ballistics_mp", "1")
    RunConsoleCommand("cl_tfa_debug_animations", "0")
    RunConsoleCommand("cl_tfa_debug_cache", "0")
    RunConsoleCommand("cl_tfa_debug_crosshair", "0")
    RunConsoleCommand("cl_tfa_debug_rt", "0")
    RunConsoleCommand("cl_tfa_fx_ads_dof_hd", "0")
    RunConsoleCommand("cl_tfa_fx_ejectionsmoke", "0")
    RunConsoleCommand("cl_tfa_fx_impact_enabled", "1")
    RunConsoleCommand("cl_tfa_fx_impact_ricochet_enabled", "1")
    RunConsoleCommand("cl_tfa_fx_impact_ricochet_sparklife", "2.00")
    RunConsoleCommand("cl_tfa_fx_impact_ricochet_sparks", "6")
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
    RunConsoleCommand("cl_tfa_rms_default_eject_smoke", "0")
    RunConsoleCommand("cl_tfa_rms_muzzleflash_dynlight", "1")
    RunConsoleCommand("cl_tfa_rms_smoke_shock", "0")
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
    RunConsoleCommand("tpf_cl_farz", "750")
    RunConsoleCommand("tpf_cl_fov", "75")
    RunConsoleCommand("tpf_cl_bright", "255")
end