--This is only here to help me test kills easier, will be removed when no-longer needed.
function TestKillNoti(ply, cmd, args)
    net.Start("NotifyKill")
    net.WriteEntity(ply)
    net.Send(ply)
end
concommand.Add("testkill", TestKillNoti)

--This is only here to help me test deaths easier, will be removed when no-longer needed.
function TestDeathNoti(ply, cmd, args)
	net.Start("DeathHud")
	net.WriteEntity(ply)
	net.WriteString("the rope")
	net.WriteFloat(100)
	net.Send(ply)
end
concommand.Add("testdeath", TestDeathNoti)

function TestDeathNoti(ply, cmd, args)
    ply:KillSilent()
    net.Start("EndOfGame")
    net.WriteString("tm_nuketown")
    net.Broadcast()
end
concommand.Add("testend", TestDeathNoti) 

--Allows the player to save their local stats to the sv.db file without having to leave the server.
function ForceSave(ply, cmd, args)
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
    --Statistics
    ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
    ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
    ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
    ply:SetPData("playerScore", ply:GetNWInt("playerScore"))

    --Streaks
    ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))

    --Customizatoin
    ply:SetPData("chosenPlayermodel", ply:GetNWString("chosenPlayermodel"))
    ply:SetPData("chosenPlayercard", ply:GetNWString("chosenPlayercard"))
    ply:SetPData("cardPictureOffset", ply:GetNWInt("cardPictureOffset"))

    --Accolades
    ply:SetPData("playerAccoladeOnStreak", ply:GetNWInt("playerAccoladeOnStreak"))
    ply:SetPData("playerAccoladeBuzzkill", ply:GetNWInt("playerAccoladeBuzzkill"))
    ply:SetPData("playerAccoladeLongshot", ply:GetNWInt("playerAccoladeLongshot"))
    ply:SetPData("playerAccoladePointblank", ply:GetNWInt("playerAccoladePointblank"))
    ply:SetPData("playerAccoladeSmackdown", ply:GetNWInt("playerAccoladeSmackdown"))
    ply:SetPData("playerAccoladeHeadshot", ply:GetNWInt("playerAccoladeHeadshot"))
    ply:SetPData("playerAccoladeClutch", ply:GetNWInt("playerAccoladeClutch"))
    ply:SetPData("playerAccoladeRevenge", ply:GetNWInt("playerAccoladeRevenge"))
    ply:SetPData("playerAccoladeCopycat", ply:GetNWInt("playerAccoladeCopycat"))

    print("Save was successful!")
end
concommand.Add("tm_forcesave", ForceSave)

--Allows the Main Menu to change the players current playermodel.
function PlayerModelChange(ply, cmd, args)
	local modelList = {}
	modelList[1] = {"models/player/Group03/male_02.mdl", "Male", "The default male character.", "default", "default"}
	modelList[2] = {"models/player/Group03/female_02.mdl", "Female", "The default female character.", "default", "default"}
	modelList[3] = {"models/player/Group01/male_03.mdl", "Casual Male", "Why so serious?", "default", "default"}
	modelList[4] = {"models/player/mossman.mdl", "Casual Female", "Why so serious?", "default", "default"}
	modelList[5] = {"models/player/Group03m/male_05.mdl", "Doctor", "I need a medic bag.", "default", "default"}
	modelList[6] = {"models/player/Group03m/female_06.mdl", "Nurse", "I need a medic bag.", "default", "default"}
	modelList[7] = {"models/player/barney.mdl", "Barney", "Not purple this time.", "default", "default"}
	modelList[8] = {"models/player/breen.mdl", "Breen", "i couldn't think of anything", "default", "default"}
	modelList[9] = {"models/player/kleiner.mdl", "Kleiner", "But in the end.", "default", "default"}
	modelList[10] = {"models/player/Group01/male_07.mdl", "Male 07", "The one, the only.", "kills", 100}
	modelList[11] = {"models/player/alyx.mdl", "Alyx", "ughhhhhhhhh.", "kills", 300}
	modelList[12] = {"models/player/hostage/hostage_04.mdl", "Scientist", "Bill Nye.", "kills", 500}
	modelList[13] = {"models/player/gman_high.mdl", "GMan", "Where is 3?", "kills", 1000}
	modelList[14] = {"models/player/p2_chell.mdl", "Chell", "Funny portal reference.", "kills", 2000}
	modelList[15] = {"models/player/leet.mdl", "Badass", "So cool.", "kills", 3000}
	modelList[16] = {"models/player/arctic.mdl", "Arctic", "I don't think it's cold in here.", "streak", 5}
	modelList[17] = {"models/player/riot.mdl", "Riot", "Tanto Addict.", "streak", 10}
	modelList[18] = {"models/player/gasmask.mdl", "Hazmat Suit", "This isn't Rust.", "streak", 15}
	modelList[19] = {"models/player/police.mdl", "Officer", "Pick up the can.", "streak", 20}
	modelList[20] = {"models/player/combine_soldier_prisonguard.mdl", "Cobalt Soilder", "No green card?", "streak", 25}
	modelList[21] = {"models/walterwhite/playermodels/walterwhitechem.mdl", "Drug Dealer", "waltuh.", "streak", 30}
	modelList[22] = {"models/cyanblue/fate/astolfo/astolfo.mdl", "Astolfo", "I was forced to do this.", "special", "name"}

	for k, v in pairs(modelList) do
		if (args[1] == v[1]) then

			local modelID = v[1]
			local modelUnlock = v[4]
			local modelValue = v[5]

			if modelUnlock == "default" then
				ply:SetNWInt("chosenPlayermodel", modelID)
			end

			if modelUnlock == "kills" and ply:GetNWInt("playerKills") >= modelValue then
				ply:SetNWInt("chosenPlayermodel", modelID)
			end

			if modelUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= modelValue then
				ply:SetNWInt("chosenPlayermodel", modelID)
			end

			if modelUnlock == "special" and ply:SteamID() == "STEAM_0:1:514443768" then
				ply:SetNWInt("chosenPlayermodel", modelID)
			end
		end
	end
end
concommand.Add("tm_selectplayermodel", PlayerModelChange)

--Allows the Main Menu to change the players current playercard.
function PlayercardChange(ply, cmd, args)
	local masteryUnlockReq = 50
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
    cardArray[53] = {"cards/mastery/asval.png", "Crab Pride", "AS-VAL mastery", "mastery", "tfa_inss_asval"}
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
    cardArray[65] = {"cards/mastery/placeholder.png", "", "DDM4V5 mastery", "mastery", "tfa_ins2_ddm4v5"}
    cardArray[66] = {"cards/mastery/deserteagle.png", "Mag Check", "Desert Eagle mastery", "mastery", "tfa_ins2_deagle"}
    cardArray[67] = {"cards/mastery/famasf1.png", "Siege", "Famas F1 mastery", "mastery", "tfa_ins2_famas"}
    cardArray[68] = {"cards/mastery/fb_msbsb.png", "Left", "FB MSBS-B mastery", "mastery", "tfa_blast_lynx_msbsb"}
    cardArray[69] = {"cards/mastery/fg42.png", "Glint", "FG 42 mastery", "mastery", "tfa_doifg42"}
    cardArray[70] = {"cards/mastery/fiveseven.png", "Intergalactic", "Fiveseven mastery", "mastery", "tfa_ins2_fiveseven_eft"}
    cardArray[71] = {"cards/mastery/placeholder.png", "", "FN FAL mastery", "mastery", "tfa_ins2_fn_fal"}
    cardArray[72] = {"cards/mastery/placeholder.png", "", "FNP-45 mastery", "mastery", "tfa_ins2_fnp45"}
    cardArray[73] = {"cards/mastery/placeholder.png", "", "Galil mastery", "mastery", "tfa_new_inss_galil"}
    cardArray[74] = {"cards/mastery/placeholder.png", "", "Glock 17 mastery", "mastery", "tfa_new_glock17"}
    cardArray[75] = {"cards/mastery/placeholder.png", "", "GSH-18 mastery", "mastery", "tfa_ins2_gsh18"}
    cardArray[76] = {"cards/mastery/placeholder.png", "", "Howa Type 64 mastery", "mastery", "tfa_howa_type_64"}
    cardArray[77] = {"cards/mastery/placeholder.png", "", "H&K MG36 mastery", "mastery", "tfa_ins2_hk_mg36"}
    cardArray[78] = {"cards/mastery/placeholder.png", "", "H&K MP5A5 mastery", "mastery", "tfa_inss2_hk_mp5a5"}
    cardArray[79] = {"cards/mastery/placeholder.png", "", "Imbel IA2 mastery", "mastery", "tfa_ins2_imbelia2"}
    cardArray[80] = {"cards/mastery/placeholder.png", "", "IZH-43 Sawed Off mastery", "mastery", "tfa_ins2_izh43sw"}
    cardArray[81] = {"cards/mastery/placeholder.png", "", "Japanese Ararebo mastery", "mastery", "tfa_ararebo_bf1"}
    cardArray[82] = {"cards/mastery/placeholder.png", "", "KM-2000 mastery", "mastery", "tfa_km2000_knife"}
    cardArray[83] = {"cards/mastery/krissvector.png", "Narkotica", "KRISS Vector mastery", "mastery", "tfa_ins2_krissv"}
    cardArray[84] = {"cards/mastery/placeholder.png", "", "KSG mastery", "mastery", "tfa_ins2_ksg"}
    cardArray[85] = {"cards/mastery/placeholder.png", "", "KSVK 12.7 mastery", "mastery", "tfa_blast_ksvk_cqb"}
    cardArray[86] = {"cards/mastery/placeholder.png", "", "Lee-Enfield No. 4 mastery", "mastery", "tfa_doi_enfield"}
    cardArray[87] = {"cards/mastery/placeholder.png", "", "Lewis mastery", "mastery", "tfa_doilewis"}
    cardArray[88] = {"cards/mastery/placeholder.png", "", "M1 Garand mastery", "mastery", "tfa_doi_garand"}
    cardArray[89] = {"cards/mastery/placeholder.png", "", "M14 mastery", "mastery", "tfa_ins2_m14retro"}
    cardArray[90] = {"cards/mastery/placeholder.png", "", "M3 Grease Gun mastery", "mastery", "tfa_doim3greasegun"}
    cardArray[91] = {"cards/mastery/placeholder.png", "", "M9 mastery", "mastery", "tfa_ins2_m9"}
    cardArray[92] = {"cards/mastery/m79.png", "Cool With It", "M79 mastery", "mastery", "tfa_nam_m79"}
    cardArray[93] = {"cards/mastery/placeholder.png", "", "M1918 mastery", "mastery", "tfa_doim1918"}
    cardArray[94] = {"cards/mastery/placeholder.png", "", "M1919 mastery", "mastery", "tfa_doim1919"}
    cardArray[95] = {"cards/mastery/placeholder.png", "", "Mac 10 mastery", "mastery", "bocw_mac10_alt"}
    cardArray[96] = {"cards/mastery/placeholder.png", "", "Makarov mastery", "mastery", "tfa_inss_makarov"}
    cardArray[97] = {"cards/mastery/mas38.png", "Galaxy", "Mas 38 mastery", "mastery", "tfa_fml_lefrench_mas38"}
    cardArray[98] = {"cards/mastery/placeholder.png", "", "MG 34 mastery", "mastery", "tfa_doimg34"}
    cardArray[99] = {"cards/mastery/mg42.png", "D-Day", "MG 42 mastery", "mastery", "tfa_doimg42"}
    cardArray[100] = {"cards/mastery/minimi.png", "Roof Camper", "Minimi Para mastery", "mastery", "tfa_ins2_minimi"}
    cardArray[101] = {"cards/mastery/placeholder.png", "", "MK 23 mastery", "mastery", "tfa_ins2_mk23"}
    cardArray[102] = {"cards/mastery/placeholder.png", "", "MK18 mastery", "mastery", "tfa_fml_inss_mk18"}
    cardArray[103] = {"cards/mastery/placeholder.png", "", "Mk. 14 EBR mastery", "mastery", "tfa_ins2_mk14ebr"}
    cardArray[104] = {"cards/mastery/model10.png", "Walter", "Model 10 mastery", "mastery", "tfa_ins2_swmodel10"}
    cardArray[105] = {"cards/mastery/placeholder.png", "", "Mosin Nagant mastery", "mastery", "tfa_ins2_mosin_nagant"}
    cardArray[106] = {"cards/mastery/placeholder.png", "", "MP 40 mastery", "mastery", "tfa_doimp40"}
    cardArray[107] = {"cards/mastery/placeholder.png", "", "MP5K mastery", "mastery", "tfa_ins2_mp5k"}
    cardArray[108] = {"cards/mastery/placeholder.png", "", "MP7A1 mastery", "mastery", "tfa_inss_mp7_new"}
    cardArray[109] = {"cards/mastery/placeholder.png", "", "MP18 mastery", "mastery", "tfa_ww1_mp18"}
    cardArray[110] = {"cards/mastery/placeholder.png", "", "MR-96 mastery", "mastery", "tfa_ins2_mr96"}
    cardArray[111] = {"cards/mastery/placeholder.png", "", "MTs225-12 mastery", "mastery", "tfa_ins2_mc255"}
    cardArray[112] = {"cards/mastery/placeholder.png", "", "Nova mastery", "mastery", "tfa_ins2_nova"}
    cardArray[113] = {"cards/mastery/placeholder.png", "", "Orsis T-5000 mastery", "mastery", "tfa_ins2_warface_orsis_t5000"}
    cardArray[114] = {"cards/mastery/placeholder.png", "", "OTs-14 Groza mastery", "mastery", "tfa_ins2_groza"}
    cardArray[115] = {"cards/mastery/placeholder.png", "", "OTs-33 Pernach mastery", "mastery", "tfa_ins2_ots_33_pernach"}
    cardArray[116] = {"cards/mastery/placeholder.png", "", "Owen Mk.I mastery", "mastery", "tfa_doiowen"}
    cardArray[117] = {"cards/mastery/placeholder.png", "", "P90 mastery", "mastery", "tfa_fml_p90_tac"}
    cardArray[118] = {"cards/mastery/placeholder.png", "", "PINDAD SS2-V1 mastery", "mastery", "tfa_blast_pindadss2"}
    cardArray[119] = {"cards/mastery/placeholder.png", "", "PM-9 mastery", "mastery", "tfa_ins2_pm9"}
    cardArray[120] = {"cards/mastery/placeholder.png", "", "PPSH-41 mastery", "mastery", "tfa_nam_ppsh41"}
    cardArray[121] = {"cards/mastery/placeholder.png", "", "PP-Bizon mastery", "mastery", "tfa_fas2_ppbizon"}
    cardArray[122] = {"cards/mastery/placeholder.png", "", "QBZ-97 mastery", "mastery", "tfa_ins2_norinco_qbz97"}
    cardArray[123] = {"cards/mastery/placeholder.png", "", "QSZ-92 mastery", "mastery", "tfa_ins2_qsz92"}
    cardArray[124] = {"cards/mastery/remingtonm870.png", "Mastery", "Remington M870 master", "mastery", "tfa_ins2_remington_m870"}
    cardArray[125] = {"cards/mastery/placeholder.png", "", "Remington MSR mastery", "mastery", "tfa_ins2_pd2_remington_msr"}
    cardArray[126] = {"cards/mastery/placeholder.png", "", "RFB mastery", "mastery", "tfa_ins2_rfb"}
    cardArray[127] = {"cards/mastery/placeholder.png", "", "RPG-7 mastery", "mastery", "tfa_ins2_rpg7_scoped"}
    cardArray[128] = {"cards/mastery/placeholder.png", "", "RPK-74M mastery", "mastery", "tfa_ins2_rpk_74m"}
    cardArray[129] = {"cards/mastery/placeholder.png", "", "SA80 mastery", "mastery", "tfa_ins2_l85a2"}
    cardArray[130] = {"cards/mastery/placeholder.png", "", "SCAR-H SSR mastery", "mastery", "tfa_ins2_scar_h_ssr"}
    cardArray[131] = {"cards/mastery/placeholder.png", "", "Scorpion Evo 3 mastery", "mastery", "tfa_ins2_sc_evo"}
    cardArray[132] = {"cards/mastery/placeholder.png", "", "SIG P226 mastery", "mastery", "tfa_new_p226"}
    cardArray[133] = {"cards/mastery/placeholder.png", "", "SKS mastery", "mastery", "tfa_ins2_sks"}
    cardArray[134] = {"cards/mastery/placeholder.png", "", "SPAS-12 mastery", "mastery", "tfa_ins2_spas12"}
    cardArray[135] = {"cards/mastery/placeholder.png", "", "Spectre M4 mastery", "mastery", "tfa_ins2_spectre"}
    cardArray[136] = {"cards/mastery/placeholder.png", "", "Spike X15 mastery", "mastery", "tfa_ins2_saiga_spike"}
    cardArray[137] = {"cards/mastery/placeholder.png", "", "SR-2M Veresk mastery", "mastery", "tfa_ins2_sr2m_veresk"}
    cardArray[138] = {"cards/mastery/placeholder.png", "", "Sten Mk.II mastery", "mastery", "tfa_doisten"}
    cardArray[139] = {"cards/mastery/placeholder.png", "", "Stevens 620 mastery", "mastery", "tfa_nam_stevens620"}
    cardArray[140] = {"cards/mastery/steyraug.png", "Cute", "Steyr AUG mastery", "mastery", "tfa_inss_aug"}
    cardArray[141] = {"cards/mastery/placeholder.png", "", "StG44 mastery", "mastery", "tfa_doistg44"}
    cardArray[142] = {"cards/mastery/placeholder.png", "", "SV-98 mastery", "mastery", "tfa_ins2_sv98"}
    cardArray[143] = {"cards/mastery/placeholder.png", "", "S&W 500 mastery", "mastery", "tfa_ins2_s&w_500"}
    cardArray[144] = {"cards/mastery/placeholder.png", "", "Tanto mastery", "mastery", "tfa_japanese_exclusive_tanto"}
    cardArray[145] = {"cards/mastery/placeholder.png", "", "Tariq mastery", "mastery", "tfa_ins_sandstorm_tariq"}
    cardArray[146] = {"cards/mastery/placeholder.png", "", "Thompson M1928 mastery", "mastery", "tfa_doithompsonm1928"}
    cardArray[147] = {"cards/mastery/thompson.png", "Suicide", "Thompson M1A1 mastery", "mastery", "tfa_doithompsonm1a1"}
    cardArray[148] = {"cards/mastery/placeholder.png", "", "Type 81 mastery", "mastery", "tfa_ins2_type81"}
    cardArray[149] = {"cards/mastery/placeholder.png", "", "Typhoon F12 Custom mastery", "mastery", "tfa_ins2_typhoon12"}
    cardArray[150] = {"cards/mastery/placeholder.png", "", "UMP .45 mastery", "mastery", "tfa_ins2_ump45"}
    cardArray[151] = {"cards/mastery/placeholder.png", "", "UMP9 mastery", "mastery", "tfa_ins2_ump9"}
    cardArray[152] = {"cards/mastery/placeholder.png", "", "Uzi mastery", "mastery", "tfa_ins2_imi_uzi"}
    cardArray[153] = {"cards/mastery/placeholder.png", "", "UZK-BR99 mastery", "mastery", "tfa_ins2_br99"}
    cardArray[154] = {"cards/mastery/placeholder.png", "", "VHS-D2 mastery", "mastery", "tfa_ins2_vhsd2"}
    cardArray[155] = {"cards/mastery/placeholder.png", "", "Walther P99 mastery", "mastery", "tfa_ins2_walther_p99"}
    cardArray[156] = {"cards/mastery/placeholder.png", "", "XM8 mastery", "mastery", "tfa_ins2_xm8"}

	for k, v in pairs(cardArray) do
		if (args[1] == v[1]) then

			local cardID = v[1]
			local cardUnlock = v[4]
			local cardValue = v[5]

			if cardUnlock == "default" then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "kills" and ply:GetNWInt("playerKills") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "headshot" and ply:GetNWInt("playerAccoladeHeadshot") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "smackdown" and ply:GetNWInt("playerAccoladeSmackdown") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "clutch" and ply:GetNWInt("playerAccoladeClutch") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "longshot" and ply:GetNWInt("playerAccoladeLongshot") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "pointblank" and ply:GetNWInt("playerAccoladePointblank") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "killstreaks" and ply:GetNWInt("playerAccoladeOnStreak") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "buzzkills" and ply:GetNWInt("playerAccoladeBuzzkill") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

            if cardUnlock == "revenge" and ply:GetNWInt("playerAccoladeRevenge") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "color" then
				ply:SetNWString("chosenPlayercard", cardID)
			end

			if cardUnlock == "mastery" and ply:GetNWInt("killsWith_" .. cardValue) >= masteryUnlockReq then
				ply:SetNWString("chosenPlayercard", cardID)
			end
		end
	end
end
concommand.Add("tm_selectplayercard", PlayercardChange)

--Allows the player to spectate other players or to free roam at will using this command, or from the spectate dropdown in the Main Menu.
function StartCustomSpectate(ply, cmd, args)
	if (args[1] == "free") then
		ply:UnSpectate()
		ply:Spectate(OBS_MODE_ROAMING)
		ply:SetNWBool("isSpectating", true)
	elseif (args[1] == "player") then
		ply:UnSpectate()
		ply:SpectateEntity(args[2])
		ply:Spectate(OBS_MODE_IN_EYE)
		ply:SetNWBool("isSpectating", true)
	end
end
concommand.Add("tm_spectate", StartCustomSpectate)

--Sets a players profile picture offset for their playercard.
function PictureOffset(ply, cmd, args)
    local value = args[1]
    ply:SetNWInt("cardPictureOffset", value)
end
concommand.Add("tm_setcardpfpoffset", PictureOffset)