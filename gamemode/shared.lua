include("performance/cl_precacher.lua")
include("performance/cl_rewrite_entity_index.lua")
include("performance/cl_rewrite_player_index.lua")
include("performance/cl_rewrite_weapon_index.lua")
include("performance/sh_optimization.lua")

GM.Name = "Titanmod"
GM.Author = "Penial"
GM.Email = "glass campers on tm_mall turning around to see a bald man crouching with a AA-12"
GM.Website = "https://github.com/PikachuPenial/Titanmod"

--Creating server ConVars and initializing the config.
if !ConVarExists("tm_gamemode") then CreateConVar("tm_gamemode", "0", FCVAR_NOTIFY, "Changes the desired gamemode, will be replaced with gamemode voting eventually", 0, 7) end
if !ConVarExists("tm_matchlengthtimer") then CreateConVar("tm_matchlengthtimer", "600", FCVAR_NOTIFY, "Changes the matches length to the selected value in seconds", 0, 3600) end
if !ConVarExists("tm_developermode") then CreateConVar("tm_developermode", "0", FCVAR_NOTIFY, "Enables Sandbox features on server start and enables certain debugging tools, having this enabled will disable progression for all players", 0, 1) end

if !ConVarExists("sv_tm_player_health") then CreateConVar("sv_tm_player_health", "100", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The max health of the player (100 by default)") end
if !ConVarExists("sv_tm_player_speed_multi") then CreateConVar("sv_tm_player_speed_multi", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier for the speed of the player (affects walking, sprinting, crouching, sliding, and ladder climbing speeds) (1 by default)") end
if !ConVarExists("sv_tm_player_gravity_multi") then CreateConVar("sv_tm_player_gravity_multi", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier for the strength of gravity affecting the player (1 by default)") end
if !ConVarExists("sv_tm_player_jump_multi") then CreateConVar("sv_tm_player_jump_multi", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier for the strength of the players jump (1 by default)") end
if !ConVarExists("sv_tm_player_duckstate_multi") then CreateConVar("sv_tm_player_duckstate_multi", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier of the speed at which the player enters/exits a crocuh after the key is pressed/released (1 by default)") end
if !ConVarExists("sv_tm_player_crouchwalkspeed_multi") then CreateConVar("sv_tm_player_crouchwalkspeed_multi", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier of the players wakling speed while crouched (1 by default)") end
if !ConVarExists("sv_tm_player_slide_speed_multi") then CreateConVar("sv_tm_player_slide_speed_multi", "1.55", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier of the players speed while sliding (1.55 by default)") end
if !ConVarExists("sv_tm_player_slide_duration") then CreateConVar("sv_tm_player_slide_duration", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) that a players slide lasts (1 by default)") end
if !ConVarExists("sv_tm_player_healthregen") then CreateConVar("sv_tm_player_healthregen_enable", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable or disable health regeneration on players (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_player_healthregen_speed") then CreateConVar("sv_tm_player_healthregen_speed", "0.12", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The speed of the players health regeneration (0.15 by default)") end
if !ConVarExists("sv_tm_player_healthregen_damagedelay") then CreateConVar("sv_tm_player_healthregen_damagedelay", "3.5", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) from when the player was last hit to begin health regeneration (3.5 by default)") end
if !ConVarExists("sv_tm_progression_forcedisable") then CreateConVar("sv_tm_progression_forcedisable", "0", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Any progress or unlocks made during a play session will be reset upon leaving (0 by default)", 0, 1) end
if !ConVarExists("sv_tm_progression_xp_multi") then CreateConVar("sv_tm_progression_xp_multi", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Multiplies all sources of XP (kills, accolades, and more) (1 by default)") end
if !ConVarExists("sv_tm_ffa_use_primary") then CreateConVar("sv_tm_ffa_use_primary", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable primary weapons for the players loadout (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_ffa_use_secondary") then CreateConVar("sv_tm_ffa_use_secondary", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable secondary weapons for the players loadout (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_ffa_use_melee") then CreateConVar("sv_tm_ffa_use_melee", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable melee weapons/gadgets for the players loadout (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_ffa_grenade_count") then CreateConVar("sv_tm_ffa_grenade_count", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The amount of grenades that a player is given on spawn (1 by default)") end
if !ConVarExists("sv_tm_fiesta_shuffle_time") then CreateConVar("sv_tm_fiesta_shuffle_time", "30", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) between each loadout swap (30 by default)") end
if !ConVarExists("sv_tm_gungame_ladder_size") then CreateConVar("sv_tm_gungame_ladder_size", "26", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The amount of weapons a player needs to get kills with to win a match (24 by default)", 2) end
if !ConVarExists("sv_tm_cranked_selfdestruct_time") then CreateConVar("sv_tm_cranked_selfdestruct_time", "25", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) that it takes for a player to explode after being Cranked (25 by default)", 10) end
if !ConVarExists("sv_tm_cranked_buff_multi") then CreateConVar("sv_tm_cranked_buff_multi", "1.33", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier for the buffs that being Cranked gives to a player (1.33 by default)", 1) end
if !ConVarExists("sv_tm_koth_scoring_interval") then CreateConVar("sv_tm_koth_scoring_interval", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) that a hill check is done, this is repeating (obviously)", 0.5, 5) end
if !ConVarExists("sv_tm_koth_score") then CreateConVar("sv_tm_koth_score", "15", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Sets the amount of score that is given to a player standing on the hill.", 1) end
if !ConVarExists("sv_tm_vip_scoring_interval") then CreateConVar("sv_tm_vip_scoring_interval", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) that a VIP check is done, this is repeating (obviously)", 0.5, 5) end
if !ConVarExists("sv_tm_vip_score") then CreateConVar("sv_tm_vip_score", "10", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Sets the amount of score that is given to the VIP.", 1) end
if !ConVarExists("sv_tm_grapple_cooldown") then CreateConVar("sv_tm_grapple_cooldown", "15", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The cooldown (in sceonds) of the grappling hook after being used (15 by default)") end
if !ConVarExists("sv_tm_grapple_killreset") then CreateConVar("sv_tm_grapple_killreset", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable or disable the grapple cooldown reset on a player kill (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_grapple_range") then CreateConVar("sv_tm_grapple_range", "850", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The length (in units) that the grappling hook can travel too before despawning (850 by default)") end
if !ConVarExists("sv_tm_rocketjump_enable") then CreateConVar("sv_tm_rocketjump_enable", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable or disable rocket jumping (knockback and less damage from self-inflicted explosive damage) (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_rocketjump_force_multi") then CreateConVar("sv_tm_rocketjump_force_multi", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier of the force applied on a player during a rocket jump (1 by default)") end
if !ConVarExists("sv_tm_damage_knockback") then CreateConVar("sv_tm_damage_knockback_enable", "0", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable or disable knockback from incoming damage (being moved from other players bullets) (0 by default)", 0, 1) end
if !ConVarExists("sv_tm_voip_range") then CreateConVar("sv_tm_voip_range", "1000", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The thresehold in distance where players can hear other players over proximity voice chat (1000 by default)") end
if !ConVarExists("sv_tm_spectating_allow") then CreateConVar("sv_tm_spectating_allow", "1", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enables the ability for players to enter a free-cam spectating state through the Main Menu (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_optimization_mapcleanup_time") then CreateConVar("sv_tm_optimization_mapcleanup_time", "30", FCVAR_NOTIFY + FCVAR_ARCHIVE, "The interval (in seconds) at which the map is cleared of decals (blood, bullet impacts.) Not recommended going below 30 seconds (30 by default)") end
if !ConVarExists("sv_tm_optimization_force_autosave") then CreateConVar("sv_tm_optimization_force_autosave", "0", FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enables auto saving and the interval (in seconds) for each save, could be heavy on server performance. Set this to 0 to disable auto saving (0 by default)", 0, 1) end

if GetConVar("tm_gamemode"):GetInt() <= 0 then SetGlobal2String("ActiveGamemode", "FFA") elseif GetConVar("tm_gamemode"):GetInt() == 1 then SetGlobal2String("ActiveGamemode", "Cranked") elseif GetConVar("tm_gamemode"):GetInt() == 2 then SetGlobal2String("ActiveGamemode", "Gun Game") elseif GetConVar("tm_gamemode"):GetInt() == 3 then SetGlobal2String("ActiveGamemode", "Shotty Snipers") elseif GetConVar("tm_gamemode"):GetInt() == 4 then SetGlobal2String("ActiveGamemode", "Fiesta") elseif GetConVar("tm_gamemode"):GetInt() == 5 then SetGlobal2String("ActiveGamemode", "Quickdraw") elseif GetConVar("tm_gamemode"):GetInt() == 6 then SetGlobal2String("ActiveGamemode", "KOTH") elseif GetConVar("tm_gamemode"):GetInt() >= 7 then SetGlobal2String("ActiveGamemode", "VIP") end
include("config.lua")

--Creating client ConVars, mostly for use in the Options menu.
if CLIENT then
    CreateClientConVar("tm_menusounds", 1, true, false, "Enable/disable the menu sounds", 0, 1)
    CreateClientConVar("tm_hitsounds", 1, true, false, "Enable/disable the hitsounds", 0, 1)
    CreateClientConVar("tm_killsound", 1, true, false, "Enable/disable the kill confirmation sound", 0, 1)
    CreateClientConVar("tm_musicvolume", 1, true, false, "Increase or lower the volume of music", 0, 1)
    CreateClientConVar("tm_hitsoundtype", 0, true, false, "Switch between the multiple styles of hitsounds", 0, 4)
    CreateClientConVar("tm_killsoundtype", 0, true, false, "Switch between the multiple styles of kill sounds", 0, 3)
    CreateClientConVar("tm_menudof", 1, true, false, "Enable or disable Depth Of Field on certain in game menus", 0, 1)
    CreateClientConVar("tm_nadebind", KEY_4, true, true, "Determines the keybind that will begin cocking a grenade")
    CreateClientConVar("tm_mainmenubind", KEY_M, true, true, "Determines the keybind that will open the main menu")
    CreateClientConVar("tm_quickswitching", 1, true, true, "Enable/disable quick weapon switching via keybinds", 0, 1)
    CreateClientConVar("tm_primarybind", KEY_1, true, true, "Determines the keybind that will quick switch to your primary weapon")
    CreateClientConVar("tm_secondarybind", KEY_2, true, true, "Determines the keybind that will quick switch to your secondary weapon")
    CreateClientConVar("tm_meleebind", KEY_3, true, true, "Determines the keybind that will quick switch to your melee")
    CreateClientConVar("tm_hidestatsfromothers", 0, true, true, "Determines if other players can see and/or compare your stats", 0, 1)
    CreateClientConVar("tm_screenflashes", 1, true, false, "Enable/disable sudden screen flashes on certain occasions (mainly dying and leveling up)", 0, 1)
    CreateClientConVar("tm_customfov", 0, true, true, "Enable/disable Titanmod's custom FOV system", 0, 1)
    CreateClientConVar("tm_customfov_value", 100, true, true, "Adjust the players FOV while using Titanmod's custom FOV system", 100, 125)

    CreateClientConVar("tm_hud_enable", 1, true, false, "Enable/disable any custom HUD elements created by the gamemode", 0, 1)
    CreateClientConVar("tm_hud_bounds_x", 15, true, false, "Adjust the HUD bounds on the X axis, moving all hud elements from the edge of your screen", 0, ScrW() / 4)
    CreateClientConVar("tm_hud_bounds_y", 15, true, false, "Adjust the HUD bounds on the Y axis, moving all hud elements from the edge of your screen", 0, ScrH() / 4)
    CreateClientConVar("tm_hud_enablekillfeed", 1, true, false, "Enable/disable the kill feed", 0, 1)
    CreateClientConVar("tm_hud_font", "Arial", true, false, "Enable/disable any custom HUD elements created by the gamemode")
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
    CreateClientConVar("tm_hud_equipment_offset_x", 525, true, false, "Adjusts the X offset of the players equipment UI", 0, ScrW())
    CreateClientConVar("tm_hud_equipment_offset_y", 0, true, false, "Adjusts the Y offset of the players equipment UI", 0, ScrH())
    CreateClientConVar("tm_hud_equipment_anchor", 0, true, false, "Adjusts the anchoring of the players equipment UI", 0, 2)
    CreateClientConVar("tm_hud_killfeed_style", 0, true, false, "Switch the killfeed entries between ascending and descending", 0, 1)
    CreateClientConVar("tm_hud_killfeed_limit", 6, true, false, "Limit the amount of kill feed entries that are shown at one time", 1, 10)
    CreateClientConVar("tm_hud_killfeed_offset_x", 0, true, false, "Adjusts the X offset of the kill feed", 0, ScrW())
    CreateClientConVar("tm_hud_killfeed_offset_y", 40, true, false, "Adjusts the Y offset of the kill feed", 0, ScrH())
    CreateClientConVar("tm_hud_killfeed_opacity", 80, true, false, "Adjusts the background opacity of a kill feed entry", 0, 255)
    CreateClientConVar("tm_hud_killdeath_offset_x", 0, true, false, "Adjusts the X offset of the kill and death UI", ScrW() / -2, ScrW() / 2)
    CreateClientConVar("tm_hud_killdeath_offset_y", 335, true, false, "Adjusts the Y offset of the kill and death UI", 0, ScrH())
    CreateClientConVar("tm_hud_kill_iconcolor_r", 255, true, false, "Adjusts the red coloring for the kill icon", 0, 255)
    CreateClientConVar("tm_hud_kill_iconcolor_g", 255, true, false, "Adjusts the green coloring for the kill icon", 0, 255)
    CreateClientConVar("tm_hud_kill_iconcolor_b", 255, true, false, "Adjusts the blue coloring for the kill icon", 0, 255)
    CreateClientConVar("tm_hud_reloadhint", 1, true, false, "Enable/disable the reload text when out of ammo", 0, 1)
    CreateClientConVar("tm_hud_loadouthint", 1, true, false, "Enable/disable the loadout info displaying on player spawn", 0, 1)
    CreateClientConVar("tm_hud_killtracker", 0, true, false, "Enable/disable the weapon specific kill tracking on the UI", 0, 1)
    CreateClientConVar("tm_hud_keypressoverlay", 0, true, false, "Enable/disable the keypress overlay (shows which keys are being pressed on your screen)", 0, 1)
    CreateClientConVar("tm_hud_keypressoverlay_x", 0, true, false, "Adjusts the X offset of the keypress overlay", 0, ScrW())
    CreateClientConVar("tm_hud_keypressoverlay_y", 0, true, false, "Adjusts the Y offset of the keypress overlay", 0, ScrH())
    CreateClientConVar("tm_hud_keypressoverlay_inactive_r", 255, true, false, "Adjusts the red coloring for a inactive key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_inactive_g", 255, true, false, "Adjusts the green coloring for a inactive key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_inactive_b", 255, true, false, "Adjusts the blue coloring for a inactive key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_actuated_r", 255, true, false, "Adjusts the red coloring for a actuated key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_actuated_g", 0, true, false, "Adjusts the green coloring for a actuated key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_actuated_b", 0, true, false, "Adjusts the blue coloring for a actuated key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_velocitycounter", 0, true, false, "Enable/disable a velocity counter", 0, 1)
    CreateClientConVar("tm_hud_velocitycounter_x", 0, true, false, "Adjusts the X offset of the FPS and ping counter", 0, ScrW())
    CreateClientConVar("tm_hud_velocitycounter_y", 190, true, false, "Adjusts the Y offset of the FPS and ping counter", 0, ScrH())
    CreateClientConVar("tm_hud_velocitycounter_r", 255, true, false, "Adjusts the red coloring for the FPS and ping counter", 0, 255)
    CreateClientConVar("tm_hud_velocitycounter_g", 255, true, false, "Adjusts the green coloring for the FPS and ping counter", 0, 255)
    CreateClientConVar("tm_hud_velocitycounter_b", 255, true, false, "Adjusts the blue coloring for the FPS and ping counter", 0, 255)
    CreateClientConVar("tm_hud_obj_scale", 1, true, false, "Adjusts the scale of the font used on objective-based HUD elements", 0.5, 3)
    CreateClientConVar("tm_hud_obj_color_empty_r", 255, true, false, "Adjusts the red coloring for the objective object when empty", 0, 255)
    CreateClientConVar("tm_hud_obj_color_empty_g", 255, true, false, "Adjusts the green coloring for the objective object when empty", 0, 255)
    CreateClientConVar("tm_hud_obj_color_empty_b", 255, true, false, "Adjusts the blue coloring for the objective object when empty", 0, 255)
    CreateClientConVar("tm_hud_obj_color_occupied_r", 255, true, false, "Adjusts the red coloring for the objective object when occupied", 0, 255)
    CreateClientConVar("tm_hud_obj_color_occupied_g", 255, true, false, "Adjusts the green coloring for the objective object when occupied", 0, 255)
    CreateClientConVar("tm_hud_obj_color_occupied_b", 0, true, false, "Adjusts the blue coloring for the objective object when occupied", 0, 255)
    CreateClientConVar("tm_hud_obj_color_contested_r", 255, true, false, "Adjusts the red coloring for the objective object when contested", 0, 255)
    CreateClientConVar("tm_hud_obj_color_contested_g", 0, true, false, "Adjusts the green coloring for the objective object when contested", 0, 255)
    CreateClientConVar("tm_hud_obj_color_contested_b", 0, true, false, "Adjusts the blue coloring for the objective object when contested", 0, 255)
    CreateClientConVar("tm_hud_obj_text_color_r", 255, true, false, "Adjusts the red coloring for the objective text", 0, 255)
    CreateClientConVar("tm_hud_obj_text_color_g", 255, true, false, "Adjusts the green coloring for the objective text", 0, 255)
    CreateClientConVar("tm_hud_obj_text_color_b", 255, true, false, "Adjusts the blue coloring for the objective text", 0, 255)
    CreateClientConVar("tm_hud_dmgindicator", 1, true, false, "Enable/disable damage indicators", 0, 1)
    CreateClientConVar("tm_hud_dmgindicator_color_r", 255, true, false, "Adjusts the red coloring for the damage indicator", 0, 255)
    CreateClientConVar("tm_hud_dmgindicator_color_g", 0, true, false, "Adjusts the green coloring for the damage indicator", 0, 255)
    CreateClientConVar("tm_hud_dmgindicator_color_b", 0, true, false, "Adjusts the blue coloring for the damage indicator", 0, 255)
    CreateClientConVar("tm_hud_dmgindicator_opacity", 85, true, false, "Adjusts the opacity for the damage indicator", 0, 255)
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

--Disable muzzle flash
hook.Add("TFA_MuzzleFlash", "DisableMuzzleFlash", function(Weapon)
    return false
end)

--Disable UBGLs
hook.Add("TFABase_ShouldLoadAttachment", "DisableUBGL", function(id, path)
    if id and (id == "ins2_fg_gp25" or id == "ins2_fg_m203" or id == "r6s_flashhider_2" or id == "r6s_h_barrel" or id == "am_gib" or id == "flashlight" or id == "flashlight_lastac" or id == "ins2_eft_lastac2" or id == "tfa_at_fml_flashlight" or id == "un_flashlight" or id == "ins2_ub_flashlight") then
        return false
    end
end)

--Model Array Formatting (Model ID, Model Name, Model Description, Unlock Style, Unlock Value)
modelArray = {}
modelArray[1] = {"models/player/Group03/male_02.mdl", "Male", "default", "default"}
modelArray[2] = {"models/player/Group03/female_02.mdl", "Female", "default", "default"}
modelArray[3] = {"models/player/Group01/male_03.mdl", "Casual Male", "default", "default"}
modelArray[4] = {"models/player/mossman.mdl", "Casual Female", "default", "default"}
modelArray[5] = {"models/player/Group03m/male_05.mdl", "Doctor", "default", "default"}
modelArray[6] = {"models/player/Group03m/female_06.mdl", "Nurse", "default", "default"}
modelArray[7] = {"models/player/barney.mdl", "Barney", "default", "default"}
modelArray[8] = {"models/player/breen.mdl", "Breen", "default", "default"}
modelArray[9] = {"models/player/kleiner.mdl", "Kleiner", "default", "default"}
modelArray[10] = {"models/player/Group01/male_07.mdl", "Male 07", "kills", 100}
modelArray[11] = {"models/player/alyx.mdl", "Alyx", "kills", 300}
modelArray[12] = {"models/player/hostage/hostage_04.mdl", "Scientist", "kills", 500}
modelArray[13] = {"models/player/gman_high.mdl", "GMan", "kills", 1000}
modelArray[14] = {"models/player/p2_chell.mdl", "Chell", "kills", 2000}
modelArray[15] = {"models/player/leet.mdl", "Badass", "kills", 3000}
modelArray[16] = {"models/player/arctic.mdl", "Frozen", "streak", 5}
modelArray[17] = {"models/player/riot.mdl", "Riot", "streak", 10}
modelArray[18] = {"models/player/gasmask.mdl", "Hazard Suit", "streak", 15}
modelArray[19] = {"models/player/police.mdl", "Officer", "streak", 20}
modelArray[20] = {"models/player/combine_soldier_prisonguard.mdl", "Cobalt Soilder", "streak", 25}
modelArray[21] = {"models/walterwhite/playermodels/walterwhitechem.mdl", "Drug Dealer", "streak", 30}
modelArray[22] = {"models/paynamia/bms/gordon_survivor_player.mdl", "Gordon", "headshot", 125}
modelArray[23] = {"models/munch/mace/Mace.mdl", "Mace", "headshot", 250}
modelArray[24] = {"models/player/darky_m/rust/arctic_hazmat.mdl", "Arctic", "headshot", 450}
modelArray[25] = {"models/player/eft/shturman/eft_shturman/models/eft_shturman_pm.mdl", "Shturman", "headshot", 900}
modelArray[26] = {"models/player/darky_m/rust/scientist.mdl", "Cobalt", "smackdown", 40}
modelArray[27] = {"models/Splinks/Hotline_Miami/Jacket/Player_jacket.mdl", "Jacket", "smackdown", 80}
modelArray[28] = {"models/titanfall2_playermodel/kanepm.mdl", "Kane", "smackdown", 160}
modelArray[29] = {"models/auditor/r6s/707/vigil/chr_707_vigil.mdl", "Vigil", "smackdown", 320}
modelArray[30] = {"models/player/combine_super_soldier.mdl", "Super Soilder", "clutch", 30}
modelArray[31] = {"models/patrickbateman/Playermodels/patrickbateman.mdl", "Patrick Bateman", "clutch", 60}
modelArray[32] = {"models/player/darky_m/rust/spacesuit.mdl", "Spacesuit", "clutch", 150}
modelArray[33] = {"models/us_airforce/jetpilot_usaf.mdl", "Pilot", "clutch", 300}
modelArray[34] = {"models/player/john_marston.mdl", "John Martson", "longshot", 30}
modelArray[35] = {"models/player/darky_m/rust/hazmat.mdl", "Hazmat", "longshot", 60}
modelArray[36] = {"models/player/darky_m/rust/nomad.mdl", "Nomad", "longshot", 150}
modelArray[37] = {"models/arachnit/csgonewsas/ctm_sasplayerwinter.mdl", "Winter SAS", "longshot", 300}
modelArray[38] = {"models/maxpayne3/ufe/ufepm.mdl", "UFE", "pointblank", 120}
modelArray[39] = {"models/starwarsbf1/Scoutrooper.mdl", "Scout Trooper", "pointblank", 240}
modelArray[40] = {"models/kyo/ghot.mdl", "Ghost", "pointblank", 480}
modelArray[41] = {"models/arachnit/csgonewsas/ctm_sasplayer.mdl", "SAS", "pointblank", 720}
modelArray[42] = {"models/Krueger_PlayerModel/Zaper/Krueger_Body.mdl", "Krueger", "killstreaks", 80}
modelArray[43] = {"models/player/tabspeasant.mdl", "Wobbler", "killstreaks", 160}
modelArray[44] = {"models/captainbigbutt/vocaloid/miku_classic.mdl", "Miku", "killstreaks", 320}
modelArray[45] = {"models/Fate_Extella_Link/Astolfo/Astolfo.mdl", "Astolfo", "killstreaks", 480}
modelArray[46] = {"models/player/voikanaa/snoop_dogg.mdl", "Snoop Dogg", "buzzkills", 60}
modelArray[47] = {"models/pacagma/humans/heroes/imc_hero_viper_player.mdl", "Viper", "buzzkills", 120}
modelArray[48] = {"models/auditor/titanfall2/cooper/chr_jackcooper.mdl", "Cooper", "buzzkills", 200}
modelArray[49] = {"models/auditor/re2/chr_hunk_pmrig.mdl", "Hunk", "buzzkills", 320}

--Calling Card Array Formatting (Image File, Card Name, Card Description, Unlock Style, Unlock Value)
cardArray = {}
cardArray[1] = {"cards/default/barrels.png", "Barrels", "", "default", "default"}
cardArray[2] = {"cards/default/carbon.png", "Carbon", "", "default", "default"}
cardArray[3] = {"cards/default/construct.png", "Construct", "", "default", "default"}
cardArray[4] = {"cards/default/flare.png", "Flare", "", "default", "default"}
cardArray[5] = {"cards/default/flattywood.png", "Fattywood", "", "default", "default"}
cardArray[6] = {"cards/default/grapple.png", "Grapple", "", "default", "default"}
cardArray[7] = {"cards/default/industry.png", "Industry", "", "default", "default"}
cardArray[8] = {"cards/default/monkey.png", "Monkey", "", "default", "default"}
cardArray[9] = {"cards/default/overhead.png", "Overhead", "", "default", "default"}
cardArray[10] = {"cards/default/specops.png", "Spec Ops", "", "default", "default"}
cardArray[11] = {"cards/default/stargazing.png", "Stargazing", "", "default", "default"}
cardArray[12] = {"cards/default/strobe.png", "Strobe", "", "default", "default"}
cardArray[13] = {"cards/kills/pistoling.png", "Pistoling", "", "kills", 300}
cardArray[14] = {"cards/kills/smoke.png", "Smoke", "", "kills", 1200}
cardArray[15] = {"cards/kills/titan.png", "Titan", "", "kills", 2500}
cardArray[16] = {"cards/kills/killstreak10.png", "Convoy", "", "streak", 10}
cardArray[17] = {"cards/kills/killstreak20.png", "On Fire", "", "streak", 20}
cardArray[18] = {"cards/kills/killstreak30.png", "Nuclear", "", "streak", 30}
cardArray[19] = {"cards/accolades/headshot1.png", "Headshot You", "", "headshot", 50}
cardArray[20] = {"cards/accolades/headshot2.png", "Headhunter", "", "headshot", 100}
cardArray[21] = {"cards/accolades/headshot3.png", "Icon", "", "headshot", 200}
cardArray[22] = {"cards/accolades/headshot4.png", "NODs", "", "headshot", 400}
cardArray[23] = {"cards/accolades/smackdown1.png", "Karambit", "", "smackdown", 25}
cardArray[24] = {"cards/accolades/smackdown2.png", "Samuri", "", "smackdown", 50}
cardArray[25] = {"cards/accolades/smackdown3.png", "Beach", "", "smackdown", 100}
cardArray[26] = {"cards/accolades/smackdown4.png", "Execution", "", "smackdown", 200}
cardArray[27] = {"cards/accolades/clutch1.png", "Desert Eagle", "", "clutch", 30}
cardArray[28] = {"cards/accolades/clutch2.png", "Magnum", "", "clutch", 60}
cardArray[29] = {"cards/accolades/clutch3.png", "KRISS", "", "clutch", 100}
cardArray[30] = {"cards/accolades/clutch4.png", "FN", "", "clutch", 180}
cardArray[31] = {"cards/accolades/longshot1.png", "Down Sights", "", "longshot", 30}
cardArray[32] = {"cards/accolades/longshot2.png", "Stalker", "", "longshot", 60}
cardArray[33] = {"cards/accolades/longshot3.png", "Highrise", "", "longshot", 100}
cardArray[34] = {"cards/accolades/longshot4.png", "Tactical", "", "longshot", 180}
cardArray[35] = {"cards/accolades/pointblank1.png", "Showers", "", "pointblank", 45}
cardArray[36] = {"cards/accolades/pointblank2.png", "No Full Auto", "", "pointblank", 90}
cardArray[37] = {"cards/accolades/pointblank3.png", "Live Fire", "", "pointblank", 150}
cardArray[38] = {"cards/accolades/pointblank4.png", "Dual Wield", "", "pointblank", 275}
cardArray[39] = {"cards/accolades/killstreaks1.png", "Soilder", "", "killstreaks", 40}
cardArray[40] = {"cards/accolades/killstreaks2.png", "Badass", "", "killstreaks", 90}
cardArray[41] = {"cards/accolades/killstreaks3.png", "Skulls", "", "killstreaks", 160}
cardArray[42] = {"cards/accolades/killstreaks4.png", "Radiation", "", "killstreaks", 270}
cardArray[43] = {"cards/accolades/buzzkills1.png", "Wobblers", "", "buzzkills", 40}
cardArray[44] = {"cards/accolades/buzzkills2.png", "Point Of View", "", "buzzkills", 90}
cardArray[45] = {"cards/accolades/buzzkills3.png", "Preperation", "", "buzzkills", 160}
cardArray[46] = {"cards/accolades/buzzkills4.png", "Twin Flames", "", "buzzkills", 270}
cardArray[47] = {"cards/color/red.png", "Red", "Solid red color.", "color", "color"}
cardArray[48] = {"cards/color/orange.png", "Orange", "Solid orange color.", "color", "color"}
cardArray[49] = {"cards/color/yellow.png", "Yellow", "Solid yellow color.", "color", "color"}
cardArray[50] = {"cards/color/lime.png", "Lime", "Solid lime color.", "color", "color"}
cardArray[51] = {"cards/color/cyan.png", "Cyan", "Solid cyan color.", "color", "color"}
cardArray[52] = {"cards/color/blue.png", "Blue", "Solid blue color.", "color", "color"}
cardArray[53] = {"cards/color/purple.png", "Purple", "Solid magenta color.", "color", "color"}
cardArray[54] = {"cards/color/pink.png", "Pink", "Solid pink color.", "color", "color"}
cardArray[55] = {"cards/color/brown.png", "Brown", "Solid brown color.", "color", "color"}
cardArray[56] = {"cards/color/gray.png", "Gray", "Solid gray color.", "color", "color"}
cardArray[57] = {"cards/color/white.png", "White", "Solid white color.", "color", "color"}
cardArray[58] = {"cards/color/black.png", "Black", "Solid black color.", "color", "color"}

--Mastery Cards
cardArray[59] = {"cards/mastery/aa12.png", "Close Up", "AA-12 mastery", "mastery", "tfa_ins2_aa12"}
cardArray[60] = {"cards/mastery/acrc.png", "Posted Up", "ACR-C mastery", "mastery", "tfa_ins2_acrc"}
cardArray[61] = {"cards/mastery/aek971.png", "Stalker", "AEK-971 mastery", "mastery", "tfa_ins2_aek971"}
cardArray[62] = {"cards/mastery/aks74u.png", "Loaded", "AKS-74U mastery", "mastery", "tfa_ins2_aks_r"}
cardArray[63] = {"cards/mastery/ak12.png", "Inspection", "AK-12 mastery", "mastery", "tfa_ins2_ak12"}
cardArray[64] = {"cards/mastery/ak47.png", "Sunset", "AK-47 mastery", "mastery", "tfa_ins2_akms"}
cardArray[65] = {"cards/mastery/ak400.png", "Overhead", "AK-400 mastery", "mastery", "tfa_ins2_ak400"}
cardArray[66] = {"cards/mastery/an94.png", "Hijacked", "AN-94 mastery", "mastery", "tfa_ins2_abakan"}
cardArray[67] = {"cards/mastery/ar57.png", "Ghost", "AR-57 mastery", "mastery", "tfa_ins2_ar57"}
cardArray[68] = {"cards/mastery/asval.png", "Obesa", "AS-VAL mastery", "mastery", "tfa_inss_asval"}
cardArray[69] = {"cards/mastery/auga3.png", "Lightning", "AUG A3 mastery", "mastery", "tfa_fml_csgo_aug"}
cardArray[70] = {"cards/mastery/awm.png", "Dust II", "AWM mastery", "mastery", "tfa_ins2_warface_awm"}
cardArray[71] = {"cards/mastery/ax308.png", "Down Range", "AX-308 mastery", "mastery", "tfa_ins2_warface_ax308"}
cardArray[72] = {"cards/mastery/barrettm98b.png", "Ready", "Barrett M98B mastery", "mastery", "tfa_ins2_barrett_m98_bravo"}
cardArray[73] = {"cards/mastery/berettamx4.png", "House", "Barrett Mx4 mastery", "mastery", "tfa_ins2_mx4"}
cardArray[74] = {"cards/mastery/bow.png", "Cargo Ship", "Bow mastery", "mastery", "rust_bow"}
cardArray[75] = {"cards/mastery/bren.png", "Flank", "Bren mastery", "mastery", "tfa_doibren"}
cardArray[76] = {"cards/mastery/cheyintervention.png", "Trickshot", "CheyTac M200 mastery", "mastery", "tfa_ins2_warface_cheytac_m200"}
cardArray[77] = {"cards/mastery/colt9mm.png", "Magazines", "Colt 9mm mastery", "mastery", "tfa_ins2_m4_9mm"}
cardArray[78] = {"cards/mastery/colt1911.png", "Relic", "Colt M1911 mastery", "mastery", "tfa_nam_m1911"}
cardArray[79] = {"cards/mastery/coltm45a1.png", "Legend", "Colt M45A1 mastery", "mastery", "tfa_ins2_colt_m45"}
cardArray[80] = {"cards/mastery/crossbow.png", "Arrows", "Crossbow mastery", "mastery", "rust_crossbow"}
cardArray[81] = {"cards/mastery/cz75.png", "Nuke", "CZ 75 B mastery", "mastery", "tfa_ins2_cz75"}
cardArray[82] = {"cards/mastery/cz805.png", "Attached", "CZ 805 mastery", "mastery", "tfa_ins2_cz805"}
cardArray[83] = {"cards/mastery/deserteagle.png", "Mag Check", "Desert Eagle mastery", "mastery", "tfa_ins2_deagle"}
cardArray[84] = {"cards/mastery/dsr1.png", "Arena", "DSR-1 mastery", "mastery", "tfa_ins2_warface_amp_dsr1"}
cardArray[85] = {"cards/mastery/dualskorpion.png", "Celestial", "Dual Skorpions mastery", "mastery", "tfa_l4d2_skorpion_dual"}
cardArray[86] = {"cards/mastery/famas.png", "Siege", "Famas F1 mastery", "mastery", "tfa_ins2_famas"}
cardArray[87] = {"cards/mastery/fg42.png", "Glint", "FG 42 mastery", "mastery", "tfa_doifg42"}
cardArray[88] = {"cards/mastery/fiveseven.png", "Intergalactic", "Fiveseven mastery", "mastery", "tfa_ins2_fiveseven_eft"}
cardArray[89] = {"cards/mastery/fn2000.png", "Armory", "FN 2000 mastery", "mastery", "tfa_ins2_fn_2000"}
cardArray[90] = {"cards/mastery/fnfal.png", "Exposed", "FN FAL mastery", "mastery", "tfa_ins2_fn_fal"}
cardArray[91] = {"cards/mastery/fnp45.png", "ACP", "FNP-45 mastery", "mastery", "tfa_ins2_fnp45"}
cardArray[92] = {"cards/mastery/g28.png", "Legacy", "G28 mastery", "mastery", "tfa_ins2_g28"}
cardArray[93] = {"cards/mastery/g36a1.png", "Aimpoint", "G36A1 mastery", "mastery", "tfa_ins2_g36a1"}
cardArray[94] = {"cards/mastery/glock18.png", "Ospery", "Glock 18 mastery", "mastery", "tfa_glk_gen4"}
cardArray[95] = {"cards/mastery/gsh18.png", "Skyscraper", "GSH-18 mastery", "mastery", "tfa_ins2_gsh18"}
cardArray[96] = {"cards/mastery/hk53.png", "Chains", "HK53 mastery", "mastery", "tfa_ins2_fml_hk53"}
cardArray[97] = {"cards/mastery/honeybadger.png", "Business", "Honey Badger mastery", "mastery", "tfa_ins2_cq300"}
cardArray[98] = {"cards/mastery/howatype64.png", "Cradle", "Howa Type 64 mastery", "mastery", "tfa_howa_type_64"}
cardArray[99] = {"cards/mastery/imbelia2.png", "Due Process", "Imbel IA2 mastery", "mastery", "tfa_ins2_imbelia2"}
cardArray[100] = {"cards/mastery/kacchainsaw.png", "", "KAC ChainSAW mastery", "mastery", "ryry_tfa_chainsaw"}
cardArray[101] = {"cards/mastery/km2000.png", "Flatgrass", "KM-2000 mastery", "mastery", "tfa_km2000_knife"}
cardArray[102] = {"cards/mastery/krissvector.png", "Narkotica", "KRISS Vector mastery", "mastery", "tfa_ins2_krissv"}
cardArray[103] = {"cards/mastery/ksg.png", "Flames", "KSG mastery", "mastery", "tfa_ins2_ksg"}
cardArray[104] = {"cards/mastery/leeenfield.png", "Minecraft", "Lee Enfield master", "mastery", "tfa_doi_enfield"}
cardArray[105] = {"cards/mastery/lewis.png", "Plates", "Lewis mastery", "mastery", "tfa_doilewis"}
cardArray[106] = {"cards/mastery/lr300.png", "Oil Rig", "LR-300 mastery", "mastery", "tfa_ins2_zm_lr300"}
cardArray[107] = {"cards/mastery/m1garand.png", "Underworld", "M1 Garand mastery", "mastery", "tfa_doi_garand"}
cardArray[108] = {"cards/mastery/m3grease.png", "Grease", "M3 Grease Gun mastery", "mastery", "tfa_doim3greasegun"}
cardArray[109] = {"cards/mastery/m4a1.png", "Modified", "M4A1 mastery", "mastery", "tfa_ins2_eftm4a1"}
cardArray[110] = {"cards/mastery/m9.png", "Full Metal", "M9 mastery", "mastery", "tfa_ins2_m9"}
cardArray[111] = {"cards/mastery/m14.png", "Bridge", "M14 mastery", "mastery", "tfa_ins2_m14retro"}
cardArray[112] = {"cards/mastery/m79.png", "Cool With It", "M79 mastery", "mastery", "tfa_nam_m79"}
cardArray[113] = {"cards/mastery/m249.png", "Roof Camper", "M249 mastery", "mastery", "tfa_ins2_minimi"}
cardArray[114] = {"cards/mastery/m1918.png", "Bipod", "M1918 mastery", "mastery", "tfa_doim1918"}
cardArray[115] = {"cards/mastery/m1919.png", "Customs", "M1919 mastery", "mastery", "tfa_doim1919"}
cardArray[116] = {"cards/mastery/mac10.png", "Dev", "Mac 10 mastery", "mastery", "bocw_mac10_alt"}
cardArray[117] = {"cards/mastery/mace.png", "Industry", "Mace master", "mastery", "tfa_ararebo_bf1"}
cardArray[118] = {"cards/mastery/makarov.png", "Leaves", "Makarov mastery", "mastery", "tfa_ins2_pm"}
cardArray[119] = {"cards/mastery/maresleg.png", "High Optic", "Mare's Leg mastery", "mastery", "tfa_tfre_maresleg"}
cardArray[120] = {"cards/mastery/mas38.png", "Galaxy", "Mas 38 mastery", "mastery", "tfa_fml_lefrench_mas38"}
cardArray[121] = {"cards/mastery/mg34.png", "Heavy ", "MG 34 mastery", "mastery", "tfa_doimg34"}
cardArray[122] = {"cards/mastery/mg42.png", "D-Day", "MG 42 mastery", "mastery", "tfa_doimg42"}
cardArray[123] = {"cards/mastery/mk23.png", "Uranium", "MK 23 mastery", "mastery", "tfa_ins2_mk23"}
cardArray[124] = {"cards/mastery/mk18.png", "Wednesday", "MK18 mastery", "mastery", "tfa_fml_inss_mk18"}
cardArray[125] = {"cards/mastery/mk14ebr.png", "Prepared", "Mk. 14 EBR mastery", "mastery", "tfa_ins2_mk14ebr"}
cardArray[126] = {"cards/mastery/model10.png", "Walter", "Model 10 mastery", "mastery", "tfa_ins2_swmodel10"}
cardArray[127] = {"cards/mastery/mosin.png", "Rebirth", "Mosin Nagant mastery", "mastery", "tfa_ins2_mosin_nagant"}
cardArray[128] = {"cards/mastery/mp40.png", "Reflection", "MP 40 mastery", "mastery", "tfa_doimp40"}
cardArray[129] = {"cards/mastery/mp5.png", "Mode Select", "MP5 mastery", "mastery", "tfa_inss2_hk_mp5a5"}
cardArray[130] = {"cards/mastery/mp5k.png", "H&K", "MP5K mastery", "mastery", "tfa_ins2_mp5k"}
cardArray[131] = {"cards/mastery/mp7.png", "Oilspill", "MP7 mastery", "mastery", "tfa_ins2_mp7"}
cardArray[132] = {"cards/mastery/mp9.png", "Training", "MP9 mastery", "mastery", "tfa_ins2_warface_bt_mp9"}
cardArray[133] = {"cards/mastery/mp18.png", "Modern", "MP18 mastery", "mastery", "tfa_ww1_mp18"}
cardArray[134] = {"cards/mastery/mp443.png", "Bush", "MP-443 mastery", "mastery", "tfa_ins2_mp443"}
cardArray[135] = {"cards/mastery/mr96.png", "Polish", "MR-96 mastery", "mastery", "tfa_ins2_mr96"}
cardArray[136] = {"cards/mastery/mts225.png", "Slug", "MTs225 mastery", "mastery", "tfa_ins2_mc255"}
cardArray[137] = {"cards/mastery/nova.png", "Dark Streets", "Nova mastery", "mastery", "tfa_ins2_nova"}
cardArray[138] = {"cards/mastery/osp18.png", "Irons", "OSP-18 mastery", "mastery", "tfa_l4d2_osp18"}
cardArray[139] = {"cards/mastery/otsgroza.png", "Bullpup", "OTs-14 Groza mastery", "mastery", "tfa_ins2_groza"}
cardArray[140] = {"cards/mastery/otspernach.png", "Speedloader", "OTs-33 Pernach mastery", "mastery", "tfa_ins2_ots_33_pernach"}
cardArray[141] = {"cards/mastery/owenmki.png", "Grid", "Owen Gun mastery", "mastery", "tfa_doiowen"}
cardArray[142] = {"cards/mastery/p90.png", "MISSING", "P90 mastery", "mastery", "tfa_fml_p90_tac"}
cardArray[143] = {"cards/mastery/pindad.png", "Labs", "PINDAD SS2 mastery", "mastery", "tfa_blast_pindadss2"}
cardArray[144] = {"cards/mastery/pkp.png", "Royalty", "PKP mastery", "mastery", "tfa_ins2_pkp"}
cardArray[145] = {"cards/mastery/pm9.png", "Akimbo", "PM-9 mastery", "mastery", "tfa_ins2_pm9"}
cardArray[146] = {"cards/mastery/ppsh.png", "Mephitic", "PPSH mastery", "mastery", "tfa_nam_ppsh41"}
cardArray[147] = {"cards/mastery/ppbizon.png", "Rainbow", "PP-Bizon mastery", "mastery", "tfa_fas2_ppbizon"}
cardArray[148] = {"cards/mastery/pzb39.png", "Exotic", "PzB 39 mastery", "mastery", "tfa_ww2_pbz39"}
cardArray[149] = {"cards/mastery/qbz97.png", "Hideout", "QBZ-97 mastery", "mastery", "tfa_ins2_norinco_qbz97"}
cardArray[150] = {"cards/mastery/qsz92.png", "yippee", "QSZ-92 mastery", "mastery", "tfa_ins2_qsz92"}
cardArray[151] = {"cards/mastery/remingtonm870.png", "Code", "Remington M870 master", "mastery", "tfa_ins2_remington_m870"}
cardArray[152] = {"cards/mastery/remingtonmsr.png", "Lightshow", "Remington MSR mastery", "mastery", "tfa_ins2_pd2_remington_msr"}
cardArray[153] = {"cards/mastery/rfb.png", "Extraction", "RFB mastery", "mastery", "tfa_ins2_rfb"}
cardArray[154] = {"cards/mastery/rpg7.png", "Damascus", "RPG-7 mastery", "mastery", "tfa_ins2_rpg7_scoped"}
cardArray[155] = {"cards/mastery/rpk74m.png", "Elcan", "RPK-74M mastery", "mastery", "tfa_ins2_rpk_74m"}
cardArray[156] = {"cards/mastery/sa80.png", "Groves", "SA80 mastery", "mastery", "tfa_ins2_l85a2"}
cardArray[157] = {"cards/mastery/sawedoff.png", "Halves", "Sawed Off mastery", "mastery", "tfa_ins2_izh43sw"}
cardArray[158] = {"cards/mastery/scarh.png", "Tilted", "SCAR-H mastery", "mastery", "tfa_ins2_scar_h_ssr"}
cardArray[159] = {"cards/mastery/scorpionevo.png", "Raid", "Scorpion Evo mastery", "mastery", "tfa_ins2_sc_evo"}
cardArray[160] = {"cards/mastery/sigp320.png", "Sauer", "SIG P320 mastery", "mastery", "tfa_ins2_p320_m18"}
cardArray[161] = {"cards/mastery/skorpion.png", "Black Hole", "Skorpion mastery", "mastery", "tfa_l4d2_skorpion"}
cardArray[162] = {"cards/mastery/sks.png", "Scav", "SKS mastery", "mastery", "tfa_ins2_sks"}
cardArray[163] = {"cards/mastery/spas.png", "Twelve Gauge", "SPAS-12 mastery", "mastery", "tfa_ins2_spas12"}
cardArray[164] = {"cards/mastery/spectrem4.png", "Mall", "Spectre M4 mastery", "mastery", "tfa_ins2_spectre"}
cardArray[165] = {"cards/mastery/spikex15.png", "Prototype", "Spike X15 mastery", "mastery", "tfa_ins2_saiga_spike"}
cardArray[166] = {"cards/mastery/sr2m.png", "Blueprint", "SR-2M mastery", "mastery", "tfa_ins2_sr2m_veresk"}
cardArray[167] = {"cards/mastery/sten.png", "Lens Flare", "Sten Gun mastery", "mastery", "tfa_doisten"}
cardArray[168] = {"cards/mastery/stevens620.png", "Mod", "Stevens 620 mastery", "mastery", "tfa_nam_stevens620"}
cardArray[169] = {"cards/mastery/stg44.png", "Wood", "StG44 mastery", "mastery", "tfa_doistg44"}
cardArray[170] = {"cards/mastery/sv98.png", "Vertigo", "SV-98 mastery", "mastery", "tfa_ins2_sv98"}
cardArray[171] = {"cards/mastery/sw500.png", "Companion", "S&W 500 mastery", "mastery", "tfa_ins2_s&w_500"}
cardArray[172] = {"cards/mastery/tanto.png", "Shipment", "Tanto mastery", "mastery", "tfa_japanese_exclusive_tanto"}
cardArray[173] = {"cards/mastery/tariq.png", "Dog", "Tariq mastery", "mastery", "tfa_ins_sandstorm_tariq"}
cardArray[174] = {"cards/mastery/thompsonm1928.png", "Typewritter", "Thompson M1928 master", "mastery", "tfa_doithompsonm1928"}
cardArray[175] = {"cards/mastery/thompson.png", "Suicide", "Thompson M1A1 master", "mastery", "tfa_doithompsonm1a1"}
cardArray[176] = {"cards/mastery/typhoonf12.png", "Ultrakill", "Typhoon F12 mastery", "mastery", "tfa_ins2_typhoon12"}
cardArray[177] = {"cards/mastery/t5000.png", "Reserve", "T-5000 mastery", "mastery", "tfa_ins2_warface_orsis_t5000"}
cardArray[178] = {"cards/mastery/ump45.png", "Nuketown", "UMP .45 mastery", "mastery", "tfa_ins2_ump45"}
cardArray[179] = {"cards/mastery/ump9.png", "Waterfall", "UMP9 mastery", "mastery", "tfa_ins2_ump9"}
cardArray[180] = {"cards/mastery/usp.png", "Strike", "USP mastery", "mastery", "tfa_ins2_usp_match"}
cardArray[181] = {"cards/mastery/uzi.png", "Alpha", "Uzi mastery", "mastery", "tfa_ins2_imi_uzi"}
cardArray[182] = {"cards/mastery/uzkbr99.png", "Rouge", "UZK-BR99 mastery", "mastery", "tfa_ins2_br99"}
cardArray[183] = {"cards/mastery/vhsd2.png", "Liminal Pool", "VHS-D2 mastery", "mastery", "tfa_ins2_vhsd2"}
cardArray[184] = {"cards/mastery/waltherp99.png", "Advisory", "Walther P99 mastery", "mastery", "tfa_ins2_walther_p99"}
cardArray[185] = {"cards/mastery/webley.png", "Bear Witness", "Webley mastery", "mastery", "tfa_doi_webley"}
cardArray[186] = {"cards/mastery/xm8.png", "Ragdoll", "XM8 mastery", "mastery", "tfa_ins2_xm8"}

--Leveling Cards
cardArray[187] = {"cards/leveling/5.png", "Mist", "", "level", 5}
cardArray[188] = {"cards/leveling/10.png", "Shift", "", "level", 10}
cardArray[189] = {"cards/leveling/15.png", "Powerhouse", "", "level", 15}
cardArray[190] = {"cards/leveling/20.png", "Monolith", "", "level", 20}
cardArray[191] = {"cards/leveling/25.png", "Kitty", "", "level", 25}
cardArray[192] = {"cards/leveling/30.png", "Kill Yourself", "", "level", 30}
cardArray[193] = {"cards/leveling/35.png", "Rubberballs", "", "level", 35}
cardArray[194] = {"cards/leveling/40.png", "Shark", "", "level", 49}
cardArray[195] = {"cards/leveling/45.png", "Bath", "", "level", 45}
cardArray[196] = {"cards/leveling/50.png", "Rig", "", "level", 50}
cardArray[197] = {"cards/leveling/55.png", "Station", "", "level", 55}
cardArray[198] = {"cards/leveling/60.png", "Scenic", "", "level", 60}
cardArray[199] = {"cards/leveling/65.png", "Dunes", "", "level", 65}
cardArray[200] = {"cards/leveling/70.png", "Pyro", "", "level", 70}
cardArray[201] = {"cards/leveling/75.png", "Toxicity", "", "level", 75}
cardArray[202] = {"cards/leveling/80.png", "Drainer", "", "level", 80}
cardArray[203] = {"cards/leveling/85.png", "Sweat", "", "level", 85}
cardArray[204] = {"cards/leveling/90.png", "Drive", "", "level", 90}
cardArray[205] = {"cards/leveling/95.png", "Dinner", "", "level", 95}
cardArray[206] = {"cards/leveling/100.png", "Thunder", "", "level", 100}
cardArray[207] = {"cards/leveling/105.png", "David", "", "level", 105}
cardArray[208] = {"cards/leveling/110.png", "Horizon", "", "level", 110}
cardArray[209] = {"cards/leveling/115.png", "Eyepatch", "", "level", 115}
cardArray[210] = {"cards/leveling/120.png", "Pro", "", "level", 120}
cardArray[211] = {"cards/leveling/125.png", "Stare", "", "level", 125}
cardArray[212] = {"cards/leveling/130.png", "Death", "", "level", 130}
cardArray[213] = {"cards/leveling/135.png", "Man", "", "level", 135}
cardArray[214] = {"cards/leveling/140.png", "Depths", "", "level", 140}
cardArray[215] = {"cards/leveling/145.png", "Superpowers", "", "level", 145}
cardArray[216] = {"cards/leveling/150.png", "Shocked", "", "level", 150}
cardArray[217] = {"cards/leveling/155.png", "Scott Up", "", "level", 155}
cardArray[218] = {"cards/leveling/160.png", "Buzzkilled", "", "level", 160}
cardArray[219] = {"cards/leveling/165.png", "Fumos", "", "level", 165}
cardArray[220] = {"cards/leveling/170.png", "The Voices", "", "level", 170}
cardArray[221] = {"cards/leveling/175.png", "Crisis", "", "level", 175}
cardArray[222] = {"cards/leveling/180.png", "Axel", "", "level", 180}
cardArray[223] = {"cards/leveling/185.png", "Operative", "", "level", 185}
cardArray[224] = {"cards/leveling/190.png", "Cool Skull", "", "level", 190}
cardArray[225] = {"cards/leveling/195.png", "Breakcore", "", "level", 195}
cardArray[226] = {"cards/leveling/200.png", "Dr. Han", "", "level", 200}
cardArray[227] = {"cards/leveling/205.png", "Waves", "", "level", 205}
cardArray[228] = {"cards/leveling/210.png", "Universe", "", "level", 210}
cardArray[229] = {"cards/leveling/215.png", "Invasion", "", "level", 215}
cardArray[230] = {"cards/leveling/220.png", "Airship", "", "level", 220}
cardArray[231] = {"cards/leveling/225.png", "Darkness", "", "level", 225}
cardArray[232] = {"cards/leveling/230.png", "Arctic", "", "level", 230}
cardArray[233] = {"cards/leveling/235.png", "Modern", "", "level", 235}
cardArray[234] = {"cards/leveling/240.png", "Childhood", "", "level", 240}

--Pride cards
cardArray[235] = {"cards/pride/pride.png", "Pride", "Pride flag", "pride", "pride"}
cardArray[236] = {"cards/pride/trans.png", "Trans", "Trans flag", "pride", "pride"}
cardArray[237] = {"cards/pride/gay.png", "Gay", "Gay flag", "pride", "pride"}
cardArray[238] = {"cards/pride/lesbian.png", "Lesbian", "Lesbian flag", "pride", "pride"}
cardArray[239] = {"cards/pride/bi.png", "Bi", "Bi flag", "pride", "pride"}
cardArray[240] = {"cards/pride/pan.png", "Pan", "Pan flag", "pride", "pride"}
cardArray[241] = {"cards/pride/ace.png", "Ace", "Ace flag", "pride", "pride"}
cardArray[242] = {"cards/pride/nonbinary.png", "Nonbinary", "Nonbinary flag", "pride", "pride"}
cardArray[243] = {"cards/pride/genderfluid.png", "Genderfluid", "Genderfluid flag", "pride", "pride"}
cardArray[244] = {"cards/pride/zedo.png", "Zedo", "What's her name?", "pride", "pride"}

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
levelArray[55] = {55, 8050}
levelArray[56] = {56, 8250}
levelArray[57] = {57, 8450}
levelArray[58] = {58, 8650}
levelArray[59] = {59, 8850}
levelArray[60] = {60, "prestige"}

--Hints, are displayed at the bottom of the Main Menu.
hintArray = {"Winning the match nets you bonus XP", "Suppressors might make your gun sound badass, but it will also lower your damage", "Be vigilant with the acidic flood while playing on the Mephitic map", "Match Ammunition is a good choice for low accuracy weapons", "Follow CaptainBear on the Steam Workshop", "Switching to your secondary is 'usually' faster than reloading", "To win a match, a player must have more score than the rest of the competing players", "Voice chat is proximity based, do with this information as you see fit", "Magnum ammunition pairs extremely well with low damage weapons", "Slug ammunition turns your traditional shotgun into a marksman rifle", "Try personalizing yourself in the cuztomization menus", "Crouching completely eliminates your footstep audio, embrace the sneaky", "Underbarrel grenade launchers can be used by pressing Interact + Left Click", "You can cycle through firing modes by using your Interact + Reload keys", "All melee weapons can be thrown with the reload key", "Air strafing is extremely useful, try to incorperate it into your playstyle", "G.I.B ammunition is a good choice if you want to slow down hit opponents", "Frag ammunition deafens hit players for a few seconds, and slows down their movement speed", "Explosive barrels can be used as a funny distraction", "Players can not shoot most weapons while submerged in water, use this to your advantage", "Almost everything you do in game is tracked, check out the stats page to compare yourself with others", "The grappling hook can easily be used to start favorable engagments", "Jumping and/or being in mid air gives your weapons less accuracy", "Sliding provides the same accuracy and recoil benefits as crouching", "Chaining multiple accolades together can give a big score/XP boost", "Accolades award good amounts of score and XP", "Running any optic lowers your weapons ADS speed", "There are over 130+ weapons, try to get consistent with many different loadouts", "There is no scope glint, hardscope all you want", "Hip fire is an effective strategy while on the move", "Other players can see your flashlight, be cautious", "Certain playermodels may shine or stand out in dark enviroments", "Combine wall running and jumping for extremely unpredictable movement", "Wall running through a chokepoint can catch opponents off guard", "Wall jumping constantly allows for continuous climbing of said wall", "All melee weapons have a left and right click attack, learn how effective each are", "Attachments save throughout play sessions, tweak your guns once and you are done", "Some snipers and hand cannons can one shot to the torso", "Explosives hurt, don't aim downwards if you want to stay alive", "Crouching drastically increases your accuracy and recoil control", "Each weapon has its own distinct recoil pattern to master", "Your grappling hook cooldown refreshes on each kill", "Shooting the torso and/or head will guarintee good damage per shot", "You can sprint and/or slide in any direction, not just forwards", "Don't stand still, potshotters will have an easy time killing you", "The vehicles can be mounted and surfed on while playing the Bridge map", "Bunny hopping will help perserve velocity after landing from a grapple/slide"}

--Quotes, are displayed on the victory/defeat screeen.
quoteArray = {'"a jeep wrangler is less aerodynamic than a lobster" -P0w', '"meow" -Megu', '"my grandma drowned, drowned in drip" -RandomSZ', '"skill issue" -Strike Force Lightning', '"told my wife im going to the bank, didnt tell her which one" -stiel', '"go lick a gas pump" -Bomca', '"justice for cradle, we the people demand" -RandomSZ', '"women fear me, fish want me" -Tomato', '"i may be im i may i have autism" -Penial', '"gang where are you, blud where are you" -White Guy', '"any kief slayers" -Cream', '"if i was a tree, i would have no reason to love a human" -suomij', '"i wish someone wanted me like plankton wanted the formula" -Seven', '"but your honor, babies kick pregnant women all the time" -MegaSlayer', '"by the nine im tweakin" -MegaSlayer', '"ball torture is $4 usd on steam" -Portanator', '"your walls are never safe from the drywall muncher" -Vertex', '"im obviously not racist, ive kissed a black man" -Mattimeo', '"my balls are made of one thing..." -RubberBalls', '"im like that" -Homeless', '"i need about tree fiddy" -Random Films', '"bring out the whole ocean" -Robo', '"can we ban this guy" -Poopy', '"root beer" -Plat', '"never forget 9/11" -afiais', '"praise o monolith" -Medinator', '"why is he there" -Smity', '"shut it mate yer da sells avon" -zee!'}

--Derives the gamemode with Sandbox if Developer Mode is enabled on server start.
if GetConVar("tm_developermode"):GetInt() == 1 then DeriveGamemode("sandbox") end