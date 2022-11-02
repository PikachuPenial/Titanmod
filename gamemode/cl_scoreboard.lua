local ScoreboardDerma = nil
local PlayerList = nil

local mapID
local mapName
local mapDesc
local mapThumb

local timeUntilMapVote = 600

net.Receive("UpdateClientMapVoteTime", function(len, ply)
    timeUntilMapVote = net.ReadFloat()
end)

function GM:ScoreboardShow()
	if not IsValid(ScoreboardDerma) then
		for m, t in pairs(mapArr) do
			if game.GetMap() == t[1] then
				mapID = t[1]
				mapName = t[2]
				mapDesc = t[3]
				mapThumb = t[4]
			end
		end

		ScoreboardDerma = vgui.Create("DFrame")
		ScoreboardDerma:SetSize(640, 470)
		ScoreboardDerma:Center()
		ScoreboardDerma:SetTitle("")
		ScoreboardDerma:SetDraggable(false)
		ScoreboardDerma:ShowCloseButton(false)
		ScoreboardDerma.Paint = function()
			draw.RoundedBox(5, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(35, 35, 35, 150))
			draw.SimpleText("Titanmod 0.3b1", "StreakText", 20, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		end

		local InfoPanel = vgui.Create("DPanel", ScoreboardDerma)
		InfoPanel:Dock(TOP)
		InfoPanel:SetSize(0, 36)

		InfoPanel.Paint = function(self, w, h)
			draw.SimpleText("1 / " .. game.MaxPlayers(), "StreakText", 50, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		end

		PlayersIcon = vgui.Create("DImage", InfoPanel)
		PlayersIcon:SetPos(10, 0)
		PlayersIcon:SetSize(30, 30)
		PlayersIcon:SetImage("icons/playericon.png")

		KillsIcon = vgui.Create("DImage", InfoPanel)
		KillsIcon:SetPos(360, 0)
		KillsIcon:SetSize(30, 30)
		KillsIcon:SetImage("icons/killicon.png")

		DeathsIcon = vgui.Create("DImage", InfoPanel)
		DeathsIcon:SetPos(405, 0)
		DeathsIcon:SetSize(30, 30)
		DeathsIcon:SetImage("icons/deathicon.png")

		KDIcon = vgui.Create("DImage", InfoPanel)
		KDIcon:SetPos(455, 0)
		KDIcon:SetSize(30, 30)
		KDIcon:SetImage("icons/ratioicon.png")

		ScoreIcon = vgui.Create("DImage", InfoPanel)
		ScoreIcon:SetPos(525, 0)
		ScoreIcon:SetSize(30, 30)
		ScoreIcon:SetImage("icons/scoreicon.png")

		local PlayerScrollPanel = vgui.Create("DScrollPanel", ScoreboardDerma)
		PlayerScrollPanel:Dock(TOP)
		PlayerScrollPanel:SetSize(ScoreboardDerma:GetWide(), 300)
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

		MapInfoPanel.Paint = function(self, w, h)
			draw.SimpleText("Playing on " .. mapName, "StreakText", 102.5, 60.5, Color(255, 255, 255), TEXT_ALIGN_LEFT)
			draw.SimpleText("Next map vote in " .. timeUntilMapVote .. "s~", "StreakText", 102.5, 80, Color(255, 255, 255), TEXT_ALIGN_LEFT)

			draw.SimpleText("Map uptime: " .. math.Round(CurTime()) .. "s", "StreakText", 630, 60.5, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
			draw.SimpleText("Server uptime: " .. math.Round(SysTime()) .. "s", "StreakText", 630, 80, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
		end

		MapThumb = vgui.Create("DImage", MapInfoPanel)
		MapThumb:SetPos(0, 5)
		MapThumb:SetSize(100, 100)
		MapThumb:SetImage(mapThumb)
	end

	if IsValid(ScoreboardDerma) then
		PlayerList:Clear()

		for k, v in pairs(player.GetAll()) do
			local ratio

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
				draw.RoundedBox(5, 0, 0, w, h, Color(35, 35, 35, 100))
				draw.SimpleText(v:GetName(), "Health", 255, 5, Color(255, 255, 255), TEXT_ALIGN_LEFT)
				draw.SimpleText("Recruit", "StreakText", 255, 30, Color(255, 255, 255), TEXT_ALIGN_LEFT)
				draw.SimpleText(v:Ping() .. "ms", "Health", 255, 65, Color(255, 255, 255), TEXT_ALIGN_LEFT)

				draw.SimpleText(v:Frags(), "Health", 375, 30, Color(0, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(v:Deaths(), "Health", 420, 30, Color(255, 0, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(math.Round(ratio, 2), "Health", 470, 30, Color(255, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(v:GetNWInt("playerScoreMatch"), "Health", 540, 30, Color(255, 255, 255), TEXT_ALIGN_CENTER)
			end

			--Displays a players calling card and profile picture.
			playerCallingCard = vgui.Create("DImage", PlayerPanel)
			playerCallingCard:SetPos(10, 10)
			playerCallingCard:SetSize(240, 80)
			playerCallingCard:SetImage(v:GetNWString("chosenPlayercard"), "cards/color/black.png")

			playerProfilePicture = vgui.Create("AvatarImage", PlayerPanel)
			playerProfilePicture:SetPos(15 + v:GetNWInt("cardPictureOffset"), 15)
			playerProfilePicture:SetSize(70, 70)
			playerProfilePicture:SetPlayer(v, 184)

			--Allows the players profile to be clicked to display various options revolving around the specific player.
			playerProfilePicture.OnMousePressed = function(self)
				local Menu = DermaMenu()

				local profileButton = Menu:AddOption("View Steam Profile", function() gui.OpenURL("http://steamcommunity.com/profiles/" .. v:SteamID64()) end)
				profileButton:SetIcon("icon16/page_find.png")

				local statistics = Menu:AddSubMenu("View Lifetime Stats")
				statistics:AddOption("Score: " .. v:GetNWInt("playerScore"))
				statistics:AddOption("Kills: " .. v:GetNWInt("playerKills"))
				statistics:AddOption("Deaths: " .. v:GetNWInt("playerDeaths"))
				statistics:AddOption("K/D Ratio: " .. math.Round(v:GetNWInt("playerKDR"), 3))
				statistics:AddOption("Highest Killstreak: " .. v:GetNWInt("highestKillStreak"))

				local accolades = Menu:AddSubMenu("View Lifetime Accolades")
				accolades:AddOption("Headshots: " .. v:GetNWInt("playerAccoladeHeadshot"))
				accolades:AddOption("Melee Kills (Smackdown): " .. v:GetNWInt("playerAccoladeSmackdown"))
				accolades:AddOption("Clutches (Kills with less than 15 HP): " .. v:GetNWInt("playerAccoladeClutch"))
				accolades:AddOption("Longshots: " .. v:GetNWInt("playerAccoladeLongshot"))
				accolades:AddOption("Point Blanks: " .. v:GetNWInt("playerAccoladePointblank"))
				accolades:AddOption("Kill Streaks Started (On Streak): " .. v:GetNWInt("playerAccoladeOnStreak"))
				accolades:AddOption("Kill Streaks Ended (Buzz Kill): " .. v:GetNWInt("playerAccoladeBuzzkill"))
				accolades:AddOption("Revenge Kills: " .. v:GetNWInt("playerAccoladeRevenge"))
				accolades:AddOption("Copycat Kills: " .. v:GetNWInt("playerAccoladeCopycat"))

				local weaponstatistics = Menu:AddSubMenu("View Lifetime Weapon Stats")
				for p, t in pairs(weaponsArr) do
					weaponstatistics:AddOption(t[2] .. " Kills: " .. v:GetNWInt("killsWith_" .. t[1]))
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
	end
end

function GM:ScoreboardHide()
	if IsValid(ScoreboardDerma) then
		ScoreboardDerma:Hide()
	end
end