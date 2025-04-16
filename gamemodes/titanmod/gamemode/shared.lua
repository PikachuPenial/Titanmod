GM.Name = "Titanmod"
GM.Author = "Penial"
GM.Email = "glass campers on tm_mall turning around to see a bald man crouching with a AA-12"
GM.Website = "https://github.com/PikachuPenial/Titanmod"

if !ConVarExists("tm_gamemode") then CreateConVar("tm_gamemode", "0", FCVAR_REPLICATED + FCVAR_NOTIFY, "Changes the desired gamemode, will be replaced with gamemode voting eventually", 0, 9) end
if GetConVar("tm_gamemode"):GetInt() <= 0 then SetGlobal2String("ActiveGamemode", "FFA") elseif GetConVar("tm_gamemode"):GetInt() == 1 then SetGlobal2String("ActiveGamemode", "Cranked") elseif GetConVar("tm_gamemode"):GetInt() == 2 then SetGlobal2String("ActiveGamemode", "Gun Game") elseif GetConVar("tm_gamemode"):GetInt() == 3 then SetGlobal2String("ActiveGamemode", "Shotty Snipers") elseif GetConVar("tm_gamemode"):GetInt() == 4 then SetGlobal2String("ActiveGamemode", "Fiesta") elseif GetConVar("tm_gamemode"):GetInt() == 5 then SetGlobal2String("ActiveGamemode", "Quickdraw") elseif GetConVar("tm_gamemode"):GetInt() == 6 then SetGlobal2String("ActiveGamemode", "KOTH") elseif GetConVar("tm_gamemode"):GetInt() == 7 then SetGlobal2String("ActiveGamemode", "VIP") elseif GetConVar("tm_gamemode"):GetInt() == 8 then SetGlobal2String("ActiveGamemode", "Overkill") elseif GetConVar("tm_gamemode"):GetInt() >= 9 then SetGlobal2String("ActiveGamemode", "Fisticuffs") end

if !ConVarExists("tm_matchlengthtimer") then CreateConVar("tm_matchlengthtimer", "600", FCVAR_REPLICATED + FCVAR_NOTIFY, "Changes the matches length to the selected value in seconds", 0, 3600) end
if !ConVarExists("tm_intermissiontimer") then CreateConVar("tm_intermissiontimer", "30", FCVAR_REPLICATED + FCVAR_NOTIFY, "Changes the intermission length to the selected value in seconds", 0, 600) end
if !ConVarExists("tm_developermode") then CreateConVar("tm_developermode", "0", FCVAR_REPLICATED + FCVAR_NOTIFY, "Enables Sandbox features on server start and enables certain debugging tools, having this enabled will disable progression for all players", 0, 1) end

if !ConVarExists("sv_tm_player_health") then CreateConVar("sv_tm_player_health", "100", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The max health of the player (100 by default)") end
if !ConVarExists("sv_tm_player_speed_multi") then CreateConVar("sv_tm_player_speed_multi", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier for the speed of the player (affects walking, sprinting, crouching, sliding, and ladder climbing speeds) (1 by default)") end
if !ConVarExists("sv_tm_player_gravity_multi") then CreateConVar("sv_tm_player_gravity_multi", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier for the strength of gravity affecting the player (1 by default)") end
if !ConVarExists("sv_tm_player_jump_multi") then CreateConVar("sv_tm_player_jump_multi", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier for the strength of the players jump (1 by default)") end
if !ConVarExists("sv_tm_player_duckstate_multi") then CreateConVar("sv_tm_player_duckstate_multi", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier of the speed at which the player enters/exits a crocuh after the key is pressed/released (1 by default)") end
if !ConVarExists("sv_tm_player_crouchwalkspeed_multi") then CreateConVar("sv_tm_player_crouchwalkspeed_multi", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier of the players wakling speed while crouched (1 by default)") end
if !ConVarExists("sv_tm_player_slide_speed_multi") then CreateConVar("sv_tm_player_slide_speed_multi", "1.55", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier of the players speed while sliding (1.55 by default)") end
if !ConVarExists("sv_tm_player_slide_duration") then CreateConVar("sv_tm_player_slide_duration", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) that a players slide lasts (1 by default)") end
if !ConVarExists("sv_tm_player_healthregen") then CreateConVar("sv_tm_player_healthregen_enable", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable or disable health regeneration on players (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_player_healthregen_speed") then CreateConVar("sv_tm_player_healthregen_speed", "0.12", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The speed of the players health regeneration (0.12 by default)") end
if !ConVarExists("sv_tm_player_healthregen_damagedelay") then CreateConVar("sv_tm_player_healthregen_damagedelay", "3.5", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) from when the player was last hit to begin health regeneration (3.5 by default)") end
if !ConVarExists("sv_tm_progression_forcedisable") then CreateConVar("sv_tm_progression_forcedisable", "0", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Any progress or unlocks made during a play session will be reset upon leaving (0 by default)", 0, 1) end
if !ConVarExists("sv_tm_progression_xp_multi") then CreateConVar("sv_tm_progression_xp_multi", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Multiplies all sources of XP (kills, accolades, and more) (1 by default)") end
if !ConVarExists("sv_tm_ffa_use_primary") then CreateConVar("sv_tm_ffa_use_primary", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable primary weapons for the players loadout (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_ffa_use_secondary") then CreateConVar("sv_tm_ffa_use_secondary", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable secondary weapons for the players loadout (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_ffa_use_melee") then CreateConVar("sv_tm_ffa_use_melee", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable melee weapons/gadgets for the players loadout (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_fiesta_shuffle_time") then CreateConVar("sv_tm_fiesta_shuffle_time", "30", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) between each loadout swap (30 by default)") end
if !ConVarExists("sv_tm_gungame_ladder_size") then CreateConVar("sv_tm_gungame_ladder_size", "26", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The amount of weapons a player needs to get kills with to win a match (26 by default)", 2) end
if !ConVarExists("sv_tm_cranked_selfdestruct_time") then CreateConVar("sv_tm_cranked_selfdestruct_time", "25", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) that it takes for a player to explode after being Cranked (25 by default)", 10) end
if !ConVarExists("sv_tm_cranked_buff_multi") then CreateConVar("sv_tm_cranked_buff_multi", "1.33", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The multiplier for the buffs that being Cranked gives to a player (1.33 by default)", 1) end
if !ConVarExists("sv_tm_koth_scoring_interval") then CreateConVar("sv_tm_koth_scoring_interval", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) that a hill check is done, this is repeating (obviously) (1 by default)", 0.5, 5) end
if !ConVarExists("sv_tm_koth_score") then CreateConVar("sv_tm_koth_score", "15", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Sets the amount of score that is given to a player standing on the hill (15 by default)", 1) end
if !ConVarExists("sv_tm_vip_scoring_interval") then CreateConVar("sv_tm_vip_scoring_interval", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The time (in seconds) that a VIP check is done, this is repeating (obviously) (1 by default)", 0.5, 5) end
if !ConVarExists("sv_tm_vip_score") then CreateConVar("sv_tm_vip_score", "10", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Sets the amount of score that is given to the VIP (10 by default)", 1) end
if !ConVarExists("sv_tm_grapple_cooldown") then CreateConVar("sv_tm_grapple_cooldown", "15", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The cooldown (in sceonds) of the grappling hook after being used (15 by default)") end
if !ConVarExists("sv_tm_grapple_killreset") then CreateConVar("sv_tm_grapple_killreset", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable or disable the grapple cooldown reset on a player kill (1 by default)", 0, 1) end
if !ConVarExists("sv_tm_grapple_range") then CreateConVar("sv_tm_grapple_range", "850", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The length (in units) that the grappling hook can travel too before despawning (850 by default)") end
if !ConVarExists("sv_tm_voip_range") then CreateConVar("sv_tm_voip_range", "1000", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "The thresehold in distance where players can hear other players over proximity voice chat (1000 by default)") end
if !ConVarExists("sv_tm_matchvoting") then CreateConVar("sv_tm_matchvoting", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable or disable the end of match map and gamemode vote (disabling this will select a map and gamemode at random after a match ends) (1 by default)") end
if !ConVarExists("sv_tm_player_custommovement") then CreateConVar("sv_tm_player_custommovement", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable or disable Titanmod's custom movement mechanics (wall running/jumping, sliding, vaulting) (1 by default)") end
if !ConVarExists("sv_tm_player_jumpsliding") then CreateConVar("sv_tm_player_jumpsliding", "0", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Removes the jump sliding patch, making movement more in line with older Titanmod versions (0 by default)") end
if !ConVarExists("sv_tm_deathcam") then CreateConVar("sv_tm_deathcam", "1", FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE, "Enable or disable Titanmod's custom death camera on a players death (showing the killers POV after a death), this can still be disabled by players client-side (1 by default)") end
include("!config.lua")

if CLIENT then
    CreateClientConVar("tm_menusounds", 1, true, false, "Enable/disable the menu sounds", 0, 1)
    CreateClientConVar("tm_hitsounds", 1, true, false, "Enable/disable the hitsounds", 0, 1)
    CreateClientConVar("tm_killsound", 1, true, false, "Enable/disable the kill confirmation sound", 0, 1)
    CreateClientConVar("tm_musicvolume", 1, true, false, "Increase or lower the volume of music", 0, 1)
    CreateClientConVar("tm_hitsoundtype", 0, true, false, "Switch between the multiple styles of hitsounds", 0, 5)
    CreateClientConVar("tm_killsoundtype", 0, true, false, "Switch between the multiple styles of kill sounds", 0, 5)
    CreateClientConVar("tm_headshotkillsoundtype", 0, true, false, "Switch between the multiple styles of kill sounds when getting a headshot kill", 0, 5)
    CreateClientConVar("tm_nadebind", KEY_4, true, true, "Determines the keybind that will begin cocking a grenade")
    CreateClientConVar("tm_mainmenubind", KEY_M, true, true, "Determines the keybind that will open the main menu")
    CreateClientConVar("tm_quickswitching", 1, true, true, "Enable/disable quick weapon switching via keybinds", 0, 1)
    CreateClientConVar("tm_primarybind", KEY_1, true, true, "Determines the keybind that will quick switch to your primary weapon")
    CreateClientConVar("tm_secondarybind", KEY_2, true, true, "Determines the keybind that will quick switch to your secondary weapon")
    CreateClientConVar("tm_meleebind", KEY_3, true, true, "Determines the keybind that will quick switch to your melee")
    CreateClientConVar("tm_hidestatsfromothers", 0, true, true, "Determines if other players can see and/or compare your stats", 0, 1)
    CreateClientConVar("tm_screenflashes", 1, true, false, "Enable/disable sudden screen flashes on certain occasions (mainly dying and leveling up)", 0, 1)
    CreateClientConVar("tm_lensflare", 1, true, false, "Enable/disable lens flare effects", 0, 1)
    CreateClientConVar("tm_deathcam", 1, true, true, "Enable/disable the custom death camera when killed by another player", 0, 1)
    CreateClientConVar("tm_customfov", 0, true, true, "Enable/disable Titanmod's custom FOV system", 0, 1)
    CreateClientConVar("tm_customfov_value", 100, true, true, "Adjust the players FOV while using Titanmod's custom FOV system", 100, 144)
    CreateClientConVar("tm_customfov_sprint", 1, true, true, "Increase the players FOV while sprinting", 0, 1)
    CreateClientConVar("tm_sensitivity_1x", 80, true, true, "Adjust the sensitivity when using iron sights/low zoom optics", 1, 100)
    CreateClientConVar("tm_sensitivity_2x", 50, true, true, "Adjust the sensitivity when using medium zoom optics", 1, 100)
    CreateClientConVar("tm_sensitivity_4x", 25, true, true, "Adjust the sensitivity when using medium-high zoom optics", 1, 100)
    CreateClientConVar("tm_sensitivity_6x", 12, true, true, "Adjust the sensitivity when using high zoom optics", 1, 100)
    CreateClientConVar("tm_sensitivity_transition", 1, true, true, "Adjust the style of transition between different zoom sensitivities", 0, 1)
    CreateClientConVar("tm_renderhands", 1, true, false, "Enable/disable the rendering of your own hands", 0, 1)
    CreateClientConVar("tm_autosprint", 0, true, true, "Enable/disable automatic sprinting while moving", 0, 1)
    CreateClientConVar("tm_autosprint_delay", 0.25, true, true, "Adjust the time between pressing a mouse button and being able to auto sprint again", 0.25, 0.50)

    CreateClientConVar("tm_hud_enable", 1, true, false, "Enable/disable any custom HUD elements created by the gamemode", 0, 1)
    CreateClientConVar("tm_hud_scale", 1, true, false, "Adjust the scale for all HUD items", 0.5, 2)
    CreateClientConVar("tm_hud_bounds_x", 15, true, false, "Adjust the HUD bounds on the X axis, moving all hud elements from the edge of your screen", 0, 480)
    CreateClientConVar("tm_hud_bounds_y", 15, true, false, "Adjust the HUD bounds on the Y axis, moving all hud elements from the edge of your screen", 0, 270)
    CreateClientConVar("tm_hud_text_color_r", 255, true, false, "Adjusts the red coloring of the HUD text", 0, 255)
    CreateClientConVar("tm_hud_text_color_g", 255, true, false, "Adjusts the green coloring of the HUD text", 0, 255)
    CreateClientConVar("tm_hud_text_color_b", 255, true, false, "Adjusts the blue coloring of the HUD text", 0, 255)
    CreateClientConVar("tm_hud_enablekillfeed", 1, true, false, "Enable/disable the kill feed", 0, 1)
    CreateClientConVar("tm_hud_font", "Bender", true, false, "Enable/disable any custom HUD elements created by the gamemode")
    CreateClientConVar("tm_hud_ammo_style", 0, true, false, "Adjusts the style and look of the ammo counter", 0, 1)
    CreateClientConVar("tm_hud_ammo_bar_color_r", 150, true, false, "Adjusts the red coloring for the ammo bar", 0, 255)
    CreateClientConVar("tm_hud_ammo_bar_color_g", 100, true, false, "Adjusts the green coloring for the ammo bar", 0, 255)
    CreateClientConVar("tm_hud_ammo_bar_color_b", 50, true, false, "Adjusts the blue coloring for the ammo bar", 0, 255)
    CreateClientConVar("tm_hud_health_size", 450, true, false, "Adjusts the size of the players health bar", 100, 1000)
    CreateClientConVar("tm_hud_health_offset_x", 0, true, false, "Adjusts the X offset of the players health bar", 0, 1920)
    CreateClientConVar("tm_hud_health_offset_y", 0, true, false, "Adjusts the Y offset of the players health bar", 0, 1080)
    CreateClientConVar("tm_hud_health_color_high_r", 100, true, false, "Adjusts the red coloring for the health bar while on high health", 0, 255)
    CreateClientConVar("tm_hud_health_color_high_g", 180, true, false, "Adjusts the green coloring for the health bar while on high health", 0, 255)
    CreateClientConVar("tm_hud_health_color_high_b", 100, true, false, "Adjusts the blue coloring for the health bar while on high health", 0, 255)
    CreateClientConVar("tm_hud_health_color_mid_r", 180, true, false, "Adjusts the red coloring for the health bar while on medium health", 0, 255)
    CreateClientConVar("tm_hud_health_color_mid_g", 180, true, false, "Adjusts the green coloring for the health bar while on medium health", 0, 255)
    CreateClientConVar("tm_hud_health_color_mid_b", 100, true, false, "Adjusts the blue coloring for the health bar while on medium health", 0, 255)
    CreateClientConVar("tm_hud_health_color_low_r", 180, true, false, "Adjusts the red coloring for the health bar while on low health", 0, 255)
    CreateClientConVar("tm_hud_health_color_low_g", 100, true, false, "Adjusts the green coloring for the health bar while on low health", 0, 255)
    CreateClientConVar("tm_hud_health_color_low_b", 100, true, false, "Adjusts the blue coloring for the health bar while on low health", 0, 255)
    CreateClientConVar("tm_hud_equipment_offset_x", 525, true, false, "Adjusts the X offset of the players equipment UI", 0, 1920)
    CreateClientConVar("tm_hud_equipment_offset_y", 0, true, false, "Adjusts the Y offset of the players equipment UI", 0, 1080)
    CreateClientConVar("tm_hud_equipment_anchor", 0, true, false, "Adjusts the anchoring of the players equipment UI", 0, 2)
    CreateClientConVar("tm_hud_killfeed_style", 0, true, false, "Switch the killfeed entries between ascending and descending", 0, 1)
    CreateClientConVar("tm_hud_killfeed_limit", 6, true, false, "Limit the amount of kill feed entries that are shown at one time", 1, 10)
    CreateClientConVar("tm_hud_killfeed_offset_x", 0, true, false, "Adjusts the X offset of the kill feed", 0, 1920)
    CreateClientConVar("tm_hud_killfeed_offset_y", 40, true, false, "Adjusts the Y offset of the kill feed", 0, 1080)
    CreateClientConVar("tm_hud_killfeed_opacity", 80, true, false, "Adjusts the background opacity of a kill feed entry", 0, 255)
    CreateClientConVar("tm_hud_killdeath_offset_x", 0, true, false, "Adjusts the X offset of the kill and death UI", -960, 960)
    CreateClientConVar("tm_hud_killdeath_offset_y", 335, true, false, "Adjusts the Y offset of the kill and death UI", 0, 1080)
    CreateClientConVar("tm_hud_kill_iconcolor_r", 255, true, false, "Adjusts the red coloring for the kill icon", 0, 255)
    CreateClientConVar("tm_hud_kill_iconcolor_g", 255, true, false, "Adjusts the green coloring for the kill icon", 0, 255)
    CreateClientConVar("tm_hud_kill_iconcolor_b", 255, true, false, "Adjusts the blue coloring for the kill icon", 0, 255)
    CreateClientConVar("tm_hud_reloadhint", 1, true, false, "Enable/disable the reload text when out of ammo", 0, 1)
    CreateClientConVar("tm_hud_loadouthint", 1, true, false, "Enable/disable the loadout info displaying on player spawn", 0, 1)
    CreateClientConVar("tm_hud_killtracker", 0, true, false, "Enable/disable the weapon specific kill tracking on the UI", 0, 1)
    CreateClientConVar("tm_hud_keypressoverlay", 0, true, false, "Enable/disable the keypress overlay (shows which keys are being pressed on your screen)", 0, 1)
    CreateClientConVar("tm_hud_keypressoverlay_x", 0, true, false, "Adjusts the X offset of the keypress overlay", 0, 1920)
    CreateClientConVar("tm_hud_keypressoverlay_y", 0, true, false, "Adjusts the Y offset of the keypress overlay", 0, 1080)
    CreateClientConVar("tm_hud_keypressoverlay_inactive_r", 255, true, false, "Adjusts the red coloring for a inactive key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_inactive_g", 255, true, false, "Adjusts the green coloring for a inactive key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_inactive_b", 255, true, false, "Adjusts the blue coloring for a inactive key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_actuated_r", 255, true, false, "Adjusts the red coloring for a actuated key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_actuated_g", 0, true, false, "Adjusts the green coloring for a actuated key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_keypressoverlay_actuated_b", 0, true, false, "Adjusts the blue coloring for a actuated key on the keypress overlay", 0, 255)
    CreateClientConVar("tm_hud_velocitycounter", 0, true, false, "Enable/disable a velocity counter", 0, 1)
    CreateClientConVar("tm_hud_velocitycounter_x", 0, true, false, "Adjusts the X offset of the FPS and ping counter", 0, 1920)
    CreateClientConVar("tm_hud_velocitycounter_y", 190, true, false, "Adjusts the Y offset of the FPS and ping counter", 0, 1080)
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
    CreateClientConVar("tm_hud_dmgindicator", 1, true, false, "Enable/disable damage indicators", 0, 1)
    CreateClientConVar("tm_hud_dmgindicator_color_r", 255, true, false, "Adjusts the red coloring for the damage indicator", 0, 255)
    CreateClientConVar("tm_hud_dmgindicator_color_g", 0, true, false, "Adjusts the green coloring for the damage indicator", 0, 255)
    CreateClientConVar("tm_hud_dmgindicator_color_b", 0, true, false, "Adjusts the blue coloring for the damage indicator", 0, 255)
    CreateClientConVar("tm_hud_dmgindicator_opacity", 85, true, false, "Adjusts the opacity for the damage indicator", 0, 255)
    CreateClientConVar("tm_hud_crosshair", 1, true, false, "Enable/disable the crosshair", 0, 1)
    CreateClientConVar("tm_hud_crosshair_style", 1, true, false, "Adjusts the crosshair style", 0, 1)
    CreateClientConVar("tm_hud_crosshair_gap", 4, true, false, "Adjusts the crosshair gap", 0, 100)
    CreateClientConVar("tm_hud_crosshair_size", 8, true, false, "Adjusts the crosshair size", 0, 100)
    CreateClientConVar("tm_hud_crosshair_thickness", 2, true, false, "Adjusts the crosshair thickness", 0, 100)
    CreateClientConVar("tm_hud_crosshair_dot", 0, true, false, "Enable/disable the crosshair dot", 0, 1)
    CreateClientConVar("tm_hud_crosshair_outline", 0, true, false, "Enable/disable the crosshair outline", 0, 1)
    CreateClientConVar("tm_hud_crosshair_opacity", 255, true, false, "Adjusts the crosshair opacity", 0, 255)
    CreateClientConVar("tm_hud_crosshair_color_r", 255, true, false, "Adjusts the red coloring for the crosshair", 0, 255)
    CreateClientConVar("tm_hud_crosshair_color_g", 255, true, false, "Adjusts the green coloring for the crosshair", 0, 255)
    CreateClientConVar("tm_hud_crosshair_color_b", 255, true, false, "Adjusts the blue coloring for the crosshair", 0, 255)
    CreateClientConVar("tm_hud_crosshair_outline_color_r", 0, true, false, "Adjusts the red coloring for the crosshair outline", 0, 255)
    CreateClientConVar("tm_hud_crosshair_outline_color_g", 0, true, false, "Adjusts the green coloring for the crosshair outline", 0, 255)
    CreateClientConVar("tm_hud_crosshair_outline_color_b", 0, true, false, "Adjusts the blue coloring for the crosshair outline", 0, 255)
    CreateClientConVar("tm_hud_crosshair_show_t", 1, true, false, "Enable/disable the top of the crosshair", 0, 1)
    CreateClientConVar("tm_hud_crosshair_show_b", 1, true, false, "Enable/disable the bottom of the crosshair", 0, 1)
    CreateClientConVar("tm_hud_crosshair_show_l", 1, true, false, "Enable/disable the left of the crosshair", 0, 1)
    CreateClientConVar("tm_hud_crosshair_show_r", 1, true, false, "Enable/disable the right of the crosshair", 0, 1)
    CreateClientConVar("tm_hud_crosshair_sprint", 0, true, false, "Enable/disable the crosshair while sprinting", 0, 1)
    CreateClientConVar("tm_hud_hitmarker", 1, true, false, "Enable/disable the hitmarker", 0, 1)
    CreateClientConVar("tm_hud_hitmarker_gap", 8, true, false, "Adjusts the hitmarker gap", 0, 100)
    CreateClientConVar("tm_hud_hitmarker_size", 8, true, false, "Adjusts the hitmarker size", 0, 100)
    CreateClientConVar("tm_hud_hitmarker_thickness", 2, true, false, "Adjusts the hitmarker thickness", 0, 20)
    CreateClientConVar("tm_hud_hitmarker_opacity", 200, true, false, "Adjusts the hitmarker opacity", 0, 255)
    CreateClientConVar("tm_hud_hitmarker_duration", 2.5, true, false, "Adjusts the hitmarker opacity", 1, 5)
    CreateClientConVar("tm_hud_hitmarker_color_hit_r", 255, true, false, "Adjusts the red coloring for the hitmarker", 0, 255)
    CreateClientConVar("tm_hud_hitmarker_color_hit_g", 255, true, false, "Adjusts the green coloring for the hitmarker", 0, 255)
    CreateClientConVar("tm_hud_hitmarker_color_hit_b", 255, true, false, "Adjusts the blue coloring for the hitmarker", 0, 255)
    CreateClientConVar("tm_hud_hitmarker_color_head_r", 255, true, false, "Adjusts the red coloring for the hitmarker on a headshot", 0, 255)
    CreateClientConVar("tm_hud_hitmarker_color_head_g", 0, true, false, "Adjusts the green coloring for the hitmarker on a headshot", 0, 255)
    CreateClientConVar("tm_hud_hitmarker_color_head_b", 0, true, false, "Adjusts the blue coloring for the hitmarker on a headshot", 0, 255)
    CreateClientConVar("tm_hud_notifications", 1, true, false, "Enable/disable HUD notifications", 0, 1)
    CreateClientConVar("tm_hud_voiceindicator", 1, true, false, "Enable/disable the voice indicator", 0, 1)
end

-- include derma skin
if SERVER then
    AddCSLuaFile("skins/tm.lua")
elseif CLIENT then
    include("skins/tm.lua")
    hook.Add("ForceDermaSkin", "EFGMDermaSkin", function() return "Titanmod Derma Skin" end)
end