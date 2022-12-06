--Allows the player to save their local stats to the sv.db file without having to leave the server.
function ForceSave(ply, cmd, args)
    if GetConVar("tm_developermode"):GetInt() == 1 then return end
    ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
    ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
    ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
    ply:SetPData("playerScore", ply:GetNWInt("playerScore"))
    ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))
    ply:SetPData("playerLevel", ply:GetNWInt("playerLevel"))
    ply:SetPData("playerPrestige", ply:GetNWInt("playerPrestige"))
    ply:SetPData("playerXP", ply:GetNWInt("playerXP"))
    ply:SetPData("chosenPlayermodel", ply:GetNWString("chosenPlayermodel"))
    ply:SetPData("chosenPlayercard", ply:GetNWString("chosenPlayercard"))
    ply:SetPData("cardPictureOffset", ply:GetNWInt("cardPictureOffset"))
    ply:SetPData("playerAccoladeOnStreak", ply:GetNWInt("playerAccoladeOnStreak"))
    ply:SetPData("playerAccoladeBuzzkill", ply:GetNWInt("playerAccoladeBuzzkill"))
    ply:SetPData("playerAccoladeLongshot", ply:GetNWInt("playerAccoladeLongshot"))
    ply:SetPData("playerAccoladePointblank", ply:GetNWInt("playerAccoladePointblank"))
    ply:SetPData("playerAccoladeSmackdown", ply:GetNWInt("playerAccoladeSmackdown"))
    ply:SetPData("playerAccoladeHeadshot", ply:GetNWInt("playerAccoladeHeadshot"))
    ply:SetPData("playerAccoladeClutch", ply:GetNWInt("playerAccoladeClutch"))
    print("Save was successful!")
end
concommand.Add("tm_forcesave", ForceSave)

--Allows the Main Menu to change the players current playermodel.
function PlayerModelChange(ply, cmd, args)
	for k, v in pairs(modelArray) do
		if (args[1] == v[1]) then

			local modelID = v[1]
			local modelUnlock = v[4]
			local modelValue = v[5]

			if modelUnlock == "default" then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

			if modelUnlock == "kills" and ply:GetNWInt("playerKills") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

			if modelUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

            if modelUnlock == "headshot" and ply:GetNWInt("playerAccoladeHeadshot") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

			if modelUnlock == "smackdown" and ply:GetNWInt("playerAccoladeSmackdown") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

			if modelUnlock == "clutch" and ply:GetNWInt("playerAccoladeClutch") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

			if modelUnlock == "longshot" and ply:GetNWInt("playerAccoladeLongshot") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

			if modelUnlock == "pointblank" and ply:GetNWInt("playerAccoladePointblank") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

			if modelUnlock == "killstreaks" and ply:GetNWInt("playerAccoladeOnStreak") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

			if modelUnlock == "buzzkills" and ply:GetNWInt("playerAccoladeBuzzkill") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

			if modelUnlock == "special" and modelValue == "name" and ply:SteamID() == "STEAM_0:1:514443768" then
				ply:SetNWString("chosenPlayermodel", modelID)
			end

            if modelUnlock == "special" and modelValue == "beta" and ply:GetNWInt("playerBetaTimePlayed") == 10800 then
				ply:SetNWString("chosenPlayermodel", modelID)
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

    for k, v in pairs(cardArray) do
		if (args[1] == v[1]) then

			local cardID = v[1]
			local cardUnlock = v[4]
			local cardValue = v[5]
            local playerTotalLevel = (ply:GetNWInt("playerPrestige") * 60) + ply:GetNWInt("playerLevel")

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

            if cardUnlock == "level" and playerTotalLevel >= cardValue then
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
	end
end
concommand.Add("tm_spectate", StartCustomSpectate)

--Sets a players profile picture offset for their playercard.
function PictureOffset(ply, cmd, args)
    local value = args[1]
    ply:SetNWInt("cardPictureOffset", value)
end
concommand.Add("tm_setcardpfpoffset", PictureOffset)

--Allows the player to prestige if they have hit the max level cap (Level 60).
function PlayerPrestige(ply, cmd, args)
	if ply:GetNWInt("playerLevel") == 60 then
        ply:SetNWInt("playerLevel", 1)
        ply:SetNWInt("playerPrestige", ply:GetNWInt("playerPrestige") + 1)
        ply:SetNWInt("playerXP", 0)
        ply:SetNWInt("playerXPToNextLevel", 750)
	end
end
concommand.Add("tm_prestige", PlayerPrestige)