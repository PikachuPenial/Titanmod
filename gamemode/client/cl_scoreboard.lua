local white = Color(255, 255, 255, 255)

local ScoreboardDerma
local PlayerList

local mapName
local mapThumb

for i = 1, #mapArray do
	if game.GetMap() == mapArray[i][1] then
		mapName = mapArray[i][2]
		mapThumb = mapArray[i][3]
	end
end

function GM:ScoreboardShow()
	local LocalPlayer = LocalPlayer()
	if not IsValid(ScoreboardDerma) then

		ScoreboardDerma = vgui.Create("DFrame")
		if player.GetCount() < 5 then ScoreboardDerma:SizeTo(640, 164 + (player.GetCount() * 100), 0.5, 0, 0.1) else ScoreboardDerma:SizeTo(640, 664, 0.5, 0, 0.1) end
		ScoreboardDerma:SetTitle("")
		ScoreboardDerma:MakePopup()
		ScoreboardDerma:SetDraggable(false)
		ScoreboardDerma:ShowCloseButton(false)
		ScoreboardDerma:SetBackgroundBlur(true)
		ScoreboardDerma:SetAlpha(0)

		ScoreboardDerma:AlphaTo(255, 0.1, 0)

		ScoreboardDerma.Paint = function(self, w, h)
			ScoreboardDerma:SetPos(ScrW() / 2 - ScoreboardDerma:GetWide() / 2, ScrH() / 2 - ScoreboardDerma:GetTall() / 2)

			BlurPanel(ScoreboardDerma, 5)

			draw.RoundedBox(0, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(35, 35, 35, 150))
			draw.SimpleTextOutlined("TITANMOD", "TitleText", 15, 15, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0.5, Color(0, 0, 0, 100))

			surface.SetDrawColor(Color(255, 255, 255, 155))
			surface.DrawRect(0, 0, w, 1)
			surface.DrawRect(0, h - 1, w, 1)
			surface.DrawRect(0, 0, 1, h)
			surface.DrawRect(w - 1, 0, 1, h)
		end

		local PlayerScrollPanel = vgui.Create("DScrollPanel", ScoreboardDerma)
		PlayerScrollPanel:Dock(TOP)
		if player.GetCount() < 5 then PlayerScrollPanel:SetSize(630, player.GetCount() * 100) else PlayerScrollPanel:SetSize(630, 500) end
		PlayerScrollPanel:SetPos(0, 0)
		PlayerScrollPanel.Paint = function(self, w, h)
			BlurPanel(PlayerList, 5)
			surface.SetDrawColor(Color(255, 255, 255, 25))
			surface.DrawRect(0, 0, w, 1)
			surface.DrawRect(0, h - 1, w, 1)
			surface.DrawRect(0, 0, 1, h)
			surface.DrawRect(w - 1, 0, 1, h)
		end

        local sbar = PlayerScrollPanel:GetVBar()
        sbar:SetHideButtons(true)
        function sbar:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 100))
			surface.SetDrawColor(Color(255, 255, 255, 25))
			surface.DrawRect(0, 0, w, 1)
			surface.DrawRect(0, h - 1, w, 1)
			surface.DrawRect(w - 1, 0, 1, h)
        end
        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(0, 5, 8, 5, h - 16, Color(255, 255, 255, 175))
        end

		PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
		PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
		PlayerList:SetPos(0, 0)
		PlayerList.Paint = function(self, w, h)
		end

		local MapInfoPanel = vgui.Create("DPanel", ScoreboardDerma)
		MapInfoPanel:Dock(TOP)
		MapInfoPanel:SetSize(0, 100)

		local PlayersIcon = vgui.Create("DImage", MapInfoPanel)
		PlayersIcon:SetSize(30, 30)
		PlayersIcon:SetImage("icons/playericon.png")

		MapInfoPanel.Paint = function()
			if mapName != nil then
				PlayersIcon:SetPos(102, 52)

				draw.SimpleText(player.GetCount() .. " / " .. game.MaxPlayers(), "StreakText", 142, 55, white, TEXT_ALIGN_LEFT)
				draw.SimpleText(activeGamemode .. " on " .. mapName, "StreakText", 102, 75, white, TEXT_ALIGN_LEFT)
			else
				PlayersIcon:SetPos(0, 52)

				draw.SimpleText(player.GetCount() .. " / " .. game.MaxPlayers(), "StreakText", 40, 55, white, TEXT_ALIGN_LEFT)
				draw.SimpleText(activeGamemode .. " on " .. game.GetMap(), "StreakText", 0, 75, white, TEXT_ALIGN_LEFT)
			end
		end

		if mapName != nil then
			MapThumb = vgui.Create("DImage", MapInfoPanel)
			MapThumb:SetPos(0, 5)
			MapThumb:SetSize(100, 100)
			MapThumb:SetImage(mapThumb)
		end

		local levelAnim = 0
		local xpCountUp = 0
		local LevelingPanel = vgui.Create("DPanel", ScoreboardDerma)
		LevelingPanel:Dock(TOP)
		LevelingPanel:SetSize(0, 30)

		LevelingPanel.Paint = function(self, w, h)
			surface.SetDrawColor(35, 35, 35, 100)
			surface.DrawRect(0, 20, 630, 10)

			surface.SetDrawColor(255, 255, 0, 50)
			if LocalPlayer:GetNWInt("playerLevel") != 60 then
				xpCountUp = math.Clamp(xpCountUp + LocalPlayer:GetNWInt("playerXP") * FrameTime() * 4, 0, LocalPlayer:GetNWInt("playerXP"))
				levelAnim = math.Clamp(levelAnim + (LocalPlayer:GetNWInt("playerXP") / LocalPlayer:GetNWInt("playerXPToNextLevel")) * FrameTime() * 4, 0, LocalPlayer:GetNWInt("playerXP") / LocalPlayer:GetNWInt("playerXPToNextLevel"))
				draw.SimpleText("P" .. LocalPlayer:GetNWInt("playerPrestige") .. " L" .. LocalPlayer:GetNWInt("playerLevel") .. " | " .. math.Round(xpCountUp) .. " / " .. LocalPlayer:GetNWInt("playerXPToNextLevel") .. "XP", "StreakText", 0, -3, white, TEXT_ALIGN_LEFT)
				surface.DrawRect(0, 20, levelAnim * 630, 10)
			else
				draw.SimpleText("P" .. LocalPlayer:GetNWInt("playerPrestige") .. " L" .. LocalPlayer:GetNWInt("playerLevel"), "StreakText", 0, -3, white, TEXT_ALIGN_LEFT)
				surface.DrawRect(0, 20, 630, 10)
			end
		end
	end

	if IsValid(ScoreboardDerma) then
		PlayerList:Clear()

		local connectedPlayers = player.GetAll()
		if activeGamemode == "Gun Game" then table.sort(connectedPlayers, function(a, b) return a:GetNWInt("ladderPosition") > b:GetNWInt("ladderPosition") end) else table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end) end

		for k, v in pairs(connectedPlayers) do
			-- constants for basic player information, much more optimized than checking every frame
			local name = v:GetName()
			local prestige = v:GetNWInt("playerPrestige")
			local level = v:GetNWInt("playerLevel")
			local ping = v:Ping()
			local ratio
			local score = v:GetNWInt("playerScoreMatch")

			surface.SetFont("StreakText")
			local pingLength = select(1, surface.GetTextSize(ping))

			local usergroup
			if v:IsUserGroup("dev") then usergroup = "dev" elseif v:IsUserGroup("mod") then usergroup = "mod" elseif v:IsUserGroup("contributor") then usergroup = "contributor" end

			-- used to format the K/D Ratio of a player, stops it from displaying INF when the player has gotten a kill, but has also not died yet
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
					draw.RoundedBox(0, 0, 0, 630, h, Color(35, 35, 100, 100))
				elseif not v:Alive() then
					draw.RoundedBox(0, 0, 0, 630, h, Color(100, 35, 35, 100))
				else
					draw.RoundedBox(0, 0, 0, 630, h, Color(35, 35, 35, 100))
				end

				draw.SimpleText(name, "Health", 255, 5, white, TEXT_ALIGN_LEFT)
				draw.SimpleText("P" .. prestige .. " L" .. level, "Health", 255, 35, white, TEXT_ALIGN_LEFT)
				draw.SimpleText(ping .. "ms", "StreakText", 255, 72, white, TEXT_ALIGN_LEFT)
				draw.SimpleText(v:Frags(), "Health", 375, 35, Color(0, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(v:Deaths(), "Health", 420, 35, Color(255, 0, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(ratioRounded, "Health", 470, 35, Color(255, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(score, "Health", 540, 35, white, TEXT_ALIGN_CENTER)

				surface.SetFont("CaliberText")
				local roleLength = 0
				local mutedLength = 0

				if usergroup == "dev" then
					draw.SimpleText("(dev)", "CaliberText", pingLength + 285, 74, Color(205, 255, 0), TEXT_ALIGN_LEFT)
					roleLength = select(1, surface.GetTextSize("(dev)"))
				elseif usergroup == "mod" then
					draw.SimpleText("(mod)", "CaliberText", pingLength + 285, 74, Color(255, 0, 100), TEXT_ALIGN_LEFT)
					roleLength = select(1, surface.GetTextSize("(mod)"))
				elseif usergroup == "contributor" then
					draw.SimpleText("(contributor)", "CaliberText", pingLength + 285, 74, Color(0, 110, 255), TEXT_ALIGN_LEFT)
					roleLength = select(1, surface.GetTextSize("(contributor)"))
				end

				if v:IsMuted() then
					draw.SimpleText("(muted)", "CaliberText", pingLength + roleLength + 285, 74, Color(255, 0, 0), TEXT_ALIGN_LEFT)
					mutedLength = select(1, surface.GetTextSize("(muted)"))
				end

				if v:GetFriendStatus() == "friend" then
					draw.SimpleText("(friend)", "CaliberText", pingLength + roleLength + mutedLength + 285, 74, Color(0, 255, 0), TEXT_ALIGN_LEFT)
					mutedLength = select(1, surface.GetTextSize("(friend)"))
				end
			end

			local PlayerCallingCard = vgui.Create("DImage", PlayerPanel)
			PlayerCallingCard:SetPos(10, 10)
			PlayerCallingCard:SetSize(240, 80)

			if IsValid(v) then PlayerCallingCard:SetImage(v:GetNWString("chosenPlayercard"), "cards/color/black.png") end

			local PlayerProfilePicture = vgui.Create("AvatarImage", PlayerPanel)
			PlayerProfilePicture:SetPos(15, 15)
			PlayerProfilePicture:SetSize(70, 70)
			PlayerProfilePicture:SetPlayer(v, 184)

			-- allows the players profile to be clicked to display various options revolving around the specific player
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
					statistics:AddOption("Prestige " .. v:GetNWInt("playerPrestige") .. " Level " .. v:GetNWInt("playerLevel"))
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
					for i = 1, #weaponArray do
						weaponKills:AddOption(weaponArray[i][2] .. ": " .. v:GetNWInt("killsWith_" .. weaponArray[i][1]))
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

				if v != LocalPlayer then
					local muteToggle = Menu:AddOption("Mute Player", function(self)
						if v:IsMuted() then v:SetMuted(false) else v:SetMuted(true) end
					end)

					if v:IsMuted() then muteToggle:SetIcon("icon16/sound.png") muteToggle:SetText("Unmute Player") else muteToggle:SetIcon("icon16/sound_mute.png") muteToggle:SetText("Mute Player") end
				end

				Menu:Open()
			end
		end

		ScoreboardDerma:SetKeyboardInputEnabled(false)
	end
end

function GM:ScoreboardHide() if IsValid(ScoreboardDerma) then ScoreboardDerma:AlphaTo(0, 0.05, 0, function() ScoreboardDerma:Remove() end) end end