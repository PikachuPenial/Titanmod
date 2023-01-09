--Allows the player to save their local stats to the sv.db file without having to leave the server.
function ForceSave(ply, cmd, args)
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	if game.GetMap() == "tm_firingrange" then return end
	if forceDisableProgression == true then return end
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerScore", ply:GetNWInt("playerScore"))
	ply:SetPData("matchesPlayed", ply:GetNWInt("matchesPlayed"))
	ply:SetPData("matchesWon", ply:GetNWInt("matchesWon"))
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))
	ply:SetPData("playerLevel", ply:GetNWInt("playerLevel"))
	ply:SetPData("playerPrestige", ply:GetNWInt("playerPrestige"))
	ply:SetPData("playerXP", ply:GetNWInt("playerXP"))
	ply:SetPData("chosenPlayermodel", ply:GetNWString("chosenPlayermodel"))
	ply:SetPData("chosenPlayercard", ply:GetNWString("chosenPlayercard"))
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
			elseif modelUnlock == "kills" and ply:GetNWInt("playerKills") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "headshot" and ply:GetNWInt("playerAccoladeHeadshot") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "smackdown" and ply:GetNWInt("playerAccoladeSmackdown") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "clutch" and ply:GetNWInt("playerAccoladeClutch") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "longshot" and ply:GetNWInt("playerAccoladeLongshot") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "pointblank" and ply:GetNWInt("playerAccoladePointblank") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "killstreaks" and ply:GetNWInt("playerAccoladeOnStreak") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "buzzkills" and ply:GetNWInt("playerAccoladeBuzzkill") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "special" and modelValue == "name" and ply:SteamID() == "STEAM_0:1:514443768" then
				ply:SetNWString("chosenPlayermodel", modelID)
			end
		end
	end
end
concommand.Add("tm_selectplayermodel", PlayerModelChange)

--Allows the Main Menu to change the players current playercard.
function PlayerCardChange(ply, cmd, args)
	local masteryUnlockReq = 50
	for k, v in pairs(cardArray) do
		if (args[1] == v[1]) then
			local cardID = v[1]
			local cardUnlock = v[4]
			local cardValue = v[5]
			local playerTotalLevel = (ply:GetNWInt("playerPrestige") * 60) + ply:GetNWInt("playerLevel")

			if cardUnlock == "default" or cardUnlock == "color" then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "kills" and ply:GetNWInt("playerKills") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "headshot" and ply:GetNWInt("playerAccoladeHeadshot") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "smackdown" and ply:GetNWInt("playerAccoladeSmackdown") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "clutch" and ply:GetNWInt("playerAccoladeClutch") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "longshot" and ply:GetNWInt("playerAccoladeLongshot") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "pointblank" and ply:GetNWInt("playerAccoladePointblank") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "killstreaks" and ply:GetNWInt("playerAccoladeOnStreak") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "buzzkills" and ply:GetNWInt("playerAccoladeBuzzkill") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "level" and playerTotalLevel >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "mastery" and ply:GetNWInt("killsWith_" .. cardValue) >= masteryUnlockReq then
				ply:SetNWString("chosenPlayercard", cardID)
			end
		end
	end
end
concommand.Add("tm_selectplayercard", PlayerCardChange)

--Allows the player to spectate other players or to free roam at will using this command, or from the spectate dropdown in the Main Menu.
function StartCustomSpectate(ply, cmd, args)
	if (args[1] == "free") then
		ply:UnSpectate()
		ply:Spectate(OBS_MODE_ROAMING)
	end
end
concommand.Add("tm_spectate", StartCustomSpectate)

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

--Allows the player to test the look and feel of their customized kill/death/level up UI's.
function HUDTestKill(ply, cmd, args)
	net.Start("NotifyKill")
	net.WriteEntity(ply)
	net.WriteString("KRISS Vector")
	net.WriteFloat(69)
	net.WriteFloat(1)
	net.WriteInt(1)
	net.Send(ply)
end
concommand.Add("tm_hud_testkill", HUDTestKill)

function HUDTestDeath(ply, cmd, args)
	net.Start("NotifyDeath")
	net.WriteEntity(ply)
	net.WriteString("KRISS Vector")
	net.WriteFloat(69)
	net.WriteFloat(1)
	net.Send(ply)
end
concommand.Add("tm_hud_testdeath", HUDTestDeath)

function HUDTestLevelUp(ply, cmd, args)
	net.Start("NotifyLevelUp")
	net.WriteFloat(1)
	net.Send(ply)
end
concommand.Add("tm_hud_testlevelup", HUDTestLevelUp)

function ForceEndMatch(ply, cmd, args)
	if !ply:IsAdmin() then return end
	if args[1] == nil then return end

	for k, v in pairs(player.GetAll()) do
		v:KillSilent()
	end

	net.Start("EndOfGame")
	net.WriteString(args[1])
	net.Broadcast()

	local connectedPlayers = player.GetAll()
	table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end)

	for k, v in pairs(connectedPlayers) do
		v:SetNWInt("matchesPlayed", v:GetNWInt("matchesPlayed") + 1)
		if k == 1 then
			v:SetNWInt("matchesWon", v:GetNWInt("matchesWon") + 1)
			v:SetNWInt("playerXP", v:GetNWInt("playerXP") + 1500)
			CheckForPlayerLevel(v)
		end
	end

	timer.Create("forceMatchEndCooldown", 30, 1, function()
		RunConsoleCommand("changelevel", args[1])
	end)
end
concommand.Add("tm_forceendmatch", ForceEndMatch)

--Allows the player to wipe their account and start fresh.
function PlayerAccountWipe(ply, cmd, args)
	ply:SetNWInt("playerKills", 0)
	ply:SetNWInt("playerDeaths", 0)
	ply:SetNWInt("playerKDR", 1)
	ply:SetNWInt("playerScore", 0)
	ply:SetNWInt("matchesPlayed", 0)
	ply:SetNWInt("matchesWon", 0)
	ply:SetNWInt("highestKillStreak", 0)
	ply:SetNWInt("playerLevel", 1)
	ply:SetNWInt("playerPrestige", 0)
	ply:SetNWInt("playerXP", 0)
	ply:SetNWInt("playerXPToNextLevel", 750)
	ply:SetNWString("chosenPlayermodel", "models/player/Group03/male_02.mdl")
	ply:SetNWString("chosenPlayercard", "cards/default/construct.png")
	ply:SetNWInt("playerAccoladeHeadshot", 0)
	ply:SetNWInt("playerAccoladeSmackdown", 0)
	ply:SetNWInt("playerAccoladeLongshot", 0)
	ply:SetNWInt("playerAccoladePointblank", 0)
	ply:SetNWInt("playerAccoladeOnStreak", 0)
	ply:SetNWInt("playerAccoladeBuzzkill", 0)
	ply:SetNWInt("playerAccoladeClutch", 0)

	--Checking if PData exists for every single fucking weapon, GG.
	for k, v in pairs(weaponArray) do
		ply:SetNWInt("killsWith_" .. v[1], 0)
	end
end
concommand.Add("tm_wipeplayeraccount_cannotbeundone", PlayerAccountWipe)

--Allows the player to reset their custom HUD settings to default.
function PlayerHUDReset(ply, cmd, args)
	RunConsoleCommand("tm_hud_enable", 1)
	RunConsoleCommand("tm_hud_enablekill", 1)
	RunConsoleCommand("tm_hud_enabledeath", 1)
	RunConsoleCommand("tm_hud_font", "Arial")
	RunConsoleCommand("tm_hud_font_scale", 1)
	RunConsoleCommand("tm_hud_font_kill", 0)
	RunConsoleCommand("tm_hud_font_death", 0)
	RunConsoleCommand("tm_hud_ammo_style", 0)
	RunConsoleCommand("tm_hud_ammo_wep_text_color_r", 255)
	RunConsoleCommand("tm_hud_ammo_wep_text_color_g", 255)
	RunConsoleCommand("tm_hud_ammo_wep_text_color_b", 255)
	RunConsoleCommand("tm_hud_ammo_bar_color_r", 150)
	RunConsoleCommand("tm_hud_ammo_bar_color_g", 100)
	RunConsoleCommand("tm_hud_ammo_bar_color_b", 50)
	RunConsoleCommand("tm_hud_ammo_text_color_r", 255)
	RunConsoleCommand("tm_hud_ammo_text_color_g", 255)
	RunConsoleCommand("tm_hud_ammo_text_color_b", 255)
	RunConsoleCommand("tm_hud_health_size", 450)
	RunConsoleCommand("tm_hud_health_offset_x", 0)
	RunConsoleCommand("tm_hud_health_offset_y", 0)
	RunConsoleCommand("tm_hud_health_text_color_r", 255)
	RunConsoleCommand("tm_hud_health_text_color_g", 255)
	RunConsoleCommand("tm_hud_health_text_color_b", 255)
	RunConsoleCommand("tm_hud_health_color_high_r", 100)
	RunConsoleCommand("tm_hud_health_color_high_g", 180)
	RunConsoleCommand("tm_hud_health_color_high_b", 100)
	RunConsoleCommand("tm_hud_health_color_mid_r", 180)
	RunConsoleCommand("tm_hud_health_color_mid_g", 180)
	RunConsoleCommand("tm_hud_health_color_mid_b", 100)
	RunConsoleCommand("tm_hud_health_color_low_r", 180)
	RunConsoleCommand("tm_hud_health_color_low_g", 100)
	RunConsoleCommand("tm_hud_health_color_low_b", 100)
	RunConsoleCommand("tm_hud_killfeed_limit", 4)
	RunConsoleCommand("tm_hud_killfeed_offset_x", 0)
	RunConsoleCommand("tm_hud_killfeed_offset_y", 0)
	RunConsoleCommand("tm_hud_killdeath_offset_x", 0)
	RunConsoleCommand("tm_hud_killdeath_offset_y", 335)
	RunConsoleCommand("tm_hud_reloadhint", 1)
	RunConsoleCommand("tm_hud_loadouthint", 1)
	RunConsoleCommand("tm_hud_killaccolades", 1)
end
concommand.Add("tm_resethudtodefault_cannotbeundone", PlayerHUDReset)