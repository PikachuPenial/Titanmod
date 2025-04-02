function UpdateFonts()
	-- MENUS
	surface.CreateFont("GunPrintName", {
		font = "Arial",
		size = TM.MenuScale(56),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("MainMenuLoadoutWeapons", {
		font = "Arial",
		size = TM.MenuScale(26),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("MainMenuDescription", {
		font = "Arial",
		size = TM.MenuScale(24),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("MainMenuTitle", {
		font = "Arial",
		size = TM.MenuScale(45),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("MatchEndText", {
		font = "Arial",
		size = TM.MenuScale(180),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("QuoteText", {
		font = "Tahoma",
		size = TM.MenuScale(22),
		weight = 200,
		antialias = true,
		italic = true
	} )

	surface.CreateFont("AmmoCountESmall", {
		font = "Arial",
		size = TM.MenuScale(48),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("AmmoCountSmall", {
		font = "Arial",
		size = TM.MenuScale(96),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("OptionsHeader", {
		font = "Arial",
		size = TM.MenuScale(64),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("Health", {
		font = "Tahoma",
		size = TM.MenuScale(30),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("StreakText", {
		font = "Tahoma",
		size = TM.MenuScale(22),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("TitleText", {
		font = "BenderBold",
		size = TM.MenuScale(32),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("CaliberText", {
		font = "Tahoma",
		size = TM.MenuScale(18),
		weight = 550,
		antialias = true
	} )

	surface.CreateFont("PlayerNotiName", {
		font = "Arial",
		size = TM.MenuScale(52),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("SettingsLabel", {
		font = "Arial",
		size = TM.MenuScale(38),
		weight = 500,
		antialias = true
	} )

	-- HUD
	surface.CreateFont("HUD_GunPrintName", {
		font = GetConVar("tm_hud_font"):GetString(),
		size = TM.HUDScale(56),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("HUD_AmmoCount", {
		font = GetConVar("tm_hud_font"):GetString(),
		size = TM.HUDScale(128),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("HUD_WepNameKill", {
		font = GetConVar("tm_hud_font"):GetString(),
		size = TM.HUDScale(28),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("HUD_Health", {
		font = GetConVar("tm_hud_font"):GetString(),
		size = TM.HUDScale(30),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("HUD_StreakText", {
		font = GetConVar("tm_hud_font"):GetString(),
		size = TM.HUDScale(22),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("HUD_PlayerNotiName", {
		font = GetConVar("tm_hud_font"):GetString(),
		size = TM.HUDScale(52),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("HUD_PlayerDeathName", {
		font = GetConVar("tm_hud_font"):GetString(),
		size = TM.HUDScale(36),
		weight = 500,
		antialias = true
	} )

	surface.CreateFont("HUD_IntermissionText", {
		font = GetConVar("tm_hud_font"):GetString(),
		size = TM.HUDScale(180),
		weight = 600,
		antialias = true,
		outline = true
	} )

	surface.CreateFont("HUD_AmmoCountSmall", {
		font = "Arial",
		size = TM.HUDScale(96),
		weight = 500,
		antialias = true
	} )
end
UpdateFonts()

hook.Add("OnScreenSizeChanged", "ResolutionChange", function() UpdateFonts() end)
cvars.AddChangeCallback("tm_hud_font", function(convar_name, value_old, value_new) UpdateFonts() end)
cvars.AddChangeCallback("tm_hud_scale", function(convar_name, value_old, value_new) UpdateFonts() end)