local ScoreboardDerma = nil
local PlayerList = nil

function GM:ScoreboardShow()
	if not LocalPlayer():Alive() then return end

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

			if v:Frags() <= 0 then
				ratio = 0
			elseif v:Frags() >= 1 and v:Deaths() == 0 then
				ratio = v:Frags()
			else
				ratio = v:Frags() / v:Deaths()
			end

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

			--Used to display icons near certain values on the player portion of the scoreboard.
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

			--Support for the Calling Card system, hopefully this isn't too complicated.
			CallingCard = vgui.Create("DImage", PlayerPanel)
			CallingCard:SetPos(10, 10)
			CallingCard:SetSize(240, 80)
			CallingCard:SetImage("cards/industry.png")

			playerProfilePicture = vgui.Create("AvatarImage", PlayerPanel)
			playerProfilePicture:SetPos(15, 15)
			playerProfilePicture:SetSize(70, 70)
			playerProfilePicture:SetPlayer(v, 184)

			playerProfilePicture.OnMousePressed = function(self)
				local Menu = DermaMenu()

				local profileButton = Menu:AddOption("View Steam Profile", function() gui.OpenURL("http://steamcommunity.com/profiles/" .. v:SteamID64()) end)
				profileButton:SetIcon("icon16/page_find.png")

				local statistics = Menu:AddSubMenu("View Lifetime Stats")
				statistics:AddOption("Score: " .. v:GetNWInt("playerScore"))
				statistics:AddOption("Kills: " .. v:GetNWInt("playerKills"))
				statistics:AddOption("Deaths: " .. v:GetNWInt("playerDeaths"))
				statistics:AddOption("K/D Ratio: " .. v:GetNWInt("playerKDR"))
				statistics:AddOption("Highest Killstreak: " .. v:GetNWInt("highestKillStreak"))

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