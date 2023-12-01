local white = Color(255, 255, 255, 255)

local ScoreboardDerma
local PlayerList

local mapName
local mapThumb
local dof

for m, t in pairs(mapArray) do
	if game.GetMap() == t[1] then
		mapName = t[2]
		mapThumb = t[3]
	end
end

function GM:ScoreboardShow()
	local LocalPlayer = LocalPlayer()
	if not IsValid(ScoreboardDerma) then
		if GetConVar("tm_menudof"):GetInt() == 1 then dof = true end

		ScoreboardDerma = vgui.Create("DFrame")
		if player.GetCount() < 5 then ScoreboardDerma:SetSize(640, 200 + (player.GetCount() * 100)) else ScoreboardDerma:SetSize(640, 700) end
		ScoreboardDerma:SetPos(ScrW() / 2 - 320, 0)
		ScoreboardDerma:SetTitle("")
		ScoreboardDerma:MakePopup()
		ScoreboardDerma:SetDraggable(false)
		ScoreboardDerma:ShowCloseButton(false)
		ScoreboardDerma:SetBackgroundBlur(true)
		ScoreboardDerma.Paint = function()
			if dof == true then
				DrawBokehDOF(2.5, 1, 12)
			end
			draw.RoundedBox(6, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(35, 35, 35, 150))
			draw.SimpleText("Titanmod", "StreakText", 15, 0, white, TEXT_ALIGN_LEFT)

			draw.SimpleText("Kills", "CaliberText", 380, 20, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Deaths", "CaliberText", 425, 20, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("K/D", "CaliberText", 475, 20, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Score", "CaliberText", 545, 20, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local InfoPanel = vgui.Create("DPanel", ScoreboardDerma)
		InfoPanel:Dock(TOP)
		InfoPanel:SetSize(0, 36)

		InfoPanel.Paint = function()
			draw.SimpleText(player.GetCount() .. " / " .. game.MaxPlayers(), "StreakText", 50, 5, white, TEXT_ALIGN_LEFT)
		end

		local PlayersIcon = vgui.Create("DImage", InfoPanel)
		PlayersIcon:SetPos(10, -2)
		PlayersIcon:SetSize(38, 38)
		PlayersIcon:SetImage("icons/playericon.png")

		local KillsIcon = vgui.Create("DImage", InfoPanel)
		KillsIcon:SetPos(360, 0)
		KillsIcon:SetSize(30, 30)
		KillsIcon:SetImage("icons/killicon.png")

		local DeathsIcon = vgui.Create("DImage", InfoPanel)
		DeathsIcon:SetPos(405, 0)
		DeathsIcon:SetSize(30, 30)
		DeathsIcon:SetImage("icons/deathicon.png")

		local KDIcon = vgui.Create("DImage", InfoPanel)
		KDIcon:SetPos(455, 0)
		KDIcon:SetSize(30, 30)
		KDIcon:SetImage("icons/ratioicon.png")

		local ScoreIcon = vgui.Create("DImage", InfoPanel)
		ScoreIcon:SetPos(525, 0)
		ScoreIcon:SetSize(30, 30)
		ScoreIcon:SetImage("icons/scoreicon.png")

		local PlayerScrollPanel = vgui.Create("DScrollPanel", ScoreboardDerma)
		PlayerScrollPanel:Dock(TOP)
		if player.GetCount() < 5 then PlayerScrollPanel:SetSize(ScoreboardDerma:GetWide(), player.GetCount() * 100) else PlayerScrollPanel:SetSize(ScoreboardDerma:GetWide(), 500) end
		PlayerScrollPanel:SetPos(0, 0)

		local sbar = PlayerScrollPanel:GetVBar()
		function sbar:Paint(w, h)
			draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 150))
		end
		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 155))
		end
		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 155))
		end
		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(16, 0, 0, w, h, Color(155, 155, 155, 155))
		end

		PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
		PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
		PlayerList:SetPos(0, 0)

		local MapInfoPanel = vgui.Create("DPanel", ScoreboardDerma)
		MapInfoPanel:Dock(TOP)
		MapInfoPanel:SetSize(0, 100)

		MapInfoPanel.Paint = function()
			if mapName != nil then
				draw.SimpleText("Playing " .. activeGamemode .. " on " .. mapName, "StreakText", 102.5, 60.5, white, TEXT_ALIGN_LEFT)
				draw.SimpleText("Match ends in " .. math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()) .. "s", "StreakText", 102.5, 80, white, TEXT_ALIGN_LEFT)
			else
				draw.SimpleText("Playing " .. activeGamemode .. " on " .. game.GetMap(), "StreakText", 2.5, 75, white, TEXT_ALIGN_LEFT)
			end
		end

		if mapName != nil then
			MapThumb = vgui.Create("DImage", MapInfoPanel)
			MapThumb:SetPos(0, 5)
			MapThumb:SetSize(100, 100)
			MapThumb:SetImage(mapThumb)
		end

		local LevelingPanel = vgui.Create("DPanel", ScoreboardDerma)
		LevelingPanel:Dock(TOP)
		LevelingPanel:SetSize(0, 30)

		LevelingPanel.Paint = function(self, w, h)
			draw.SimpleText("P" .. LocalPlayer:GetNWInt("playerPrestige") .. " L" .. LocalPlayer:GetNWInt("playerLevel") .. " | " .. LocalPlayer:GetNWInt("playerXP") .. " / " .. LocalPlayer:GetNWInt("playerXPToNextLevel") .. "XP", "StreakText", 0, -3, white, TEXT_ALIGN_LEFT)

			surface.SetDrawColor(35, 35, 35, 100)
			surface.DrawRect(0, 20, 630, 10)

			surface.SetDrawColor(255, 255, 0, 50)
			if LocalPlayer:GetNWInt("playerLevel") != 60 then
				surface.DrawRect(0, 20, (LocalPlayer:GetNWInt("playerXP") / LocalPlayer:GetNWInt("playerXPToNextLevel")) * 630, 10)
			end
		end
	end

	if IsValid(ScoreboardDerma) then
		ScoreboardDerma:MoveTo(ScrW() / 2 - 320, ScrH() / 2 - ScoreboardDerma:GetTall() / 2, 0.3, 0, 0.4)
		PlayerList:Clear()

		local connectedPlayers = player.GetAll()
		if activeGamemode == "Gun Game" then table.sort(connectedPlayers, function(a, b) return a:GetNWInt("ladderPosition") > b:GetNWInt("ladderPosition") end) else table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end) end

		for k, v in pairs(connectedPlayers) do
			-- Constants for basic player information, much more optimized than checking every frame
			local name = v:GetName()
			local prestige = v:GetNWInt("playerPrestige")
			local level = v:GetNWInt("playerLevel")
			local ping = v:Ping()
			local ratio
			local score = v:GetNWInt("playerScoreMatch")

			local usergroup
			if v:IsUserGroup("dev") then usergroup = "dev" elseif v:IsUserGroup("mod") then usergroup = "mod" elseif v:IsUserGroup("contributor") then usergroup = "contributor" end

			-- Used to format the K/D Ratio of a player, stops it from displaying INF when the player has gotten a kill, but has also not died yet
			if v:Frags() <= 0 then
				ratio = 0
			elseif v:Frags() >= 1 and v:Deaths() == 0 then
				ratio = v:Frags()
			else
				ratio = v:Frags() / v:Deaths()
			end

			local ratioRounded = math.Round(ratio, 2)

			local PlayerPanel = vgui.Create("DPanel", PlayerList)
			PlayerPanel:SetSize(PlayerList:GetWide(), 100)
			PlayerPanel:SetPos(0, 0)
			PlayerPanel.Paint = function(w, h)
				if not IsValid(v) then return end
				if v:GetNWBool("mainmenu") == true then
					draw.RoundedBox(6, 0, 0, 630, h, Color(35, 35, 100, 100))
				elseif not v:Alive() then
					draw.RoundedBox(6, 0, 0, 630, h, Color(100, 35, 35, 100))
				else
					draw.RoundedBox(6, 0, 0, 630, h, Color(35, 35, 35, 100))
				end

				draw.SimpleText(name, "Health", 255, 5, white, TEXT_ALIGN_LEFT)
				draw.SimpleText("P" .. prestige .. " L" .. level, "Health", 255, 35, white, TEXT_ALIGN_LEFT)
				draw.SimpleText(ping .. "ms", "StreakText", 255, 72, white, TEXT_ALIGN_LEFT)
				draw.SimpleText(v:Frags(), "Health", 375, 35, Color(0, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(v:Deaths(), "Health", 420, 35, Color(255, 0, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(ratioRounded, "Health", 470, 35, Color(255, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(score, "Health", 540, 35, white, TEXT_ALIGN_CENTER)

				if usergroup == "dev" then draw.SimpleText("Developer", "StreakText", 315, 72, Color(205, 255, 0), TEXT_ALIGN_LEFT) elseif usergroup == "mod" then draw.SimpleText("Moderator", "StreakText", 315, 72, Color(255, 0, 100), TEXT_ALIGN_LEFT) elseif usergroup == "contributor" then draw.SimpleText("Contributor", "StreakText", 315, 72, Color(0, 110, 255), TEXT_ALIGN_LEFT) end
			end

			local PlayerCallingCard = vgui.Create("DImage", PlayerPanel)
			PlayerCallingCard:SetPos(10, 10)
			PlayerCallingCard:SetSize(240, 80)

			if IsValid(v) then PlayerCallingCard:SetImage(v:GetNWString("chosenPlayercard"), "cards/color/black.png") end

			local PlayerProfilePicture = vgui.Create("AvatarImage", PlayerPanel)
			PlayerProfilePicture:SetPos(15, 15)
			PlayerProfilePicture:SetSize(70, 70)
			PlayerProfilePicture:SetPlayer(v, 184)

			-- Allows the players profile to be clicked to display various options revolving around the specific player
			PlayerProfilePicture.OnMousePressed = function()
				local Menu = DermaMenu()

				local profileButton = Menu:AddOption("Open Steam Profile", function() gui.OpenURL("http://steamcommunity.com/profiles/" .. v:SteamID64()) end)
				profileButton:SetIcon("icon16/page_find.png")

				Menu:AddSpacer()

				local statistics = Menu:AddSubMenu("View Stats")
				local accolades = Menu:AddSubMenu("View Accolades")
				local weaponstatistics = Menu:AddSubMenu("View Weapon Stats")
				local weaponKills = weaponstatistics:AddSubMenu("Kills With")
				weaponKills:SetMaxHeight(ScrH() / 1.5)

				if v:GetInfoNum("tm_hidestatsfromothers", 0) == 0 or v == LocalPlayer then
					statistics:AddOption("Level: P" .. v:GetNWInt("playerPrestige") .. " L" .. v:GetNWInt("playerLevel"))
					statistics:AddOption("Score: " .. v:GetNWInt("playerScore"))
					statistics:AddOption("Kills: " .. v:GetNWInt("playerKills"))
					statistics:AddOption("Deaths: " .. v:GetNWInt("playerDeaths"))
					statistics:AddOption("K/D Ratio: " .. math.Round(v:GetNWInt("playerKills") / v:GetNWInt("playerDeaths"), 3))
					statistics:AddOption("Highest Killstreak: " .. v:GetNWInt("highestKillStreak"))
					statistics:AddOption("Highest Kill Game: " .. v:GetNWInt("highestKillGame"))
					statistics:AddOption("Farthest Kill: " .. v:GetNWInt("farthestKill") .. "m")
					statistics:AddOption("Matches Played: " .. v:GetNWInt("matchesPlayed"))
					statistics:AddOption("Matches Won: " .. v:GetNWInt("matchesWon"))
					statistics:AddOption("W/L Ratio: " .. math.Round((v:GetNWInt("matchesWon") / v:GetNWInt("matchesPlayed")) * 100) .. "%")
					accolades:AddOption("Headshot Kills: " .. v:GetNWInt("playerAccoladeHeadshot"))
					accolades:AddOption("Smackdowns (Melee Kills): " .. v:GetNWInt("playerAccoladeSmackdown"))
					accolades:AddOption("Clutches (Kills with less than 15 HP): " .. v:GetNWInt("playerAccoladeClutch"))
					accolades:AddOption("Longshots: " .. v:GetNWInt("playerAccoladeLongshot"))
					accolades:AddOption("Point Blanks: " .. v:GetNWInt("playerAccoladePointblank"))
					accolades:AddOption("On Streaks (Kill Streaks Started): " .. v:GetNWInt("playerAccoladeOnStreak"))
					accolades:AddOption("Buzz Kills (Kill Streaks Ended): " .. v:GetNWInt("playerAccoladeBuzzkill"))
					for p, t in pairs(weaponArray) do
						weaponKills:AddOption(t[2] .. ": " .. v:GetNWInt("killsWith_" .. t[1]))
					end
				else
					statistics:AddOption("This player has their stats hidden.")
					accolades:AddOption("This player has their stats hidden.")
					weaponKills:AddOption("This player has their stats hidden.")
				end

				Menu:AddSpacer()

				local copyMenu = Menu:AddSubMenu("Copy...")
				copyMenu:AddOption("Copy Name", function() SetClipboardText(v:GetName()) end):SetIcon("icon16/cut.png")
				copyMenu:AddOption("Copy SteamID64", function() SetClipboardText(v:SteamID64()) end):SetIcon("icon16/cut.png")

				Menu:Open()
			end
		end

		ScoreboardDerma:SetKeyboardInputEnabled(false)
	end
end

function GM:ScoreboardHide() if IsValid(ScoreboardDerma) then ScoreboardDerma:Remove() end end