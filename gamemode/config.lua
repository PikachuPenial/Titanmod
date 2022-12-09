--[[
    Titanmod Config File
    This is primarily for server owners that are trying to fine tune their experience.
    If you do not understand what a certain setting does, I would recommend not changing it.
]]--

--PLAYER
playerHealth = 100              --The the max health of the player.
playerSpeedMulti = 1            --The speed multipler of the player (affects walking, sprinting, crouching, sliding, and climbing speeds.)
healthRegenSpeed = 0.15         --The speed of the players health regeneration.
healthRegenDamageDelay = 3.5    --The time in seconds from when the player was last hit to begin health regeneration.

--MAPS
--If you want to use custom maps, or want to add or remove certain maps, edit this array.
--Map Array Formatting (Map ID, map name, map description, map thumbnail image.)
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

availableMaps = {"skip"} -- "skip" will have the map vote end in a continue if it ties with another map, requiring a majority vote for a new map.
for m, v in pairs(mapArray) do
    if game.GetMap() ~= v[1] and v[1] ~= "tm_firingrange" then
        table.insert(availableMaps, v[1])
    end
end

--WEAPONS
--If you want to use custom weapons, or want to add or remove certain weapons, edit this array.
--Formatting (Item ID, print name, category.)
weaponArray = {}
weaponArray[1] = {"tfa_ins2_aa12", "AA-12", "primary"}
weaponArray[2] = {"tfa_ins2_acrc", "ACR-C", "primary"}
weaponArray[3] = {"tfa_ins2_aek971", "AEK-971", "primary"}
weaponArray[4] = {"tfa_ins2_akms", "AKMS", "primary"}
weaponArray[5] = {"tfa_inss_aks74u", "AKS-74U", "primary"}
weaponArray[6] = {"tfa_ismc_ak12_rpk", "AK-12 RPK", "primary"}
weaponArray[7] = {"tfa_ins2_ak400", "AK-400", "primary"}
weaponArray[8] = {"tfa_ins2_warface_amp_dsr1", "AMP DSR-1", "primary"}
weaponArray[9] = {"tfa_ins2_abakan", "AN-94", "primary"}
weaponArray[10] = {"tfa_ins2_cw_ar15", "AR-15", "primary"}
weaponArray[11] = {"tfa_ins2_ar57", "AR-57", "primary"}
weaponArray[12] = {"tfa_at_shak_12", "ASh-12", "primary"}
weaponArray[13] = {"tfa_inss_asval", "AS-VAL", "primary"}
weaponArray[14] = {"tfa_ins2_warface_awm", "AWM", "primary"}
weaponArray[15] = {"tfa_ins2_warface_ax308", "AX-308", "primary"}
weaponArray[16] = {"tfa_ins2_barrett_m98_bravo", "Barrett M98B", "primary"}
weaponArray[17] = {"tfa_ins2_mx4", "Beretta Mx4", "primary"}
weaponArray[18] = {"tfa_doibren", "Bren", "primary"}
weaponArray[19] = {"tfa_ins2_warface_bt_mp9", "B&T MP9", "primary"}
weaponArray[20] = {"tfa_ins2_warface_cheytac_m200", "CheyTac M200", "primary"}
weaponArray[21] = {"tfa_ins2_m4_9mm", "Colt 9mm", "primary"}
weaponArray[22] = {"tfa_new_m1911", "Colt M1911", "secondary"}
weaponArray[23] = {"tfa_ins2_colt_m45", "Colt M45A1", "secondary"}
weaponArray[24] = {"tfa_ins2_cz75", "CZ 75 B", "secondary"}
weaponArray[25] = {"tfa_ins2_cz805", "CZ 805", "primary"}
weaponArray[26] = {"tfa_ins2_ddm4v5", "DDM4V5", "primary"}
weaponArray[27] = {"tfa_ins2_deagle", "Desert Eagle", "secondary"}
weaponArray[28] = {"tfa_ins2_famas", "Famas F1", "primary"}
weaponArray[29] = {"tfa_blast_lynx_msbsb", "FB MSBS-B", "primary"}
weaponArray[30] = {"tfa_doifg42", "FG 42", "primary"}
weaponArray[31] = {"tfa_ins2_fiveseven_eft", "Fiveseven", "secondary"}
weaponArray[32] = {"tfa_ins2_fn_2000", "FN 2000", "primary"}
weaponArray[33] = {"tfa_ins2_fn_fal", "FN FAL", "primary"}
weaponArray[34] = {"tfa_ins2_fnp45", "FNP-45", "secondary"}
weaponArray[35] = {"tfa_ins2_g28", "G28", "primary"}
weaponArray[36] = {"tfa_new_inss_galil", "Galil", "primary"}
weaponArray[37] = {"tfa_new_glock17", "Glock 17", "secondary"}
weaponArray[38] = {"fres_grapple", "Grappling Hook", "gadget"}
weaponArray[39] = {"tfa_ins2_gsh18", "GSH-18", "secondary"}
weaponArray[40] = {"tfa_ins2_cq300", "Honey Badger", "primary"}
weaponArray[41] = {"tfa_howa_type_64", "Howa Type 64", "primary"}
weaponArray[42] = {"tfa_ins2_hk_mg36", "H&K MG36", "primary"}
weaponArray[43] = {"tfa_inss2_hk_mp5a5", "H&K MP5A5", "primary"}
weaponArray[44] = {"tfa_ins2_imbelia2", "Imbel IA2", "primary"}
weaponArray[45] = {"tfa_ins2_izh43sw", "IZH-43 Sawed Off", "secondary"}
weaponArray[46] = {"tfa_ararebo_bf1", "Japanese Ararebo", "melee"}
weaponArray[47] = {"tfa_km2000_knife", "KM-2000", "melee"}
weaponArray[48] = {"tfa_ins2_krissv", "KRISS Vector", "primary"}
weaponArray[49] = {"tfa_ins2_ksg", "KSG", "primary"}
weaponArray[50] = {"tfa_blast_ksvk_cqb", "KSVK 12.7", "primary"}
weaponArray[51] = {"tfa_doi_enfield", "Lee-Enfield No. 4", "primary"}
weaponArray[52] = {"tfa_doilewis", "Lewis", "primary"}
weaponArray[53] = {"tfa_ins2_zm_lr300", "LR-300", "primary"}
weaponArray[54] = {"tfa_doi_garand", "M1 Garand", "primary"}
weaponArray[55] = {"tfa_doim3greasegun", "M3 Grease Gun", "secondary"}
weaponArray[56] = {"tfa_ins2_m9", "M9", "secondary"}
weaponArray[57] = {"tfa_ins2_m14retro", "M14", "primary"}
weaponArray[58] = {"tfa_nam_m79", "M79", "primary"}
weaponArray[59] = {"tfa_doim1918", "M1918", "primary"}
weaponArray[60] = {"tfa_doim1919", "M1919", "primary"}
weaponArray[61] = {"bocw_mac10_alt", "Mac 10", "secondary"}
weaponArray[62] = {"tfa_inss_makarov", "Makarov", "secondary"}
weaponArray[63] = {"tfa_tfre_maresleg", "Mare's Leg", "secondary"}
weaponArray[64] = {"tfa_fml_lefrench_mas38", "Mas 38", "primary"}
weaponArray[65] = {"tfa_doimg34", "MG 34", "primary"}
weaponArray[66] = {"tfa_doimg42", "MG 42", "primary"}
weaponArray[67] = {"tfa_ins2_minimi", "Minimi Para", "primary"}
weaponArray[68] = {"tfa_ins2_mk23", "MK 23", "secondary"}
weaponArray[69] = {"tfa_fml_inss_mk18", "MK18", "primary"}
weaponArray[70] = {"tfa_ins2_mk14ebr", "Mk. 14 EBR", "primary"}
weaponArray[71] = {"tfa_ins2_swmodel10", "Model 10", "secondary"}
weaponArray[72] = {"tfa_ins2_mosin_nagant", "Mosin Nagant", "primary"}
weaponArray[73] = {"tfa_doimp40", "MP 40", "primary"}
weaponArray[74] = {"tfa_ins2_mp443", "MP-443", "secondary"}
weaponArray[75] = {"tfa_ins2_mp5k", "MP5K", "secondary"}
weaponArray[76] = {"tfa_inss_mp7_new", "MP7A1", "primary"}
weaponArray[77] = {"tfa_ww1_mp18", "MP18", "primary"}
weaponArray[78] = {"tfa_ins2_mr96", "MR-96", "secondary"}
weaponArray[79] = {"tfa_ins2_mc255", "MTs225-12", "primary"}
weaponArray[80] = {"tfa_ins2_nova", "Nova", "primary"}
weaponArray[81] = {"tfa_ins2_warface_orsis_t5000", "Orsis T-5000", "primary"}
weaponArray[82] = {"tfa_l4d2_osp18", "OSP-18", "secondary"}
weaponArray[83] = {"tfa_ins2_groza", "OTs-14 Groza", "primary"}
weaponArray[84] = {"tfa_ins2_ots_33_pernach", "OTs-33 Pernach", "secondary"}
weaponArray[85] = {"tfa_doiowen", "Owen Mk.I", "primary"}
weaponArray[86] = {"tfa_fml_p90_tac", "P90", "primary"}
weaponArray[87] = {"tfa_blast_pindadss2", "PINDAD SS2-V1", "primary"}
weaponArray[88] = {"tfa_ins2_pm9", "PM-9", "primary"}
weaponArray[89] = {"tfa_nam_ppsh41", "PPSH-41", "primary"}
weaponArray[90] = {"tfa_fas2_ppbizon", "PP-Bizon", "primary"}
weaponArray[91] = {"tfa_ww2_pbz39", "PzB 39", "primary"}
weaponArray[92] = {"tfa_ins2_norinco_qbz97", "QBZ-97", "primary"}
weaponArray[93] = {"tfa_ins2_qsz92", "QSZ-92", "secondary"}
weaponArray[94] = {"tfa_ins2_remington_m870", "Remington M870", "primary"}
weaponArray[95] = {"tfa_ins2_pd2_remington_msr", "Remington MSR", "primary"}
weaponArray[96] = {"tfa_ins2_rfb", "RFB", "primary"}
weaponArray[97] = {"tfa_fml_rk62", "RK62", "primary"}
weaponArray[98] = {"tfa_ins2_rpg7_scoped", "RPG-7", "primary"}
weaponArray[99] = {"tfa_ins2_rpk_74m", "RPK-74M", "primary"}
weaponArray[100] = {"tfa_ins2_l85a2", "SA80", "primary"}
weaponArray[101] = {"tfa_ins2_scar_h_ssr", "SCAR-H", "primary"}
weaponArray[102] = {"tfa_ins2_sc_evo", "Scorpion Evo", "primary"}
weaponArray[103] = {"tfa_new_p226", "SIG P226", "secondary"}
weaponArray[104] = {"tfa_ins2_sks", "SKS", "primary"}
weaponArray[105] = {"tfa_ins2_spas12", "SPAS-12", "primary"}
weaponArray[106] = {"tfa_ins2_spectre", "Spectre M4", "primary"}
weaponArray[107] = {"tfa_ins2_saiga_spike", "Spike X15", "primary"}
weaponArray[108] = {"tfa_ins2_sr2m_veresk", "SR-2M Veresk", "primary"}
weaponArray[109] = {"tfa_doisten", "Sten Mk.II", "primary"}
weaponArray[110] = {"tfa_nam_stevens620", "Stevens 620", "primary"}
weaponArray[111] = {"tfa_inss_aug", "Steyr AUG", "primary"}
weaponArray[112] = {"tfa_doistg44", "StG44", "primary"}
weaponArray[113] = {"tfa_ins2_sv98", "SV-98", "primary"}
weaponArray[114] = {"tfa_ins2_s&w_500", "S&W 500", "secondary"}
weaponArray[115] = {"tfa_japanese_exclusive_tanto", "Tanto", "melee"}
weaponArray[116] = {"tfa_ins_sandstorm_tariq", "Tariq", "secondary"}
weaponArray[117] = {"st_stim_pistol", "TCo Stim Pistol", "secondary"}
weaponArray[118] = {"tfa_doithompsonm1928", "Thompson M1928", "primary"}
weaponArray[119] = {"tfa_doithompsonm1a1", "Thompson M1A1", "primary"}
weaponArray[120] = {"tfa_ins2_type81", "Type 81", "primary"}
weaponArray[121] = {"tfa_ins2_typhoon12", "Typhoon F12", "primary"}
weaponArray[122] = {"tfa_ins2_ump45", "UMP .45", "primary"}
weaponArray[123] = {"tfa_ins2_ump9", "UMP9", "primary"}
weaponArray[124] = {"tfa_ins2_imi_uzi", "Uzi", "secondary"}
weaponArray[125] = {"tfa_ins2_br99", "UZK-BR99", "primary"}
weaponArray[126] = {"tfa_ins2_vhsd2", "VHS-D2", "primary"}
weaponArray[127] = {"tfa_ins2_walther_p99", "Walther P99", "secondary"}
weaponArray[128] = {"tfa_ins2_xm8", "XM8", "primary"}