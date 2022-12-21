--[[
    Titanmod Config File
    This is primarily for server owners that are trying to fine tune their experience.
    If you do not understand what a certain setting does, I would recommend not changing it.
]]--

playerHealth = 100              --The max health of the player.
playerSpeedMulti = 1            --The multiplier for the speed of the player (affects walking, sprinting, crouching, sliding, and climbing speeds.)
playerGravityMulti = 1          --The multiplier for the strength of gravity affecting the player.
playerJumpMulti = 1             --The multiplier for the strength of the players jump.
playerDuckStateMulti = 1        --The multuplier of the speed at which the player enters/exits a crocuh after the key is pressed/released.
playerCrouchWalkSpeedMulti = 1  --The multiplier of the players wakling speed while crouched.
healthRegenSpeed = 0.15         --The speed of the players health regeneration.
healthRegenDamageDelay = 3.5    --The time (in seconds) from when the player was last hit to begin health regeneration.
playerRespawnTime = 4           --The time (in seconds) that it takes for a player to respawn.

forceDisableProgression = false --Any progress or unlocks made during a play session will be reset upon leaving.
xpMultiplier = 1                --Multiplies all sources of XP (kills, accolades, and more.)

usePrimary = true               --Enable primary weapons for the players loadout.
useSecondary = true             --Enable secondary weapons for the players loadout.
useMelee = true                 --Enable melee weapons for the players loadout.
useGadget = true                --Enable gadgets for the players loadout.
grenadesOnSpawn = 1             --The amount of grenades that a player is given on spawn.
grappleCooldown = 18            --The cooldown (in sceonds) of the grappling hook after being used.
grappleKillReset = true         --The cooldown (in sceonds) of the grappling hook after being used.
grappleRange = 850              --The length (in units) that the grappling hook can travel too before despawning.
rocketJumping = true            --Enable or disable rocket jumping (knockback and less damage from self-inflicted explosive damage.)
damageKnockback = false         --Enable or disable knockback from incoming damage (being moved from other players bullets.)

mapCleanupTime = 30             --The interval (in seconds) at which the map is cleared of decals (blood, bullet impacts.) I would not recommend going below 30 seconds.
forceEnableWepSpawner = false   --Enables the Firing Range scoreboard weapon spawner for all maps.

mapVoteTimer = GetConVar("tm_mapvotetimer"):GetInt()    --The time in seconds until a map vote starts, can be replaced with a whole number to override the ConVar.

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
    if v[1] ~= "tm_firingrange" then
        table.insert(availableMaps, v[1])
    end
end

--WEAPONS
--If you want to use custom weapons, or want to add or remove certain weapons, edit this array.
--Formatting (Item ID, print name, category.)
weaponArray = {}
weaponArray[1] = {"tfa_ins2_aa12", "AA-12", "primary", "12 Gauge"}
weaponArray[2] = {"tfa_ins2_acrc", "ACR-C", "primary", "5.56x45"}
weaponArray[3] = {"tfa_ins2_aek971", "AEK-971", "primary", "5.45x39"}
weaponArray[4] = {"tfa_ins2_akms", "AKMS", "primary", "7.62x39"}
weaponArray[5] = {"tfa_inss_aks74u", "AKS-74U", "primary", "5.45x39"}
weaponArray[6] = {"tfa_ismc_ak12_rpk", "AK-12 RPK", "primary", "5.45x39"}
weaponArray[7] = {"tfa_ins2_ak400", "AK-400", "primary", "5.45x39"}
weaponArray[8] = {"tfa_ins2_warface_amp_dsr1", "AMP DSR-1", "primary", ".338 Lapua"}
weaponArray[9] = {"tfa_ins2_abakan", "AN-94", "primary", "5.45x39"}
weaponArray[10] = {"tfa_ins2_cw_ar15", "AR-15", "primary", "5.56x45"}
weaponArray[11] = {"tfa_ins2_ar57", "AR-57", "primary", "5.7x28"}
weaponArray[12] = {"tfa_at_shak_12", "ASh-12", "primary", "12.7x55"}
weaponArray[13] = {"tfa_inss_asval", "AS-VAL", "primary", "9x39"}
weaponArray[14] = {"tfa_ins2_warface_awm", "AWM", "primary", ".338 Lapua"}
weaponArray[15] = {"tfa_ins2_warface_ax308", "AX-308", "primary", "7.62x51"}
weaponArray[16] = {"tfa_ins2_barrett_m98_bravo", "Barrett M98B", "primary", ".338 Lapua"}
weaponArray[17] = {"tfa_ins2_mx4", "Beretta Mx4", "primary", "9x19"}
weaponArray[18] = {"tfa_doibren", "Bren", "primary", ".303 British"}
weaponArray[19] = {"tfa_ins2_warface_bt_mp9", "B&T MP9", "primary", "9x19"}
weaponArray[20] = {"tfa_ins2_warface_cheytac_m200", "CheyTac M200", "primary", ".408 Cheyenne"}
weaponArray[21] = {"tfa_ins2_m4_9mm", "Colt 9mm", "primary", "9x19"}
weaponArray[22] = {"tfa_new_m1911", "Colt M1911", "secondary", ".45 ACP"}
weaponArray[23] = {"tfa_ins2_colt_m45", "Colt M45A1", "secondary", ".45 ACP"}
weaponArray[24] = {"tfa_ins2_cz75", "CZ 75 B", "secondary", "9x19"}
weaponArray[25] = {"tfa_ins2_cz805", "CZ 805", "primary", "5.56x45"}
weaponArray[26] = {"tfa_ins2_ddm4v5", "DDM4V5", "primary", "5.56x45"}
weaponArray[27] = {"tfa_ins2_deagle", "Desert Eagle", "secondary", ".50 AE"}
weaponArray[28] = {"tfa_ins2_famas", "Famas F1", "primary", "5.56x45"}
weaponArray[29] = {"tfa_blast_lynx_msbsb", "FB MSBS-B", "primary", "5.56x45"}
weaponArray[30] = {"tfa_doifg42", "FG 42", "primary", "7.92x57"}
weaponArray[31] = {"tfa_ins2_fiveseven_eft", "Fiveseven", "secondary", "5.7x28"}
weaponArray[32] = {"tfa_ins2_fn_2000", "FN 2000", "primary", "5.56x45"}
weaponArray[33] = {"tfa_ins2_fn_fal", "FN FAL", "primary", "7.62x51"}
weaponArray[34] = {"tfa_ins2_fnp45", "FNP-45", "secondary", ".45 ACP"}
weaponArray[35] = {"tfa_ins2_g28", "G28", "primary", "7.62x51"}
weaponArray[36] = {"tfa_new_inss_galil", "Galil", "primary", "5.56x45"}
weaponArray[37] = {"tfa_new_glock17", "Glock 17", "secondary", "9x19"}
weaponArray[38] = {"fres_grapple", "Grappling Hook", "gadget"}
weaponArray[39] = {"tfa_ins2_gsh18", "GSH-18", "secondary", "9x19"}
weaponArray[40] = {"tfa_ins2_cq300", "Honey Badger", "primary", ".300 AAC"}
weaponArray[41] = {"tfa_howa_type_64", "Howa Type 64", "primary", "7.62x51"}
weaponArray[42] = {"tfa_ins2_hk_mg36", "H&K MG36", "primary", "5.56x45"}
weaponArray[43] = {"tfa_inss2_hk_mp5a5", "H&K MP5A5", "primary", "9x19"}
weaponArray[44] = {"tfa_ins2_imbelia2", "Imbel IA2", "primary", "5.56x45"}
weaponArray[45] = {"tfa_ins2_izh43sw", "IZH-43 Sawed Off", "secondary", "12 Gauge"}
weaponArray[46] = {"tfa_ararebo_bf1", "Japanese Ararebo", "melee"}
weaponArray[47] = {"tfa_km2000_knife", "KM-2000", "melee"}
weaponArray[48] = {"tfa_ins2_krissv", "KRISS Vector", "primary", ".45 ACP"}
weaponArray[49] = {"tfa_ins2_ksg", "KSG", "primary", "12 Gauge"}
weaponArray[50] = {"tfa_blast_ksvk_cqb", "KSVK 12.7", "primary", "12.7x108"}
weaponArray[51] = {"tfa_doi_enfield", "Lee-Enfield No. 4", "primary", ".303 Mk VII"}
weaponArray[52] = {"tfa_doilewis", "Lewis", "primary", ".303 British"}
weaponArray[53] = {"tfa_ins2_zm_lr300", "LR-300", "primary", "5.56x45"}
weaponArray[54] = {"tfa_doi_garand", "M1 Garand", "primary", ".30-06"}
weaponArray[55] = {"tfa_doim3greasegun", "M3 Grease Gun", "secondary", ".45 ACP"}
weaponArray[56] = {"tfa_ins2_m9", "M9", "secondary", "9x19"}
weaponArray[57] = {"tfa_ins2_m14retro", "M14", "primary", "7.62x51"}
weaponArray[58] = {"tfa_nam_m79", "M79", "primary", "40x46 Grenade"}
weaponArray[59] = {"tfa_doim1918", "M1918", "primary", ".30-06"}
weaponArray[60] = {"tfa_doim1919", "M1919", "primary", ".30-06"}
weaponArray[61] = {"bocw_mac10_alt", "Mac 10", "secondary", ".45 ACP"}
weaponArray[62] = {"tfa_inss_makarov", "Makarov", "secondary", "9x18"}
weaponArray[63] = {"tfa_tfre_maresleg", "Mare's Leg", "secondary", ".44-40"}
weaponArray[64] = {"tfa_fml_lefrench_mas38", "Mas 38", "primary", "7.65"}
weaponArray[65] = {"tfa_doimg34", "MG 34", "primary", "7.92x57"}
weaponArray[66] = {"tfa_doimg42", "MG 42", "primary", "7.92x57"}
weaponArray[67] = {"tfa_ins2_minimi", "Minimi Para", "primary", "5.56x45"}
weaponArray[68] = {"tfa_ins2_mk23", "MK 23", "secondary", ".45 ACP"}
weaponArray[69] = {"tfa_fml_inss_mk18", "MK18", "primary", "5.56x45"}
weaponArray[70] = {"tfa_ins2_mk14ebr", "Mk. 14 EBR", "primary", "7.62x51"}
weaponArray[71] = {"tfa_ins2_swmodel10", "Model 10", "secondary", ".38"}
weaponArray[72] = {"tfa_ins2_mosin_nagant", "Mosin Nagant", "primary", "7.62x54"}
weaponArray[73] = {"tfa_doimp40", "MP 40", "primary", "9x19"}
weaponArray[74] = {"tfa_ins2_mp443", "MP-443", "secondary", "9x19"}
weaponArray[75] = {"tfa_ins2_mp5k", "MP5K", "secondary", "9x19"}
weaponArray[76] = {"tfa_inss_mp7_new", "MP7A1", "primary", "4.6x30"}
weaponArray[77] = {"tfa_ww1_mp18", "MP18", "primary", "9x19"}
weaponArray[78] = {"tfa_ins2_mr96", "MR-96", "secondary", ".22"}
weaponArray[79] = {"tfa_ins2_mc255", "MTs225-12", "primary", "12 Gauge"}
weaponArray[80] = {"tfa_ins2_nova", "Nova", "primary", "12 Gauge"}
weaponArray[81] = {"tfa_ins2_warface_orsis_t5000", "Orsis T-5000", "primary", "6.5x47"}
weaponArray[82] = {"tfa_l4d2_osp18", "OSP-18", "secondary", ".45 ACP"}
weaponArray[83] = {"tfa_ins2_groza", "OTs-14 Groza", "primary", "7.62x39"}
weaponArray[84] = {"tfa_ins2_ots_33_pernach", "OTs-33 Pernach", "secondary", "9x18"}
weaponArray[85] = {"tfa_doiowen", "Owen Mk.I", "primary", "9x19"}
weaponArray[86] = {"tfa_fml_p90_tac", "P90", "primary", "5.7x28"}
weaponArray[87] = {"tfa_blast_pindadss2", "PINDAD SS2-V1", "primary", "5.56x45"}
weaponArray[88] = {"tfa_ins2_pm9", "PM-9", "primary", "9x19"}
weaponArray[89] = {"tfa_nam_ppsh41", "PPSH-41", "primary", "7.62x25"}
weaponArray[90] = {"tfa_fas2_ppbizon", "PP-Bizon", "primary", "9x18"}
weaponArray[91] = {"tfa_ww2_pbz39", "PzB 39", "primary", "7.92x94"}
weaponArray[92] = {"tfa_ins2_norinco_qbz97", "QBZ-97", "primary", "5.8x42"}
weaponArray[93] = {"tfa_ins2_qsz92", "QSZ-92", "secondary", "5.8x21"}
weaponArray[94] = {"tfa_ins2_remington_m870", "Remington M870", "primary", "12 Gauge"}
weaponArray[95] = {"tfa_ins2_pd2_remington_msr", "Remington MSR", "primary", ".338 Lapua"}
weaponArray[96] = {"tfa_ins2_rfb", "RFB", "primary", "7.62x51"}
weaponArray[97] = {"tfa_fml_rk62", "RK62", "primary", "7.62x39"}
weaponArray[98] = {"tfa_ins2_rpg7_scoped", "RPG-7", "primary", "40mm Rocket"}
weaponArray[99] = {"tfa_ins2_rpk_74m", "RPK-74M", "primary", "5.45x39"}
weaponArray[100] = {"tfa_ins2_l85a2", "SA80", "primary", "5.56x45"}
weaponArray[101] = {"tfa_ins2_scar_h_ssr", "SCAR-H", "primary", "5.56x45"}
weaponArray[102] = {"tfa_ins2_sc_evo", "Scorpion Evo", "primary", "9x19"}
weaponArray[103] = {"tfa_new_p226", "SIG P226", "secondary", "9x19"}
weaponArray[104] = {"tfa_ins2_sks", "SKS", "primary", "7.62x39"}
weaponArray[105] = {"tfa_ins2_spas12", "SPAS-12", "primary", "12 Gauge"}
weaponArray[106] = {"tfa_ins2_spectre", "Spectre M4", "primary", "9x19"}
weaponArray[107] = {"tfa_ins2_saiga_spike", "Spike X15", "primary", "12 Gauge"}
weaponArray[108] = {"tfa_ins2_sr2m_veresk", "SR-2M Veresk", "primary", "9x21"}
weaponArray[109] = {"tfa_doisten", "Sten Mk.II", "primary", "9x19"}
weaponArray[110] = {"tfa_nam_stevens620", "Stevens 620", "primary", "12 Gauge"}
weaponArray[111] = {"tfa_inss_aug", "Steyr AUG", "primary", "5.56x45"}
weaponArray[112] = {"tfa_doistg44", "StG44", "primary", "7.92x33"}
weaponArray[113] = {"tfa_ins2_sv98", "SV-98", "primary", "7.62x54"}
weaponArray[114] = {"tfa_ins2_s&w_500", "S&W 500", "secondary", ".500 Magnum"}
weaponArray[115] = {"tfa_japanese_exclusive_tanto", "Tanto", "melee"}
weaponArray[116] = {"tfa_ins_sandstorm_tariq", "Tariq", "secondary", "9x19"}
weaponArray[117] = {"st_stim_pistol", "TCo Stim Pistol", "secondary", "Syringe"}
weaponArray[118] = {"tfa_doithompsonm1928", "Thompson M1928", "primary", ".45 ACP"}
weaponArray[119] = {"tfa_doithompsonm1a1", "Thompson M1A1", "primary", ".45 ACP"}
weaponArray[120] = {"tfa_ins2_type81", "Type 81", "primary", "7.62x39"}
weaponArray[121] = {"tfa_ins2_typhoon12", "Typhoon F12", "primary", "12 Gauge"}
weaponArray[122] = {"tfa_ins2_ump45", "UMP .45", "primary", ".45 ACP"}
weaponArray[123] = {"tfa_ins2_ump9", "UMP9", "primary", "9x19"}
weaponArray[124] = {"tfa_ins2_imi_uzi", "Uzi", "secondary", ".22 LR"}
weaponArray[125] = {"tfa_ins2_br99", "UZK-BR99", "primary", "12 Gauge"}
weaponArray[126] = {"tfa_ins2_vhsd2", "VHS-D2", "primary", "5.56x45"}
weaponArray[127] = {"tfa_ins2_walther_p99", "Walther P99", "secondary", "9x19"}
weaponArray[128] = {"tfa_ins2_xm8", "XM8", "primary", "5.56x45"}

--CONVARS
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
        RunConsoleCommand("frest_Cooldowng", grappleCooldown)
    end
    RunConsoleCommand("frest_range", grappleRange)
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