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

net.Receive("OpenMainMenu", function(len, ply)
    local LocalPly = LocalPlayer()
    if LocalPly:Alive() then return end

    local chosenMusic
    local musicName
    local musicList
    local requestedBy
    local dof

    local mapID
    local mapName
    local mapDesc
    local mapThumb

    local canPrestige
    if LocalPly:GetNWInt("playerLevel") ~= 60 then canPrestige = false else canPrestige = true end
    if ScrW() < 1024 and ScrH() < 768 then belowMinimumRes = true else belowMinimumRes = false end
    if GetConVar("tm_menudof"):GetInt() == 1 then dof = true end

    musicList = {"music/chillwave_ragdolluniverseost.wav", "music/giftshop_battleblocktheaterost.wav", "music/takecare_ultrakillost.wav", "music/immaculate_visage.wav", "music/tabgmenumusic.wav", "music/sneakysnitch_kevinmacleod.wav", "music/waster_bladee.wav", "music/systemfiles_zedorfski.wav", "music/nintendo_mariokartchannel.wav"}
    chosenMusic = (musicList[math.random(#musicList)])
    local menuMusic = CreateSound(LocalPly, chosenMusic)

    if chosenMusic == "music/chillwave_ragdolluniverseost.wav" then
        musicName = "Chillwave - Ragdoll Universe OST"
    end

    if chosenMusic == "music/giftshop_battleblocktheaterost.wav" then
        musicName = "Gift Shop - Battleblock Theater OST"
    end

    if chosenMusic == "music/nintendo_mariokartchannel.wav" then
        musicName = "Mario Kart Channel - Nintendo"
    end

    if chosenMusic == "music/takecare_ultrakillost.wav" then
        musicName = "Take Care - Ultrakill OST"
        requestedBy = "Unlucky"
        steamProfile = "https://steamcommunity.com/id/UnluckyGamer49"
    end

    if chosenMusic == "music/immaculate_visage.wav" then
        musicName = "Immaculate - Visage"
        requestedBy = "Seven"
        steamProfile = "https://steamcommunity.com/profiles/76561199121652527"
    end

    if chosenMusic == "music/tabgmenumusic.wav" then
        musicName = "TABG Main Theme"
        requestedBy = "Portanator"
        steamProfile = "https://steamcommunity.com/id/portmens/"
    end

    if chosenMusic == "music/sneakysnitch_kevinmacleod.wav" then
        musicName = "Sneaky Snitch - Kevin MacLeod"
        requestedBy = "Checked"
        steamProfile = "https://steamcommunity.com/profiles/76561198853717083"
    end

    if chosenMusic == "music/waster_bladee.wav" then
        musicName = "Waster - Bladee"
        requestedBy = "Suomij (narkotica)"
        steamProfile = "https://steamcommunity.com/profiles/76561199027666260"
    end

    if chosenMusic == "music/systemfiles_zedorfski.wav" then
        musicName = "System Files - Zedorfski"
        requestedBy = "Zedorfski"
        steamProfile = "https://steamcommunity.com/id/zedorfski"
    end

    musicVolume = GetConVar("tm_menumusicvolume"):GetInt() / 4

    if GetConVar("tm_menumusic"):GetInt() == 1 then
        menuMusic:Play()
        menuMusic:ChangeVolume(musicVolume * 1.45)
    end

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
                mapThumb = t[3]
            end
        end

        MainMenu.Paint = function()
            if dof == true then DrawBokehDOF(4, 1, 0) end
            surface.SetDrawColor(40, 40, 40, 225)
            surface.DrawRect(0, 0, MainMenu:GetWide(), MainMenu:GetTall())
        end

        gui.EnableScreenClicker(true)

        local MainPanel = MainMenu:Add("MainPanel")
            MainPanel.Paint = function()
                if GetConVar("tm_menumusic"):GetInt() == 1 then
                    draw.SimpleText("Listening to: " .. musicName, "StreakText", ScrW() - 5, 0, white, TEXT_ALIGN_RIGHT)

                    if requestedBy ~= nil then
                        draw.SimpleText("Requested by " .. requestedBy, "StreakText", ScrW() - 5, 20, white, TEXT_ALIGN_RIGHT)
                    end
                else
                    draw.SimpleText("Listening to nothing, peace and quiet :)", "StreakText", ScrW() - 5, 0, white, TEXT_ALIGN_RIGHT)
                end

                if mapID ~= nil then
                    draw.SimpleText(mapName, "MainMenuMusicName", ScrW() - 210, ScrH() - 35, white, TEXT_ALIGN_RIGHT)
                    draw.SimpleText("Match ends in " .. math.Round(GetGlobalInt("tm_matchtime", 0) - CurTime()) .. "s", "StreakText", ScrW() - 5, ScrH() - 230, white, TEXT_ALIGN_RIGHT)
                else
                    draw.SimpleText("Playing on " .. game.GetMap(), "MainMenuMusicName", ScrW() - 5, ScrH() - 35, white, TEXT_ALIGN_RIGHT)
                end

                draw.SimpleText(LocalPly:GetNWInt("playerLevel"), "AmmoCountSmall", 440, -5, white, TEXT_ALIGN_LEFT)

                if LocalPly:GetNWInt("playerPrestige") ~= 0 and LocalPly:GetNWInt("playerLevel") ~= 60 then
                    draw.SimpleText("P" .. LocalPly:GetNWInt("playerPrestige"), "StreakText", 660, 37.5, white, TEXT_ALIGN_RIGHT)
                elseif LocalPly:GetNWInt("playerPrestige") ~= 0 and LocalPly:GetNWInt("playerLevel") == 60 then
                    draw.SimpleText("P" .. LocalPly:GetNWInt("playerPrestige"), "StreakText", 535, 37.5, white, TEXT_ALIGN_LEFT)
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
                    surface.PlaySound("tmui/buttonclick.wav")
                    if (prestigeConfirm == 0) then
                        prestigeConfirm = 1
                    else
                        LocalPly:ConCommand("tm_prestige")
                        PrestigeButton:Hide()
                    end

                    timer.Simple(3, function() prestigeConfirm = 0 end)
                end
            end

            if requestedBy ~= nil and GetConVar("tm_menumusic"):GetInt() == 1 then
                local ProfileButton = vgui.Create("DImageButton", MainPanel)
                ProfileButton:SetPos(ScrW() - 37, 45)
                ProfileButton:SetSize(32, 32)
                ProfileButton:SetImage("icons/steamicon.png")
                ProfileButton.DoClick = function()
                    gui.OpenURL(steamProfile)
                end
            end

            CallingCard = vgui.Create("DImage", MainPanel)
            CallingCard:SetPos(190, 10)
            CallingCard:SetSize(240, 80)
            CallingCard:SetImage(LocalPly:GetNWString("chosenPlayercard"), "cards/color/black.png")

            playerProfilePicture = vgui.Create("AvatarImage", MainPanel)
            playerProfilePicture:SetPos(195, 15)
            playerProfilePicture:SetSize(70, 70)
            playerProfilePicture:SetPlayer(LocalPly, 184)

            if mapID ~= nil then
                MapPreview = vgui.Create("DImage", MainPanel)
                MapPreview:SetPos(ScrW() - 205, ScrH() - 205)
                MapPreview:SetSize(200, 200)
                MapPreview:SetImage(mapThumb)
            end

            local StatisticsButton = vgui.Create("DImageButton", MainPanel)
            StatisticsButton:SetPos(10, 10)
            StatisticsButton:SetImage("icons/statsicon.png")
            StatisticsButton:SetSize(80, 80)
            StatisticsButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                MainPanel:Hide()

                if not IsValid(StatisticsPanel) then
                    local comparisonSelectedPlayer = nil
                    local comparingWith = false

                    local StatisticsPanel = MainMenu:Add("StatsPanel")
                    local StatisticsSlideoutPanel = MainMenu:Add("StatsSlideoutPanel")

                    local StatsQuickjumpHolder = vgui.Create("DPanel", StatisticsSlideoutPanel)
                    StatsQuickjumpHolder:Dock(TOP)
                    StatsQuickjumpHolder:SetSize(0, ScrH())

                    StatsQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end

                    local StatsScroller = vgui.Create("DScrollPanel", StatisticsPanel)
                    StatsScroller:Dock(FILL)

                    local sbar = StatsScroller:GetVBar()
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

                    local StatsTextHolder = vgui.Create("DPanel", StatsScroller)
                    StatsTextHolder:Dock(TOP)
                    StatsTextHolder:SetSize(0, 150)

                    StatsTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("STATISTICS", "AmmoCountSmall", 20, 20, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("View your lifetime stats.", "PlayerNotiName", 20, 100, white, TEXT_ALIGN_LEFT)
                    end

                    local StatsCombat = vgui.Create("DPanel", StatsScroller)
                    StatsCombat:Dock(TOP)
                    StatsCombat:SetSize(0, 330)

                    local StatsAccolades = vgui.Create("DPanel", StatsScroller)
                    StatsAccolades:Dock(TOP)
                    StatsAccolades:SetSize(0, 320)

                    local StatsWeapons = vgui.Create("DPanel", StatsScroller)
                    StatsWeapons:Dock(TOP)
                    StatsWeapons:SetSize(0, 6260)

                    local comparePlayerStats = StatsTextHolder:Add("DComboBox")
                    comparePlayerStats:SetPos(524, 113)
                    comparePlayerStats:SetSize(200, 30)
                    comparePlayerStats:SetValue("Compare stats with...")
                    comparePlayerStats.OnSelect = function(_, _, value, id)
                        comparisonSelectedPlayerID = id
                        comparingWith = player.GetBySteamID(comparisonSelectedPlayerID)
                        comparePlayerStats:SetValue("Comparing with " .. value)

                        comparingWithPFP = vgui.Create("AvatarImage", StatsCombat)
                        comparingWithPFP:SetPos(656, 15)
                        comparingWithPFP:SetSize(64, 64)
                        comparingWithPFP:SetPlayer(comparingWith, 184)
                    end

                    for _, v in pairs(player.GetAll()) do
                        if v:GetInfoNum("tm_hidestatsfromothers", 0) == 0 and v ~= LocalPly then
                            comparePlayerStats:AddChoice(v:Name(), v:SteamID())
                        end
                    end

                    local trackingPlayer = LocalPly

                    StatsCombat.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("COMBAT", "OptionsHeader", 20, 20, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Total Score:", "SettingsLabel", 20, 80, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerScore"), "SettingsLabel", 500, 80, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Total Player Kills:", "SettingsLabel", 20, 115, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerKills"), "SettingsLabel", 500, 115, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Total Deaths:", "SettingsLabel", 20, 150, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerDeaths"), "SettingsLabel", 500, 150, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("K/D Ratio:", "SettingsLabel", 20, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(math.Round(trackingPlayer:GetNWInt("playerKDR"), 3), "SettingsLabel", 500, 185, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Highest Player Killstreak:", "SettingsLabel", 20, 220, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("highestKillStreak"), "SettingsLabel", 500, 220, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Matches Played:", "SettingsLabel", 20, 255, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("matchesPlayed"), "SettingsLabel", 500, 255, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Matches Won:", "SettingsLabel", 20, 290, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("matchesWon"), "SettingsLabel", 500, 290, white, TEXT_ALIGN_RIGHT)

                        if comparingWith ~= false then
                            draw.SimpleText(comparingWith:GetNWInt("playerScore"), "SettingsLabel", 720, 80, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerKills"), "SettingsLabel", 720, 115, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerDeaths"), "SettingsLabel", 720, 150, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(math.Round(comparingWith:GetNWInt("playerKDR"), 3), "SettingsLabel", 720, 185, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("highestKillStreak"), "SettingsLabel", 720, 220, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("matchesPlayed"), "SettingsLabel", 720, 255, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("matchesWon"), "SettingsLabel", 720, 290, white, TEXT_ALIGN_RIGHT)
                        end
                    end

                    StatsAccolades.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("ACCOLADES", "OptionsHeader", 20, 20, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Headshot Kills:", "SettingsLabel", 20, 80, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeHeadshot"), "SettingsLabel", 500, 80, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Melee Kills (Smackdowns):", "SettingsLabel", 20, 115, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeSmackdown"), "SettingsLabel", 500, 115, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Clutches (Kills with <15HP):", "SettingsLabel", 20, 150, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeClutch"), "SettingsLabel", 500, 150, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Longshot Kills:", "SettingsLabel", 20, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeLongshot"), "SettingsLabel", 500, 185, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Point Blank Kills:", "SettingsLabel", 20, 220, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladePointblank"), "SettingsLabel", 500, 220, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Killstreaks Started:", "SettingsLabel", 20, 255, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeOnStreak"), "SettingsLabel", 500, 255, white, TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Killstreaks Ended:", "SettingsLabel", 20, 290, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeBuzzkill"), "SettingsLabel", 500, 290, white, TEXT_ALIGN_RIGHT)

                        if comparingWith ~= false then
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeHeadshot"), "SettingsLabel", 720, 80, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeSmackdown"), "SettingsLabel", 720, 115, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeClutch"), "SettingsLabel", 720, 150, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeLongshot"), "SettingsLabel", 720, 185, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladePointblank"), "SettingsLabel", 720, 220, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeOnStreak"), "SettingsLabel", 720, 255, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeBuzzkill"), "SettingsLabel", 720, 290, white, TEXT_ALIGN_RIGHT)
                        end
                    end

                    StatsWeapons.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("WEAPONS", "OptionsHeader", 20, 20, white, TEXT_ALIGN_LEFT)

                        for p, t in pairs(weaponArray) do
                            draw.SimpleText(t[2] .. " Kills: ", "SettingsLabel", 20, 80 + ((p - 1) * 47.5), white, TEXT_ALIGN_LEFT)
                            draw.SimpleText(trackingPlayer:GetNWInt("killsWith_" .. t[1]), "SettingsLabel", 500, 80 + ((p - 1) * 47.5), white, TEXT_ALIGN_RIGHT)
                            if t[4] ~= nil then draw.DrawText(t[3] .. " | " .. t[4], "CaliberText", 22.5, 112.5 + ((p - 1) * 47.5), white, TEXT_ALIGN_LEFT) else draw.DrawText(t[3], "StreakTextMini", 22.5, 112.5 + ((p - 1) * 47.5), white, TEXT_ALIGN_LEFT) end

                            if comparingWith ~= false then
                                draw.SimpleText(comparingWith:GetNWInt("killsWith_" .. t[1]), "SettingsLabel", 720, 80 + ((p - 1) * 47.5), white, TEXT_ALIGN_RIGHT)
                            end
                        end
                    end

                    localPFP = vgui.Create("AvatarImage", StatsCombat)
                    localPFP:SetPos(436, 15)
                    localPFP:SetSize(64, 64)
                    localPFP:SetPlayer(LocalPly, 184)

                    local StatsIcon = vgui.Create("DImage", StatsQuickjumpHolder)
                    StatsIcon:SetPos(12, 12)
                    StatsIcon:SetSize(32, 32)
                    StatsIcon:SetImage("icons/statsslideouticon.png")

                    local CombatJump = vgui.Create("DImageButton", StatsQuickjumpHolder)
                    CombatJump:SetPos(4, 100)
                    CombatJump:SetSize(48, 48)
                    CombatJump:SetImage("icons/uikillicon.png")
                    CombatJump:SetTooltip("Combat Stats")
                    CombatJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        StatsScroller:ScrollToChild(StatsCombat)
                    end

                    local AccoladesJump = vgui.Create("DImageButton", StatsQuickjumpHolder)
                    AccoladesJump:SetPos(4, 152)
                    AccoladesJump:SetSize(48, 48)
                    AccoladesJump:SetImage("icons/accoladeicon.png")
                    AccoladesJump:SetTooltip("Accolade Stats")
                    AccoladesJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        StatsScroller:ScrollToChild(StatsAccolades)
                    end

                    local WeaponsJump = vgui.Create("DImageButton", StatsQuickjumpHolder)
                    WeaponsJump:SetPos(4, 204)
                    WeaponsJump:SetSize(48, 48)
                    WeaponsJump:SetImage("icons/weaponicon.png")
                    WeaponsJump:SetTooltip("Weapon Stats")
                    WeaponsJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        StatsScroller:ScrollToChild(StatsWeapons)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", StatsQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        MainPanel:Show()
                        StatisticsPanel:Hide()
                        StatisticsSlideoutPanel:Hide()
                    end
                end
            end

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
            SpectatePicker:AddChoice("Freecam")
            SpectatePicker.OnSelect = function(_, _, value, id)
                net.Start("BeginSpectate")
                net.SendToServer()
                MainMenu:Remove(false)
                gui.EnableScreenClicker(false)
                menuMusic:FadeOut(1)
            end

            local SpectateButton = vgui.Create("DImageButton", MainPanel)
            SpectateButton:SetPos(100, 10)
            SpectateButton:SetImage("icons/spectateicon.png")
            SpectateButton:SetSize(80, 80)
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

            local WorkshopButton = vgui.Create("DImageButton", MainPanel)
            WorkshopButton:SetPos(8, ScrH() - 72)
            WorkshopButton:SetImage("icons/workshopicon.png")
            WorkshopButton:SetSize(64, 64)
            WorkshopButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2863062354")
            end

            local YouTubeButton = vgui.Create("DImageButton", MainPanel)
            YouTubeButton:SetPos(80, ScrH() - 72)
            YouTubeButton:SetImage("icons/youtubeicon.png")
            YouTubeButton:SetSize(64, 64)
            YouTubeButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                gui.OpenURL("https://www.youtube.com/channel/UC1aCX3i4L6TyEv_rmo_HeRA")
            end

            local GithubButton = vgui.Create("DImageButton", MainPanel)
            GithubButton:SetPos(152, ScrH() - 72)
            GithubButton:SetImage("icons/githubicon.png")
            GithubButton:SetSize(64, 64)
            GithubButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                gui.OpenURL("https://github.com/PikachuPenial/Titanmod")
            end

            local SpawnButton = vgui.Create("DButton", MainPanel)
            SpawnButton:SetPos(0, ScrH() / 2 - 200)
            SpawnButton:SetText("")
            SpawnButton:SetSize(535, 100)
            local textAnim = 0
            SpawnButton.Paint = function()
                if SpawnButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                else
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                end

                draw.DrawText("SPAWN", "AmmoCountSmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
                for k, v in pairs(weaponArray) do
                    if v[1] == LocalPly:GetNWString("loadoutPrimary") and usePrimary then draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + textAnim, 15, white, TEXT_ALIGN_LEFT) end
                    if v[1] == LocalPly:GetNWString("loadoutSecondary") and useSecondary then draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + textAnim, 40 , white, TEXT_ALIGN_LEFT) end
                    if v[1] == LocalPly:GetNWString("loadoutMelee") and useMelee then draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + textAnim, 65, white, TEXT_ALIGN_LEFT) end
                end
            end
            SpawnButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                MainMenu:Remove()
                gui.EnableScreenClicker(false)

                menuMusic:FadeOut(1)

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
            local pushButtonsAbove = 100
            CustomizeButton.Paint = function()
                if CustomizeButton:IsHovered() or CustomizeModelButton:IsHovered() or CustomizeCardButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                    pushButtonsAbove = math.Clamp(pushButtonsAbove + 600 * FrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, ScrH() / 2 - pushButtonsAbove)
                    CustomizeButton:SizeTo(-1, 200, 0, 0, 1)
                else
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                    pushButtonsAbove = math.Clamp(pushButtonsAbove - 600 * FrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, ScrH() / 2 - pushButtonsAbove)
                    CustomizeButton:SizeTo(-1, 100, 0, 0, 1)
                end
                draw.DrawText("CUSTOMIZE", "AmmoCountSmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
                SpawnButton:SetPos(0, ScrH() / 2 - 100 - pushButtonsAbove)
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

                    local CardTextHolder = vgui.Create("DPanel", CardScroller)
                    CardTextHolder:Dock(TOP)
                    CardTextHolder:SetSize(0, 170)

                    CardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("CARDS", "AmmoCountSmall", 257.5, 20, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(cardsUnlocked .. " / " .. totalCards .. " cards unlocked", "Health", 257.5, 100, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText("Hide locked playercards", "StreakText", w / 2 + 20, 140, white, TEXT_ALIGN_CENTER)
                    end

                    local HideLockedCards = CardTextHolder:Add("DCheckBox")
                    HideLockedCards:SetPos(145, 142.5)
                    HideLockedCards:SetValue(false)
                    HideLockedCards:SetSize(20, 20)
                    HideLockedCards:SetTooltip("Hide playercards that you do not have unlocked.")

                    --Default Playercards
                    local TextDefault = vgui.Create("DPanel", CardScroller)
                    TextDefault:Dock(TOP)
                    TextDefault:SetSize(0, 90)

                    local DockDefaultCards = vgui.Create("DPanel", CardScroller)
                    DockDefaultCards:Dock(TOP)
                    DockDefaultCards:SetSize(0, 250)

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
                    DockAccoladeCards:SetSize(0, 583)

                    --Leveling related Playercards
                    local TextLevel = vgui.Create("DPanel", CardScroller)
                    TextLevel:Dock(TOP)
                    TextLevel:SetSize(0, 90)

                    local DockLevelCards = vgui.Create("DPanel", CardScroller)
                    DockLevelCards:Dock(TOP)
                    DockLevelCards:SetSize(0, 1280)

                    --Mastery related Playercards
                    local TextMastery = vgui.Create("DPanel", CardScroller)
                    TextMastery:Dock(TOP)
                    TextMastery:SetSize(0, 90)

                    local DockMasteryCards = vgui.Create("DPanel", CardScroller)
                    DockMasteryCards:Dock(TOP)
                    DockMasteryCards:SetSize(0, 5440)

                    --Color related Playercards
                    local TextColor = vgui.Create("DPanel", CardScroller)
                    TextColor:Dock(TOP)
                    TextColor:SetSize(0, 90)

                    local DockColorCards = vgui.Create("DPanel", CardScroller)
                    DockColorCards:Dock(TOP)
                    DockColorCards:SetSize(0, 930)

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
                            draw.SimpleText(newCardName, "PlayerNotiName", 5, 90, white, TEXT_ALIGN_LEFT)
                            draw.SimpleText(newCardDesc, "Health", 5, 135, white, TEXT_ALIGN_LEFT)
                        end

                        if newCardUnlockType == "default" or newCardUnlockType == "color" then
                            draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                        elseif newCardUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Kills: " .. LocalPly:GetNWInt("playerKills") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Kills: " .. LocalPly:GetNWInt("playerKills") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Highest Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Highest Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "level" then
                            if playerTotalLevel < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Total Levels: " .. playerTotalLevel .. "/" .. newCardUnlockValue, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Total Levels: " .. playerTotalLevel .. "/" .. newCardUnlockValue, "Health", 510, 135, solidGreen, TEXT_ALIGN_RIGHT)
                            end
                        elseif newCardUnlockType == "mastery" then
                            if LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) < 50 then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, solidRed, TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Kills w/ gun: " .. LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) .. "/" .. 50, "Health", 510, 135, solidRed, TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, solidGreen, TEXT_ALIGN_RIGHT)
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
                        draw.SimpleText("Colors and Pride", "OptionsHeader", 257.5, 0, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(colorCardsUnlocked .. " / " .. colorCardsTotal, "Health", 257.5, 55, solidGreen, TEXT_ALIGN_CENTER)
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
                        if newCardUnlockType == "default" or newCardUnlockType == "color" then
                            surface.PlaySound("common/wpn_select.wav")
                            RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                            MainPanel:Show()
                            CardPanel:Hide()
                            CardPreviewPanel:Hide()
                            CardSlideoutPanel:Hide()
                        elseif newCardUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "level" then
                            if playerTotalLevel < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        elseif newCardUnlockType == "mastery" then
                            if LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) < masteryUnlock then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue, masteryUnlock)
                                MainPanel:Show()
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
                            FillCardListsUnlocked()
                            DockDefaultCards:SetSize(0, 250)
                            DockKillCards:SetSize(0, (killCardsUnlocked * 42.5) + 42.5)
                            DockAccoladeCards:SetSize(0, (accoladeCardsUnlocked * 42.5) + 42.5)
                            DockLevelCards:SetSize(0, (levelCardsUnlocked * 42.5) + 42.5)
                            DockMasteryCards:SetSize(0, (masteryCardsUnlocked * 42.5) + 42.5)
                            DockColorCards:SetSize(0, (colorCardsUnlocked * 42.5) + 42.5)
                        else
                            DefaultCardList:Clear()
                            KillCardList:Clear()
                            AccoladeCardList:Clear()
                            LevelCardList:Clear()
                            MasteryCardList:Clear()
                            ColorCardList:Clear()
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
                            FillCardListsAll()
                            DockDefaultCards:SetSize(0, 250)
                            DockKillCards:SetSize(0, 250)
                            DockAccoladeCards:SetSize(0, 583)
                            DockLevelCards:SetSize(0, 1280)
                            DockMasteryCards:SetSize(0, 5440)
                            DockColorCards:SetSize(0, 930)
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

                    local KillsJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    KillsJump:SetPos(4, 152)
                    KillsJump:SetSize(48, 48)
                    KillsJump:SetImage("icons/uikillicon.png")
                    KillsJump:SetTooltip("Kills")
                    KillsJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextKill)
                    end

                    local AccoladeJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    AccoladeJump:SetPos(4, 204)
                    AccoladeJump:SetSize(48, 48)
                    AccoladeJump:SetImage("icons/accoladeicon.png")
                    AccoladeJump:SetTooltip("Accolades")
                    AccoladeJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextAccolade)
                    end

                    local LevelJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    LevelJump:SetPos(4, 256)
                    LevelJump:SetSize(48, 48)
                    LevelJump:SetImage("icons/performanceicon.png")
                    LevelJump:SetTooltip("Leveling")
                    LevelJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextLevel)
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

                    local PaletteJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    PaletteJump:SetPos(4, 360)
                    PaletteJump:SetSize(48, 48)
                    PaletteJump:SetImage("icons/paletteicon.png")
                    PaletteJump:SetTooltip("Colors and Pride")
                    PaletteJump.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        CardScroller:ScrollToChild(TextColor)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", CardQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        MainPanel:Show()
                        CardPanel:Hide()
                        CardPreviewPanel:Hide()
                        CardSlideoutPanel:Hide()
                    end
                end
            end

            CustomizeModelButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                MainPanel:Hide()

                local currentModel = LocalPly:GetNWString("chosenPlayermodel")

                if not IsValid(CustomizePanel) then
                    local CustomizePanel = MainMenu:Add("CustomizePanel")
                    local CustomizeSlideoutPanel = MainMenu:Add("CustomizeSlideoutPanel")

                    local newModel
                    local newModelName
                    local newModelDesc
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
                            newModelDesc = v[3]
                            newModelUnlockType = v[4]
                            newModelUnlockValue = v[5]
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
                        draw.RoundedBox(5, 0, 0, w, h, lightGray)
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

                    local CustomizeTextHolder = vgui.Create("DPanel", CustomizeScroller)
                    CustomizeTextHolder:Dock(TOP)
                    CustomizeTextHolder:SetSize(0, 170)

                    CustomizeTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("MODELS", "AmmoCountSmall", w / 2, 20, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(modelsUnlocked .. " / " .. totalModels .. " models unlocked", "Health", w / 2, 100, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText("Hide locked playermodels", "StreakText", w / 2 + 20, 140, white, TEXT_ALIGN_CENTER)
                    end

                    local HideLockedModels = CustomizeTextHolder:Add("DCheckBox")
                    HideLockedModels:SetPos(120, 142.5)
                    HideLockedModels:SetValue(false)
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
                    DockModelsAccolade:SetSize(0, 610)

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
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
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
                            draw.SimpleText(newModelName, "PlayerNotiName", w / 2, 5, white, TEXT_ALIGN_CENTER)
                            draw.SimpleText(newModelDesc, "Health", w / 2, 50, white, TEXT_ALIGN_CENTER)
                        end

                        if newModelUnlockType == "default" then
                            draw.SimpleText("Unlocked", "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                        elseif newModelUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newModelUnlockValue then
                                draw.SimpleText("Total Kills: " .. LocalPly:GetNWInt("playerKills") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Total Kills: " .. LocalPly:GetNWInt("playerKills") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newModelUnlockValue then
                                draw.SimpleText("Longest Kill Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Longest Kill Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newModelUnlockValue then
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newModelUnlockValue then
                                draw.SimpleText("Smackdowns: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Smackdowns: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newModelUnlockValue then
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newModelUnlockValue then
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newModelUnlockValue then
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newModelUnlockValue then
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newModelUnlockValue then
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. " / " .. newModelUnlockValue, "Health", w / 2, 75, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        end
                    end

                    local SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                    SelectedModelDisplay:SetSize(475, 337.5)
                    SelectedModelDisplay:SetPos(0, 120)
                    SelectedModelDisplay:SetModel(newModel)

                    local function FillModelListsAll()
                        for k, v in pairs(modelArray) do
                            if v[4] == "default" then
                                local icon = vgui.Create("SpawnIcon", DockModels)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2] .. "\n" .. v[3])
                                icon:SetSize(150, 150)
                                DefaultModelList:Add(icon)

                                defaultModelsTotal = defaultModelsTotal + 1
                                modelsUnlocked = modelsUnlocked + 1
                                defaultModelsUnlocked = defaultModelsUnlocked + 1

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelDesc = v[3]
                                    newModelUnlockType = v[4]
                                    newModelUnlockValue = v[5]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "kills" then
                                local icon = vgui.Create("SpawnIcon", DockModelsKills)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2] .. "\n" .. v[3])
                                icon:SetSize(150, 150)
                                KillsModelList:Add(icon)

                                killModelsTotal = killModelsTotal + 1

                                if LocalPly:GetNWInt("playerKills") < v[5] then
                                    local lockIndicator = vgui.Create("DImageButton", icon)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(96, 96)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelDesc = v[3]
                                        newModelUnlockType = v[4]
                                        newModelUnlockValue = v[5]

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
                                    newModelDesc = v[3]
                                    newModelUnlockType = v[4]
                                    newModelUnlockValue = v[5]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "streak" then
                                local icon = vgui.Create("SpawnIcon", DockModelsStreak)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2] .. "\n" .. v[3])
                                icon:SetSize(150, 150)
                                StreakModelList:Add(icon)

                                streakModelsTotal = streakModelsTotal + 1

                                if LocalPly:GetNWInt("highestKillStreak") < v[5] then
                                    local lockIndicator = vgui.Create("DImageButton", icon)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(96, 96)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelDesc = v[3]
                                        newModelUnlockType = v[4]
                                        newModelUnlockValue = v[5]

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
                                    newModelDesc = v[3]
                                    newModelUnlockType = v[4]
                                    newModelUnlockValue = v[5]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "headshot" or v[4] == "smackdown" or v[4] == "clutch" or v[4] == "longshot" or v[4] == "pointblank" or v[4] == "killstreaks" or v[4] == "buzzkills" then
                                local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2] .. "\n" .. v[3])
                                icon:SetSize(150, 150)
                                AccoladeModelList:Add(icon)

                                accoladeModelsTotal = accoladeModelsTotal + 1

                                if v[4] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") < v[5] or v[4] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") < v[5] or v[4] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") < v[5] or v[4] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") < v[5] or v[4] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") < v[5] or v[4] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") < v[5] or v[4] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") < v[5] then
                                    local lockIndicator = vgui.Create("DImageButton", icon)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(96, 96)
                                    lockIndicator:Center()
                                    lockIndicator.DoClick = function(lockIndicator)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelDesc = v[3]
                                        newModelUnlockType = v[4]
                                        newModelUnlockValue = v[5]

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
                                    newModelDesc = v[3]
                                    newModelUnlockType = v[4]
                                    newModelUnlockValue = v[5]

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
                            if v[4] == "default" then
                                local icon = vgui.Create("SpawnIcon", DockModels)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2] .. "\n" .. v[3])
                                icon:SetSize(150, 150)
                                DefaultModelList:Add(icon)

                                defaultModelsTotal = defaultModelsTotal + 1
                                modelsUnlocked = modelsUnlocked + 1
                                defaultModelsUnlocked = defaultModelsUnlocked + 1

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelDesc = v[3]
                                    newModelUnlockType = v[4]
                                    newModelUnlockValue = v[5]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(400, 400)
                                    SelectedModelDisplay:SetPos(0, -25)
                                    SelectedModelDisplay:SetModel(newModel)

                                    surface.PlaySound("tmui/buttonrollover.wav")
                                end
                            elseif v[4] == "kills" then
                                killModelsTotal = killModelsTotal + 1
                                if LocalPly:GetNWInt("playerKills") >= v[5] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsKills)
                                    icon:SetModel(v[1])
                                    icon:SetTooltip(v[2] .. "\n" .. v[3])
                                    icon:SetSize(150, 150)
                                    KillsModelList:Add(icon)

                                    killModelsUnlocked = killModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.DoClick = function(icon)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelDesc = v[3]
                                        newModelUnlockType = v[4]
                                        newModelUnlockValue = v[5]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(400, 400)
                                        SelectedModelDisplay:SetPos(0, -25)
                                        SelectedModelDisplay:SetModel(newModel)

                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                end
                            elseif v[4] == "streak" then
                                streakModelsTotal = streakModelsTotal + 1

                                if LocalPly:GetNWInt("highestKillStreak") >= v[5] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsStreak)
                                    icon:SetModel(v[1])
                                    icon:SetTooltip(v[2] .. "\n" .. v[3])
                                    icon:SetSize(150, 150)
                                    StreakModelList:Add(icon)

                                    streakModelsUnlocked = streakModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.DoClick = function(icon)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelDesc = v[3]
                                        newModelUnlockType = v[4]
                                        newModelUnlockValue = v[5]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(400, 400)
                                        SelectedModelDisplay:SetPos(0, -25)
                                        SelectedModelDisplay:SetModel(newModel)

                                        surface.PlaySound("tmui/buttonrollover.wav")
                                    end
                                end
                            elseif v[4] == "headshot" or v[4] == "smackdown" or v[4] == "clutch" or v[4] == "longshot" or v[4] == "pointblank" or v[4] == "killstreaks" or v[4] == "buzzkills" then
                                accoladeModelsTotal = accoladeModelsTotal + 1

                                if v[4] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") >= v[5] or v[4] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") >= v[5] or v[4] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") >= v[5] or v[4] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") >= v[5] or v[4] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") >= v[5] or v[4] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") >= v[5] or v[4] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") >= v[5] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                                    icon:SetModel(v[1])
                                    icon:SetTooltip(v[2] .. "\n" .. v[3])
                                    icon:SetSize(150, 150)
                                    AccoladeModelList:Add(icon)

                                    accoladeModelsUnlocked = accoladeModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.DoClick = function(icon)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelDesc = v[3]
                                        newModelUnlockType = v[4]
                                        newModelUnlockValue = v[5]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(400, 400)
                                        SelectedModelDisplay:SetPos(0, -25)
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
                            RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                            MainPanel:Show()
                            CustomizeSlideoutPanel:Hide()
                            CustomizePanel:Hide()
                            PreviewPanel:Hide()
                        elseif newModelUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
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
                            DockModelsAccolade:SetSize(0, 775)
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

                    local BackButtonSlideout = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        MainPanel:Show()
                        CustomizeSlideoutPanel:Hide()
                        CustomizePanel:Hide()
                        PreviewPanel:Hide()
                    end
                end
            end

            local OptionsButton = vgui.Create("DButton", MainPanel)
            OptionsButton:SetPos(0, ScrH() / 2)
            OptionsButton:SetText("")
            OptionsButton:SetSize(415, 100)
            local textAnim = 0
            OptionsButton.Paint = function()
                if OptionsButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                else
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                end
                draw.DrawText("OPTIONS", "AmmoCountSmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end
            OptionsButton.DoClick = function()
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
                    DockUI:SetSize(0, 395)

                    local DockAudio = vgui.Create("DPanel", OptionsScroller)
                    DockAudio:Dock(TOP)
                    DockAudio:SetSize(0, 320)

                    local DockWeaponry = vgui.Create("DPanel", OptionsScroller)
                    DockWeaponry:Dock(TOP)
                    DockWeaponry:SetSize(0, 395)

                    local DockCrosshair = vgui.Create("DPanel", OptionsScroller)
                    DockCrosshair:Dock(TOP)
                    DockCrosshair:SetSize(0, 675)

                    local DockHitmarker = vgui.Create("DPanel", OptionsScroller)
                    DockHitmarker:Dock(TOP)
                    DockHitmarker:SetSize(0, 315)

                    local DockPerformance = vgui.Create("DPanel", OptionsScroller)
                    DockPerformance:Dock(TOP)
                    DockPerformance:SetSize(0, 320)

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
                    hideStatsFromOthers:SetValue(true)
                    hideStatsFromOthers:SetSize(30, 30)
                    hideStatsFromOthers:SetTooltip("Hides your own personal stats from other players, making them only viewable by you.")

                    DockInputs.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("INPUT", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("ADS Sensitivity", "SettingsLabel", 155, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Toggle ADS", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
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

                    local ironsToggle = DockInputs:Add("DCheckBox")
                    ironsToggle:SetPos(20, 110)
                    ironsToggle:SetConVar("cl_tfa_ironsights_toggle")
                    ironsToggle:SetValue(true)
                    ironsToggle:SetSize(30, 30)
                    ironsToggle:SetTooltip("Enable click-to-ADS instead of hold-to-ADS.")

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
                        draw.SimpleText("Enable Kill Popup", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Death Popup", "SettingsLabel", 55, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill Popup Accolades", "SettingsLabel", 55, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Reload Hints", "SettingsLabel", 55, 225, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Loadout Hints", "SettingsLabel", 55, 265, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill Tracker", "SettingsLabel", 55, 305, white, TEXT_ALIGN_LEFT)
                    end

                    local enableUIButton = DockUI:Add("DCheckBox")
                    enableUIButton:SetPos(20, 70)
                    enableUIButton:SetConVar("tm_hud_enable")
                    enableUIButton:SetSize(30, 30)
                    enableUIButton:SetTooltip("Enable the UI.")

                    local enableKillUIButton = DockUI:Add("DCheckBox")
                    enableKillUIButton:SetPos(20, 110)
                    enableKillUIButton:SetConVar("tm_hud_enablekill")
                    enableKillUIButton:SetValue(true)
                    enableKillUIButton:SetSize(30, 30)
                    enableKillUIButton:SetTooltip("Enable the kill UI.")

                    local enableDeathUIButton = DockUI:Add("DCheckBox")
                    enableDeathUIButton:SetPos(20, 150)
                    enableDeathUIButton:SetConVar("tm_hud_enabledeath")
                    enableDeathUIButton:SetValue(true)
                    enableDeathUIButton:SetSize(30, 30)
                    enableDeathUIButton:SetTooltip("Enable the death UI.")

                    local accoladeToggle = DockUI:Add("DCheckBox")
                    accoladeToggle:SetPos(20, 190)
                    accoladeToggle:SetConVar("tm_hud_killaccolades")
                    accoladeToggle:SetValue(true)
                    accoladeToggle:SetSize(30, 30)
                    accoladeToggle:SetTooltip("Enable accolades displaying on the kill UI.")

                    local reloadHintsToggle = DockUI:Add("DCheckBox")
                    reloadHintsToggle:SetPos(20, 230)
                    reloadHintsToggle:SetConVar("tm_hud_reloadhint")
                    reloadHintsToggle:SetValue(true)
                    reloadHintsToggle:SetSize(30, 30)
                    reloadHintsToggle:SetTooltip("Enable visual cues when you need to reload.")

                    local loadoutHintsToggle = DockUI:Add("DCheckBox")
                    loadoutHintsToggle:SetPos(20, 270)
                    loadoutHintsToggle:SetConVar("tm_hud_loadouthint")
                    loadoutHintsToggle:SetValue(true)
                    loadoutHintsToggle:SetSize(30, 30)
                    loadoutHintsToggle:SetTooltip("Enable the loadout hud when you respawn.")

                    local killTrackerToggle = DockUI:Add("DCheckBox")
                    killTrackerToggle:SetPos(20, 310)
                    killTrackerToggle:SetConVar("tm_hud_killtracker")
                    killTrackerToggle:SetValue(true)
                    killTrackerToggle:SetSize(30, 30)
                    killTrackerToggle:SetTooltip("Enable the weapon specific kill tracking on the HUD.")

                    local HUDEditorButton = vgui.Create("DButton", DockUI)
                    HUDEditorButton:SetPos(20, 350)
                    HUDEditorButton:SetText("")
                    HUDEditorButton:SetSize(300, 40)
                    HUDEditorButton:SetTooltip("Adjust the position and size of many HUD elements.")
                    local textAnim = 0
                    HUDEditorButton.Paint = function()
                        if HUDEditorButton:IsHovered() then
                            textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                        else
                            textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                        end
                        draw.DrawText("Open HUD Editor", "SettingsLabel", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                    end
                    HUDEditorButton.DoClick = function()
                        surface.PlaySound("tmui/buttonclick.wav")
                        OptionsSlideoutPanel:Hide()
                        OptionsPanel:Hide()

                        local health = 100
                        local ammo = 30
                        local wep = "KRISS Vector"
                        local fakeFeedArray = {}
                        timer.Create("previewLoop", 1, 0, function()
                            health = math.random(1, 100)
                            ammo = math.random(1, 30)
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
                                if v[2] == 1 and v[2] != nil then surface.SetDrawColor(150, 50, 50, 80) else surface.SetDrawColor(50, 50, 50, 80) end
                                local nameLength = select(1, surface.GetTextSize(v[1]))

                                surface.DrawRect(10 + GetConVar("tm_hud_killfeed_offset_x"):GetInt(), ScrH() - 20 + ((k - 1) * feedStyle) - GetConVar("tm_hud_killfeed_offset_y"):GetInt(), nameLength + 5, 20)
                                draw.SimpleText(v[1], "HUD_StreakText", 12.5 + GetConVar("tm_hud_killfeed_offset_x"):GetInt(), ScrH() - 10 + ((k - 1) * feedStyle) - GetConVar("tm_hud_killfeed_offset_y"):GetInt(), Color(250, 250, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            end
                        end

                        local EditorPanel = vgui.Create("DFrame", FakeHUD)
                        EditorPanel:SetSize(435, 550)
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
                            OptionsSlideoutPanel:Show()
                            OptionsPanel:Show()
                            timer.Remove("previewLoop")
                        end

                        local EditorScroller = vgui.Create("DScrollPanel", EditorPanel)
                        EditorScroller:Dock(FILL)

                        local sbar = EditorScroller:GetVBar()
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
                            draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 50))
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
                        KillUICustomFont:SetValue(true)
                        KillUICustomFont:SetSize(30, 30)
                        KillUICustomFont:SetTooltip("Enable use of your custom font for the kill UI.")

                        local DeathUICustomFont = GeneralEditor:Add("DCheckBox")
                        DeathUICustomFont:SetPos(20, 170)
                        DeathUICustomFont:SetConVar("tm_hud_font_death")
                        DeathUICustomFont:SetValue(true)
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

                        local KillFeedEditor = vgui.Create("DPanel", EditorScroller)
                        KillFeedEditor:Dock(TOP)
                        KillFeedEditor:SetSize(0, 215)
                        KillFeedEditor.Paint = function(self, w, h)
                            draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                            draw.SimpleText("KILL FEED", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                            draw.SimpleText("Enable Kill Feed", "Health", 55, 50, white, TEXT_ALIGN_LEFT)
                            draw.SimpleText("Feed Entry Style", "Health", 125, 85, white, TEXT_ALIGN_LEFT)
                            draw.SimpleText("Feed Item Limit", "Health", 150, 115, white, TEXT_ALIGN_LEFT)
                            draw.SimpleText("Feed X Offset", "Health", 150, 145, white, TEXT_ALIGN_LEFT)
                            draw.SimpleText("Feed Y Offset", "Health", 150, 175, white, TEXT_ALIGN_LEFT)
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
                        EnableKillFeed:SetValue(true)
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

                        local KillDeathEditor = vgui.Create("DPanel", EditorScroller)
                        KillDeathEditor:Dock(TOP)
                        KillDeathEditor:SetSize(0, 120)
                        KillDeathEditor.Paint = function(self, w, h)
                            draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                            draw.SimpleText("KILL/DEATH UI", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                            draw.SimpleText("UI X Offset", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                            draw.SimpleText("UI Y Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
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

                        local EditorButtons = vgui.Create("DPanel", EditorScroller)
                        EditorButtons:Dock(TOP)
                        EditorButtons:SetSize(0, 210)
                        EditorButtons.Paint = function(self, w, h)
                            draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                        end

                        local TestKillButton = vgui.Create("DButton", EditorButtons)
                        TestKillButton:SetPos(20, 0)
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
                            surface.PlaySound("tmui/buttonclick.wav")
                            RunConsoleCommand("tm_hud_testkill")
                        end

                        local TestDeathButton = vgui.Create("DButton", EditorButtons)
                        TestDeathButton:SetPos(20, 30)
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
                            surface.PlaySound("tmui/buttonclick.wav")
                            RunConsoleCommand("tm_hud_testdeath")
                        end

                        local TestLevelUpButton = vgui.Create("DButton", EditorButtons)
                        TestLevelUpButton:SetPos(20, 60)
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
                            surface.PlaySound("tmui/buttonclick.wav")
                            RunConsoleCommand("tm_hud_testlevelup")
                        end

                        local ExportProfileButton = vgui.Create("DButton", EditorButtons)
                        ExportProfileButton:SetPos(20, 105)
                        ExportProfileButton:SetText("")
                        ExportProfileButton:SetSize(300, 40)
                        local textAnim = 0
                        ExportProfileButton.Paint = function()
                            if ExportProfileButton:IsHovered() then
                                textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                            else
                                textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                            end
                            draw.DrawText("Export HUD Profile Code", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                        end
                        ExportProfileButton.DoClick = function()
                            surface.PlaySound("tmui/buttonclick.wav")
                        end

                        local ImportProfileButton = vgui.Create("DButton", EditorButtons)
                        ImportProfileButton:SetPos(20, 135)
                        ImportProfileButton:SetText("")
                        ImportProfileButton:SetSize(300, 40)
                        local textAnim = 0
                        ImportProfileButton.Paint = function()
                            if ImportProfileButton:IsHovered() then
                                textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                            else
                                textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                            end
                            draw.DrawText("Import HUD Profile Code", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                        end
                        ImportProfileButton.DoClick = function()
                            surface.PlaySound("tmui/buttonclick.wav")
                        end

                        local ResetToDefaultButton = vgui.Create("DButton", EditorButtons)
                        ResetToDefaultButton:SetPos(20, 165)
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
                    if GetConVar("tm_hitsoundtype"):GetInt() == 0 then hitSoundsType:SetValue("Rust") elseif GetConVar("tm_hitsoundtype"):GetInt() == 1 then hitSoundsType:SetValue("TABG") elseif GetConVar("tm_hitsoundtype"):GetInt() == 2 then hitSoundsType:SetValue("Bartol") end
                    hitSoundsType:AddChoice("Rust")
                    hitSoundsType:AddChoice("TABG")
                    hitSoundsType:AddChoice("Bartol")
                    hitSoundsType.OnSelect = function(self, value)
                        surface.PlaySound("hitsound/hit_" .. value - 1 .. ".wav")
                        RunConsoleCommand("tm_hitsoundtype", value - 1)
                    end

                    local killSoundsType = DockAudio:Add("DComboBox")
                    killSoundsType:SetPos(20, 190)
                    killSoundsType:SetSize(100, 30)
                    killSoundsType:SetTooltip("Adjust the style of the kill confirmation sound.")
                    if GetConVar("tm_killsoundtype"):GetInt() == 0 then killSoundsType:SetValue("Call Of Duty") elseif GetConVar("tm_killsoundtype"):GetInt() == 1 then killSoundsType:SetValue("TABG") end
                    killSoundsType:AddChoice("Call Of Duty")
                    killSoundsType:AddChoice("TABG")
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
                            menuMusic:Play()
                            menuMusic:ChangeVolume(GetConVar("tm_menumusicvolume"):GetFloat() / 4 * 1.45)
                        else
                            menuMusic:FadeOut(1)
                        end
                    end

                    local menuMusicVolume = DockAudio:Add("DNumSlider")
                    menuMusicVolume:SetPos(-85, 270)
                    menuMusicVolume:SetSize(250, 30)
                    menuMusicVolume:SetConVar("tm_menumusicvolume")
                    menuMusicVolume:SetMin(0)
                    menuMusicVolume:SetMax(1)
                    menuMusicVolume:SetDecimals(2)
                    menuMusicVolume:SetTooltip("Adjust the volume of the menu music.")

                    menuMusicVolume.OnValueChanged = function(self, value)
                        menuMusic:ChangeVolume(GetConVar("tm_menumusicvolume"):GetFloat() / 4 * 1.45)
                    end

                    DockWeaponry.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("WEAPONRY", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("VM FOV Multiplier", "SettingsLabel", 155, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Centered Gun", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Flashlight Color", "SettingsLabel", 245, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Reticle Color", "SettingsLabel", 245, 275, white, TEXT_ALIGN_LEFT)
                    end

                    local viewmodelFOV = DockWeaponry:Add("DNumSlider")
                    viewmodelFOV:SetPos(-85, 70)
                    viewmodelFOV:SetSize(250, 30)
                    viewmodelFOV:SetConVar("cl_tfa_viewmodel_multiplier_fov")
                    viewmodelFOV:SetMin(0.75)
                    viewmodelFOV:SetMax(2)
                    viewmodelFOV:SetDecimals(2)
                    viewmodelFOV:SetTooltip("Adjust the multiplier of your weapons FOV.")

                    local centeredVM = DockWeaponry:Add("DCheckBox")
                    centeredVM:SetPos(20, 110)
                    centeredVM:SetConVar("cl_tfa_viewmodel_centered")
                    centeredVM:SetSize(30, 30)
                    centeredVM:SetTooltip("Centeres your viewmodel towards the middle of your screen.")

                    local flashlightMixer = vgui.Create("DColorMixer", DockWeaponry)
                    flashlightMixer:SetPos(20, 150)
                    flashlightMixer:SetSize(215, 110)
                    flashlightMixer:SetConVarR("tpf_cl_color_red")
                    flashlightMixer:SetConVarG("tpf_cl_color_green")
                    flashlightMixer:SetConVarB("tpf_cl_color_blue")
                    flashlightMixer:SetAlphaBar(false)
                    flashlightMixer:SetPalette(false)
                    flashlightMixer:SetWangs(true)
                    flashlightMixer:SetTooltip("Change the color of your flashlight.")

                    local reticleMixer = vgui.Create("DColorMixer", DockWeaponry)
                    reticleMixer:SetPos(20, 280)
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
                    hitmarkerToggle:SetValue(true)
                    hitmarkerToggle:SetSize(30, 30)
                    hitmarkerToggle:SetTooltip("Enable hitmarkers (hit indication when you damage an enemy.)")

                    local hitmarkerDynamicToggle = DockHitmarker:Add("DCheckBox")
                    hitmarkerDynamicToggle:SetPos(20, 110)
                    hitmarkerDynamicToggle:SetConVar("cl_tfa_hud_hitmarker_3d_all")
                    hitmarkerDynamicToggle:SetValue(true)
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
                    end

                    local menuDOF = DockPerformance:Add("DCheckBox")
                    menuDOF:SetPos(20, 70)
                    menuDOF:SetConVar("tm_menudof")
                    menuDOF:SetValue(true)
                    menuDOF:SetSize(30, 30)
                    menuDOF:SetTooltip("Blurs the background of certain in game menus.")

                    local ironSightDOF = DockPerformance:Add("DCheckBox")
                    ironSightDOF:SetPos(20, 110)
                    ironSightDOF:SetConVar("cl_tfa_fx_ads_dof")
                    ironSightDOF:SetValue(true)
                    ironSightDOF:SetSize(30, 30)
                    ironSightDOF:SetTooltip("Blurs your weapon while aiming down sights.")

                    local inspectionDOF = DockPerformance:Add("DCheckBox")
                    inspectionDOF:SetPos(20, 150)
                    inspectionDOF:SetConVar("cl_tfa_inspection_bokeh")
                    inspectionDOF:SetValue(true)
                    inspectionDOF:SetSize(30, 30)
                    inspectionDOF:SetTooltip("Enables a blur affect while in the attachment editing menu.")

                    local vignetteDOF = DockPerformance:Add("DCheckBox")
                    vignetteDOF:SetPos(20, 190)
                    vignetteDOF:SetConVar("cl_aimingfx_enabled")
                    vignetteDOF:SetValue(true)
                    vignetteDOF:SetSize(30, 30)
                    vignetteDOF:SetTooltip("Darkens the corners of your screen while aiming down sights.")

                    local WipeAccountButton = vgui.Create("DButton", DockPerformance)
                    WipeAccountButton:SetPos(20, 270)
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

                        timer.Simple(3, function() wipeConfirm = 0 end)
                    end
                end
            end

            local ExitButton = vgui.Create("DButton", MainPanel)
            ExitButton:SetPos(0, ScrH() / 2 + 100)
            ExitButton:SetText("")
            ExitButton:SetSize(500, 100)
            local textAnim = 0
            local disconnectConfirm = 0
            ExitButton.Paint = function()
                if ExitButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                else
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                end
                if (disconnectConfirm == 0) then
                    draw.DrawText("EXIT GAME", "AmmoCountSmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
                else
                    draw.DrawText("CONFIRM?", "AmmoCountSmall", 5 + textAnim, 5, Color(255, 0, 0), TEXT_ALIGN_LEFT)
                end
            end
            ExitButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                if (disconnectConfirm == 0) then
                    disconnectConfirm = 1
                else
                    RunConsoleCommand("disconnect")
                end

                timer.Simple(3, function() disconnectConfirm = 0 end)
            end

            local PatchNotesButtonHolder = vgui.Create("DPanel", MainPanel)
            PatchNotesButtonHolder:SetPos(ScrW() - 49, ScrH() / 2 - 28)
            PatchNotesButtonHolder:SetSize(48, 48)
            PatchNotesButtonHolder.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, transparent)
            end

            local PlayerList
            local PatchNotesButton = vgui.Create("DImageButton", PatchNotesButtonHolder)
            PatchNotesButton:SetImage("icons/patchnotesicon.png")
            patchNotesAnim = 0
            patchNotesOpen = 0
            local buttonSize = 32
            PatchNotesButton.DoClick = function()
                surface.PlaySound("tmui/buttonclick.wav")
                if (patchNotesOpen == 0) then
                    patchNotesOpen = 1
                else
                    patchNotesOpen = 0
                end
            end
            PatchNotesButton.Paint = function(self, w, h)
                if PatchNotesButton:IsHovered() then
                    buttonSize = math.Clamp(buttonSize + 200 * FrameTime(), 0, 12)
                else
                    buttonSize = math.Clamp(buttonSize - 200 * FrameTime(), 0, 12)
                end
                if (patchNotesOpen == 1) then
                    patchNotesAnim = math.Clamp(patchNotesAnim + 4000 * FrameTime(), 0, 400)
                else
                    patchNotesAnim = math.Clamp(patchNotesAnim - 4000 * FrameTime(), 0, 400)
                end
                PatchNotesButton:SetSize(32 + buttonSize, 32 + buttonSize)
                PatchNotesButton:Center()
                PatchNotesButtonHolder:SetPos(ScrW() - 48 - patchNotesAnim, ScrH() / 2 - 28)
            end

            local PatchNotesPanel = vgui.Create("DPanel", MainPanel)
            PatchNotesPanel:SetSize(420, 450)
            PatchNotesPanel:SetPos(ScrW() - 1, ScrH() / 2 - 225)
            PatchNotesPanel.Paint = function(self, w, h)
                PatchNotesPanel:SetPos(ScrW() - 1 - patchNotesAnim, ScrH() / 2 - 225)
                draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 0))
            end

            local PatchScroller = vgui.Create("DScrollPanel", PatchNotesPanel)
            PatchScroller:Dock(FILL)

            local PlayersTextHeader = vgui.Create("DPanel", PatchScroller)
            PlayersTextHeader:Dock(TOP)
            PlayersTextHeader:SetSize(0, 65)
            PlayersTextHeader.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, lightGray)
                draw.SimpleText("PLAYERS", "OptionsHeader", 3, 0, white, TEXT_ALIGN_LEFT)
            end

            local PlayerScrollPanel = vgui.Create("DScrollPanel", PatchScroller)
            PlayerScrollPanel:Dock(TOP)
            PlayerScrollPanel:SetSize(PatchNotesPanel:GetWide(), 100 * player.GetCount())
            PlayerScrollPanel:SetPos(0, 0)

            PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
            PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
            PlayerList:SetPos(0, 0)

            PlayerList:Clear()
            local connectedPlayers = player.GetAll()
            table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end)
            for k, v in pairs(connectedPlayers) do
                local PlayerPanel = vgui.Create("DPanel", PlayerList)
                PlayerPanel:SetSize(PlayerList:GetWide(), 100)
                PlayerPanel:SetPos(0, 0)
                local name = v:GetName()
                local prestige = v:GetNWInt("playerPrestige")
                local level = v:GetNWInt("playerLevel")
                PlayerPanel.Paint = function(self, w, h)
                    if not IsValid(v) then return end
                    if v:GetNWBool("mainmenu") == true then
                        draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 100, 100))
                    elseif not v:Alive() then
                        draw.RoundedBox(0, 0, 0, w, h, Color(100, 35, 35, 100))
                    else
                        draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 100))
                    end

                    draw.SimpleText(name, "StreakText", 255, 5, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("P" .. prestige .. " L" .. level, "Health", 255, 25, white, TEXT_ALIGN_LEFT)
                end

                --Displays a players calling card and profile picture.
                local PlayerCallingCard = vgui.Create("DImageButton", PlayerPanel)
                PlayerCallingCard:SetPos(10, 10)
                PlayerCallingCard:SetSize(240, 80)

                if IsValid(v) then PlayerCallingCard:SetImage(v:GetNWString("chosenPlayercard"), "cards/color/black.png") end

                local PlayerProfilePicture = vgui.Create("AvatarImage", PlayerCallingCard)
                PlayerProfilePicture:SetPos(5, 5)
                PlayerProfilePicture:SetSize(70, 70)
                PlayerProfilePicture:SetPlayer(v, 184)
            end

            local PatchTextHeader = vgui.Create("DPanel", PatchScroller)
            PatchTextHeader:Dock(TOP)
            PatchTextHeader:SetSize(0, 65)
            PatchTextHeader.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, lightGray)
                draw.SimpleText("PATCH NOTES", "OptionsHeader", 3, 0, white, TEXT_ALIGN_LEFT)
            end

            local PatchPreRelease2 = vgui.Create("DPanel", PatchScroller)
            PatchPreRelease2:Dock(TOP)
            PatchPreRelease2:SetSize(0, 390)
            PatchPreRelease2.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, gray)
                draw.SimpleText("Pre Release 2", "OptionsHeader", 3, 0, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("01/23/22", "Health", 5, 50, white, TEXT_ALIGN_LEFT)

                draw.SimpleText("+ Drastic gunplay refinments", "StreakText", 5, 80, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ HK53 primary weapon", "StreakText", 5, 100, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ SIG P320 secondary weapon", "StreakText", 5, 120, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Rebalancing across all weapons", "StreakText", 5, 140, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Multiple weapon revamps/remodels", "StreakText", 5, 160, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ More trackable statistics", "StreakText", 5, 180, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Weapon kill tracking HUD option", "StreakText", 5, 200, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Scoreboard improvments", "StreakText", 5, 220, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Moved many systems to net messages", "StreakText", 5, 240, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Config option to disable map vote skip", "StreakText", 5, 260, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Map framework changes", "StreakText", 5, 280, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed bugs introduced with new gmod update", "StreakText", 5, 300, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Updated credit entries", "StreakText", 5, 320, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("- Galil primary weapon", "StreakText", 5, 340, patchRed, TEXT_ALIGN_LEFT)
                draw.SimpleText("- SIG P260 secondary weapon", "StreakText", 5, 360, patchRed, TEXT_ALIGN_LEFT)
            end

            local PatchPreRelease = vgui.Create("DPanel", PatchScroller)
            PatchPreRelease:Dock(TOP)
            PatchPreRelease:SetSize(0, 1390)
            PatchPreRelease.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, gray)
                draw.SimpleText("Pre Release", "OptionsHeader", 3, 0, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("12/05/22", "Health", 5, 50, white, TEXT_ALIGN_LEFT)

                draw.SimpleText("+ G28, G36A1, Dual Skorpions, AK-12,", "StreakText", 5, 80, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ and M4A1 primary weapons", "StreakText", 5, 100, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Skorpion secondary weapon", "StreakText", 5, 120, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ File Compression", "StreakText", 5, 140, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Option tooltips", "StreakText", 5, 160, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Account and Privacy options", "StreakText", 5, 180, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Credits menu", "StreakText", 5, 200, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Level 200-300 and Pride Player Cards", "StreakText", 5, 220, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Config File", "StreakText", 5, 240, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Killstrak notifications in kill feed", "StreakText", 5, 260, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Hints", "StreakText", 5, 280, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Loadout Hints option", "StreakText", 5, 300, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Match tracking", "StreakText", 5, 320, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Match win XP bonus", "StreakText", 5, 340, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ HUD Editing and recoloring", "StreakText", 5, 360, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Custom font support", "StreakText", 5, 380, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Hide locked option in cuztomization menus", "StreakText", 5, 400, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Clan tags", "StreakText", 5, 420, patchGreen, TEXT_ALIGN_LEFT)
                draw.SimpleText("   New UI animations", "StreakText", 5, 440, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   More UI SFX", "StreakText", 5, 460, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Optimized UI", "StreakText", 5, 480, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Optimized score calculation", "StreakText", 5, 500, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Optimized kill cams", "StreakText", 5, 520, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Optimized player leveling", "StreakText", 5, 540, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Optimized arrays", "StreakText", 5, 560, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed incorrect score distribution", "StreakText", 5, 580, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Removed BETA patch notes", "StreakText", 5, 600, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Faster loading on model and card menus", "StreakText", 5, 620, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed overlapping menu SFX", "StreakText", 5, 640, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Added DOF for main menu and scoreboard", "StreakText", 5, 660, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Primaries no longer fire underwater", "StreakText", 5, 680, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Secondaries and melee now fire underwater", "StreakText", 5, 700, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Buffed Mac 10, Beretta Mx4, MP7", "StreakText", 5, 720, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Nerfed AKS-74U, Imbel IA2, SCAR-H", "StreakText", 5, 740, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Updated many weapon names", "StreakText", 5, 760, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Smoothened level up animation", "StreakText", 5, 780, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Lowered volume of level up SFX", "StreakText", 5, 800, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Improved statistics menu", "StreakText", 5, 820, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Improved map voting algorithm", "StreakText", 5, 840, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed death cooldown check every frame", "StreakText", 5, 860, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed manually voting on unvotable maps", "StreakText", 5, 880, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Added errors during manual map voting", "StreakText", 5, 900, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Added caliber information for weapons", "StreakText", 5, 920, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Removed unused weapon files", "StreakText", 5, 940, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Removed hooks that run exclusively in Sandbox", "StreakText", 5, 960, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Kill/Death UI now scale properly", "StreakText", 5, 980, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Smooth scrolling across all UI", "StreakText", 5, 1000, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Updated and improved ASh-12", "StreakText", 5, 1020, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed ammo bar being 1 pixel too high", "StreakText", 5, 1040, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed ammo bar text while using melee", "StreakText", 5, 1060, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed UI elements when player disconnects", "StreakText", 5, 1080, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed desync related to kill info and streaks", "StreakText", 5, 1100, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("- WA-2000, H&K MG36, AK-12 RPK,", "StreakText", 5, 1120, patchRed, TEXT_ALIGN_LEFT)
                draw.SimpleText("- and AR-15 primary weapons", "StreakText", 5, 1140, patchRed, TEXT_ALIGN_LEFT)
                draw.SimpleText("- Groves and Rooftops maps", "StreakText", 5, 1160, patchRed, TEXT_ALIGN_LEFT)
                draw.SimpleText("- Revenge accolade", "StreakText", 5, 1180, patchRed, TEXT_ALIGN_LEFT)
                draw.SimpleText("- Lee-Enfield stripper clip attachment", "StreakText", 5, 1200, patchRed, TEXT_ALIGN_LEFT)
                draw.SimpleText("- Profile picture offset option", "StreakText", 5, 1220, patchRed, TEXT_ALIGN_LEFT)

                draw.SimpleText("Thanks for playing my shitty gamemode, I never", "StreakText", 5, 1260, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("thought it would end up as a finished product :)", "StreakText", 5, 1280, white, TEXT_ALIGN_LEFT)

                draw.SimpleText("Special thanks to all the testers, their names can", "StreakText", 5, 1320, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("found in the credits. ", "StreakText", 5, 1340, white, TEXT_ALIGN_LEFT)
                draw.SimpleText("-penial <3", "StreakText", 5, 1360, white, TEXT_ALIGN_LEFT)
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
vgui.Register("StatsSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(780, ScrH())
    self:SetPos(56, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("StatsPanel", PANEL, "Panel")

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