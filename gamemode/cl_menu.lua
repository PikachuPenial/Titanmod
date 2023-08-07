--Color array, saving space
local white = Color(255, 255, 255, 255)
local gray = Color(50, 50, 50, 200)
local lightGray = Color(40, 40, 40, 200)
local patchGreen = Color(100, 250, 100, 255)
local patchRed = Color(250, 100, 100, 255)
local solidGreen = Color(0, 255, 0, 255)
local solidRed = Color(255, 0, 0, 255)
local transparent = Color(0, 0, 0, 0)

local MainMenu
local activeGamemode = GetGlobal2String("ActiveGamemode", "FFA")

net.Receive("OpenMainMenu", function(len, ply)
    local LocalPly = LocalPlayer()
    local respawnTimeLeft = net.ReadFloat()
    timer.Create("respawnTimeLeft", respawnTimeLeft, 1, function()
    end)

    local chosenMusic
    local musicName
    local musicList
    local requestedBy
    local dof

    local mapID
    local mapName

    local canPrestige
    if LocalPly:GetNWInt("playerLevel") ~= 60 then canPrestige = false else canPrestige = true end
    if ScrW() < 1024 and ScrH() < 768 then belowMinimumRes = true else belowMinimumRes = false end
    if GetConVar("tm_menudof"):GetInt() == 1 then dof = true end

    musicList = {"sound/music/chillwave_ragdolluniverseost.mp3", "sound/music/giftshop_battleblocktheaterost.mp3", "sound/music/tabg_landfall.mp3", "sound/music/waster_bladee.mp3", "sound/music/systemfiles_zedorfska.mp3", "sound/music/systemfiles_zedorfska.mp3", "sound/music/drift_eightiesheadachetape.mp3", "sound/music/highstakes_worldcorp.mp3", "sound/music/bald_jpegmafia.mp3", "sound/music/bmciabaeilrd_limppumpo.mp3"}
    chosenMusic = (musicList[math.random(#musicList)])

    if chosenMusic == "sound/music/chillwave_ragdolluniverseost.mp3" then
        musicName = "Chillwave - Ragdoll Universe OST"
        musicLink = "https://youtu.be/0Y1xiG8cYnY"
    end

    if chosenMusic == "sound/music/giftshop_battleblocktheaterost.mp3" then
        musicName = "Gift Shop - Battleblock Theater OST"
        musicLink = "https://youtu.be/GOkQrRn9434"
    end

    if chosenMusic == "sound/music/mariokartchannel_nintendo.mp3" then
        musicName = "Mario Kart Channel - Nintendo"
        musicLink = "https://youtu.be/HOylSnC340I"
    end

    if chosenMusic == "sound/music/drift_eightiesheadachetape.mp3" then
        musicName = "Drift - eightiesheadachetape"
        musicLink = "https://youtu.be/Q-NaB8W2934"
    end

    if chosenMusic == "sound/music/highstakes_worldcorp.mp3" then
        musicName = "High Stakes - worldcorp"
        musicLink = "https://youtu.be/4dXLpJcSu8w"
    end

    if chosenMusic == "sound/music/bald_jpegmafia.mp3" then
        musicName = "BALD! - JPEGMAFIA"
        musicLink = "https://youtu.be/BjFI9hFEHHY"
    end

    if chosenMusic == "sound/music/tabg_landfall.mp3" then
        musicName = "TABG Main Theme"
        musicLink = "https://youtu.be/ofG5Uc47uVY"
        requestedBy = "Portanator"
        steamProfile = "http://steamcommunity.com/profiles/76561198355588760 "
    end

    if chosenMusic == "sound/music/waster_bladee.mp3" then
        musicName = "Waster - Bladee"
        musicLink = "https://youtu.be/sLWeSsxk5GE"
        requestedBy = "Suomij"
        steamProfile = "https://steamcommunity.com/profiles/76561199027666260"
    end

    if chosenMusic == "sound/music/systemfiles_zedorfska.mp3" then
        musicName = "System Files - Zedorfska"
        musicLink = "https://www.youtube.com/c/Zedorfska"
        requestedBy = "Zedorfska"
        steamProfile = "http://steamcommunity.com/profiles/76561198313962855"
    end

    if chosenMusic == "sound/music/bmciabaeilrd_limppumpo.mp3" then
        musicName = "Brampton men Charged in Amen Breaking - LIMP PUMPO"
        musicLink = "https://youtu.be/t7URVeFx5s8"
        requestedBy = "färməsəst"
        steamProfile = "https://steamcommunity.com/profiles/76561199103473114"
    end

    musicVolume = GetConVar("tm_menumusicvolume"):GetInt()

    sound.PlayFile(chosenMusic, "noplay", function(menuMusic)
        if IsValid(menuMusic) then
            function StartMusic()
                menuMusic:Play()
                menuMusic:EnableLooping(true)
                menuMusic:SetVolume(musicVolume)
            end

            function PauseMusic()
                menuMusic:Pause()
            end

            function ResumeMusic()
                menuMusic:Play()
            end

            function SetMusicVolume(vol)
                menuMusic:SetVolume(vol)
            end

            function StopMusic()
                menuMusic:Stop()
            end

            if GetConVar("tm_menumusic"):GetInt() == 1 then StartMusic() end
        end
    end )

    local hintList = hintArray
    table.Shuffle(hintList)
    local hintText = table.concat(hintList, " / ")

    if not IsValid(MainMenu) then
        MainMenu = vgui.Create("DFrame")
        MainMenu:SetSize(ScrW(), ScrH())
        MainMenu:Center()
        MainMenu:SetTitle("")
        MainMenu:SetDraggable(false)
        MainMenu:ShowCloseButton(false)
        MainMenu:SetDeleteOnClose(false)
        MainMenu:MakePopup()

        for m, t in pairs(mapArray) do
            if game.GetMap() == t[1] then
                mapID = t[1]
                mapName = t[2]
            end
        end

        MainMenu.Paint = function()
            if dof == true then DrawBokehDOF(4, 1, 0) end
            surface.SetDrawColor(40, 40, 40, 225)
            surface.DrawRect(0, 0, MainMenu:GetWide(), MainMenu:GetTall())
        end

        gui.EnableScreenClicker(true)

        local MainPanel = MainMenu:Add("MainPanel")
            local pushSpawnItems = 100
            local pushExitItems = -100
            local spawnTextAnim = 0
            local hintTextAnim = 0
            MainPanel.Paint = function()
                if GetConVar("tm_menumusic"):GetInt() == 1 then
                    draw.SimpleText("Listening to: " .. musicName, "StreakText", ScrW() - 5, 0, white, TEXT_ALIGN_RIGHT)

                    if requestedBy ~= nil then
                        draw.SimpleText("Requested by " .. requestedBy, "StreakText", ScrW() - 5, 20, white, TEXT_ALIGN_RIGHT)
                    end
                else
                    draw.SimpleText("Listening to nothing, peace and quiet :)", "StreakText", ScrW() - 5, 0, white, TEXT_ALIGN_RIGHT)
                end

                draw.SimpleText(LocalPly:GetNWInt("playerLevel"), "AmmoCountSmall", 440, -5, white, TEXT_ALIGN_LEFT)

                if LocalPly:GetNWInt("playerPrestige") ~= 0 and LocalPly:GetNWInt("playerLevel") ~= 60 then
                    draw.SimpleText("Prestige " .. LocalPly:GetNWInt("playerPrestige"), "StreakText", 660, 37.5, white, TEXT_ALIGN_RIGHT)
                elseif LocalPly:GetNWInt("playerPrestige") ~= 0 and LocalPly:GetNWInt("playerLevel") == 60 then
                    draw.SimpleText("Prestige " .. LocalPly:GetNWInt("playerPrestige"), "StreakText", 535, 37.5, white, TEXT_ALIGN_LEFT)
                end

                if LocalPly:GetNWInt("playerLevel") ~= 60 then
                    draw.SimpleText(math.Round(LocalPly:GetNWInt("playerXP"), 0) .. " / " .. math.Round(LocalPly:GetNWInt("playerXPToNextLevel"), 0) .. "XP", "StreakText", 660, 57.5, white, TEXT_ALIGN_RIGHT)
                    draw.SimpleText(LocalPly:GetNWInt("playerLevel") + 1, "StreakText", 665, 72.5, white, TEXT_ALIGN_LEFT)

                    surface.SetDrawColor(30, 30, 30, 200)
                    surface.DrawRect(440, 80, 220, 10)

                    surface.SetDrawColor(200, 200, 0, 200)
                    surface.DrawRect(440, 80, (LocalPly:GetNWInt("playerXP") / LocalPly:GetNWInt("playerXPToNextLevel")) * 220, 10)
                else
                    draw.SimpleText("+ " .. math.Round(LocalPly:GetNWInt("playerXP"), 0) .. "XP", "StreakText", 535, 55, white, TEXT_ALIGN_LEFT)
                end

                if mapID == nil then draw.SimpleText(string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()), "%2i:%02i" .. " / " .. activeGamemode .. ", " .. game.GetMap()), "StreakText", 5 + spawnTextAnim, ScrH() / 2 - 110 - pushSpawnItems, white, TEXT_ALIGN_LEFT) else draw.SimpleText(string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()), "%2i:%02i" .. " / " .. activeGamemode .. ", " .. mapName), "StreakText", 10 + spawnTextAnim, ScrH() / 2 - 110 - pushSpawnItems, white, TEXT_ALIGN_LEFT) end

                hintTextAnim = math.Clamp(hintTextAnim + 25 * FrameTime(), 0, 10000)
                surface.SetDrawColor(30, 30, 30, 200)
                surface.DrawRect(0, ScrH() - 24, ScrW(), 24)
                draw.SimpleText(hintText, "StreakText", 5 - hintTextAnim, ScrH() - 13, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            if canPrestige == true then
                local PrestigeButton = vgui.Create("DButton", MainPanel)
                PrestigeButton:SetPos(437.5, 67.5)
                PrestigeButton:SetText("")
                PrestigeButton:SetSize(180, 30)
                local textAnim = 0
                local prestigeConfirm = 0
                PrestigeButton.Paint = function()
                    if PrestigeButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                    else
                        textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                    end

                    if prestigeConfirm == 0 then
                        draw.DrawText("PRESTIGE TO P" .. LocalPly:GetNWInt("playerPrestige") + 1, "StreakText", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("ARE YOU SURE?", "StreakText", 5 + textAnim, 5, solidRed, TEXT_ALIGN_LEFT)
                    end
                end
                PrestigeButton.DoClick = function()
                    if (prestigeConfirm == 0) then
                        surface.PlaySound("tmui/buttonclick.wav")
                        prestigeConfirm = 1
                    else
                        surface.PlaySound("tmui/prestige.wav")
                        LocalPly:ConCommand("tm_prestige")
                        PrestigeButton:Hide()
                    end

                    timer.Simple(3, function() prestigeConfirm = 0 end)
                end
            end

            local ProfileButton
            if requestedBy ~= nil then
                ProfileButton = vgui.Create("DImageButton", MainPanel)
                ProfileButton:SetPos(ScrW() - 72, 45)
                ProfileButton:SetSize(32, 32)
                ProfileButton:SetImage("icons/steamicon.png")
                ProfileButton.DoClick = function()
                    gui.OpenURL(steamProfile)
                end
            end

            local LinkButton
            if musicLink ~= nil then
                LinkButton = vgui.Create("DImageButton", MainPanel)
                if requestedBy ~= nil then LinkButton:SetPos(ScrW() - 107, 45) else LinkButton:SetPos(ScrW() - 72, 25) end
                LinkButton:SetSize(32, 32)
                LinkButton:SetImage("icons/musicicon.png")
                LinkButton:SetTooltip("Open song on YouTube")
                LinkButton.DoClick = function()
                    gui.OpenURL(musicLink)
                end
            end

            if GetConVar("tm_menumusic"):GetInt() == 0 then
                if requestedBy ~= nil then ProfileButton:Hide() end
                if musicLink ~= nil then LinkButton:Hide() end
            end

            local MuteMusicButton = vgui.Create("DImageButton", MainPanel)
            if requestedBy ~= nil then MuteMusicButton:SetPos(ScrW() - 37, 45) elseif requestedBy == nil or GetConVar("tm_menumusic"):GetInt() == 0 then MuteMusicButton:SetPos(ScrW() - 37, 25) end
            MuteMusicButton:SetSize(32, 32)
            if GetConVar("tm_menumusic"):GetInt() == 1 then
                MuteMusicButton:SetImage("icons/speakericon.png")
                MuteMusicButton:SetTooltip("Disable music")
            else
                MuteMusicButton:SetImage("icons/speakermutedicon.png")
                MuteMusicButton:SetTooltip("Enable music")
            end
            MuteMusicButton.DoClick = function()
                if GetConVar("tm_menumusic"):GetInt() == 0 then
                    ResumeMusic()
                    MuteMusicButton:SetImage("icons/speakericon.png")
                    MuteMusicButton:SetTooltip("Disable music")
                    if requestedBy ~= nil then MuteMusicButton:SetPos(ScrW() - 37, 45) else MuteMusicButton:SetPos(ScrW() - 37, 25) end
                    if ProfileButton ~= nil then ProfileButton:Show() end
                    if LinkButton ~= nil then LinkButton:Show() end
                    RunConsoleCommand("tm_menumusic", 1)
                else
                    PauseMusic()
                    MuteMusicButton:SetImage("icons/speakermutedicon.png")
                    MuteMusicButton:SetTooltip("Enable music")
                    MuteMusicButton:SetPos(ScrW() - 37, 25)
                    if requestedBy ~= nil and ProfileButton ~= nil then ProfileButton:Hide() end
                    if musicLink ~= nil and LinkButton ~= nil then LinkButton:Hide() end
                    RunConsoleCommand("tm_menumusic", 0)
                end
            end

            plyCallingCard = vgui.Create("DImage", MainPanel)
            plyCallingCard:SetPos(190, 10)
            plyCallingCard:SetSize(240, 80)
            plyCallingCard:SetImage(LocalPly:GetNWString("chosenPlayercard"), "cards/color/black.png")

            playerProfilePicture = vgui.Create("AvatarImage", MainPanel)
            playerProfilePicture:SetPos(195, 15)
            playerProfilePicture:SetSize(70, 70)
            playerProfilePicture:SetPlayer(LocalPly, 184)

            local SelectedBoard
            local SelectedBoardName
            local LeaderboardButton = vgui.Create("DImageButton", MainPanel)
            LeaderboardButton:SetPos(10, 10)
            LeaderboardButton:SetImage("icons/statsicon.png")
            LeaderboardButton:SetSize(80, 80)
            LeaderboardButton:SetTooltip("Leaderboards (not available)")
            LeaderboardButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                MainPanel:Hide()
                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat() * 0.2)

                if not IsValid(LeaderboardPanel) then
                    local LeaderboardPanel = MainMenu:Add("LeaderboardPanel")
                    local LeaderboardSlideoutPanel = MainMenu:Add("LeaderboardSlideoutPanel")

                    local LeaderboardQuickjumpHolder = vgui.Create("DPanel", LeaderboardSlideoutPanel)
                    LeaderboardQuickjumpHolder:Dock(TOP)
                    LeaderboardQuickjumpHolder:SetSize(0, ScrH())

                    LeaderboardQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end

                    local LeaderboardScroller = vgui.Create("DScrollPanel", LeaderboardPanel)
                    LeaderboardScroller:Dock(FILL)

                    local sbar = LeaderboardScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, gray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local LeaderboardTextHolder = vgui.Create("DPanel", LeaderboardPanel)
                    LeaderboardTextHolder:Dock(TOP)
                    LeaderboardTextHolder:SetSize(0, 210)

                    LeaderboardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("LEADERBOARDS", "AmmoCountSmall", 20, 20, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Entries update on match start/player disconnect | Only top 50 are shown", "StreakText", 25, 100, white, TEXT_ALIGN_LEFT)

                        if SelectedBoardName ~= nil then draw.SimpleText(SelectedBoardName, "OptionsHeader", 85, 156, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
                        draw.SimpleText("#", "StreakText", 20, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Name", "StreakText", 85, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Stat", "StreakText", 710, 185, white, TEXT_ALIGN_RIGHT)
                    end

                    local LeaderboardPickerButton
                    function LeaderboardSelected(text, data)
                        if SelectedBoardName == text then return end
                        LeaderboardPickerButton:Hide()
                        timer.Create("SendBoardDataRequestCooldown", 1.25, 1, function()
                            LeaderboardPickerButton:Show()
                        end)
                        surface.PlaySound("tmui/buttonclick.wav")
                        net.Start("GrabLeaderboardData")
                        net.WriteString(data)
                        net.SendToServer()
                        SelectedBoardName = text
                    end

                    LeaderboardPickerButton = vgui.Create("DImageButton", LeaderboardTextHolder)
                    LeaderboardPickerButton:SetPos(25, 140)
                    LeaderboardPickerButton:SetSize(32, 32)
                    LeaderboardPickerButton:SetTooltip("Switch shown Leaderboard")
                    LeaderboardPickerButton:SetImage("icons/changeicon.png")
                    LeaderboardPickerButton.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        local BoardSelection = DermaMenu()
                        local statistics = BoardSelection:AddSubMenu("Statistics")
                        statistics:AddOption("Level", function() LeaderboardSelected("Level", "level") end)
                        statistics:AddOption("Kills", function() LeaderboardSelected("Kills", "playerKills") end)
                        statistics:AddOption("Deaths", function() LeaderboardSelected("Deaths", "playerDeaths") end)
                        statistics:AddOption("K/D Ratio", function() LeaderboardSelected("K/D Ratio", "kd") end)
                        statistics:AddOption("Matches Played", function() LeaderboardSelected("Matches Played", "matchesPlayed") end)
                        statistics:AddOption("Matches Won", function() LeaderboardSelected("Matches Won", "matchesWon") end)
                        statistics:AddOption("W/L Ratio", function() LeaderboardSelected("W/L Ratio", "wl") end)
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
                        weaponstatistics:SetMaxHeight(ScrH() / 2)
                        for p, t in pairs(weaponArray) do
                            weaponstatistics:AddOption("Kills w/ " .. t[2], function() LeaderboardSelected("Kills w/ " .. t[2], "killsWith_" .. t[1]) end)
                        end

                        BoardSelection:Open()
                    end

                    local StatsIcon = vgui.Create("DImage", LeaderboardQuickjumpHolder)
                    StatsIcon:SetPos(12, 12)
                    StatsIcon:SetSize(32, 32)
                    StatsIcon:SetImage("icons/statsslideouticon.png")

                    local BackButtonSlideout = vgui.Create("DImageButton", LeaderboardQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        MainPanel:Show()
                        SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                        LeaderboardPanel:Hide()
                        LeaderboardSlideoutPanel:Hide()
                    end

                    local LeaderboardContents = vgui.Create("DPanel", LeaderboardScroller)
                    LeaderboardContents:Dock(TOP)
                    LeaderboardContents:SetSize(0, 2082.5)

                    LeaderboardContents.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)

                        if SelectedBoard == nil then return end
                        for p, t in pairs(SelectedBoard) do
                            if SelectedBoardName == "Level" then
                                if t.Value == "NULL" or t.level == nil or t.prestige == nil then return end
                                if t.SteamName != LocalPly:GetName() then
                                    draw.SimpleText(p, "SettingsLabel", 20, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT)
                                    if t.SteamName != "NULL" then draw.SimpleText(t.SteamName, "SettingsLabel", 85, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT) else draw.SimpleText(t.SteamID, "SettingsLabel", 85, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT) end
                                    draw.SimpleText("P" .. t.prestige .. " L" .. t.level, "SettingsLabel", 710, (p - 1) * 41.25, white, TEXT_ALIGN_RIGHT)
                                else
                                    draw.SimpleText(p, "SettingsLabel", 20, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                                    draw.SimpleText(t.SteamName, "SettingsLabel", 85, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                                    draw.SimpleText("P" .. t.prestige .. " L" .. t.level, "SettingsLabel", 710, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_RIGHT)
                                end
                            elseif SelectedBoardName == "W/L Ratio" then
                                if t.Value == "NULL" or t.Value == nil then return end
                                if t.SteamName != LocalPly:GetName() then
                                    draw.SimpleText(p, "SettingsLabel", 20, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT)
                                    if t.SteamName != "NULL" then draw.SimpleText(t.SteamName, "SettingsLabel", 85, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT) else draw.SimpleText(t.SteamID, "SettingsLabel", 85, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT) end
                                    draw.SimpleText(math.Round(t.Value) .. "%", "SettingsLabel", 710, (p - 1) * 41.25, white, TEXT_ALIGN_RIGHT)
                                else
                                    draw.SimpleText(p, "SettingsLabel", 20, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                                    draw.SimpleText(t.SteamName, "SettingsLabel", 85, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                                    draw.SimpleText(math.Round(t.Value) .. "%", "SettingsLabel", 710, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_RIGHT)
                                end
                            else
                                if t.Value == "NULL" or t.Value == nil then return end
                                if t.SteamName != LocalPly:GetName() then
                                    draw.SimpleText(p, "SettingsLabel", 20, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT)
                                    if t.SteamName != "NULL" then draw.SimpleText(t.SteamName, "SettingsLabel", 85, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT) else draw.SimpleText(t.SteamID, "SettingsLabel", 85, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT) end
                                    draw.SimpleText(math.Round(t.Value, 2), "SettingsLabel", 710, (p - 1) * 41.25, white, TEXT_ALIGN_RIGHT)
                                else
                                    draw.SimpleText(p, "SettingsLabel", 20, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                                    draw.SimpleText(t.SteamName, "SettingsLabel", 85, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                                    draw.SimpleText(math.Round(t.Value, 2), "SettingsLabel", 710, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_RIGHT)
                                end
                            end
                        end
                    end

                    net.Start("GrabLeaderboardData")
                    net.WriteString("playerKills")
                    net.SendToServer()
                    SelectedBoardName = "Kills"
                end
            end

            net.Receive("SendLeaderboardData", function(len, ply)
                SelectedBoard = net.ReadTable()
            end )

            local SpectatePanel = vgui.Create("DPanel", MainPanel)
            SpectatePanel:SetSize(170, 0)
            SpectatePanel:SetPos(10, 100)
            SpectatePanel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, white)
            end

            local SpectateTextHeader = vgui.Create("DPanel", SpectatePanel)
            SpectateTextHeader:Dock(TOP)
            SpectateTextHeader:SetSize(0, 70)
            SpectateTextHeader.Paint = function(self, w, h)
                draw.SimpleText("SPECTATE", "UITiny", 3, 0, Color(0, 0, 0), TEXT_ALIGN_LEFT)
            end

            local SpectatePicker = SpectateTextHeader:Add("DComboBox")
            SpectatePicker:SetPos(0, 40)
            SpectatePicker:SetSize(170, 30)
            SpectatePicker:SetValue("Spectate...")
            if allowSpectating then SpectatePicker:AddChoice("Freecam") else SpectatePicker:AddChoice("Spectating disabled by server.") end
            SpectatePicker.OnSelect = function(_, _, value, id)
                if not allowSpectating then return end
                net.Start("BeginSpectate")
                net.SendToServer()
                MainMenu:Remove(false)
                gui.EnableScreenClicker(false)
                StopMusic()
            end

            local SpectateButton = vgui.Create("DImageButton", MainPanel)
            SpectateButton:SetPos(100, 10)
            SpectateButton:SetImage("icons/spectateicon.png")
            SpectateButton:SetSize(80, 80)
            SpectateButton:SetTooltip("Spectate")
            local spectatePanelOpen = 0
            SpectateButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                if (spectatePanelOpen == 0) then
                    spectatePanelOpen = 1
                    SpectatePanel:SizeTo(-1, 70, 1, 0, 0.1)
                else
                    spectatePanelOpen = 0
                    SpectatePanel:SizeTo(-1, 0, 1, 0, 0.1)
                end
            end

            local function ShowTutorial()
                local ContextBind = "Context Menu Bind"
                if input.LookupBinding("+menu_context") != nil then ContextBind = input.LookupBinding("+menu_context") end

                local TutorialPanel = vgui.Create("DFrame", MainMenu)
                TutorialPanel:SetSize(864, 768)
                TutorialPanel:MakePopup()
                TutorialPanel:SetTitle("Titanmod Tutorial")
                TutorialPanel:Center()
                TutorialPanel:SetScreenLock(true)
                TutorialPanel:GetBackgroundBlur(false)
                TutorialPanel:SetDraggable(false)
                TutorialPanel:SetDeleteOnClose(true)
                MainMenu:SetMouseInputEnabled(false)
                TutorialPanel.Paint = function(self, w, h)
                    DrawBokehDOF(4, 1, 0)
                    draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 100))
                end
                TutorialPanel.OnClose = function()
                    surface.PlaySound("tmui/buttonclick.wav")
                    MainMenu:SetMouseInputEnabled(true)
                end

                local TutorialScroller = vgui.Create("DScrollPanel", TutorialPanel)
                TutorialScroller:Dock(FILL)

                local sbar = TutorialScroller:GetVBar()
                function sbar:Paint(w, h)
                    draw.RoundedBox(5, 0, 0, w, h, gray)
                end
                function sbar.btnUp:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, gray)
                end
                function sbar.btnDown:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, gray)
                end
                function sbar.btnGrip:Paint(w, h)
                    draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                end

                local TitleText = vgui.Create("DPanel", TutorialScroller)
                TitleText:Dock(TOP)
                TitleText:SetSize(0, 175)
                TitleText.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("Welcome to", "SettingsLabel", w / 2, 10, white, TEXT_ALIGN_CENTER)
                    draw.SimpleText("Titanmod", "OptionsHeader", w / 2, 40, Color(165, 55, 155), TEXT_ALIGN_CENTER)
                    draw.SimpleText("Here are some things you should know before jumping in:", "SettingsLabel", w / 2, 110, white, TEXT_ALIGN_CENTER)
                end

                local WeaponrySection = vgui.Create("DPanel", TutorialScroller)
                WeaponrySection:Dock(TOP)
                WeaponrySection:SetSize(0, 280)
                WeaponrySection.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("WEAPONS", "OptionsHeader", 280, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end

                local WeaponryLabel = vgui.Create("DLabel", WeaponrySection)
                WeaponryLabel:SetPos(280, 30)
                WeaponryLabel:SetSize(554, 230)
                WeaponryLabel:SetFont("GModNotify")
                WeaponryLabel:SetText([[There are 130+ unique weapons to master in Titanmod!
You can use your Context Menu key []] .. ContextBind .. [[] to adjust attachments on your weapons, and to view weapon statistics. Attachments that you select are saved throughout play sessions, so you only have to customize a gun to your liking once.
Each weapon has its own unique recoil pattern to learn.
Bullets are hitscan and can penetrate through surfaces.
]])
                WeaponryLabel:SetWrap(true)

                local WeaponryImage = vgui.Create("DImage", WeaponrySection)
                WeaponryImage:SetPos(10, 10)
                WeaponryImage:SetSize(260, 260)
                WeaponryImage:SetImage("images/attach.png")

                local MovementSection = vgui.Create("DPanel", TutorialScroller)
                MovementSection:Dock(TOP)
                MovementSection:SetSize(0, 280)
                MovementSection.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("MOVEMENT", "OptionsHeader", 280, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end

                local MovementLabel = vgui.Create("DLabel", MovementSection)
                MovementLabel:SetPos(280, 35)
                MovementLabel:SetSize(554, 230)
                MovementLabel:SetFont("GModNotify")
                MovementLabel:SetText([[Titanmod has an assortment of movement mechanics to learn and use on your opponents!
Here are a few things to look out for:
Sliding                     Air Strafing
Wall Running          Wall Jumping
Rocket Jumping      Grappling
+ More to discover on your own
]])
                MovementLabel:SetWrap(true)

                local MovementImage = vgui.Create("DImage", MovementSection)
                MovementImage:SetPos(10, 10)
                MovementImage:SetSize(260, 260)
                MovementImage:SetImage("images/movement.png")

                local PersonalizeSection = vgui.Create("DPanel", TutorialScroller)
                PersonalizeSection:Dock(TOP)
                PersonalizeSection:SetSize(0, 280)
                PersonalizeSection.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("CUSTOMIZATION", "OptionsHeader", 280, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end

                local PersonalizeLabel = vgui.Create("DLabel", PersonalizeSection)
                PersonalizeLabel:SetPos(280, 45)
                PersonalizeLabel:SetSize(554, 230)
                PersonalizeLabel:SetFont("GModNotify")
                PersonalizeLabel:SetText([[There are over 250+ items to unlock in Titanmod!
There are an assortment of player models and calling cards to express yourself with. Some are unlocked for you already, while some require you to complete specific challenges.
Check out the CUSTOMIZE page to see what is on offer.
Head to the OPTIONS page to tailor the experience to your needs. There is an extensive list of settings to change, and well as a robust HUD editor.
]])
                PersonalizeLabel:SetWrap(true)

                local PersonalizeImage = vgui.Create("DImage", PersonalizeSection)
                PersonalizeImage:SetPos(10, 10)
                PersonalizeImage:SetSize(260, 260)
                PersonalizeImage:SetImage("images/personalize.png")

                local EndingLabel = vgui.Create("DPanel", TutorialScroller)
                EndingLabel:Dock(TOP)
                EndingLabel:SetSize(0, 115)
                EndingLabel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("Join our Discord server!", "SettingsLabel", 90, 8, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Find people to play with or keep up wtih new updates and leaks", "GModNotify", 90, 48, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("^   click me please :)", "GModNotify", 44, 80, white, TEXT_ALIGN_LEFT)
                end

                local DiscordButton = vgui.Create("DImageButton", EndingLabel)
                DiscordButton:SetPos(15, 8)
                DiscordButton:SetImage("icons/discordicon.png")
                DiscordButton:SetSize(64, 64)
                DiscordButton:SetTooltip("Discord")
                DiscordButton.DoClick = function()
                    surface.PlaySound("tmui/buttonclick.wav")
                    gui.OpenURL("https://discord.gg/GRfvt27uGF")
                end
            end

            if LocalPly:GetNWInt("playerDeaths") == 0 then ShowTutorial() end --Force shows the Tutorial is a player joins for the first time

            local TutorialButton = vgui.Create("DImageButton", MainPanel)
            TutorialButton:SetPos(8, ScrH() - 96)
            TutorialButton:SetImage("icons/tutorialicon.png")
            TutorialButton:SetSize(64, 64)
            TutorialButton:SetTooltip("Tutorial")
            TutorialButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                ShowTutorial()
            end

            local DiscordButton = vgui.Create("DImageButton", MainPanel)
            DiscordButton:SetPos(108, ScrH() - 96)
            DiscordButton:SetImage("icons/discordicon.png")
            DiscordButton:SetSize(64, 64)
            DiscordButton:SetTooltip("Discord")
            DiscordButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                gui.OpenURL("https://discord.gg/GRfvt27uGF")
            end

            local WorkshopButton = vgui.Create("DImageButton", MainPanel)
            WorkshopButton:SetPos(180, ScrH() - 96)
            WorkshopButton:SetImage("icons/workshopicon.png")
            WorkshopButton:SetSize(64, 64)
            WorkshopButton:SetTooltip("Steam Workshop")
            WorkshopButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3002938569")
            end

            local YouTubeButton = vgui.Create("DImageButton", MainPanel)
            YouTubeButton:SetPos(252, ScrH() - 96)
            YouTubeButton:SetImage("icons/youtubeicon.png")
            YouTubeButton:SetSize(64, 64)
            YouTubeButton:SetTooltip("YouTube")
            YouTubeButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                gui.OpenURL("https://youtube.com/@penial_")
            end

            local GithubButton = vgui.Create("DImageButton", MainPanel)
            GithubButton:SetPos(324, ScrH() - 96)
            GithubButton:SetImage("icons/githubicon.png")
            GithubButton:SetSize(64, 64)
            GithubButton:SetTooltip("GitHub")
            GithubButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                gui.OpenURL("https://github.com/PikachuPenial/Titanmod")
            end

            local SpawnButton = vgui.Create("DButton", MainPanel)
            SpawnButton:SetPos(0, ScrH() / 2 - 100 - pushSpawnItems)
            SpawnButton:SetText("")
            SpawnButton:SetSize(535, 100)
            SpawnButton.Paint = function()
                SpawnButton:SetPos(0, ScrH() / 2 - 100 - pushSpawnItems)
                if not timer.Exists("respawnTimeLeft") then
                    if SpawnButton:IsHovered() then
                        spawnTextAnim = math.Clamp(spawnTextAnim + 200 * FrameTime(), 0, 20)
                    else
                        spawnTextAnim = math.Clamp(spawnTextAnim - 200 * FrameTime(), 0, 20)
                    end

                    draw.DrawText("SPAWN", "AmmoCountSmall", 5 + spawnTextAnim, 5, white, TEXT_ALIGN_LEFT)
                    for k, v in pairs(weaponArray) do
                        if activeGamemode == "FFA" or activeGamemode == "Fiesta" or activeGamemode == "Shotty Snipers" or activeGamemode == "Cranked" then
                            if v[1] == LocalPly:GetNWString("loadoutPrimary") and usePrimary then draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + spawnTextAnim, 15, white, TEXT_ALIGN_LEFT) end
                            if v[1] == LocalPly:GetNWString("loadoutSecondary") and useSecondary then draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + spawnTextAnim, 40 , white, TEXT_ALIGN_LEFT) end
                            if v[1] == LocalPly:GetNWString("loadoutMelee") and useMelee then draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + spawnTextAnim, 65, white, TEXT_ALIGN_LEFT) end
                        elseif activeGamemode == "Gun Game" then
                            draw.SimpleText(LocalPly:GetNWInt("ladderPosition") .. " / " .. ggLadderSize .. " kills", "MainMenuLoadoutWeapons", 325 + spawnTextAnim, 15, white, TEXT_ALIGN_LEFT)
                        end
                    end
                else
                    draw.DrawText("SPAWN", "AmmoCountSmall", 5 + spawnTextAnim, 5, patchRed, TEXT_ALIGN_LEFT)
                    draw.DrawText("" .. math.Round(timer.TimeLeft("respawnTimeLeft"), 2), "AmmoCountSmall", 350 + spawnTextAnim, 5, white, TEXT_ALIGN_LEFT)
                end
            end
            SpawnButton.DoClick = function()
                if timer.Exists("respawnTimeLeft") then return end
                surface.PlaySound("tmui/buttonclick.wav")
                MainMenu:Remove()
                gui.EnableScreenClicker(false)
                StopMusic()
                net.Start("CloseMainMenu")
                net.SendToServer()
            end

            local CustomizeButton = vgui.Create("DButton", MainPanel)
            local CustomizeModelButton = vgui.Create("DButton", CustomizeButton)
            local CustomizeCardButton = vgui.Create("DButton", CustomizeButton)
            CustomizeButton:SetPos(0, ScrH() / 2 - 100)
            CustomizeButton:SetText("")
            CustomizeButton:SetSize(530, 100)
            local textAnim = 0
            CustomizeButton.Paint = function()
                if CustomizeButton:IsHovered() or CustomizeModelButton:IsHovered() or CustomizeCardButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                    pushSpawnItems = math.Clamp(pushSpawnItems + 600 * FrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, ScrH() / 2 - pushSpawnItems)
                    CustomizeButton:SizeTo(-1, 200, 0, 0, 1)
                else
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                    pushSpawnItems = math.Clamp(pushSpawnItems - 600 * FrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, ScrH() / 2 - pushSpawnItems)
                    CustomizeButton:SizeTo(-1, 100, 0, 0, 1)
                end
                draw.DrawText("CUSTOMIZE", "AmmoCountSmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            CustomizeModelButton:SetPos(0, 100)
            CustomizeModelButton:SetText("")
            CustomizeModelButton:SetSize(180, 100)
            CustomizeModelButton.Paint = function()
                draw.DrawText("MODEL", "AmmoCountESmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            CustomizeCardButton:SetPos(180, 100)
            CustomizeCardButton:SetText("")
            CustomizeCardButton:SetSize(160, 100)
            CustomizeCardButton.Paint = function()
                draw.DrawText("CARD", "AmmoCountESmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            CustomizeCardButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                MainPanel:Hide()
                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat() * 0.2)
                local currentCard = LocalPly:GetNWString("chosenPlayercard")

                if not IsValid(CardPanel) then
                    local CardPanel = MainMenu:Add("CardPanel")
                    local CardSlideoutPanel = MainMenu:Add("CardSlideoutPanel")

                    local CardQuickjumpHolder = vgui.Create("DPanel", CardSlideoutPanel)
                    CardQuickjumpHolder:Dock(TOP)
                    CardQuickjumpHolder:SetSize(0, ScrH())

                    CardQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end

                    local newCard
                    local newCardName
                    local newCardDesc
                    local newCardUnlockType
                    local newCardUnlockValue

                    local totalCards = table.Count(cardArray)
                    local cardsUnlocked = 0

                    local defaultCardsTotal = 0
                    local defaultCardsUnlocked = 0

                    local killCardsTotal = 0
                    local killCardsUnlocked = 0

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

                    --Checking for the players currently equipped card.
                    for k, v in pairs(cardArray) do
                        if v[1] == currentCard then
                            newCard = v[1]
                            newCardName = v[2]
                            newCardDesc = v[3]
                            newCardUnlockType = v[4]
                            newCardUnlockValue = v[5]
                        end
                    end

                    local CardScroller = vgui.Create("DScrollPanel", CardPanel)
                    CardScroller:Dock(FILL)

                    local sbar = CardScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, gray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local CardTextHolder = vgui.Create("DPanel", CardPanel)
                    CardTextHolder:Dock(TOP)
                    CardTextHolder:SetSize(0, 160)

                    CardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("CARDS", "AmmoCountSmall", 257.5, 5, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(cardsUnlocked .. " / " .. totalCards .. " cards unlocked", "Health", 257.5, 85, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText("Hide locked playercards", "StreakText", w / 2 + 20, 120, white, TEXT_ALIGN_CENTER)
                    end

                    local HideLockedCards = CardTextHolder:Add("DCheckBox")
                    HideLockedCards:SetPos(145, 122.5)
                    HideLockedCards:SetSize(20, 20)
                    HideLockedCards:SetTooltip("Hide playercards that you do not have unlocked.")

                    --Default Playercards
                    local TextDefault = vgui.Create("DPanel", CardScroller)
                    TextDefault:Dock(TOP)
                    TextDefault:SetSize(0, 90)

                    local DockDefaultCards = vgui.Create("DPanel", CardScroller)
                    DockDefaultCards:Dock(TOP)
                    DockDefaultCards:SetSize(0, 500)

                    --Leveling related Playercards
                    local TextLevel = vgui.Create("DPanel", CardScroller)
                    TextLevel:Dock(TOP)
                    TextLevel:SetSize(0, 90)

                    local DockLevelCards = vgui.Create("DPanel", CardScroller)
                    DockLevelCards:Dock(TOP)
                    DockLevelCards:SetSize(0, 2030)

                    --Kill related Playercards
                    local TextKill = vgui.Create("DPanel", CardScroller)
                    TextKill:Dock(TOP)
                    TextKill:SetSize(0, 90)

                    local DockKillCards = vgui.Create("DPanel", CardScroller)
                    DockKillCards:Dock(TOP)
                    DockKillCards:SetSize(0, 250)

                    --Accolade related Playercards
                    local TextAccolade = vgui.Create("DPanel", CardScroller)
                    TextAccolade:Dock(TOP)
                    TextAccolade:SetSize(0, 90)

                    local DockAccoladeCards = vgui.Create("DPanel", CardScroller)
                    DockAccoladeCards:Dock(TOP)
                    DockAccoladeCards:SetSize(0, 1198)

                    --Mastery related Playercards
                    local TextMastery = vgui.Create("DPanel", CardScroller)
                    TextMastery:Dock(TOP)
                    TextMastery:SetSize(0, 90)

                    local DockMasteryCards = vgui.Create("DPanel", CardScroller)
                    DockMasteryCards:Dock(TOP)
                    DockMasteryCards:SetSize(0, 5357)

                    --Color related Playercards
                    local TextColor = vgui.Create("DPanel", CardScroller)
                    TextColor:Dock(TOP)
                    TextColor:SetSize(0, 90)

                    local DockColorCards = vgui.Create("DPanel", CardScroller)
                    DockColorCards:Dock(TOP)
                    DockColorCards:SetSize(0, 500)

                    --Pride related Playercards
                    local TextPride = vgui.Create("DPanel", CardScroller)
                    TextPride:Dock(TOP)
                    TextPride:SetSize(0, 90)

                    local DockPrideCards = vgui.Create("DPanel", CardScroller)
                    DockPrideCards:Dock(TOP)
                    DockPrideCards:SetSize(0, 416)

                    --Creating playercard lists
                    local DefaultCardList = vgui.Create("DIconLayout", DockDefaultCards)
                    DefaultCardList:Dock(TOP)
                    DefaultCardList:SetSpaceY(5)
                    DefaultCardList:SetSpaceX(20)

                    local KillCardList = vgui.Create("DIconLayout", DockKillCards)
                    KillCardList:Dock(TOP)
                    KillCardList:SetSpaceY(5)
                    KillCardList:SetSpaceX(20)

                    local AccoladeCardList = vgui.Create("DIconLayout", DockAccoladeCards)
                    AccoladeCardList:Dock(TOP)
                    AccoladeCardList:SetSpaceY(5)
                    AccoladeCardList:SetSpaceX(20)

                    local LevelCardList = vgui.Create("DIconLayout", DockLevelCards)
                    LevelCardList:Dock(TOP)
                    LevelCardList:SetSpaceY(5)
                    LevelCardList:SetSpaceX(20)

                    local MasteryCardList = vgui.Create("DIconLayout", DockMasteryCards)
                    MasteryCardList:Dock(TOP)
                    MasteryCardList:SetSpaceY(5)
                    MasteryCardList:SetSpaceX(20)

                    local ColorCardList = vgui.Create("DIconLayout", DockColorCards)
                    ColorCardList:Dock(TOP)
                    ColorCardList:SetSpaceY(5)
                    ColorCardList:SetSpaceX(20)

                    local PrideCardList = vgui.Create("DIconLayout", DockPrideCards)
                    PrideCardList:Dock(TOP)
                    PrideCardList:SetSpaceY(5)
                    PrideCardList:SetSpaceX(20)

                    DefaultCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    KillCardList.Paint = function(self, w, h)
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

                    local CardPreviewPanel = MainMenu:Add("CardPreviewPanel")

                    local CardsPreviewScroller = vgui.Create("DScrollPanel", CardPreviewPanel)
                    CardsPreviewScroller:Dock(FILL)

                    local sbar = CardsPreviewScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, lightGray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local PreviewCardTextHolder = vgui.Create("DPanel", CardsPreviewScroller)
                    PreviewCardTextHolder:Dock(TOP)
                    if ScrH() >= 1080 then PreviewCardTextHolder:SetSize(0, CardPreviewPanel:GetTall() - 100) else PreviewCardTextHolder:SetSize(0, CardPreviewPanel:GetTall()) end

                    CallingCard = vgui.Create("DImage", PreviewCardTextHolder)
                    CallingCard:SetPos(137.5, 10)
                    CallingCard:SetSize(240, 80)
                    CallingCard:SetImage(newCard)

                    ProfilePicture = vgui.Create("AvatarImage", CallingCard)
                    ProfilePicture:SetPos(5, 5)
                    ProfilePicture:SetSize(70, 70)
                    ProfilePicture:SetPlayer(LocalPly, 184)

                    PreviewCardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)

                        if currentCard ~= nil then
                            draw.SimpleText(newCardName, "PlayerNotiName", 5, 88, white, TEXT_ALIGN_LEFT)
                            draw.SimpleText(newCardDesc, "Health", 5, 135, white, TEXT_ALIGN_LEFT)
                        end

                        if newCardUnlockType == "default" or newCardUnlockType == "color" or newCardUnlockType == "pride" then
                            draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                        elseif newCardUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Kills: " .. LocalPly:GetNWInt("playerKills") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Kills: " .. LocalPly:GetNWInt("playerKills") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Highest Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Highest Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "level" then
                            if playerTotalLevel < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Total Levels: " .. playerTotalLevel .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Total Levels: " .. playerTotalLevel .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "mastery" then
                            if LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) < 50 then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 88, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Kills w/ gun: " .. LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) .. "/" .. 50, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 88, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Kills w/ gun: " .. LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) .. "/" .. 50, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        end

                        CallingCard:SetImage(newCard)
                    end

                    local function FillCardListsAll()
                        for k, v in pairs(cardArray) do
                            if v[4] == "default" then
                                local card = vgui.Create("DImageButton", DockDefaultCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                DefaultCardList:Add(card)

                                defaultCardsTotal = defaultCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                defaultCardsUnlocked = defaultCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "kills" or v[4] == "streak" then
                                local card = vgui.Create("DImageButton", DockKillCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                KillCardList:Add(card)

                                killCardsTotal = killCardsTotal + 1

                                if v[4] == "kills" and LocalPly:GetNWInt("playerKills") < v[5] or v[4] == "streak" and LocalPly:GetNWInt("highestKillStreak") < v[5] then
                                    card:SetColor(Color(100, 100, 100))

                                    local lockIndicator = vgui.Create("DImageButton", card)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(48, 48)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                else
                                    cardsUnlocked = cardsUnlocked + 1
                                    killCardsUnlocked = killCardsUnlocked + 1
                                end

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "headshot" or v[4] == "smackdown" or v[4] == "clutch" or v[4] == "longshot" or v[4] == "pointblank" or v[4] == "killstreaks" or v[4] == "buzzkills" then
                                local card = vgui.Create("DImageButton", DockAccoladeCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                AccoladeCardList:Add(card)

                                accoladeCardsTotal = accoladeCardsTotal + 1

                                if v[4] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") < v[5] or v[4] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") < v[5] or v[4] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") < v[5] or v[4] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") < v[5] or v[4] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") < v[5] or v[4] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") < v[5] or v[4] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") < v[5] then
                                    card:SetColor(Color(100, 100, 100))

                                    local lockIndicator = vgui.Create("DImageButton", card)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(48, 48)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                else
                                    cardsUnlocked = cardsUnlocked + 1
                                    accoladeCardsUnlocked = accoladeCardsUnlocked + 1
                                end

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "color" then
                                local card = vgui.Create("DImageButton", DockColorCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                ColorCardList:Add(card)

                                colorCardsTotal = colorCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                colorCardsUnlocked = colorCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "pride" then
                                local card = vgui.Create("DImageButton", DockPrideCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                PrideCardList:Add(card)

                                prideCardsTotal = prideCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                prideCardsUnlocked = prideCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "level" then
                                local card = vgui.Create("DImageButton", DockLevelCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                LevelCardList:Add(card)

                                levelCardsTotal = levelCardsTotal + 1

                                if v[4] == "level" and playerTotalLevel < v[5] then
                                    card:SetColor(Color(100, 100, 100))

                                    local lockIndicator = vgui.Create("DImageButton", card)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(48, 48)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                else
                                    cardsUnlocked = cardsUnlocked + 1
                                    levelCardsUnlocked = levelCardsUnlocked + 1
                                end

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "mastery" then
                                local card = vgui.Create("DImageButton", DockMasteryCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                MasteryCardList:Add(card)

                                masteryCardsTotal = masteryCardsTotal + 1

                                if v[4] == "mastery" and LocalPly:GetNWInt("killsWith_" .. v[5]) < 50 then
                                    card:SetColor(Color(100, 100, 100))

                                    local lockIndicator = vgui.Create("DImageButton", card)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(48, 48)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                else
                                    cardsUnlocked = cardsUnlocked + 1
                                    masteryCardsUnlocked = masteryCardsUnlocked + 1
                                end

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            end
                        end
                    end

                    local function FillCardListsUnlocked()
                        for k, v in pairs(cardArray) do
                            if v[4] == "default" then
                                local card = vgui.Create("DImageButton", DockDefaultCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                DefaultCardList:Add(card)

                                defaultCardsTotal = defaultCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                defaultCardsUnlocked = defaultCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "kills" or v[4] == "streak" then
                                killCardsTotal = killCardsTotal + 1
                                if v[4] == "kills" and LocalPly:GetNWInt("playerKills") >= v[5] or v[4] == "streak" and LocalPly:GetNWInt("highestKillStreak") >= v[5] then
                                    local card = vgui.Create("DImageButton", DockKillCards)
                                    card:SetImage(v[1])
                                    card:SetTooltip(v[2] .. "\n" .. v[3])
                                    card:SetSize(240, 80)
                                    KillCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    killCardsUnlocked = killCardsUnlocked + 1

                                    card.DoClick = function(card)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                end
                            elseif v[4] == "headshot" or v[4] == "smackdown" or v[4] == "clutch" or v[4] == "longshot" or v[4] == "pointblank" or v[4] == "killstreaks" or v[4] == "buzzkills" then
                                accoladeCardsTotal = accoladeCardsTotal + 1
                                if v[4] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") >= v[5] or v[4] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") >= v[5] or v[4] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") >= v[5] or v[4] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") >= v[5] or v[4] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") >= v[5] or v[4] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") >= v[5] or v[4] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") >= v[5] then
                                    local card = vgui.Create("DImageButton", DockAccoladeCards)
                                    card:SetImage(v[1])
                                    card:SetTooltip(v[2] .. "\n" .. v[3])
                                    card:SetSize(240, 80)
                                    AccoladeCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    accoladeCardsUnlocked = accoladeCardsUnlocked + 1

                                    card.DoClick = function(card)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                end
                            elseif v[4] == "color" then
                                local card = vgui.Create("DImageButton", DockColorCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                ColorCardList:Add(card)

                                colorCardsTotal = colorCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                colorCardsUnlocked = colorCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "pride" then
                                local card = vgui.Create("DImageButton", DockPrideCards)
                                card:SetImage(v[1])
                                card:SetTooltip(v[2] .. "\n" .. v[3])
                                card:SetSize(240, 80)
                                PrideCardList:Add(card)

                                prideCardsTotal = prideCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                prideCardsUnlocked = prideCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "level" then
                                levelCardsTotal = levelCardsTotal + 1
                                if v[4] == "level" and playerTotalLevel >= v[5] then
                                    local card = vgui.Create("DImageButton", DockLevelCards)
                                    card:SetImage(v[1])
                                    card:SetTooltip(v[2] .. "\n" .. v[3])
                                    card:SetSize(240, 80)
                                    LevelCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    levelCardsUnlocked = levelCardsUnlocked + 1

                                    card.DoClick = function(card)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                end
                            elseif v[4] == "mastery" then
                                masteryCardsTotal = masteryCardsTotal + 1
                                if v[4] == "mastery" and LocalPly:GetNWInt("killsWith_" .. v[5]) >= 50 then
                                    local card = vgui.Create("DImageButton", DockMasteryCards)
                                    card:SetImage(v[1])
                                    card:SetTooltip(v[2] .. "\n" .. v[3])
                                    card:SetSize(240, 80)
                                    MasteryCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    masteryCardsUnlocked = masteryCardsUnlocked + 1

                                    card.DoClick = function(card)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                end
                            end
                        end
                    end

                    FillCardListsAll()

                    TextDefault.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Default", "OptionsHeader", 257.5, 0, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(defaultCardsUnlocked .. " / " .. defaultCardsUnlocked, "Health", 257.5, 55, solidGreen, TEXT_ALIGN_CENTER)
                    end

                    TextKill.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Kills", "OptionsHeader", 257.5, 0, white, TEXT_ALIGN_CENTER)

                        if killCardsUnlocked == killCardsTotal then
                            draw.SimpleText(killCardsUnlocked .. " / " .. killCardsTotal, "Health", 257.5, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(killCardsUnlocked .. " / " .. killCardsTotal, "Health", 257.5, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Accolades", "OptionsHeader", 257.5, 0, white, TEXT_ALIGN_CENTER)

                        if accoladeCardsUnlocked == accoladeCardsTotal then
                            draw.SimpleText(accoladeCardsUnlocked .. " / " .. accoladeCardsTotal, "Health", 257.5, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(accoladeCardsUnlocked .. " / " .. accoladeCardsTotal, "Health", 257.5, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextLevel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Leveling", "OptionsHeader", 257.5, 0, white, TEXT_ALIGN_CENTER)

                        if levelCardsUnlocked == levelCardsTotal then
                            draw.SimpleText(levelCardsUnlocked .. " / " .. levelCardsTotal, "Health", 257.5, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(levelCardsUnlocked .. " / " .. levelCardsTotal, "Health", 257.5, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextMastery.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Mastery", "OptionsHeader", 257.5, 0, white, TEXT_ALIGN_CENTER)

                        if masteryCardsUnlocked == masteryCardsTotal then
                            draw.SimpleText(masteryCardsUnlocked .. " / " .. masteryCardsTotal, "Health", 257.5, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(masteryCardsUnlocked .. " / " .. masteryCardsTotal, "Health", 257.5, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextColor.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Colors", "OptionsHeader", 257.5, 0, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(colorCardsUnlocked .. " / " .. colorCardsTotal, "Health", 257.5, 55, solidGreen, TEXT_ALIGN_CENTER)
                    end

                    TextPride.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Pride", "OptionsHeader", 257.5, 0, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(prideCardsUnlocked .. " / " .. prideCardsTotal, "Health", 257.5, 55, solidGreen, TEXT_ALIGN_CENTER)
                    end

                    DockDefaultCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockKillCards.Paint = function(self, w, h)
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

                    local ApplyButtonHolder = vgui.Create("DPanel", CardsPreviewScroller)
                    ApplyButtonHolder:Dock(TOP)
                    ApplyButtonHolder:SetSize(0, 100)

                    ApplyButtonHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 80, 50, 200))
                    end

                    local ApplyCardButton = vgui.Create("DButton", ApplyButtonHolder)
                    ApplyCardButton:SetText("APPLY NEW PLAYERCARD")
                    ApplyCardButton:SetPos(82.5, 25)
                    ApplyCardButton:SetSize(350, 50)
                    ApplyCardButton.DoClick = function()
                        local masteryUnlock = 50
                        if newCardUnlockType == "default" or newCardUnlockType == "color" or newCardUnlockType == "pride" then
                            surface.PlaySound("common/wpn_select.wav")
                            net.Start("PlayerCardChange")
                            net.WriteString(newCard)
                            net.SendToServer()
                            plyCallingCard:SetImage(newCard)
                            MainPanel:Show()
                            SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                            CardPanel:Hide()
                            CardPreviewPanel:Hide()
                            CardSlideoutPanel:Hide()
                        elseif newCardUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "level" then
                            if playerTotalLevel < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "mastery" then
                            if LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) < masteryUnlock then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerCardChange")
                                net.WriteString(newCard)
                                net.SendToServer()
                                plyCallingCard:SetImage(newCard)
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end
                    end

                    function HideLockedCards:OnChange(bVal)
                        if (bVal) then
                            DefaultCardList:Clear()
                            KillCardList:Clear()
                            AccoladeCardList:Clear()
                            LevelCardList:Clear()
                            MasteryCardList:Clear()
                            ColorCardList:Clear()
                            PrideCardList:Clear()
                            cardsUnlocked = 0
                            defaultCardsTotal = 0
                            defaultCardsUnlocked = 0
                            killCardsTotal = 0
                            killCardsUnlocked = 0
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
                            DockDefaultCards:SetSize(0, 416)
                            DockKillCards:SetSize(0, (killCardsUnlocked * 42.5) + 42.5)
                            DockAccoladeCards:SetSize(0, (accoladeCardsUnlocked * 42.5) + 42.5)
                            DockLevelCards:SetSize(0, (levelCardsUnlocked * 42.5) + 42.5)
                            DockMasteryCards:SetSize(0, (masteryCardsUnlocked * 42.5) + 42.5)
                            DockColorCards:SetSize(0, 500)
                            DockPrideCards:SetSize(0, 416)
                        else
                            DefaultCardList:Clear()
                            KillCardList:Clear()
                            AccoladeCardList:Clear()
                            LevelCardList:Clear()
                            MasteryCardList:Clear()
                            ColorCardList:Clear()
                            PrideCardList:Clear()
                            cardsUnlocked = 0
                            defaultCardsTotal = 0
                            defaultCardsUnlocked = 0
                            killCardsTotal = 0
                            killCardsUnlocked = 0
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
                            DockDefaultCards:SetSize(0, 416)
                            DockKillCards:SetSize(0, 250)
                            DockAccoladeCards:SetSize(0, 1166)
                            DockLevelCards:SetSize(0, 2030)
                            DockMasteryCards:SetSize(0, 5357)
                            DockColorCards:SetSize(0, 500)
                            DockPrideCards:SetSize(0, 416)
                        end
                    end

                    local CardIcon = vgui.Create("DImage", CardQuickjumpHolder)
                    CardIcon:SetPos(12, 12)
                    CardIcon:SetSize(32, 32)
                    CardIcon:SetImage("icons/cardicon.png")

                    local DefaultJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    DefaultJump:SetPos(4, 100)
                    DefaultJump:SetSize(48, 48)
                    DefaultJump:SetImage("icons/unlockedicon.png")
                    DefaultJump:SetTooltip("Default")
                    DefaultJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextDefault)
                    end

                    local LevelJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    LevelJump:SetPos(4, 152)
                    LevelJump:SetSize(48, 48)
                    LevelJump:SetImage("icons/performanceicon.png")
                    LevelJump:SetTooltip("Leveling")
                    LevelJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextLevel)
                    end

                    local KillsJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    KillsJump:SetPos(4, 204)
                    KillsJump:SetSize(48, 48)
                    KillsJump:SetImage("icons/uikillicon.png")
                    KillsJump:SetTooltip("Kills")
                    KillsJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextKill)
                    end

                    local AccoladeJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    AccoladeJump:SetPos(4, 256)
                    AccoladeJump:SetSize(48, 48)
                    AccoladeJump:SetImage("icons/accoladeicon.png")
                    AccoladeJump:SetTooltip("Accolades")
                    AccoladeJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextAccolade)
                    end

                    local WeaponJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    WeaponJump:SetPos(4, 308)
                    WeaponJump:SetSize(48, 48)
                    WeaponJump:SetImage("icons/weaponicon.png")
                    WeaponJump:SetTooltip("Mastery")
                    WeaponJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextMastery)
                    end

                    local ColorJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    ColorJump:SetPos(4, 360)
                    ColorJump:SetSize(48, 48)
                    ColorJump:SetImage("icons/paletteicon.png")
                    ColorJump:SetTooltip("Colors")
                    ColorJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextColor)
                    end

                    local PrideJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    PrideJump:SetPos(4, 412)
                    PrideJump:SetSize(48, 48)
                    PrideJump:SetImage("icons/scoreicon.png")
                    PrideJump:SetTooltip("Pride")
                    PrideJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextPride)
                    end

                    local RandomizeButton = vgui.Create("DImageButton", CardQuickjumpHolder)
                    RandomizeButton:SetPos(12, ScrH() - 96)
                    RandomizeButton:SetSize(32, 32)
                    RandomizeButton:SetImage("icons/diceicon.png")
                    RandomizeButton:SetTooltip("Choose random card")
                    RandomizeButton.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        local rand = math.random(1, totalCards)

                        for k, v in pairs(cardArray) do
                            if k == rand then
                                newCard = v[1]
                                newCardName = v[2]
                                newCardDesc = v[3]
                                newCardUnlockType = v[4]
                                newCardUnlockValue = v[5]
                            end
                        end
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", CardQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        MainPanel:Show()
                        SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                        CardPanel:Hide()
                        CardPreviewPanel:Hide()
                        CardSlideoutPanel:Hide()
                    end
                end
            end

            CustomizeModelButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                MainPanel:Hide()
                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat() * 0.2)

                local currentModel = LocalPly:GetNWString("chosenPlayermodel")

                if not IsValid(CustomizePanel) then
                    local CustomizePanel = MainMenu:Add("CustomizePanel")
                    local CustomizeSlideoutPanel = MainMenu:Add("CustomizeSlideoutPanel")

                    local newModel
                    local newModelName
                    local newModelUnlockType
                    local newModelUnlockValue

                    local totalModels = table.Count(modelArray)
                    local modelsUnlocked = 0

                    local defaultModelsTotal = 0
                    local defaultModelsUnlocked = 0

                    local killModelsTotal = 0
                    local killModelsUnlocked = 0

                    local streakModelsTotal = 0
                    local streakModelsUnlocked = 0

                    local accoladeModelsTotal = 0
                    local accoladeModelsUnlocked = 0

                    --Checking for the players currently equipped model.
                    for k, v in pairs(modelArray) do
                        if v[1] == currentModel then
                            newModel = v[1]
                            newModelName = v[2]
                            newModelUnlockType = v[3]
                            newModelUnlockValue = v[4]
                        end
                    end

                    local ModelQuickjumpHolder = vgui.Create("DPanel", CustomizeSlideoutPanel)
                    ModelQuickjumpHolder:Dock(TOP)
                    ModelQuickjumpHolder:SetSize(0, ScrH())

                    ModelQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end

                    local CustomizeScroller = vgui.Create("DScrollPanel", CustomizePanel)
                    CustomizeScroller:Dock(FILL)

                    local sbar = CustomizeScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, gray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local CustomizeTextHolder = vgui.Create("DPanel", CustomizePanel)
                    CustomizeTextHolder:Dock(TOP)
                    CustomizeTextHolder:SetSize(0, 160)

                    CustomizeTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("MODELS", "AmmoCountSmall", w / 2, 5, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(modelsUnlocked .. " / " .. totalModels .. " models unlocked", "Health", w / 2, 85, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText("Hide locked playermodels", "StreakText", w / 2 + 20, 120, white, TEXT_ALIGN_CENTER)
                    end

                    local HideLockedModels = CustomizeTextHolder:Add("DCheckBox")
                    HideLockedModels:SetPos(120, 122.5)
                    HideLockedModels:SetSize(20, 20)
                    HideLockedModels:SetTooltip("Hide playermodels that you do not have unlocked.")    

                    --Default Playermodels
                    local TextDefault = vgui.Create("DPanel", CustomizeScroller)
                    TextDefault:Dock(TOP)
                    TextDefault:SetSize(0, 90)

                    local DockModels = vgui.Create("DPanel", CustomizeScroller)
                    DockModels:Dock(TOP)
                    DockModels:SetSize(0, 465)

                    --Kills Playermodels
                    local TextKills = vgui.Create("DPanel", CustomizeScroller)
                    TextKills:Dock(TOP)
                    TextKills:SetSize(0, 90)

                    local DockModelsKills = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsKills:Dock(TOP)
                    DockModelsKills:SetSize(0, 310)

                    --Streak Playermodels
                    local TextStreak = vgui.Create("DPanel", CustomizeScroller)
                    TextStreak:Dock(TOP)
                    TextStreak:SetSize(0, 90)

                    local DockModelsStreak = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsStreak:Dock(TOP)
                    DockModelsStreak:SetSize(0, 310)

                    --Accolade Playermodels
                    local TextAccolade = vgui.Create("DPanel", CustomizeScroller)
                    TextAccolade:Dock(TOP)
                    TextAccolade:SetSize(0, 90)

                    local DockModelsAccolade = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsAccolade:Dock(TOP)
                    DockModelsAccolade:SetSize(0, 1550)

                    --Creating playermodel lists
                    local DefaultModelList = vgui.Create("DIconLayout", DockModels)
                    DefaultModelList:Dock(TOP)
                    DefaultModelList:SetSpaceY(5)
                    DefaultModelList:SetSpaceX(5)

                    DefaultModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local KillsModelList = vgui.Create("DIconLayout", DockModelsKills)
                    KillsModelList:Dock(TOP)
                    KillsModelList:SetSpaceY(5)
                    KillsModelList:SetSpaceX(5)

                    KillsModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local StreakModelList = vgui.Create("DIconLayout", DockModelsStreak)
                    StreakModelList:Dock(TOP)
                    StreakModelList:SetSpaceY(5)
                    StreakModelList:SetSpaceX(5)

                    StreakModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local AccoladeModelList = vgui.Create("DIconLayout", DockModelsAccolade)
                    AccoladeModelList:Dock(TOP)
                    AccoladeModelList:SetSpaceY(5)
                    AccoladeModelList:SetSpaceX(5)

                    AccoladeModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local PreviewPanel = MainMenu:Add("CustomizePreviewPanel")

                    local PreviewScroller = vgui.Create("DScrollPanel", PreviewPanel)
                    PreviewScroller:Dock(FILL)

                    local sbar = PreviewScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, lightGray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local SelectedModelHolder = vgui.Create("DPanel", PreviewScroller)
                    SelectedModelHolder:Dock(TOP)
                    if ScrH() >= 1080 then SelectedModelHolder:SetSize(0, PreviewPanel:GetTall() - 100) else SelectedModelHolder:SetSize(0, PreviewPanel:GetTall()) end

                    SelectedModelHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)

                        if newModel ~= nil then
                            draw.SimpleText(newModelName, "PlayerNotiName", w / 2, 2.5, white, TEXT_ALIGN_CENTER)
                        end

                        if newModelUnlockType == "default" then
                            draw.SimpleText("Unlocked", "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                        elseif newModelUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newModelUnlockValue then
                                draw.SimpleText("Total Kills: " .. LocalPly:GetNWInt("playerKills") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Total Kills: " .. LocalPly:GetNWInt("playerKills") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newModelUnlockValue then
                                draw.SimpleText("Longest Kill Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Longest Kill Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newModelUnlockValue then
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newModelUnlockValue then
                                draw.SimpleText("Smackdowns: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Smackdowns: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newModelUnlockValue then
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newModelUnlockValue then
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newModelUnlockValue then
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newModelUnlockValue then
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newModelUnlockValue then
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        end
                    end

                    local SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                    SelectedModelDisplay:SetSize(475, 337.5)
                    SelectedModelDisplay:SetPos(0, 120)
                    SelectedModelDisplay:SetModel(newModel)

                    local function FillModelListsAll()
                        for k, v in pairs(modelArray) do
                            if v[3] == "default" then
                                local icon = vgui.Create("SpawnIcon", DockModels)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                DefaultModelList:Add(icon)

                                defaultModelsTotal = defaultModelsTotal + 1
                                modelsUnlocked = modelsUnlocked + 1
                                defaultModelsUnlocked = defaultModelsUnlocked + 1

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[3] == "kills" then
                                local icon = vgui.Create("SpawnIcon", DockModelsKills)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                KillsModelList:Add(icon)

                                killModelsTotal = killModelsTotal + 1

                                if LocalPly:GetNWInt("playerKills") < v[4] then
                                    local lockIndicator = vgui.Create("DImageButton", icon)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(96, 96)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelUnlockType = v[3]
                                        newModelUnlockValue = v[4]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(475, 337.5)
                                        SelectedModelDisplay:SetPos(0, 120)
                                        SelectedModelDisplay:SetModel(newModel)

                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                else
                                    killModelsUnlocked = killModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1
                                end

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[3] == "streak" then
                                local icon = vgui.Create("SpawnIcon", DockModelsStreak)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                StreakModelList:Add(icon)

                                streakModelsTotal = streakModelsTotal + 1

                                if LocalPly:GetNWInt("highestKillStreak") < v[4] then
                                    local lockIndicator = vgui.Create("DImageButton", icon)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(96, 96)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelUnlockType = v[3]
                                        newModelUnlockValue = v[4]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(475, 337.5)
                                        SelectedModelDisplay:SetPos(0, 120)
                                        SelectedModelDisplay:SetModel(newModel)

                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                else
                                    streakModelsUnlocked = streakModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1
                                end

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[3] == "headshot" or v[3] == "smackdown" or v[3] == "clutch" or v[3] == "longshot" or v[3] == "pointblank" or v[3] == "killstreaks" or v[3] == "buzzkills" then
                                local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                AccoladeModelList:Add(icon)

                                accoladeModelsTotal = accoladeModelsTotal + 1

                                if v[3] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") < v[4] or v[3] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") < v[4] or v[3] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") < v[4] or v[3] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") < v[4] or v[3] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") < v[4] or v[3] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") < v[4] or v[3] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") < v[4] then
                                    local lockIndicator = vgui.Create("DImageButton", icon)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(96, 96)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelUnlockType = v[3]
                                        newModelUnlockValue = v[4]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(475, 337.5)
                                        SelectedModelDisplay:SetPos(0, 120)
                                        SelectedModelDisplay:SetModel(newModel)

                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                else
                                    accoladeModelsUnlocked = accoladeModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1
                                end

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            end
                        end
                    end

                    local function FillModelListsUnlocked()
                        for k, v in pairs(modelArray) do
                            if v[3] == "default" then
                                local icon = vgui.Create("SpawnIcon", DockModels)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                DefaultModelList:Add(icon)

                                defaultModelsTotal = defaultModelsTotal + 1
                                modelsUnlocked = modelsUnlocked + 1
                                defaultModelsUnlocked = defaultModelsUnlocked + 1

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[3] == "kills" then
                                killModelsTotal = killModelsTotal + 1
                                if LocalPly:GetNWInt("playerKills") >= v[4] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsKills)
                                    icon:SetModel(v[1])
                                    icon:SetTooltip(v[2])
                                    icon:SetSize(150, 150)
                                    KillsModelList:Add(icon)

                                    killModelsUnlocked = killModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.DoClick = function(icon)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelUnlockType = v[3]
                                        newModelUnlockValue = v[4]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(475, 337.5)
                                        SelectedModelDisplay:SetPos(0, 120)
                                        SelectedModelDisplay:SetModel(newModel)

                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                end
                            elseif v[3] == "streak" then
                                streakModelsTotal = streakModelsTotal + 1

                                if LocalPly:GetNWInt("highestKillStreak") >= v[4] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsStreak)
                                    icon:SetModel(v[1])
                                    icon:SetTooltip(v[2])
                                    icon:SetSize(150, 150)
                                    StreakModelList:Add(icon)

                                    streakModelsUnlocked = streakModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.DoClick = function(icon)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelUnlockType = v[3]
                                        newModelUnlockValue = v[4]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(475, 337.5)
                                        SelectedModelDisplay:SetPos(0, 120)
                                        SelectedModelDisplay:SetModel(newModel)

                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                end
                            elseif v[3] == "headshot" or v[3] == "smackdown" or v[3] == "clutch" or v[3] == "longshot" or v[3] == "pointblank" or v[3] == "killstreaks" or v[3] == "buzzkills" then
                                accoladeModelsTotal = accoladeModelsTotal + 1

                                if v[3] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") >= v[4] or v[3] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") >= v[4] or v[3] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") >= v[4] or v[3] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") >= v[4] or v[3] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") >= v[4] or v[3] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") >= v[4] or v[3] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") >= v[4] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                                    icon:SetModel(v[1])
                                    icon:SetTooltip(v[2])
                                    icon:SetSize(150, 150)
                                    AccoladeModelList:Add(icon)

                                    accoladeModelsUnlocked = accoladeModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.DoClick = function(icon)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelUnlockType = v[3]
                                        newModelUnlockValue = v[4]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(475, 337.5)
                                        SelectedModelDisplay:SetPos(0, 120)
                                        SelectedModelDisplay:SetModel(newModel)

                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                end
                            end
                        end
                    end

                    FillModelListsAll()

                    TextDefault.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Default", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(defaultModelsUnlocked .. " / " .. defaultModelsTotal, "Health", w / 2, 55, solidGreen, TEXT_ALIGN_CENTER)
                    end

                    TextKills.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Kills", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)

                        if killModelsUnlocked == killModelsTotal then
                            draw.SimpleText(killModelsUnlocked .. " / " .. killModelsTotal, "Health", w / 2, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(killModelsUnlocked .. " / " .. killModelsTotal, "Health", w / 2, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextStreak.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Streaks", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)

                        if streakModelsUnlocked == streakModelsTotal then
                            draw.SimpleText(streakModelsUnlocked .. " / " .. streakModelsTotal, "Health", w / 2, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(streakModelsUnlocked .. " / " .. streakModelsTotal, "Health", w / 2, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Accolades", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)

                        if accoladeModelsUnlocked == accoladeModelsTotal then
                            draw.SimpleText(accoladeModelsUnlocked .. " / " .. accoladeModelsTotal, "Health", w / 2, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(accoladeModelsUnlocked .. " / " .. accoladeModelsTotal, "Health", w / 2, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    DockModels.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockModelsKills.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockModelsStreak.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockModelsAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    local ApplyButtonHolder = vgui.Create("DPanel", PreviewScroller)
                    ApplyButtonHolder:Dock(TOP)
                    ApplyButtonHolder:SetSize(0, 100)

                    ApplyButtonHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 80, 50, 200))
                    end

                    local ApplyModelButton = vgui.Create("DButton", ApplyButtonHolder)
                    ApplyModelButton:SetText("APPLY NEW PLAYERMODEL")
                    ApplyModelButton:SetPos(62.5, 25)
                    ApplyModelButton:SetSize(350, 50)
                    ApplyModelButton.DoClick = function()
                        if newModelUnlockType == "default" then
                            surface.PlaySound("common/wpn_select.wav")
                            net.Start("PlayerModelChange")
                            net.WriteString(newModel)
                            net.SendToServer()
                            MainPanel:Show()
                            SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                            CustomizeSlideoutPanel:Hide()
                            CustomizePanel:Hide()
                            PreviewPanel:Hide()
                        elseif newModelUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        end
                    end

                    function HideLockedModels:OnChange(bVal)
                        if (bVal) then
                            DefaultModelList:Clear()
                            KillsModelList:Clear()
                            StreakModelList:Clear()
                            AccoladeModelList:Clear()
                            modelsUnlocked = 0
                            defaultModelsTotal = 0
                            defaultModelsUnlocked = 0
                            killModelsTotal = 0
                            killModelsUnlocked = 0
                            streakModelsTotal = 0
                            streakModelsUnlocked = 0
                            accoladeModelsTotal = 0
                            accoladeModelsUnlocked = 0
                            FillModelListsUnlocked()
                            DockModels:SetSize(0, 465)
                            DockModelsKills:SetSize(0, (killModelsUnlocked * 51.6) + 103.2)
                            DockModelsStreak:SetSize(0, (streakModelsUnlocked * 51.6) + 103.2)
                            DockModelsAccolade:SetSize(0, (accoladeModelsUnlocked * 51.6) + 103.2)
                        else
                            DefaultModelList:Clear()
                            KillsModelList:Clear()
                            StreakModelList:Clear()
                            AccoladeModelList:Clear()
                            modelsUnlocked = 0
                            defaultModelsTotal = 0
                            defaultModelsUnlocked = 0
                            killModelsTotal = 0
                            killModelsUnlocked = 0
                            streakModelsTotal = 0
                            streakModelsUnlocked = 0
                            accoladeModelsTotal = 0
                            accoladeModelsUnlocked = 0
                            FillModelListsAll()
                            DockModels:SetSize(0, 465)
                            DockModelsKills:SetSize(0, 310)
                            DockModelsStreak:SetSize(0, 310)
                            DockModelsAccolade:SetSize(0, 1550)
                        end
                    end

                    local ModelIcon = vgui.Create("DImage", ModelQuickjumpHolder)
                    ModelIcon:SetPos(12, 12)
                    ModelIcon:SetSize(32, 32)
                    ModelIcon:SetImage("icons/modelicon.png")

                    local DefaultJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    DefaultJump:SetPos(4, 100)
                    DefaultJump:SetSize(48, 48)
                    DefaultJump:SetImage("icons/unlockedicon.png")
                    DefaultJump:SetTooltip("Default")
                    DefaultJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CustomizeScroller:ScrollToChild(TextDefault)
                    end

                    local KillsJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    KillsJump:SetPos(4, 152)
                    KillsJump:SetSize(48, 48)
                    KillsJump:SetImage("icons/uikillicon.png")
                    KillsJump:SetTooltip("Kills")
                    KillsJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CustomizeScroller:ScrollToChild(TextKills)
                    end

                    local StreaksJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    StreaksJump:SetPos(4, 204)
                    StreaksJump:SetSize(48, 48)
                    StreaksJump:SetImage("icons/streakicon.png")
                    StreaksJump:SetTooltip("Streaks")
                    StreaksJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CustomizeScroller:ScrollToChild(TextStreak)
                    end

                    local AccoladeJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    AccoladeJump:SetPos(4, 256)
                    AccoladeJump:SetSize(48, 48)
                    AccoladeJump:SetImage("icons/accoladeicon.png")
                    AccoladeJump:SetTooltip("Accolades")
                    AccoladeJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CustomizeScroller:ScrollToChild(TextAccolade)
                    end

                    local RandomizeButton = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    RandomizeButton:SetPos(12, ScrH() - 96)
                    RandomizeButton:SetSize(32, 32)
                    RandomizeButton:SetImage("icons/diceicon.png")
                    RandomizeButton:SetTooltip("Choose random model")
                    RandomizeButton.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        local rand = math.random(1, totalModels)

                        for k, v in pairs(modelArray) do
                            if k == rand then
                                newModel = v[1]
                                newModelName = v[2]
                                newModelUnlockType = v[3]
                                newModelUnlockValue = v[4]

                                SelectedModelDisplay:Remove()

                                SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                SelectedModelDisplay:SetSize(475, 337.5)
                                SelectedModelDisplay:SetPos(0, 120)
                                SelectedModelDisplay:SetModel(newModel)
                            end
                        end
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        MainPanel:Show()
                        SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                        CustomizeSlideoutPanel:Hide()
                        CustomizePanel:Hide()
                        PreviewPanel:Hide()
                    end
                end
            end

            local OptionsButton = vgui.Create("DButton", MainPanel)
            local OptionsSettingsButton = vgui.Create("DButton", OptionsButton)
            local OptionsHUDButton = vgui.Create("DButton", OptionsButton)
            OptionsButton:SetPos(0, ScrH() / 2)
            OptionsButton:SetText("")
            OptionsButton:SetSize(415, 100)
            local textAnim = 0
            OptionsButton.Paint = function()
                if OptionsButton:IsHovered() or OptionsSettingsButton:IsHovered() or OptionsHUDButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                    pushExitItems = math.Clamp(pushExitItems + 600 * FrameTime(), 100, 150)
                    OptionsButton:SizeTo(-1, 200, 0, 0, 1)
                else
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                    pushExitItems = math.Clamp(pushExitItems - 600 * FrameTime(), 100, 150)
                    OptionsButton:SizeTo(-1, 100, 0, 0, 1)
                end
                draw.DrawText("OPTIONS", "AmmoCountSmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            OptionsSettingsButton:SetPos(0, 100)
            OptionsSettingsButton:SetText("")
            OptionsSettingsButton:SetSize(235, 100)
            OptionsSettingsButton.Paint = function()
                draw.DrawText("SETTINGS", "AmmoCountESmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            OptionsHUDButton:SetPos(240, 100)
            OptionsHUDButton:SetText("")
            OptionsHUDButton:SetSize(245, 100)
            OptionsHUDButton.Paint = function()
                draw.DrawText("HUD", "AmmoCountESmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            OptionsSettingsButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                MainPanel:Hide()

                if not IsValid(OptionsPanel) then
                    local OptionsPanel = MainMenu:Add("OptionsPanel")
                    local OptionsSlideoutPanel = MainMenu:Add("OptionsSlideoutPanel")

                    local OptionsQuickjumpHolder = vgui.Create("DPanel", OptionsSlideoutPanel)
                    OptionsQuickjumpHolder:Dock(TOP)
                    OptionsQuickjumpHolder:SetSize(0, ScrH())

                    OptionsQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end

                    local OptionsScroller = vgui.Create("DScrollPanel", OptionsPanel)
                    OptionsScroller:Dock(FILL)

                    local sbar = OptionsScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, gray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local DockAccount = vgui.Create("DPanel", OptionsScroller)
                    DockAccount:Dock(TOP)
                    DockAccount:SetSize(0, 110)

                    local DockInputs = vgui.Create("DPanel", OptionsScroller)
                    DockInputs:Dock(TOP)
                    DockInputs:SetSize(0, 280)

                    local DockUI = vgui.Create("DPanel", OptionsScroller)
                    DockUI:Dock(TOP)
                    DockUI:SetSize(0, 355)

                    local DockAudio = vgui.Create("DPanel", OptionsScroller)
                    DockAudio:Dock(TOP)
                    DockAudio:SetSize(0, 320)

                    local DockWeaponry = vgui.Create("DPanel", OptionsScroller)
                    DockWeaponry:Dock(TOP)
                    DockWeaponry:SetSize(0, 375)

                    local DockCrosshair = vgui.Create("DPanel", OptionsScroller)
                    DockCrosshair:Dock(TOP)
                    DockCrosshair:SetSize(0, 675)

                    local DockHitmarker = vgui.Create("DPanel", OptionsScroller)
                    DockHitmarker:Dock(TOP)
                    DockHitmarker:SetSize(0, 315)

                    local DockPerformance = vgui.Create("DPanel", OptionsScroller)
                    DockPerformance:Dock(TOP)
                    DockPerformance:SetSize(0, 360)

                    local SettingsCog = vgui.Create("DImage", OptionsQuickjumpHolder)
                    SettingsCog:SetPos(12, 12)
                    SettingsCog:SetSize(32, 32)
                    SettingsCog:SetImage("icons/settingsicon.png")

                    local AccountJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    AccountJump:SetPos(4, 100)
                    AccountJump:SetSize(48, 48)
                    AccountJump:SetTooltip("Account")
                    AccountJump:SetImage("icons/modelicon.png")
                    AccountJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        OptionsScroller:ScrollToChild(DockAccount)
                    end

                    local InputsJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    InputsJump:SetPos(4, 152)
                    InputsJump:SetSize(48, 48)
                    InputsJump:SetTooltip("Input")
                    InputsJump:SetImage("icons/mouseicon.png")
                    InputsJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockInputs)
                    end

                    local UIJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    UIJump:SetPos(4, 204)
                    UIJump:SetSize(48, 48)
                    UIJump:SetTooltip("Interface")
                    UIJump:SetImage("icons/uiicon.png")
                    UIJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        OptionsScroller:ScrollToChild(DockUI)
                    end

                    local AudioJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    AudioJump:SetPos(4, 256)
                    AudioJump:SetSize(48, 48)
                    AudioJump:SetTooltip("Audio")
                    AudioJump:SetImage("icons/audioicon.png")
                    AudioJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        OptionsScroller:ScrollToChild(DockAudio)
                    end

                    local WeaponJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    WeaponJump:SetPos(4, 308)
                    WeaponJump:SetSize(48, 48)
                    WeaponJump:SetTooltip("Weaponry")
                    WeaponJump:SetImage("icons/weaponicon.png")
                    WeaponJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        OptionsScroller:ScrollToChild(DockWeaponry)
                    end

                    local CrosshairJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    CrosshairJump:SetPos(4, 360)
                    CrosshairJump:SetSize(48, 48)
                    CrosshairJump:SetTooltip("Crosshair")
                    CrosshairJump:SetImage("icons/crosshairicon.png")
                    CrosshairJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        OptionsScroller:ScrollToChild(DockCrosshair)
                    end

                    local HitmarkerJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    HitmarkerJump:SetPos(4, 412)
                    HitmarkerJump:SetSize(48, 48)
                    HitmarkerJump:SetTooltip("Hitmarkers")
                    HitmarkerJump:SetImage("icons/hitmarkericon.png")
                    HitmarkerJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        OptionsScroller:ScrollToChild(DockHitmarker)
                    end

                    local PerformanceJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    PerformanceJump:SetPos(4, 464)
                    PerformanceJump:SetSize(48, 48)
                    PerformanceJump:SetTooltip("Performance")
                    PerformanceJump:SetImage("icons/performanceicon.png")
                    PerformanceJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        OptionsScroller:ScrollToChild(DockPerformance)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        MainPanel:Show()
                        OptionsSlideoutPanel:Hide()
                        OptionsPanel:Hide()
                    end

                    DockAccount.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("ACCOUNT", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Hide Lifetime Stats From Others", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                    end

                    local hideStatsFromOthers = DockAccount:Add("DCheckBox")
                    hideStatsFromOthers:SetPos(20, 70)
                    hideStatsFromOthers:SetConVar("tm_hidestatsfromothers")
                    hideStatsFromOthers:SetSize(30, 30)
                    hideStatsFromOthers:SetTooltip("Hides your own personal stats from other players, making them only viewable by you.")

                    DockInputs.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("INPUT", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("ADS Sensitivity", "SettingsLabel", 155, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Compensate Sensitivity w/ FOV", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Main Menu Keybind", "SettingsLabel", 135, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Grenade Keybind", "SettingsLabel", 135, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Grappling Hook Keybind", "SettingsLabel", 135, 225, white, TEXT_ALIGN_LEFT)
                    end

                    local adsSensitivity = DockInputs:Add("DNumSlider")
                    adsSensitivity:SetPos(-85, 70)
                    adsSensitivity:SetSize(250, 30)
                    adsSensitivity:SetConVar("cl_tfa_scope_sensitivity")
                    adsSensitivity:SetMin(0)
                    adsSensitivity:SetMax(100)
                    adsSensitivity:SetDecimals(0)
                    adsSensitivity:SetTooltip("Adjust the sensitivity while aiming down sights.")

                    local compensateSensWithFOV = DockInputs:Add("DCheckBox")
                    compensateSensWithFOV:SetPos(20, 110)
                    compensateSensWithFOV:SetConVar("cl_tfa_scope_sensitivity_autoscale")
                    compensateSensWithFOV:SetSize(30, 30)
                    compensateSensWithFOV:SetTooltip("Change the ADS sensitivity depending on the weapons FOV.")

                    local mainMenuBind = DockInputs:Add("DBinder")
                    mainMenuBind:SetPos(22.5, 150)
                    mainMenuBind:SetSize(100, 30)
                    mainMenuBind:SetSelectedNumber(GetConVar("tm_mainmenubind"):GetInt())
                    mainMenuBind:SetTooltip("Adjust the keybind for opening the main menu.")
                    function mainMenuBind:OnChange(num)
                        surface.PlaySound("tmui/buttonrollover.wav")
                        selectedMenuBind = mainMenuBind:GetSelectedNumber()
                        RunConsoleCommand("tm_mainmenubind", selectedMenuBind)
                    end

                    local grenadeBind = DockInputs:Add("DBinder")
                    grenadeBind:SetPos(22.5, 190)
                    grenadeBind:SetSize(100, 30)
                    grenadeBind:SetSelectedNumber(GetConVar("tm_nadebind"):GetInt())
                    grenadeBind:SetTooltip("Adjust the keybind for throwing a grenade.")
                    function grenadeBind:OnChange(num)
                        surface.PlaySound("tmui/buttonrollover.wav")
                        selectedGrenadeBind = grenadeBind:GetSelectedNumber()
                        RunConsoleCommand("tm_nadebind", selectedGrenadeBind)
                    end

                    local grappleBind = DockInputs:Add("DBinder")
                    grappleBind:SetPos(22.5, 230)
                    grappleBind:SetSize(100, 30)
                    grappleBind:SetSelectedNumber(GetConVar("frest_bindg"):GetInt())
                    grappleBind:SetTooltip("Adjust the keybind for using a grappling hook")
                    function grappleBind:OnChange(num)
                        surface.PlaySound("tmui/buttonrollover.wav")
                        selectedGrappleBind = grappleBind:GetSelectedNumber()
                        RunConsoleCommand("frest_bindg", selectedGrappleBind)
                    end

                    DockUI.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("INTERFACE", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable UI", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Reload Hints", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Loadout Hints", "SettingsLabel", 55, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill Tracker", "SettingsLabel", 55, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Keypress Overlay", "SettingsLabel", 55, 225, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("FPS/Ping Counter", "SettingsLabel", 55, 265, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Velocity Counter", "SettingsLabel", 55, 305, white, TEXT_ALIGN_LEFT)
                    end

                    local enableUIButton = DockUI:Add("DCheckBox")
                    enableUIButton:SetPos(20, 70)
                    enableUIButton:SetConVar("tm_hud_enable")
                    enableUIButton:SetSize(30, 30)
                    enableUIButton:SetTooltip("Enable the UI.")

                    local reloadHintsToggle = DockUI:Add("DCheckBox")
                    reloadHintsToggle:SetPos(20, 110)
                    reloadHintsToggle:SetConVar("tm_hud_reloadhint")
                    reloadHintsToggle:SetSize(30, 30)
                    reloadHintsToggle:SetTooltip("Enable visual cues when you need to reload.")

                    local loadoutHintsToggle = DockUI:Add("DCheckBox")
                    loadoutHintsToggle:SetPos(20, 150)
                    loadoutHintsToggle:SetConVar("tm_hud_loadouthint")
                    loadoutHintsToggle:SetSize(30, 30)
                    loadoutHintsToggle:SetTooltip("Enable the loadout hud when you respawn.")

                    local killTrackerToggle = DockUI:Add("DCheckBox")
                    killTrackerToggle:SetPos(20, 190)
                    killTrackerToggle:SetConVar("tm_hud_killtracker")
                    killTrackerToggle:SetSize(30, 30)
                    killTrackerToggle:SetTooltip("Enable the weapon specific kill tracking on the HUD.")

                    local keypressOverlayToggle = DockUI:Add("DCheckBox")
                    keypressOverlayToggle:SetPos(20, 230)
                    keypressOverlayToggle:SetConVar("tm_hud_keypressoverlay")
                    keypressOverlayToggle:SetSize(30, 30)
                    keypressOverlayToggle:SetTooltip("Enable a HUD element showing which keys are being pressed.")

                    local FPSPingCounterToggle = DockUI:Add("DCheckBox")
                    FPSPingCounterToggle:SetPos(20, 270)
                    FPSPingCounterToggle:SetConVar("tm_hud_fpscounter")
                    FPSPingCounterToggle:SetSize(30, 30)
                    FPSPingCounterToggle:SetTooltip("Enable a HUD element that shows your FPS and ping.")

                    local VelocityCounterToggle = DockUI:Add("DCheckBox")
                    VelocityCounterToggle:SetPos(20, 310)
                    VelocityCounterToggle:SetConVar("tm_hud_velocitycounter")
                    VelocityCounterToggle:SetSize(30, 30)
                    VelocityCounterToggle:SetTooltip("Enable a HUD element that shows your velocity.")

                    DockAudio.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("AUDIO", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable Hit Sounds", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Kill Sounds", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hit Sound Style", "SettingsLabel", 125, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill Sound Style", "SettingsLabel", 125, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Menu Music", "SettingsLabel", 55, 225, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Menu Music Volume", "SettingsLabel", 155, 265, white, TEXT_ALIGN_LEFT)
                    end

                    local hitSoundsButton = DockAudio:Add("DCheckBox")
                    hitSoundsButton:SetPos(20, 70)
                    hitSoundsButton:SetConVar("tm_hitsounds")
                    hitSoundsButton:SetSize(30, 30)
                    hitSoundsButton:SetTooltip("Enable the hitsounds.")

                    local killSoundButton = DockAudio:Add("DCheckBox")
                    killSoundButton:SetPos(20, 110)
                    killSoundButton:SetConVar("tm_killsound")
                    killSoundButton:SetSize(30, 30)
                    killSoundButton:SetTooltip("Enable the kill conformation sound.")

                    local hitSoundsType = DockAudio:Add("DComboBox")
                    hitSoundsType:SetPos(20, 150)
                    hitSoundsType:SetSize(100, 30)
                    hitSoundsType:SetTooltip("Adjust the style of the hitsounds.")
                    if GetConVar("tm_hitsoundtype"):GetInt() == 0 then hitSoundsType:SetValue("Rust") elseif GetConVar("tm_hitsoundtype"):GetInt() == 1 then hitSoundsType:SetValue("TABG") elseif GetConVar("tm_hitsoundtype"):GetInt() == 2 then hitSoundsType:SetValue("Bartol") elseif GetConVar("tm_hitsoundtype"):GetInt() == 3 then hitSoundsType:SetValue("Bad Business") end
                    hitSoundsType:AddChoice("Rust")
                    hitSoundsType:AddChoice("TABG")
                    hitSoundsType:AddChoice("Bartol")
                    hitSoundsType:AddChoice("Bad Business")
                    hitSoundsType.OnSelect = function(self, value)
                        surface.PlaySound("hitsound/hit_" .. value - 1 .. ".wav")
                        RunConsoleCommand("tm_hitsoundtype", value - 1)
                    end

                    local killSoundsType = DockAudio:Add("DComboBox")
                    killSoundsType:SetPos(20, 190)
                    killSoundsType:SetSize(100, 30)
                    killSoundsType:SetTooltip("Adjust the style of the kill confirmation sound.")
                    if GetConVar("tm_killsoundtype"):GetInt() == 0 then killSoundsType:SetValue("Call Of Duty") elseif GetConVar("tm_killsoundtype"):GetInt() == 1 then killSoundsType:SetValue("TABG") elseif GetConVar("tm_killsoundtype"):GetInt() == 2 then killSoundsType:SetValue("Bad Business") end
                    killSoundsType:AddChoice("Call Of Duty")
                    killSoundsType:AddChoice("TABG")
                    killSoundsType:AddChoice("Bad Business")
                    killSoundsType.OnSelect = function(self, value)
                        surface.PlaySound("hitsound/kill_" .. value - 1 .. ".wav")
                        RunConsoleCommand("tm_killsoundtype", value - 1)
                    end

                    local menuMusicButton = DockAudio:Add("DCheckBox")
                    menuMusicButton:SetPos(20, 230)
                    menuMusicButton:SetConVar("tm_menumusic")
                    menuMusicButton:SetSize(30, 30)
                    menuMusicButton:SetTooltip("Enable music while in the menu.")

                    function menuMusicButton:OnChange(bVal)
                        if (bVal) then
                            ResumeMusic()
                        else
                            PauseMusic()
                        end
                    end

                    local menuMusicVolume = DockAudio:Add("DNumSlider")
                    menuMusicVolume:SetPos(-85, 270)
                    menuMusicVolume:SetSize(250, 30)
                    menuMusicVolume:SetConVar("tm_menumusicvolume")
                    menuMusicVolume:SetMin(0)
                    menuMusicVolume:SetMax(2)
                    menuMusicVolume:SetDecimals(2)
                    menuMusicVolume:SetTooltip("Adjust the volume of the menu music.")

                    menuMusicVolume.OnValueChanged = function(self, value)
                        SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                    end

                    DockWeaponry.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("WEAPONRY", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Centered Gun", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Flashlight Color", "SettingsLabel", 245, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Reticle Color", "SettingsLabel", 245, 235, white, TEXT_ALIGN_LEFT)
                    end

                    local centeredVM = DockWeaponry:Add("DCheckBox")
                    centeredVM:SetPos(20, 70)
                    centeredVM:SetConVar("cl_tfa_viewmodel_centered")
                    centeredVM:SetSize(30, 30)
                    centeredVM:SetTooltip("Centeres your viewmodel towards the middle of your screen.")

                    local flashlightMixer = vgui.Create("DColorMixer", DockWeaponry)
                    flashlightMixer:SetPos(20, 110)
                    flashlightMixer:SetSize(215, 110)
                    flashlightMixer:SetConVarR("tpf_cl_color_red")
                    flashlightMixer:SetConVarG("tpf_cl_color_green")
                    flashlightMixer:SetConVarB("tpf_cl_color_blue")
                    flashlightMixer:SetAlphaBar(false)
                    flashlightMixer:SetPalette(false)
                    flashlightMixer:SetWangs(true)
                    flashlightMixer:SetTooltip("Change the color of your flashlight.")

                    local reticleMixer = vgui.Create("DColorMixer", DockWeaponry)
                    reticleMixer:SetPos(20, 250)
                    reticleMixer:SetSize(215, 110)
                    reticleMixer:SetConVarR("cl_tfa_reticule_color_r")
                    reticleMixer:SetConVarG("cl_tfa_reticule_color_g")
                    reticleMixer:SetConVarB("cl_tfa_reticule_color_b")
                    reticleMixer:SetAlphaBar(false)
                    reticleMixer:SetPalette(false)
                    reticleMixer:SetWangs(true)
                    reticleMixer:SetTooltip("Override the color of the reticle on sights and scopes.")

                    DockCrosshair.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("CROSSHAIR", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable Crosshair", "SettingsLabel", 55 , 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Dot", "SettingsLabel", 55 , 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Pump Feedback", "SettingsLabel", 55 , 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Triangular Crosshair", "SettingsLabel", 55 , 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Color", "SettingsLabel", 245 , 225, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Length", "SettingsLabel", 155, 345, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Width", "SettingsLabel", 155, 385, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Gap Scale", "SettingsLabel", 155, 425, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Outline", "SettingsLabel", 55, 465, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Outline Width", "SettingsLabel", 155, 505, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Outline Color", "SettingsLabel", 245 , 545, white, TEXT_ALIGN_LEFT)
                    end

                    local crosshairToggle = DockCrosshair:Add("DCheckBox")
                    crosshairToggle:SetPos(20, 70)
                    crosshairToggle:SetConVar("cl_tfa_hud_crosshair_enable_custom")
                    crosshairToggle:SetSize(30, 30)
                    crosshairToggle:SetTooltip("Disables the custom crosshair and reverts back to the HL2 default.")

                    local dotToggle = DockCrosshair:Add("DCheckBox")
                    dotToggle:SetPos(20, 110)
                    dotToggle:SetConVar("cl_tfa_hud_crosshair_dot")
                    dotToggle:SetSize(30, 30)
                    dotToggle:SetTooltip("Enable a dot in the middle of your crosshair.")

                    local pumpToggle = DockCrosshair:Add("DCheckBox")
                    pumpToggle:SetPos(20, 150)
                    pumpToggle:SetConVar("cl_tfa_hud_crosshair_pump")
                    pumpToggle:SetSize(30, 30)
                    pumpToggle:SetTooltip("Rotates your crosshair during a sniper rechamber/shotgun pump.")

                    local triangleToggle = DockCrosshair:Add("DCheckBox")
                    triangleToggle:SetPos(20, 190)
                    triangleToggle:SetConVar("cl_tfa_hud_crosshair_triangular")
                    triangleToggle:SetSize(30, 30)
                    triangleToggle:SetTooltip("Adjusts your crosshair to a triangular shape.")

                    local crosshairMixer = vgui.Create("DColorMixer", DockCrosshair)
                    crosshairMixer:SetPos(20, 230)
                    crosshairMixer:SetSize(215, 110)
                    crosshairMixer:SetConVarR("cl_tfa_hud_crosshair_color_r")
                    crosshairMixer:SetConVarG("cl_tfa_hud_crosshair_color_g")
                    crosshairMixer:SetConVarB("cl_tfa_hud_crosshair_color_b")
                    crosshairMixer:SetConVarA("cl_tfa_hud_crosshair_color_a")
                    crosshairMixer:SetAlphaBar(true)
                    crosshairMixer:SetPalette(false)
                    crosshairMixer:SetWangs(true)
                    crosshairMixer:SetTooltip("Adjusts your crosshairs color.")

                    local crosshairLength = DockCrosshair:Add("DNumSlider")
                    crosshairLength:SetPos(-85, 350)
                    crosshairLength:SetSize(250, 30)
                    crosshairLength:SetConVar("cl_tfa_hud_crosshair_length")
                    crosshairLength:SetMin(0.2)
                    crosshairLength:SetMax(2)
                    crosshairLength:SetDecimals(1)
                    crosshairLength:SetTooltip("Adjusts your crosshairs length.")

                    local crosshairWidth = DockCrosshair:Add("DNumSlider")
                    crosshairWidth:SetPos(-85, 390)
                    crosshairWidth:SetSize(250, 30)
                    crosshairWidth:SetConVar("cl_tfa_hud_crosshair_width")
                    crosshairWidth:SetMin(1)
                    crosshairWidth:SetMax(4)
                    crosshairWidth:SetDecimals(1)
                    crosshairWidth:SetTooltip("Adjusts your crosshairs width.")

                    local crosshairGap = DockCrosshair:Add("DNumSlider")
                    crosshairGap:SetPos(-85, 430)
                    crosshairGap:SetSize(250, 30)
                    crosshairGap:SetConVar("cl_tfa_hud_crosshair_gap_scale")
                    crosshairGap:SetMin(0)
                    crosshairGap:SetMax(3)
                    crosshairGap:SetDecimals(1)
                    crosshairGap:SetTooltip("Adjust the gap between your crosshair.")

                    local outlineToggle = DockCrosshair:Add("DCheckBox")
                    outlineToggle:SetPos(20, 470)
                    outlineToggle:SetConVar("cl_tfa_hud_crosshair_outline_enabled")
                    outlineToggle:SetSize(30, 30)
                    outlineToggle:SetTooltip("Enable a outline that wraps around your crosshair.")

                    local outlineWidth = DockCrosshair:Add("DNumSlider")
                    outlineWidth:SetPos(-85, 510)
                    outlineWidth:SetSize(250, 30)
                    outlineWidth:SetConVar("cl_tfa_hud_crosshair_outline_width")
                    outlineWidth:SetMin(0)
                    outlineWidth:SetMax(3)
                    outlineWidth:SetDecimals(1)
                    outlineWidth:SetTooltip("Adjusts your crosshairs outline width.")

                    local outlineMixer = vgui.Create("DColorMixer", DockCrosshair)
                    outlineMixer:SetPos(20, 550)
                    outlineMixer:SetSize(215, 110)
                    outlineMixer:SetConVarR("cl_tfa_hud_crosshair_outline_color_r")
                    outlineMixer:SetConVarG("cl_tfa_hud_crosshair_outline_color_g")
                    outlineMixer:SetConVarB("cl_tfa_hud_crosshair_outline_color_b")
                    outlineMixer:SetConVarA("cl_tfa_hud_crosshair_outline_color_a")
                    outlineMixer:SetAlphaBar(true)
                    outlineMixer:SetPalette(false)
                    outlineMixer:SetWangs(true)
                    outlineMixer:SetTooltip("Change the color of your crosshairs outline.")

                    DockHitmarker.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("HITMARKERS", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable Hitmarkers", "SettingsLabel", 55 , 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("3D/Dynamic Hitmarkers", "SettingsLabel", 55 , 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker Scale", "SettingsLabel", 155, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker Color", "SettingsLabel", 245 , 185, white, TEXT_ALIGN_LEFT)
                    end

                    local hitmarkerToggle = DockHitmarker:Add("DCheckBox")
                    hitmarkerToggle:SetPos(20, 70)
                    hitmarkerToggle:SetConVar("cl_tfa_hud_hitmarker_enabled")
                    hitmarkerToggle:SetSize(30, 30)
                    hitmarkerToggle:SetTooltip("Enable hitmarkers (hit indication when you damage an enemy.)")

                    local hitmarkerDynamicToggle = DockHitmarker:Add("DCheckBox")
                    hitmarkerDynamicToggle:SetPos(20, 110)
                    hitmarkerDynamicToggle:SetConVar("cl_tfa_hud_hitmarker_3d_all")
                    hitmarkerDynamicToggle:SetSize(30, 30)
                    hitmarkerDynamicToggle:SetTooltip("Enable dynamic hitmarkers (changes position depending on where you shot hit.)")

                    local hitmarkerScale = DockHitmarker:Add("DNumSlider")
                    hitmarkerScale:SetPos(-85, 150)
                    hitmarkerScale:SetSize(250, 30)
                    hitmarkerScale:SetConVar("cl_tfa_hud_hitmarker_scale")
                    hitmarkerScale:SetMin(0.2)
                    hitmarkerScale:SetMax(2)
                    hitmarkerScale:SetDecimals(1)
                    hitmarkerScale:SetTooltip("Adjust the size of hitmarkers.")

                    local hitmarkerMixer = vgui.Create("DColorMixer", DockHitmarker)
                    hitmarkerMixer:SetPos(20, 190)
                    hitmarkerMixer:SetSize(215, 110)
                    hitmarkerMixer:SetConVarR("cl_tfa_hud_hitmarker_color_r")
                    hitmarkerMixer:SetConVarG("cl_tfa_hud_hitmarker_color_g")
                    hitmarkerMixer:SetConVarB("cl_tfa_hud_hitmarker_color_b")
                    hitmarkerMixer:SetConVarA("cl_tfa_hud_hitmarker_color_a")
                    hitmarkerMixer:SetAlphaBar(true)
                    hitmarkerMixer:SetPalette(false)
                    hitmarkerMixer:SetWangs(true)
                    hitmarkerMixer:SetTooltip("Change the color of hitmarkers.")

                    DockPerformance.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("PERFORMANCE", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Menu DOF", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("ADS DOF", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Inspection DOF", "SettingsLabel", 55, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("ADS Vignette", "SettingsLabel", 55, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Screen Flashing Effects", "SettingsLabel", 55, 225, white, TEXT_ALIGN_LEFT)
                    end

                    local menuDOF = DockPerformance:Add("DCheckBox")
                    menuDOF:SetPos(20, 70)
                    menuDOF:SetConVar("tm_menudof")
                    menuDOF:SetSize(30, 30)
                    menuDOF:SetTooltip("Blurs the background of certain in game menus.")

                    local ironSightDOF = DockPerformance:Add("DCheckBox")
                    ironSightDOF:SetPos(20, 110)
                    ironSightDOF:SetConVar("cl_tfa_fx_ads_dof")
                    ironSightDOF:SetSize(30, 30)
                    ironSightDOF:SetTooltip("Blurs your weapon while aiming down sights.")

                    local inspectionDOF = DockPerformance:Add("DCheckBox")
                    inspectionDOF:SetPos(20, 150)
                    inspectionDOF:SetConVar("cl_tfa_inspection_bokeh")
                    inspectionDOF:SetSize(30, 30)
                    inspectionDOF:SetTooltip("Enables a blur affect while in the attachment editing menu.")

                    local vignetteDOF = DockPerformance:Add("DCheckBox")
                    vignetteDOF:SetPos(20, 190)
                    vignetteDOF:SetConVar("cl_aimingfx_enabled")
                    vignetteDOF:SetSize(30, 30)
                    vignetteDOF:SetTooltip("Darkens the corners of your screen while aiming down sights.")

                    local screenFlashing = DockPerformance:Add("DCheckBox")
                    screenFlashing:SetPos(20, 230)
                    screenFlashing:SetConVar("tm_screenflashes")
                    screenFlashing:SetSize(30, 30)
                    screenFlashing:SetTooltip("Enables sudden screen effects on certain events (mainly dying and leveling up)")

                    local WipeAccountButton = vgui.Create("DButton", DockPerformance)
                    WipeAccountButton:SetPos(17.5, 310)
                    WipeAccountButton:SetText("")
                    WipeAccountButton:SetSize(500, 40)
                    local textAnim = 0
                    local wipeConfirm = 0
                    WipeAccountButton.Paint = function()
                        if WipeAccountButton:IsHovered() then
                            textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                        else
                            textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                        end
                        if (wipeConfirm == 0) then
                            draw.DrawText("WIPE PLAYER ACCOUNT", "SettingsLabel", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
                        else
                            draw.DrawText("ARE YOU SURE?", "SettingsLabel", 5 + textAnim, 5, Color(255, 0, 0), TEXT_ALIGN_LEFT)
                        end
                    end
                    WipeAccountButton.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
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
                MainPanel:Hide()
                SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat() * 0.2)
                surface.PlaySound("tmui/buttonclick.wav")
                local ShowHiddenOptions = false

                local health = 100
                local ammo = 30
                local velocity = 350
                local wep = "KRISS Vector"
                local fakeFeedArray = {}
                local grappleMat = Material("icons/grapplehudicon.png")
                local nadeMat = Material("icons/grenadehudicon.png")
                local timeText = " ∞"
                timer.Create("previewLoop", 1, 0, function()
                    health = math.random(1, 100)
                    ammo = math.random(1, 30)
                    velocity = math.random(0, 400)
                end)

                local FakeHUD = MainMenu:Add("HUDEditorPanel")
                MainMenu:SetMouseInputEnabled(false)
                FakeHUD.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    if GetConVar("tm_hud_ammo_style"):GetInt() == 0 then
                        draw.SimpleText(wep, "HUD_GunPrintName", ScrW() - 15, ScrH() - 30, Color(GetConVar("tm_hud_ammo_wep_text_color_r"):GetInt(), GetConVar("tm_hud_ammo_wep_text_color_g"):GetInt(), GetConVar("tm_hud_ammo_wep_text_color_b"):GetInt()), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(health .. " kills", "HUD_StreakText", ScrW() - 25, ScrH() - 155, Color(GetConVar("tm_hud_ammo_wep_text_color_r"):GetInt(), GetConVar("tm_hud_ammo_wep_text_color_g"):GetInt(), GetConVar("tm_hud_ammo_wep_text_color_b"):GetInt()), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
                        draw.SimpleText(ammo, "HUD_AmmoCount", ScrW() - 15, ScrH() - 100, Color(GetConVar("tm_hud_ammo_text_color_r"):GetInt(), GetConVar("tm_hud_ammo_text_color_g"):GetInt(), GetConVar("tm_hud_ammo_text_color_b"):GetInt()), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    elseif GetConVar("tm_hud_ammo_style"):GetInt() == 1 then
                        draw.SimpleText(wep, "HUD_GunPrintName", ScrW() - 15, ScrH() - 70, Color(GetConVar("tm_hud_ammo_wep_text_color_r"):GetInt(), GetConVar("tm_hud_ammo_wep_text_color_g"):GetInt(), GetConVar("tm_hud_ammo_wep_text_color_b"):GetInt()), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(health .. " kills", "HUD_StreakText", ScrW() - 18, ScrH() - 100, Color(GetConVar("tm_hud_ammo_wep_text_color_r"):GetInt(), GetConVar("tm_hud_ammo_wep_text_color_g"):GetInt(), GetConVar("tm_hud_ammo_wep_text_color_b"):GetInt()), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
                        surface.SetDrawColor(GetConVar("tm_hud_ammo_bar_color_r"):GetInt() - 205, GetConVar("tm_hud_ammo_bar_color_g"):GetInt() - 205, GetConVar("tm_hud_ammo_bar_color_b"):GetInt() - 205, 80)
                        surface.DrawRect(ScrW() - 415, ScrH() - 38, 400, 30)
                        surface.SetDrawColor(GetConVar("tm_hud_ammo_bar_color_r"):GetInt(), GetConVar("tm_hud_ammo_bar_color_g"):GetInt(), GetConVar("tm_hud_ammo_bar_color_b"):GetInt(), 175)
                        surface.DrawRect(ScrW() - 415, ScrH() - 38, 400 * (ammo / 30), 30)
                        draw.SimpleText(ammo, "HUD_Health", ScrW() - 410, ScrH() - 24, Color(GetConVar("tm_hud_ammo_text_color_r"):GetInt(), GetConVar("tm_hud_ammo_text_color_g"):GetInt(), GetConVar("tm_hud_ammo_text_color_b"):GetInt(), 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                    surface.SetDrawColor(50, 50, 50, 80)
                    surface.DrawRect(10 + GetConVar("tm_hud_health_offset_x"):GetInt(), ScrH() - 38 - GetConVar("tm_hud_health_offset_y"):GetInt(), GetConVar("tm_hud_health_size"):GetInt(), 30)
                    if health <= 66 then
                        if health <= 33 then
                            surface.SetDrawColor(GetConVar("tm_hud_health_color_low_r"):GetInt(), GetConVar("tm_hud_health_color_low_g"):GetInt(), GetConVar("tm_hud_health_color_low_b"):GetInt(), 120)
                        else
                            surface.SetDrawColor(GetConVar("tm_hud_health_color_mid_r"):GetInt(), GetConVar("tm_hud_health_color_mid_g"):GetInt(), GetConVar("tm_hud_health_color_mid_b"):GetInt(), 120)
                        end
                    else
                        surface.SetDrawColor(GetConVar("tm_hud_health_color_high_r"):GetInt(), GetConVar("tm_hud_health_color_high_g"):GetInt(), GetConVar("tm_hud_health_color_high_b"):GetInt(), 120)
                    end
                    surface.DrawRect(10 + GetConVar("tm_hud_health_offset_x"):GetInt(), ScrH() - 38 - GetConVar("tm_hud_health_offset_y"):GetInt(), GetConVar("tm_hud_health_size"):GetInt() * (health / 100), 30)
                    draw.SimpleText(health, "HUD_Health", GetConVar("tm_hud_health_size"):GetInt() + GetConVar("tm_hud_health_offset_x"):GetInt(), ScrH() - 24 - GetConVar("tm_hud_health_offset_y"):GetInt(), Color(GetConVar("tm_hud_health_text_color_r"):GetInt(), GetConVar("tm_hud_health_text_color_g"):GetInt(), GetConVar("tm_hud_health_text_color_b"):GetInt()), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    local feedStyle
                    if GetConVar("tm_hud_killfeed_style"):GetInt() == 0 then
                        feedStyle = -20
                    else
                        feedStyle = 20
                    end
                    for k, v in pairs(fakeFeedArray) do
                        if v[2] == 1 and v[2] != nil then surface.SetDrawColor(150, 50, 50, GetConVar("tm_hud_killfeed_opacity"):GetInt()) else surface.SetDrawColor(50, 50, 50, GetConVar("tm_hud_killfeed_opacity"):GetInt()) end
                        local nameLength = select(1, surface.GetTextSize(v[1]))

                        surface.DrawRect(10 + GetConVar("tm_hud_killfeed_offset_x"):GetInt(), ScrH() - 20 + ((k - 1) * feedStyle) - GetConVar("tm_hud_killfeed_offset_y"):GetInt(), nameLength + 5, 20)
                        draw.SimpleText(v[1], "HUD_StreakText", 12.5 + GetConVar("tm_hud_killfeed_offset_x"):GetInt(), ScrH() - 10 + ((k - 1) * feedStyle) - GetConVar("tm_hud_killfeed_offset_y"):GetInt(), Color(250, 250, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                    timeText = string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()), "%2i:%02i")
                    draw.SimpleText(activeGamemode .. " | " .. timeText, "HUD_Health", ScrW() / 2, 5, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    surface.SetMaterial(grappleMat)
                    surface.SetDrawColor(255,255,255,255)
                    surface.DrawTexturedRect(GetConVar("tm_hud_equipment_offset_x"):GetInt() - 45, ScrH() - 47.5 - GetConVar("tm_hud_equipment_offset_y"):GetInt(), 35, 40)
                    draw.SimpleText("[" .. input.GetKeyName(GetConVar("frest_bindg"):GetInt()) .. "]", "HUD_StreakText", GetConVar("tm_hud_equipment_offset_x"):GetInt() - 27.5, ScrH() - 75 - GetConVar("tm_hud_equipment_offset_y"):GetInt(), color_white, TEXT_ALIGN_CENTER)
                    surface.SetMaterial(nadeMat)
                    surface.SetDrawColor(255,255,255,255)
                    surface.DrawTexturedRect(GetConVar("tm_hud_equipment_offset_x"):GetInt() + 10, ScrH() - 47.5 - GetConVar("tm_hud_equipment_offset_y"):GetInt(), 35, 40)
                    draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", GetConVar("tm_hud_equipment_offset_x"):GetInt() + 27.5, ScrH() - 75 - GetConVar("tm_hud_equipment_offset_y"):GetInt(), color_white, TEXT_ALIGN_CENTER)
                    if GetConVar("tm_hud_keypressoverlay"):GetInt() == 1 then
                        local keyX = GetConVar("tm_hud_keypressoverlay_x"):GetInt()
                        local keyY = GetConVar("tm_hud_keypressoverlay_y"):GetInt()
                        local actuatedColor = Color(GetConVar("tm_hud_keypressoverlay_actuated_r"):GetInt(), GetConVar("tm_hud_keypressoverlay_actuated_g"):GetInt(), GetConVar("tm_hud_keypressoverlay_actuated_b"):GetInt())
                        local inactiveColor = Color(GetConVar("tm_hud_keypressoverlay_inactive_r"):GetInt(), GetConVar("tm_hud_keypressoverlay_inactive_g"):GetInt(), GetConVar("tm_hud_keypressoverlay_inactive_b"):GetInt())
                        local keyMat = Material("icons/keyicon.png")
                        local keyMatMed = Material("icons/keyiconmedium.png")
                        local keyMatLong = Material("icons/keyiconlong.png")
                        surface.SetMaterial(keyMat)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(48 + keyX, 0 + keyY, 42, 42)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(0 + keyX, 48 + keyY, 42, 42)
                        surface.SetDrawColor(inactiveColor)
                        surface.DrawTexturedRect(48 + keyX, 48 + keyY, 42, 42)
                        surface.SetDrawColor(inactiveColor)
                        surface.DrawTexturedRect(96 + keyX, 48 + keyY, 42, 42)
                        surface.SetMaterial(keyMatLong)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(0 + keyX, 96 + keyY, 138, 42)
                        surface.SetMaterial(keyMatMed)
                        surface.SetDrawColor(inactiveColor)
                        surface.DrawTexturedRect(0 + keyX, 144 + keyY, 66, 42)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(72 + keyX, 144 + keyY, 66, 42)
                        draw.SimpleText("W", "HUD_StreakText", 69 + keyX, 21 + keyY, actuatedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("A", "HUD_StreakText", 21 + keyX, 69 + keyY, actuatedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("S", "HUD_StreakText", 69 + keyX, 69 + keyY, inactiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("D", "HUD_StreakText", 117 + keyX, 69 + keyY, inactiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("JUMP", "HUD_StreakText", 69 + keyX, 117 + keyY, actuatedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("RUN", "HUD_StreakText", 33 + keyX, 165 + keyY, inactiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("DUCK", "HUD_StreakText", 105 + keyX, 165 + keyY, actuatedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    if GetConVar("tm_hud_fpscounter"):GetInt() == 1 then
                        draw.SimpleText("420 FPS", "HUD_Health", ScrW() - GetConVar("tm_hud_fpscounter_x"):GetInt(), GetConVar("tm_hud_fpscounter_y"):GetInt(), Color(GetConVar("tm_hud_fpscounter_r"):GetInt(), GetConVar("tm_hud_fpscounter_g"):GetInt(), GetConVar("tm_hud_fpscounter_b"):GetInt()), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                        draw.SimpleText("69 PING", "HUD_Health", ScrW() - GetConVar("tm_hud_fpscounter_x"):GetInt(), GetConVar("tm_hud_fpscounter_y"):GetInt() + 25, Color(GetConVar("tm_hud_fpscounter_r"):GetInt(), GetConVar("tm_hud_fpscounter_g"):GetInt(), GetConVar("tm_hud_fpscounter_b"):GetInt()), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    end
                    if GetConVar("tm_hud_velocitycounter"):GetInt() == 1 then
                        draw.SimpleText(velocity .. " u/s", "HUD_Health", GetConVar("tm_hud_velocitycounter_x"):GetInt(), GetConVar("tm_hud_velocitycounter_y"):GetInt(), Color(GetConVar("tm_hud_velocitycounter_r"):GetInt(), GetConVar("tm_hud_velocitycounter_g"):GetInt(), GetConVar("tm_hud_velocitycounter_b"):GetInt()), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    end
                end

                local EditorPanel = vgui.Create("DFrame", FakeHUD)
                EditorPanel:SetSize(435, ScrH() * 0.7)
                EditorPanel:MakePopup()
                EditorPanel:SetTitle("HUD Editor")
                EditorPanel:Center()
                EditorPanel:SetScreenLock(true)
                EditorPanel:GetBackgroundBlur(false)
                EditorPanel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                end
                EditorPanel.OnClose = function()
                    surface.PlaySound("tmui/buttonclick.wav")
                    MainMenu:SetMouseInputEnabled(true)
                    FakeHUD:Hide()
                    MainPanel:Show()
                    SetMusicVolume(GetConVar("tm_menumusicvolume"):GetFloat())
                    timer.Remove("previewLoop")
                    hook.Remove("Tick", "KeyOverlayTracking")
                end

                local EditorScroller = vgui.Create("DScrollPanel", EditorPanel)
                EditorScroller:Dock(FILL)

                local sbar = EditorScroller:GetVBar()
                function sbar:Paint(w, h)
                    draw.RoundedBox(5, 0, 0, w, h, lightGray)
                end
                function sbar.btnUp:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, lightGray)
                end
                function sbar.btnDown:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, lightGray)
                end
                function sbar.btnGrip:Paint(w, h)
                    draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                end

                local HiddenOptionsScroller = vgui.Create("DPanel", EditorPanel)
                HiddenOptionsScroller:Dock(FILL)

                HiddenOptionsScroller.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 5))
                end

                local GeneralEditor = vgui.Create("DPanel", EditorScroller)
                GeneralEditor:Dock(TOP)
                GeneralEditor:SetSize(0, 210)
                GeneralEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("GENERAL", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("HUD Font", "Health", 125, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Font Scale", "Health", 150, 90, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Use Font on Kill UI", "Health", 55, 127.5, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Use Font on Death UI", "Health", 55, 167.5, white, TEXT_ALIGN_LEFT)
                end

                local HUDFont = GeneralEditor:Add("DComboBox")
                HUDFont:SetPos(20, 50)
                HUDFont:SetSize(100, 30)
                HUDFont:SetTooltip("Adjust the font used on HUD text.")
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
                HUDFont:AddChoice("Source Sans Pro Semibold")
                HUDFont.OnSelect = function(self, index, value)
                    surface.PlaySound("tmui/buttonrollover.wav")
                    RunConsoleCommand("tm_hud_font", value)
                end

                local CustomFontInput = GeneralEditor:Add("DTextEntry")
                CustomFontInput:SetPlaceholderText("Enter a custom font...")
                CustomFontInput:SetPos(275, 50)
                CustomFontInput:SetSize(125, 30)
                CustomFontInput.OnEnter = function(self)
                    RunConsoleCommand("tm_hud_font", self:GetValue())
                    HUDFont:SetValue(self:GetValue())
                end

                local FontScale = GeneralEditor:Add("DNumSlider")
                FontScale:SetPos(-85, 90)
                FontScale:SetSize(250, 30)
                FontScale:SetConVar("tm_hud_font_scale")
                FontScale:SetMin(0.5)
                FontScale:SetMax(1.5)
                FontScale:SetDecimals(2)
                FontScale:SetTooltip("Adjust the size of your font.")

                local KillUICustomFont = GeneralEditor:Add("DCheckBox")
                KillUICustomFont:SetPos(20, 130)
                KillUICustomFont:SetConVar("tm_hud_font_kill")
                KillUICustomFont:SetSize(30, 30)
                KillUICustomFont:SetTooltip("Enable use of your custom font for the kill UI.")

                local DeathUICustomFont = GeneralEditor:Add("DCheckBox")
                DeathUICustomFont:SetPos(20, 170)
                DeathUICustomFont:SetConVar("tm_hud_font_death")
                DeathUICustomFont:SetSize(30, 30)
                DeathUICustomFont:SetTooltip("Enable use of your custom font for the death UI.")

                local AmmoEditor = vgui.Create("DPanel", EditorScroller)
                AmmoEditor:Dock(TOP)
                AmmoEditor:SetSize(0, 330)
                AmmoEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("AMMO", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Style", "Health", 125, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Gun Text Color", "Health", 210, 85, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Ammo Text Color", "Health", 210, 165, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar Color", "Health", 210, 245, white, TEXT_ALIGN_LEFT)
                end

                local AmmoStyle = AmmoEditor:Add("DComboBox")
                AmmoStyle:SetPos(20, 50)
                AmmoStyle:SetSize(100, 30)
                AmmoStyle:SetTooltip("Adjust the style of the ammo counter.")
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
                end

                local WepTextColor = vgui.Create("DColorMixer", AmmoEditor)
                WepTextColor:SetPos(20, 90)
                WepTextColor:SetSize(185, 70)
                WepTextColor:SetConVarR("tm_hud_ammo_wep_text_color_r")
                WepTextColor:SetConVarG("tm_hud_ammo_wep_text_color_g")
                WepTextColor:SetConVarB("tm_hud_ammo_wep_text_color_b")
                WepTextColor:SetAlphaBar(false)
                WepTextColor:SetPalette(false)
                WepTextColor:SetWangs(true)
                WepTextColor:SetTooltip("Adjusts your gun name text color.")

                local AmmoTextColor = vgui.Create("DColorMixer", AmmoEditor)
                AmmoTextColor:SetPos(20, 170)
                AmmoTextColor:SetSize(185, 70)
                AmmoTextColor:SetConVarR("tm_hud_ammo_text_color_r")
                AmmoTextColor:SetConVarG("tm_hud_ammo_text_color_g")
                AmmoTextColor:SetConVarB("tm_hud_ammo_text_color_b")
                AmmoTextColor:SetAlphaBar(false)
                AmmoTextColor:SetPalette(false)
                AmmoTextColor:SetWangs(true)
                AmmoTextColor:SetTooltip("Adjusts your ammo text color.")

                local AmmoBarColor = vgui.Create("DColorMixer", AmmoEditor)
                AmmoBarColor:SetPos(20, 250)
                AmmoBarColor:SetSize(185, 70)
                AmmoBarColor:SetConVarR("tm_hud_ammo_bar_color_r")
                AmmoBarColor:SetConVarG("tm_hud_ammo_bar_color_g")
                AmmoBarColor:SetConVarB("tm_hud_ammo_bar_color_b")
                AmmoBarColor:SetAlphaBar(false)
                AmmoBarColor:SetPalette(false)
                AmmoBarColor:SetWangs(true)
                AmmoBarColor:SetTooltip("Adjusts your ammo bar color.")

                local HealthEditor = vgui.Create("DPanel", EditorScroller)
                HealthEditor:Dock(TOP)
                HealthEditor:SetSize(0, 470)
                HealthEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("HEALTH", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar Size", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar X Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar Y Offset", "Health", 150, 110, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("HP Text Color", "Health", 210, 145, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("High HP Color", "Health", 210, 225, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Mid HP Color", "Health", 210, 305, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Low HP Color", "Health", 210, 385, white, TEXT_ALIGN_LEFT)
                end

                local HealthBarSize = HealthEditor:Add("DNumSlider")
                HealthBarSize:SetPos(-85, 50)
                HealthBarSize:SetSize(250, 30)
                HealthBarSize:SetConVar("tm_hud_health_size")
                HealthBarSize:SetMin(100)
                HealthBarSize:SetMax(1000)
                HealthBarSize:SetDecimals(0)
                HealthBarSize:SetTooltip("Adjust the size of your health bar.")

                local HealthBarX = HealthEditor:Add("DNumSlider")
                HealthBarX:SetPos(-85, 80)
                HealthBarX:SetSize(250, 30)
                HealthBarX:SetConVar("tm_hud_health_offset_x")
                HealthBarX:SetMin(0)
                HealthBarX:SetMax(ScrW())
                HealthBarX:SetDecimals(0)
                HealthBarX:SetTooltip("Adjust the X offset of your health bar.")

                local HealthBarY = HealthEditor:Add("DNumSlider")
                HealthBarY:SetPos(-85, 110)
                HealthBarY:SetSize(250, 30)
                HealthBarY:SetConVar("tm_hud_health_offset_y")
                HealthBarY:SetMin(0)
                HealthBarY:SetMax(ScrH())
                HealthBarY:SetDecimals(0)
                HealthBarY:SetTooltip("Adjust the Y offset of your health bar.")

                local HealthTextColor = vgui.Create("DColorMixer", HealthEditor)
                HealthTextColor:SetPos(20, 150)
                HealthTextColor:SetSize(185, 70)
                HealthTextColor:SetConVarR("tm_hud_health_text_color_r")
                HealthTextColor:SetConVarG("tm_hud_health_text_color_g")
                HealthTextColor:SetConVarB("tm_hud_health_text_color_b")
                HealthTextColor:SetAlphaBar(false)
                HealthTextColor:SetPalette(false)
                HealthTextColor:SetWangs(true)
                HealthTextColor:SetTooltip("Adjusts your health text color.")

                local HealthHighColor = vgui.Create("DColorMixer", HealthEditor)
                HealthHighColor:SetPos(20, 230)
                HealthHighColor:SetSize(185, 70)
                HealthHighColor:SetConVarR("tm_hud_health_color_high_r")
                HealthHighColor:SetConVarG("tm_hud_health_color_high_g")
                HealthHighColor:SetConVarB("tm_hud_health_color_high_b")
                HealthHighColor:SetAlphaBar(false)
                HealthHighColor:SetPalette(false)
                HealthHighColor:SetWangs(true)
                HealthHighColor:SetTooltip("Adjusts your health bar color while on 100% or less HP.")

                local HealthMidColor = vgui.Create("DColorMixer", HealthEditor)
                HealthMidColor:SetPos(20, 310)
                HealthMidColor:SetSize(185, 70)
                HealthMidColor:SetConVarR("tm_hud_health_color_mid_r")
                HealthMidColor:SetConVarG("tm_hud_health_color_mid_g")
                HealthMidColor:SetConVarB("tm_hud_health_color_mid_b")
                HealthMidColor:SetAlphaBar(false)
                HealthMidColor:SetPalette(false)
                HealthMidColor:SetWangs(true)
                HealthMidColor:SetTooltip("Adjusts your health bar color while on 66% or less HP.")

                local HealthLowColor = vgui.Create("DColorMixer", HealthEditor)
                HealthLowColor:SetPos(20, 390)
                HealthLowColor:SetSize(185, 70)
                HealthLowColor:SetConVarR("tm_hud_health_color_low_r")
                HealthLowColor:SetConVarG("tm_hud_health_color_low_g")
                HealthLowColor:SetConVarB("tm_hud_health_color_low_b")
                HealthLowColor:SetAlphaBar(false)
                HealthLowColor:SetPalette(false)
                HealthLowColor:SetWangs(true)
                HealthLowColor:SetTooltip("Adjusts your health bar color while on 33% or less HP.")

                local EquipmentEditor = vgui.Create("DPanel", EditorScroller)
                EquipmentEditor:Dock(TOP)
                EquipmentEditor:SetSize(0, 150)
                EquipmentEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("EQUIPMENT UI", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Equipment Anchoring", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Equipment X Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Equipment Y Offset", "Health", 150, 110, white, TEXT_ALIGN_LEFT)
                end

                local EquipmentAnchor = EquipmentEditor:Add("DComboBox")
                EquipmentAnchor:SetPos(20, 50)
                EquipmentAnchor:SetSize(100, 30)
                EquipmentAnchor:SetTooltip("Adjust the anchoring of your equipment UI.")
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
                end

                local EquipmentX = EquipmentEditor:Add("DNumSlider")
                EquipmentX:SetPos(-85, 80)
                EquipmentX:SetSize(250, 30)
                EquipmentX:SetConVar("tm_hud_equipment_offset_x")
                EquipmentX:SetMin(0)
                EquipmentX:SetMax(ScrW())
                EquipmentX:SetDecimals(0)
                EquipmentX:SetTooltip("Adjust the X offset of your equipment UI.")

                local EquipmentY = EquipmentEditor:Add("DNumSlider")
                EquipmentY:SetPos(-85, 110)
                EquipmentY:SetSize(250, 30)
                EquipmentY:SetConVar("tm_hud_equipment_offset_y")
                EquipmentY:SetMin(0)
                EquipmentY:SetMax(ScrH())
                EquipmentY:SetDecimals(0)
                EquipmentY:SetTooltip("Adjust the Y offset of your equipment UI.")

                local KillFeedEditor = vgui.Create("DPanel", EditorScroller)
                KillFeedEditor:Dock(TOP)
                KillFeedEditor:SetSize(0, 245)
                KillFeedEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("KILL FEED", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Enable Kill Feed", "Health", 55, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Entry Style", "Health", 125, 85, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Item Limit", "Health", 150, 115, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed X Offset", "Health", 150, 145, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Y Offset", "Health", 150, 175, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Opacity", "Health", 150, 205, white, TEXT_ALIGN_LEFT)
                end

                local AddFeedEntryButton = vgui.Create("DButton", KillFeedEditor)
                AddFeedEntryButton:SetPos(190, 17.5)
                AddFeedEntryButton:SetText("")
                AddFeedEntryButton:SetSize(145, 40)
                local textAnim = 0
                AddFeedEntryButton.Paint = function()
                    if AddFeedEntryButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                    end
                    draw.DrawText("Add Feed Entry", "StreakText", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                AddFeedEntryButton.DoClick = function()
                    if GetConVar("tm_hud_enablekillfeed"):GetInt() == 0 then return end
                    local playersInAction = LocalPly:Name() .. " killed " .. math.random(1, 1000)
                    local victimLastHitIn = math.random(0, 1)

                    table.insert(fakeFeedArray, {playersInAction, victimLastHitIn})
                    if table.Count(fakeFeedArray) >= (GetConVar("tm_hud_killfeed_limit"):GetInt() + 1) then table.remove(fakeFeedArray, 1) end
                end

                local EnableKillFeed = KillFeedEditor:Add("DCheckBox")
                EnableKillFeed:SetPos(20, 50)
                EnableKillFeed:SetConVar("tm_hud_enablekillfeed")
                EnableKillFeed:SetSize(30, 30)
                EnableKillFeed:SetTooltip("Enable the kill feed.")

                local KillFeedStyle = KillFeedEditor:Add("DComboBox")
                KillFeedStyle:SetPos(20, 85)
                KillFeedStyle:SetSize(100, 30)
                KillFeedStyle:SetTooltip("Adjust the style of the kill feed entries.")
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
                end

                local KillFeedItemLimit = KillFeedEditor:Add("DNumSlider")
                KillFeedItemLimit:SetPos(-85, 115)
                KillFeedItemLimit:SetSize(250, 30)
                KillFeedItemLimit:SetConVar("tm_hud_killfeed_limit")
                KillFeedItemLimit:SetMin(1)
                KillFeedItemLimit:SetMax(10)
                KillFeedItemLimit:SetDecimals(0)
                KillFeedItemLimit:SetTooltip("Limit the amount of entries that can be shown on the kill feed.")

                local KillFeedX = KillFeedEditor:Add("DNumSlider")
                KillFeedX:SetPos(-85, 145)
                KillFeedX:SetSize(250, 30)
                KillFeedX:SetConVar("tm_hud_killfeed_offset_x")
                KillFeedX:SetMin(0)
                KillFeedX:SetMax(ScrW())
                KillFeedX:SetDecimals(0)
                KillFeedX:SetTooltip("Adjust the X offset of your kill feed.")

                local KillFeedY = KillFeedEditor:Add("DNumSlider")
                KillFeedY:SetPos(-85, 175)
                KillFeedY:SetSize(250, 30)
                KillFeedY:SetConVar("tm_hud_killfeed_offset_y")
                KillFeedY:SetMin(0)
                KillFeedY:SetMax(ScrH())
                KillFeedY:SetDecimals(0)
                KillFeedY:SetTooltip("Adjust the Y offset of your kill feed.")

                local KillFeedOpacity = KillFeedEditor:Add("DNumSlider")
                KillFeedOpacity:SetPos(-85, 205)
                KillFeedOpacity:SetSize(250, 30)
                KillFeedOpacity:SetConVar("tm_hud_killfeed_opacity")
                KillFeedOpacity:SetMin(0)
                KillFeedOpacity:SetMax(255)
                KillFeedOpacity:SetDecimals(0)
                KillFeedOpacity:SetTooltip("Adjust the opacity of a feed entries background.")

                local KillDeathEditor
                KillDeathEditor = vgui.Create("DPanel", EditorScroller)
                KillDeathEditor:Dock(TOP)
                KillDeathEditor:SetSize(0, 200)
                KillDeathEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("KILL/DEATH UI", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("UI X Offset", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("UI Y Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Kill Icon Color", "Health", 210, 115, white, TEXT_ALIGN_LEFT)
                end

                local KillDeathX = KillDeathEditor:Add("DNumSlider")
                KillDeathX:SetPos(-85, 50)
                KillDeathX:SetSize(250, 30)
                KillDeathX:SetConVar("tm_hud_killdeath_offset_x")
                KillDeathX:SetMin(ScrW() / -2)
                KillDeathX:SetMax(ScrW() / 2)
                KillDeathX:SetDecimals(0)
                KillDeathX:SetTooltip("Adjust the X offset of your kill and death UI.")

                local KillDeathY = KillDeathEditor:Add("DNumSlider")
                KillDeathY:SetPos(-85, 80)
                KillDeathY:SetSize(250, 30)
                KillDeathY:SetConVar("tm_hud_killdeath_offset_y")
                KillDeathY:SetMin(0)
                KillDeathY:SetMax(ScrH())
                KillDeathY:SetDecimals(0)
                KillDeathY:SetTooltip("Adjust the Y offset of your kill and death UI.")

                local KillColor = vgui.Create("DColorMixer", KillDeathEditor)
                KillColor:SetPos(20, 120)
                KillColor:SetSize(185, 70)
                KillColor:SetConVarR("tm_hud_kill_iconcolor_r")
                KillColor:SetConVarG("tm_hud_kill_iconcolor_g")
                KillColor:SetConVarB("tm_hud_kill_iconcolor_b")
                KillColor:SetAlphaBar(false)
                KillColor:SetPalette(false)
                KillColor:SetWangs(true)
                KillColor:SetTooltip("Adjusts the color of the skull icon on a kill.")

                local KeypressOverlay
                if GetConVar("tm_hud_keypressoverlay"):GetInt() == 1 then KeypressOverlay = vgui.Create("DPanel", EditorScroller) else
                    KeypressOverlay = vgui.Create("DPanel", HiddenOptionsScroller)
                    ShowHiddenOptions = true
                end
                KeypressOverlay:Dock(TOP)
                KeypressOverlay:SetSize(0, 280)
                KeypressOverlay.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("KEYPRESS OVERLAY", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Overlay X Offset", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Overlay Y Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Unpressed Color", "Health", 210, 115, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Actuated Color", "Health", 210, 195, white, TEXT_ALIGN_LEFT)
                end

                local KeypressOverlayX = KeypressOverlay:Add("DNumSlider")
                KeypressOverlayX:SetPos(-85, 50)
                KeypressOverlayX:SetSize(250, 30)
                KeypressOverlayX:SetConVar("tm_hud_keypressoverlay_x")
                KeypressOverlayX:SetMin(0)
                KeypressOverlayX:SetMax(ScrW())
                KeypressOverlayX:SetDecimals(0)
                KeypressOverlayX:SetTooltip("Adjust the X offset of your keypress overlay.")

                local KeypressOverlayY = KeypressOverlay:Add("DNumSlider")
                KeypressOverlayY:SetPos(-85, 80)
                KeypressOverlayY:SetSize(250, 30)
                KeypressOverlayY:SetConVar("tm_hud_keypressoverlay_y")
                KeypressOverlayY:SetMin(0)
                KeypressOverlayY:SetMax(ScrH())
                KeypressOverlayY:SetDecimals(0)
                KeypressOverlayY:SetTooltip("Adjust the Y offset of your keypress overlay.")

                local KeypressInactiveColor = vgui.Create("DColorMixer", KeypressOverlay)
                KeypressInactiveColor:SetPos(20, 120)
                KeypressInactiveColor:SetSize(185, 70)
                KeypressInactiveColor:SetConVarR("tm_hud_keypressoverlay_inactive_r")
                KeypressInactiveColor:SetConVarG("tm_hud_keypressoverlay_inactive_g")
                KeypressInactiveColor:SetConVarB("tm_hud_keypressoverlay_inactive_b")
                KeypressInactiveColor:SetAlphaBar(false)
                KeypressInactiveColor:SetPalette(false)
                KeypressInactiveColor:SetWangs(true)
                KeypressInactiveColor:SetTooltip("Adjusts the color of an inactive key on your keypress overlay.")

                local KeypressActuatedColor = vgui.Create("DColorMixer", KeypressOverlay)
                KeypressActuatedColor:SetPos(20, 200)
                KeypressActuatedColor:SetSize(185, 70)
                KeypressActuatedColor:SetConVarR("tm_hud_keypressoverlay_actuated_r")
                KeypressActuatedColor:SetConVarG("tm_hud_keypressoverlay_actuated_g")
                KeypressActuatedColor:SetConVarB("tm_hud_keypressoverlay_actuated_b")
                KeypressActuatedColor:SetAlphaBar(false)
                KeypressActuatedColor:SetPalette(false)
                KeypressActuatedColor:SetWangs(true)
                KeypressActuatedColor:SetTooltip("Adjusts the color of an actuated key on your keypress overlay.")

                local FPSPingCounter
                if GetConVar("tm_hud_fpscounter"):GetInt() == 1 then FPSPingCounter = vgui.Create("DPanel", EditorScroller) else
                    FPSPingCounter = vgui.Create("DPanel", HiddenOptionsScroller)
                    ShowHiddenOptions = true
                end
                FPSPingCounter:Dock(TOP)
                FPSPingCounter:SetSize(0, 200)
                FPSPingCounter.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("FPS/PING COUNTER", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Counter X Offset", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Counter Y Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Text Color", "Health", 210, 115, white, TEXT_ALIGN_LEFT)
                end

                local FPSPingCounterX = FPSPingCounter:Add("DNumSlider")
                FPSPingCounterX:SetPos(-85, 50)
                FPSPingCounterX:SetSize(250, 30)
                FPSPingCounterX:SetConVar("tm_hud_fpscounter_x")
                FPSPingCounterX:SetMin(0)
                FPSPingCounterX:SetMax(ScrW())
                FPSPingCounterX:SetDecimals(0)
                FPSPingCounterX:SetTooltip("Adjust the X offset of your FPS and ping counter.")

                local FPSPingCounterY = FPSPingCounter:Add("DNumSlider")
                FPSPingCounterY:SetPos(-85, 80)
                FPSPingCounterY:SetSize(250, 30)
                FPSPingCounterY:SetConVar("tm_hud_fpscounter_y")
                FPSPingCounterY:SetMin(0)
                FPSPingCounterY:SetMax(ScrH())
                FPSPingCounterY:SetDecimals(0)
                FPSPingCounterY:SetTooltip("Adjust the Y offset of your FPS and ping counter")

                local FPSPingCounterColor = vgui.Create("DColorMixer", FPSPingCounter)
                FPSPingCounterColor:SetPos(20, 120)
                FPSPingCounterColor:SetSize(185, 70)
                FPSPingCounterColor:SetConVarR("tm_hud_fpscounter_r")
                FPSPingCounterColor:SetConVarG("tm_hud_fpscounter_g")
                FPSPingCounterColor:SetConVarB("tm_hud_fpscounter_b")
                FPSPingCounterColor:SetAlphaBar(false)
                FPSPingCounterColor:SetPalette(false)
                FPSPingCounterColor:SetWangs(true)
                FPSPingCounterColor:SetTooltip("Adjusts the color of the text on the FPS and ping counter.")

                local VelocityCounter
                if GetConVar("tm_hud_velocitycounter"):GetInt() == 1 then VelocityCounter = vgui.Create("DPanel", EditorScroller) else
                    VelocityCounter = vgui.Create("DPanel", HiddenOptionsScroller)
                    ShowHiddenOptions = true
                end
                VelocityCounter:Dock(TOP)
                VelocityCounter:SetSize(0, 200)
                VelocityCounter.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("VELOCITY COUNTER", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Counter X Offset", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Counter Y Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Text Color", "Health", 210, 115, white, TEXT_ALIGN_LEFT)
                end

                local VelocityCounterX = VelocityCounter:Add("DNumSlider")
                VelocityCounterX:SetPos(-85, 50)
                VelocityCounterX:SetSize(250, 30)
                VelocityCounterX:SetConVar("tm_hud_velocitycounter_x")
                VelocityCounterX:SetMin(0)
                VelocityCounterX:SetMax(ScrW())
                VelocityCounterX:SetDecimals(0)
                VelocityCounterX:SetTooltip("Adjust the X offset of your velocity counter.")

                local VelocityCounterY = VelocityCounter:Add("DNumSlider")
                VelocityCounterY:SetPos(-85, 80)
                VelocityCounterY:SetSize(250, 30)
                VelocityCounterY:SetConVar("tm_hud_velocitycounter_y")
                VelocityCounterY:SetMin(0)
                VelocityCounterY:SetMax(ScrH())
                VelocityCounterY:SetDecimals(0)
                VelocityCounterY:SetTooltip("Adjust the Y offset of your velocity counter")

                local VelocityCounterColor = vgui.Create("DColorMixer", VelocityCounter)
                VelocityCounterColor:SetPos(20, 120)
                VelocityCounterColor:SetSize(185, 70)
                VelocityCounterColor:SetConVarR("tm_hud_velocitycounter_r")
                VelocityCounterColor:SetConVarG("tm_hud_velocitycounter_g")
                VelocityCounterColor:SetConVarB("tm_hud_velocitycounter_b")
                VelocityCounterColor:SetAlphaBar(false)
                VelocityCounterColor:SetPalette(false)
                VelocityCounterColor:SetWangs(true)
                VelocityCounterColor:SetTooltip("Adjusts the color of the text on the velocity counter.")

                local HiddenOptionsCollapse = vgui.Create("DCollapsibleCategory", EditorScroller)
                HiddenOptionsCollapse:SetLabel("Show options for disabled HUD elements")
                HiddenOptionsCollapse:Dock(TOP)
                HiddenOptionsCollapse:SetSize(250, 200)
                HiddenOptionsCollapse:SetExpanded(false)
                HiddenOptionsCollapse:SetContents(HiddenOptionsScroller)

                if ShowHiddenOptions == false then HiddenOptionsCollapse:Remove() end

                local EditorButtons = vgui.Create("DPanel", EditorScroller)
                EditorButtons:Dock(TOP)
                EditorButtons:SetSize(0, 190)
                EditorButtons.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                end

                local TestKillButton = vgui.Create("DButton", EditorButtons)
                TestKillButton:SetPos(20, 30)
                TestKillButton:SetText("")
                TestKillButton:SetSize(145, 40)
                local textAnim = 0
                TestKillButton.Paint = function()
                    if TestKillButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                    end
                    draw.DrawText("Test Kill", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                TestKillButton.DoClick = function()
                    RunConsoleCommand("tm_hud_testkill")
                end

                local TestDeathButton = vgui.Create("DButton", EditorButtons)
                TestDeathButton:SetPos(20, 60)
                TestDeathButton:SetText("")
                TestDeathButton:SetSize(165, 40)
                local textAnim = 0
                TestDeathButton.Paint = function()
                    if TestDeathButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                    end
                    draw.DrawText("Test Death", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                TestDeathButton.DoClick = function()
                    RunConsoleCommand("tm_hud_testdeath")
                end

                local TestLevelUpButton = vgui.Create("DButton", EditorButtons)
                TestLevelUpButton:SetPos(20, 90)
                TestLevelUpButton:SetText("")
                TestLevelUpButton:SetSize(200, 40)
                local textAnim = 0
                TestLevelUpButton.Paint = function()
                    if TestLevelUpButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                    end
                    draw.DrawText("Test Level Up", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                TestLevelUpButton.DoClick = function()
                    RunConsoleCommand("tm_hud_testlevelup")
                end

                local ResetToDefaultButton = vgui.Create("DButton", EditorButtons)
                ResetToDefaultButton:SetPos(20, 150)
                ResetToDefaultButton:SetText("")
                ResetToDefaultButton:SetSize(360, 40)
                local textAnim = 0
                local ResetToDefaultConfirm = 0
                ResetToDefaultButton.Paint = function()
                    if ResetToDefaultButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                    end
                    if (ResetToDefaultConfirm == 0) then
                        draw.DrawText("Reset HUD To Default Options", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("ARE YOU SURE?", "Health", 0 + textAnim, 0, Color(255, 0, 0), TEXT_ALIGN_LEFT)
                    end
                end
                ResetToDefaultButton.DoClick = function()
                    surface.PlaySound("tmui/buttonclick.wav")
                    if (ResetToDefaultConfirm == 0) then
                        ResetToDefaultConfirm = 1
                    else
                        RunConsoleCommand("tm_resethudtodefault_cannotbeundone")
                        ResetToDefaultConfirm = 0
                    end

                    timer.Simple(3, function() ResetToDefaultConfirm = 0 end)
                end
            end

            local ExitButton = vgui.Create("DButton", MainPanel)
            ExitButton:SetPos(0, ScrH() / 2 + 100)
            ExitButton:SetText("")
            ExitButton:SetSize(600, 100)
            local textAnim = 0
            ExitButton.Paint = function()
                ExitButton:SetPos(0, ScrH() / 2 + pushExitItems)
                if ExitButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                else
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                end
                draw.DrawText("PAUSE MENU", "AmmoCountSmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end
            ExitButton.DoClick = function()
                gui.ActivateGameUI()
                StopMusic()
                net.Start("CloseMainMenu")
                net.SendToServer()
                MainMenu:Remove()
                gui.EnableScreenClicker(false)
            end

            local CreditsButton = vgui.Create("DButton", MainPanel)
            CreditsButton:SetPos(ScrW() - 110, ScrH() - 52)
            CreditsButton:SetText("")
            CreditsButton:SetSize(110, 32)
            local textAnim = 20
            CreditsButton.Paint = function()
                CreditsButton:SetPos(ScrW() - 110, ScrH() - 52)
                if CreditsButton:IsHovered() then
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                else
                    textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                end
                draw.DrawText("CREDITS", "StreakText", 85 + textAnim, 5, white, TEXT_ALIGN_RIGHT)
            end
            CreditsButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                gui.OpenURL("https://github.com/PikachuPenial/Titanmod#credits")
            end
    end

    if belowMinimumRes == true and LocalPly:GetNWBool("seenResWarning") ~= true then
        local ResWarning = vgui.Create("DPanel")
        ResWarning:SetPos(0, 0)
        ResWarning:SetSize(ScrW(), ScrH())
        ResWarning:MakePopup()

        local ResWarningLabel = vgui.Create("DLabel", ResWarning)
        ResWarningLabel:SetPos(10, 10)
        ResWarningLabel:SetText("You are playing on a resolution lower than 1024x762!" .. "\n" .. "Any problems that arise from your current resolution will not be addressed." .. "\n" .. "This popup will disappear in 8 seconds.")
        ResWarningLabel:SizeToContents()
        ResWarningLabel:SetDark(1)

        LocalPly:SetNWBool("seenResWarning", true)

        timer.Create("removeResWarning", 8, 1, function()
            ResWarning:Remove()
        end)
    end
end )

PANEL = {}
function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("MainPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(56, ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("OptionsSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(600, ScrH())
    self:SetPos(56, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("OptionsPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(56, ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CustomizeSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(475, ScrH() * 0.6)
    self:SetPos(56, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CustomizePanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(475, ScrH() * 0.4)
    self:SetPos(56, ScrH() * 0.6)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CustomizePreviewPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(56, ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CardSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(515, ScrH() * 0.75)
    self:SetPos(56, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CardPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(515, ScrH() * 0.25)
    self:SetPos(56, ScrH() * 0.75)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CardPreviewPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(56, ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("LeaderboardSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(780, ScrH())
    self:SetPos(56, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("LeaderboardPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(56, ScrH())
    self:SetPos(0, 0)
end

PANEL = {}
function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("HUDEditorPanel", PANEL, "Panel")