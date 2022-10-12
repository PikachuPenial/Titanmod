GM.Name = "Titanmod"
GM.Author = "Penial"
GM.Email = "pissoff"
GM.Website = "https://github.com/PikachuPenial"

--DeriveGamemode("sandbox")

--Player Convars
if !ConVarExists("tm_enableui") then CreateConVar("tm_enableui", "1", FCVAR_ARCHIVE, "Enable/disable any custom UI elements created by the gamemode",0,1) end
if !ConVarExists("tm_enablekillpopup") then CreateConVar("tm_enablekillpopup", "1", FCVAR_ARCHIVE, "Completely show/hide the kill popup",0,1) end
if !ConVarExists("tm_enabledeathpopup") then CreateConVar("tm_enabledeathpopup", "1", FCVAR_ARCHIVE, "Completely show/hide the death popup",0,1) end
if !ConVarExists("tm_healthanchor") then CreateConVar("tm_healthanchor", "0", FCVAR_ARCHIVE, "Changes the corner of the screen that holds your health bar",0,1) end
if !ConVarExists("tm_ammostyle") then CreateConVar("tm_ammostyle", "0", FCVAR_ARCHIVE, "Switch between a numeric value and a bar to display your weapons ammo",0,1) end
if !ConVarExists("tm_hitsounds") then CreateConVar("tm_hitsounds", "0", FCVAR_ARCHIVE, "Enable or disable the hitsounds",0,1) end
if !ConVarExists("tm_menumusic") then CreateConVar("tm_menumusic", "1", FCVAR_ARCHIVE, "Enable or disable the Main Menu music",0,1) end
if !ConVarExists("tm_menumusicvolume") then CreateConVar("tm_menumusicvolume", "0.75", FCVAR_ARCHIVE, "Enable or disable the Main Menu music",0,1) end
if !ConVarExists("tm_communitymusic") then CreateConVar("tm_communitymusic", "0", FCVAR_ARCHIVE, "Enable or disable community requested Main Menu music",0,1) end

hook.Add("PlayerFootstep", "MuteCrouchFootsteps", function(ply, pos, foot, sound, volume, ktoslishet)
	if !ply:Crouching() then return end
	return true
end)

function GM:Initialize()
    --Weapon Array Formatting (Item Name/ID, Print Name)
	local weaponArray = {}
	weaponArray[1] = {"bocw_mac10_alt", "Mac 10"}
	weaponArray[2] = {"tfa_nam_m79", "M79"}
    weaponArray[3] = {"tfa_nam_ppsh41", "PPSH-41"}
	weaponArray[4] = {"tfa_nam_stevens620", "Stevens 620"}
    weaponArray[5] = {"tfa_doibren", "Bren"}
	weaponArray[6] = {"tfa_doifg42", "FG 42"}
    weaponArray[7] = {"tfa_doilewis", "Lewis"}
	weaponArray[8] = {"tfa_doim1918", "M1918"}
    weaponArray[9] = {"tfa_doim1919", "M1919"}
	weaponArray[10] = {"tfa_doim3greasegun", "M3 Grease Gun"}
    weaponArray[11] = {"tfa_doimg34", "MG 34"}
	weaponArray[12] = {"tfa_doimg42", "MG 42"}
    weaponArray[13] = {"tfa_doimp40", "MP 40"}
	weaponArray[14] = {"tfa_doiowen", "Owen Mk.I"}
    weaponArray[15] = {"tfa_doisten", "Sten Mk.II"}
	weaponArray[16] = {"tfa_doistg44", "StG44"}
    weaponArray[17] = {"tfa_doithompsonm1928", "Thompson M1928"}
    weaponArray[18] = {"tfa_doithompsonm1a1", "Thompson M1A1"}
	weaponArray[19] = {"tfa_fas2_ppbizon", "PP-Bizon"}
    weaponArray[20] = {"tfa_ismc_ak12_rpk", "AK-12 (RPK)"}
    weaponArray[21] = {"tfa_inss_aks74u", "AKS-74U"}
	weaponArray[22] = {"tfa_new_m1911", "Colt M1911"}
    weaponArray[23] = {"tfa_new_inss_galil", "Galil"}
    weaponArray[24] = {"tfa_new_glock17", "Glock 17"}
	weaponArray[25] = {"tfa_inss_makarov", "Makarov"}
    weaponArray[26] = {"tfa_inss_mp7_new", "MP7A1"}
    weaponArray[27] = {"tfa_new_pf940", "PF940"}
	weaponArray[28] = {"tfa_new_p226", "SIG P226"}
    weaponArray[29] = {"tfa_inss_aug", "Steyr AUG"}
    weaponArray[30] = {"tfa_ins2_aek971", "AEK-971"}
	weaponArray[31] = {"tfa_ins2_ak400", "AK-400"}
    weaponArray[32] = {"tfa_ins2_akms", "AKMS"}
    weaponArray[33] = {"tfa_ins2_warface_amp_dsr1", "AMP DSR-1"}
	weaponArray[34] = {"tfa_ins2_abakan", "AN-94"}
    weaponArray[35] = {"tfa_ins2_cw_ar15", "AR-15"}
    weaponArray[36] = {"tfa_ins2_ar57", "AR-57"}
	weaponArray[37] = {"tfa_inss_asval", "AS-VAL"}
    weaponArray[38] = {"tfa_at_shak_12", "ASh-12"}
    weaponArray[39] = {"tfa_ins2_warface_awm", "AWM"}
	weaponArray[40] = {"tfa_ins2_warface_ax308", "AX-308"}
    weaponArray[41] = {"tfa_ins2_warface_bt_mp9", "B&T MP9"}
    weaponArray[42] = {"tfa_ins2_barrett_m98_bravo", "Barrett M98B"}
	weaponArray[43] = {"tfa_ins2_colt_m45", "Colt M45A1"}
    weaponArray[44] = {"tfa_ins2_cz75", "CZ 75 B"}
    weaponArray[45] = {"tfa_ins2_cz805", "CZ 805 BREN"}
	weaponArray[46] = {"tfa_ins2_deagle", "Desert Eagle"}
    weaponArray[47] = {"tfa_ins2_famas", "Famas F1"}
    weaponArray[48] = {"tfa_ins2_fiveseven_eft", "Fiveseven"}
	weaponArray[49] = {"tfa_ins2_fn_fal", "FN FAL"}
    weaponArray[50] = {"tfa_ins2_gsh18", "GSH-18"}
    weaponArray[51] = {"tfa_ins2_hk_mg36", "H&K MG36"}
	weaponArray[52] = {"tfa_inss2_hk_mp5a5", "H&K MP5A5"}
    weaponArray[53] = {"tfa_howa_type_64", "Howa Type 64"}
    weaponArray[54] = {"tfa_ins2_imbelia2", "Imbel IA2"}
	weaponArray[55] = {"tfa_ins2_izh43sw", "IZH-43 Sawed Off"}
    weaponArray[56] = {"tfa_at_kriss_vector", "KRISS Vector"}
    weaponArray[57] = {"tfa_ins2_ksg", "KSG"}
	weaponArray[58] = {"tfa_doi_enfield", "Lee-Enfield No. 4"}
    weaponArray[59] = {"tfa_ins2_m14retro", "M1A"}
    weaponArray[60] = {"tfa_ins2_m9", "M9"}
	weaponArray[61] = {"tfa_ins2_mk23", "MK 23"}
    weaponArray[62] = {"tfa_ins2_mk14ebr", "Mk. 14 EBR"}
    weaponArray[63] = {"tfa_fml_inss_mk18", "MK18"}
	weaponArray[64] = {"tfa_ins2_swmodel10", "Model 10"}
    weaponArray[65] = {"tfa_ins2_mosin_nagant", "Mosin Nagant"}
    weaponArray[66] = {"tfa_ins2_mp5k", "MP5K"}
	weaponArray[67] = {"tfa_ins2_mr96", "MR-96"}
    weaponArray[68] = {"tfa_ins2_nova", "Nova"}
    weaponArray[69] = {"tfa_ins2_warface_orsis_t5000", "Orsis T-5000"}
	weaponArray[70] = {"tfa_ins2_ots_33_pernach", "OTs-33 Pernach"}
    weaponArray[71] = {"tfa_ins2_pm9", "PM-9"}
    weaponArray[72] = {"tfa_ins2_norinco_qbz97", "QBZ-97"}
	weaponArray[73] = {"tfa_ins2_remington_m870", "Remington M870"}
    weaponArray[74] = {"tfa_ins2_pd2_remington_msr", "Remington MSR"}
    weaponArray[75] = {"tfa_ins2_rfb", "RFB"}
	weaponArray[76] = {"tfa_ins2_rpk_74m", "RPK-74M"}
    weaponArray[77] = {"tfa_ins2_s&w_500", "S&W 500"}
    weaponArray[78] = {"tfa_ins2_l85a2", "SA80"}
	weaponArray[79] = {"tfa_ins2_scar_h_ssr", "SCAR-H SSR"}
    weaponArray[80] = {"tfa_ins2_sks", "SKS"}
    weaponArray[81] = {"tfa_ins2_sv98", "SV-98"}
	weaponArray[82] = {"tfa_ins2_ump45", "UMP .45"}
    weaponArray[83] = {"tfa_ins2_imi_uzi", "Uzi"}
    weaponArray[84] = {"tfa_ins2_br99", "UZK-BR99"}
	weaponArray[85] = {"tfa_ins2_vhsd2", "VHS-D2"}
    weaponArray[86] = {"tfa_ins2_walther_p99", "Walther P99"}
    weaponArray[87] = {"tfa_ins2_xm8", "XM8"}
	weaponArray[88] = {"tfa_ins_sandstorm_tariq", "Tariq"}
    weaponArray[89] = {"tfa_japanese_exclusive_tanto", "Tanto"}
    weaponArray[90] = {"tfa_fml_p90_tac", "P90"}
	weaponArray[91] = {"tfa_ararebo_bf1", "Japanese Ararebo"}
    weaponArray[92] = {"tfa_ww1_mp18", "MP18"}
    weaponArray[93] = {"tfa_ins2_qsz92", "QSZ-92"}
    weaponArray[94] = {"tfa_ins2_saiga_spike", "Spike X15"}
    weaponArray[95] = {"tfa_ins2_spectre", "Spectre M4"}
    weaponArray[96] = {"tfa_ins2_groza", "OTs-14 Groza"}
    weaponArray[97] = {"tfa_ins2_sc_evo", "Scorpion Evo 3"}
    weaponArray[98] = {"tfa_ins2_spas12", "SPAS-12"}
    weaponArray[99] = {"tfa_ins2_ddm4v5", "DDM4V5"}
    weaponArray[100] = {"tfa_ins2_mx4", "Beretta Mx4 Storm"}
    weaponArray[101] = {"tfa_doi_garand", "M1 Garand"}
    weaponArray[102] = {"tfa_ins2_warface_cheytac_m200", "CheyTac M200"}
    weaponArray[103] = {"tfa_ins2_rpg7_scoped", "RPG-7"}
    weaponArray[104] = {"tfa_fml_lefrench_mas38", "Mas 38"}
    weaponArray[105] = {"tfa_ins2_minimi", "Minimi Para"}
    weaponArray[106] = {"tfa_ins2_typhoon12", "Typhoon F12 Custom"}
    weaponArray[107] = {"tfa_ins2_mc255", "MTs225-12"}
    weaponArray[108] = {"tfa_km2000_knife", "KM-2000"}
    weaponArray[109] = {"tfa_ins2_aa12", "AA-12"}
    weaponArray[110] = {"tfa_ins2_sr2m_veresk", "SR-2M Veresk"}
    weaponArray[111] = {"tfa_ins2_fnp45", "FNP-45"}
    weaponArray[109] = {"tfa_blast_pindadss2", "PINDAD SS2-V1"}
    weaponArray[110] = {"tfa_ins2_acrc", "ACR-C"}
    weaponArray[111] = {"tfa_blast_lynx_msbsb", "FB MSBS-B"}

    --Model Array Formatting (Model ID, Model Name, Model Description, Unlock Style, Unlock Value)
    local modelArray = {}
    modelArray[1] = {"models/player/Group03/male_02.mdl", "Male", "The default male character.", "default", "default"}
    modelArray[2] = {"models/player/Group03/female_02.mdl", "Female", "The default female character.", "default", "default"}
    modelArray[3] = {"models/player/Group01/male_03.mdl", "Casual Male", "Why so serious?", "default", "default"}
    modelArray[4] = {"models/player/mossman.mdl", "Casual Female", "Why so serious?", "default", "default"}
    modelArray[5] = {"models/player/Group03m/male_05.mdl", "Doctor", "I need a medic bag.", "default", "default"}
    modelArray[6] = {"models/player/Group03m/female_06.mdl", "Nurse", "I need a medic bag.", "default", "default"}
    modelArray[7] = {"models/player/Group01/male_07.mdl", "Male 07", "The one, the only.", "kills", 100}
    modelArray[8] = {"models/player/alyx.mdl", "Alyx", "Half-Life 3.", "kills", 300}
    modelArray[9] = {"models/player/hostage/hostage_04.mdl", "Scientist", "Bill Nye.", "kills", 500}
    modelArray[10] = {"models/player/combine_super_soldier.mdl", "Super Soilder", "Very super.", "kills", 1000}
    modelArray[11] = {"models/player/p2_chell.mdl", "Chell", "Funny portal reference.", "kills", 2000}
    modelArray[12] = {"models/player/leet.mdl", "Badass", "So cool.", "kills", 3000}
    modelArray[13] = {"models/player/arctic.mdl", "Arctic", "I don't think it's cold in here.", "streak", 5}
    modelArray[14] = {"models/player/riot.mdl", "Riot", "Tanto Addict.", "streak", 10}
    modelArray[15] = {"models/player/gasmask.mdl", "Hazmat Suit", "This isn't Rust.", "streak", 15}
    modelArray[16] = {"models/player/police.mdl", "Officer", "Pick up the can.", "streak", 20}
    modelArray[17] = {"models/player/combine_soldier_prisonguard.mdl", "Cobalt Soilder", "No green card?", "streak", 25}
    modelArray[18] = {"models/walterwhite/playermodels/walterwhitechem.mdl", "Drug Dealer", "waltuh.", "streak", 30}
    modelArray[19] = {"models/cyanblue/fate/astolfo/astolfo.mdl", "Astolfo", "I was forced to do this.", "special", "name"}

    --Accolade Array Formatting (Accolade Name, Amount Of Score Given, Required For Accolade, Required Amount)
    local scoreArray = {}
    scoreArray[1] = {"Buzz Kill", 25, "killStreak", 3}
    scoreArray[2] = {"On Streak", 10, "killStreak", 3}
    scoreArray[3] = {"Marksman", 40, "distance", 40}

    weaponsArr = weaponArray
    modelArr = modelArray
    scoreArr = scoreArray
end

--Convars for the gamemode will go here
--Server Side

if SERVER then
    --Disabling NoClip/Tinnitus
    RunConsoleCommand("sbox_noclip", "0")
    RunConsoleCommand("dsp_off", "1")

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
    RunConsoleCommand("sv_tfa_spread_multiplier", "0.01")
    RunConsoleCommand("sv_tfa_sprint_enabled", "1")
    RunConsoleCommand("sv_tfa_unique_slots", "1")
    RunConsoleCommand("sv_tfa_weapon_strip", "0")
    RunConsoleCommand("sv_tfa_weapon_weight", "1")
    RunConsoleCommand("sv_tfa_worldmodel_culldistance", "-1") 
    RunConsoleCommand("sv_tfa_lean_automatic", "0")

    --Flashlight
    RunConsoleCommand("sv_VMANIPFlash_canAttachShoulder", "1")
    RunConsoleCommand("sv_VMANIPFlashlight_isOnlyUsingShoulder", "1")
end

--Client Side

if CLIENT then
    --Client Side TFA Configuration
    RunConsoleCommand("cl_tfa_3dscope", "1")
    RunConsoleCommand("cl_tfa_3dscope_overlay", "1")
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
    RunConsoleCommand("cl_tfa_gunbob_intensity", "1.00")
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
    RunConsoleCommand("cl_tfa_hud_hitmarker_scale", "1")
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
    RunConsoleCommand("cl_tfa_rms_smoke_shock", "1")
    RunConsoleCommand("cl_tfa_scope_sensitivity_3d", "2")
    RunConsoleCommand("cl_tfa_scope_sensitivity_autoscale", "1")
    RunConsoleCommand("cl_tfa_viewbob_animated", "1")
    RunConsoleCommand("cl_tfa_viewbob_intensity", "1.00")
    RunConsoleCommand("cl_tfa_viewmodel_centered", "0")
    RunConsoleCommand("cl_tfa_viewmodel_flip", "0")
    RunConsoleCommand("cl_tfa_viewmodel_multiplier_fov", "1.00")
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
    RunConsoleCommand("cl_aimingfx_enabled", "1")
    RunConsoleCommand("cl_aimingfx_ca_enabled", "0")
    RunConsoleCommand("cl_aimingfx_vignette_enabled", "1")
    RunConsoleCommand("cl_aimingfx_vignette_intensity_initially_multiplier", "0.75")
    RunConsoleCommand("cl_aimingfx_vignette_intensity_sighted_multiplier", "0.60")

    --Sliding
    RunConsoleCommand("cl_qslide_view", "1")

    --Voice Chat animations
    RunConsoleCommand("cl_vmanip_voicechat", "0")
end