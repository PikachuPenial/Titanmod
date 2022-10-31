local ScoreboardDerma = nil
local PlayerList = nil

function GM:ScoreboardShow()
	if not IsValid(ScoreboardDerma) then
		ScoreboardDerma = vgui.Create("DFrame")
		ScoreboardDerma:SetSize(510, 400)
		ScoreboardDerma:Center()
		ScoreboardDerma:SetTitle("")
		ScoreboardDerma:SetDraggable(false)
		ScoreboardDerma:ShowCloseButton(false)
		ScoreboardDerma.Paint = function()
			draw.RoundedBox(5, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(60, 60, 60, 0))
			draw.SimpleText("Titanmod", "Health", 255, -6, Color(255, 255, 255), TEXT_ALIGN_CENTER)
		end

		local PlayerScrollPanel = vgui.Create("DScrollPanel", ScoreboardDerma)
		PlayerScrollPanel:SetSize(ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall() - 20)
		PlayerScrollPanel:SetPos(0, 20)

		PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
		PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
		PlayerList:SetPos(0, 0)
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
			PlayerPanel.Paint = function()
				draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(35, 35, 35, 150))
				draw.SimpleText(v:GetName(), "Health", 255, 5, Color(255, 255, 255), TEXT_ALIGN_LEFT)
				draw.SimpleText(v:Frags(), "Health", 275, 30, Color(0, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(v:Deaths(), "Health", 320, 30, Color(255, 0, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(math.Round(ratio, 2), "Health", 370, 30, Color(255, 255, 0), TEXT_ALIGN_CENTER)
				draw.SimpleText(v:GetNWInt("playerScoreMatch"), "Health", 440, 30, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				draw.SimpleText(v:Ping() .. "ms", "Health", 460, 5, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
			end

			--Displays icons near certain values, makes the board look prettier, and allows for quicker reading.
			KillsIcon = vgui.Create("DImage", PlayerPanel)
			KillsIcon:SetPos(260, 60)
			KillsIcon:SetSize(30, 30)
			KillsIcon:SetImage("icons/killicon.png")

			DeathsIcon = vgui.Create("DImage", PlayerPanel)
			DeathsIcon:SetPos(305, 60)
			DeathsIcon:SetSize(30, 30)
			DeathsIcon:SetImage("icons/deathicon.png")

			KDIcon = vgui.Create("DImage", PlayerPanel)
			KDIcon:SetPos(355, 60)
			KDIcon:SetSize(30, 30)
			KDIcon:SetImage("icons/ratioicon.png")

			ScoreIcon = vgui.Create("DImage", PlayerPanel)
			ScoreIcon:SetPos(425, 60)
			ScoreIcon:SetSize(30, 30)
			ScoreIcon:SetImage("icons/scoreicon.png")

			--Displays a players calling card and profile picture.
			playerCallingCard = vgui.Create("DImage", PlayerPanel)
			playerCallingCard:SetPos(10, 10)
			playerCallingCard:SetSize(240, 80)
			playerCallingCard:SetImage(v:GetNWString("chosenPlayercard"))

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