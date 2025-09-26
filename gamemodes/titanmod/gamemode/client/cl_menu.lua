local white = Color(255, 255, 255, 255)
local gray = Color(50, 50, 50, 185)
local lightGray = Color(40, 40, 40, 200)
local solidGreen = Color(0, 255, 0, 255)
local solidRed = Color(255, 0, 0, 255)
local transparent = Color(0, 0, 0, 0)
local transparentRed = Color(255, 0, 0, 20)

local gradientL = Material("overlay/gradient_c.png", "noclamp smooth")
local gradientR = Material("overlay/gradient_c2.png", "noclamp smooth")

local gradLColor
local gradRColor
if math.random(0, 1) == 0 then
    gradLColor = Color(100, 0, 255, 6)
    gradRColor = Color(100, 255, 255, 12)
else
    gradLColor = Color(100, 255, 255, 6)
    gradRColor = Color(100, 0, 255, 12)
end

local function TriggerSound(type)
    if GetConVar("tm_menusounds"):GetInt() == 0 then return end
    if type == "click" then surface.PlaySound("tmui/click" .. math.random(1, 3) .. ".wav") end
    if type == "forward" then surface.PlaySound("tmui/clickforward.wav") end
    if type == "back" then surface.PlaySound("tmui/clickback.wav") end
    if type == "hover" then surface.PlaySound("tmui/hover.wav") end
end

local playedIntro = false

local MainMenu

net.Receive("OpenMainMenu", function(len, ply)
    local LocalPly = LocalPlayer()
    local respawnTimeLeft = net.ReadFloat()
    if respawnTimeLeft != 0 then timer.Create("respawnTimeLeft", respawnTimeLeft, 1, function()
    end) end

    hook.Add("Think", "RenderBehindPauseMenu", function()
        if !IsValid(MainMenu) then return end
        if !gui.IsGameUIVisible() then MainMenu:Show() else MainMenu:Hide() end
    end)

    DeleteHUDHook()

    local mapID
    local mapName

    local canPrestige
    if LocalPly:GetNWInt("playerLevel") != 60 then canPrestige = false else canPrestige = true end

    local hintList = hintArray
    table.Shuffle(hintList)
    local hintText = table.concat(hintList, "                ")

    local mouseX = 0
    local mouseY = 0

    local ContextBind = "Context Menu Bind"
    if input.LookupBinding("+menu_context") != nil then ContextBind = input.LookupBinding("+menu_context") end

    if !IsValid(MainMenu) then
        MainMenu = vgui.Create("DFrame")
        MainMenu:SetSize(scrW, scrH)
        MainMenu:Center()
        MainMenu:SetTitle("")
        MainMenu:SetDraggable(false)
        MainMenu:ShowCloseButton(false)
        MainMenu:SetDeleteOnClose(false)
        MainMenu:MakePopup()
        MainMenu:SetAlpha(0)

        MainMenu:AlphaTo(255, 0.1, 0)

        for i = 1, #mapArray do
            if game.GetMap() == mapArray[i][1] then
                mapID = mapArray[i][1]
                mapName = mapArray[i][2]
            end
        end

        MainMenu.Paint = function()
            BlurPanel(MainMenu, 10)
            surface.SetDrawColor(35, 35, 35, 165)
            surface.DrawRect(0, 0, MainMenu:GetWide(), MainMenu:GetTall())

            surface.SetMaterial(gradientL)
            surface.SetDrawColor(gradLColor)
            surface.DrawTexturedRect(0, 0, scrW, scrH)

            surface.SetMaterial(gradientR)
            surface.SetDrawColor(gradRColor)
            surface.DrawTexturedRect(0, 0, scrW, scrH)

            mouseX, mouseY = MainMenu:LocalCursorPos()

            if GetGlobal2Bool("tm_matchended") == true then 
                MainMenu:Remove()
                return
            end
        end

        if !playedIntro then
            -- surface.PlaySound("tmui/intro.wav")
            playedIntro = true
        end

        gui.EnableScreenClicker(true)

        local MainPanel = MainMenu:Add("MainPanel")
            local pushSpawnItems = 100
            local pushExitItems = -100
            local spawnTextAnim = 0
            local hintTextAnim = 0

            MainPanel.Paint = function()
                draw.SimpleText(LocalPly:GetNWInt("playerLevel"), "AmmoCountSmall", TM.MenuScale(440), TM.MenuScale(-5), white, TEXT_ALIGN_LEFT)

                if LocalPly:GetNWInt("playerPrestige") != 0 and LocalPly:GetNWInt("playerLevel") != 60 then
                    draw.SimpleText("PRESTIGE " .. LocalPly:GetNWInt("playerPrestige"), "StreakText", TM.MenuScale(660), TM.MenuScale(37.5), white, TEXT_ALIGN_RIGHT)
                elseif LocalPly:GetNWInt("playerPrestige") != 0 and LocalPly:GetNWInt("playerLevel") == 60 then
                    draw.SimpleText("PRESTIGE " .. LocalPly:GetNWInt("playerPrestige"), "StreakText", TM.MenuScale(535), TM.MenuScale(37.5), white, TEXT_ALIGN_LEFT)
                end

                if LocalPly:GetNWInt("playerLevel") != 60 then
                    draw.SimpleText(math.Round(LocalPly:GetNWInt("playerXP"), 0) .. " / " .. math.Round(LocalPly:GetNWInt("playerXPToNextLevel"), 0) .. "XP", "StreakText", TM.MenuScale(660), TM.MenuScale(57.5), white, TEXT_ALIGN_RIGHT)
                    draw.SimpleText(LocalPly:GetNWInt("playerLevel") + 1, "StreakText", TM.MenuScale(665), TM.MenuScale(72.5), white, TEXT_ALIGN_LEFT)

                    surface.SetDrawColor(30, 30, 30, 125)
                    surface.DrawRect(TM.MenuScale(440), TM.MenuScale(80), TM.MenuScale(220), TM.MenuScale(10))

                    surface.SetDrawColor(200, 200, 0, 130)
                    surface.DrawRect(TM.MenuScale(440), TM.MenuScale(80), (LocalPly:GetNWInt("playerXP") / LocalPly:GetNWInt("playerXPToNextLevel")) * TM.MenuScale(220), TM.MenuScale(10))
                else
                    draw.SimpleText("+ " .. math.Round(LocalPly:GetNWInt("playerXP"), 0) .. "XP", "StreakText", TM.MenuScale(535), TM.MenuScale(55), white, TEXT_ALIGN_LEFT)
                end

                if mapID == nil then draw.SimpleText(string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime() + 1), "%2i:%02i" .. " / " .. activeGamemode .. ", " .. game.GetMap()), "StreakText", TM.MenuScale(5 + spawnTextAnim), scrH / 2 - TM.MenuScale(60) - TM.MenuScale(pushSpawnItems), white, TEXT_ALIGN_LEFT) else draw.SimpleText(string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime() + 1), "%2i:%02i" .. " / " .. activeGamemode .. ", " .. mapName), "StreakText", TM.MenuScale(10 + spawnTextAnim), scrH / 2 - TM.MenuScale(60) - TM.MenuScale(pushSpawnItems), white, TEXT_ALIGN_LEFT) end

                hintTextAnim = math.Clamp(hintTextAnim + 50 * RealFrameTime(), 0, 10000)
                surface.SetDrawColor(30, 30, 30, 125)
                surface.DrawRect(0, scrH - TM.MenuScale(24), scrW, TM.MenuScale(24))
                draw.SimpleText(hintText, "StreakText", TM.MenuScale(5) - TM.MenuScale(hintTextAnim), scrH - TM.MenuScale(13), white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            if canPrestige == true then
                local PrestigeButton = vgui.Create("DButton", MainPanel)
                PrestigeButton:SetPos(TM.MenuScale(437.5), TM.MenuScale(67.5))
                PrestigeButton:SetText("")
                PrestigeButton:SetSize(TM.MenuScale(180), TM.MenuScale(30))
                local textAnim = 0
                local prestigeConfirm = 0
                local rainbowSpeed = 160
                local rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)
                PrestigeButton.Paint = function()
                    rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)
                    if PrestigeButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 20)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 20)
                    end

                    if prestigeConfirm == 0 then
                        draw.DrawText("PRESTIGE TO P" .. LocalPly:GetNWInt("playerPrestige") + 1, "StreakText", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), rainbowColor, TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("ARE YOU SURE?", "StreakText", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                    end
                end
                PrestigeButton.DoClick = function()
                    if (prestigeConfirm == 0) then
                        TriggerSound("click")
                        prestigeConfirm = 1
                    else
                        surface.PlaySound("tmui/prestige.wav")
                        net.Start("PlayerPrestige")
                        net.SendToServer()
                        PrestigeButton:Hide()
                    end

                    timer.Simple(3, function() prestigeConfirm = 0 end)
                end
            end

            plyCallingCard = vgui.Create("DImage", MainPanel)
            plyCallingCard:SetPos(TM.MenuScale(190), TM.MenuScale(10))
            plyCallingCard:SetSize(TM.MenuScale(240), TM.MenuScale(80))
            plyCallingCard:SetImage(LocalPly:GetNWString("chosenPlayercard"), "cards/color/black.png")

            playerProfilePicture = vgui.Create("AvatarImage", MainPanel)
            playerProfilePicture:SetPos(TM.MenuScale(195), TM.MenuScale(15))
            playerProfilePicture:SetSize(TM.MenuScale(70), TM.MenuScale(70))
            playerProfilePicture:SetPlayer(LocalPly, 184)

            local SelectedBoard
            local SelectedBoardName
            local LeaderboardProfiles
            local ProfilesHolder
            local LeaderboardButton = vgui.Create("DImageButton", MainPanel)
            LeaderboardButton:SetPos(TM.MenuScale(10), TM.MenuScale(10))
            LeaderboardButton:SetImage("icons/leaderboardicon.png")
            LeaderboardButton:SetSize(TM.MenuScale(80), TM.MenuScale(80))
            LeaderboardButton:SetTooltip("Leaderboards")
            LeaderboardButton.DoClick = function()
                if IsValid(LeaderboardPanel) then return end
                TriggerSound("click")
                MainPanel:AlphaTo(0, 0.05, 0, function() MainPanel:Hide() end)

                if !IsValid(LeaderboardPanel) then
                    local LeaderboardPanel = MainMenu:Add("LeaderboardPanel")
                    local LeaderboardSlideoutPanel = MainMenu:Add("LeaderboardSlideoutPanel")
                    LeaderboardPanel:SetAlpha(0)
                    LeaderboardSlideoutPanel:SetAlpha(0)
                    LeaderboardPanel:AlphaTo(255, 0.05, 0.025)
                    LeaderboardSlideoutPanel:AlphaTo(255, 0.05, 0.025)

                    local LeaderboardQuickjumpHolder = vgui.Create("DPanel", LeaderboardSlideoutPanel)
                    LeaderboardQuickjumpHolder:Dock(TOP)
                    LeaderboardQuickjumpHolder:SetSize(0, scrH)

                    LeaderboardQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                        draw.RoundedBox(0, TM.MenuScale(4), scrH - TM.MenuScale(52), TM.MenuScale(48), TM.MenuScale(48), transparentRed)
                    end

                    local LeaderboardScroller = vgui.Create("DScrollPanel", LeaderboardPanel)
                    LeaderboardScroller:Dock(FILL)

                    local sbar = LeaderboardScroller:GetVBar()
                    sbar:SetHideButtons(true)
                    sbar:SetSize(TM.MenuScale(15), TM.MenuScale(15))
                    function sbar:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(0, TM.MenuScale(5), TM.MenuScale(8), TM.MenuScale(5), h - TM.MenuScale(16), Color(255, 255, 255, 175))
                    end

                    local LeaderboardTextHolder = vgui.Create("DPanel", LeaderboardPanel)
                    LeaderboardTextHolder:Dock(TOP)
                    LeaderboardTextHolder:SetSize(0, TM.MenuScale(210))

                    LeaderboardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("LEADERBOARDS", "AmmoCountSmall", TM.MenuScale(20), TM.MenuScale(20), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Entries update on match start/player disconnect | Only top 100 are shown", "StreakText", TM.MenuScale(25), TM.MenuScale(100), white, TEXT_ALIGN_LEFT)

                        if SelectedBoardName != nil then draw.SimpleText(SelectedBoardName, "OptionsHeader", TM.MenuScale(85), TM.MenuScale(124), white, TEXT_ALIGN_LEFT) end
                        if timer.Exists("SendBoardDataRequestCooldown") then draw.SimpleText(math.Round(timer.TimeLeft("SendBoardDataRequestCooldown"), 1), "StreakText", TM.MenuScale(41), TM.MenuScale(145), white, TEXT_ALIGN_CENTER) end
                        draw.SimpleText("#", "StreakText", TM.MenuScale(20), TM.MenuScale(185), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Name", "StreakText", TM.MenuScale(85), TM.MenuScale(185), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Stat", "StreakText", TM.MenuScale(710), TM.MenuScale(185), white, TEXT_ALIGN_RIGHT)
                    end

                    local LeaderboardPickerButton
                    local firstSelection = true
                    function LeaderboardSelected(text, data)
                        if SelectedBoardName == text then return end
                        if !firstSelection then
                            LeaderboardPickerButton:Hide()
                            timer.Create("SendBoardDataRequestCooldown", 3, 1, function() if !LocalPly:Alive() and IsValid(LeaderboardPickerButton) then LeaderboardPickerButton:Show() end end)
                        end
                        TriggerSound("click")
                        net.Start("GrabLeaderboardData")
                        net.WriteString(data)
                        net.WriteBool(true)
                        net.SendToServer()
                        SelectedBoardName = text
                    end

                    LeaderboardPickerButton = vgui.Create("DImageButton", LeaderboardTextHolder)
                    LeaderboardPickerButton:SetPos(TM.MenuScale(25), TM.MenuScale(140))
                    LeaderboardPickerButton:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                    LeaderboardPickerButton:SetTooltip("Switch shown Leaderboard")
                    LeaderboardPickerButton:SetImage("icons/changeicon.png")
                    LeaderboardPickerButton.DoClick = function()
                        TriggerSound("click")
                        local BoardSelection = DermaMenu()
                        local statistics = BoardSelection:AddSubMenu("Statistics")
                        statistics:AddOption("Score", function() LeaderboardSelected("Score", "playerScore") end)
                        statistics:AddOption("Kills", function() LeaderboardSelected("Kills", "playerKills") end)
                        statistics:AddOption("Deaths", function() LeaderboardSelected("Deaths", "playerDeaths") end)
                        -- statistics:AddOption("K/D Ratio", function() LeaderboardSelected("K/D Ratio", "kd") end)
                        statistics:AddOption("Matches Played", function() LeaderboardSelected("Matches Played", "matchesPlayed") end)
                        statistics:AddOption("Matches Won", function() LeaderboardSelected("Matches Won", "matchesWon") end)
                        -- statistics:AddOption("W/L Ratio", function() LeaderboardSelected("W/L Ratio", "wl") end)
                        statistics:AddOption("Highest Killstreak", function() LeaderboardSelected("Highest Killstreak", "highestKillStreak") end)
                        statistics:AddOption("Highest Kill Game", function() LeaderboardSelected("Highest Kill Game", "highestKillGame") end)
                        statistics:AddOption("Farthest Kill", function() LeaderboardSelected("Farthest Kill", "farthestKill") end)

                        local accolades = BoardSelection:AddSubMenu("Accolades")
                        accolades:AddOption("Headshot Kills", function() LeaderboardSelected("Headshot Kills", "playerAccoladeHeadshot") end)
                        accolades:AddOption("Melee Kills", function() LeaderboardSelected("Melee Kills", "playerAccoladeSmackdown") end)
                        accolades:AddOption("Longshot Kills", function() LeaderboardSelected("Longshot Kills", "playerAccoladeLongshot") end)
                        accolades:AddOption("Point Blank Kills", function() LeaderboardSelected("Point Blank Kills", "playerAccoladePointblank") end)
                        accolades:AddOption("Clutches", function() LeaderboardSelected("Clutches", "playerAccoladeClutch") end)
                        accolades:AddOption("Kill Streaks Started", function() LeaderboardSelected("Kill Streaks Started", "playerAccoladeOnStreak") end)
                        accolades:AddOption("Kill Streaks Ended", function() LeaderboardSelected("Kill Streaks Ended", "playerAccoladeBuzzkill") end)

                        local weaponstatistics = BoardSelection:AddSubMenu("Weapons")
                        weaponstatistics:SetMaxHeight(scrH / 2)
                        for i = 1, #weaponArray do
                            weaponstatistics:AddOption("Kills w/ " .. weaponArray[i][2], function() LeaderboardSelected("Kills w/ " .. weaponArray[i][2], "killsWith_" .. weaponArray[i][1]) end)
                        end

                        BoardSelection:Open()
                    end

                    local StatsIcon = vgui.Create("DImage", LeaderboardQuickjumpHolder)
                    StatsIcon:SetPos(TM.MenuScale(12), TM.MenuScale(12))
                    StatsIcon:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                    StatsIcon:SetImage("icons/leaderboardslideouticon.png")

                    local BackButtonSlideout = vgui.Create("DImageButton", LeaderboardQuickjumpHolder)
                    BackButtonSlideout:SetPos(TM.MenuScale(12), scrH - TM.MenuScale(44))
                    BackButtonSlideout:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout.DoClick = function()
                        TriggerSound("back")
                        LeaderboardPanel:AlphaTo(0, 0.05, 0, function() LeaderboardPanel:Hide() end)
                        LeaderboardSlideoutPanel:AlphaTo(0, 0.05, 0, function() LeaderboardSlideoutPanel:Hide() end)
                        MainPanel:Show()
                        MainPanel:AlphaTo(255, 0.05, 0.025)
                    end

                    local LeaderboardContents = vgui.Create("DPanel", LeaderboardScroller)
                    LeaderboardContents:Dock(FILL)

                    LeaderboardContents.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)

                        if SelectedBoard == nil then return end
                        for p, t in pairs(SelectedBoard) do
                            if t.Value == "NULL" then return end
                            if t.SteamName != LocalPly:GetName() then
                                draw.SimpleText(p, "SettingsLabel", TM.MenuScale(20), (p - 1) * TM.MenuScale(41.25), white, TEXT_ALIGN_LEFT)
                                if t.SteamName != "NULL" then draw.SimpleText(string.sub(t.SteamName, 1, 21), "SettingsLabel", TM.MenuScale(85), (p - 1) * TM.MenuScale(41.25), white, TEXT_ALIGN_LEFT) else draw.SimpleText(t.SteamID, "SettingsLabel", TM.MenuScale(85), (p - 1) * TM.MenuScale(41.25), white, TEXT_ALIGN_LEFT) end
                            else
                                draw.SimpleText(p, "SettingsLabel", TM.MenuScale(20), (p - 1) * TM.MenuScale(41.25), Color(255, 255, 0), TEXT_ALIGN_LEFT)
                                draw.SimpleText(string.sub(t.SteamName, 1, 21), "SettingsLabel", TM.MenuScale(85), (p - 1) * TM.MenuScale(41.25), Color(255, 255, 0), TEXT_ALIGN_LEFT)
                            end

                            if SelectedBoardName == "W/L Ratio" then
                                if t.SteamName != LocalPly:GetName() then
                                    draw.SimpleText(math.Round(t.Value) .. "%", "SettingsLabel", TM.MenuScale(710), (p - 1) * TM.MenuScale(41.25), white, TEXT_ALIGN_RIGHT)
                                else
                                    draw.SimpleText(math.Round(t.Value) .. "%", "SettingsLabel", TM.MenuScale(710), (p - 1) * TM.MenuScale(41.25), Color(255, 255, 0), TEXT_ALIGN_RIGHT)
                                end
                            elseif SelectedBoardName == "Farthest Kill" then
                                if t.SteamName != LocalPly:GetName() then
                                    draw.SimpleText(math.Round(t.Value, 2) .. "m", "SettingsLabel", TM.MenuScale(710), (p - 1) * TM.MenuScale(41.25), white, TEXT_ALIGN_RIGHT)
                                else
                                    draw.SimpleText(math.Round(t.Value, 2) .. "m", "SettingsLabel", TM.MenuScale(710), (p - 1) * TM.MenuScale(41.25), Color(255, 255, 0), TEXT_ALIGN_RIGHT)
                                end
                            else
                                if t.SteamName != LocalPly:GetName() then
                                    draw.SimpleText(math.Round(t.Value, 2), "SettingsLabel", TM.MenuScale(710), (p - 1) * TM.MenuScale(41.25), white, TEXT_ALIGN_RIGHT)
                                else
                                    draw.SimpleText(math.Round(t.Value, 2), "SettingsLabel", TM.MenuScale(710), (p - 1) * TM.MenuScale(41.25), Color(255, 255, 0), TEXT_ALIGN_RIGHT)
                                end
                            end
                        end
                    end

                    LeaderboardProfiles = vgui.Create("DPanel", LeaderboardScroller)
                    LeaderboardProfiles:SetPos(TM.MenuScale(720), 0)
                    LeaderboardProfiles.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    ProfilesHolder = vgui.Create("DIconLayout", LeaderboardProfiles)
                    ProfilesHolder:Dock(TOP)
                    ProfilesHolder:SetSpaceY(TM.MenuScale(1.25))

                    net.Start("GrabLeaderboardData")
                    net.WriteString("playerKills")
                    net.WriteBool(false)
                    net.SendToServer()
                    SelectedBoardName = "Kills"
                    firstSelection = false
                end
            end

            net.Receive("SendLeaderboardData", function(len, ply)
                ReceivedBoard = net.ReadTable()
                ProfilesHolder:Clear()

                for p, t in pairs(ReceivedBoard) do
                    local SteamProfile = vgui.Create("DImageButton", ProfilesHolder)
                    SteamProfile:SetImage("icons/linkicon.png")
                    SteamProfile:SetSize(TM.MenuScale(40), TM.MenuScale(40))
                    SteamProfile:SetTooltip("Open " .. t.SteamName .. "'s Steam Profile")
                    ProfilesHolder:Add(SteamProfile)

                    SteamProfile.DoClick = function()
                        TriggerSound("click")
                        gui.OpenURL("http://steamcommunity.com/profiles/" .. t.SteamID)
                    end
                end

                LeaderboardProfiles:SetSize(TM.MenuScale(45), math.max(table.Count(ReceivedBoard) * TM.MenuScale(41.25) + TM.MenuScale(5), TM.MenuScale(870)))
                SelectedBoard = ReceivedBoard
            end )

            local SpectatePanel = vgui.Create("DPanel", MainPanel)
            SpectatePanel:SetSize(TM.MenuScale(170), 0)
            SpectatePanel:SetPos(TM.MenuScale(10), TM.MenuScale(100))
            SpectatePanel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, white)
            end

            local SpectateTextHeader = vgui.Create("DPanel", SpectatePanel)
            SpectateTextHeader:Dock(TOP)
            SpectateTextHeader:SetSize(0, TM.MenuScale(70))
            SpectateTextHeader.Paint = function(self, w, h)
                draw.SimpleText("SPECTATE", "MainMenuDescription", w / 2, TM.MenuScale(8), Color(0, 0, 0), TEXT_ALIGN_CENTER)
            end

            local SpectateButton = vgui.Create("DImageButton", MainPanel)
            SpectateButton:SetPos(TM.MenuScale(100), TM.MenuScale(10))
            SpectateButton:SetImage("icons/spectateicon.png")
            SpectateButton:SetSize(TM.MenuScale(80), TM.MenuScale(80))
            SpectateButton:SetTooltip("Spectate")
            SpectateButton.DoClick = function()
                TriggerSound("click")
                if timer.Exists("respawnTimeLeft") then return end
                if GetGlobal2Bool("tm_intermission") then return end
                net.Start("BeginSpectate")
                net.SendToServer()
                MainMenu:Remove(false)
                gui.EnableScreenClicker(false)
            end

            local function ShowTutorial()
                if IsValid(TutorialPanel) then return end

                local TutorialPanel = vgui.Create("DFrame", MainMenu)
                TutorialPanel:SetSize(TM.MenuScale(864), TM.MenuScale(768))
                TutorialPanel:MakePopup()
                TutorialPanel:SetTitle("")
                TutorialPanel:Center()
                TutorialPanel:SetScreenLock(true)
                TutorialPanel:GetBackgroundBlur(false)
                TutorialPanel:SetDraggable(false)
                TutorialPanel:SetDeleteOnClose(false)
                TutorialPanel:SetAlpha(0)
                MainMenu:SetMouseInputEnabled(false)
                TutorialPanel:AlphaTo(255, 0.1, 0)
                TutorialPanel.Paint = function(self, w, h)
                    BlurPanel(self, 10)
                    draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 100))
                end
                TutorialPanel.OnClose = function()
                    TutorialPanel:AlphaTo(0, 0.05, 0, function() TutorialPanel:Remove() end)
                    TriggerSound("click")
                    MainMenu:SetMouseInputEnabled(true)
                    return false
                end

                local TutorialScroller = vgui.Create("DScrollPanel", TutorialPanel)
                TutorialScroller:Dock(FILL)

                local sbar = TutorialScroller:GetVBar()
                sbar:SetHideButtons(true)
                sbar:SetSize(TM.MenuScale(15), TM.MenuScale(15))
                function sbar:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                end
                function sbar.btnGrip:Paint(w, h)
                    draw.RoundedBox(0, TM.MenuScale(5), TM.MenuScale(8), TM.MenuScale(5), h - TM.MenuScale(16), Color(255, 255, 255, 175))
                end

                local TitleText = vgui.Create("DPanel", TutorialScroller)
                TitleText:Dock(TOP)
                TitleText:SetSize(0, TM.MenuScale(160))
                TitleText.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 100))
                    draw.SimpleText("WELCOME TO", "SettingsLabel", w / 2, TM.MenuScale(5), white, TEXT_ALIGN_CENTER)
                end

                local TitanmodLogo = vgui.Create("DImage", TutorialScroller)
                TitanmodLogo:SetPos(TM.MenuScale(112), TM.MenuScale(25))
                TitanmodLogo:SetSize(TM.MenuScale(641), TM.MenuScale(128))
                TitanmodLogo:SetImage("gamemodes/titanmod/logo.png")

                local WeaponrySection = vgui.Create("DPanel", TutorialScroller)
                WeaponrySection:Dock(TOP)
                WeaponrySection:SetSize(0, TM.MenuScale(280))
                WeaponrySection.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("WEAPONS", "OptionsHeader", TM.MenuScale(280), 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end

                local WeaponryLabel = vgui.Create("DLabel", WeaponrySection)
                WeaponryLabel:SetPos(TM.MenuScale(280), TM.MenuScale(40))
                WeaponryLabel:SetSize(TM.MenuScale(554), TM.MenuScale(230))
                WeaponryLabel:SetFont("Menu_GModNotify")
                WeaponryLabel:SetText([[There are 150+ unique weapons to master in Titanmod!
You can use your Context Menu key []] .. string.upper(ContextBind) .. [[] to adjust attachments on your weapons, and to view weapon statistics. Attachments that you select are saved throughout play sessions, so you only have to customize a gun to your liking once.
Each weapon has its own unique recoil pattern to learn.
Bullets are hitscan and can penetrate through surfaces.
]])
                WeaponryLabel:SetWrap(true)

                local WeaponryImage = vgui.Create("DImage", WeaponrySection)
                WeaponryImage:SetPos(TM.MenuScale(10), TM.MenuScale(10))
                WeaponryImage:SetSize(TM.MenuScale(260), TM.MenuScale(260))
                WeaponryImage:SetImage("images/attach.png")

                local MovementSection = vgui.Create("DPanel", TutorialScroller)
                MovementSection:Dock(TOP)
                MovementSection:SetSize(0, TM.MenuScale(280))
                MovementSection.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("MOVEMENT", "OptionsHeader", TM.MenuScale(280), 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end

                local MovementLabel = vgui.Create("DLabel", MovementSection)
                MovementLabel:SetPos(TM.MenuScale(280), TM.MenuScale(35))
                MovementLabel:SetSize(TM.MenuScale(554), TM.MenuScale(230))
                MovementLabel:SetFont("Menu_GModNotify")
                MovementLabel:SetText([[Titanmod has an assortment of movement mechanics to learn and use on your opponents!
Here are a few things to look out for:
Sliding                     Bunny Hopping
Wall Running          Wall Jumping
Rocket Jumping      Grappling
+ More to discover on your own
]])
                MovementLabel:SetWrap(true)

                local MovementImage = vgui.Create("DImage", MovementSection)
                MovementImage:SetPos(TM.MenuScale(10), TM.MenuScale(10))
                MovementImage:SetSize(TM.MenuScale(260), TM.MenuScale(260))
                MovementImage:SetImage("images/movement.png")

                local PersonalizeSection = vgui.Create("DPanel", TutorialScroller)
                PersonalizeSection:Dock(TOP)
                PersonalizeSection:SetSize(0, TM.MenuScale(280))
                PersonalizeSection.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("CUSTOMIZATION", "OptionsHeader", TM.MenuScale(280), 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end

                local PersonalizeLabel = vgui.Create("DLabel", PersonalizeSection)
                PersonalizeLabel:SetPos(TM.MenuScale(280), TM.MenuScale(50))
                PersonalizeLabel:SetSize(TM.MenuScale(554), TM.MenuScale(230))
                PersonalizeLabel:SetFont("Menu_GModNotify")
                PersonalizeLabel:SetText([[There are over 400+ items to unlock in Titanmod!
You have an assortment of melee weapons, player models and calling cards to express yourself with. Some are unlocked for you already, while some require you to complete specific challenges.
Check out the CUSTOMIZE page to see what is on offer.
Head to the OPTIONS page to tailor the experience to your needs. There is an extensive list of settings to change, and well as a robust HUD editor.
]])
                PersonalizeLabel:SetWrap(true)

                local PersonalizeImage = vgui.Create("DImage", PersonalizeSection)
                PersonalizeImage:SetPos(TM.MenuScale(10), TM.MenuScale(10))
                PersonalizeImage:SetSize(TM.MenuScale(260), TM.MenuScale(260))
                PersonalizeImage:SetImage("images/personalize.png")

                local EndingLabel = vgui.Create("DPanel", TutorialScroller)
                EndingLabel:Dock(TOP)
                EndingLabel:SetSize(0, TM.MenuScale(115))
                EndingLabel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("Join our Discord server!", "SettingsLabel", TM.MenuScale(90), TM.MenuScale(8), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Find people to play with or keep up wtih new updates and teasers", "Menu_GModNotify", TM.MenuScale(90), TM.MenuScale(48), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("^   click me please :)", "Menu_GModNotify", TM.MenuScale(44), TM.MenuScale(80), white, TEXT_ALIGN_LEFT)
                end

                local DiscordButton = vgui.Create("DImageButton", EndingLabel)
                DiscordButton:SetPos(TM.MenuScale(15), TM.MenuScale(8))
                DiscordButton:SetImage("icons/discordicon.png")
                DiscordButton:SetSize(TM.MenuScale(64), TM.MenuScale(64))
                DiscordButton.DoClick = function()
                    TriggerSound("click")
                    gui.OpenURL("https://discord.gg/GRfvt27uGF")
                end
                DiscordButton.Paint = function()
                    if DiscordButton:IsHovered() then
                        DiscordButton:SetColor(Color(114, 137, 218))
                    else
                        DiscordButton:SetColor(Color(255, 255, 255))
                    end
                end
            end

            if LocalPly:GetNWInt("playerDeaths") == 0 then ShowTutorial() end -- force shows the Tutorial is a player joins for the first time

            local TutorialButton = vgui.Create("DImageButton", MainPanel)
            TutorialButton:SetPos(TM.MenuScale(8), scrH - TM.MenuScale(96))
            TutorialButton:SetImage("icons/tutorialicon.png")
            TutorialButton:SetSize(TM.MenuScale(64), TM.MenuScale(64))
            TutorialButton:SetTooltip("Tutorial")
            TutorialButton.DoClick = function()
                TriggerSound("click")
                ShowTutorial()
            end

            local DiscordButton = vgui.Create("DImageButton", MainPanel)
            DiscordButton:SetPos(TM.MenuScale(108), scrH - TM.MenuScale(96))
            DiscordButton:SetImage("icons/discordicon.png")
            DiscordButton:SetSize(TM.MenuScale(64), TM.MenuScale(64))
            DiscordButton:SetTooltip("Discord")
            DiscordButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://discord.gg/GRfvt27uGF")
            end
            DiscordButton.Paint = function()
                if DiscordButton:IsHovered() then
                    DiscordButton:SetColor(Color(114, 137, 218))
                else
                    DiscordButton:SetColor(Color(255, 255, 255))
                end
            end

            local WorkshopButton = vgui.Create("DImageButton", MainPanel)
            WorkshopButton:SetPos(TM.MenuScale(180), scrH - TM.MenuScale(96))
            WorkshopButton:SetImage("icons/workshopicon.png")
            WorkshopButton:SetSize(TM.MenuScale(64), TM.MenuScale(64))
            WorkshopButton:SetTooltip("Steam Workshop")
            WorkshopButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3002938569")
            end
            WorkshopButton.Paint = function()
                if WorkshopButton:IsHovered() then
                    WorkshopButton:SetColor(Color(0, 164, 240))
                else
                    WorkshopButton:SetColor(Color(255, 255, 255))
                end
            end

            local YouTubeButton = vgui.Create("DImageButton", MainPanel)
            YouTubeButton:SetPos(TM.MenuScale(252), scrH - TM.MenuScale(96))
            YouTubeButton:SetImage("icons/youtubeicon.png")
            YouTubeButton:SetSize(TM.MenuScale(64), TM.MenuScale(64))
            YouTubeButton:SetTooltip("YouTube")
            YouTubeButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://youtu.be/MyBYoh2shmo?si=H6bU6E9xKseb4YuH")
            end
            YouTubeButton.Paint = function()
                if YouTubeButton:IsHovered() then
                    YouTubeButton:SetColor(Color(255, 0, 0))
                else
                    YouTubeButton:SetColor(Color(255, 255, 255))
                end
            end

            local GithubButton = vgui.Create("DImageButton", MainPanel)
            GithubButton:SetPos(TM.MenuScale(324), scrH - TM.MenuScale(96))
            GithubButton:SetImage("icons/githubicon.png")
            GithubButton:SetSize(TM.MenuScale(64), TM.MenuScale(64))
            GithubButton:SetTooltip("GitHub")
            GithubButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://github.com/PikachuPenial/Titanmod")
            end
            GithubButton.Paint = function()
                if GithubButton:IsHovered() then
                    GithubButton:SetColor(Color(108, 198, 68))
                else
                    GithubButton:SetColor(Color(255, 255, 255))
                end
            end

            local SpawnButton = vgui.Create("DButton", MainPanel)
            SpawnButton:SetPos(0, scrH / 2 - TM.MenuScale(50) - TM.MenuScale(pushSpawnItems))
            SpawnButton:SetText("")
            SpawnButton:SetSize(TM.MenuScale(535), TM.MenuScale(100))
            SpawnButton.Paint = function()
                SpawnButton:SetPos(0, scrH / 2 - TM.MenuScale(50) - TM.MenuScale(pushSpawnItems))
                if !timer.Exists("respawnTimeLeft") then
                    if SpawnButton:IsHovered() then
                        spawnTextAnim = math.Clamp(spawnTextAnim + 200 * RealFrameTime(), 0, 20)
                    else
                        spawnTextAnim = math.Clamp(spawnTextAnim - 200 * RealFrameTime(), 0, 20)
                    end

                    draw.DrawText("SPAWN", "AmmoCountSmall", TM.MenuScale(5) + TM.MenuScale(spawnTextAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
                    for i = 1, #weaponArray do
                        if activeGamemode == "Gun Game" then
                            draw.SimpleText(LocalPly:GetNWInt("ladderPosition") .. " / " .. ggLadderSize .. " kills", "MainMenuLoadoutWeapons", TM.MenuScale(325) + TM.MenuScale(spawnTextAnim), TM.MenuScale(15), white, TEXT_ALIGN_LEFT)
                        else
                            if weaponArray[i][1] == LocalPly:GetNWString("loadoutPrimary") and usePrimary then draw.SimpleText(weaponArray[i][2], "MainMenuLoadoutWeapons", TM.MenuScale(325) + TM.MenuScale(spawnTextAnim), TM.MenuScale(15), white, TEXT_ALIGN_LEFT) end
                            if weaponArray[i][1] == LocalPly:GetNWString("loadoutSecondary") and useSecondary then draw.SimpleText(weaponArray[i][2], "MainMenuLoadoutWeapons", TM.MenuScale(325) + TM.MenuScale(spawnTextAnim), TM.MenuScale(40) , white, TEXT_ALIGN_LEFT) end
                            if weaponArray[i][1] == LocalPly:GetNWString("loadoutMelee") and useMelee then draw.SimpleText(weaponArray[i][2], "MainMenuLoadoutWeapons", TM.MenuScale(325) + TM.MenuScale(spawnTextAnim), TM.MenuScale(65), white, TEXT_ALIGN_LEFT) end
                        end
                    end
                else
                    draw.DrawText("SPAWN", "AmmoCountSmall", TM.MenuScale(5) + TM.MenuScale(spawnTextAnim), TM.MenuScale(5), Color(250, 100, 100, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText("" .. math.Round(timer.TimeLeft("respawnTimeLeft"), 2), "AmmoCountSmall", TM.MenuScale(350) + TM.MenuScale(spawnTextAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
                end
            end
            SpawnButton.DoClick = function()
                if timer.Exists("respawnTimeLeft") then return end
                TriggerSound("click")
                CreateHUDHook()
                MainMenu:AlphaTo(0, 0.05, 0, function()

                    MainMenu:Remove()
                    gui.EnableScreenClicker(false)
                    hook.Remove("Think", "RenderBehindPauseMenu")
                    net.Start("CloseMainMenu")
                    net.SendToServer()

                end)
            end

            local CustomizeButton = vgui.Create("DButton", MainPanel)
            local CustomizeLoadoutButton = vgui.Create("DButton", CustomizeButton)
            local CustomizeModelButton = vgui.Create("DButton", CustomizeButton)
            local CustomizeCardButton = vgui.Create("DButton", CustomizeButton)
            CustomizeButton:SetPos(0, scrH / 2 + TM.MenuScale(50))
            CustomizeButton:SetText("")
            CustomizeButton:SetSize(TM.MenuScale(530), TM.MenuScale(100))
            local textAnim = 0
            CustomizeButton.Paint = function()
                if CustomizeButton:IsHovered() or CustomizeLoadoutButton:IsHovered() or CustomizeModelButton:IsHovered() or CustomizeCardButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 20)
                    pushSpawnItems = math.Clamp(pushSpawnItems + 600 * RealFrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, scrH / 2 + TM.MenuScale(50) - TM.MenuScale(pushSpawnItems))
                    CustomizeButton:SizeTo(TM.MenuScale(530), TM.MenuScale(200), 0, 0, 1)
                else
                    textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 20)
                    pushSpawnItems = math.Clamp(pushSpawnItems - 600 * RealFrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, scrH / 2 + TM.MenuScale(50) - TM.MenuScale(pushSpawnItems))
                    CustomizeButton:SizeTo(TM.MenuScale(530), TM.MenuScale(100), 0, 0, 1)
                end
                draw.DrawText("CUSTOMIZE", "AmmoCountSmall", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
            end

            CustomizeLoadoutButton:SetPos(0, TM.MenuScale(100))
            CustomizeLoadoutButton:SetText("")
            CustomizeLoadoutButton:SetSize(TM.MenuScale(180), TM.MenuScale(100))
            CustomizeLoadoutButton.Paint = function()
                draw.DrawText("GEAR", "AmmoCountESmall", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
            end

            CustomizeModelButton:SetPos(TM.MenuScale(180), TM.MenuScale(100))
            CustomizeModelButton:SetText("")
            CustomizeModelButton:SetSize(TM.MenuScale(180), TM.MenuScale(100))
            CustomizeModelButton.Paint = function()
                draw.DrawText("MODEL", "AmmoCountESmall", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
            end

            CustomizeCardButton:SetPos(TM.MenuScale(380), TM.MenuScale(100))
            CustomizeCardButton:SetText("")
            CustomizeCardButton:SetSize(TM.MenuScale(160), TM.MenuScale(100))
            CustomizeCardButton.Paint = function()
                draw.DrawText("CARD", "AmmoCountESmall", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
            end

            CustomizeLoadoutButton.DoClick = function()
                if IsValid(GearPanel) then return end
                TriggerSound("click")
                MainPanel:AlphaTo(0, 0.05, 0, function() MainPanel:Hide() end)
                local currentGear = LocalPly:GetNWString("chosenMelee")

                local GearPanel = vgui.Create("DPanel", MainMenu)
                GearPanel:SetSize(TM.MenuScale(645), scrH)
                GearPanel:SetPos(TM.MenuScale(56), 0)
                GearPanel:SetAlpha(0)
                GearPanel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, transparent)
                end

                local GearSlideoutPanel = vgui.Create("DPanel", MainMenu)
                GearSlideoutPanel:SetSize(TM.MenuScale(56), scrH)
                GearSlideoutPanel:SetPos(0, 0)
                GearSlideoutPanel:SetAlpha(0)
                GearSlideoutPanel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, transparent)
                end

                local GearQuickjumpHolder = vgui.Create("DPanel", GearSlideoutPanel)
                GearQuickjumpHolder:Dock(TOP)
                GearQuickjumpHolder:SetSize(0, scrH)
                GearQuickjumpHolder:SetAlpha(0)
                GearQuickjumpHolder.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    draw.RoundedBox(0, TM.MenuScale(4), scrH - TM.MenuScale(52), TM.MenuScale(48), TM.MenuScale(48), transparentRed)
                end

                GearPanel:AlphaTo(255, 0.05, 0.025)
                GearSlideoutPanel:AlphaTo(255, 0.05, 0.025)
                GearQuickjumpHolder:AlphaTo(255, 0.05, 0.025)

                local equippedGear
                local equippedGearName
                local equippedGearModel
                local equippedGearUnlockType
                local equippedGearUnlockKills
                local equippedGearUnlockLevel

                local newGear
                local newGearName
                local newGearModel
                local newGearUnlockType
                local newGearUnlockKills
                local newGearUnlockLevel

                local totalGear = table.Count(gearArray)
                local gearUnlocked = 0

                local defaultGearTotal = 0
                local defaultGearUnlocked = 0

                local progressionGearTotal = 0
                local progressionGearUnlocked = 0

                local playerTotalLevel = (LocalPly:GetNWInt("playerPrestige") * 60) + LocalPly:GetNWInt("playerLevel")

                -- checking for the players currently equipped gear
                for i = 1, #gearArray do
                    if gearArray[i][1] == currentGear then
                        equippedGear = gearArray[i][1]
                        equippedGearName = gearArray[i][2]
                        equippedGearModel = gearArray[i][3]
                        equippedGearUnlockType = gearArray[i][4]
                        equippedGearUnlockKills = gearArray[i][5]
                        equippedGearUnlockLevel = gearArray[i][6]

                        newGear = gearArray[i][1]
                        newGearName = gearArray[i][2]
                        newGearModel = gearArray[i][3]
                        newGearUnlockType = gearArray[i][4]
                        newGearUnlockKills = gearArray[i][5]
                        newGearUnlockLevel = gearArray[i][6]
                    end
                end

                local GearScroller = vgui.Create("DScrollPanel", GearPanel)
                GearScroller:Dock(FILL)

                local sbar = GearScroller:GetVBar()
                sbar:SetHideButtons(true)
                sbar:SetSize(TM.MenuScale(15), TM.MenuScale(15))
                function sbar:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, gray)
                end
                function sbar.btnGrip:Paint(w, h)
                    draw.RoundedBox(0, TM.MenuScale(5), TM.MenuScale(8), TM.MenuScale(5), h - TM.MenuScale(16), Color(255, 255, 255, 175))
                end

                local GearTextHolder = vgui.Create("DPanel", GearPanel)
                GearTextHolder:Dock(TOP)
                GearTextHolder:SetSize(0, TM.MenuScale(160))

                GearTextHolder.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, gray)
                    draw.SimpleText("GEAR", "AmmoCountSmall", w / 2, TM.MenuScale(5), white, TEXT_ALIGN_CENTER)
                    draw.SimpleText(gearUnlocked .. " / " .. totalGear .. " UNLOCKED", "MainMenuDescription", w / 2, TM.MenuScale(85), white, TEXT_ALIGN_CENTER)
                    draw.SimpleText("hide locked gear", "StreakText", w / 2 + TM.MenuScale(20), TM.MenuScale(120), white, TEXT_ALIGN_CENTER)
                end

                local HideLockedGear = GearTextHolder:Add("DCheckBox")
                HideLockedGear:SetPos(TM.MenuScale(248), TM.MenuScale(122.5))
                HideLockedGear:SetSize(TM.MenuScale(20), TM.MenuScale(20))
                function HideLockedGear:OnChange() TriggerSound("click") end

                -- default cards
                local TextDefault = vgui.Create("DPanel", GearScroller)
                TextDefault:Dock(TOP)
                TextDefault:SetSize(0, TM.MenuScale(85))

                local DockDefaultGear = vgui.Create("DPanel", GearScroller)
                DockDefaultGear:Dock(TOP)
                DockDefaultGear:SetSize(0, TM.MenuScale(400))

                local DefaultGearList = vgui.Create("DIconLayout", DockDefaultGear)
                DefaultGearList:Dock(TOP)
                DefaultGearList:SetSpaceY(0)
                DefaultGearList:SetSpaceX(0)

                DefaultGearList.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, transparent)
                end

                TextDefault.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, gray)
                    draw.SimpleText("DEFAULT", "OptionsHeader", w / 2, TM.MenuScale(-5), white, TEXT_ALIGN_CENTER)
                    draw.SimpleText(defaultGearTotal .. " / " .. defaultGearUnlocked, "MainMenuDescription", w / 2, TM.MenuScale(50), solidGreen, TEXT_ALIGN_CENTER)
                end

                -- progression cards
                local TextProgression = vgui.Create("DPanel", GearScroller)
                TextProgression:Dock(TOP)
                TextProgression:SetSize(0, TM.MenuScale(85))

                local DockProgressionGear = vgui.Create("DPanel", GearScroller)
                DockProgressionGear:Dock(TOP)
                DockProgressionGear:SetSize(0, TM.MenuScale(1100))

                local ProgressionGearList = vgui.Create("DIconLayout", DockProgressionGear)
                ProgressionGearList:Dock(TOP)
                ProgressionGearList:SetSpaceY(0)
                ProgressionGearList:SetSpaceX(0)

                ProgressionGearList.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, transparent)
                end

                TextProgression.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, gray)
                    draw.SimpleText("PROGRESSION", "OptionsHeader", w / 2, TM.MenuScale(-5), white, TEXT_ALIGN_CENTER)

                    if progressionGearUnlocked == progressionGearTotal then
                        draw.SimpleText(progressionGearUnlocked .. " / " .. progressionGearTotal, "MainMenuDescription", w / 2, TM.MenuScale(50), solidGreen, TEXT_ALIGN_CENTER)
                    else
                        draw.SimpleText(progressionGearUnlocked .. " / " .. progressionGearTotal, "MainMenuDescription", w / 2, TM.MenuScale(50), white, TEXT_ALIGN_CENTER)
                    end
                end

                local GearPreviewPanel = vgui.Create("DPanel", MainMenu)
                GearPreviewPanel:SetSize(TM.MenuScale(1450), scrH)
                GearPreviewPanel:SetPos(TM.MenuScale(700), 0)
                GearPreviewPanel:SetAlpha(0)
                GearPreviewPanel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, transparent)
                end

                GearPreviewPanel:AlphaTo(255, 0.05, 0.025)

                local SelectedGearHolder = vgui.Create("DPanel", GearPreviewPanel)
                SelectedGearHolder:SetSize(TM.MenuScale(600), TM.MenuScale(2000))
                SelectedGearHolder.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, transparent)
                end

                local SelectedGearDisplay
                local function PreviewNewGear(model)
                    if IsValid(SelectedGearDisplay) then SelectedGearDisplay:Remove() end
                    SelectedGearDisplay = vgui.Create("DModelPanel", SelectedGearHolder)
                    SelectedGearDisplay:SetAlpha(0)
                    SelectedGearDisplay:SetSize(TM.MenuScale(1450), scrH)
                    SelectedGearDisplay:SetPos(TM.MenuScale(-525), 0)
                    SelectedGearDisplay:SetMouseInputEnabled(true)
                    SelectedGearDisplay:SetDirectionalLight(BOX_RIGHT, Color(255, 160, 80, 255))
                    SelectedGearDisplay:SetDirectionalLight(BOX_LEFT, Color(80, 160, 255, 255))
                    SelectedGearDisplay:SetAnimated(true)
                    SelectedGearDisplay:SetModel(model)
                    SelectedGearDisplay.Entity:SetAngles(Angle(-10, 20, 10))
                    SelectedGearDisplay.Entity:SetPos(Vector(6, 5, 35))

                    SelectedGearDisplay:AlphaTo(255, 0.05, 0.025)
                end

                PreviewNewGear(newGearModel)

                local function ApplyGear()
                    surface.PlaySound("tmui/uisuccess.wav")
                    net.Start("PlayerGearChange")
                    net.WriteString(newGear)
                    net.SendToServer()
                    GearPanel:AlphaTo(0, 0.05, 0, function() GearPanel:Hide() end)
                    GearPreviewPanel:AlphaTo(0, 0.05, 0, function() GearPreviewPanel:Hide() end)
                    GearSlideoutPanel:AlphaTo(0, 0.05, 0, function() GearSlideoutPanel:Hide() end)
                    MainPanel:Show()
                    MainPanel:AlphaTo(255, 0.05, 0.025)
                end

                local previewRed = Color(255, 0, 0, 5)
                local previewGreen = Color(0, 255, 0, 5)

                local function FillGearListsAll()
                    local lockedGear = {}
                    for i = 1, #gearArray do
                        if gearArray[i][4] == "default" then
                            local gear = vgui.Create("DButton", DockDefaultGear)
                            gear:SetSize(TM.MenuScale(635), TM.MenuScale(100))
                            gear:SetText("")
                            gear.Paint = function(self, w, h)
                                draw.RoundedBox(0, 0, 0, w, h, previewGreen)

                                draw.SimpleTextOutlined(string.upper(gearArray[i][2]), "PlayerNotiName", TM.MenuScale(5), 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 205))
                                draw.SimpleTextOutlined("Unlocked", "PlayerNotiName", TM.MenuScale(5), TM.MenuScale(50), solidGreen, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))
                            end

                            DefaultGearList:Add(gear)

                            defaultGearTotal = defaultGearTotal + 1
                            gearUnlocked = gearUnlocked + 1
                            defaultGearUnlocked = defaultGearUnlocked + 1

                            gear.OnCursorEntered = function()
                                newGear = gearArray[i][1]
                                newGearName = gearArray[i][2]
                                newGearModel = gearArray[i][3]
                                newGearUnlockType = gearArray[i][4]
                                newGearUnlockKills = gearArray[i][5]
                                newGearUnlockLevel = gearArray[i][6]
                                TriggerSound("hover")
                                PreviewNewGear(newGearModel)
                            end

                            gear.OnCursorExited = function()
                                newGear = equippedGear
                                newGearName = equippedGearName
                                newGearModel = equippedGearModel
                                newGearUnlockType = equippedGearUnlockType
                                newGearUnlockKills = equippedGearUnlockKills
                                newGearUnlockLevel = equippedGearUnlockLevel
                                PreviewNewGear(equippedGearModel)
                            end

                            gear.DoClick = function() ApplyGear() end
                        elseif gearArray[i][4] == "melee" then
                            progressionGearTotal = progressionGearTotal + 1

                            if gearArray[i][4] == "melee" and LocalPly:GetNWInt("playerAccoladeSmackdown") < gearArray[i][5] and gearArray[i][4] == "melee" and playerTotalLevel < gearArray[i][6] then
                                table.insert(lockedGear, gearArray[i])
                            else
                                local gear = vgui.Create("DButton", DockProgressionGear)
                                gear:SetSize(TM.MenuScale(635), TM.MenuScale(100))
                                gear:SetText("")
                                gear.Paint = function(self, w, h)
                                    draw.RoundedBox(0, 0, 0, w, h, previewGreen)

                                    draw.SimpleTextOutlined(string.upper(gearArray[i][2]), "PlayerNotiName", TM.MenuScale(5), 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                    draw.SimpleTextOutlined("Unlocked", "PlayerNotiName", TM.MenuScale(5), TM.MenuScale(50), solidGreen, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))

                                    draw.SimpleTextOutlined("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. gearArray[i][5], "MainMenuDescription", TM.MenuScale(625), TM.MenuScale(25), solidGreen, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))
                                    draw.SimpleTextOutlined("OR", "MainMenuDescription", TM.MenuScale(625), TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                    draw.SimpleTextOutlined("Total Levels: " .. playerTotalLevel .. "/" .. gearArray[i][6], "MainMenuDescription", TM.MenuScale(625), TM.MenuScale(65), solidGreen, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))
                                end

                                ProgressionGearList:Add(gear)

                                gearUnlocked = gearUnlocked + 1
                                progressionGearUnlocked = progressionGearUnlocked + 1

                                gear.OnCursorEntered = function()
                                    newGear = gearArray[i][1]
                                    newGearName = gearArray[i][2]
                                    newGearModel = gearArray[i][3]
                                    newGearUnlockType = gearArray[i][4]
                                    newGearUnlockKills = gearArray[i][5]
                                    newGearUnlockLevel = gearArray[i][6]
                                    TriggerSound("hover")
                                    PreviewNewGear(newGearModel)
                                end

                                gear.OnCursorExited = function()
                                    newGear = equippedGear
                                    newGearName = equippedGearName
                                    newGearModel = equippedGearModel
                                    newGearUnlockType = equippedGearUnlockType
                                    newGearUnlockKills = equippedGearUnlockKills
                                    newGearUnlockLevel = equippedGearUnlockLevel
                                    PreviewNewGear(equippedGearModel)
                                end

                                gear.DoClick = function() ApplyGear() end
                            end
                        end
                    end

                    for i = 1, #lockedGear do
                        if lockedGear[i][4] == "melee" then
                            local gear = vgui.Create("DButton", DockProgressionGear)
                            gear:SetSize(TM.MenuScale(635), TM.MenuScale(100))
                            gear:SetText("")
                            gear.Paint = function(self, w, h)
                                draw.RoundedBox(0, 0, 0, w, h, previewRed)

                                draw.SimpleTextOutlined(string.upper(lockedGear[i][2]), "PlayerNotiName", TM.MenuScale(5), 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                draw.SimpleTextOutlined("Locked", "PlayerNotiName", TM.MenuScale(5), TM.MenuScale(50), solidRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))

                                draw.SimpleTextOutlined("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. lockedGear[i][5], "MainMenuDescription", TM.MenuScale(625), TM.MenuScale(25), solidRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))
                                draw.SimpleTextOutlined("OR", "MainMenuDescription", TM.MenuScale(625), TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                draw.SimpleTextOutlined("Total Levels: " .. playerTotalLevel .. "/" .. lockedGear[i][6], "MainMenuDescription", TM.MenuScale(625), TM.MenuScale(65), solidRed, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))
                            end

                            ProgressionGearList:Add(gear)

                            gear.OnCursorEntered = function()
                                newGear = lockedGear[i][1]
                                newGearName = lockedGear[i][2]
                                newGearModel = lockedGear[i][3]
                                newGearUnlockType = lockedGear[i][4]
                                newGearUnlockKills = lockedGear[i][5]
                                newGearUnlockLevel = lockedGear[i][6]
                                TriggerSound("hover")
                                PreviewNewGear(newGearModel)
                            end

                            gear.OnCursorExited = function()
                                newGear = equippedGear
                                newGearName = equippedGearName
                                newGearModel = equippedGearModel
                                newGearUnlockType = equippedGearUnlockType
                                newGearUnlockKills = equippedGearUnlockKills
                                newGearUnlockLevel = equippedGearUnlockLevel
                                PreviewNewGear(equippedGearModel)
                            end

                            gear.DoClick = function() surface.PlaySound("tmui/warning.wav") end
                        end
                    end
                end

                local function FillGearListsUnlocked()
                    for i = 1, #gearArray do
                        if gearArray[i][4] == "default" then
                            local gear = vgui.Create("DButton", DockDefaultGear)
                            gear:SetSize(TM.MenuScale(635), TM.MenuScale(100))
                            gear:SetText("")
                            gear.Paint = function(self, w, h)
                                draw.RoundedBox(0, 0, 0, w, h, previewGreen)

                                draw.SimpleTextOutlined(string.upper(gearArray[i][2]), "PlayerNotiName", TM.MenuScale(5), 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                draw.SimpleTextOutlined("Unlocked", "PlayerNotiName", TM.MenuScale(5), TM.MenuScale(50), solidGreen, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))
                            end

                            DefaultGearList:Add(gear)

                            defaultGearTotal = defaultGearTotal + 1
                            gearUnlocked = gearUnlocked + 1
                            defaultGearUnlocked = defaultGearUnlocked + 1

                            gear.OnCursorEntered = function()
                                newGear = gearArray[i][1]
                                newGearName = gearArray[i][2]
                                newGearModel = gearArray[i][3]
                                newGearUnlockType = gearArray[i][4]
                                newGearUnlockKills = gearArray[i][5]
                                newGearUnlockLevel = gearArray[i][6]
                                TriggerSound("hover")
                                PreviewNewGear(newGearModel)
                            end

                            gear.OnCursorExited = function()
                                newGear = equippedGear
                                newGearName = equippedGearName
                                newGearModel = equippedGearModel
                                newGearUnlockType = equippedGearUnlockType
                                newGearUnlockKills = equippedGearUnlockKills
                                newGearUnlockLevel = equippedGearUnlockLevel
                                PreviewNewGear(equippedGearModel)
                            end

                            gear.DoClick = function() ApplyGear() end
                        elseif gearArray[i][4] == "melee" then
                            progressionGearTotal = progressionGearTotal + 1

                            if gearArray[i][4] == "melee" and LocalPly:GetNWInt("playerAccoladeSmackdown") < gearArray[i][5] and gearArray[i][4] == "melee" and playerTotalLevel < gearArray[i][6] then
                                return
                            else
                                local gear = vgui.Create("DButton", DockProgressionGear)
                                gear:SetSize(TM.MenuScale(635), TM.MenuScale(100))
                                gear:SetText("")
                                gear.Paint = function(self, w, h)
                                    draw.RoundedBox(0, 0, 0, w, h, previewGreen)

                                    draw.SimpleTextOutlined(string.upper(gearArray[i][2]), "PlayerNotiName", TM.MenuScale(5), 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                    draw.SimpleTextOutlined("Unlocked", "PlayerNotiName", TM.MenuScale(5), TM.MenuScale(50), solidGreen, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))

                                    draw.SimpleTextOutlined("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. gearArray[i][5], "MainMenuDescription", TM.MenuScale(625), TM.MenuScale(25), solidGreen, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))
                                    draw.SimpleTextOutlined("OR", "MainMenuDescription", TM.MenuScale(625), TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                    draw.SimpleTextOutlined("Total Levels: " .. playerTotalLevel .. "/" .. gearArray[i][6], "MainMenuDescription", TM.MenuScale(625), TM.MenuScale(65), solidGreen, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 0, Color(0, 0, 0, 205))
                                end

                                ProgressionGearList:Add(gear)

                                gearUnlocked = gearUnlocked + 1
                                progressionGearUnlocked = progressionGearUnlocked + 1

                                gear.OnCursorEntered = function()
                                    newGear = gearArray[i][1]
                                    newGearName = gearArray[i][2]
                                    newGearModel = gearArray[i][3]
                                    newGearUnlockType = gearArray[i][4]
                                    newGearUnlockKills = gearArray[i][5]
                                    newGearUnlockLevel = gearArray[i][6]
                                    TriggerSound("hover")
                                    PreviewNewGear(newGearModel)
                                end

                                gear.OnCursorExited = function()
                                    newGear = equippedGear
                                    newGearName = equippedGearName
                                    newGearModel = equippedGearModel
                                    newGearUnlockType = equippedGearUnlockType
                                    newGearUnlockKills = equippedGearUnlockKills
                                    newGearUnlockLevel = equippedGearUnlockLevel
                                    PreviewNewGear(equippedGearModel)
                                end

                                gear.DoClick = function() ApplyGear() end
                            end
                        end
                    end
                end

                FillGearListsAll()

                function HideLockedGear:OnChange(bVal)
                    if (bVal) then
                        DefaultGearList:Clear()
                        ProgressionGearList:Clear()
                        gearUnlocked = 0
                        defaultGearTotal = 0
                        defaultGearUnlocked = 0
                        progressionGearTotal = 0
                        progressionGearUnlocked = 0
                        FillGearListsUnlocked()
                        DockDefaultGear:SetSize(0, TM.MenuScale(400))
                        DockProgressionGear:SetSize(0, progressionGearUnlocked * TM.MenuScale(100))
                    else
                        DefaultGearList:Clear()
                        ProgressionGearList:Clear()
                        gearUnlocked = 0
                        defaultGearTotal = 0
                        defaultGearUnlocked = 0
                        progressionGearTotal = 0
                        progressionGearUnlocked = 0
                        FillGearListsAll()
                        DockDefaultGear:SetSize(0, TM.MenuScale(400))
                        DockProgressionGear:SetSize(0, TM.MenuScale(1100))
                    end
                end

                local GearIcon = vgui.Create("DImage", GearQuickjumpHolder)
                GearIcon:SetPos(TM.MenuScale(12), TM.MenuScale(12))
                GearIcon:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                GearIcon:SetImage("icons/gearicon.png")

                local BackButtonSlideout = vgui.Create("DImageButton", GearQuickjumpHolder)
                BackButtonSlideout:SetPos(TM.MenuScale(12), scrH - TM.MenuScale(44))
                BackButtonSlideout:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                BackButtonSlideout:SetImage("icons/exiticon.png")
                BackButtonSlideout:SetTooltip("Return to Main Menu")
                BackButtonSlideout.DoClick = function()
                    TriggerSound("back")
                    GearPanel:AlphaTo(0, 0.05, 0, function() GearPanel:Hide() end)
                    GearPreviewPanel:AlphaTo(0, 0.05, 0, function() GearPreviewPanel:Hide() end)
                    GearSlideoutPanel:AlphaTo(0, 0.05, 0, function() GearSlideoutPanel:Hide() end)
                    MainPanel:Show()
                    MainPanel:AlphaTo(255, 0.05, 0.025)
                end
            end

            CustomizeCardButton.DoClick = function()
                if IsValid(CardPanel) then return end
                TriggerSound("click")
                MainPanel:AlphaTo(0, 0.05, 0, function() MainPanel:Hide() end)
                local currentCard = LocalPly:GetNWString("chosenPlayercard")

                if !IsValid(CardPanel) then
                    local CardPanel = vgui.Create("DPanel", MainMenu)
                    CardPanel:SetSize(TM.MenuScale(745), scrH)
                    CardPanel:SetPos(TM.MenuScale(56), 0)
                    CardPanel:SetAlpha(0)
                    CardPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local CardSlideoutPanel = vgui.Create("DPanel", MainMenu)
                    CardSlideoutPanel:SetSize(TM.MenuScale(56), scrH)
                    CardSlideoutPanel:SetPos(0, 0)
                    CardSlideoutPanel:SetAlpha(0)
                    CardSlideoutPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local CardQuickjumpHolder = vgui.Create("DPanel", CardSlideoutPanel)
                    CardQuickjumpHolder:Dock(TOP)
                    CardQuickjumpHolder:SetSize(0, scrH)
                    CardQuickjumpHolder:SetAlpha(0)
                    CardQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                        draw.RoundedBox(0, TM.MenuScale(4), scrH - TM.MenuScale(52), TM.MenuScale(48), TM.MenuScale(48), transparentRed)
                    end

                    CardPanel:AlphaTo(255, 0.05, 0.025)
                    CardSlideoutPanel:AlphaTo(255, 0.05, 0.025)
                    CardQuickjumpHolder:AlphaTo(255, 0.05, 0.025)

                    local equippedCard
                    local equippedCardName
                    local equippedCardDesc
                    local equippedCardUnlockType
                    local equippedCardUnlockValue

                    local newCard
                    local newCardName
                    local newCardDesc
                    local newCardUnlockType
                    local newCardUnlockValue

                    local totalCards = table.Count(cardArray)
                    local cardsUnlocked = 0

                    local defaultCardsTotal = 0
                    local defaultCardsUnlocked = 0

                    local statCardsTotal = 0
                    local statCardsUnlocked = 0

                    local accoladeCardsTotal = 0
                    local accoladeCardsUnlocked = 0

                    local levelCardsTotal = 0
                    local levelCardsUnlocked = 0

                    local masteryCardsTotal = 0
                    local masteryCardsUnlocked = 0

                    local colorCardsTotal = 0
                    local colorCardsUnlocked = 0

                    local prideCardsTotal = 0
                    local prideCardsUnlocked = 0

                    local playerTotalLevel = (LocalPly:GetNWInt("playerPrestige") * 60) + LocalPly:GetNWInt("playerLevel")

                    -- checking for the players currently equipped card
                    for i = 1, #cardArray do
                        if cardArray[i][1] == currentCard then
                            newCard = cardArray[i][1]
                            newCardName = cardArray[i][2]
                            newCardDesc = cardArray[i][3]
                            newCardUnlockType = cardArray[i][4]
                            newCardUnlockValue = cardArray[i][5]

                            equippedCard = cardArray[i][1]
                            equippedCardName = cardArray[i][2]
                            equippedCardDesc = cardArray[i][3]
                            equippedCardUnlockType = cardArray[i][4]
                            equippedCardUnlockValue = cardArray[i][5]
                        end
                    end

                    local CardScroller = vgui.Create("DScrollPanel", CardPanel)
                    CardScroller:Dock(FILL)

                    local sbar = CardScroller:GetVBar()
                    sbar:SetHideButtons(true)
                    sbar:SetSize(TM.MenuScale(15), TM.MenuScale(15))
                    function sbar:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(0, TM.MenuScale(5), TM.MenuScale(8), TM.MenuScale(5), h - TM.MenuScale(16), Color(255, 255, 255, 175))
                    end

                    local CardTextHolder = vgui.Create("DPanel", CardPanel)
                    CardTextHolder:Dock(TOP)
                    CardTextHolder:SetSize(0, TM.MenuScale(160))

                    CardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("CARDS", "AmmoCountSmall", w / 2, TM.MenuScale(5), white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(cardsUnlocked .. " / " .. totalCards .. " UNLOCKED", "MainMenuDescription", w / 2, TM.MenuScale(85), white, TEXT_ALIGN_CENTER)
                        draw.SimpleText("hide locked playercards", "StreakText", w / 2 + TM.MenuScale(20), TM.MenuScale(120), white, TEXT_ALIGN_CENTER)
                    end

                    local CardPreviewPanel = vgui.Create("DPanel", CardPanel)
                    CardPreviewPanel:Dock(TOP)
                    CardPreviewPanel:SetSize(0, TM.MenuScale(100))
                    CardPreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local HideLockedCards = CardTextHolder:Add("DCheckBox")
                    HideLockedCards:SetPos(TM.MenuScale(268), TM.MenuScale(122.5))
                    HideLockedCards:SetSize(TM.MenuScale(20), TM.MenuScale(20))
                    function HideLockedCards:OnChange() TriggerSound("click") end

                    -- default cards
                    local TextDefault = vgui.Create("DPanel", CardScroller)
                    TextDefault:Dock(TOP)
                    TextDefault:SetSize(0, TM.MenuScale(85))

                    local DockDefaultCards = vgui.Create("DPanel", CardScroller)
                    DockDefaultCards:Dock(TOP)
                    DockDefaultCards:SetSize(0, TM.MenuScale(340))

                    -- leveling related cards
                    local TextLevel = vgui.Create("DPanel", CardScroller)
                    TextLevel:Dock(TOP)
                    TextLevel:SetSize(0, TM.MenuScale(85))

                    local DockLevelCards = vgui.Create("DPanel", CardScroller)
                    DockLevelCards:Dock(TOP)
                    DockLevelCards:SetSize(0, TM.MenuScale(1700))

                    -- kill related cards
                    local TextStats = vgui.Create("DPanel", CardScroller)
                    TextStats:Dock(TOP)
                    TextStats:SetSize(0, TM.MenuScale(85))

                    local DockStatCards = vgui.Create("DPanel", CardScroller)
                    DockStatCards:Dock(TOP)
                    DockStatCards:SetSize(0, TM.MenuScale(680))

                    -- accolade related cards
                    local TextAccolade = vgui.Create("DPanel", CardScroller)
                    TextAccolade:Dock(TOP)
                    TextAccolade:SetSize(0, TM.MenuScale(85))

                    local DockAccoladeCards = vgui.Create("DPanel", CardScroller)
                    DockAccoladeCards:Dock(TOP)
                    DockAccoladeCards:SetSize(0, TM.MenuScale(850))

                    -- mastery related cards
                    local TextMastery = vgui.Create("DPanel", CardScroller)
                    TextMastery:Dock(TOP)
                    TextMastery:SetSize(0, TM.MenuScale(85))

                    local DockMasteryCards = vgui.Create("DPanel", CardScroller)
                    DockMasteryCards:Dock(TOP)
                    DockMasteryCards:SetSize(0, TM.MenuScale(4430))

                    -- color related cards
                    local TextColor = vgui.Create("DPanel", CardScroller)
                    TextColor:Dock(TOP)
                    TextColor:SetSize(0, TM.MenuScale(85))

                    local DockColorCards = vgui.Create("DPanel", CardScroller)
                    DockColorCards:Dock(TOP)
                    DockColorCards:SetSize(0, TM.MenuScale(340))

                    -- pride related cards
                    local TextPride = vgui.Create("DPanel", CardScroller)
                    TextPride:Dock(TOP)
                    TextPride:SetSize(0, TM.MenuScale(85))

                    local DockPrideCards = vgui.Create("DPanel", CardScroller)
                    DockPrideCards:Dock(TOP)
                    DockPrideCards:SetSize(0, TM.MenuScale(1785))

                    -- creating playercard lists
                    local DefaultCardList = vgui.Create("DIconLayout", DockDefaultCards)
                    DefaultCardList:Dock(TOP)
                    DefaultCardList:SetSpaceY(TM.MenuScale(5))
                    DefaultCardList:SetSpaceX(TM.MenuScale(4))

                    local StatCardList = vgui.Create("DIconLayout", DockStatCards)
                    StatCardList:Dock(TOP)
                    StatCardList:SetSpaceY(TM.MenuScale(5))
                    StatCardList:SetSpaceX(TM.MenuScale(4))

                    local AccoladeCardList = vgui.Create("DIconLayout", DockAccoladeCards)
                    AccoladeCardList:Dock(TOP)
                    AccoladeCardList:SetSpaceY(TM.MenuScale(5))
                    AccoladeCardList:SetSpaceX(TM.MenuScale(4))

                    local LevelCardList = vgui.Create("DIconLayout", DockLevelCards)
                    LevelCardList:Dock(TOP)
                    LevelCardList:SetSpaceY(TM.MenuScale(5))
                    LevelCardList:SetSpaceX(TM.MenuScale(4))

                    local MasteryCardList = vgui.Create("DIconLayout", DockMasteryCards)
                    MasteryCardList:Dock(TOP)
                    MasteryCardList:SetSpaceY(TM.MenuScale(5))
                    MasteryCardList:SetSpaceX(TM.MenuScale(4))

                    local ColorCardList = vgui.Create("DIconLayout", DockColorCards)
                    ColorCardList:Dock(TOP)
                    ColorCardList:SetSpaceY(TM.MenuScale(5))
                    ColorCardList:SetSpaceX(TM.MenuScale(4))

                    local PrideCardList = vgui.Create("DIconLayout", DockPrideCards)
                    PrideCardList:Dock(TOP)
                    PrideCardList:SetSpaceY(TM.MenuScale(5))
                    PrideCardList:SetSpaceX(TM.MenuScale(4))

                    DefaultCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    StatCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    AccoladeCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    LevelCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    MasteryCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    ColorCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    PrideCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local PreviewCardTextHolder = vgui.Create("DPanel", CardPreviewPanel)
                    PreviewCardTextHolder:Dock(FILL)
                    PreviewCardTextHolder:SetSize(0, TM.MenuScale(100))

                    CallingCard = vgui.Create("DImage", PreviewCardTextHolder)
                    CallingCard:SetPos(TM.MenuScale(245), TM.MenuScale(10))
                    CallingCard:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                    CallingCard:SetImage(newCard)

                    ProfilePicture = vgui.Create("AvatarImage", CallingCard)
                    ProfilePicture:SetPos(TM.MenuScale(5), TM.MenuScale(5))
                    ProfilePicture:SetSize(TM.MenuScale(70), TM.MenuScale(70))
                    ProfilePicture:SetPlayer(LocalPly, 184)

                    local previewRed = Color(255, 0, 0, 5)
                    local previewGreen = Color(0, 255, 0, 5)
                    local previewColor = previewGreen

                    local function ApplyCard()
                        surface.PlaySound("tmui/uisuccess.wav")
                        net.Start("PlayerCardChange")
                        net.WriteString(newCard)
                        net.SendToServer()
                        plyCallingCard:SetImage(newCard)
                        CardPanel:AlphaTo(0, 0.05, 0, function() CardPanel:Hide() end)
                        CardPreviewPanel:AlphaTo(0, 0.05, 0, function() CardPreviewPanel:Hide() end)
                        CardSlideoutPanel:AlphaTo(0, 0.05, 0, function() CardSlideoutPanel:Hide() end)
                        MainPanel:Show()
                        MainPanel:AlphaTo(255, 0.05, 0.025)
                    end

                    PreviewCardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                        draw.RoundedBox(0, 0, 0, w, h, previewColor)

                        if currentCard != nil then
                            draw.SimpleText(newCardName, "PlayerNotiName", TM.MenuScale(240), TM.MenuScale(5), white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(newCardDesc, "MainMenuDescription", TM.MenuScale(240), TM.MenuScale(65), white, TEXT_ALIGN_RIGHT)
                        end

                        if newCardUnlockType == "default" or newCardUnlockType == "color" or newCardUnlockType == "pride" then
                            draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                            previewColor = previewGreen
                        elseif newCardUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Kills: " .. LocalPly:GetNWInt("playerKills") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Kills: " .. LocalPly:GetNWInt("playerKills") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Highest Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Highest Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "matches" then
                            if LocalPly:GetNWInt("matchesPlayed") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Matches Played: " .. LocalPly:GetNWInt("matchesPlayed") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Matches Played: " .. LocalPly:GetNWInt("matchesPlayed") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "wins" then
                            if LocalPly:GetNWInt("matchesWon") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Matches Won: " .. LocalPly:GetNWInt("matchesWon") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Matches Won: " .. LocalPly:GetNWInt("matchesWon") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Streaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Streaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "level" then
                            if playerTotalLevel < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Total Levels: " .. playerTotalLevel .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Total Levels: " .. playerTotalLevel .. "/" .. newCardUnlockValue, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "mastery" then
                            if LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) < 50 then
                                draw.SimpleText("Locked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Kills w/ gun: " .. LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) .. "/" .. 50, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", TM.MenuScale(490), TM.MenuScale(5), solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Kills w/ gun: " .. LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) .. "/" .. 50, "MainMenuDescription", TM.MenuScale(490), TM.MenuScale(65), solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        end

                        CallingCard:SetImage(newCard)
                    end

                    local function FillCardListsAll()
                        local lockedCards = {}
                        for i = 1, #cardArray do
                            if cardArray[i][4] == "default" then
                                local card = vgui.Create("DImageButton", DockDefaultCards)
                                card:SetImage(cardArray[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                DefaultCardList:Add(card)

                                defaultCardsTotal = defaultCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                defaultCardsUnlocked = defaultCardsUnlocked + 1

                                card.OnCursorEntered = function()
                                    newCard = cardArray[i][1]
                                    newCardName = cardArray[i][2]
                                    newCardDesc = cardArray[i][3]
                                    newCardUnlockType = cardArray[i][4]
                                    newCardUnlockValue = cardArray[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() ApplyCard() end
                            elseif cardArray[i][4] == "kills" or cardArray[i][4] == "streak" or cardArray[i][4] == "matches" or cardArray[i][4] == "wins" then
                                statCardsTotal = statCardsTotal + 1

                                if cardArray[i][4] == "kills" and LocalPly:GetNWInt("playerKills") < cardArray[i][5] or cardArray[i][4] == "streak" and LocalPly:GetNWInt("highestKillStreak") < cardArray[i][5] or cardArray[i][4] == "matches" and LocalPly:GetNWInt("matchesPlayed") < cardArray[i][5] or cardArray[i][4] == "wins" and LocalPly:GetNWInt("matchesWon") < cardArray[i][5] then
                                    table.insert(lockedCards, cardArray[i])
                                else
                                    local card = vgui.Create("DImageButton", DockStatCards)
                                    card:SetImage(cardArray[i][1])
                                    card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                    card:SetDepressImage(false)
                                    StatCardList:Add(card)
                                    cardsUnlocked = cardsUnlocked + 1
                                    statCardsUnlocked = statCardsUnlocked + 1

                                    card.OnCursorEntered = function()
                                        newCard = cardArray[i][1]
                                        newCardName = cardArray[i][2]
                                        newCardDesc = cardArray[i][3]
                                        newCardUnlockType = cardArray[i][4]
                                        newCardUnlockValue = cardArray[i][5]
                                        TriggerSound("hover")
                                    end

                                    card.OnCursorExited = function()
                                        newCard = equippedCard
                                        newCardName = equippedCardName
                                        newCardDesc = equippedCardDesc
                                        newCardUnlockType = equippedCardUnlockType
                                        newCardUnlockValue = equippedCardUnlockValue
                                    end

                                    card.DoClick = function() ApplyCard() end
                                end
                            elseif cardArray[i][4] == "headshot" or cardArray[i][4] == "smackdown" or cardArray[i][4] == "clutch" or cardArray[i][4] == "longshot" or cardArray[i][4] == "pointblank" or cardArray[i][4] == "killstreaks" or cardArray[i][4] == "buzzkills" then
                                accoladeCardsTotal = accoladeCardsTotal + 1

                                if cardArray[i][4] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") < cardArray[i][5] or cardArray[i][4] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") < cardArray[i][5] or cardArray[i][4] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") < cardArray[i][5] or cardArray[i][4] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") < cardArray[i][5] or cardArray[i][4] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") < cardArray[i][5] or cardArray[i][4] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") < cardArray[i][5] or cardArray[i][4] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") < cardArray[i][5] then
                                    table.insert(lockedCards, cardArray[i])
                                else
                                    local card = vgui.Create("DImageButton", DockAccoladeCards)
                                    card:SetImage(cardArray[i][1])
                                    card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                    card:SetDepressImage(false)
                                    AccoladeCardList:Add(card)
                                    cardsUnlocked = cardsUnlocked + 1
                                    accoladeCardsUnlocked = accoladeCardsUnlocked + 1

                                    card.OnCursorEntered = function()
                                        newCard = cardArray[i][1]
                                        newCardName = cardArray[i][2]
                                        newCardDesc = cardArray[i][3]
                                        newCardUnlockType = cardArray[i][4]
                                        newCardUnlockValue = cardArray[i][5]
                                        TriggerSound("hover")
                                    end

                                    card.OnCursorExited = function()
                                        newCard = equippedCard
                                        newCardName = equippedCardName
                                        newCardDesc = equippedCardDesc
                                        newCardUnlockType = equippedCardUnlockType
                                        newCardUnlockValue = equippedCardUnlockValue
                                    end

                                    card.DoClick = function() ApplyCard() end
                                end
                            elseif cardArray[i][4] == "color" then
                                local card = vgui.Create("DImageButton", DockColorCards)
                                card:SetImage(cardArray[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                ColorCardList:Add(card)

                                colorCardsTotal = colorCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                colorCardsUnlocked = colorCardsUnlocked + 1

                                card.OnCursorEntered = function()
                                    newCard = cardArray[i][1]
                                    newCardName = cardArray[i][2]
                                    newCardDesc = cardArray[i][3]
                                    newCardUnlockType = cardArray[i][4]
                                    newCardUnlockValue = cardArray[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() ApplyCard() end
                            elseif cardArray[i][4] == "pride" then
                                local card = vgui.Create("DImageButton", DockPrideCards)
                                card:SetImage(cardArray[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                PrideCardList:Add(card)

                                prideCardsTotal = prideCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                prideCardsUnlocked = prideCardsUnlocked + 1

                                card.OnCursorEntered = function()
                                    newCard = cardArray[i][1]
                                    newCardName = cardArray[i][2]
                                    newCardDesc = cardArray[i][3]
                                    newCardUnlockType = cardArray[i][4]
                                    newCardUnlockValue = cardArray[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() ApplyCard() end
                            elseif cardArray[i][4] == "level" then
                                levelCardsTotal = levelCardsTotal + 1

                                if cardArray[i][4] == "level" and playerTotalLevel < cardArray[i][5] then
                                    table.insert(lockedCards, cardArray[i])
                                else
                                    local card = vgui.Create("DImageButton", DockLevelCards)
                                    card:SetImage(cardArray[i][1])
                                    card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                    card:SetDepressImage(false)
                                    LevelCardList:Add(card)
                                    cardsUnlocked = cardsUnlocked + 1
                                    levelCardsUnlocked = levelCardsUnlocked + 1

                                    card.OnCursorEntered = function()
                                        newCard = cardArray[i][1]
                                        newCardName = cardArray[i][2]
                                        newCardDesc = cardArray[i][3]
                                        newCardUnlockType = cardArray[i][4]
                                        newCardUnlockValue = cardArray[i][5]
                                        TriggerSound("hover")
                                    end

                                    card.OnCursorExited = function()
                                        newCard = equippedCard
                                        newCardName = equippedCardName
                                        newCardDesc = equippedCardDesc
                                        newCardUnlockType = equippedCardUnlockType
                                        newCardUnlockValue = equippedCardUnlockValue
                                    end

                                    card.DoClick = function() ApplyCard() end
                                end
                            elseif cardArray[i][4] == "mastery" then
                                masteryCardsTotal = masteryCardsTotal + 1

                                if cardArray[i][4] == "mastery" and LocalPly:GetNWInt("killsWith_" .. cardArray[i][5]) < 50 then
                                    table.insert(lockedCards, cardArray[i])
                                else
                                    local card = vgui.Create("DImageButton", DockMasteryCards)
                                    card:SetImage(cardArray[i][1])
                                    card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                    card:SetDepressImage(false)
                                    MasteryCardList:Add(card)
                                    cardsUnlocked = cardsUnlocked + 1
                                    masteryCardsUnlocked = masteryCardsUnlocked + 1

                                    card.OnCursorEntered = function()
                                        newCard = cardArray[i][1]
                                        newCardName = cardArray[i][2]
                                        newCardDesc = cardArray[i][3]
                                        newCardUnlockType = cardArray[i][4]
                                        newCardUnlockValue = cardArray[i][5]
                                        TriggerSound("hover")
                                    end

                                    card.OnCursorExited = function()
                                        newCard = equippedCard
                                        newCardName = equippedCardName
                                        newCardDesc = equippedCardDesc
                                        newCardUnlockType = equippedCardUnlockType
                                        newCardUnlockValue = equippedCardUnlockValue
                                    end

                                    card.DoClick = function() ApplyCard() end
                                end
                            end
                        end

                        for i = 1, #lockedCards do
                            if lockedCards[i][4] == "kills" or lockedCards[i][4] == "streak" or lockedCards[i][4] == "matches" or lockedCards[i][4] == "wins" then
                                local card = vgui.Create("DImageButton", DockStatCards)
                                card:SetImage(lockedCards[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                card:SetColor(Color(100, 100, 100, 150))
                                card.Paint = function(self, w, h)
                                    surface.SetDrawColor(35, 35, 35, 255)
                                    surface.DrawRect(0, h - TM.MenuScale(5), TM.MenuScale(240), TM.MenuScale(5))

                                    surface.SetDrawColor(255, 255, 0, 100)
                                    if lockedCards[i][4] == "kills" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("playerKills") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) elseif lockedCards[i][4] == "streak" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("highestKillStreak") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) elseif lockedCards[i][4] == "matches" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("matchesPlayed") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) elseif lockedCards[i][4] == "wins" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("matchesWon") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) end
                                end
                                local lockIndicator = vgui.Create("DImage", card)
                                lockIndicator:SetImage("icons/lockicon.png")
                                lockIndicator:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                                lockIndicator:Center()
                                StatCardList:Add(card)

                                card.OnCursorEntered = function()
                                    newCard = lockedCards[i][1]
                                    newCardName = lockedCards[i][2]
                                    newCardDesc = lockedCards[i][3]
                                    newCardUnlockType = lockedCards[i][4]
                                    newCardUnlockValue = lockedCards[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() surface.PlaySound("tmui/warning.wav") end
                            elseif lockedCards[i][4] == "headshot" or lockedCards[i][4] == "smackdown" or lockedCards[i][4] == "clutch" or lockedCards[i][4] == "longshot" or lockedCards[i][4] == "pointblank" or lockedCards[i][4] == "killstreaks" or lockedCards[i][4] == "buzzkills" then
                                local card = vgui.Create("DImageButton", DockAccoladeCards)
                                card:SetImage(lockedCards[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                card:SetColor(Color(100, 100, 100, 150))
                                card.Paint = function(self, w, h)
                                    surface.SetDrawColor(35, 35, 35, 255)
                                    surface.DrawRect(0, h - TM.MenuScale(5), TM.MenuScale(240), TM.MenuScale(5))

                                    surface.SetDrawColor(255, 255, 0, 100)
                                    if lockedCards[i][4] == "headshot" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("playerAccoladeHeadshot") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) elseif lockedCards[i][4] == "smackdown" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("playerAccoladeSmackdown") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) elseif lockedCards[i][4] == "clutch" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("playerAccoladeClutch") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) elseif lockedCards[i][4] == "longshot" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("playerAccoladeLongshot") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) elseif lockedCards[i][4] == "pointblank" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("playerAccoladePointblank") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) elseif lockedCards[i][4] == "killstreaks" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("playerAccoladeOnStreak") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) elseif lockedCards[i][4] == "buzzkills" then surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("playerAccoladeBuzzkill") / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5)) end
                                end
                                local lockIndicator = vgui.Create("DImage", card)
                                lockIndicator:SetImage("icons/lockicon.png")
                                lockIndicator:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                                lockIndicator:Center()
                                AccoladeCardList:Add(card)

                                card.OnCursorEntered = function()
                                    newCard = lockedCards[i][1]
                                    newCardName = lockedCards[i][2]
                                    newCardDesc = lockedCards[i][3]
                                    newCardUnlockType = lockedCards[i][4]
                                    newCardUnlockValue = lockedCards[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() surface.PlaySound("tmui/warning.wav") end
                            elseif lockedCards[i][4] == "level" then
                                local card = vgui.Create("DImageButton", DockLevelCards)
                                card:SetImage(lockedCards[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                card:SetColor(Color(100, 100, 100, 150))
                                card.Paint = function(self, w, h)
                                    surface.SetDrawColor(35, 35, 35, 255)
                                    surface.DrawRect(0, h - TM.MenuScale(5), TM.MenuScale(240), TM.MenuScale(5))

                                    surface.SetDrawColor(255, 255, 0, 100)
                                    surface.DrawRect(0, h - TM.MenuScale(5), (playerTotalLevel / lockedCards[i][5]) * TM.MenuScale(240), TM.MenuScale(5))
                                end
                                local lockIndicator = vgui.Create("DImage", card)
                                lockIndicator:SetImage("icons/lockicon.png")
                                lockIndicator:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                                lockIndicator:Center()
                                LevelCardList:Add(card)

                                card.OnCursorEntered = function()
                                    newCard = lockedCards[i][1]
                                    newCardName = lockedCards[i][2]
                                    newCardDesc = lockedCards[i][3]
                                    newCardUnlockType = lockedCards[i][4]
                                    newCardUnlockValue = lockedCards[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() surface.PlaySound("tmui/warning.wav") end
                            elseif lockedCards[i][4] == "mastery" then
                                local card = vgui.Create("DImageButton", DockMasteryCards)
                                card:SetImage(lockedCards[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                card:SetColor(Color(100, 100, 100, 150))
                                card.Paint = function(self, w, h)
                                    surface.SetDrawColor(35, 35, 35, 255)
                                    surface.DrawRect(0, h - TM.MenuScale(5), TM.MenuScale(240), TM.MenuScale(5))

                                    surface.SetDrawColor(255, 255, 0, 100)
                                    surface.DrawRect(0, h - TM.MenuScale(5), (LocalPly:GetNWInt("killsWith_" .. lockedCards[i][5]) / TM.MenuScale(50)) * TM.MenuScale(240), TM.MenuScale(5))
                                end
                                local lockIndicator = vgui.Create("DImage", card)
                                lockIndicator:SetImage("icons/lockicon.png")
                                lockIndicator:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                                lockIndicator:Center()
                                MasteryCardList:Add(card)

                                card.OnCursorEntered = function()
                                    newCard = lockedCards[i][1]
                                    newCardName = lockedCards[i][2]
                                    newCardDesc = lockedCards[i][3]
                                    newCardUnlockType = lockedCards[i][4]
                                    newCardUnlockValue = lockedCards[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() surface.PlaySound("tmui/warning.wav") end
                            end
                        end
                    end

                    local function FillCardListsUnlocked()
                        for i = 1, #cardArray do
                            if cardArray[i][4] == "default" then
                                local card = vgui.Create("DImageButton", DockDefaultCards)
                                card:SetImage(cardArray[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                DefaultCardList:Add(card)

                                defaultCardsTotal = defaultCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                defaultCardsUnlocked = defaultCardsUnlocked + 1

                                card.OnCursorEntered = function()
                                    newCard = cardArray[i][1]
                                    newCardName = cardArray[i][2]
                                    newCardDesc = cardArray[i][3]
                                    newCardUnlockType = cardArray[i][4]
                                    newCardUnlockValue = cardArray[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() ApplyCard() end
                            elseif cardArray[i][4] == "kills" or cardArray[i][4] == "streak" or cardArray[i][4] == "matches" or cardArray[i][4] == "wins" then
                                statCardsTotal = statCardsTotal + 1
                                if cardArray[i][4] == "kills" and LocalPly:GetNWInt("playerKills") >= cardArray[i][5] or cardArray[i][4] == "streak" and LocalPly:GetNWInt("highestKillStreak") >= cardArray[i][5] or cardArray[i][4] == "matches" and LocalPly:GetNWInt("matchesPlayed") >= cardArray[i][5] or cardArray[i][4] == "wins" and LocalPly:GetNWInt("matchesWon") >= cardArray[i][5] then
                                    local card = vgui.Create("DImageButton", DockStatCards)
                                    card:SetImage(cardArray[i][1])
                                    card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                    card:SetDepressImage(false)
                                    StatCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    statCardsUnlocked = statCardsUnlocked + 1

                                    card.OnCursorEntered = function()
                                        newCard = cardArray[i][1]
                                        newCardName = cardArray[i][2]
                                        newCardDesc = cardArray[i][3]
                                        newCardUnlockType = cardArray[i][4]
                                        newCardUnlockValue = cardArray[i][5]
                                        TriggerSound("hover")
                                    end

                                    card.OnCursorExited = function()
                                        newCard = equippedCard
                                        newCardName = equippedCardName
                                        newCardDesc = equippedCardDesc
                                        newCardUnlockType = equippedCardUnlockType
                                        newCardUnlockValue = equippedCardUnlockValue
                                    end

                                    card.DoClick = function() ApplyCard() end
                                end
                            elseif cardArray[i][4] == "headshot" or cardArray[i][4] == "smackdown" or cardArray[i][4] == "clutch" or cardArray[i][4] == "longshot" or cardArray[i][4] == "pointblank" or cardArray[i][4] == "killstreaks" or cardArray[i][4] == "buzzkills" then
                                accoladeCardsTotal = accoladeCardsTotal + 1
                                if cardArray[i][4] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") >= cardArray[i][5] or cardArray[i][4] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") >= cardArray[i][5] or cardArray[i][4] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") >= cardArray[i][5] or cardArray[i][4] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") >= cardArray[i][5] or cardArray[i][4] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") >= cardArray[i][5] or cardArray[i][4] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") >= cardArray[i][5] or cardArray[i][4] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") >= cardArray[i][5] then
                                    local card = vgui.Create("DImageButton", DockAccoladeCards)
                                    card:SetImage(cardArray[i][1])
                                    card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                    card:SetDepressImage(false)
                                    AccoladeCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    accoladeCardsUnlocked = accoladeCardsUnlocked + 1

                                    card.OnCursorEntered = function()
                                        newCard = cardArray[i][1]
                                        newCardName = cardArray[i][2]
                                        newCardDesc = cardArray[i][3]
                                        newCardUnlockType = cardArray[i][4]
                                        newCardUnlockValue = cardArray[i][5]
                                        TriggerSound("hover")
                                    end

                                    card.OnCursorExited = function()
                                        newCard = equippedCard
                                        newCardName = equippedCardName
                                        newCardDesc = equippedCardDesc
                                        newCardUnlockType = equippedCardUnlockType
                                        newCardUnlockValue = equippedCardUnlockValue
                                    end

                                    card.DoClick = function() ApplyCard() end
                                end
                            elseif cardArray[i][4] == "color" then
                                local card = vgui.Create("DImageButton", DockColorCards)
                                card:SetImage(cardArray[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                ColorCardList:Add(card)

                                colorCardsTotal = colorCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                colorCardsUnlocked = colorCardsUnlocked + 1

                                card.OnCursorEntered = function()
                                    newCard = cardArray[i][1]
                                    newCardName = cardArray[i][2]
                                    newCardDesc = cardArray[i][3]
                                    newCardUnlockType = cardArray[i][4]
                                    newCardUnlockValue = cardArray[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() ApplyCard() end
                            elseif cardArray[i][4] == "pride" then
                                local card = vgui.Create("DImageButton", DockPrideCards)
                                card:SetImage(cardArray[i][1])
                                card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                card:SetDepressImage(false)
                                PrideCardList:Add(card)

                                prideCardsTotal = prideCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                prideCardsUnlocked = prideCardsUnlocked + 1

                                card.OnCursorEntered = function()
                                    newCard = cardArray[i][1]
                                    newCardName = cardArray[i][2]
                                    newCardDesc = cardArray[i][3]
                                    newCardUnlockType = cardArray[i][4]
                                    newCardUnlockValue = cardArray[i][5]
                                    TriggerSound("hover")
                                end

                                card.OnCursorExited = function()
                                    newCard = equippedCard
                                    newCardName = equippedCardName
                                    newCardDesc = equippedCardDesc
                                    newCardUnlockType = equippedCardUnlockType
                                    newCardUnlockValue = equippedCardUnlockValue
                                end

                                card.DoClick = function() ApplyCard() end
                            elseif cardArray[i][4] == "level" then
                                levelCardsTotal = levelCardsTotal + 1
                                if cardArray[i][4] == "level" and playerTotalLevel >= cardArray[i][5] then
                                    local card = vgui.Create("DImageButton", DockLevelCards)
                                    card:SetImage(cardArray[i][1])
                                    card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                    card:SetDepressImage(false)
                                    LevelCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    levelCardsUnlocked = levelCardsUnlocked + 1

                                    card.OnCursorEntered = function()
                                        newCard = cardArray[i][1]
                                        newCardName = cardArray[i][2]
                                        newCardDesc = cardArray[i][3]
                                        newCardUnlockType = cardArray[i][4]
                                        newCardUnlockValue = cardArray[i][5]
                                        TriggerSound("hover")
                                    end

                                    card.OnCursorExited = function()
                                        newCard = equippedCard
                                        newCardName = equippedCardName
                                        newCardDesc = equippedCardDesc
                                        newCardUnlockType = equippedCardUnlockType
                                        newCardUnlockValue = equippedCardUnlockValue
                                    end

                                    card.DoClick = function() ApplyCard() end
                                end
                            elseif cardArray[i][4] == "mastery" then
                                masteryCardsTotal = masteryCardsTotal + 1
                                if cardArray[i][4] == "mastery" and LocalPly:GetNWInt("killsWith_" .. cardArray[i][5]) >= 50 then
                                    local card = vgui.Create("DImageButton", DockMasteryCards)
                                    card:SetImage(cardArray[i][1])
                                    card:SetSize(TM.MenuScale(240), TM.MenuScale(80))
                                    card:SetDepressImage(false)
                                    MasteryCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    masteryCardsUnlocked = masteryCardsUnlocked + 1

                                    card.OnCursorEntered = function()
                                        newCard = cardArray[i][1]
                                        newCardName = cardArray[i][2]
                                        newCardDesc = cardArray[i][3]
                                        newCardUnlockType = cardArray[i][4]
                                        newCardUnlockValue = cardArray[i][5]
                                        TriggerSound("hover")
                                    end

                                    card.OnCursorExited = function()
                                        newCard = equippedCard
                                        newCardName = equippedCardName
                                        newCardDesc = equippedCardDesc
                                        newCardUnlockType = equippedCardUnlockType
                                        newCardUnlockValue = equippedCardUnlockValue
                                    end

                                    card.DoClick = function() ApplyCard() end
                                end
                            end
                        end
                    end

                    FillCardListsAll()

                    TextDefault.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("DEFAULT", "OptionsHeader", w / 2, TM.MenuScale(-5), white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(defaultCardsUnlocked .. " / " .. defaultCardsUnlocked, "MainMenuDescription", w / 2, TM.MenuScale(50), solidGreen, TEXT_ALIGN_CENTER)
                    end

                    TextStats.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("STATS", "OptionsHeader", w / 2, TM.MenuScale(-5), white, TEXT_ALIGN_CENTER)

                        if statCardsUnlocked == statCardsTotal then
                            draw.SimpleText(statCardsUnlocked .. " / " .. statCardsTotal, "Health", w / 2, TM.MenuScale(50), solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(statCardsUnlocked .. " / " .. statCardsTotal, "Health", w / 2, TM.MenuScale(50), white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("ACCOLADES", "OptionsHeader", w / 2, TM.MenuScale(-5), white, TEXT_ALIGN_CENTER)

                        if accoladeCardsUnlocked == accoladeCardsTotal then
                            draw.SimpleText(accoladeCardsUnlocked .. " / " .. accoladeCardsTotal, "Health", w / 2, TM.MenuScale(50), solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(accoladeCardsUnlocked .. " / " .. accoladeCardsTotal, "Health", w / 2, TM.MenuScale(50), white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextLevel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("LEVELING", "OptionsHeader", w / 2, TM.MenuScale(-5), white, TEXT_ALIGN_CENTER)

                        if levelCardsUnlocked == levelCardsTotal then
                            draw.SimpleText(levelCardsUnlocked .. " / " .. levelCardsTotal, "Health", w / 2, TM.MenuScale(50), solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(levelCardsUnlocked .. " / " .. levelCardsTotal, "Health", w / 2, TM.MenuScale(50), white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextMastery.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("MASTERY", "OptionsHeader", w / 2, TM.MenuScale(-5), white, TEXT_ALIGN_CENTER)

                        if masteryCardsUnlocked == masteryCardsTotal then
                            draw.SimpleText(masteryCardsUnlocked .. " / " .. masteryCardsTotal, "Health", w / 2, TM.MenuScale(50), solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(masteryCardsUnlocked .. " / " .. masteryCardsTotal, "Health", w / 2, TM.MenuScale(50), white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextColor.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("COLORS", "OptionsHeader", w / 2, TM.MenuScale(-5), white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(colorCardsUnlocked .. " / " .. colorCardsTotal, "Health", w / 2, TM.MenuScale(50), solidGreen, TEXT_ALIGN_CENTER)
                    end

                    TextPride.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("PRIDE", "OptionsHeader", w / 2, TM.MenuScale(-5), white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(prideCardsUnlocked .. " / " .. prideCardsTotal, "Health", w / 2, TM.MenuScale(50), solidGreen, TEXT_ALIGN_CENTER)
                    end

                    DockDefaultCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockStatCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockAccoladeCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockLevelCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockMasteryCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockColorCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockPrideCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    function HideLockedCards:OnChange(bVal)
                        if (bVal) then
                            DefaultCardList:Clear()
                            StatCardList:Clear()
                            AccoladeCardList:Clear()
                            LevelCardList:Clear()
                            MasteryCardList:Clear()
                            ColorCardList:Clear()
                            PrideCardList:Clear()
                            cardsUnlocked = 0
                            defaultCardsTotal = 0
                            defaultCardsUnlocked = 0
                            statCardsTotal = 0
                            statCardsUnlocked = 0
                            accoladeCardsTotal = 0
                            accoladeCardsUnlocked = 0
                            levelCardsTotal = 0
                            levelCardsUnlocked = 0
                            masteryCardsTotal = 0
                            masteryCardsUnlocked = 0
                            colorCardsTotal = 0
                            colorCardsUnlocked = 0
                            prideCardsTotal = 0
                            prideCardsUnlocked = 0
                            FillCardListsUnlocked()
                            DockDefaultCards:SetSize(0, TM.MenuScale(340))
                            DockStatCards:SetSize(0, (statCardsUnlocked * TM.MenuScale(28.33)) + TM.MenuScale(28.33))
                            DockAccoladeCards:SetSize(0, (accoladeCardsUnlocked * TM.MenuScale(28.33)) + TM.MenuScale(28.33))
                            DockLevelCards:SetSize(0, (levelCardsUnlocked * TM.MenuScale(28.33)) + TM.MenuScale(28.33))
                            DockMasteryCards:SetSize(0, (masteryCardsUnlocked * TM.MenuScale(28.33)) + TM.MenuScale(28.33))
                            DockColorCards:SetSize(0, TM.MenuScale(340))
                            DockPrideCards:SetSize(0, TM.MenuScale(1785))
                        else
                            DefaultCardList:Clear()
                            StatCardList:Clear()
                            AccoladeCardList:Clear()
                            LevelCardList:Clear()
                            MasteryCardList:Clear()
                            ColorCardList:Clear()
                            PrideCardList:Clear()
                            cardsUnlocked = 0
                            defaultCardsTotal = 0
                            defaultCardsUnlocked = 0
                            statCardsTotal = 0
                            statCardsUnlocked = 0
                            accoladeCardsTotal = 0
                            accoladeCardsUnlocked = 0
                            levelCardsTotal = 0
                            levelCardsUnlocked = 0
                            masteryCardsTotal = 0
                            masteryCardsUnlocked = 0
                            colorCardsTotal = 0
                            colorCardsUnlocked = 0
                            prideCardsTotal = 0
                            prideCardsUnlocked = 0
                            FillCardListsAll()
                            DockDefaultCards:SetSize(0, TM.MenuScale(340))
                            DockStatCards:SetSize(0, TM.MenuScale(680))
                            DockAccoladeCards:SetSize(0, TM.MenuScale(850))
                            DockLevelCards:SetSize(0, TM.MenuScale(1700))
                            DockMasteryCards:SetSize(0, TM.MenuScale(4345))
                            DockColorCards:SetSize(0, TM.MenuScale(340))
                            DockPrideCards:SetSize(0, TM.MenuScale(1785))
                        end
                    end

                    local CardIcon = vgui.Create("DImage", CardQuickjumpHolder)
                    CardIcon:SetPos(TM.MenuScale(12), TM.MenuScale(12))
                    CardIcon:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                    CardIcon:SetImage("icons/cardicon.png")

                    local DefaultJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    DefaultJump:SetPos(TM.MenuScale(4), TM.MenuScale(100))
                    DefaultJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    DefaultJump:SetImage("icons/unlockedicon.png")
                    DefaultJump:SetTooltip("Default")
                    DefaultJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextDefault)
                    end

                    local LevelJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    LevelJump:SetPos(TM.MenuScale(4), TM.MenuScale(152))
                    LevelJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    LevelJump:SetImage("icons/performanceicon.png")
                    LevelJump:SetTooltip("Leveling")
                    LevelJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextLevel)
                    end

                    local StatsJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    StatsJump:SetPos(TM.MenuScale(4), TM.MenuScale(204))
                    StatsJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    StatsJump:SetImage("icons/uikillicon.png")
                    StatsJump:SetTooltip("Stats")
                    StatsJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextStats)
                    end

                    local AccoladeJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    AccoladeJump:SetPos(TM.MenuScale(4), TM.MenuScale(256))
                    AccoladeJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    AccoladeJump:SetImage("icons/accoladeicon.png")
                    AccoladeJump:SetTooltip("Accolades")
                    AccoladeJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextAccolade)
                    end

                    local WeaponJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    WeaponJump:SetPos(TM.MenuScale(4), TM.MenuScale(308))
                    WeaponJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    WeaponJump:SetImage("icons/weaponicon.png")
                    WeaponJump:SetTooltip("Mastery")
                    WeaponJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextMastery)
                    end

                    local ColorJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    ColorJump:SetPos(TM.MenuScale(4), TM.MenuScale(360))
                    ColorJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    ColorJump:SetImage("icons/paletteicon.png")
                    ColorJump:SetTooltip("Colors")
                    ColorJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextColor)
                    end

                    local PrideJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    PrideJump:SetPos(TM.MenuScale(4), TM.MenuScale(412))
                    PrideJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    PrideJump:SetImage("icons/hearticon.png")
                    PrideJump:SetTooltip("Pride")
                    PrideJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextPride)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", CardQuickjumpHolder)
                    BackButtonSlideout:SetPos(TM.MenuScale(12), scrH - TM.MenuScale(44))
                    BackButtonSlideout:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
                        TriggerSound("back")
                        CardPanel:AlphaTo(0, 0.05, 0, function() CardPanel:Hide() end)
                        CardPreviewPanel:AlphaTo(0, 0.05, 0, function() CardPreviewPanel:Hide() end)
                        CardSlideoutPanel:AlphaTo(0, 0.05, 0, function() CardSlideoutPanel:Hide() end)
                        MainPanel:Show()
                        MainPanel:AlphaTo(255, 0.05, 0.025)
                    end
                end
            end

            CustomizeModelButton.DoClick = function()
                if IsValid(ModelPanel) then return end
                TriggerSound("click")
                MainPanel:AlphaTo(0, 0.05, 0, function() MainPanel:Hide() end)

                local currentModel = LocalPly:GetNWString("chosenPlayermodel")

                if !IsValid(ModelPanel) then
                    local ModelPanel = vgui.Create("DPanel", MainMenu)
                    ModelPanel:SetSize(TM.MenuScale(630), scrH)
                    ModelPanel:SetPos(TM.MenuScale(56), 0)
                    ModelPanel:SetAlpha(0)
                    ModelPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local ModelSlideoutPanel = vgui.Create("DPanel", MainMenu)
                    ModelSlideoutPanel:SetSize(TM.MenuScale(56), scrH)
                    ModelSlideoutPanel:SetPos(0, 0)
                    ModelSlideoutPanel:SetAlpha(0)
                    ModelSlideoutPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local equippedModel
                    local equippedModelName
                    local equippedModelUnlockType
                    local equippedModelUnlockValue

                    local newModel
                    local newModelName
                    local newModelUnlockType
                    local newModelUnlockValue

                    local totalModels = table.Count(modelArray)
                    local modelsUnlocked = 0

                    local defaultModelsTotal = 0
                    local defaultModelsUnlocked = 0

                    local statModelsTotal = 0
                    local statModelsUnlocked = 0

                    local accoladeModelsTotal = 0
                    local accoladeModelsUnlocked = 0

                    local previewRed = Color(255, 0, 0, 5)
                    local previewGreen = Color(0, 255, 0, 5)

                    -- checking for the players currently equipped model
                    for i = 1, #modelArray do
                        if modelArray[i][1] == currentModel then
                            equippedModel = modelArray[i][1]
                            equippedModelName = modelArray[i][2]
                            equippedModelUnlockType = modelArray[i][3]
                            equippedModelUnlockValue = modelArray[i][4]

                            newModel = modelArray[i][1]
                            newModelName = modelArray[i][2]
                            newModelUnlockType = modelArray[i][3]
                            newModelUnlockValue = modelArray[i][4]
                        end
                    end

                    local ModelQuickjumpHolder = vgui.Create("DPanel", ModelSlideoutPanel)
                    ModelQuickjumpHolder:Dock(TOP)
                    ModelQuickjumpHolder:SetSize(0, scrH)

                    ModelQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                        draw.RoundedBox(0, TM.MenuScale(4), scrH - TM.MenuScale(52), TM.MenuScale(48), TM.MenuScale(48), transparentRed)
                    end

                    ModelPanel:AlphaTo(255, 0.05, 0.025)
                    ModelSlideoutPanel:AlphaTo(255, 0.05, 0.025)

                    local CustomizeScroller = vgui.Create("DScrollPanel", ModelPanel)
                    CustomizeScroller:Dock(FILL)

                    local sbar = CustomizeScroller:GetVBar()
                    sbar:SetHideButtons(true)
                    sbar:SetSize(TM.MenuScale(15), TM.MenuScale(15))
                    function sbar:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(0, TM.MenuScale(5), TM.MenuScale(8), TM.MenuScale(5), h - TM.MenuScale(16), Color(255, 255, 255, 175))
                    end

                    local CustomizeTextHolder = vgui.Create("DPanel", ModelPanel)
                    CustomizeTextHolder:Dock(TOP)
                    CustomizeTextHolder:SetSize(0, TM.MenuScale(160))

                    CustomizeTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("MODELS", "AmmoCountSmall", w / 2, TM.MenuScale(5), white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(modelsUnlocked .. " / " .. totalModels .. " UNLOCKED", "MainMenuDescription", w / 2, TM.MenuScale(85), white, TEXT_ALIGN_CENTER)
                        draw.SimpleText("hide locked playermodels", "StreakText", w / 2 + TM.MenuScale(20), TM.MenuScale(120), white, TEXT_ALIGN_CENTER)
                    end

                    local HideLockedModels = CustomizeTextHolder:Add("DCheckBox")
                    HideLockedModels:SetPos(TM.MenuScale(205), TM.MenuScale(122.5))
                    HideLockedModels:SetSize(TM.MenuScale(20), TM.MenuScale(20))
                    function HideLockedModels:OnChange() TriggerSound("click") end

                    -- default models
                    local TextDefault = vgui.Create("DPanel", CustomizeScroller)
                    TextDefault:Dock(TOP)
                    TextDefault:SetSize(0, TM.MenuScale(90))

                    local DockModels = vgui.Create("DPanel", CustomizeScroller)
                    DockModels:Dock(TOP)
                    DockModels:SetSize(0, TM.MenuScale(310))

                    -- stats models
                    local TextStats = vgui.Create("DPanel", CustomizeScroller)
                    TextStats:Dock(TOP)
                    TextStats:SetSize(0, TM.MenuScale(90))

                    local DockModelsStats = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsStats:Dock(TOP)
                    DockModelsStats:SetSize(0, TM.MenuScale(1240))

                    -- accolade models
                    local TextAccolade = vgui.Create("DPanel", CustomizeScroller)
                    TextAccolade:Dock(TOP)
                    TextAccolade:SetSize(0, TM.MenuScale(90))

                    local DockModelsAccolade = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsAccolade:Dock(TOP)
                    DockModelsAccolade:SetSize(0, TM.MenuScale(1080))

                    -- creating playermodel lists
                    local DefaultModelList = vgui.Create("DIconLayout", DockModels)
                    DefaultModelList:Dock(TOP)
                    DefaultModelList:SetSpaceY(TM.MenuScale(5))
                    DefaultModelList:SetSpaceX(TM.MenuScale(5))

                    DefaultModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local StatModelList = vgui.Create("DIconLayout", DockModelsStats)
                    StatModelList:Dock(TOP)
                    StatModelList:SetSpaceY(TM.MenuScale(5))
                    StatModelList:SetSpaceX(TM.MenuScale(5))

                    StatModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local AccoladeModelList = vgui.Create("DIconLayout", DockModelsAccolade)
                    AccoladeModelList:Dock(TOP)
                    AccoladeModelList:SetSpaceY(TM.MenuScale(5))
                    AccoladeModelList:SetSpaceX(TM.MenuScale(5))

                    AccoladeModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local ModelPreviewPanel = vgui.Create("DPanel", MainMenu)
                    ModelPreviewPanel:SetSize(TM.MenuScale(1450), scrH)
                    ModelPreviewPanel:SetPos(TM.MenuScale(686), 0)
                    ModelPreviewPanel:SetAlpha(0)
                    ModelPreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    ModelPreviewPanel:AlphaTo(255, 0.05, 0.025)

                    local SelectedModelHolder = vgui.Create("DPanel", ModelPreviewPanel)
                    SelectedModelHolder:SetSize(TM.MenuScale(600), TM.MenuScale(2000))
                    SelectedModelHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local SelectedModelDisplay
                    local function PreviewNewModel(model)
                        if IsValid(SelectedModelDisplay) then SelectedModelDisplay:Remove() end
                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                        SelectedModelDisplay:SetAlpha(0)
                        SelectedModelDisplay:SetSize(TM.MenuScale(1450), scrH)
                        SelectedModelDisplay:SetPos(TM.MenuScale(-525), 0)
                        SelectedModelDisplay:SetMouseInputEnabled(true)
                        SelectedModelDisplay:SetDirectionalLight(BOX_RIGHT, Color(255, 160, 80, 255))
                        SelectedModelDisplay:SetDirectionalLight(BOX_LEFT, Color(80, 160, 255, 255))
                        SelectedModelDisplay:SetAnimated(true)
                        SelectedModelDisplay:SetModel(model)
                        SelectedModelDisplay.Entity:SetAngles(Angle(0, 20, 0))
                        SelectedModelDisplay.Entity:SetPos(Vector(0, 0, -5))

                        function SelectedModelDisplay:LayoutEntity(Entity)
                            if !IsValid(Entity) then return end
                            SelectedModelDisplay:RunAnimation()
                        end

                        SelectedModelDisplay:AlphaTo(255, 0.05, 0.025)
                    end

                    PreviewNewModel(newModel)

                    local function ApplyModel()
                        surface.PlaySound("tmui/uisuccess.wav")
                        net.Start("PlayerModelChange")
                        net.WriteString(newModel)
                        net.SendToServer()
                        ModelPanel:AlphaTo(0, 0.05, 0, function() ModelPanel:Hide() end)
                        ModelPreviewPanel:AlphaTo(0, 0.05, 0, function() ModelPreviewPanel:Hide() end)
                        ModelSlideoutPanel:AlphaTo(0, 0.05, 0, function() ModelSlideoutPanel:Hide() end)
                        MainPanel:Show()
                        MainPanel:AlphaTo(255, 0.05, 0.025)
                    end

                    local sideH, sideV

                    local function FillModelListsAll()
                        local lockedModels = {}
                        for i = 1, #modelArray do
                            if modelArray[i][3] == "default" then
                                local icon = vgui.Create("SpawnIcon", DockModels)
                                icon:SetModel(modelArray[i][1])
                                icon:SetSize(TM.MenuScale(150), TM.MenuScale(150))
                                icon:SetTooltip(nil)
                                DefaultModelList:Add(icon)

                                defaultModelsTotal = defaultModelsTotal + 1
                                modelsUnlocked = modelsUnlocked + 1
                                defaultModelsUnlocked = defaultModelsUnlocked + 1

                                icon.OnCursorEntered = function()
                                    TriggerSound("hover")

                                    newModel = modelArray[i][1]
                                    newModelName = modelArray[i][2]
                                    newModelUnlockType = modelArray[i][3]
                                    newModelUnlockValue = modelArray[i][4]
                                    PreviewNewModel(newModel)

                                    if mouseX <= (ScrW() / 2) then sideH = true else sideH = false end
                                    if mouseY <= (ScrH() / 2) then sideV = true else sideV = false end

                                    surface.SetFont("PlayerNotiName")
                                    local modelNameTextSize = math.max(surface.GetTextSize(string.upper(newModelName)), TM.MenuScale(200))

                                    if IsValid(modelPopOut) then modelPopOut:Remove() end
                                    modelPopOut = vgui.Create("DPanel", MainMenu)
                                    modelPopOut:SetSize(modelNameTextSize + TM.MenuScale(10), TM.MenuScale(70))
                                    UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)
                                    modelPopOut:SetAlpha(0)
                                    modelPopOut:AlphaTo(255, 0.1, 0, function() end)
                                    modelPopOut:SetMouseInputEnabled(false)

                                    modelPopOut.Paint = function(s, w, h)

                                        if !IsValid(s) then return end

                                        BlurPanel(s, 3)

                                        -- panel position follows mouse position
                                        UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)

                                        surface.SetDrawColor(Color(0, 0, 0, 205))
                                        surface.DrawRect(0, 0, w, h)

                                        surface.SetDrawColor(previewGreen)
                                        surface.DrawRect(0, 0, w, h)

                                        surface.SetDrawColor(Color(255, 255, 255, 155))
                                        surface.DrawRect(0, 0, w, TM.MenuScale(1))
                                        surface.DrawRect(0, h - TM.MenuScale(1), w, TM.MenuScale(1))
                                        surface.DrawRect(0, 0, TM.MenuScale(1), h)
                                        surface.DrawRect(w - TM.MenuScale(1), 0, TM.MenuScale(1), h)

                                        draw.SimpleTextOutlined(string.upper(newModelName), "PlayerNotiName", w / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        draw.SimpleTextOutlined("click to equip", "StreakText", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))

                                    end
                                end

                                icon.OnCursorExited = function()
                                    if IsValid(modelPopOut) then modelPopOut:Remove() end

                                    newModel = equippedModel
                                    newModelName = equippedModelName
                                    newModelUnlockType = equippedModelUnlockType
                                    newModelUnlockValue = equippedModelUnlockValue
                                    PreviewNewModel(equippedModel)
                                end

                                icon.DoClick = function() ApplyModel() end
                            elseif modelArray[i][3] == "kills" or modelArray[i][3] == "streak" or modelArray[i][3] == "matches" or modelArray[i][3] == "wins" then
                                statModelsTotal = statModelsTotal + 1

                                if modelArray[i][3] == "kills" and LocalPly:GetNWInt("playerKills") < modelArray[i][4] or modelArray[i][3] == "streak" and LocalPly:GetNWInt("highestKillStreak") < modelArray[i][4] or modelArray[i][3] == "matches" and LocalPly:GetNWInt("matchesPlayed") < modelArray[i][4] or modelArray[i][3] == "wins" and LocalPly:GetNWInt("matchesWon") < modelArray[i][4] then
                                    table.insert(lockedModels, modelArray[i])
                                else
                                    local icon = vgui.Create("SpawnIcon", DockModelsStats)
                                    icon:SetModel(modelArray[i][1])
                                    icon:SetSize(TM.MenuScale(150), TM.MenuScale(150))
                                    icon:SetTooltip(nil)
                                    StatModelList:Add(icon)
                                    statModelsUnlocked = statModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.OnCursorEntered = function()
                                        TriggerSound("hover")

                                        newModel = modelArray[i][1]
                                        newModelName = modelArray[i][2]
                                        newModelUnlockType = modelArray[i][3]
                                        newModelUnlockValue = modelArray[i][4]
                                        PreviewNewModel(newModel)

                                        if mouseX <= (ScrW() / 2) then sideH = true else sideH = false end
                                        if mouseY <= (ScrH() / 2) then sideV = true else sideV = false end

                                        surface.SetFont("PlayerNotiName")
                                        local modelNameTextSize = math.max(surface.GetTextSize(string.upper(newModelName)), TM.MenuScale(200))

                                        if IsValid(modelPopOut) then modelPopOut:Remove() end
                                        modelPopOut = vgui.Create("DPanel", MainMenu)
                                        modelPopOut:SetSize(modelNameTextSize + TM.MenuScale(10), TM.MenuScale(130))
                                        UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)
                                        modelPopOut:SetAlpha(0)
                                        modelPopOut:AlphaTo(255, 0.1, 0, function() end)
                                        modelPopOut:SetMouseInputEnabled(false)

                                        modelPopOut.Paint = function(s, w, h)

                                            if !IsValid(s) then return end

                                            BlurPanel(s, 3)

                                            -- panel position follows mouse position
                                            UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)

                                            surface.SetDrawColor(Color(0, 0, 0, 205))
                                            surface.DrawRect(0, 0, w, h)

                                            surface.SetDrawColor(previewGreen)
                                            surface.DrawRect(0, 0, w, h)

                                            surface.SetDrawColor(Color(255, 255, 255, 155))
                                            surface.DrawRect(0, 0, w, TM.MenuScale(1))
                                            surface.DrawRect(0, h - TM.MenuScale(1), w, TM.MenuScale(1))
                                            surface.DrawRect(0, 0, TM.MenuScale(1), h)
                                            surface.DrawRect(w - TM.MenuScale(1), 0, TM.MenuScale(1), h)

                                            draw.SimpleTextOutlined(string.upper(newModelName), "PlayerNotiName", w / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))

                                            if newModelUnlockType == "kills" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerKills") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("KILLS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "streak" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("highestKillStreak") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("HIGHEST STREAK", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "matches" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("matchesPlayed") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("MATCHES PLAYED", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "wins" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("matchesWon") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("MATCHES WON", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            end

                                            draw.SimpleTextOutlined("click to equip", "StreakText", w / 2, TM.MenuScale(105), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        end
                                    end

                                    icon.OnCursorExited = function()
                                        if IsValid(modelPopOut) then modelPopOut:Remove() end

                                        newModel = equippedModel
                                        newModelName = equippedModelName
                                        newModelUnlockType = equippedModelUnlockType
                                        newModelUnlockValue = equippedModelUnlockValue
                                        PreviewNewModel(equippedModel)
                                    end

                                    icon.DoClick = function() ApplyModel() end
                                end
                            elseif modelArray[i][3] == "headshot" or modelArray[i][3] == "smackdown" or modelArray[i][3] == "clutch" or modelArray[i][3] == "longshot" or modelArray[i][3] == "pointblank" or modelArray[i][3] == "killstreaks" or modelArray[i][3] == "buzzkills" then
                                accoladeModelsTotal = accoladeModelsTotal + 1

                                if modelArray[i][3] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") < modelArray[i][4] or modelArray[i][3] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") < modelArray[i][4] or modelArray[i][3] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") < modelArray[i][4] or modelArray[i][3] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") < modelArray[i][4] or modelArray[i][3] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") < modelArray[i][4] or modelArray[i][3] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") < modelArray[i][4] or modelArray[i][3] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") < modelArray[i][4] then
                                    table.insert(lockedModels, modelArray[i])
                                else
                                    local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                                    icon:SetModel(modelArray[i][1])
                                    icon:SetSize(TM.MenuScale(150), TM.MenuScale(150))
                                    icon:SetTooltip(nil)
                                    AccoladeModelList:Add(icon)
                                    accoladeModelsUnlocked = accoladeModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.OnCursorEntered = function()
                                        TriggerSound("hover")

                                        newModel = modelArray[i][1]
                                        newModelName = modelArray[i][2]
                                        newModelUnlockType = modelArray[i][3]
                                        newModelUnlockValue = modelArray[i][4]
                                        PreviewNewModel(newModel)

                                        if mouseX <= (ScrW() / 2) then sideH = true else sideH = false end
                                        if mouseY <= (ScrH() / 2) then sideV = true else sideV = false end

                                        surface.SetFont("PlayerNotiName")
                                        local modelNameTextSize = math.max(surface.GetTextSize(string.upper(newModelName)), TM.MenuScale(220))

                                        if IsValid(modelPopOut) then modelPopOut:Remove() end
                                        modelPopOut = vgui.Create("DPanel", MainMenu)
                                        modelPopOut:SetSize(modelNameTextSize + TM.MenuScale(10), TM.MenuScale(130))
                                        UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)
                                        modelPopOut:SetAlpha(0)
                                        modelPopOut:AlphaTo(255, 0.1, 0, function() end)
                                        modelPopOut:SetMouseInputEnabled(false)

                                        modelPopOut.Paint = function(s, w, h)
                                            if !IsValid(s) then return end

                                            BlurPanel(s, 3)

                                            -- panel position follows mouse position
                                            UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)

                                            surface.SetDrawColor(Color(0, 0, 0, 205))
                                            surface.DrawRect(0, 0, w, h)

                                            surface.SetDrawColor(previewGreen)
                                            surface.DrawRect(0, 0, w, h)

                                            surface.SetDrawColor(Color(255, 255, 255, 155))
                                            surface.DrawRect(0, 0, w, TM.MenuScale(1))
                                            surface.DrawRect(0, h - TM.MenuScale(1), w, TM.MenuScale(1))
                                            surface.DrawRect(0, 0, TM.MenuScale(1), h)
                                            surface.DrawRect(w - TM.MenuScale(1), 0, TM.MenuScale(1), h)

                                            draw.SimpleTextOutlined(string.upper(newModelName), "PlayerNotiName", w / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))

                                            if newModelUnlockType == "headshot" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("HEADSHOTS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "smackdown" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("MELEE KILLS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "clutch" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("CLUTCHES", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "longshot" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("LONGSHOTS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "pointblank" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("POINT BLANKS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "killstreaks" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("STREAKS STARTED", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "buzzkills" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("BUZZKILLS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            end

                                            draw.SimpleTextOutlined("click to equip", "StreakText", w / 2, TM.MenuScale(105), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        end
                                    end

                                    icon.OnCursorExited = function()
                                        if IsValid(modelPopOut) then modelPopOut:Remove() end

                                        newModel = equippedModel
                                        newModelName = equippedModelName
                                        newModelUnlockType = equippedModelUnlockType
                                        newModelUnlockValue = equippedModelUnlockValue
                                        PreviewNewModel(equippedModel)
                                    end

                                    icon.DoClick = function() ApplyModel() end
                                end
                            end
                        end

                        for i = 1, #lockedModels do
                            if lockedModels[i][3] == "kills" or lockedModels[i][3] == "streak" or lockedModels[i][3] == "matches" or lockedModels[i][3] == "wins" then
                                local icon = vgui.Create("SpawnIcon", DockModelsStats)
                                icon:SetModel(lockedModels[i][1])
                                icon:SetSize(TM.MenuScale(150), TM.MenuScale(150))
                                icon:SetTooltip(nil)
                                StatModelList:Add(icon)

                                local lockIndicator = vgui.Create("DImage", icon)
                                lockIndicator:SetImage("icons/lockicon.png")
                                lockIndicator:SetSize(TM.MenuScale(96), TM.MenuScale(96))
                                lockIndicator:Center()

                                icon.OnCursorEntered = function()
                                    TriggerSound("hover")

                                    newModel = lockedModels[i][1]
                                    newModelName = lockedModels[i][2]
                                    newModelUnlockType = lockedModels[i][3]
                                    newModelUnlockValue = lockedModels[i][4]
                                    PreviewNewModel(newModel)

                                    if mouseX <= (ScrW() / 2) then sideH = true else sideH = false end
                                    if mouseY <= (ScrH() / 2) then sideV = true else sideV = false end

                                    surface.SetFont("PlayerNotiName")
                                    local modelNameTextSize = math.max(surface.GetTextSize(string.upper(newModelName)), TM.MenuScale(200))

                                    if IsValid(modelPopOut) then modelPopOut:Remove() end
                                    modelPopOut = vgui.Create("DPanel", MainMenu)
                                    modelPopOut:SetSize(modelNameTextSize + TM.MenuScale(10), TM.MenuScale(110))
                                    UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)
                                    modelPopOut:SetAlpha(0)
                                    modelPopOut:AlphaTo(255, 0.1, 0, function() end)
                                    modelPopOut:SetMouseInputEnabled(false)

                                    modelPopOut.Paint = function(s, w, h)
                                        if !IsValid(s) then return end

                                        BlurPanel(s, 3)

                                        -- panel position follows mouse position
                                        UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)

                                        surface.SetDrawColor(Color(0, 0, 0, 205))
                                        surface.DrawRect(0, 0, w, h)

                                        surface.SetDrawColor(previewRed)
                                        surface.DrawRect(0, 0, w, h)

                                        surface.SetDrawColor(Color(255, 255, 255, 155))
                                        surface.DrawRect(0, 0, w, TM.MenuScale(1))
                                        surface.DrawRect(0, h - TM.MenuScale(1), w, TM.MenuScale(1))
                                        surface.DrawRect(0, 0, TM.MenuScale(1), h)
                                        surface.DrawRect(w - TM.MenuScale(1), 0, TM.MenuScale(1), h)

                                        draw.SimpleTextOutlined(string.upper(newModelName), "PlayerNotiName", w / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))

                                        if newModelUnlockType == "kills" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("playerKills") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(255, 0, 0, 15))
                                            draw.SimpleTextOutlined("KILLS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        elseif newModelUnlockType == "streak" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("highestKillStreak") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(255, 0, 0, 15))
                                            draw.SimpleTextOutlined("HIGHEST STREAK", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        elseif newModelUnlockType == "matches" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("matchesPlayed") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(255, 0, 0, 15))
                                            draw.SimpleTextOutlined("MATCHES PLAYED", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        elseif newModelUnlockType == "wins" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("matchesWon") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(255, 0, 0, 15))
                                            draw.SimpleTextOutlined("MATCHES WON", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        end
                                    end
                                end

                                icon.OnCursorExited = function()
                                    if IsValid(modelPopOut) then modelPopOut:Remove() end

                                    newModel = equippedModel
                                    newModelName = equippedModelName
                                    newModelUnlockType = equippedModelUnlockType
                                    newModelUnlockValue = equippedModelUnlockValue
                                    PreviewNewModel(equippedModel)
                                end

                                icon.DoClick = function() surface.PlaySound("tmui/warning.wav") end
                            elseif lockedModels[i][3] == "headshot" or lockedModels[i][3] == "smackdown" or lockedModels[i][3] == "clutch" or lockedModels[i][3] == "longshot" or lockedModels[i][3] == "pointblank" or lockedModels[i][3] == "killstreaks" or lockedModels[i][3] == "buzzkills" then
                                local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                                icon:SetModel(lockedModels[i][1])
                                icon:SetSize(TM.MenuScale(150), TM.MenuScale(150))
                                icon:SetTooltip(nil)
                                AccoladeModelList:Add(icon)

                                local lockIndicator = vgui.Create("DImage", icon)
                                lockIndicator:SetImage("icons/lockicon.png")
                                lockIndicator:SetSize(TM.MenuScale(96), TM.MenuScale(96))
                                lockIndicator:Center()

                                icon.OnCursorEntered = function()
                                    TriggerSound("hover")

                                    newModel = lockedModels[i][1]
                                    newModelName = lockedModels[i][2]
                                    newModelUnlockType = lockedModels[i][3]
                                    newModelUnlockValue = lockedModels[i][4]
                                    PreviewNewModel(newModel)

                                    if mouseX <= (ScrW() / 2) then sideH = true else sideH = false end
                                    if mouseY <= (ScrH() / 2) then sideV = true else sideV = false end

                                    surface.SetFont("PlayerNotiName")
                                    local modelNameTextSize = math.max(surface.GetTextSize(string.upper(newModelName)), TM.MenuScale(220))

                                    if IsValid(modelPopOut) then modelPopOut:Remove() end
                                    modelPopOut = vgui.Create("DPanel", MainMenu)
                                    modelPopOut:SetSize(modelNameTextSize + TM.MenuScale(10), TM.MenuScale(110))
                                    UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)
                                    modelPopOut:SetAlpha(0)
                                    modelPopOut:AlphaTo(255, 0.1, 0, function() end)
                                    modelPopOut:SetMouseInputEnabled(false)

                                    modelPopOut.Paint = function(s, w, h)
                                        if !IsValid(s) then return end

                                        BlurPanel(s, 3)

                                        -- panel position follows mouse position
                                        UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)

                                        surface.SetDrawColor(Color(0, 0, 0, 205))
                                        surface.DrawRect(0, 0, w, h)

                                        surface.SetDrawColor(previewRed)
                                        surface.DrawRect(0, 0, w, h)

                                        surface.SetDrawColor(Color(255, 255, 255, 155))
                                        surface.DrawRect(0, 0, w, TM.MenuScale(1))
                                        surface.DrawRect(0, h - TM.MenuScale(1), w, TM.MenuScale(1))
                                        surface.DrawRect(0, 0, TM.MenuScale(1), h)
                                        surface.DrawRect(w - TM.MenuScale(1), 0, TM.MenuScale(1), h)

                                        draw.SimpleTextOutlined(string.upper(newModelName), "PlayerNotiName", w / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))

                                        if newModelUnlockType == "headshot" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(255, 0, 0, 15))
                                            draw.SimpleTextOutlined("HEADSHOTS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        elseif newModelUnlockType == "smackdown" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(255, 0, 0, 15))
                                            draw.SimpleTextOutlined("MELEE KILLS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        elseif newModelUnlockType == "clutch" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(255, 0, 0, 15))
                                            draw.SimpleTextOutlined("CLUTCHES", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        elseif newModelUnlockType == "longshot" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(2550, 0, 0, 15))
                                            draw.SimpleTextOutlined("LONGSHOTS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        elseif newModelUnlockType == "pointblank" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(2550, 0, 0, 15))
                                            draw.SimpleTextOutlined("POINT BLANKS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        elseif newModelUnlockType == "killstreaks" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(2550, 0, 0, 15))
                                            draw.SimpleTextOutlined("STREAKS STARTED", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        elseif newModelUnlockType == "buzzkills" then
                                            draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(255, 0, 0, 15))
                                            draw.SimpleTextOutlined("BUZZKILLS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        end
                                    end
                                end

                                icon.OnCursorExited = function()
                                    if IsValid(modelPopOut) then modelPopOut:Remove() end

                                    newModel = equippedModel
                                    newModelName = equippedModelName
                                    newModelUnlockType = equippedModelUnlockType
                                    newModelUnlockValue = equippedModelUnlockValue
                                    PreviewNewModel(equippedModel)
                                end

                                icon.DoClick = function() surface.PlaySound("tmui/warning.wav") end
                            end
                        end
                    end

                    local function FillModelListsUnlocked()
                        for i = 1, #modelArray do
                            if modelArray[i][3] == "default" then
                                local icon = vgui.Create("SpawnIcon", DockModels)
                                icon:SetModel(modelArray[i][1])
                                icon:SetSize(TM.MenuScale(150), TM.MenuScale(150))
                                icon:SetTooltip(nil)
                                DefaultModelList:Add(icon)

                                defaultModelsTotal = defaultModelsTotal + 1
                                modelsUnlocked = modelsUnlocked + 1
                                defaultModelsUnlocked = defaultModelsUnlocked + 1

                                icon.OnCursorEntered = function()
                                    TriggerSound("hover")

                                    newModel = modelArray[i][1]
                                    newModelName = modelArray[i][2]
                                    newModelUnlockType = modelArray[i][3]
                                    newModelUnlockValue = modelArray[i][4]
                                    PreviewNewModel(newModel)

                                    if mouseX <= (ScrW() / 2) then sideH = true else sideH = false end
                                    if mouseY <= (ScrH() / 2) then sideV = true else sideV = false end

                                    surface.SetFont("PlayerNotiName")
                                    local modelNameTextSize = math.max(surface.GetTextSize(string.upper(newModelName)), TM.MenuScale(200))

                                    if IsValid(modelPopOut) then modelPopOut:Remove() end
                                    modelPopOut = vgui.Create("DPanel", MainMenu)
                                    modelPopOut:SetSize(modelNameTextSize + TM.MenuScale(10), TM.MenuScale(70))
                                    UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)
                                    modelPopOut:SetAlpha(0)
                                    modelPopOut:AlphaTo(255, 0.1, 0, function() end)
                                    modelPopOut:SetMouseInputEnabled(false)

                                    modelPopOut.Paint = function(s, w, h)

                                        if !IsValid(s) then return end

                                        BlurPanel(s, 3)

                                        -- panel position follows mouse position
                                        UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)

                                        surface.SetDrawColor(Color(0, 0, 0, 205))
                                        surface.DrawRect(0, 0, w, h)

                                        surface.SetDrawColor(previewGreen)
                                        surface.DrawRect(0, 0, w, h)

                                        surface.SetDrawColor(Color(255, 255, 255, 155))
                                        surface.DrawRect(0, 0, w, TM.MenuScale(1))
                                        surface.DrawRect(0, h - TM.MenuScale(1), w, TM.MenuScale(1))
                                        surface.DrawRect(0, 0, TM.MenuScale(1), h)
                                        surface.DrawRect(w - TM.MenuScale(1), 0, TM.MenuScale(1), h)

                                        draw.SimpleTextOutlined(string.upper(newModelName), "PlayerNotiName", w / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        draw.SimpleTextOutlined("click to equip", "StreakText", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))

                                    end
                                end

                                icon.OnCursorExited = function()
                                    if IsValid(modelPopOut) then modelPopOut:Remove() end

                                    newModel = equippedModel
                                    newModelName = equippedModelName
                                    newModelUnlockType = equippedModelUnlockType
                                    newModelUnlockValue = equippedModelUnlockValue
                                    PreviewNewModel(equippedModel)
                                end

                                icon.DoClick = function() ApplyModel() end
                            elseif modelArray[i][3] == "kills" or modelArray[i][3] == "streak" or modelArray[i][3] == "matches" or modelArray[i][3] == "wins" then
                                statModelsTotal = statModelsTotal + 1
                                if modelArray[i][3] == "kills" and LocalPly:GetNWInt("playerKills") >= modelArray[i][4] or modelArray[i][3] == "streak" and LocalPly:GetNWInt("highestKillStreak") >= modelArray[i][4] or modelArray[i][3] == "matches" and LocalPly:GetNWInt("matchesPlayed") >= modelArray[i][4] or modelArray[i][3] == "wins" and LocalPly:GetNWInt("matchesWon") >= modelArray[i][4] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsStats)
                                    icon:SetModel(modelArray[i][1])
                                    icon:SetSize(TM.MenuScale(150), TM.MenuScale(150))
                                    icon:SetTooltip(nil)
                                    StatModelList:Add(icon)

                                    statModelsUnlocked = statModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.OnCursorEntered = function()
                                        TriggerSound("hover")

                                        newModel = modelArray[i][1]
                                        newModelName = modelArray[i][2]
                                        newModelUnlockType = modelArray[i][3]
                                        newModelUnlockValue = modelArray[i][4]
                                        PreviewNewModel(newModel)

                                        if mouseX <= (ScrW() / 2) then sideH = true else sideH = false end
                                        if mouseY <= (ScrH() / 2) then sideV = true else sideV = false end

                                        surface.SetFont("PlayerNotiName")
                                        local modelNameTextSize = math.max(surface.GetTextSize(string.upper(newModelName)), TM.MenuScale(200))

                                        if IsValid(modelPopOut) then modelPopOut:Remove() end
                                        modelPopOut = vgui.Create("DPanel", MainMenu)
                                        modelPopOut:SetSize(modelNameTextSize + TM.MenuScale(10), TM.MenuScale(130))
                                        UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)
                                        modelPopOut:SetAlpha(0)
                                        modelPopOut:AlphaTo(255, 0.1, 0, function() end)
                                        modelPopOut:SetMouseInputEnabled(false)

                                        modelPopOut.Paint = function(s, w, h)

                                            if !IsValid(s) then return end

                                            BlurPanel(s, 3)

                                            -- panel position follows mouse position
                                            UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)

                                            surface.SetDrawColor(Color(0, 0, 0, 205))
                                            surface.DrawRect(0, 0, w, h)

                                            surface.SetDrawColor(previewGreen)
                                            surface.DrawRect(0, 0, w, h)

                                            surface.SetDrawColor(Color(255, 255, 255, 155))
                                            surface.DrawRect(0, 0, w, TM.MenuScale(1))
                                            surface.DrawRect(0, h - TM.MenuScale(1), w, TM.MenuScale(1))
                                            surface.DrawRect(0, 0, TM.MenuScale(1), h)
                                            surface.DrawRect(w - TM.MenuScale(1), 0, TM.MenuScale(1), h)

                                            draw.SimpleTextOutlined(string.upper(newModelName), "PlayerNotiName", w / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))

                                            if newModelUnlockType == "kills" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerKills") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("KILLS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "streak" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("highestKillStreak") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("HIGHEST STREAK", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "matches" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("matchesPlayed") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("MATCHES PLAYED", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "wins" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("matchesWon") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("MATCHES WON", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            end

                                            draw.SimpleTextOutlined("click to equip", "StreakText", w / 2, TM.MenuScale(105), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        end
                                    end

                                    icon.DoClick = function() ApplyModel() end
                                end
                            elseif modelArray[i][3] == "headshot" or modelArray[i][3] == "smackdown" or modelArray[i][3] == "clutch" or modelArray[i][3] == "longshot" or modelArray[i][3] == "pointblank" or modelArray[i][3] == "killstreaks" or modelArray[i][3] == "buzzkills" then
                                accoladeModelsTotal = accoladeModelsTotal + 1

                                if modelArray[i][3] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") >= modelArray[i][4] or modelArray[i][3] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") >= modelArray[i][4] or modelArray[i][3] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") >= modelArray[i][4] or modelArray[i][3] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") >= modelArray[i][4] or modelArray[i][3] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") >= modelArray[i][4] or modelArray[i][3] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") >= modelArray[i][4] or modelArray[i][3] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") >= modelArray[i][4] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                                    icon:SetModel(modelArray[i][1])
                                    icon:SetSize(TM.MenuScale(150), TM.MenuScale(150))
                                    icon:SetTooltip(nil)
                                    AccoladeModelList:Add(icon)

                                    accoladeModelsUnlocked = accoladeModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.OnCursorEntered = function()
                                        TriggerSound("hover")

                                        newModel = modelArray[i][1]
                                        newModelName = modelArray[i][2]
                                        newModelUnlockType = modelArray[i][3]
                                        newModelUnlockValue = modelArray[i][4]
                                        PreviewNewModel(newModel)

                                        if mouseX <= (ScrW() / 2) then sideH = true else sideH = false end
                                        if mouseY <= (ScrH() / 2) then sideV = true else sideV = false end

                                        surface.SetFont("PlayerNotiName")
                                        local modelNameTextSize = math.max(surface.GetTextSize(string.upper(newModelName)), TM.MenuScale(220))

                                        if IsValid(modelPopOut) then modelPopOut:Remove() end
                                        modelPopOut = vgui.Create("DPanel", MainMenu)
                                        modelPopOut:SetSize(modelNameTextSize + TM.MenuScale(10), TM.MenuScale(130))
                                        UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)
                                        modelPopOut:SetAlpha(0)
                                        modelPopOut:AlphaTo(255, 0.1, 0, function() end)
                                        modelPopOut:SetMouseInputEnabled(false)

                                        modelPopOut.Paint = function(s, w, h)
                                            if !IsValid(s) then return end

                                            BlurPanel(s, 3)

                                            -- panel position follows mouse position
                                            UpdatePopOutPos(modelPopOut, sideH, sideV, mouseX, mouseY)

                                            surface.SetDrawColor(Color(0, 0, 0, 205))
                                            surface.DrawRect(0, 0, w, h)

                                            surface.SetDrawColor(previewGreen)
                                            surface.DrawRect(0, 0, w, h)

                                            surface.SetDrawColor(Color(255, 255, 255, 155))
                                            surface.DrawRect(0, 0, w, TM.MenuScale(1))
                                            surface.DrawRect(0, h - TM.MenuScale(1), w, TM.MenuScale(1))
                                            surface.DrawRect(0, 0, TM.MenuScale(1), h)
                                            surface.DrawRect(w - TM.MenuScale(1), 0, TM.MenuScale(1), h)

                                            draw.SimpleTextOutlined(string.upper(newModelName), "PlayerNotiName", w / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))

                                            if newModelUnlockType == "headshot" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("HEADSHOTS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "smackdown" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("MELEE KILLS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "clutch" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("CLUTCHES", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "longshot" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("LONGSHOTS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "pointblank" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("POINT BLANKS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "killstreaks" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("STREAKS STARTED", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            elseif newModelUnlockType == "buzzkills" then
                                                draw.SimpleTextOutlined(LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newModelUnlockValue, "Health", w / 2, TM.MenuScale(45), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 255, 0, 15))
                                                draw.SimpleTextOutlined("BUZZKILLS", "Health", w / 2, TM.MenuScale(75), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                            end

                                            draw.SimpleTextOutlined("click to equip", "StreakText", w / 2, TM.MenuScale(105), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TM.MenuScale(1), Color(0, 0, 0, 205))
                                        end
                                    end

                                    icon.OnCursorExited = function()
                                        if IsValid(modelPopOut) then modelPopOut:Remove() end

                                        newModel = equippedModel
                                        newModelName = equippedModelName
                                        newModelUnlockType = equippedModelUnlockType
                                        newModelUnlockValue = equippedModelUnlockValue
                                        PreviewNewModel(equippedModel)
                                    end

                                    icon.DoClick = function() ApplyModel() end
                                end
                            end
                        end
                    end

                    FillModelListsAll()

                    TextDefault.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("DEFAULT", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(defaultModelsUnlocked .. " / " .. defaultModelsTotal, "Health", w / 2, TM.MenuScale(55), solidGreen, TEXT_ALIGN_CENTER)
                    end

                    TextStats.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("STATS", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)

                        if statModelsUnlocked == statModelsTotal then
                            draw.SimpleText(statModelsUnlocked .. " / " .. statModelsTotal, "Health", w / 2, TM.MenuScale(55), solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(statModelsUnlocked .. " / " .. statModelsTotal, "Health", w / 2, TM.MenuScale(55), white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("ACCOLADES", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)

                        if accoladeModelsUnlocked == accoladeModelsTotal then
                            draw.SimpleText(accoladeModelsUnlocked .. " / " .. accoladeModelsTotal, "Health", w / 2, TM.MenuScale(55), solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(accoladeModelsUnlocked .. " / " .. accoladeModelsTotal, "Health", w / 2, TM.MenuScale(55), white, TEXT_ALIGN_CENTER)
                        end
                    end

                    DockModels.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockModelsStats.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockModelsAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    function HideLockedModels:OnChange(bVal)
                        if (bVal) then
                            DefaultModelList:Clear()
                            StatModelList:Clear()
                            AccoladeModelList:Clear()
                            modelsUnlocked = 0
                            defaultModelsTotal = 0
                            defaultModelsUnlocked = 0
                            statModelsTotal = 0
                            statModelsUnlocked = 0
                            accoladeModelsTotal = 0
                            accoladeModelsUnlocked = 0
                            FillModelListsUnlocked()
                            DockModels:SetSize(0, TM.MenuScale(310))
                            DockModelsStats:SetSize(0, (statModelsTotal * TM.MenuScale(38.75)) + TM.MenuScale(103.2))
                            DockModelsAccolade:SetSize(0, (accoladeModelsUnlocked * TM.MenuScale(38.75)) + TM.MenuScale(103.2))
                        else
                            DefaultModelList:Clear()
                            StatModelList:Clear()
                            AccoladeModelList:Clear()
                            modelsUnlocked = 0
                            defaultModelsTotal = 0
                            defaultModelsUnlocked = 0
                            statModelsTotal = 0
                            statModelsUnlocked = 0
                            accoladeModelsTotal = 0
                            accoladeModelsUnlocked = 0
                            FillModelListsAll()
                            DockModels:SetSize(0, TM.MenuScale(310))
                            DockModelsStats:SetSize(0, TM.MenuScale(1240))
                            DockModelsAccolade:SetSize(0, TM.MenuScale(1080))
                        end
                    end

                    local ModelIcon = vgui.Create("DImage", ModelQuickjumpHolder)
                    ModelIcon:SetPos(TM.MenuScale(12), TM.MenuScale(12))
                    ModelIcon:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                    ModelIcon:SetImage("icons/modelicon.png")

                    local DefaultJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    DefaultJump:SetPos(TM.MenuScale(4), TM.MenuScale(100))
                    DefaultJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    DefaultJump:SetImage("icons/unlockedicon.png")
                    DefaultJump:SetTooltip("Default")
                    DefaultJump.DoClick = function()
                        TriggerSound("click")
                        CustomizeScroller:ScrollToChild(TextDefault)
                    end

                    local StatsJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    StatsJump:SetPos(TM.MenuScale(4), TM.MenuScale(152))
                    StatsJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    StatsJump:SetImage("icons/uikillicon.png")
                    StatsJump:SetTooltip("Kills")
                    StatsJump.DoClick = function()
                        TriggerSound("click")
                        CustomizeScroller:ScrollToChild(TextStats)
                    end

                    local AccoladeJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    AccoladeJump:SetPos(TM.MenuScale(4), TM.MenuScale(204))
                    AccoladeJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    AccoladeJump:SetImage("icons/accoladeicon.png")
                    AccoladeJump:SetTooltip("Accolades")
                    AccoladeJump.DoClick = function()
                        TriggerSound("click")
                        CustomizeScroller:ScrollToChild(TextAccolade)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    BackButtonSlideout:SetPos(TM.MenuScale(12), scrH - TM.MenuScale(44))
                    BackButtonSlideout:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
                        TriggerSound("back")
                        ModelPanel:AlphaTo(0, 0.05, 0, function() ModelPanel:Hide() end)
                        ModelPreviewPanel:AlphaTo(0, 0.05, 0, function() ModelPreviewPanel:Hide() end)
                        ModelSlideoutPanel:AlphaTo(0, 0.05, 0, function() ModelSlideoutPanel:Hide() end)
                        MainPanel:Show()
                        MainPanel:AlphaTo(255, 0.05, 0.025)
                    end
                end
            end

            local OptionsButton = vgui.Create("DButton", MainPanel)
            local OptionsSettingsButton = vgui.Create("DButton", OptionsButton)
            local OptionsHUDButton = vgui.Create("DButton", OptionsButton)
            OptionsButton:SetPos(0, scrH / 2 + TM.MenuScale(50))
            OptionsButton:SetText("")
            OptionsButton:SetSize(TM.MenuScale(405), TM.MenuScale(100))
            local textAnim = 0
            OptionsButton.Paint = function()
                if OptionsButton:IsHovered() or OptionsSettingsButton:IsHovered() or OptionsHUDButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 20)
                    pushExitItems = math.Clamp(pushExitItems + 600 * RealFrameTime(), 100, 150)
                    OptionsButton:SizeTo(TM.MenuScale(405), TM.MenuScale(200), 0, 0, 1)
                else
                    textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 20)
                    pushExitItems = math.Clamp(pushExitItems - 600 * RealFrameTime(), 100, 150)
                    OptionsButton:SizeTo(TM.MenuScale(405), TM.MenuScale(100), 0, 0, 1)
                end
                draw.DrawText("OPTIONS", "AmmoCountSmall", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
            end

            OptionsSettingsButton:SetPos(0, TM.MenuScale(100))
            OptionsSettingsButton:SetText("")
            OptionsSettingsButton:SetSize(TM.MenuScale(235), TM.MenuScale(100))
            OptionsSettingsButton.Paint = function()
                draw.DrawText("SETTINGS", "AmmoCountESmall", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
            end

            OptionsHUDButton:SetPos(TM.MenuScale(240), TM.MenuScale(100))
            OptionsHUDButton:SetText("")
            OptionsHUDButton:SetSize(TM.MenuScale(245), TM.MenuScale(100))
            OptionsHUDButton.Paint = function()
                draw.DrawText("HUD", "AmmoCountESmall", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
            end

            OptionsSettingsButton.DoClick = function()
                if IsValid(OptionsPanel) then return end
                MainPanel:AlphaTo(0, 0.05, 0, function() MainPanel:Hide() end)

                local previewPool = {"images/preview/sky.png", "images/preview/sky2.png", "images/preview/metal.png", "images/preview/water.png", "images/preview/grass.png", "images/preview/devtexture.png", "images/preview/wood.png", "images/preview/glass.png"}
                local previewImg = "images/preview/sky.png"

                if not IsValid(OptionsPanel) then
                    local OptionsPanel = MainMenu:Add("OptionsPanel")
                    OptionsPanel:SetAlpha(0)
                    local OptionsSlideoutPanel = MainMenu:Add("OptionsSlideoutPanel")
                    OptionsSlideoutPanel:SetAlpha(0)

                    OptionsPanel:AlphaTo(255, 0.05, 0.025)
                    OptionsSlideoutPanel:AlphaTo(255, 0.05, 0.025)

                    local OptionsQuickjumpHolder = vgui.Create("DPanel", OptionsSlideoutPanel)
                    OptionsQuickjumpHolder:Dock(TOP)
                    OptionsQuickjumpHolder:SetSize(0, scrH)

                    OptionsQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                        draw.RoundedBox(0, TM.MenuScale(4), scrH - TM.MenuScale(52), TM.MenuScale(48), TM.MenuScale(48), transparentRed)
                    end

                    local OptionsScroller = vgui.Create("DScrollPanel", OptionsPanel)
                    OptionsScroller:Dock(FILL)

                    local sbar = OptionsScroller:GetVBar()
                    sbar:SetHideButtons(true)
                    sbar:SetSize(TM.MenuScale(15), TM.MenuScale(15))
                    function sbar:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(0, TM.MenuScale(5), TM.MenuScale(8), TM.MenuScale(5), h - TM.MenuScale(16), Color(255, 255, 255, 175))
                    end

                    local DockAccount = vgui.Create("DPanel", OptionsScroller)
                    DockAccount:Dock(TOP)
                    DockAccount:SetSize(0, TM.MenuScale(110))

                    local DockInputs = vgui.Create("DPanel", OptionsScroller)
                    DockInputs:Dock(TOP)
                    DockInputs:SetSize(0, TM.MenuScale(760))

                    local DockGameplay = vgui.Create("DPanel", OptionsScroller)
                    DockGameplay:Dock(TOP)
                    DockGameplay:SetSize(0, TM.MenuScale(395))

                    local DockUI = vgui.Create("DPanel", OptionsScroller)
                    DockUI:Dock(TOP)
                    DockUI:SetSize(0, TM.MenuScale(435))

                    local DockAudio = vgui.Create("DPanel", OptionsScroller)
                    DockAudio:Dock(TOP)
                    DockAudio:SetSize(0, TM.MenuScale(360))

                    local DockCrosshair = vgui.Create("DPanel", OptionsScroller)
                    DockCrosshair:Dock(TOP)
                    DockCrosshair:SetSize(0, TM.MenuScale(670))

                    local DockHitmarker = vgui.Create("DPanel", OptionsScroller)
                    DockHitmarker:Dock(TOP)
                    DockHitmarker:SetSize(0, TM.MenuScale(550))

                    local DockPerformance = vgui.Create("DPanel", OptionsScroller)
                    DockPerformance:Dock(TOP)
                    DockPerformance:SetSize(0, TM.MenuScale(400))

                    local SettingsCog = vgui.Create("DImage", OptionsQuickjumpHolder)
                    SettingsCog:SetPos(TM.MenuScale(12), TM.MenuScale(12))
                    SettingsCog:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                    SettingsCog:SetImage("icons/settingsicon.png")

                    local AccountJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    AccountJump:SetPos(TM.MenuScale(4), TM.MenuScale(100))
                    AccountJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    AccountJump:SetTooltip("Account")
                    AccountJump:SetImage("icons/accounticon.png")
                    AccountJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockAccount)
                    end

                    local InputsJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    InputsJump:SetPos(TM.MenuScale(4), TM.MenuScale(152))
                    InputsJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    InputsJump:SetTooltip("Input")
                    InputsJump:SetImage("icons/inputicon.png")
                    InputsJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockInputs)
                    end

                    local GameplayJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    GameplayJump:SetPos(TM.MenuScale(4), TM.MenuScale(204))
                    GameplayJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    GameplayJump:SetTooltip("Gameplay")
                    GameplayJump:SetImage("icons/weaponicon.png")
                    GameplayJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockGameplay)
                    end

                    local UIJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    UIJump:SetPos(TM.MenuScale(4), TM.MenuScale(256))
                    UIJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    UIJump:SetTooltip("Interface")
                    UIJump:SetImage("icons/interfaceicon.png")
                    UIJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockUI)
                    end

                    local AudioJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    AudioJump:SetPos(TM.MenuScale(4), TM.MenuScale(308))
                    AudioJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    AudioJump:SetTooltip("Audio")
                    AudioJump:SetImage("icons/audioicon.png")
                    AudioJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockAudio)
                    end

                    local CrosshairJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    CrosshairJump:SetPos(TM.MenuScale(4), TM.MenuScale(360))
                    CrosshairJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    CrosshairJump:SetTooltip("Crosshair")
                    CrosshairJump:SetImage("icons/crosshairicon.png")
                    CrosshairJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockCrosshair)
                    end

                    local HitmarkerJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    HitmarkerJump:SetPos(TM.MenuScale(4), TM.MenuScale(412))
                    HitmarkerJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    HitmarkerJump:SetTooltip("Hitmarker")
                    HitmarkerJump:SetImage("icons/hitmarkericon.png")
                    HitmarkerJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockHitmarker)
                    end

                    local PerformanceJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    PerformanceJump:SetPos(TM.MenuScale(4), TM.MenuScale(464))
                    PerformanceJump:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    PerformanceJump:SetTooltip("Performance")
                    PerformanceJump:SetImage("icons/performanceicon.png")
                    PerformanceJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockPerformance)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    BackButtonSlideout:SetPos(TM.MenuScale(12), scrH - TM.MenuScale(44))
                    BackButtonSlideout:SetSize(TM.MenuScale(32), TM.MenuScale(32))
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout.DoClick = function()
                        TriggerSound("back")
                        OptionsPanel:AlphaTo(0, 0.05, 0, function() OptionsPanel:Hide() end)
                        OptionsSlideoutPanel:AlphaTo(0, 0.05, 0, function() OptionsSlideoutPanel:Hide() end)
                        MainPanel:Show()
                        MainPanel:AlphaTo(255, 0.05, 0.025)
                        timer.Remove("CrosshairDynamicPreview")
                    end

                    DockAccount.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("ACCOUNT", "OptionsHeader", TM.MenuScale(20), 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Hide Lifetime Stats From Others", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(65), white, TEXT_ALIGN_LEFT)
                    end

                    local hideStatsFromOthers = DockAccount:Add("DCheckBox")
                    hideStatsFromOthers:SetPos(TM.MenuScale(20), TM.MenuScale(70))
                    hideStatsFromOthers:SetConVar("tm_hidestatsfromothers")
                    hideStatsFromOthers:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function hideStatsFromOthers:OnChange() TriggerSound("click") end

                    DockInputs.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("INPUT", "OptionsHeader", TM.MenuScale(20), 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Auto Sprint", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(65), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Auto Sprint Interaction Delay", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(105), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("1x ADS Sensitivity", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(145), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("2x ADS Sensitivity", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(185), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("4x ADS Sensitivity", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(225), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("6x ADS Sensitivity", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(265), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Sensitivity Transition Style", "SettingsLabel", TM.MenuScale(135), TM.MenuScale(305), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Compensate Sensitivity w/ FOV", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(345), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Main Menu Bind", "SettingsLabel", TM.MenuScale(135), TM.MenuScale(385), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Grenade Bind", "SettingsLabel", TM.MenuScale(135), TM.MenuScale(425), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Grappling Hook Bind", "SettingsLabel", TM.MenuScale(135), TM.MenuScale(465), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Quick Weapon Switching", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(505), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Primary Weapon Bind", "SettingsLabel", TM.MenuScale(135), TM.MenuScale(545), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Secondary Weapon Bind", "SettingsLabel", TM.MenuScale(135), TM.MenuScale(585), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Melee Weapon Bind", "SettingsLabel", TM.MenuScale(135), TM.MenuScale(625), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Inspect Bind", "SettingsLabel", TM.MenuScale(135), TM.MenuScale(665), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Attachments Bind (none = [" .. string.upper(ContextBind) .. "])", "SettingsLabel", TM.MenuScale(135), TM.MenuScale(705), white, TEXT_ALIGN_LEFT)
                    end

                    local autoSprint = DockInputs:Add("DCheckBox")
                    autoSprint:SetPos(TM.MenuScale(20), TM.MenuScale(70))
                    autoSprint:SetConVar("tm_autosprint")
                    autoSprint:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function autoSprint:OnChange() TriggerSound("click") end

                    local autoSprintDelay = DockInputs:Add("DNumSlider")
                    autoSprintDelay:SetPos(TM.MenuScale(-85), TM.MenuScale(110))
                    autoSprintDelay:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    autoSprintDelay:SetConVar("tm_autosprint_delay")
                    autoSprintDelay:SetMin(0.25)
                    autoSprintDelay:SetMax(0.50)
                    autoSprintDelay:SetDecimals(2)

                    local adsSensitivity = DockInputs:Add("DNumSlider")
                    adsSensitivity:SetPos(TM.MenuScale(-85), TM.MenuScale(150))
                    adsSensitivity:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    adsSensitivity:SetConVar("tm_sensitivity_1x")
                    adsSensitivity:SetMin(0)
                    adsSensitivity:SetMax(100)
                    adsSensitivity:SetDecimals(0)

                    local twoadsSensitivity = DockInputs:Add("DNumSlider")
                    twoadsSensitivity:SetPos(TM.MenuScale(-85), TM.MenuScale(190))
                    twoadsSensitivity:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    twoadsSensitivity:SetConVar("tm_sensitivity_2x")
                    twoadsSensitivity:SetMin(0)
                    twoadsSensitivity:SetMax(100)
                    twoadsSensitivity:SetDecimals(0)

                    local fouradsSensitivity = DockInputs:Add("DNumSlider")
                    fouradsSensitivity:SetPos(TM.MenuScale(-85), TM.MenuScale(230))
                    fouradsSensitivity:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    fouradsSensitivity:SetConVar("tm_sensitivity_4x")
                    fouradsSensitivity:SetMin(0)
                    fouradsSensitivity:SetMax(100)
                    fouradsSensitivity:SetDecimals(0)

                    local sixadsSensitivity = DockInputs:Add("DNumSlider")
                    sixadsSensitivity:SetPos(TM.MenuScale(-85), TM.MenuScale(270))
                    sixadsSensitivity:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    sixadsSensitivity:SetConVar("tm_sensitivity_6x")
                    sixadsSensitivity:SetMin(0)
                    sixadsSensitivity:SetMax(100)
                    sixadsSensitivity:SetDecimals(0)

                    local sensitivityTransition = DockInputs:Add("DComboBox")
                    sensitivityTransition:SetPos(TM.MenuScale(20), TM.MenuScale(310))
                    sensitivityTransition:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    if GetConVar("tm_sensitivity_transition"):GetInt() == 0 then sensitivityTransition:SetValue("Instant") elseif GetConVar("tm_sensitivity_transition"):GetInt() == 1 then sensitivityTransition:SetValue("Gradual") end
                    sensitivityTransition:AddChoice("Instant")
                    sensitivityTransition:AddChoice("Gradual")
                    sensitivityTransition.OnSelect = function(self, value) RunConsoleCommand("tm_sensitivity_transition", value - 1) TriggerSound("forward") end

                    local compensateSensWithFOV = DockInputs:Add("DCheckBox")
                    compensateSensWithFOV:SetPos(TM.MenuScale(20), TM.MenuScale(350))
                    compensateSensWithFOV:SetConVar("cl_tfa_scope_sensitivity_autoscale")
                    compensateSensWithFOV:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function compensateSensWithFOV:OnChange() TriggerSound("click") end

                    local mainMenuBind = DockInputs:Add("DBinder")
                    mainMenuBind:SetPos(TM.MenuScale(22.5), TM.MenuScale(390))
                    mainMenuBind:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    mainMenuBind:SetSelectedNumber(GetConVar("tm_mainmenubind"):GetInt())
                    function mainMenuBind:OnChange(num)
                        TriggerSound("forward")
                        selectedMenuBind = mainMenuBind:GetSelectedNumber()
                        RunConsoleCommand("tm_mainmenubind", selectedMenuBind)
                    end

                    local grenadeBind = DockInputs:Add("DBinder")
                    grenadeBind:SetPos(TM.MenuScale(22.5), TM.MenuScale(430))
                    grenadeBind:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    grenadeBind:SetSelectedNumber(GetConVar("tm_nadebind"):GetInt())
                    function grenadeBind:OnChange(num)
                        TriggerSound("forward")
                        selectedGrenadeBind = grenadeBind:GetSelectedNumber()
                        RunConsoleCommand("tm_nadebind", selectedGrenadeBind)
                    end

                    local grappleBind = DockInputs:Add("DBinder")
                    grappleBind:SetPos(TM.MenuScale(22.5), TM.MenuScale(470))
                    grappleBind:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    grappleBind:SetSelectedNumber(GetConVar("frest_bindg"):GetInt())
                    function grappleBind:OnChange(num)
                        TriggerSound("forward")
                        selectedGrappleBind = grappleBind:GetSelectedNumber()
                        RunConsoleCommand("frest_bindg", selectedGrappleBind)
                    end

                    local quickWeaponSwitching = DockInputs:Add("DCheckBox")
                    quickWeaponSwitching:SetPos(TM.MenuScale(20), TM.MenuScale(510))
                    quickWeaponSwitching:SetConVar("tm_quickswitching")
                    quickWeaponSwitching:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function quickWeaponSwitching:OnChange() TriggerSound("click") end

                    local primaryBind = DockInputs:Add("DBinder")
                    primaryBind:SetPos(TM.MenuScale(22.5), TM.MenuScale(550))
                    primaryBind:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    primaryBind:SetSelectedNumber(GetConVar("tm_primarybind"):GetInt())
                    function primaryBind:OnChange(num)
                        TriggerSound("forward")
                        selectedPrimaryBind = primaryBind:GetSelectedNumber()
                        RunConsoleCommand("tm_primarybind", selectedPrimaryBind)
                    end

                    local secondaryBind = DockInputs:Add("DBinder")
                    secondaryBind:SetPos(TM.MenuScale(22.5), TM.MenuScale(590))
                    secondaryBind:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    secondaryBind:SetSelectedNumber(GetConVar("tm_secondarybind"):GetInt())
                    function secondaryBind:OnChange(num)
                        TriggerSound("forward")
                        selectedSecondaryBind = secondaryBind:GetSelectedNumber()
                        RunConsoleCommand("tm_secondarybind", selectedSecondaryBind)
                    end

                    local meleeBind = DockInputs:Add("DBinder")
                    meleeBind:SetPos(TM.MenuScale(22.5), TM.MenuScale(630))
                    meleeBind:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    meleeBind:SetSelectedNumber(GetConVar("tm_meleebind"):GetInt())
                    function meleeBind:OnChange(num)
                        TriggerSound("forward")
                        selectedMeleeBind = meleeBind:GetSelectedNumber()
                        RunConsoleCommand("tm_meleebind", selectedMeleeBind)
                    end

                    local inspectBind = DockInputs:Add("DBinder")
                    inspectBind:SetPos(TM.MenuScale(22.5), TM.MenuScale(670))
                    inspectBind:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    inspectBind:SetSelectedNumber(GetConVar("cl_tfa_keys_inspect"):GetInt())
                    function inspectBind:OnChange(num)
                        TriggerSound("forward")
                        selectedInspectBind = inspectBind:GetSelectedNumber()
                        RunConsoleCommand("cl_tfa_keys_inspect", selectedInspectBind)
                    end

                    local customizeBind = DockInputs:Add("DBinder")
                    customizeBind:SetPos(TM.MenuScale(22.5), TM.MenuScale(710))
                    customizeBind:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    customizeBind:SetSelectedNumber(GetConVar("cl_tfa_keys_customize"):GetInt())
                    function customizeBind:OnChange(num)
                        TriggerSound("forward")
                        selectedCustomizeBind = customizeBind:GetSelectedNumber()
                        RunConsoleCommand("cl_tfa_keys_customize", selectedCustomizeBind)
                    end

                    DockGameplay.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("GAMEPLAY", "OptionsHeader", TM.MenuScale(20), 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Override FOV", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(65), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("FOV Value", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(105), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Sprinting FOV Increase", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(145), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Centered Viewmodel", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(185), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Death Camera", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(225), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Optic Reticle Color", "SettingsLabel", TM.MenuScale(245), TM.MenuScale(265), white, TEXT_ALIGN_LEFT)
                    end

                    local customFOV = DockGameplay:Add("DCheckBox")
                    customFOV:SetPos(TM.MenuScale(20), TM.MenuScale(70))
                    customFOV:SetConVar("tm_customfov")
                    customFOV:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function customFOV:OnChange() TriggerSound("click") end

                    local customFOVSlider = DockGameplay:Add("DNumSlider")
                    customFOVSlider:SetPos(TM.MenuScale(-85), TM.MenuScale(110))
                    customFOVSlider:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    customFOVSlider:SetConVar("tm_customfov_value")
                    customFOVSlider:SetMin(100)
                    customFOVSlider:SetMax(144)
                    customFOVSlider:SetDecimals(0)

                    local sprintingFOV = DockGameplay:Add("DCheckBox")
                    sprintingFOV:SetPos(TM.MenuScale(20), TM.MenuScale(150))
                    sprintingFOV:SetConVar("tm_customfov_sprint")
                    sprintingFOV:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function sprintingFOV:OnChange() TriggerSound("click") end

                    local centeredVM = DockGameplay:Add("DCheckBox")
                    centeredVM:SetPos(TM.MenuScale(20), TM.MenuScale(190))
                    centeredVM:SetConVar("cl_tfa_viewmodel_centered")
                    centeredVM:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function centeredVM:OnChange() TriggerSound("click") end

                    local deathCam = DockGameplay:Add("DCheckBox")
                    deathCam:SetPos(TM.MenuScale(20), TM.MenuScale(230))
                    deathCam:SetConVar("tm_deathcam")
                    deathCam:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function deathCam:OnChange() TriggerSound("click") end

                    local EotechPreview = vgui.Create("DImage", DockGameplay)
                    EotechPreview:SetPos(TM.MenuScale(245), TM.MenuScale(310))
                    EotechPreview:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    EotechPreview:SetImage("images/reticles/eotech.png")
                    EotechPreview:SetImageColor(Color(GetConVar("cl_tfa_reticule_color_r"):GetInt(), GetConVar("cl_tfa_reticule_color_g"):GetInt(), GetConVar("cl_tfa_reticule_color_b"):GetInt(), 200))

                    local KobraPreview = vgui.Create("DImage", DockGameplay)
                    KobraPreview:SetPos(TM.MenuScale(289), TM.MenuScale(310))
                    KobraPreview:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    KobraPreview:SetImage("images/reticles/kobra.png")
                    KobraPreview:SetImageColor(Color(GetConVar("cl_tfa_reticule_color_r"):GetInt(), GetConVar("cl_tfa_reticule_color_g"):GetInt(), GetConVar("cl_tfa_reticule_color_b"):GetInt(), 200))

                    local AimpointPreview = vgui.Create("DImage", DockGameplay)
                    AimpointPreview:SetPos(TM.MenuScale(333), TM.MenuScale(310))
                    AimpointPreview:SetSize(TM.MenuScale(48), TM.MenuScale(48))
                    AimpointPreview:SetImage("images/reticles/aimpoint.png")
                    AimpointPreview:SetImageColor(Color(GetConVar("cl_tfa_reticule_color_r"):GetInt(), GetConVar("cl_tfa_reticule_color_g"):GetInt(), GetConVar("cl_tfa_reticule_color_b"):GetInt(), 200))

                    local reticleMixer = vgui.Create("DColorMixer", DockGameplay)
                    reticleMixer:SetPos(TM.MenuScale(20), TM.MenuScale(270))
                    reticleMixer:SetSize(TM.MenuScale(215), TM.MenuScale(110))
                    reticleMixer:SetConVarR("cl_tfa_reticule_color_r")
                    reticleMixer:SetConVarG("cl_tfa_reticule_color_g")
                    reticleMixer:SetConVarB("cl_tfa_reticule_color_b")
                    reticleMixer:SetAlphaBar(false)
                    reticleMixer:SetPalette(false)
                    reticleMixer:SetWangs(true)
                    function reticleMixer:ValueChanged()
                        EotechPreview:SetImageColor(Color(GetConVar("cl_tfa_reticule_color_r"):GetInt(), GetConVar("cl_tfa_reticule_color_g"):GetInt(), GetConVar("cl_tfa_reticule_color_b"):GetInt(), 200))
                        KobraPreview:SetImageColor(Color(GetConVar("cl_tfa_reticule_color_r"):GetInt(), GetConVar("cl_tfa_reticule_color_g"):GetInt(), GetConVar("cl_tfa_reticule_color_b"):GetInt(), 200))
                        AimpointPreview:SetImageColor(Color(GetConVar("cl_tfa_reticule_color_r"):GetInt(), GetConVar("cl_tfa_reticule_color_g"):GetInt(), GetConVar("cl_tfa_reticule_color_b"):GetInt(), 200))
                    end

                    DockUI.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("INTERFACE", "OptionsHeader", TM.MenuScale(20), 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("HUD", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(65), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Notifications", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(105), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Damage Indicator", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(145), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Reload Hints", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(185), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Loadout Hints", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(225), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill Tracker", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(265), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Keypress Overlay", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(305), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Velocity Counter", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(345), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("VOIP Indicator", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(385), white, TEXT_ALIGN_LEFT)
                    end

                    local HUDtoggle = DockUI:Add("DCheckBox")
                    HUDtoggle:SetPos(TM.MenuScale(20), TM.MenuScale(70))
                    HUDtoggle:SetConVar("tm_hud_enable")
                    HUDtoggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function HUDtoggle:OnChange() TriggerSound("click") end

                    local notificationToggle = DockUI:Add("DCheckBox")
                    notificationToggle:SetPos(TM.MenuScale(20), TM.MenuScale(110))
                    notificationToggle:SetConVar("tm_hud_notifications")
                    notificationToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function notificationToggle:OnChange() TriggerSound("click") end

                    local dmgIndicatorToggle = DockUI:Add("DCheckBox")
                    dmgIndicatorToggle:SetPos(TM.MenuScale(20), TM.MenuScale(150))
                    dmgIndicatorToggle:SetConVar("tm_hud_dmgindicator")
                    dmgIndicatorToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function dmgIndicatorToggle:OnChange() TriggerSound("click") end

                    local reloadHintsToggle = DockUI:Add("DCheckBox")
                    reloadHintsToggle:SetPos(TM.MenuScale(20), TM.MenuScale(190))
                    reloadHintsToggle:SetConVar("tm_hud_reloadhint")
                    reloadHintsToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function reloadHintsToggle:OnChange() TriggerSound("click") end

                    local loadoutHintsToggle = DockUI:Add("DCheckBox")
                    loadoutHintsToggle:SetPos(TM.MenuScale(20), TM.MenuScale(230))
                    loadoutHintsToggle:SetConVar("tm_hud_loadouthint")
                    loadoutHintsToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function loadoutHintsToggle:OnChange() TriggerSound("click") end

                    local killTrackerToggle = DockUI:Add("DCheckBox")
                    killTrackerToggle:SetPos(TM.MenuScale(20), TM.MenuScale(270))
                    killTrackerToggle:SetConVar("tm_hud_killtracker")
                    killTrackerToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function killTrackerToggle:OnChange() TriggerSound("click") end

                    local keypressOverlayToggle = DockUI:Add("DCheckBox")
                    keypressOverlayToggle:SetPos(TM.MenuScale(20), TM.MenuScale(310))
                    keypressOverlayToggle:SetConVar("tm_hud_keypressoverlay")
                    keypressOverlayToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function keypressOverlayToggle:OnChange() TriggerSound("click") end

                    local VelocityCounterToggle = DockUI:Add("DCheckBox")
                    VelocityCounterToggle:SetPos(TM.MenuScale(20), TM.MenuScale(350))
                    VelocityCounterToggle:SetConVar("tm_hud_velocitycounter")
                    VelocityCounterToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function VelocityCounterToggle:OnChange() TriggerSound("click") end

                    local VoiceChatIndicatorToggle = DockUI:Add("DCheckBox")
                    VoiceChatIndicatorToggle:SetPos(TM.MenuScale(20), TM.MenuScale(390))
                    VoiceChatIndicatorToggle:SetConVar("tm_hud_voiceindicator")
                    VoiceChatIndicatorToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function VoiceChatIndicatorToggle:OnChange() TriggerSound("click") end

                    DockAudio.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("AUDIO", "OptionsHeader", TM.MenuScale(20), 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Menu SFX", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(65), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Music Volume", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(105), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker SFX", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(145), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill SFX", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(185), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker SFX Style", "SettingsLabel", TM.MenuScale(125), TM.MenuScale(225), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill SFX Style", "SettingsLabel", TM.MenuScale(125), TM.MenuScale(265), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Headshot Kill SFX Style", "SettingsLabel", TM.MenuScale(125), TM.MenuScale(305), white, TEXT_ALIGN_LEFT)
                    end

                    local menuSoundsButton = DockAudio:Add("DCheckBox")
                    menuSoundsButton:SetPos(TM.MenuScale(20), TM.MenuScale(70))
                    menuSoundsButton:SetConVar("tm_menusounds")
                    menuSoundsButton:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function menuSoundsButton:OnChange() TriggerSound("click") end

                    local musicVolume = DockAudio:Add("DNumSlider")
                    musicVolume:SetPos(TM.MenuScale(-85), TM.MenuScale(110))
                    musicVolume:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    musicVolume:SetConVar("tm_musicvolume")
                    musicVolume:SetMin(0)
                    musicVolume:SetMax(1)
                    musicVolume:SetDecimals(2)

                    local hitSoundsButton = DockAudio:Add("DCheckBox")
                    hitSoundsButton:SetPos(TM.MenuScale(20), TM.MenuScale(150))
                    hitSoundsButton:SetConVar("tm_hitsounds")
                    hitSoundsButton:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function hitSoundsButton:OnChange() TriggerSound("click") end

                    local killSoundButton = DockAudio:Add("DCheckBox")
                    killSoundButton:SetPos(TM.MenuScale(20), TM.MenuScale(190))
                    killSoundButton:SetConVar("tm_killsound")
                    killSoundButton:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function killSoundButton:OnChange() TriggerSound("click") end

                    local hitSoundsType = DockAudio:Add("DComboBox")
                    hitSoundsType:SetPos(TM.MenuScale(20), TM.MenuScale(230))
                    hitSoundsType:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    if GetConVar("tm_hitsoundtype"):GetInt() == 0 then hitSoundsType:SetValue("Rust") elseif GetConVar("tm_hitsoundtype"):GetInt() == 1 then hitSoundsType:SetValue("TABG") elseif GetConVar("tm_hitsoundtype"):GetInt() == 2 then hitSoundsType:SetValue("Apex Legends") elseif GetConVar("tm_hitsoundtype"):GetInt() == 3 then hitSoundsType:SetValue("Bad Business") elseif GetConVar("tm_hitsoundtype"):GetInt() == 4 then hitSoundsType:SetValue("Call Of Duty") elseif GetConVar("tm_hitsoundtype"):GetInt() == 5 then hitSoundsType:SetValue("Overwatch") end
                    hitSoundsType:AddChoice("Rust")
                    hitSoundsType:AddChoice("TABG")
                    hitSoundsType:AddChoice("Apex Legends")
                    hitSoundsType:AddChoice("Bad Business")
                    hitSoundsType:AddChoice("Call Of Duty")
                    hitSoundsType:AddChoice("Overwatch")
                    hitSoundsType.OnSelect = function(self, value)
                        surface.PlaySound("hitsound/hit_" .. value - 1 .. ".wav")
                        RunConsoleCommand("tm_hitsoundtype", value - 1)
                    end

                    local killSoundsType = DockAudio:Add("DComboBox")
                    killSoundsType:SetPos(TM.MenuScale(20), TM.MenuScale(270))
                    killSoundsType:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    if GetConVar("tm_killsoundtype"):GetInt() == 0 then killSoundsType:SetValue("Call Of Duty") elseif GetConVar("tm_killsoundtype"):GetInt() == 1 then killSoundsType:SetValue("TABG") elseif GetConVar("tm_killsoundtype"):GetInt() == 2 then killSoundsType:SetValue("Bad Business") elseif GetConVar("tm_killsoundtype"):GetInt() == 3 then killSoundsType:SetValue("Apex Legends") elseif GetConVar("tm_killsoundtype"):GetInt() == 4 then killSoundsType:SetValue("Counter Strike") elseif GetConVar("tm_killsoundtype"):GetInt() == 5 then killSoundsType:SetValue("Overwatch") end
                    killSoundsType:AddChoice("Call Of Duty")
                    killSoundsType:AddChoice("TABG")
                    killSoundsType:AddChoice("Bad Business")
                    killSoundsType:AddChoice("Apex Legends")
                    killSoundsType:AddChoice("Counter Strike")
                    killSoundsType:AddChoice("Overwatch")
                    killSoundsType.OnSelect = function(self, value)
                        surface.PlaySound("hitsound/kill_" .. value - 1 .. ".wav")
                        RunConsoleCommand("tm_killsoundtype", value - 1)
                    end

                    local headshotKillSoundsType = DockAudio:Add("DComboBox")
                    headshotKillSoundsType:SetPos(TM.MenuScale(20), TM.MenuScale(310))
                    headshotKillSoundsType:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    if GetConVar("tm_headshotkillsoundtype"):GetInt() == 0 then headshotKillSoundsType:SetValue("Call Of Duty") elseif GetConVar("tm_headshotkillsoundtype"):GetInt() == 1 then headshotKillSoundsType:SetValue("TABG") elseif GetConVar("tm_headshotkillsoundtype"):GetInt() == 2 then headshotKillSoundsType:SetValue("Bad Business") elseif GetConVar("tm_headshotkillsoundtype"):GetInt() == 3 then headshotKillSoundsType:SetValue("Apex Legends") elseif GetConVar("tm_headshotkillsoundtype"):GetInt() == 4 then headshotKillSoundsType:SetValue("Counter Strike") elseif GetConVar("tm_headshotkillsoundtype"):GetInt() == 5 then headshotKillSoundsType:SetValue("Overwatch") end
                    headshotKillSoundsType:AddChoice("Call Of Duty")
                    headshotKillSoundsType:AddChoice("TABG")
                    headshotKillSoundsType:AddChoice("Bad Business")
                    headshotKillSoundsType:AddChoice("Apex Legends")
                    headshotKillSoundsType:AddChoice("Counter Strike")
                    headshotKillSoundsType:AddChoice("Overwatch")
                    headshotKillSoundsType.OnSelect = function(self, value)
                        surface.PlaySound("hitsound/kill_" .. value - 1 .. ".wav")
                        RunConsoleCommand("tm_headshotkillsoundtype", value - 1)
                    end

                    DockCrosshair.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("CROSSHAIR", "OptionsHeader", TM.MenuScale(20), 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(65), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Show When Sprinting", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(105), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Style", "SettingsLabel", TM.MenuScale(125), TM.MenuScale(145), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Center Dot", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(185), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Length", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(225), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Thickness", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(265), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Gap", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(305), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Color/Opacity", "SettingsLabel", TM.MenuScale(245), TM.MenuScale(345), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Outline", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(465), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Outline Color", "SettingsLabel", TM.MenuScale(245), TM.MenuScale(505), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Top", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(625), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Bottom", "SettingsLabel", TM.MenuScale(155), TM.MenuScale(625), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Left", "SettingsLabel", TM.MenuScale(300), TM.MenuScale(625), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Right", "SettingsLabel", TM.MenuScale(395), TM.MenuScale(625), white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Click to cycle image", "QuoteText", TM.MenuScale(485), TM.MenuScale(225), white, TEXT_ALIGN_CENTER)
                    end

                    local crosshairToggle = DockCrosshair:Add("DCheckBox")
                    crosshairToggle:SetPos(TM.MenuScale(20), TM.MenuScale(70))
                    crosshairToggle:SetConVar("tm_hud_crosshair")
                    crosshairToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function crosshairToggle:OnChange() TriggerSound("click") end

                    local crosshairSprint = DockCrosshair:Add("DCheckBox")
                    crosshairSprint:SetPos(TM.MenuScale(20), TM.MenuScale(110))
                    crosshairSprint:SetConVar("tm_hud_crosshair_sprint")
                    crosshairSprint:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function crosshairSprint:OnChange() TriggerSound("click") end

                    local crosshairStyle = DockCrosshair:Add("DComboBox")
                    crosshairStyle:SetPos(TM.MenuScale(20), TM.MenuScale(150))
                    crosshairStyle:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                    if GetConVar("tm_hud_crosshair_style"):GetInt() == 0 then crosshairStyle:SetValue("Static") elseif GetConVar("tm_hud_crosshair_style"):GetInt() == 1 then crosshairStyle:SetValue("Dynamic") end
                    crosshairStyle:AddChoice("Static")
                    crosshairStyle:AddChoice("Dynamic")
                    crosshairStyle.OnSelect = function(self, value) RunConsoleCommand("tm_hud_crosshair_style", value - 1) TriggerSound("forward") end

                    local crosshairDot = DockCrosshair:Add("DCheckBox")
                    crosshairDot:SetPos(TM.MenuScale(20), TM.MenuScale(190))
                    crosshairDot:SetConVar("tm_hud_crosshair_dot")
                    crosshairDot:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function crosshairDot:OnChange() TriggerSound("click") end

                    local crosshairLength = DockCrosshair:Add("DNumSlider")
                    crosshairLength:SetPos(TM.MenuScale(-85), TM.MenuScale(230))
                    crosshairLength:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    crosshairLength:SetConVar("tm_hud_crosshair_size")
                    crosshairLength:SetMin(1)
                    crosshairLength:SetMax(50)
                    crosshairLength:SetDecimals(0)
                    function crosshairLength:OnValueChanged() end

                    local crosshairThickness = DockCrosshair:Add("DNumSlider")
                    crosshairThickness:SetPos(TM.MenuScale(-85), TM.MenuScale(270))
                    crosshairThickness:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    crosshairThickness:SetConVar("tm_hud_crosshair_thickness")
                    crosshairThickness:SetMin(1)
                    crosshairThickness:SetMax(50)
                    crosshairThickness:SetDecimals(0)
                    function crosshairThickness:OnValueChanged() end

                    local crosshairGap = DockCrosshair:Add("DNumSlider")
                    crosshairGap:SetPos(TM.MenuScale(-85), TM.MenuScale(310))
                    crosshairGap:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    crosshairGap:SetConVar("tm_hud_crosshair_gap")
                    crosshairGap:SetMin(0)
                    crosshairGap:SetMax(50)
                    crosshairGap:SetDecimals(0)
                    function crosshairGap:OnValueChanged() end

                    local crosshairMixer = vgui.Create("DColorMixer", DockCrosshair)
                    crosshairMixer:SetPos(TM.MenuScale(20), TM.MenuScale(350))
                    crosshairMixer:SetSize(TM.MenuScale(215), TM.MenuScale(110))
                    crosshairMixer:SetConVarR("tm_hud_crosshair_color_r")
                    crosshairMixer:SetConVarG("tm_hud_crosshair_color_g")
                    crosshairMixer:SetConVarB("tm_hud_crosshair_color_b")
                    crosshairMixer:SetConVarA("tm_hud_crosshair_opacity")
                    crosshairMixer:SetAlphaBar(true)
                    crosshairMixer:SetPalette(false)
                    crosshairMixer:SetWangs(true)

                    local crosshairOutline = DockCrosshair:Add("DCheckBox")
                    crosshairOutline:SetPos(TM.MenuScale(20), TM.MenuScale(470))
                    crosshairOutline:SetConVar("tm_hud_crosshair_outline")
                    crosshairOutline:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function crosshairOutline:OnChange() TriggerSound("click") end

                    local crosshairOutlineMixer = vgui.Create("DColorMixer", DockCrosshair)
                    crosshairOutlineMixer:SetPos(TM.MenuScale(20), TM.MenuScale(510))
                    crosshairOutlineMixer:SetSize(TM.MenuScale(215), TM.MenuScale(110))
                    crosshairOutlineMixer:SetConVarR("tm_hud_crosshair_outline_color_r")
                    crosshairOutlineMixer:SetConVarG("tm_hud_crosshair_outline_color_g")
                    crosshairOutlineMixer:SetConVarB("tm_hud_crosshair_outline_color_b")
                    crosshairOutlineMixer:SetAlphaBar(false)
                    crosshairOutlineMixer:SetPalette(false)
                    crosshairOutlineMixer:SetWangs(true)

                    local crosshairTop = DockCrosshair:Add("DCheckBox")
                    crosshairTop:SetPos(TM.MenuScale(20), TM.MenuScale(630))
                    crosshairTop:SetConVar("tm_hud_crosshair_show_t")
                    crosshairTop:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function crosshairTop:OnChange() TriggerSound("click") end

                    local crosshairBottom = DockCrosshair:Add("DCheckBox")
                    crosshairBottom:SetPos(TM.MenuScale(120), TM.MenuScale(630))
                    crosshairBottom:SetConVar("tm_hud_crosshair_show_b")
                    crosshairBottom:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function crosshairBottom:OnChange() TriggerSound("click") end

                    local crosshairLeft = DockCrosshair:Add("DCheckBox")
                    crosshairLeft:SetPos(TM.MenuScale(265), TM.MenuScale(630))
                    crosshairLeft:SetConVar("tm_hud_crosshair_show_l")
                    crosshairLeft:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function crosshairLeft:OnChange() TriggerSound("click") end

                    local crosshairRight = DockCrosshair:Add("DCheckBox")
                    crosshairRight:SetPos(TM.MenuScale(360), TM.MenuScale(630))
                    crosshairRight:SetConVar("tm_hud_crosshair_show_r")
                    crosshairRight:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function crosshairRight:OnChange() TriggerSound("click") end

                    local previewOpacitySlider = DockCrosshair:Add("DSlider")
                    previewOpacitySlider:SetPos(TM.MenuScale(410), TM.MenuScale(210))
                    previewOpacitySlider:SetSize(TM.MenuScale(150), TM.MenuScale(20))
                    previewOpacitySlider:SetSlideX(1)

                    local crosshairPreviewImage = DockCrosshair:Add("DImageButton")
                    crosshairPreviewImage:SetPos(TM.MenuScale(385), TM.MenuScale(10))
                    crosshairPreviewImage:SetSize(TM.MenuScale(200), TM.MenuScale(200))
                    crosshairPreviewImage:SetImage(previewImg)
                    crosshairPreviewImage.DoClick = function()
                        local imagePool = table.Copy(previewPool)
                        table.RemoveByValue(imagePool, previewImg)
                        previewImg = imagePool[math.random(#imagePool)]
                        crosshairPreviewImage:SetImage(previewImg)
                    end

                    local crosshair = {}
                    local dyn = 0
                    local smoothDyn = 0
                    local startDyn = 0
                    local newDyn = 0
                    local oldDyn = 0

                    local function UpdateCrosshair()
                        crosshair = {
                            ["enabled"] = GetConVar("tm_hud_crosshair"):GetInt(),
                            ["style"] = GetConVar("tm_hud_crosshair_style"):GetInt(),
                            ["gap"] = GetConVar("tm_hud_crosshair_gap"):GetInt(),
                            ["size"] = GetConVar("tm_hud_crosshair_size"):GetInt(),
                            ["thickness"] = GetConVar("tm_hud_crosshair_thickness"):GetInt(),
                            ["dot"] = GetConVar("tm_hud_crosshair_dot"):GetInt(),
                            ["outline"] = GetConVar("tm_hud_crosshair_outline"):GetInt(),
                            ["opacity"] = GetConVar("tm_hud_crosshair_opacity"):GetInt(),
                            ["r"] = GetConVar("tm_hud_crosshair_color_r"):GetInt(),
                            ["g"] = GetConVar("tm_hud_crosshair_color_g"):GetInt(),
                            ["b"] = GetConVar("tm_hud_crosshair_color_b"):GetInt(),
                            ["outline_r"] = GetConVar("tm_hud_crosshair_outline_color_r"):GetInt(),
                            ["outline_g"] = GetConVar("tm_hud_crosshair_outline_color_g"):GetInt(),
                            ["outline_b"] = GetConVar("tm_hud_crosshair_outline_color_b"):GetInt(),
                            ["show_t"] = GetConVar("tm_hud_crosshair_show_t"):GetInt(),
                            ["show_b"] = GetConVar("tm_hud_crosshair_show_b"):GetInt(),
                            ["show_l"] = GetConVar("tm_hud_crosshair_show_l"):GetInt(),
                            ["show_r"] = GetConVar("tm_hud_crosshair_show_r"):GetInt()
                        }
                        crosshairPreviewImage:SetColor(Color(255, 255, 255, previewOpacitySlider:GetSlideX() * 255))
                    end

                    local function LerpCrosshair()
                        smoothDyn = Lerp((SysTime() - startDyn ) / 0.07, oldDyn, newDyn)

                        if newDyn != dyn then
                            if (smoothDyn != dyn) then newDyn = smoothDyn end
                            oldDyn = newDyn
                            startDyn = SysTime()
                            newDyn = dyn
                        end
                    end

                    timer.Create("CrosshairDynamicPreview", 0.5, 0, function()
                        if crosshair["style"] == 1 then dyn = math.random(0, 10) else dyn = 0 end
                    end)

                    CrosshairPreview = vgui.Create("DPanel", DockCrosshair)
                    CrosshairPreview:SetSize(TM.MenuScale(200), TM.MenuScale(200))
                    CrosshairPreview:SetPos(TM.MenuScale(385), TM.MenuScale(10))
                    CrosshairPreview:SetMouseInputEnabled(false)
                    CrosshairPreview.Paint = function(self, w, h)
                        UpdateCrosshair()
                        LerpCrosshair()
                        if crosshair["outline"] == 1 then
                            surface.SetDrawColor(Color(crosshair["outline_r"], crosshair["outline_g"], crosshair["outline_b"], crosshair["opacity"]))
                            if crosshair["show_r"] == 1 then surface.DrawRect(w / 2 + (crosshair["gap"] + smoothDyn) - 1, h / 2 - math.floor(crosshair["thickness"] / 2) - 1, crosshair["size"] + 2,  crosshair["thickness"] + 2) end
                            if crosshair["show_l"] == 1 then surface.DrawRect(w / 2 - (crosshair["gap"] + smoothDyn) - crosshair["size"] + crosshair["thickness"] % 2 - 1, h / 2 - math.floor(crosshair["thickness"] / 2) - 1, crosshair["size"] + 2,  crosshair["thickness"] + 2) end
                            if crosshair["show_b"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2) - 1, h / 2 + (crosshair["gap"] + smoothDyn) - 1, crosshair["thickness"] + 2, crosshair["size"] + 2) end
                            if crosshair["show_t"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2) - 1, h / 2 - crosshair["size"] - (crosshair["gap"] + smoothDyn) + crosshair["thickness"] % 2 - 1, crosshair["thickness"] + 2, crosshair["size"] + 2) end
                            if crosshair["dot"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2) - 1, h / 2 - math.floor(crosshair["thickness"] / 2) - 1, crosshair["thickness"] + 2, crosshair["thickness"] + 2) end
                        end
                        surface.SetDrawColor(Color(crosshair["r"], crosshair["g"], crosshair["b"], crosshair["opacity"]))
                        if crosshair["show_r"] == 1 then surface.DrawRect(w / 2 + (crosshair["gap"] + smoothDyn), h / 2 - math.floor(crosshair["thickness"] / 2), crosshair["size"],  crosshair["thickness"]) end
                        if crosshair["show_l"] == 1 then surface.DrawRect(w / 2 - (crosshair["gap"] + smoothDyn) - crosshair["size"] + crosshair["thickness"] % 2, h / 2 - math.floor(crosshair["thickness"] / 2), crosshair["size"],  crosshair["thickness"]) end
                        if crosshair["show_b"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2), h / 2 + (crosshair["gap"] + smoothDyn), crosshair["thickness"], crosshair["size"]) end
                        if crosshair["show_t"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2), h / 2 - crosshair["size"] - (crosshair["gap"] + smoothDyn) + crosshair["thickness"] % 2, crosshair["thickness"], crosshair["size"]) end
                        if crosshair["dot"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2), h / 2 - math.floor(crosshair["thickness"] / 2), crosshair["thickness"], crosshair["thickness"]) end
                    end

                    DockHitmarker.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("HITMARKER", "OptionsHeader", TM.MenuScale(20), 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(65), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Length", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(105), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Thickness", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(145), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Gap", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(185), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Opacity", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(225), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Duration", "SettingsLabel", TM.MenuScale(170), TM.MenuScale(265), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hit Color", "SettingsLabel", TM.MenuScale(245), TM.MenuScale(305), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Headshot Color", "SettingsLabel", TM.MenuScale(245), TM.MenuScale(425), white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Click to show hitmarker", "QuoteText", TM.MenuScale(475), TM.MenuScale(215), white, TEXT_ALIGN_CENTER)
                    end

                    local hitmarkerToggle = DockHitmarker:Add("DCheckBox")
                    hitmarkerToggle:SetPos(TM.MenuScale(20), TM.MenuScale(70))
                    hitmarkerToggle:SetConVar("tm_hud_hitmarker")
                    hitmarkerToggle:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function hitmarkerToggle:OnChange() TriggerSound("click") end

                    local hitmarkerLength = DockHitmarker:Add("DNumSlider")
                    hitmarkerLength:SetPos(TM.MenuScale(-85), TM.MenuScale(110))
                    hitmarkerLength:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    hitmarkerLength:SetConVar("tm_hud_hitmarker_size")
                    hitmarkerLength:SetMin(1)
                    hitmarkerLength:SetMax(50)
                    hitmarkerLength:SetDecimals(0)
                    function hitmarkerLength:OnValueChanged() end

                    local hitmarkerThickness = DockHitmarker:Add("DNumSlider")
                    hitmarkerThickness:SetPos(TM.MenuScale(-85), TM.MenuScale(150))
                    hitmarkerThickness:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    hitmarkerThickness:SetConVar("tm_hud_hitmarker_thickness")
                    hitmarkerThickness:SetMin(1)
                    hitmarkerThickness:SetMax(20)
                    hitmarkerThickness:SetDecimals(0)
                    function hitmarkerThickness:OnValueChanged() end

                    local hitmarkerGap = DockHitmarker:Add("DNumSlider")
                    hitmarkerGap:SetPos(TM.MenuScale(-85), TM.MenuScale(190))
                    hitmarkerGap:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    hitmarkerGap:SetConVar("tm_hud_hitmarker_gap")
                    hitmarkerGap:SetMin(0)
                    hitmarkerGap:SetMax(50)
                    hitmarkerGap:SetDecimals(0)
                    function hitmarkerGap:OnValueChanged() end

                    local hitmarkerOpacity = DockHitmarker:Add("DNumSlider")
                    hitmarkerOpacity:SetPos(TM.MenuScale(-85), TM.MenuScale(230))
                    hitmarkerOpacity:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    hitmarkerOpacity:SetConVar("tm_hud_hitmarker_opacity")
                    hitmarkerOpacity:SetMin(0)
                    hitmarkerOpacity:SetMax(255)
                    hitmarkerOpacity:SetDecimals(0)
                    function hitmarkerOpacity:OnValueChanged() end

                    local hitmarkerDuration = DockHitmarker:Add("DNumSlider")
                    hitmarkerDuration:SetPos(TM.MenuScale(-85), TM.MenuScale(270))
                    hitmarkerDuration:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                    hitmarkerDuration:SetConVar("tm_hud_hitmarker_duration")
                    hitmarkerDuration:SetMin(1)
                    hitmarkerDuration:SetMax(5)
                    hitmarkerDuration:SetDecimals(1)
                    function hitmarkerDuration:OnValueChanged() end

                    local hitmarkerMixer = vgui.Create("DColorMixer", DockHitmarker)
                    hitmarkerMixer:SetPos(TM.MenuScale(20), TM.MenuScale(310))
                    hitmarkerMixer:SetSize(TM.MenuScale(215), TM.MenuScale(110))
                    hitmarkerMixer:SetConVarR("tm_hud_hitmarker_color_hit_r")
                    hitmarkerMixer:SetConVarG("tm_hud_hitmarker_color_hit_g")
                    hitmarkerMixer:SetConVarB("tm_hud_hitmarker_color_hit_b")
                    hitmarkerMixer:SetAlphaBar(false)
                    hitmarkerMixer:SetPalette(false)
                    hitmarkerMixer:SetWangs(true)

                    local hitmarkerHeadMixer = vgui.Create("DColorMixer", DockHitmarker)
                    hitmarkerHeadMixer:SetPos(TM.MenuScale(20), TM.MenuScale(430))
                    hitmarkerHeadMixer:SetSize(TM.MenuScale(215), TM.MenuScale(110))
                    hitmarkerHeadMixer:SetConVarR("tm_hud_hitmarker_color_head_r")
                    hitmarkerHeadMixer:SetConVarG("tm_hud_hitmarker_color_head_g")
                    hitmarkerHeadMixer:SetConVarB("tm_hud_hitmarker_color_head_b")
                    hitmarkerHeadMixer:SetAlphaBar(false)
                    hitmarkerHeadMixer:SetPalette(false)
                    hitmarkerHeadMixer:SetWangs(true)

                    local hitmarker = {}
                    local hitmarkerFade = 0
                    local hitColor = "hit"

                    local hitmarkerPreviewImage = DockHitmarker:Add("DImageButton")
                    hitmarkerPreviewImage:SetPos(TM.MenuScale(375), TM.MenuScale(10))
                    hitmarkerPreviewImage:SetSize(TM.MenuScale(200), TM.MenuScale(200))
                    hitmarkerPreviewImage:SetImage("images/preview/white.png")
                    hitmarkerPreviewImage:SetColor(Color(255, 255, 255, 0))
                    hitmarkerPreviewImage.DoClick = function()
                        hitmarkerFade = hitmarker["duration"]
                        if math.random(0, 1) == 0 then hitColor = "hit" else hitColor = "head" end
                    end

                    local function UpdateHitmarker()
                        hitmarker = {
                            ["enabled"] = GetConVar("tm_hud_hitmarker"):GetInt(),
                            ["gap"] = GetConVar("tm_hud_hitmarker_gap"):GetInt(),
                            ["size"] = GetConVar("tm_hud_hitmarker_size"):GetInt(),
                            ["thickness"] = GetConVar("tm_hud_hitmarker_thickness"):GetInt(),
                            ["opacity"] = GetConVar("tm_hud_hitmarker_opacity"):GetInt(),
                            ["duration"] = GetConVar("tm_hud_hitmarker_duration"):GetInt(),
                            ["hit_r"] = GetConVar("tm_hud_hitmarker_color_hit_r"):GetInt(),
                            ["hit_g"] = GetConVar("tm_hud_hitmarker_color_hit_g"):GetInt(),
                            ["hit_b"] = GetConVar("tm_hud_hitmarker_color_hit_b"):GetInt(),
                            ["head_r"] = GetConVar("tm_hud_hitmarker_color_head_r"):GetInt(),
                            ["head_g"] = GetConVar("tm_hud_hitmarker_color_head_g"):GetInt(),
                            ["head_b"] = GetConVar("tm_hud_hitmarker_color_head_b"):GetInt()
                        }
                    end
                    UpdateHitmarker()

                    HitmarkerPreview = vgui.Create("DFrame", DockHitmarker)
                    HitmarkerPreview:SetSize(TM.MenuScale(200), TM.MenuScale(200))
                    HitmarkerPreview:SetPos(TM.MenuScale(375), TM.MenuScale(10))
                    HitmarkerPreview:SetMouseInputEnabled(false)
                    HitmarkerPreview:SetTitle("")
                    HitmarkerPreview:SetDraggable(false)
                    HitmarkerPreview:ShowCloseButton(false)
                    HitmarkerPreview.Paint = function(self, w, h)
                        UpdateHitmarker()

                        hitmarkerFade = math.Clamp(hitmarkerFade - 7 * RealFrameTime(), 0, hitmarker["duration"])
                        surface.SetDrawColor(hitmarker[hitColor .. "_r"], hitmarker[hitColor .. "_g"], hitmarker[hitColor .. "_b"], hitmarker["opacity"] * math.min(1, hitmarkerFade))
                        draw.NoTexture()
                        surface.DrawTexturedRectRotated(w / 2 - hitmarker["gap"], h / 2 - hitmarker["gap"], hitmarker["thickness"] * math.min(1, hitmarkerFade), hitmarker["size"], 45)
                        surface.DrawTexturedRectRotated(w / 2 + hitmarker["gap"], h / 2 - hitmarker["gap"], hitmarker["thickness"] * math.min(1, hitmarkerFade), hitmarker["size"], 135)
                        surface.DrawTexturedRectRotated(w / 2 + hitmarker["gap"], h / 2 + hitmarker["gap"], hitmarker["thickness"] * math.min(1, hitmarkerFade), hitmarker["size"], 225)
                        surface.DrawTexturedRectRotated(w / 2 - hitmarker["gap"], h / 2 + hitmarker["gap"], hitmarker["thickness"] * math.min(1, hitmarkerFade), hitmarker["size"], 315)
                    end

                    DockPerformance.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("PERFORMANCE", "OptionsHeader", TM.MenuScale(20), 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Render Hands", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(65), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Lens Flare", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(105), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("ADS Depth Of Field", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(145), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Inspection Depth Of Field", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(185), white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Screen Flashing Effects", "SettingsLabel", TM.MenuScale(55), TM.MenuScale(225), white, TEXT_ALIGN_LEFT)
                    end

                    local renderHands = DockPerformance:Add("DCheckBox")
                    renderHands:SetPos(TM.MenuScale(20), TM.MenuScale(70))
                    renderHands:SetConVar("tm_renderhands")
                    renderHands:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function renderHands:OnChange() TriggerSound("click") end

                    local lensFlare = DockPerformance:Add("DCheckBox")
                    lensFlare:SetPos(TM.MenuScale(20), TM.MenuScale(110))
                    lensFlare:SetConVar("tm_lensflare")
                    lensFlare:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function lensFlare:OnChange() TriggerSound("click") end

                    local ironSightDOF = DockPerformance:Add("DCheckBox")
                    ironSightDOF:SetPos(TM.MenuScale(20), TM.MenuScale(150))
                    ironSightDOF:SetConVar("cl_tfa_fx_ads_dof")
                    ironSightDOF:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function ironSightDOF:OnChange() TriggerSound("click") end

                    local inspectionDOF = DockPerformance:Add("DCheckBox")
                    inspectionDOF:SetPos(TM.MenuScale(20), TM.MenuScale(190))
                    inspectionDOF:SetConVar("cl_tfa_inspection_bokeh")
                    inspectionDOF:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function inspectionDOF:OnChange() TriggerSound("click") end

                    local screenFlashing = DockPerformance:Add("DCheckBox")
                    screenFlashing:SetPos(TM.MenuScale(20), TM.MenuScale(230))
                    screenFlashing:SetConVar("tm_screenflashes")
                    screenFlashing:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                    function screenFlashing:OnChange() TriggerSound("click") end

                    local WipeAccountButton = vgui.Create("DButton", DockPerformance)
                    WipeAccountButton:SetPos(TM.MenuScale(17.5), TM.MenuScale(310))
                    WipeAccountButton:SetText("")
                    WipeAccountButton:SetSize(TM.MenuScale(500), TM.MenuScale(40))
                    local textAnim = 0
                    local wipeConfirm = 0
                    WipeAccountButton.Paint = function()
                        if WipeAccountButton:IsHovered() then
                            textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                        else
                            textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                        end
                        if (wipeConfirm == 0) then
                            draw.DrawText("WIPE PLAYER ACCOUNT", "SettingsLabel", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_LEFT)
                        else
                            draw.DrawText("ARE YOU SURE?", "SettingsLabel", TM.MenuScale(5) + TM.MenuScale(textAnim), TM.MenuScale(5), Color(255, 0, 0), TEXT_ALIGN_LEFT)
                        end
                    end
                    WipeAccountButton.DoClick = function()
                        TriggerSound("click")
                        if (wipeConfirm == 0) then
                            wipeConfirm = 1
                        else
                            RunConsoleCommand("tm_wipeplayeraccount_cannotbeundone")
                            wipeConfirm = 0
                        end

                        timer.Simple(1, function() wipeConfirm = 0 end)
                    end
                end
            end

            OptionsHUDButton.DoClick = function()
                if IsValid(FakeHUD) then return end
                MainPanel:AlphaTo(0, 0.05, 0, function() MainPanel:Hide() end)
                TriggerSound("click")

                local ShowHiddenOptions = false
                local modePool = {"FFA", "Cranked", "Gun Game", "KOTH", "VIP"}

                local mode = "FFA"
                local modeTime = "45"
                local modeTimeText = "0:45"
                local ggGuns = ggLadderSize
                local health = 100
                local ammo = 30
                local velocity = 350
                local wep = "KRISS Vector"
                local fakeFeedArray = {}
                local grappleMat = Material("icons/grapplehudicon.png")
                local nadeMat = Material("icons/grenadehudicon.png")
                local hillEmptyMat = Material("icons/kothempty.png")
                local border = Material("overlay/objborder.png")
                local timeText = " ∞"
                timer.Create("previewLoop", 1, 0, function()
                    mode = modePool[math.random(#modePool)]
                    modeTime = math.random(1, 45)
                    modeTimeText = "0:" .. modeTime
                    ggGuns = math.random(1, ggLadderSize)
                    health = math.random(1, 100)
                    ammo = math.random(1, 30)
                    velocity = math.random(0, 400)
                end)

                local FakeHUD = MainMenu:Add("HUDEditorPanel")
                FakeHUD:SetAlpha(0)
                FakeHUD:AlphaTo(255, 0.05, 0.025)
                MainMenu:SetMouseInputEnabled(false)
                FakeHUD.Paint = function(self, w, h)
                    convars = {
                        ["text_r"] = GetConVar("tm_hud_text_color_r"):GetInt(),
                        ["text_g"] = GetConVar("tm_hud_text_color_g"):GetInt(),
                        ["text_b"] = GetConVar("tm_hud_text_color_b"):GetInt()
                    }
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    if GetConVar("tm_hud_ammo_style"):GetInt() == 0 then
                        draw.SimpleText(wep, "HUD_GunPrintName", scrW - TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(50) - TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT)
                        if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(health .. " kills", "HUD_StreakText", scrW - TM.HUDScale(5) - TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(170) - TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT) end
                        draw.SimpleText(ammo, "HUD_AmmoCount", scrW - TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(165) - TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT)
                    elseif GetConVar("tm_hud_ammo_style"):GetInt() == 1 then
                        draw.SimpleText(wep, "HUD_GunPrintName", scrW - TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(90) - TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT)
                        if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(health .. " kills", "HUD_StreakText", scrW - TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(105) - TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT) end
                        surface.SetDrawColor(GetConVar("tm_hud_ammo_bar_color_r"):GetInt() - 205, GetConVar("tm_hud_ammo_bar_color_g"):GetInt() - 205, GetConVar("tm_hud_ammo_bar_color_b"):GetInt() - 205, 80)
                        surface.DrawRect(scrW - TM.HUDScale(400) - TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(30) - TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), TM.HUDScale(400), TM.HUDScale(30))
                        surface.SetDrawColor(GetConVar("tm_hud_ammo_bar_color_r"):GetInt(), GetConVar("tm_hud_ammo_bar_color_g"):GetInt(), GetConVar("tm_hud_ammo_bar_color_b"):GetInt(), 175)
                        surface.DrawRect(scrW - TM.HUDScale(400) - TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(30) - TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), TM.HUDScale(400) * (ammo / 30), TM.HUDScale(30))
                        draw.SimpleText(ammo, "HUD_Health", scrW - TM.HUDScale(390) - TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(30) - TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT)
                    end
                    surface.SetDrawColor(50, 50, 50, 80)
                    surface.DrawRect(TM.HUDScale(GetConVar("tm_hud_health_offset_x"):GetInt() + (GetConVar("tm_hud_bounds_x"):GetInt())), scrH - TM.HUDScale(30) - TM.HUDScale(GetConVar("tm_hud_health_offset_y"):GetInt() + (GetConVar("tm_hud_bounds_y"):GetInt())), TM.HUDScale(GetConVar("tm_hud_health_size"):GetInt()), TM.HUDScale(30))
                    if health <= 66 then
                        if health <= 33 then
                            surface.SetDrawColor(GetConVar("tm_hud_health_color_low_r"):GetInt(), GetConVar("tm_hud_health_color_low_g"):GetInt(), GetConVar("tm_hud_health_color_low_b"):GetInt(), 120)
                        else
                            surface.SetDrawColor(GetConVar("tm_hud_health_color_mid_r"):GetInt(), GetConVar("tm_hud_health_color_mid_g"):GetInt(), GetConVar("tm_hud_health_color_mid_b"):GetInt(), 120)
                        end
                    else
                        surface.SetDrawColor(GetConVar("tm_hud_health_color_high_r"):GetInt(), GetConVar("tm_hud_health_color_high_g"):GetInt(), GetConVar("tm_hud_health_color_high_b"):GetInt(), 120)
                    end
                    surface.DrawRect(TM.HUDScale(GetConVar("tm_hud_health_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(30) - TM.HUDScale(GetConVar("tm_hud_health_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()), TM.HUDScale(GetConVar("tm_hud_health_size"):GetInt()) * (health / 100), TM.HUDScale(30))
                    draw.SimpleText(health, "HUD_Health", TM.HUDScale(GetConVar("tm_hud_health_size"):GetInt()) + TM.HUDScale(GetConVar("tm_hud_health_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()) - TM.HUDScale(10), scrH - TM.HUDScale(30) - TM.HUDScale(GetConVar("tm_hud_health_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT)
                    local feedStyle
                    if GetConVar("tm_hud_killfeed_style"):GetInt() == 0 then
                        feedStyle = TM.HUDScale(-20)
                    else
                        feedStyle = TM.HUDScale(20)
                    end
                    surface.SetFont("HUD_StreakText")
                    for k, v in pairs(fakeFeedArray) do
                        if v[2] == 1 and v[2] != nil then surface.SetDrawColor(150, 50, 50, GetConVar("tm_hud_killfeed_opacity"):GetInt()) else surface.SetDrawColor(50, 50, 50, GetConVar("tm_hud_killfeed_opacity"):GetInt()) end
                        local nameLength = select(1, surface.GetTextSize(v[1]))

                        surface.DrawRect(TM.HUDScale(GetConVar("tm_hud_killfeed_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(20) + ((k - 1) * feedStyle) - TM.HUDScale(GetConVar("tm_hud_killfeed_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()), nameLength + TM.HUDScale(5), TM.HUDScale(20))
                        draw.SimpleText(v[1], "HUD_StreakText", TM.HUDScale(2.5) + TM.HUDScale(GetConVar("tm_hud_killfeed_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()), scrH - TM.HUDScale(22) + ((k - 1) * feedStyle) - TM.HUDScale(GetConVar("tm_hud_killfeed_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT)
                    end
                    surface.SetMaterial(grappleMat)
                    surface.SetDrawColor(255,255,255,255)
                    surface.DrawTexturedRect(TM.HUDScale(GetConVar("tm_hud_equipment_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()) - TM.HUDScale(45), scrH - TM.HUDScale(40) - TM.HUDScale(GetConVar("tm_hud_equipment_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()), TM.HUDScale(35), TM.HUDScale(40))
                    draw.SimpleText("[" .. string.upper(input.GetKeyName(GetConVar("frest_bindg"):GetInt())) .. "]", "HUD_StreakText", TM.HUDScale(GetConVar("tm_hud_equipment_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()) - TM.HUDScale(27.5), scrH - TM.HUDScale(65) - TM.HUDScale(GetConVar("tm_hud_equipment_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
                    surface.SetMaterial(nadeMat)
                    surface.SetDrawColor(255,255,255,255)
                    surface.DrawTexturedRect(TM.HUDScale(GetConVar("tm_hud_equipment_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()) + TM.HUDScale(10), scrH - TM.HUDScale(40) - TM.HUDScale(GetConVar("tm_hud_equipment_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()), TM.HUDScale(35), TM.HUDScale(40))
                    if GetConVar("tm_hud_keypressoverlay"):GetInt() == 1 then
                        local keyX = TM.HUDScale(GetConVar("tm_hud_keypressoverlay_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt())
                        local keyY = TM.HUDScale(GetConVar("tm_hud_keypressoverlay_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt())
                        local actuatedColor = Color(GetConVar("tm_hud_keypressoverlay_actuated_r"):GetInt(), GetConVar("tm_hud_keypressoverlay_actuated_g"):GetInt(), GetConVar("tm_hud_keypressoverlay_actuated_b"):GetInt())
                        local inactiveColor = Color(GetConVar("tm_hud_keypressoverlay_inactive_r"):GetInt(), GetConVar("tm_hud_keypressoverlay_inactive_g"):GetInt(), GetConVar("tm_hud_keypressoverlay_inactive_b"):GetInt())
                        local keyMat = Material("icons/keyicon.png")
                        local keyMatMed = Material("icons/keyiconmedium.png")
                        local keyMatLong = Material("icons/keyiconlong.png")
                        surface.SetMaterial(keyMat)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(TM.HUDScale(48) + keyX, 0 + keyY, TM.HUDScale(42), TM.HUDScale(42))
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(0 + keyX, TM.HUDScale(48) + keyY, TM.HUDScale(42), TM.HUDScale(42))
                        surface.SetDrawColor(inactiveColor)
                        surface.DrawTexturedRect(TM.HUDScale(48) + keyX, TM.HUDScale(48) + keyY, TM.HUDScale(42), TM.HUDScale(42))
                        surface.SetDrawColor(inactiveColor)
                        surface.DrawTexturedRect(TM.HUDScale(96) + keyX, TM.HUDScale(48) + keyY, TM.HUDScale(42), TM.HUDScale(42))
                        surface.SetMaterial(keyMatLong)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(0 + keyX, TM.HUDScale(96) + keyY, TM.HUDScale(138), TM.HUDScale(42))
                        surface.SetMaterial(keyMatMed)
                        surface.SetDrawColor(inactiveColor)
                        surface.DrawTexturedRect(0 + keyX, TM.HUDScale(144) + keyY, TM.HUDScale(66), TM.HUDScale(42))
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(TM.HUDScale(72) + keyX, TM.HUDScale(144) + keyY, TM.HUDScale(66), TM.HUDScale(42))
                        draw.SimpleText("W", "HUD_StreakText", TM.HUDScale(69) + keyX, TM.HUDScale(10) + keyY, actuatedColor, TEXT_ALIGN_CENTER)
                        draw.SimpleText("A", "HUD_StreakText", TM.HUDScale(21) + keyX, TM.HUDScale(58) + keyY, actuatedColor, TEXT_ALIGN_CENTER)
                        draw.SimpleText("S", "HUD_StreakText", TM.HUDScale(69) + keyX, TM.HUDScale(58) + keyY, inactiveColor, TEXT_ALIGN_CENTER)
                        draw.SimpleText("D", "HUD_StreakText", TM.HUDScale(117) + keyX, TM.HUDScale(58) + keyY, inactiveColor, TEXT_ALIGN_CENTER)
                        draw.SimpleText("JUMP", "HUD_StreakText", TM.HUDScale(69) + keyX, TM.HUDScale(106) + keyY, actuatedColor, TEXT_ALIGN_CENTER)
                        draw.SimpleText("RUN", "HUD_StreakText", TM.HUDScale(33) + keyX, TM.HUDScale(154) + keyY, inactiveColor, TEXT_ALIGN_CENTER)
                        draw.SimpleText("DUCK", "HUD_StreakText", TM.HUDScale(105) + keyX, TM.HUDScale(154) + keyY, actuatedColor, TEXT_ALIGN_CENTER)
                    end
                    if GetConVar("tm_hud_velocitycounter"):GetInt() == 1 then
                        draw.SimpleText(velocity .. " u/s", "HUD_Health", TM.HUDScale(GetConVar("tm_hud_velocitycounter_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()), TM.HUDScale(GetConVar("tm_hud_velocitycounter_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    end
                    timeText = string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime() + 1), "%2i:%02i")
                    draw.SimpleText(mode .. " |" .. timeText, "HUD_Health", scrW / 2, TM.HUDScale(-5) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)

                    if mode == "Gun Game" then
                        draw.SimpleText(ggGuns  .. " kills left", "HUD_Health", scrW / 2, TM.HUDScale(25) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
                    elseif mode == "Fiesta" then
                        draw.SimpleText(modeTimeText, "HUD_Health", scrW / 2, TM.HUDScale(25) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
                    elseif mode == "Cranked" then
                        draw.SimpleText(modeTime, "HUD_Health", scrW / 2, TM.HUDScale(25) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
                        surface.SetDrawColor(50, 50, 50, 80)
                        surface.DrawRect(scrW / 2 - TM.HUDScale(75), TM.HUDScale(60) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), TM.HUDScale(150), TM.HUDScale(10))
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_contested_r"):GetInt(), GetConVar("tm_hud_obj_color_contested_g"):GetInt(), GetConVar("tm_hud_obj_color_contested_b"):GetInt(), 80)
                        surface.DrawRect(scrW / 2 - TM.HUDScale(75), TM.HUDScale(60) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), TM.HUDScale(150) * (modeTime / 45), TM.HUDScale(10))
                    elseif mode == "KOTH" then
                        draw.SimpleText("Contested", "HUD_Health", scrW / 2, TM.HUDScale(25) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_contested_r"):GetInt(), GetConVar("tm_hud_obj_color_contested_g"):GetInt(), GetConVar("tm_hud_obj_color_contested_b"):GetInt(), 100)
                        surface.SetMaterial(hillEmptyMat)
                        surface.DrawTexturedRect(scrW / 2 - TM.HUDScale(21), TM.HUDScale(60) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), TM.HUDScale(42), TM.HUDScale(42))
                        surface.SetMaterial(border)
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_contested_r"):GetInt(), GetConVar("tm_hud_obj_color_contested_g"):GetInt(), GetConVar("tm_hud_obj_color_contested_b"):GetInt(), 175)
                        surface.DrawTexturedRect(0, 0, scrW, scrH)
                    elseif mode == "VIP" then
                        draw.SimpleText(LocalPly:GetName(), "HUD_Health", scrW / 2, TM.HUDScale(25) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_occupied_r"):GetInt(), GetConVar("tm_hud_obj_color_occupied_g"):GetInt(), GetConVar("tm_hud_obj_color_occupied_b"):GetInt(), 225)
                        surface.SetMaterial(hillEmptyMat)
                        surface.DrawTexturedRect(scrW / 2 - TM.HUDScale(24), TM.HUDScale(57) + TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()), TM.HUDScale(48), TM.HUDScale(48))
                        surface.SetMaterial(border)
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_occupied_r"):GetInt(), GetConVar("tm_hud_obj_color_occupied_g"):GetInt(), GetConVar("tm_hud_obj_color_occupied_b"):GetInt(), 175)
                        surface.DrawTexturedRect(0, 0, scrW, scrH)
                    end
                end

                local EditorPanel = vgui.Create("DFrame", FakeHUD)
                EditorPanel:SetSize(TM.MenuScale(435), TM.MenuScale(756))
                EditorPanel:MakePopup()
                EditorPanel:SetTitle("")
                EditorPanel:Center()
                EditorPanel:SetScreenLock(true)
                EditorPanel:GetBackgroundBlur(false)
                EditorPanel.Paint = function(self, w, h)
                    BlurPanel(EditorPanel, 2)
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                end
                EditorPanel.OnClose = function()
                    TriggerSound("back")
                    MainMenu:SetMouseInputEnabled(true)
                    FakeHUD:AlphaTo(0, 0.05, 0, function() FakeHUD:Hide() end)
                    MainPanel:Show()
                    MainPanel:AlphaTo(255, 0.05, 0.025)
                    timer.Remove("previewLoop")
                    hook.Remove("Tick", "KeyOverlayTracking")
                    UpdateHUD()
                end

                local EditorScroller = vgui.Create("DScrollPanel", EditorPanel)
                EditorScroller:Dock(FILL)

                local sbar = EditorScroller:GetVBar()
                sbar:SetHideButtons(true)
                sbar:SetSize(TM.MenuScale(15), TM.MenuScale(15))
                function sbar:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                end
                function sbar.btnGrip:Paint(w, h)
                    draw.RoundedBox(0, TM.MenuScale(5), TM.MenuScale(8), TM.MenuScale(5), h - TM.MenuScale(16), Color(255, 255, 255, 175))
                end

                local HiddenOptionsScroller = vgui.Create("DPanel", EditorPanel)
                HiddenOptionsScroller:Dock(FILL)

                HiddenOptionsScroller.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 5))
                end

                local GeneralEditor = vgui.Create("DPanel", EditorScroller)
                GeneralEditor:Dock(TOP)
                GeneralEditor:SetSize(0, TM.MenuScale(290))
                GeneralEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("GENERAL", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("HUD Scale", "Health", TM.MenuScale(165), TM.MenuScale(50), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("HUD Font", "Health", TM.MenuScale(125), TM.MenuScale(90), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("HUD X Bounds", "Health", TM.MenuScale(165), TM.MenuScale(130), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("HUD Y Bounds", "Health", TM.MenuScale(165), TM.MenuScale(170), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Text Color", "Health", TM.MenuScale(210), TM.MenuScale(205), white, TEXT_ALIGN_LEFT)
                end

                local HUDScale = GeneralEditor:Add("DNumSlider")
                HUDScale:SetPos(TM.MenuScale(-85), TM.MenuScale(50))
                HUDScale:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                HUDScale:SetConVar("tm_hud_scale")
                HUDScale:SetMin(0.5)
                HUDScale:SetMax(2)
                HUDScale:SetDecimals(2)

                local HUDFont = GeneralEditor:Add("DComboBox")
                HUDFont:SetPos(TM.MenuScale(20), TM.MenuScale(90))
                HUDFont:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                HUDFont:SetValue(GetConVar("tm_hud_font"):GetString())
                HUDFont:AddChoice("Arial")
                HUDFont:AddChoice("Comic Sans MS")
                HUDFont:AddChoice("Tahoma")
                HUDFont:AddChoice("Roboto")
                HUDFont:AddChoice("Impact")
                HUDFont:AddChoice("Times New Roman")
                HUDFont:AddChoice("Trebuchet MS")
                HUDFont:AddChoice("VCR OSD Mono")
                HUDFont:AddChoice("Bender")
                HUDFont:AddChoice("Gravity")
                HUDFont.OnSelect = function(self, index, value)
                    surface.PlaySound("tmui/buttonrollover.wav")
                    RunConsoleCommand("tm_hud_font", value)
                    TriggerSound("forward")
                end

                local CustomFontInput = GeneralEditor:Add("DTextEntry")
                CustomFontInput:SetPlaceholderText("Enter a custom font...")
                CustomFontInput:SetPos(TM.MenuScale(275), TM.MenuScale(90))
                CustomFontInput:SetSize(TM.MenuScale(125), TM.MenuScale(30))
                CustomFontInput.OnEnter = function(self)
                    RunConsoleCommand("tm_hud_font", self:GetValue())
                    HUDFont:SetValue(self:GetValue())
                    TriggerSound("forward")
                end

                local HUDXBounds = GeneralEditor:Add("DNumSlider")
                HUDXBounds:SetPos(TM.MenuScale(-85), TM.MenuScale(130))
                HUDXBounds:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                HUDXBounds:SetConVar("tm_hud_bounds_x")
                HUDXBounds:SetMin(0)
                HUDXBounds:SetMax(480)
                HUDXBounds:SetDecimals(0)

                local HUDYBounds = GeneralEditor:Add("DNumSlider")
                HUDYBounds:SetPos(TM.MenuScale(-85), TM.MenuScale(170))
                HUDYBounds:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                HUDYBounds:SetConVar("tm_hud_bounds_y")
                HUDYBounds:SetMin(0)
                HUDYBounds:SetMax(270)
                HUDYBounds:SetDecimals(0)

                local WepTextColor = vgui.Create("DColorMixer", GeneralEditor)
                WepTextColor:SetPos(TM.MenuScale(20), TM.MenuScale(210))
                WepTextColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                WepTextColor:SetConVarR("tm_hud_text_color_r")
                WepTextColor:SetConVarG("tm_hud_text_color_g")
                WepTextColor:SetConVarB("tm_hud_text_color_b")
                WepTextColor:SetAlphaBar(false)
                WepTextColor:SetPalette(false)
                WepTextColor:SetWangs(true)

                local AmmoEditor = vgui.Create("DPanel", EditorScroller)
                AmmoEditor:Dock(TOP)
                AmmoEditor:SetSize(0, TM.MenuScale(170))
                AmmoEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("AMMO", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Style", "Health", TM.MenuScale(125), TM.MenuScale(50), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar Color", "Health", TM.MenuScale(210), TM.MenuScale(85), white, TEXT_ALIGN_LEFT)
                end

                local AmmoStyle = AmmoEditor:Add("DComboBox")
                AmmoStyle:SetPos(TM.MenuScale(20), TM.MenuScale(50))
                AmmoStyle:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                if GetConVar("tm_hud_ammo_style"):GetInt() == 0 then
                    AmmoStyle:SetValue("Numeric")
                elseif GetConVar("tm_hud_ammo_style"):GetInt() == 1 then
                    AmmoStyle:SetValue("Bar")
                end
                AmmoStyle:AddChoice("Numeric")
                AmmoStyle:AddChoice("Bar")
                AmmoStyle.OnSelect = function(self, value)
                    surface.PlaySound("tmui/buttonrollover.wav")
                    RunConsoleCommand("tm_hud_ammo_style", value - 1)
                    TriggerSound("forward")
                end

                local AmmoBarColor = vgui.Create("DColorMixer", AmmoEditor)
                AmmoBarColor:SetPos(TM.MenuScale(20), TM.MenuScale(90))
                AmmoBarColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                AmmoBarColor:SetConVarR("tm_hud_ammo_bar_color_r")
                AmmoBarColor:SetConVarG("tm_hud_ammo_bar_color_g")
                AmmoBarColor:SetConVarB("tm_hud_ammo_bar_color_b")
                AmmoBarColor:SetAlphaBar(false)
                AmmoBarColor:SetPalette(false)
                AmmoBarColor:SetWangs(true)

                local HealthEditor = vgui.Create("DPanel", EditorScroller)
                HealthEditor:Dock(TOP)
                HealthEditor:SetSize(0, TM.MenuScale(390))
                HealthEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("HEALTH", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar Size", "Health", TM.MenuScale(165), TM.MenuScale(50), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar X Offset", "Health", TM.MenuScale(165), TM.MenuScale(80), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar Y Offset", "Health", TM.MenuScale(165), TM.MenuScale(110), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("High HP Color", "Health", TM.MenuScale(210), TM.MenuScale(145), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Mid HP Color", "Health", TM.MenuScale(210), TM.MenuScale(225), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Low HP Color", "Health", TM.MenuScale(210), TM.MenuScale(305), white, TEXT_ALIGN_LEFT)
                end

                local HealthBarSize = HealthEditor:Add("DNumSlider")
                HealthBarSize:SetPos(TM.MenuScale(-85), TM.MenuScale(50))
                HealthBarSize:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                HealthBarSize:SetConVar("tm_hud_health_size")
                HealthBarSize:SetMin(100)
                HealthBarSize:SetMax(1000)
                HealthBarSize:SetDecimals(0)

                local HealthBarX = HealthEditor:Add("DNumSlider")
                HealthBarX:SetPos(TM.MenuScale(-85), TM.MenuScale(80))
                HealthBarX:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                HealthBarX:SetConVar("tm_hud_health_offset_x")
                HealthBarX:SetMin(0)
                HealthBarX:SetMax(1920)
                HealthBarX:SetDecimals(0)

                local HealthBarY = HealthEditor:Add("DNumSlider")
                HealthBarY:SetPos(TM.MenuScale(-85), TM.MenuScale(110))
                HealthBarY:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                HealthBarY:SetConVar("tm_hud_health_offset_y")
                HealthBarY:SetMin(0)
                HealthBarY:SetMax(1080)
                HealthBarY:SetDecimals(0)

                local HealthHighColor = vgui.Create("DColorMixer", HealthEditor)
                HealthHighColor:SetPos(TM.MenuScale(20), TM.MenuScale(150))
                HealthHighColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                HealthHighColor:SetConVarR("tm_hud_health_color_high_r")
                HealthHighColor:SetConVarG("tm_hud_health_color_high_g")
                HealthHighColor:SetConVarB("tm_hud_health_color_high_b")
                HealthHighColor:SetAlphaBar(false)
                HealthHighColor:SetPalette(false)
                HealthHighColor:SetWangs(true)

                local HealthMidColor = vgui.Create("DColorMixer", HealthEditor)
                HealthMidColor:SetPos(TM.MenuScale(20), TM.MenuScale(230))
                HealthMidColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                HealthMidColor:SetConVarR("tm_hud_health_color_mid_r")
                HealthMidColor:SetConVarG("tm_hud_health_color_mid_g")
                HealthMidColor:SetConVarB("tm_hud_health_color_mid_b")
                HealthMidColor:SetAlphaBar(false)
                HealthMidColor:SetPalette(false)
                HealthMidColor:SetWangs(true)

                local HealthLowColor = vgui.Create("DColorMixer", HealthEditor)
                HealthLowColor:SetPos(TM.MenuScale(20), TM.MenuScale(310))
                HealthLowColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                HealthLowColor:SetConVarR("tm_hud_health_color_low_r")
                HealthLowColor:SetConVarG("tm_hud_health_color_low_g")
                HealthLowColor:SetConVarB("tm_hud_health_color_low_b")
                HealthLowColor:SetAlphaBar(false)
                HealthLowColor:SetPalette(false)
                HealthLowColor:SetWangs(true)

                local EquipmentEditor = vgui.Create("DPanel", EditorScroller)
                EquipmentEditor:Dock(TOP)
                EquipmentEditor:SetSize(TM.MenuScale(0), TM.MenuScale(150))
                EquipmentEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("EQUIPMENT UI", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Equipment Anchoring", "Health", TM.MenuScale(150), TM.MenuScale(50), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Equipment X Offset", "Health", TM.MenuScale(165), TM.MenuScale(80), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Equipment Y Offset", "Health", TM.MenuScale(165), TM.MenuScale(110), white, TEXT_ALIGN_LEFT)
                end

                local EquipmentAnchor = EquipmentEditor:Add("DComboBox")
                EquipmentAnchor:SetPos(TM.MenuScale(20), TM.MenuScale(50))
                EquipmentAnchor:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                if GetConVar("tm_hud_equipment_anchor"):GetInt() == 0 then
                    EquipmentAnchor:SetValue("Left")
                elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 1 then
                    EquipmentAnchor:SetValue("Center")
                elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 2 then
                    EquipmentAnchor:SetValue("Right")
                end
                EquipmentAnchor:AddChoice("Left")
                EquipmentAnchor:AddChoice("Center")
                EquipmentAnchor:AddChoice("Right")
                EquipmentAnchor.OnSelect = function(self, value)
                    surface.PlaySound("tmui/buttonrollover.wav")
                    RunConsoleCommand("tm_hud_equipment_anchor", value - 1)
                    TriggerSound("forward")
                end

                local EquipmentX = EquipmentEditor:Add("DNumSlider")
                EquipmentX:SetPos(TM.MenuScale(-85), TM.MenuScale(80))
                EquipmentX:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                EquipmentX:SetConVar("tm_hud_equipment_offset_x")
                EquipmentX:SetMin(0)
                EquipmentX:SetMax(1920)
                EquipmentX:SetDecimals(0)

                local EquipmentY = EquipmentEditor:Add("DNumSlider")
                EquipmentY:SetPos(TM.MenuScale(-85), TM.MenuScale(110))
                EquipmentY:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                EquipmentY:SetConVar("tm_hud_equipment_offset_y")
                EquipmentY:SetMin(0)
                EquipmentY:SetMax(1080)
                EquipmentY:SetDecimals(0)

                local KillFeedEditor = vgui.Create("DPanel", EditorScroller)
                KillFeedEditor:Dock(TOP)
                KillFeedEditor:SetSize(0, TM.MenuScale(245))
                KillFeedEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("KILL FEED", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Enable Kill Feed", "Health", TM.MenuScale(55), TM.MenuScale(50), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Entry Style", "Health", TM.MenuScale(125), TM.MenuScale(85), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Item Limit", "Health", TM.MenuScale(165), TM.MenuScale(115), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed X Offset", "Health", TM.MenuScale(165), TM.MenuScale(145), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Y Offset", "Health", TM.MenuScale(165), TM.MenuScale(175), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Opacity", "Health", TM.MenuScale(165), TM.MenuScale(205), white, TEXT_ALIGN_LEFT)
                end

                local AddFeedEntryButton = vgui.Create("DButton", KillFeedEditor)
                AddFeedEntryButton:SetPos(TM.MenuScale(190), TM.MenuScale(17.5))
                AddFeedEntryButton:SetText("")
                AddFeedEntryButton:SetSize(TM.MenuScale(145), TM.MenuScale(40))
                local textAnim = 0
                AddFeedEntryButton.Paint = function()
                    if AddFeedEntryButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Add Feed Entry", "StreakText", 0 + TM.MenuScale(textAnim), 0, white, TEXT_ALIGN_LEFT)
                end
                AddFeedEntryButton.DoClick = function()
                    if GetConVar("tm_hud_enablekillfeed"):GetInt() == 0 then return end
                    local playersInAction = LocalPly:Name() .. " killed " .. math.random(1, 1000)
                    local victimLastHitIn = math.random(0, 1)

                    table.insert(fakeFeedArray, {playersInAction, victimLastHitIn})
                    if table.Count(fakeFeedArray) >= (GetConVar("tm_hud_killfeed_limit"):GetInt() + 1) then table.remove(fakeFeedArray, 1) end
                end

                local EnableKillFeed = KillFeedEditor:Add("DCheckBox")
                EnableKillFeed:SetPos(TM.MenuScale(20), TM.MenuScale(50))
                EnableKillFeed:SetConVar("tm_hud_enablekillfeed")
                EnableKillFeed:SetSize(TM.MenuScale(30), TM.MenuScale(30))
                function EnableKillFeed:OnChange() TriggerSound("click") end

                local KillFeedStyle = KillFeedEditor:Add("DComboBox")
                KillFeedStyle:SetPos(TM.MenuScale(20), TM.MenuScale(85))
                KillFeedStyle:SetSize(TM.MenuScale(100), TM.MenuScale(30))
                if GetConVar("tm_hud_killfeed_style"):GetInt() == 0 then
                    KillFeedStyle:SetValue("Ascending")
                elseif GetConVar("tm_hud_killfeed_style"):GetInt() == 1 then
                    KillFeedStyle:SetValue("Descending")
                end
                KillFeedStyle:AddChoice("Ascending")
                KillFeedStyle:AddChoice("Descending")
                KillFeedStyle.OnSelect = function(self, value)
                    surface.PlaySound("tmui/buttonrollover.wav")
                    RunConsoleCommand("tm_hud_killfeed_style", value - 1)
                    TriggerSound("forward")
                end

                local KillFeedItemLimit = KillFeedEditor:Add("DNumSlider")
                KillFeedItemLimit:SetPos(TM.MenuScale(-85), TM.MenuScale(115))
                KillFeedItemLimit:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                KillFeedItemLimit:SetConVar("tm_hud_killfeed_limit")
                KillFeedItemLimit:SetMin(1)
                KillFeedItemLimit:SetMax(10)
                KillFeedItemLimit:SetDecimals(0)

                local KillFeedX = KillFeedEditor:Add("DNumSlider")
                KillFeedX:SetPos(TM.MenuScale(-85), TM.MenuScale(145))
                KillFeedX:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                KillFeedX:SetConVar("tm_hud_killfeed_offset_x")
                KillFeedX:SetMin(0)
                KillFeedX:SetMax(1920)
                KillFeedX:SetDecimals(0)

                local KillFeedY = KillFeedEditor:Add("DNumSlider")
                KillFeedY:SetPos(TM.MenuScale(-85), TM.MenuScale(175))
                KillFeedY:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                KillFeedY:SetConVar("tm_hud_killfeed_offset_y")
                KillFeedY:SetMin(0)
                KillFeedY:SetMax(1080)
                KillFeedY:SetDecimals(0)

                local KillFeedOpacity = KillFeedEditor:Add("DNumSlider")
                KillFeedOpacity:SetPos(TM.MenuScale(-85), TM.MenuScale(205))
                KillFeedOpacity:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                KillFeedOpacity:SetConVar("tm_hud_killfeed_opacity")
                KillFeedOpacity:SetMin(0)
                KillFeedOpacity:SetMax(255)
                KillFeedOpacity:SetDecimals(0)

                local KillDeathEditor
                KillDeathEditor = vgui.Create("DPanel", EditorScroller)
                KillDeathEditor:Dock(TOP)
                KillDeathEditor:SetSize(0, TM.MenuScale(200))
                KillDeathEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("KILL/DEATH UI", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("UI X Offset", "Health", TM.MenuScale(165), TM.MenuScale(50), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("UI Y Offset", "Health", TM.MenuScale(165), TM.MenuScale(80), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Kill Icon Color", "Health", TM.MenuScale(210), TM.MenuScale(115), white, TEXT_ALIGN_LEFT)
                end

                local KillDeathX = KillDeathEditor:Add("DNumSlider")
                KillDeathX:SetPos(TM.MenuScale(-85), TM.MenuScale(50))
                KillDeathX:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                KillDeathX:SetConVar("tm_hud_killdeath_offset_x")
                KillDeathX:SetMin(-960)
                KillDeathX:SetMax(960)
                KillDeathX:SetDecimals(0)

                local KillDeathY = KillDeathEditor:Add("DNumSlider")
                KillDeathY:SetPos(TM.MenuScale(-85), TM.MenuScale(80))
                KillDeathY:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                KillDeathY:SetConVar("tm_hud_killdeath_offset_y")
                KillDeathY:SetMin(0)
                KillDeathY:SetMax(1080)
                KillDeathY:SetDecimals(0)

                local KillColor = vgui.Create("DColorMixer", KillDeathEditor)
                KillColor:SetPos(TM.MenuScale(20), TM.MenuScale(120))
                KillColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                KillColor:SetConVarR("tm_hud_kill_iconcolor_r")
                KillColor:SetConVarG("tm_hud_kill_iconcolor_g")
                KillColor:SetConVarB("tm_hud_kill_iconcolor_b")
                KillColor:SetAlphaBar(false)
                KillColor:SetPalette(false)
                KillColor:SetWangs(true)

                local ObjectiveEditor
                ObjectiveEditor = vgui.Create("DPanel", EditorScroller)
                ObjectiveEditor:Dock(TOP)
                ObjectiveEditor:SetSize(0, TM.MenuScale(330))
                ObjectiveEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("OBJECTIVE UI", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("OBJ Text Scale", "Health", TM.MenuScale(165), TM.MenuScale(50), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Empty Color", "Health", TM.MenuScale(210), TM.MenuScale(85), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Occupied Color", "Health", TM.MenuScale(210), TM.MenuScale(165), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Contested Color", "Health", TM.MenuScale(210), TM.MenuScale(245), white, TEXT_ALIGN_LEFT)
                end

                local ObjScale = ObjectiveEditor:Add("DNumSlider")
                ObjScale:SetPos(TM.MenuScale(-85), TM.MenuScale(50))
                ObjScale:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                ObjScale:SetConVar("tm_hud_obj_scale")
                ObjScale:SetMin(0.5)
                ObjScale:SetMax(3.0)
                ObjScale:SetDecimals(2)

                local ObjEmptyBrushColor = vgui.Create("DColorMixer", ObjectiveEditor)
                ObjEmptyBrushColor:SetPos(TM.MenuScale(20), TM.MenuScale(90))
                ObjEmptyBrushColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                ObjEmptyBrushColor:SetConVarR("tm_hud_obj_color_empty_r")
                ObjEmptyBrushColor:SetConVarG("tm_hud_obj_color_empty_g")
                ObjEmptyBrushColor:SetConVarB("tm_hud_obj_color_empty_b")
                ObjEmptyBrushColor:SetAlphaBar(false)
                ObjEmptyBrushColor:SetPalette(false)
                ObjEmptyBrushColor:SetWangs(true)

                local ObjOccupiedBrushColor = vgui.Create("DColorMixer", ObjectiveEditor)
                ObjOccupiedBrushColor:SetPos(TM.MenuScale(20), TM.MenuScale(170))
                ObjOccupiedBrushColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                ObjOccupiedBrushColor:SetConVarR("tm_hud_obj_color_occupied_r")
                ObjOccupiedBrushColor:SetConVarG("tm_hud_obj_color_occupied_g")
                ObjOccupiedBrushColor:SetConVarB("tm_hud_obj_color_occupied_b")
                ObjOccupiedBrushColor:SetAlphaBar(false)
                ObjOccupiedBrushColor:SetPalette(false)
                ObjOccupiedBrushColor:SetWangs(true)

                local ObjContestedBrushColor = vgui.Create("DColorMixer", ObjectiveEditor)
                ObjContestedBrushColor:SetPos(TM.MenuScale(20), TM.MenuScale(250))
                ObjContestedBrushColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                ObjContestedBrushColor:SetConVarR("tm_hud_obj_color_contested_r")
                ObjContestedBrushColor:SetConVarG("tm_hud_obj_color_contested_g")
                ObjContestedBrushColor:SetConVarB("tm_hud_obj_color_contested_b")
                ObjContestedBrushColor:SetAlphaBar(false)
                ObjContestedBrushColor:SetPalette(false)
                ObjContestedBrushColor:SetWangs(true)

                local DamageIndicatorOverlay
                if GetConVar("tm_hud_dmgindicator"):GetInt() == 1 then DamageIndicatorOverlay = vgui.Create("DPanel", EditorScroller) else
                    DamageIndicatorOverlay = vgui.Create("DPanel", HiddenOptionsScroller)
                    ShowHiddenOptions = true
                end

                DamageIndicatorOverlay:Dock(TOP)
                DamageIndicatorOverlay:SetSize(0, TM.MenuScale(160))
                DamageIndicatorOverlay.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("DAMAGE INDICATOR", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Indicator Color", "Health", TM.MenuScale(210), TM.MenuScale(45), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Indicator Opacity", "Health", TM.MenuScale(165), TM.MenuScale(130), white, TEXT_ALIGN_LEFT)
                end

                local IndicatorColor = vgui.Create("DColorMixer", DamageIndicatorOverlay)
                IndicatorColor:SetPos(TM.MenuScale(20), TM.MenuScale(50))
                IndicatorColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                IndicatorColor:SetConVarR("tm_hud_dmgindicator_color_r")
                IndicatorColor:SetConVarG("tm_hud_dmgindicator_color_g")
                IndicatorColor:SetConVarB("tm_hud_dmgindicator_color_b")
                IndicatorColor:SetAlphaBar(false)
                IndicatorColor:SetPalette(false)
                IndicatorColor:SetWangs(true)

                local IndicatorOpaticy = DamageIndicatorOverlay:Add("DNumSlider")
                IndicatorOpaticy:SetPos(TM.MenuScale(-85), TM.MenuScale(130))
                IndicatorOpaticy:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                IndicatorOpaticy:SetConVar("tm_hud_dmgindicator_opacity")
                IndicatorOpaticy:SetMin(0)
                IndicatorOpaticy:SetMax(255)
                IndicatorOpaticy:SetDecimals(0)

                local KeypressOverlay
                if GetConVar("tm_hud_keypressoverlay"):GetInt() == 1 then KeypressOverlay = vgui.Create("DPanel", EditorScroller) else
                    KeypressOverlay = vgui.Create("DPanel", HiddenOptionsScroller)
                    ShowHiddenOptions = true
                end

                KeypressOverlay:Dock(TOP)
                KeypressOverlay:SetSize(0, TM.MenuScale(280))
                KeypressOverlay.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("KEYPRESS OVERLAY", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Overlay X Offset", "Health", TM.MenuScale(165), TM.MenuScale(50), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Overlay Y Offset", "Health", TM.MenuScale(165), TM.MenuScale(80), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Unpressed Color", "Health", TM.MenuScale(210), TM.MenuScale(115), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Actuated Color", "Health", TM.MenuScale(210), TM.MenuScale(195), white, TEXT_ALIGN_LEFT)
                end

                local KeypressOverlayX = KeypressOverlay:Add("DNumSlider")
                KeypressOverlayX:SetPos(TM.MenuScale(-85), TM.MenuScale(50))
                KeypressOverlayX:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                KeypressOverlayX:SetConVar("tm_hud_keypressoverlay_x")
                KeypressOverlayX:SetMin(0)
                KeypressOverlayX:SetMax(1920)
                KeypressOverlayX:SetDecimals(0)

                local KeypressOverlayY = KeypressOverlay:Add("DNumSlider")
                KeypressOverlayY:SetPos(TM.MenuScale(-85), TM.MenuScale(80))
                KeypressOverlayY:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                KeypressOverlayY:SetConVar("tm_hud_keypressoverlay_y")
                KeypressOverlayY:SetMin(0)
                KeypressOverlayY:SetMax(1080)
                KeypressOverlayY:SetDecimals(0)

                local KeypressInactiveColor = vgui.Create("DColorMixer", KeypressOverlay)
                KeypressInactiveColor:SetPos(TM.MenuScale(20), TM.MenuScale(120))
                KeypressInactiveColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                KeypressInactiveColor:SetConVarR("tm_hud_keypressoverlay_inactive_r")
                KeypressInactiveColor:SetConVarG("tm_hud_keypressoverlay_inactive_g")
                KeypressInactiveColor:SetConVarB("tm_hud_keypressoverlay_inactive_b")
                KeypressInactiveColor:SetAlphaBar(false)
                KeypressInactiveColor:SetPalette(false)
                KeypressInactiveColor:SetWangs(true)

                local KeypressActuatedColor = vgui.Create("DColorMixer", KeypressOverlay)
                KeypressActuatedColor:SetPos(TM.MenuScale(20), TM.MenuScale(200))
                KeypressActuatedColor:SetSize(TM.MenuScale(185), TM.MenuScale(70))
                KeypressActuatedColor:SetConVarR("tm_hud_keypressoverlay_actuated_r")
                KeypressActuatedColor:SetConVarG("tm_hud_keypressoverlay_actuated_g")
                KeypressActuatedColor:SetConVarB("tm_hud_keypressoverlay_actuated_b")
                KeypressActuatedColor:SetAlphaBar(false)
                KeypressActuatedColor:SetPalette(false)
                KeypressActuatedColor:SetWangs(true)

                local VelocityCounter
                if GetConVar("tm_hud_velocitycounter"):GetInt() == 1 then VelocityCounter = vgui.Create("DPanel", EditorScroller) else
                    VelocityCounter = vgui.Create("DPanel", HiddenOptionsScroller)
                    ShowHiddenOptions = true
                end

                VelocityCounter:Dock(TOP)
                VelocityCounter:SetSize(0, TM.MenuScale(110))
                VelocityCounter.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("VELOCITY COUNTER", "SettingsLabel", TM.MenuScale(20), TM.MenuScale(10), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Counter X Offset", "Health", TM.MenuScale(165), TM.MenuScale(50), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Counter Y Offset", "Health", TM.MenuScale(165), TM.MenuScale(80), white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Text Color", "Health", TM.MenuScale(210), TM.MenuScale(115), white, TEXT_ALIGN_LEFT)
                end

                local VelocityCounterX = VelocityCounter:Add("DNumSlider")
                VelocityCounterX:SetPos(TM.MenuScale(-85), TM.MenuScale(50))
                VelocityCounterX:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                VelocityCounterX:SetConVar("tm_hud_velocitycounter_x")
                VelocityCounterX:SetMin(0)
                VelocityCounterX:SetMax(1920)
                VelocityCounterX:SetDecimals(0)

                local VelocityCounterY = VelocityCounter:Add("DNumSlider")
                VelocityCounterY:SetPos(TM.MenuScale(-85), TM.MenuScale(80))
                VelocityCounterY:SetSize(TM.MenuScale(250), TM.MenuScale(30))
                VelocityCounterY:SetConVar("tm_hud_velocitycounter_y")
                VelocityCounterY:SetMin(0)
                VelocityCounterY:SetMax(1080)
                VelocityCounterY:SetDecimals(0)

                local HiddenOptionsCollapse = vgui.Create("DCollapsibleCategory", EditorScroller)
                HiddenOptionsCollapse:SetLabel("Show options for disabled HUD elements")
                HiddenOptionsCollapse:Dock(TOP)
                HiddenOptionsCollapse:SetSize(TM.MenuScale(250), TM.MenuScale(200))
                HiddenOptionsCollapse:SetExpanded(false)
                HiddenOptionsCollapse:SetContents(HiddenOptionsScroller)

                if ShowHiddenOptions == false then HiddenOptionsCollapse:Remove() end

                local EditorButtons = vgui.Create("DPanel", EditorScroller)
                EditorButtons:Dock(TOP)
                EditorButtons:SetSize(0, TM.MenuScale(290))
                EditorButtons.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                end

                local TestKillButton = vgui.Create("DButton", EditorButtons)
                TestKillButton:SetPos(TM.MenuScale(20), TM.MenuScale(30))
                TestKillButton:SetText("")
                TestKillButton:SetSize(TM.MenuScale(145), TM.MenuScale(40))
                local textAnim = 0
                TestKillButton.Paint = function()
                    if TestKillButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Test Kill", "Health", 0 + TM.MenuScale(textAnim), 0, white, TEXT_ALIGN_LEFT)
                end
                TestKillButton.DoClick = function()
                    RunConsoleCommand("tm_hud_testkill")
                end

                local TestDeathButton = vgui.Create("DButton", EditorButtons)
                TestDeathButton:SetPos(TM.MenuScale(20), TM.MenuScale(60))
                TestDeathButton:SetText("")
                TestDeathButton:SetSize(TM.MenuScale(165), TM.MenuScale(40))
                local textAnim = 0
                TestDeathButton.Paint = function()
                    if TestDeathButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Test Death", "Health", 0 + TM.MenuScale(textAnim), 0, white, TEXT_ALIGN_LEFT)
                end
                TestDeathButton.DoClick = function()
                    RunConsoleCommand("tm_hud_testdeath")
                end

                local TestLevelUpButton = vgui.Create("DButton", EditorButtons)
                TestLevelUpButton:SetPos(TM.MenuScale(20), TM.MenuScale(90))
                TestLevelUpButton:SetText("")
                TestLevelUpButton:SetSize(TM.MenuScale(200), TM.MenuScale(40))
                local textAnim = 0
                TestLevelUpButton.Paint = function()
                    if TestLevelUpButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Test Level Up", "Health", 0 + TM.MenuScale(textAnim), 0, white, TEXT_ALIGN_LEFT)
                end
                TestLevelUpButton.DoClick = function()
                    RunConsoleCommand("tm_hud_testlevelup")
                end

                local ImportCodeInput = EditorButtons:Add("DTextEntry")
                ImportCodeInput:SetPlaceholderText("Enter a HUD code...")
                ImportCodeInput:SetPos(TM.MenuScale(250), TM.MenuScale(140))
                ImportCodeInput:SetSize(TM.MenuScale(150), TM.MenuScale(30))

                local ImportCode = vgui.Create("DButton", EditorButtons)
                ImportCode:SetPos(TM.MenuScale(20), TM.MenuScale(140))
                ImportCode:SetText("")
                ImportCode:SetSize(TM.MenuScale(225), TM.MenuScale(40))
                local textAnim = 0
                ImportCode.Paint = function()
                    if ImportCode:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Import HUD Code", "Health", 0 + TM.MenuScale(textAnim), 0, white, TEXT_ALIGN_LEFT)
                end
                ImportCode.DoClick = function()
                    RunConsoleCommand("tm_importhudcode_cannotbeundone", ImportCodeInput:GetValue())
                    TriggerSound("forward")
                end

                local function CreateExportedCodeEntry(code)
                    if not IsValid(ExportCodeInput) then
                        ExportCodeInput = EditorButtons:Add("DTextEntry")
                        ExportCodeInput:SetPos(TM.MenuScale(250), TM.MenuScale(170))
                        ExportCodeInput:SetSize(TM.MenuScale(150), TM.MenuScale(30))
                        ExportCodeInput.AllowInput = function(self, stringValue) return true end
                        ExportCodeInput:SetValue(code)
                    else
                        ExportCodeInput:SetValue(code)
                    end
                end

                local ExportCode = vgui.Create("DButton", EditorButtons)
                ExportCode:SetPos(TM.MenuScale(20), TM.MenuScale(170))
                ExportCode:SetText("")
                ExportCode:SetSize(TM.MenuScale(225), TM.MenuScale(40))
                local textAnim = 0
                ExportCode.Paint = function()
                    if ExportCode:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Export HUD Code", "Health", 0 + TM.MenuScale(textAnim), 0, white, TEXT_ALIGN_LEFT)
                end
                ExportCode.DoClick = function()
                    CreateExportedCodeEntry(GetConVar("tm_hud_scale"):GetFloat() .. "-" .. GetConVar("tm_hud_font"):GetString() .. "-" .. GetConVar("tm_hud_bounds_x"):GetInt() .. "-" .. GetConVar("tm_hud_bounds_y"):GetInt() .. "-" .. GetConVar("tm_hud_text_color_r"):GetInt() .. "-" .. GetConVar("tm_hud_text_color_g"):GetInt() .. "-" .. GetConVar("tm_hud_text_color_b"):GetInt() .. "-" .. GetConVar("tm_hud_ammo_style"):GetInt() .. "-" .. GetConVar("tm_hud_ammo_bar_color_r"):GetInt() .. "-" .. GetConVar("tm_hud_ammo_bar_color_g"):GetInt() .. "-"
                    .. GetConVar("tm_hud_ammo_bar_color_b"):GetInt() .. "-" .. GetConVar("tm_hud_health_size"):GetInt() .. "-" .. GetConVar("tm_hud_health_offset_x"):GetInt() .. "-" .. GetConVar("tm_hud_health_offset_y"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_high_r"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_high_g"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_high_b"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_mid_r"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_mid_g"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_mid_b"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_low_r"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_low_g"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_low_b"):GetInt() .. "-" .. GetConVar("tm_hud_equipment_anchor"):GetInt() .. "-"
                    .. GetConVar("tm_hud_equipment_offset_x"):GetInt() .. "-" .. GetConVar("tm_hud_equipment_offset_y"):GetInt() .. "-" .. GetConVar("tm_hud_enablekillfeed"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_style"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_limit"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_offset_x"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_offset_y"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_opacity"):GetInt() .. "-" .. GetConVar("tm_hud_killdeath_offset_x"):GetInt() .. "-" .. GetConVar("tm_hud_killdeath_offset_y"):GetInt() .. "-" .. GetConVar("tm_hud_kill_iconcolor_r"):GetInt() .. "-" .. GetConVar("tm_hud_kill_iconcolor_g"):GetInt() .. "-" .. GetConVar("tm_hud_kill_iconcolor_b"):GetInt() .. "-" .. GetConVar("tm_hud_obj_scale"):GetInt() .. "-"
                    .. GetConVar("tm_hud_obj_color_empty_r"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_empty_g"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_empty_b"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_occupied_r"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_occupied_g"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_occupied_b"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_contested_r"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_contested_g"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_contested_b"):GetInt() .. "-" .. GetConVar("tm_hud_dmgindicator_color_r"):GetInt() .. "-" .. GetConVar("tm_hud_dmgindicator_color_g"):GetInt() .. "-" .. GetConVar("tm_hud_dmgindicator_color_b"):GetInt() .. "-" .. GetConVar("tm_hud_dmgindicator_opacity"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_x"):GetInt() .. "-"
                    .. GetConVar("tm_hud_keypressoverlay_y"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_inactive_r"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_inactive_g"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_inactive_b"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_actuated_r"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_actuated_g"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_actuated_b"):GetInt() .. "-" .. GetConVar("tm_hud_velocitycounter_x"):GetInt() .. "-" .. GetConVar("tm_hud_velocitycounter_y"):GetInt())
                end

                local ResetToDefaultButton = vgui.Create("DButton", EditorButtons)
                ResetToDefaultButton:SetPos(TM.MenuScale(20), TM.MenuScale(250))
                ResetToDefaultButton:SetText("")
                ResetToDefaultButton:SetSize(TM.MenuScale(360), TM.MenuScale(40))
                local textAnim = 0
                local ResetToDefaultConfirm = 0
                ResetToDefaultButton.Paint = function()
                    if ResetToDefaultButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    if (ResetToDefaultConfirm == 0) then
                        draw.DrawText("Reset HUD To Default Options", "Health", 0 + TM.MenuScale(textAnim), 0, white, TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("ARE YOU SURE?", "Health", 0 + TM.MenuScale(textAnim), 0, Color(255, 0, 0), TEXT_ALIGN_LEFT)
                    end
                end
                ResetToDefaultButton.DoClick = function()
                    TriggerSound("click")
                    if (ResetToDefaultConfirm == 0) then
                        ResetToDefaultConfirm = 1
                    else
                        RunConsoleCommand("tm_resethudtodefault_cannotbeundone")
                        UpdateHUD()
                        ResetToDefaultConfirm = 0
                    end

                    timer.Simple(3, function() ResetToDefaultConfirm = 0 end)
                end
            end

            local CreditsButton = vgui.Create("DButton", MainPanel)
            CreditsButton:SetPos(scrW - TM.MenuScale(110), scrH - TM.MenuScale(84))
            CreditsButton:SetText("")
            CreditsButton:SetSize(TM.MenuScale(110), TM.MenuScale(32))
            local textAnim = 20
            CreditsButton.Paint = function()
                CreditsButton:SetPos(scrW - TM.MenuScale(110), scrH - TM.MenuScale(84))
                if CreditsButton:IsHovered() then
                    textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 20)
                else
                    textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 20)
                end
                draw.DrawText("CREDITS", "StreakText", TM.MenuScale(85) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_RIGHT)
            end
            CreditsButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://github.com/PikachuPenial/Titanmod#credits")
            end

            local PatchNotesButton = vgui.Create("DButton", MainPanel)
            PatchNotesButton:SetPos(scrW - TM.MenuScale(150), scrH - TM.MenuScale(84))
            PatchNotesButton:SetText("")
            PatchNotesButton:SetSize(TM.MenuScale(150), TM.MenuScale(32))
            local textAnim = 20
            PatchNotesButton.Paint = function()
                PatchNotesButton:SetPos(scrW - TM.MenuScale(150), scrH - TM.MenuScale(52))
                if PatchNotesButton:IsHovered() then
                    textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 20)
                else
                    textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 20)
                end
                draw.DrawText("PATCH NOTES", "StreakText", TM.MenuScale(125) + TM.MenuScale(textAnim), TM.MenuScale(5), white, TEXT_ALIGN_RIGHT)
            end
            PatchNotesButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://github.com/PikachuPenial/Titanmod/blob/main/PATCHNOTES.md")
            end
    end
end )

PANEL = {}
function PANEL:Init()
    self:SetSize(scrW, scrH)
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("MainPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(TM.MenuScale(56), scrH)
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("OptionsSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(TM.MenuScale(600), scrH)
    self:SetPos(TM.MenuScale(56), 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("OptionsPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(TM.MenuScale(56), scrH)
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("LeaderboardSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(TM.MenuScale(780), scrH)
    self:SetPos(TM.MenuScale(56), 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("LeaderboardPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(TM.MenuScale(56), scrH)
    self:SetPos(0, 0)
end

PANEL = {}
function PANEL:Init()
    self:SetSize(scrW, scrH)
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("HUDEditorPanel", PANEL, "Panel")