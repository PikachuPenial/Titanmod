--Color array, saving space
local white = Color(255, 255, 255, 255)

local ScoreboardDerma
local mapID
local mapName
local mapDesc
local mapThumb
local dof

local timeUntilMapVote = GetConVar("tm_mapvotetimer"):GetInt()

net.Receive("UpdateClientMapVoteTime", function(len, ply)
    timeUntilMapVote = net.ReadFloat()
end)

function GM:ScoreboardShow()
	if not IsValid(ScoreboardDerma) then
		for m, t in pairs(mapArray) do
			if game.GetMap() == t[1] then
				mapID = t[1]
				mapName = t[2]
				mapDesc = t[3]
				mapThumb = t[4]
			end
		end

		if GetConVar("tm_menudof"):GetInt() == 1 then dof = true end

		ScoreboardDerma = vgui.Create("DFrame")
		ScoreboardDerma:SetSize(640, 600)
		ScoreboardDerma:SetPos(ScrW() / 2 - 320, 0)
		ScoreboardDerma:SetTitle("")
		ScoreboardDerma:SetDraggable(false)
		ScoreboardDerma:ShowCloseButton(false)
		ScoreboardDerma.Paint = function()
			if dof == true then
				DrawBokehDOF(4, 1, 0)
			end
			draw.RoundedBox(5, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(35, 35, 35, 150))
			draw.SimpleText("Titanmod", "StreakText", 15, 0, white, TEXT_ALIGN_LEFT)
		end

		local InfoPanel = vgui.Create("DPanel", ScoreboardDerma)
		InfoPanel:Dock(TOP)
		InfoPanel:SetSize(0, 36)

		InfoPanel.Paint = function(self, w, h)
			draw.SimpleText(player.GetCount() .. " / " .. game.MaxPlayers(), "StreakText", 50, 0, white, TEXT_ALIGN_LEFT)
		end

		local PlayersIcon = vgui.Create("DImage", InfoPanel)
		PlayersIcon:SetPos(10, 0)
		PlayersIcon:SetSize(30, 30)
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
		PlayerScrollPanel:SetSize(ScoreboardDerma:GetWide(), 400)
		PlayerScrollPanel:SetPos(0, 0)

		local sbar = PlayerScrollPanel:GetVBar()
		function sbar:Paint(w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(0, 0, 0, 150))
		end
		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 155))
		end
		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 155))
		end
		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
		end

		PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
		PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
		PlayerList:SetPos(0, 0)

		local MapInfoPanel = vgui.Create("DPanel", ScoreboardDerma)
		MapInfoPanel:Dock(TOP)
		MapInfoPanel:SetSize(0, 100)

		--Displays information about the current map, the map vote, and the server.
		MapInfoPanel.Paint = function(self, w, h)
			if mapName ~= nil then
				draw.SimpleText("Playing on " .. mapName, "StreakText", 102.5, 60.5, white, TEXT_ALIGN_LEFT)
				draw.SimpleText("Next map vote in " .. timeUntilMapVote .. "s~", "StreakText", 102.5, 80, white, TEXT_ALIGN_LEFT)
			else
				draw.SimpleText("Playing on " .. game.GetMap(), "StreakText", 2.5, 75, white, TEXT_ALIGN_LEFT)
			end

			draw.SimpleText("Map uptime: " .. math.Round(CurTime()) .. "s", "StreakText", 630, 80, white, TEXT_ALIGN_RIGHT)
		end

		if mapName ~= nil then
			MapThumb = vgui.Create("DImage", MapInfoPanel)
			MapThumb:SetPos(0, 5)
			MapThumb:SetSize(100, 100)
			MapThumb:SetImage(mapThumb)
		end

		local LevelingPanel = vgui.Create("DPanel", ScoreboardDerma)
		LevelingPanel:Dock(TOP)
		LevelingPanel:SetSize(0, 30)

		--Displays information about the current map, the map vote, and the server.
		LevelingPanel.Paint = function(self, w, h)
			draw.SimpleText("P" .. LocalPlayer():GetNWInt("playerPrestige") .. " L" .. LocalPlayer():GetNWInt("playerLevel"), "StreakText", 2.5, -2.5, white, TEXT_ALIGN_LEFT)

			surface.SetDrawColor(35, 35, 35, 100)
			surface.DrawRect(0, 20, 630, 10)

			surface.SetDrawColor(255, 255, 0, 50)
			if LocalPlayer():GetNWInt("playerLevel") ~= 60 then surface.DrawRect(0, 20, (LocalPlayer():GetNWInt("playerXP") / LocalPlayer():GetNWInt("playerXPToNextLevel")) * 630, 10) end
		end
	end

	if IsValid(ScoreboardDerma) then
		ScoreboardDerma:MoveTo(ScrW() / 2 - 320, ScrH() / 2 - 300, 0.5, 0, 0.25)
		PlayerList:Clear()

		local connectedPlayers = player.GetAll()
		table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end)

		for k, v in pairs(connectedPlayers) do
			local ratio
			local card = v:GetNWString("chosenPlayercard")

			--Used to format the K/D Ratio of a player, stops it from displaying INF when the player has gotten a kill, but has also not died yet.
			if v:Frags() <= 0 then
				ratio = 0
			elseif v:Frags() >= 1 and v:Deaths() == 0 then
				ratio = v:Frags()
			else
				ratio = v:Frags() / v:Deaths()
			end

			--Displays the players statistics.
			local PlayerPanel = vgui.Create("DPanel", PlayerList)
			PlayerPanel:SetSize(PlayerList:GetWide(), 100)
			PlayerPanel:SetPos(0, 0)
			PlayerPanel.Paint = function(self, w, h)
				if v:GetNWBool("mainmenu") == true then
					draw.RoundedBox(5, 0, 0, w, h, Color(35, 35, 100, 100))
				elseif !v:Alive() then
					draw.RoundedBox(5, 0, 0, w, h, Color(100, 35, 35, 100))
				else
					draw.RoundedBox(5, 0, 0, w, h, Color(35, 35, 35, 100))
				end
				draw.SimpleText(v:GetName(), "Health", 255, 5, white, TEXT_ALIGN_LEFT)
				draw.SimpleText("P" .. v:GetNWInt("playerPrestige") .. " L" .. v:GetNWInt("playerLevel"), "Health", 255, 35, white, TEXT_ALIGN_LEFT)
				draw.SimpleText(v:Ping() .. "ms", "StreakText", 255, 72, white, TEXT_ALIGN_LEFT)

				draw.SimpleText(v:Frags(), "Health", 375, 35, Color(0, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(v:Deaths(), "Health", 420, 35, Color(255, 0, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(math.Round(ratio, 2), "Health", 470, 35, Color(255, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(v:GetNWInt("playerScoreMatch"), "Health", 540, 35, white, TEXT_ALIGN_CENTER)
			end

			local playerCallingCard = vgui.Create("DImage", PlayerPanel)
			playerCallingCard:SetPos(10, 10)
			playerCallingCard:SetSize(240, 80)
			playerCallingCard:SetImage(card, "cards/color/black.png")

			--Displays a players calling card and profile picture.
			local playerProfilePicture = vgui.Create("AvatarImage", PlayerPanel)
			playerProfilePicture:SetPos(15 + v:GetNWInt("cardPictureOffset"), 15)
			playerProfilePicture:SetSize(70, 70)
			playerProfilePicture:SetPlayer(v, 184)

			--Allows the players profile to be clicked to display various options revolving around the specific player.
			playerProfilePicture.OnMousePressed = function(self)
				local Menu = DermaMenu()

				local profileButton = Menu:AddOption("View Steam Profile", function() gui.OpenURL("http://steamcommunity.com/profiles/" .. v:SteamID64()) end)
				profileButton:SetIcon("icon16/page_find.png")

				Menu:AddSpacer()

				local statistics = Menu:AddSubMenu("View Stats")
				local accolades = Menu:AddSubMenu("View Accolades")
				local weaponstatistics = Menu:AddSubMenu("View Weapon Stats")
				local weaponKills = weaponstatistics:AddSubMenu("Kills")

				if v:GetInfoNum("tm_hidestatsfromothers", 0) == 0 or v == LocalPlayer() then
					statistics:AddOption("Level: P" .. v:GetNWInt("playerPrestige") .. " L" .. v:GetNWInt("playerLevel"))
					statistics:AddOption("Score/XP: " .. v:GetNWInt("playerScore"))
					statistics:AddOption("Kills: " .. v:GetNWInt("playerKills"))
					statistics:AddOption("Deaths: " .. v:GetNWInt("playerDeaths"))
					statistics:AddOption("K/D Ratio: " .. math.Round(v:GetNWInt("playerKDR"), 3))
					statistics:AddOption("Highest Killstreak: " .. v:GetNWInt("highestKillStreak"))
					accolades:AddOption("Headshots: " .. v:GetNWInt("playerAccoladeHeadshot"))
					accolades:AddOption("Melee Kills (Smackdown): " .. v:GetNWInt("playerAccoladeSmackdown"))
					accolades:AddOption("Clutches (Kills with less than 15 HP): " .. v:GetNWInt("playerAccoladeClutch"))
					accolades:AddOption("Longshots: " .. v:GetNWInt("playerAccoladeLongshot"))
					accolades:AddOption("Point Blanks: " .. v:GetNWInt("playerAccoladePointblank"))
					accolades:AddOption("Kill Streaks Started (On Streak): " .. v:GetNWInt("playerAccoladeOnStreak"))
					accolades:AddOption("Kill Streaks Ended (Buzz Kill): " .. v:GetNWInt("playerAccoladeBuzzkill"))
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
				copyMenu:AddOption("Copy SteamID", function() SetClipboardText(v:SteamID64()) end):SetIcon("icon16/cut.png")

				Menu:Open()
			end
		end

		ScoreboardDerma:Show()
		ScoreboardDerma:MakePopup()
		ScoreboardDerma:SetKeyboardInputEnabled(false)

		--If playing on the Firing Range, a special menu will appear to the right of the scoreboard which allows weapon spawning.
		if game.GetMap() == "tm_firingrange" then
			local FiringRangeDerma = vgui.Create("DFrame")
			FiringRangeDerma:SetSize(200, 530)
			FiringRangeDerma:SetPos(ScrW() / 2 + 325, 0)
			FiringRangeDerma:SetTitle("")
			FiringRangeDerma:SetDraggable(false)
			FiringRangeDerma:ShowCloseButton(false)
			FiringRangeDerma.Paint = function()
				draw.RoundedBox(5, 0, 0, FiringRangeDerma:GetWide(), FiringRangeDerma:GetTall(), Color(35, 35, 35, 150))
				draw.SimpleText("Weapon Spawner", "StreakText", 15, 0, white, TEXT_ALIGN_LEFT)
			end

			FiringRangeDerma:MoveTo(ScrW() / 2 + 325, ScrH() / 2 - 265, 0.5, 0, 0.25)

			local FiringRangeScroller = vgui.Create("DScrollPanel", FiringRangeDerma)
			FiringRangeScroller:Dock(FILL)

			local sbar = FiringRangeScroller:GetVBar()
			function sbar:Paint(w, h)
				draw.RoundedBox(5, 0, 0, w, h, Color(40, 40, 40, 200))
			end
			function sbar.btnUp:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
			end
			function sbar.btnDown:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
			end
			function sbar.btnGrip:Paint(w, h)
				draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
			end

			local WeaponList = vgui.Create("DIconLayout", FiringRangeScroller)
			WeaponList:Dock(TOP)
			WeaponList:SetSpaceY(5)
			WeaponList:SetSpaceX(20)

			WeaponList.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
			end

			for k, v in pairs(weaponArray) do
				local weapon = vgui.Create("DButton", DockDefaultCards)
				weapon:SetSize(170, 40)
				weapon:SetText("")
				weapon.Paint = function()
					draw.DrawText(v[2], "StreakText", 5, 5, white, TEXT_ALIGN_LEFT)
					draw.DrawText(v[3], "StreakTextMini", 5, 25, white, TEXT_ALIGN_LEFT)
				end
				WeaponList:Add(weapon)

				weapon.DoClick = function(weapon)
					net.Start("FiringRangeGiveWeapon")
					net.WriteString(v[1])
					net.SendToServer()
				end
			end
		end
	end
end

function GM:ScoreboardHide()
	if IsValid(ScoreboardDerma) then
		ScoreboardDerma:SetPos(ScrW() / 2 - 320, 0)
		ScoreboardDerma:Remove()

		if game.GetMap() == "tm_firingrange" then
			FiringRangeDerma:Remove()
		end
	end
end