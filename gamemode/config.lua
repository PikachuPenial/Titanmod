--[[
    Titanmod Config File
    This is primarily for server owners that are trying to fine tune their experience.
    If you do not understand what a certain setting does, I would recommend not changing it.
]]--

--Player settings
playerHealth = 100              --The max health of the player.
playerSpeedMulti = 1            --The multiplier for the speed of the player (affects walking, sprinting, crouching, sliding, and ladder climbing speeds.)
playerGravityMulti = 1          --The multiplier for the strength of gravity affecting the player.
playerJumpMulti = 1             --The multiplier for the strength of the players jump.
playerDuckStateMulti = 1        --The multiplier of the speed at which the player enters/exits a crocuh after the key is pressed/released.
playerCrouchWalkSpeedMulti = 1  --The multiplier of the players wakling speed while crouched.
playerSlideSpeedMulti = 1.55    --The multiplier of the players speed while sliding.
playerSlideDuration = 1         --The time (in seconds) that a players slide lasts.
healthRegeneration = true       --Enable or disable health regeneration on players after not taking damage for a set amount of time.
healthRegenSpeed = 0.15         --The speed of the players health regeneration.
healthRegenDamageDelay = 3.5    --The time (in seconds) from when the player was last hit to begin health regeneration.
playerRespawnTime = 4           --The time (in seconds) that it takes for a player to respawn.

--Progression settings
forceDisableProgression = false --Any progress or unlocks made during a play session will be reset upon leaving.
xpMultiplier = 1                --Multiplies all sources of XP (kills, accolades, and more.)

--FFA settings
usePrimary = true               --Enable primary weapons for the players loadout.
useSecondary = true             --Enable secondary weapons for the players loadout.
useMelee = true                 --Enable melee weapons/gadgets  for the players loadout.
grenadesOnSpawn = 1             --The amount of grenades that a player is given on spawn.
grappleCooldown = 18            --The cooldown (in sceonds) of the grappling hook after being used.

--Gun Game settings
ggLadderSize = 24                 --Sets the amount of weapons a player needs to get kills with to win a match.

--Mechanic settings
grappleKillReset = true         --Enable or disable the grapple cooldown reset on a player kill.
grappleRange = 850              --The length (in units) that the grappling hook can travel too before despawning.
rocketJumping = true            --Enable or disable rocket jumping (knockback and less damage from self-inflicted explosive damage.)
rocketJumpForceMulti = 1        --The multiplier of the force applied on a player during a rocket jump.
damageKnockback = false         --Enable or disable knockback from incoming damage (being moved from other players bullets.)
proxChatRange = 750             --The thresehold in distance where players can hear other players over proximity voice chat.

--Feature settings
killFeed = true                 --Enables the kill feed.
suicidesInFeed = true           --Enables the broadcasting of a player(s) suicide in the kill feed.
allowSpectating = true          --Enables the ability for players to enter a free-cam spectating state through the Main Menu.
forceEnableWepSpawner = false   --Enables the Firing Range scoreboard weapon spawner for all maps.

--Optimization settings
mapCleanupTime = 30             --The interval (in seconds) at which the map is cleared of decals (blood, bullet impacts.) I would not recommend going below 30 seconds.
forceEnableAutoSaveTime = 0     --Enables auto saving and the interval (in seconds) for each save, could be heavy on server performance. Set this to 0 to disable auto saving.

matchLengthTime = GetConVar("tm_matchlengthtimer"):GetInt()    --The time in seconds until a map vote starts, can be replaced with a whole number to override the ConVar.

--GAMEMODES
--Don't mess with this, there is not a way to create or easily modify gamemodes at the current moment. Any changable gamemode settings will be found above.
gamemodeArray = {}
gamemodeArray[1] = {0, "FFA"}
--gamemodeArray[2] = {1, "Fiesta"}
gamemodeArray[2] = {2, "Gun Game"}

--MAPS
--If you want to use custom maps, or want to add or remove certain maps, edit this array.
--Map Array Formatting (map ID, map name, map thumbnail image)
--The fourth key either allows/disallows the maps entry into the map pool, set this to false if you don't want a map showing up in map votes.
--The fifth key will stop a map from showing up in map votes if the player count surpasses the set value, setting this to 0 will make a map always be available in the map pool.
mapArray = {}
mapArray[1] = {"tm_arctic", "Arctic", "maps/thumb/tm_arctic.png", true, 0}
mapArray[2] = {"tm_bridge", "Bridge", "maps/thumb/tm_bridge.png", true, 0}
mapArray[3] = {"tm_corrugated", "Corrugated", "maps/thumb/tm_corrugated.png", true, 0}
mapArray[4] = {"tm_devtown", "Devtown", "maps/thumb/tm_devtown.png", true, 0}
mapArray[5] = {"tm_disequilibrium_test", "Disequilibrium", "maps/thumb/tm_disequilibrium_test.png", true, 0}
mapArray[6] = {"tm_firingrange", "Firing Range", "maps/thumb/tm_firingrange.png", false, 0} --Do not set the fourth key to true, that would be very retarded.
mapArray[7] = {"tm_hydro", "Hydro", "maps/thumb/tm_hydro.png", true, 0}
mapArray[8] = {"tm_initial", "Initial", "maps/thumb/tm_initial.png", true, 5}
mapArray[9] = {"tm_liminal_pool", "Liminal Pool", "maps/thumb/tm_liminal_pool.png", true, 0}
mapArray[10] = {"tm_mall", "Mall", "maps/thumb/tm_mall.png", true, 0}
mapArray[11] = {"tm_mephitic", "Mephitic", "maps/thumb/tm_mephitic.png", true, 0}
mapArray[12] = {"tm_nuketown", "Nuketown", "maps/thumb/tm_nuketown.png", true, 5}
mapArray[13] = {"tm_rig", "Rig", "maps/thumb/tm_rig.png", true, 0}
mapArray[14] = {"tm_sanctuary", "Sanctuary", "maps/thumb/tm_sanctuary.png", true, 0}
mapArray[15] = {"tm_shipment", "Shipment", "maps/thumb/tm_shipment.png", true, 5}
mapArray[16] = {"tm_villa", "Villa", "maps/thumb/tm_villa.png", true, 0}

availableMaps = {}
for m, v in pairs(mapArray) do
    if v[4] == true then table.insert(availableMaps, v[1]) end
end

--WEAPONS
--If you want to use custom weapons, or want to add or remove certain weapons, edit this array.
--Formatting (Item ID, print name, category.)
weaponArray = {}
weaponArray[1] = {"tfa_ins2_aa12", "AA-12", "primary", "rifle"}
weaponArray[2] = {"tfa_ins2_acrc", "ACR-C", "primary", "rifle"}
weaponArray[3] = {"tfa_ins2_aek971", "AEK-971", "primary", "rifle"}
weaponArray[4] = {"tfa_ins2_akms", "AKMS", "primary", "rifle"}
weaponArray[5] = {"tfa_ins2_aks_r", "AKS-74U", "primary", "smg"}
weaponArray[6] = {"tfa_ins2_ak12", "AK-12", "primary", "rifle"}
weaponArray[7] = {"tfa_ins2_ak400", "AK-400", "primary", "rifle"}
weaponArray[8] = {"tfa_ins2_abakan", "AN-94", "primary", "rifle"}
weaponArray[9] = {"tfa_ins2_ar57", "AR-57", "primary", "smg"}
weaponArray[10] = {"tfa_blast_ash12", "ASh-12", "primary", "rifle"}
weaponArray[11] = {"tfa_fml_csgo_aug", "AUG A3", "primary", "rifle"}
weaponArray[12] = {"tfa_inss_asval", "AS-VAL", "primary", "rifle"}
weaponArray[13] = {"tfa_cod_accuracy_international_l115a3", "AWM", "primary", "sniper"}
weaponArray[14] = {"tfa_ins2_warface_ax308", "AX-308", "primary", "sniper"}
weaponArray[15] = {"tfa_ins2_barrett_m98_bravo", "Barrett M98B", "primary", "sniper"}
weaponArray[16] = {"tfa_ins2_mx4", "Beretta Mx4", "primary", "smg"}
weaponArray[17] = {"rust_bow", "Bow", "secondary", "sniper"}
weaponArray[18] = {"tfa_doibren", "Bren", "primary", "lmg"}
weaponArray[19] = {"tfa_ins2_warface_bt_mp9", "B&T MP9", "primary", "smg"}
weaponArray[20] = {"tfa_ins2_warface_cheytac_m200", "CheyTac M200", "primary", "sniper"}
weaponArray[21] = {"tfa_ins2_m4_9mm", "Colt 9mm", "primary", "smg"}
weaponArray[22] = {"tfa_nam_m1911", "Colt M1911", "secondary", "pistol"}
weaponArray[23] = {"tfa_ins2_colt_m45", "Colt M45A1", "secondary", "pistol"}
weaponArray[24] = {"rust_crossbow", "Crossbow", "primary", "sniper"}
weaponArray[25] = {"tfa_ins2_cz75", "CZ 75 B", "secondary", "pistol"}
weaponArray[26] = {"tfa_ins2_cz805", "CZ 805", "primary", "rifle"}
weaponArray[27] = {"tfa_ins2_ddm4v5", "DDM4V5", "primary", "rifle"}
weaponArray[28] = {"tfa_ins2_deagle", "Desert Eagle", "secondary", "pistol"}
weaponArray[29] = {"tfa_ins2_warface_amp_dsr1", "DSR-1", "primary", "sniper"}
weaponArray[30] = {"tfa_l4d2_skorpion_dual", "Dual Skorpions", "primary", "pistol"}
weaponArray[31] = {"tfa_ins2_famas", "Famas F1", "primary", "rifle"}
weaponArray[32] = {"tfa_blast_lynx_msbsb", "FB MSBS-B", "primary", "rifle"}
weaponArray[33] = {"tfa_doifg42", "FG 42", "primary", "lmg"}
weaponArray[34] = {"tfa_ins2_fiveseven_eft", "Fiveseven", "secondary", "pistol"}
weaponArray[35] = {"tfa_ins2_fn_2000", "FN 2000", "primary", "rifle"}
weaponArray[36] = {"tfa_ins2_fn_fal", "FN FAL", "primary", "rifle"}
weaponArray[37] = {"tfa_ins2_fnp45", "FNP-45", "secondary", "pistol"}
weaponArray[38] = {"tfa_ins2_g28", "G28", "primary", "rifle"}
weaponArray[39] = {"tfa_ins2_g36a1", "G36A1", "primary", "rifle"}
weaponArray[40] = {"tfa_glk_gen4", "Glock 17", "secondary", "pistol"}
weaponArray[41] = {"fres_grapple", "Grappling Hook", "gadget"}
weaponArray[42] = {"tfa_ins2_gsh18", "GSH-18", "secondary", "pistol"}
weaponArray[43] = {"tfa_ins2_fml_hk53", "HK53", "primary", "lmg"}
weaponArray[44] = {"tfa_ins2_cq300", "Honey Badger", "primary", "rifle"}
weaponArray[45] = {"tfa_howa_type_64", "Howa Type 64", "primary", "rifle"}
weaponArray[46] = {"tfa_ins2_imbelia2", "Imbel IA2", "primary", "rifle"}
weaponArray[47] = {"tfa_ararebo_bf1", "Japanese Ararebo", "melee"}
weaponArray[48] = {"tfa_km2000_knife", "KM-2000", "melee"}
weaponArray[49] = {"tfa_ins2_krissv", "KRISS Vector", "primary", "smg"}
weaponArray[50] = {"tfa_ins2_ksg", "KSG", "primary", "shotgun"}
weaponArray[51] = {"tfa_blast_ksvk_cqb", "KSVK 12.7", "primary", "sniper"}
weaponArray[52] = {"tfa_doi_enfield", "Lee-Enfield No. 4", "primary", "sniper"}
weaponArray[53] = {"tfa_doilewis", "Lewis", "primary", "lmg"}
weaponArray[54] = {"tfa_ins2_zm_lr300", "LR-300", "primary", "rifle"}
weaponArray[55] = {"tfa_doi_garand", "M1 Garand", "primary", "rifle"}
weaponArray[56] = {"tfa_doim3greasegun", "M3 Grease Gun", "secondary", "smg"}
weaponArray[57] = {"tfa_ins2_eftm4a1", "M4A1", "primary", "rifle"}
weaponArray[58] = {"tfa_ins2_m9", "M9", "secondary", "pistol"}
weaponArray[59] = {"tfa_ins2_m14retro", "M14", "primary", "rifle"}
weaponArray[60] = {"tfa_nam_m79", "M79", "primary", "explosive"}
weaponArray[61] = {"tfa_doim1918", "M1918", "primary", "lmg"}
weaponArray[62] = {"tfa_doim1919", "M1919", "primary", "lmg"}
weaponArray[63] = {"tfa_ins2_minimi", "M249", "primary", "lmg"}
weaponArray[64] = {"bocw_mac10_alt", "Mac 10", "secondary", "smg"}
weaponArray[65] = {"tfa_ins2_pm", "Makarov", "secondary", "pistol"}
weaponArray[66] = {"tfa_tfre_maresleg", "Mare's Leg", "secondary", "pistol"}
weaponArray[67] = {"tfa_fml_lefrench_mas38", "Mas 38", "primary", "smg"}
weaponArray[68] = {"tfa_doimg34", "MG 34", "primary", "lmg"}
weaponArray[69] = {"tfa_doimg42", "MG 42", "primary", "lmg"}
weaponArray[70] = {"tfa_ins2_mk23", "MK 23", "secondary", "pistol"}
weaponArray[71] = {"tfa_fml_inss_mk18", "MK18", "primary", "rifle"}
weaponArray[72] = {"tfa_ins2_mk14ebr", "Mk 14 EBR", "primary", "rifle"}
weaponArray[73] = {"tfa_ins2_swmodel10", "Model 10", "secondary", "pistol"}
weaponArray[74] = {"tfa_ins2_mosin_nagant", "Mosin Nagant", "primary", "sniper"}
weaponArray[75] = {"tfa_doimp40", "MP 40", "primary", "smg"}
weaponArray[76] = {"tfa_ins2_mp443", "MP-443", "secondary", "pistol"}
weaponArray[77] = {"tfa_ins2_mp5k", "MP5K", "secondary", "smg"}
weaponArray[78] = {"tfa_ins2_mp7", "MP7A1", "primary", "smg"}
weaponArray[79] = {"tfa_ww1_mp18", "MP18", "primary", "smg"}
weaponArray[80] = {"tfa_inss2_hk_mp5a5", "MP5", "primary", "smg"}
weaponArray[81] = {"tfa_ins2_mr96", "MR-96", "secondary", "pistol"}
weaponArray[82] = {"tfa_ins2_mc255", "MTs225-12", "primary", "shotgun"}
weaponArray[83] = {"tfa_ins2_nova", "Nova", "primary", "shotgun"}
weaponArray[84] = {"tfa_ins2_warface_orsis_t5000", "Orsis T-5000", "primary", "sniper"}
weaponArray[85] = {"tfa_l4d2_osp18", "OSP-18", "secondary", "pistol"}
weaponArray[86] = {"tfa_ins2_groza", "OTs-14 Groza", "primary", "rifle"}
weaponArray[87] = {"tfa_ins2_ots_33_pernach", "OTs-33 Pernach", "secondary", "pistol"}
weaponArray[88] = {"tfa_doiowen", "Owen Mk.I", "primary", "smg"}
weaponArray[89] = {"tfa_fml_p90_tac", "P90", "primary", "smg"}
weaponArray[90] = {"tfa_blast_pindadss2", "PINDAD SS2-V1", "primary", "rifle"}
weaponArray[91] = {"tfa_ins2_pm9", "PM-9", "primary", "smg"}
weaponArray[92] = {"tfa_nam_ppsh41", "PPSH-41", "primary", "smg"}
weaponArray[93] = {"tfa_fas2_ppbizon", "PP-19 Bizon", "primary", "smg"}
weaponArray[94] = {"tfa_ww2_pbz39", "PzB 39", "primary", "sniper"}
weaponArray[95] = {"tfa_ins2_norinco_qbz97", "QBZ-97", "primary", "rifle"}
weaponArray[96] = {"tfa_ins2_qsz92", "QSZ-92", "secondary", "pistol"}
weaponArray[97] = {"tfa_ins2_remington_m870", "Remington M870", "primary", "shotgun"}
weaponArray[98] = {"tfa_ins2_pd2_remington_msr", "Remington MSR", "primary", "sniper"}
weaponArray[99] = {"tfa_ins2_rfb", "RFB", "primary", "rifle"}
weaponArray[100] = {"swat_shield", "Riot Shield", "secondary", "melee"}
weaponArray[101] = {"tfa_fml_rk62", "RK62", "primary", "rifle"}
weaponArray[102] = {"tfa_ins2_rpg7_scoped", "RPG-7", "primary", "explosive"}
weaponArray[103] = {"tfa_ins2_rpk_74m", "RPK-74M", "primary", "lmg"}
weaponArray[104] = {"tfa_ins2_l85a2", "SA80", "primary", "rifle"}
weaponArray[105] = {"tfa_ins2_izh43sw", "Sawed Off", "secondary", "shotgun"}
weaponArray[106] = {"tfa_ins2_scar_h_ssr", "SCAR-H", "primary", "rifle"}
weaponArray[107] = {"tfa_ins2_sc_evo", "Scorpion Evo", "primary", "smg"}
weaponArray[108] = {"tfa_ins2_p320_m18", "SIG P320", "secondary", "pistol"}
weaponArray[109] = {"tfa_l4d2_skorpion", "Skorpion", "secondary", "pistol"}
weaponArray[110] = {"tfa_ins2_sks", "SKS", "primary", "rifle"}
weaponArray[111] = {"tfa_ins2_spas12", "SPAS-12", "primary", "shotgun"}
weaponArray[112] = {"tfa_ins2_spectre", "Spectre M4", "primary", "smg"}
weaponArray[113] = {"tfa_ins2_saiga_spike", "Spike X15", "primary", "shotgun"}
weaponArray[114] = {"tfa_ins2_sr2m_veresk", "SR-2M Veresk", "primary", "smg"}
weaponArray[115] = {"tfa_doisten", "Sten Mk.II", "primary", "smg"}
weaponArray[116] = {"tfa_nam_stevens620", "Stevens 620", "primary", "shotgun"}
weaponArray[117] = {"tfa_doistg44", "StG44", "primary", "rifle"}
weaponArray[118] = {"tfa_ins2_sv98", "SV-98", "primary", "sniper"}
weaponArray[119] = {"tfa_ins2_s&w_500", "S&W 500", "secondary", "pistol"}
weaponArray[120] = {"tfa_japanese_exclusive_tanto", "Tanto", "melee"}
weaponArray[121] = {"tfa_ins_sandstorm_tariq", "Tariq", "secondary", "9x19"}
weaponArray[122] = {"st_stim_pistol", "TCo Stim Pistol", "secondary", "pistol"}
weaponArray[123] = {"tfa_doithompsonm1928", "Thompson M1928", "primary", "smg"}
weaponArray[124] = {"tfa_doithompsonm1a1", "Thompson M1A1", "primary", "smg"}
weaponArray[125] = {"tfa_ins2_type81", "Type 81", "primary", "rifle"}
weaponArray[126] = {"tfa_ins2_typhoon12", "Typhoon F12", "primary", "shotgun"}
weaponArray[127] = {"tfa_ins2_ump45", "UMP .45", "primary", "smg"}
weaponArray[128] = {"tfa_ins2_ump9", "UMP9", "primary", "smg"}
weaponArray[129] = {"tfa_ins2_usp_match", "USP", "secondary", "pistol"}
weaponArray[130] = {"tfa_ins2_imi_uzi", "Uzi", "secondary", "smg"}
weaponArray[131] = {"tfa_ins2_br99", "UZK-BR99", "primary", "shotgun"}
weaponArray[132] = {"tfa_ins2_vhsd2", "VHS-D2", "primary", "rifle"}
weaponArray[133] = {"tfa_ins2_walther_p99", "Walther P99", "secondary", "pistol"}
weaponArray[134] = {"tfa_doi_webley", "Webley", "secondary", "pistol"}
weaponArray[135] = {"tfa_ins2_xm8", "XM8", "primary", "rifle"}

--CONVARS
if SERVER then
    --Noclip
    RunConsoleCommand("sbox_noclip", "0")

    --Dynamic Height
    RunConsoleCommand("sv_ec2_dynamicheight", "0")
    RunConsoleCommand("sv_ec2_dynamicheight_min", "42")
    RunConsoleCommand("sv_ec2_dynamicheight_max", "64")

    --Sliding
    RunConsoleCommand("sv_qslide_duration", playerSlideDuration)
    RunConsoleCommand("sv_qslide_speedmult", playerSlideSpeedMulti)

    --Player Acceleration
    RunConsoleCommand("sv_airaccelerate", "1000")

    --Gunplay Specific TFA Configuration
    RunConsoleCommand("sv_tfa_damage_multiplier", "1.05")
    RunConsoleCommand("sv_tfa_recoil_mul_p", "1")
    RunConsoleCommand("sv_tfa_recoil_mul_p_npc", "1")
    RunConsoleCommand("sv_tfa_recoil_mul_y", "1")
    RunConsoleCommand("sv_tfa_recoil_mul_y_npc", "1")
    RunConsoleCommand("sv_tfa_recoil_viewpunch_mul", "1")
    RunConsoleCommand("sv_tfa_spread_multiplier", "0.55")

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
    RunConsoleCommand("sv_tfa_bullet_penetration_power_mul", "1.25")
    RunConsoleCommand("sv_tfa_bullet_randomseed", "0")
    RunConsoleCommand("sv_tfa_bullet_ricochet", "0")
    RunConsoleCommand("sv_tfa_cmenu", "1")
    RunConsoleCommand("sv_tfa_crosshair_showplayer", "0")
    RunConsoleCommand("sv_tfa_crosshair_showplayerteam", "0")
    RunConsoleCommand("sv_tfa_damage_mult_max", "1")
    RunConsoleCommand("sv_tfa_damage_mult_min", "1")
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
    RunConsoleCommand("sv_tfa_melee_damage_ply", "0.85")
    RunConsoleCommand("sv_tfa_nearlyempty", "1")
    RunConsoleCommand("sv_tfa_npc_burst", "0")
    RunConsoleCommand("sv_tfa_npc_randomize_atts", "0")
    RunConsoleCommand("sv_tfa_penetration_hardlimit", "100")
    RunConsoleCommand("sv_tfa_penetration_hitmarker", "1")
    RunConsoleCommand("sv_tfa_range_modifier", "0.85")
    RunConsoleCommand("sv_tfa_recoil_legacy", "0")
    RunConsoleCommand("sv_tfa_scope_gun_speed_scale", "0")
    RunConsoleCommand("sv_tfa_soundscale", "1")
    RunConsoleCommand("sv_tfa_spread_legacy", "0")
    RunConsoleCommand("sv_tfa_sprint_enabled", "1")
    RunConsoleCommand("sv_tfa_unique_slots", "1")
    RunConsoleCommand("sv_tfa_weapon_strip", "0")
    RunConsoleCommand("sv_tfa_weapon_weight", "1")
    RunConsoleCommand("sv_tfa_worldmodel_culldistance", "20")

    --Flashlight
    RunConsoleCommand("tpf_sv_light_forward_offset", "15")
    RunConsoleCommand("tpf_sv_max_bright", "255")
    RunConsoleCommand("tpf_sv_max_farz", "750")
    RunConsoleCommand("tpf_sv_max_fov", "75")

    --Grappling Hook
    if GetConVar("tm_developermode"):GetInt() == 1 then RunConsoleCommand("frest_Cooldowng", "0") else RunConsoleCommand("frest_Cooldowng", grappleCooldown) end
    RunConsoleCommand("frest_range", grappleRange)

    --HL2 Grenades
    RunConsoleCommand("sk_fraggrenade_radius", "350")
    RunConsoleCommand("sk_plr_dmg_grenade", "250")
    RunConsoleCommand("sk_npc_dmg_grenade", "250")
end

--Client Side
if CLIENT then
    --Client Side TFA Configuration
    RunConsoleCommand("cl_tfa_3dscope", "1")
    RunConsoleCommand("cl_tfa_3dscope_overlay", "0")
    RunConsoleCommand("cl_tfa_3dscope_quality", "0")
    RunConsoleCommand("cl_tfa_attachments_persist_enabled", "1")
    RunConsoleCommand("cl_tfa_ballistics_fx_bullet", "1")
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
    RunConsoleCommand("cl_tfa_gunbob_intensity", "0.65")
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
    RunConsoleCommand("cl_tfa_hud_keybindhints_enabled", "0")
    RunConsoleCommand("cl_tfa_inspect_hide", "0")
    RunConsoleCommand("cl_tfa_inspect_hide_hud", "0")
    RunConsoleCommand("cl_tfa_inspect_hide_in_screenshots", "0")
    RunConsoleCommand("cl_tfa_inspect_newbars", "0")
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

--CHAT FILTER ENTRIES
--This is the list of words blocked from being used in the in-game chat.
--Formatting (Word to block, replacment in chat)
chatFilterArray = {}
chatFilterArray["niger"] = "cutie"
chatFilterArray["n1ger"] = "nice guy"
chatFilterArray["nig3r"] = "great guy"
chatFilterArray["n1g3r"] = "best mate"
chatFilterArray["niga"] = "nice lad"
chatFilterArray["nigger"] = "charming lad"
chatFilterArray["n1gg3r"] = "charming lad"
chatFilterArray["n1gger"] = "attractive mate"
chatFilterArray["nigg3r"] = "kind man"
chatFilterArray["nigga"] = "swag daddy"
chatFilterArray["fag"] = "incredible individual"
chatFilterArray["faggot"] = "incredible individual"
chatFilterArray["f4ggot"] = "incredible individual"
chatFilterArray["fagg0t"] = "incredible individual"
chatFilterArray["tranny"] = "amazing person"
chatFilterArray["tr4nny"] = "amazing person"
chatFilterArray["kike"] = "swag individual"
chatFilterArray["dyke"] = "swag individual"