local MainMenu

function mainMenu()
    local client = LocalPlayer()
    local chosenMusic
    local musicName
    local musicList
    local requestedBy

    if ScrW() < 1024 and ScrH() < 768 then
        belowMinimumRes = true
    else
        belowMinimumRes = false
    end

    if CLIENT and GetConVar("tm_communitymusic"):GetInt() == 0 then
        musicList = {"music/sicktwisteddemented_sewerslvt.wav"}
        chosenMusic = (musicList[math.random(#musicList)])
    else
        musicList = {"music/sicktwisteddemented_sewerslvt.wav", "music/takecare_ultrakillost.wav", "music/immaculate_visage.wav", "music/tabgmenumusic.wav", "music/altarsofapostasy_ultrakillost.wav", "music/sneakysnitch_kevinmacleod.wav"}
        chosenMusic = (musicList[math.random(#musicList)])
    end

    local menuMusic = CreateSound(client, chosenMusic)

    if chosenMusic == "music/sicktwisteddemented_sewerslvt.wav" then
        musicName = "sick, twisted, demented - Sewerslvt"
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

    if chosenMusic == "music/altarsofapostasy_ultrakillost.wav" then
        musicName = "Altars of Apostasy - Ultrakill OST"
        requestedBy = "Checked"
        steamProfile = "https://steamcommunity.com/profiles/76561198853717083"
    end

    if chosenMusic == "music/sneakysnitch_kevinmacleod.wav" then
        musicName = "Sneaky Snitch - Kevin MacLeod"
        requestedBy = "Checked"
        steamProfile = "https://steamcommunity.com/profiles/76561198853717083"
    end

    musicVolume = GetConVar("tm_menumusicvolume"):GetInt() / 4

    if CLIENT and GetConVar("tm_menumusic"):GetInt() == 1 then
        menuMusic:Play()
        menuMusic:ChangeVolume(musicVolume * 1.2)
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

        MainMenu.Paint = function()
            surface.SetDrawColor(40, 40, 40, 200)
            surface.DrawRect(0, 0, MainMenu:GetWide(), MainMenu:GetTall())
        end

        gui.EnableScreenClicker(true)

        local MainPanel = MainMenu:Add("MainPanel")
            MainPanel.Paint = function()
                if CLIENT and GetConVar("tm_menumusic"):GetInt() == 1 then
                    draw.SimpleText("Listening to: " .. musicName, "MainMenuMusicName", ScrW() - 5, 5, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                    if requestedBy ~= nil then
                        draw.SimpleText("Requested by " .. requestedBy, "MainMenuMusicName", ScrW() - 5, 30, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                    end
                else
                    draw.SimpleText("Listening to nothing, peace and quiet :)", "MainMenuMusicName", ScrW() - 5, 5, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                end
            end

            if requestedBy ~= nil and CLIENT and GetConVar("tm_menumusic"):GetInt() == 1 then
                local ProfileButton = vgui.Create("DImageButton", MainPanel)
                ProfileButton:SetPos(ScrW() - 53, 60)
                ProfileButton:SetSize(48, 48)
                ProfileButton:SetImage("icons/steamicon.png")
                ProfileButton.DoClick = function()
                    gui.OpenURL(steamProfile)
                end
            end

            CallingCard = vgui.Create("DImage", MainPanel)
            CallingCard:SetPos(100, 10)
            CallingCard:SetSize(240, 80)
            CallingCard:SetImage(LocalPlayer():GetNWString("chosenPlayercard"))

            playerProfilePicture = vgui.Create("AvatarImage", MainPanel)
            playerProfilePicture:SetPos(105, 15)
            playerProfilePicture:SetSize(70, 70)
            playerProfilePicture:SetPlayer(LocalPlayer(), 184)

            local StatisticsButton = vgui.Create("DImageButton", MainPanel)
            StatisticsButton:SetPos(10, 10)
            StatisticsButton:SetImage("icons/statsicon.png")
            StatisticsButton:SetSize(80, 80)
            StatisticsButton.DoClick = function()
                MainPanel:Hide()

                if not IsValid(StatisticsPanel) then
                    local StatisticsPanel = MainMenu:Add("StatsPanel")

                    local StatsScroller = vgui.Create("DScrollPanel", StatisticsPanel)
                    StatsScroller:Dock(FILL)

                    local StatsTextHolder = vgui.Create("DPanel", StatsScroller)
                    StatsTextHolder:Dock(TOP)
                    StatsTextHolder:SetSize(0, 150)

                    StatsTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("STATISTICS", "AmmoCountSmall", 20, 20, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("View your lifetime stats.", "PlayerNotiName", 20, 100, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local StatsCombat = vgui.Create("DPanel", StatsScroller)
                    StatsCombat:Dock(TOP)
                    StatsCombat:SetSize(0, 260)

                    local StatsAccolades = vgui.Create("DPanel", StatsScroller)
                    StatsAccolades:Dock(TOP)
                    StatsAccolades:SetSize(0, 330)

                    local StatsWeapons = vgui.Create("DPanel", StatsScroller)
                    StatsWeapons:Dock(TOP)
                    StatsWeapons:SetSize(0, 4250)

                    local trackingPlayer = LocalPlayer()

                    StatsCombat.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("COMBAT", "OptionsHeader", 20, 20, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Total Score:", "SettingsLabel", 20, 80, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerScore"), "SettingsLabel", 500, 80, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Total Player Kills:", "SettingsLabel", 20, 115, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerKills"), "SettingsLabel", 500, 115, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Total Deaths:", "SettingsLabel", 20, 150, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerDeaths"), "SettingsLabel", 500, 150, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("K/D Ratio:", "SettingsLabel", 20, 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerKDR"), "SettingsLabel", 500, 185, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Highest Player Killstreak:", "SettingsLabel", 20, 220, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("highestKillStreak"), "SettingsLabel", 500, 220, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                    end

                    StatsAccolades.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("ACCOLADES", "OptionsHeader", 20, 20, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Headshot Kills:", "SettingsLabel", 20, 80, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeHeadshot"), "SettingsLabel", 500, 80, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Melee Kills (Smackdowns):", "SettingsLabel", 20, 115, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeSmackdown"), "SettingsLabel", 500, 115, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Clutches (Kills with <15HP):", "SettingsLabel", 20, 150, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeClutch"), "SettingsLabel", 500, 150, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Longshot Kills:", "SettingsLabel", 20, 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeLongshot"), "SettingsLabel", 500, 185, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Point Blank Kills:", "SettingsLabel", 20, 220, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladePointblank"), "SettingsLabel", 500, 220, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Killstreaks Started:", "SettingsLabel", 20, 255, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeOnStreak"), "SettingsLabel", 500, 255, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Killstreaks Ended:", "SettingsLabel", 20, 290, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeBuzzkill"), "SettingsLabel", 500, 290, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                    end

                    StatsWeapons.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("WEAPONS", "OptionsHeader", 20, 20, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        for k, v in pairs(weaponsArr) do
                            draw.SimpleText(v[2] .. " Kills: ", "SettingsLabel", 20, 80 + ((k - 1) * 35), Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                            draw.SimpleText("0", "SettingsLabel", 500, 80 + ((k - 1) * 35), Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                        end
                    end

                    local DockBackButton = vgui.Create("DPanel", StatsScroller)
                    DockBackButton:Dock(TOP)
                    DockBackButton:SetSize(0, 100)

                    DockBackButton.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    local BackButton = vgui.Create("DImageButton", DockBackButton)
                    BackButton:SetPos(0, 0)
                    BackButton:SetImage("mainmenu/backbutton.png")
                    BackButton:SizeToContents()
                    BackButton.DoClick = function()
                        MainPanel:Show()
                        StatisticsPanel:Hide()
                    end
                end
            end

            local WorkshopButton = vgui.Create("DImageButton", MainPanel)
            WorkshopButton:SetPos(8, ScrH() - 72)
            WorkshopButton:SetImage("icons/workshopicon.png")
            WorkshopButton:SetSize(64, 64)
            WorkshopButton.DoClick = function()
                gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2863062354")
            end

            local YouTubeButton = vgui.Create("DImageButton", MainPanel)
            YouTubeButton:SetPos(80, ScrH() - 72)
            YouTubeButton:SetImage("icons/youtubeicon.png")
            YouTubeButton:SetSize(64, 64)
            YouTubeButton.DoClick = function()
                gui.OpenURL("https://www.youtube.com/channel/UC1aCX3i4L6TyEv_rmo_HeR")
            end

            local ServerButton = vgui.Create("DImageButton", MainPanel)
            ServerButton:SetPos(152, ScrH() - 72)
            ServerButton:SetImage("icons/discordicon.png")
            ServerButton:SetSize(64, 64)
            ServerButton.DoClick = function()
                gui.OpenURL("https://discord.gg/landfall")
            end

            local GithubButton = vgui.Create("DImageButton", MainPanel)
            GithubButton:SetPos(224, ScrH() - 72)
            GithubButton:SetImage("icons/githubicon.png")
            GithubButton:SetSize(64, 64)
            GithubButton.DoClick = function()
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

                draw.DrawText("SPAWN", "AmmoCountSmall", 5 + textAnim, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                for k, v in pairs(weaponsArr) do
                    if v[1] == LocalPlayer():GetNWInt("loadoutPrimary") then
                        draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + textAnim, 15, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end
                    if v[1] == LocalPlayer():GetNWInt("loadoutSecondary") then
                        draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + textAnim, 40 , Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end
                    if v[1] == LocalPlayer():GetNWInt("loadoutMelee") then
                        draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + textAnim, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end
                end
            end
            SpawnButton.DoClick = function()
                MainMenu:Remove(false)
                gui.EnableScreenClicker(false)

                menuMusic:FadeOut(2)

                LocalPlayer():ConCommand("tm_closemainmenu")
                LocalPlayer():Spawn()
            end

            local CustomizeButton = vgui.Create("DButton", MainPanel)
            CustomizeButton:SetPos(0, ScrH() / 2 - 100)
            CustomizeButton:SetText("")
            CustomizeButton:SetSize(530, 100)
            local textAnim = 0
            CustomizeButton.Paint = function()
                if CustomizeButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
                else
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                end
                draw.DrawText("CUSTOMIZE", "AmmoCountSmall", 5 + textAnim, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            end
            CustomizeButton.DoClick = function()
                MainPanel:Hide()

                local previewModel = LocalPlayer():GetNWString("chosenPlayermodel")

                if not IsValid(CustomizePanel) then
                    local CustomizePanel = MainMenu:Add("CustomizePanel")

                    local newModel
                    local newModelName
                    local newModelDesc
                    local newModelUnlockType
                    local newModelUnlockValue

                    local CustomizeScroller = vgui.Create("DScrollPanel", CustomizePanel)
                    CustomizeScroller:Dock(FILL)

                    local CustomizeTextHolder = vgui.Create("DPanel", CustomizeScroller)
                    CustomizeTextHolder:Dock(TOP)
                    CustomizeTextHolder:SetSize(0, 200)

                    CustomizeTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("CUSTOMIZE", "AmmoCountSmall", 20, 20, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Personalize yourself.", "PlayerNotiName", 20, 130, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    --Default Playermodels
                    local TextDefault = vgui.Create("DPanel", CustomizeScroller)
                    TextDefault:Dock(TOP)
                    TextDefault:SetSize(0, 60)

                    local DockModels = vgui.Create("DPanel", CustomizeScroller)
                    DockModels:Dock(TOP)
                    DockModels:SetSize(0, 600   )

                    --Kills Playermodels
                    local TextKills = vgui.Create("DPanel", CustomizeScroller)
                    TextKills:Dock(TOP)
                    TextKills:SetSize(0, 60)

                    local DockModelsKills = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsKills:Dock(TOP)
                    DockModelsKills:SetSize(0, 400)

                    --Streak Playermodels
                    local TextStreak = vgui.Create("DPanel", CustomizeScroller)
                    TextStreak:Dock(TOP)
                    TextStreak:SetSize(0, 60)

                    local DockModelsStreak = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsStreak:Dock(TOP)
                    DockModelsStreak:SetSize(0, 400)

                    --Special Playermodels
                    local TextSpecial = vgui.Create("DPanel", CustomizeScroller)
                    TextSpecial:Dock(TOP)
                    TextSpecial:SetSize(0, 60)

                    local DockModelsSpecial = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsSpecial:Dock(TOP)
                    DockModelsSpecial:SetSize(0, 217)

                    --Creating playermodel lists
                    local DefaultModelList = vgui.Create("DIconLayout", DockModels)
                    DefaultModelList:Dock(TOP)
                    DefaultModelList:SetSpaceY(17)
                    DefaultModelList:SetSpaceX(17)

                    DefaultModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    local KillsModelList = vgui.Create("DIconLayout", DockModelsKills)
                    KillsModelList:Dock(TOP)
                    KillsModelList:SetSpaceY(17)
                    KillsModelList:SetSpaceX(17)

                    KillsModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    local StreakModelList = vgui.Create("DIconLayout", DockModelsStreak)
                    StreakModelList:Dock(TOP)
                    StreakModelList:SetSpaceY(17)
                    StreakModelList:SetSpaceX(17)

                    StreakModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    local SpecialModelList = vgui.Create("DIconLayout", DockModelsSpecial)
                    SpecialModelList:Dock(TOP)
                    SpecialModelList:SetSpaceY(17)
                    SpecialModelList:SetSpaceX(17)

                    SpecialModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    local PreviewPanel = MainMenu:Add("CustomizePreviewPanel")

                    local PreviewScroller = vgui.Create("DScrollPanel", PreviewPanel)
                    PreviewScroller:Dock(FILL)

                    local PreviewTextHolder = vgui.Create("DPanel", PreviewScroller)
                    PreviewTextHolder:Dock(TOP)
                    PreviewTextHolder:SetSize(0, 100)

                    PreviewTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Current playermodel:", "Health", w / 2, 20, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                    end

                    local PreviewModelHolder = vgui.Create("DPanel", PreviewScroller)
                    PreviewModelHolder:Dock(TOP)
                    PreviewModelHolder:SetSize(0, 320)

                    PreviewModelHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    local NewModelTextHolder = vgui.Create("DPanel", PreviewScroller)
                    NewModelTextHolder:Dock(TOP)
                    NewModelTextHolder:SetSize(0, 160)

                    NewModelTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))

                        if newModel ~= nil then
                            draw.SimpleText("Selected playermodel:", "Health", w / 2, 20, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                            draw.SimpleText(newModelName, "PlayerNotiName", w / 2, 50, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                            draw.SimpleText(newModelDesc, "Health", w / 2, 100, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        end

                        if newModelUnlockType == "default" then
                            draw.SimpleText("Unlocked", "Health", w / 2, 130, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                        end

                        if newModelUnlockType == "kills" then
                            if LocalPlayer():GetNWInt("playerKills") < newModelUnlockValue then
                                draw.SimpleText("Total Kills: " .. LocalPlayer():GetNWInt("playerKills") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Total Kills: " .. LocalPlayer():GetNWInt("playerKills") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "streak" then
                            if LocalPlayer():GetNWInt("highestKillStreak") < newModelUnlockValue then
                                draw.SimpleText("Longest Kill Streak: " .. LocalPlayer():GetNWInt("highestKillStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Longest Kill Streak: " .. LocalPlayer():GetNWInt("highestKillStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "special" then
                            if LocalPlayer():SteamID() == "STEAM_0:1:514443768" then
                                draw.SimpleText("Unlocked", "Health", w / 2, 130, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("[CLASSIFIED]", "Health", w / 2, 130, Color(0, 0, 250, 255), TEXT_ALIGN_CENTER)
                            end
                        end
                    end

                    local PlayerModelDisplay = vgui.Create("DModelPanel", PreviewModelHolder)
                    PlayerModelDisplay:SetSize(400, 400)
                    PlayerModelDisplay:SetPos(0, -50)
                    PlayerModelDisplay:SetModel(previewModel)

                    local SelectedModelHolder = vgui.Create("DPanel", PreviewScroller)
                    SelectedModelHolder:Dock(TOP)
                    SelectedModelHolder:SetSize(0, 400)

                    SelectedModelHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    local DockBackButton = vgui.Create("DPanel", CustomizeScroller)
                    DockBackButton:Dock(TOP)
                    DockBackButton:SetSize(0, 100)

                    DockBackButton.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    local SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                    selectedModelShown = false

                    for k, v in pairs(modelArr) do
                        if v[4] == "default" then
                            local icon = vgui.Create("SpawnIcon", DockModels)
                            icon:SetModel(v[1])
                            icon:SetTooltip(v[2] .. "\n" .. v[3])
                            icon:SetSize(183, 183)
                            DefaultModelList:Add(icon)

                            icon.DoClick = function(icon)
                                newModel = v[1]
                                newModelName = v[2]
                                newModelDesc = v[3]
                                newModelUnlockType = v[4]
                                newModelUnlockValue = v[5]

                                if selectedModelShown == true then
                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(400, 400)
                                    SelectedModelDisplay:SetPos(0, -25)
                                    SelectedModelDisplay:SetModel(newModel)
                                else
                                    SelectedModelDisplay:SetSize(400, 400)
                                    SelectedModelDisplay:SetPos(0, -25)
                                    SelectedModelDisplay:SetModel(newModel)
                                    selectedModelShown = true
                                end
                            end
                        end

                        if v[4] == "kills" then
                            local icon = vgui.Create("SpawnIcon", DockModelsKills)
                            icon:SetModel(v[1])
                            icon:SetTooltip(v[2] .. "\n" .. v[3])
                            icon:SetSize(183, 183)
                            KillsModelList:Add(icon)

                            icon.DoClick = function(icon)
                                newModel = v[1]
                                newModelName = v[2]
                                newModelDesc = v[3]
                                newModelUnlockType = v[4]
                                newModelUnlockValue = v[5]

                                if selectedModelShown == true then
                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(400, 400)
                                    SelectedModelDisplay:SetPos(0, -25)
                                    SelectedModelDisplay:SetModel(newModel)
                                else
                                    SelectedModelDisplay:SetSize(400, 400)
                                    SelectedModelDisplay:SetPos(0, -25)
                                    SelectedModelDisplay:SetModel(newModel)
                                    selectedModelShown = true
                                end
                            end
                        end

                        if v[4] == "streak" then
                            local icon = vgui.Create("SpawnIcon", DockModelsStreak)
                            icon:SetModel(v[1])
                            icon:SetTooltip(v[2] .. "\n" .. v[3])
                            icon:SetSize(183, 183)
                            StreakModelList:Add(icon)

                            icon.DoClick = function(icon)
                                newModel = v[1]
                                newModelName = v[2]
                                newModelDesc = v[3]
                                newModelUnlockType = v[4]
                                newModelUnlockValue = v[5]

                                if selectedModelShown == true then
                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(400, 400)
                                    SelectedModelDisplay:SetPos(0, -25)
                                    SelectedModelDisplay:SetModel(newModel)
                                else
                                    SelectedModelDisplay:SetSize(400, 400)
                                    SelectedModelDisplay:SetPos(0, -25)
                                    SelectedModelDisplay:SetModel(newModel)
                                    selectedModelShown = true
                                end
                            end
                        end

                        if v[4] == "special" then
                            local icon = vgui.Create("SpawnIcon", DockModelsSpecial)
                            icon:SetModel(v[1])
                            icon:SetTooltip(v[2] .. "\n" .. v[3])
                            icon:SetSize(183, 183)
                            SpecialModelList:Add(icon)

                            icon.DoClick = function(icon)
                                newModel = v[1]
                                newModelName = v[2]
                                newModelDesc = v[3]
                                newModelUnlockType = v[4]
                                newModelUnlockValue = v[5]

                                if selectedModelShown == true then
                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(400, 400)
                                    SelectedModelDisplay:SetPos(0, -25)
                                    SelectedModelDisplay:SetModel(newModel)
                                else
                                    SelectedModelDisplay:SetSize(400, 400)
                                    SelectedModelDisplay:SetPos(0, -25)
                                    SelectedModelDisplay:SetModel(newModel)
                                    selectedModelShown = true
                                end
                            end
                        end
                    end

                    TextDefault.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Default", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    TextKills.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Kills", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    TextStreak.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Streaks", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    TextSpecial.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Special", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    DockModels.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    DockModelsKills.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    DockModelsStreak.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    DockModelsSpecial.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    local ApplyButtonHolder = vgui.Create("DPanel", PreviewScroller)
                    ApplyButtonHolder:Dock(TOP)
                    ApplyButtonHolder:SetSize(0, 100)

                    ApplyButtonHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 80, 50, 200))
                    end

                    local ApplyModelButton = vgui.Create( "DButton", ApplyButtonHolder )
                    ApplyModelButton:SetText("APPLY NEW PLAYERMODEL")
                    ApplyModelButton:SetPos(25, 25)
                    ApplyModelButton:SetSize(350, 50)
                    ApplyModelButton.DoClick = function()
                        if newModelUnlockType == "default" then
                            surface.PlaySound("common/wpn_select.wav")
                            RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                            MainPanel:Show()
                            CustomizePanel:Hide()
                            PreviewPanel:Hide()
                        end

                        if newModelUnlockType == "kills" then
                            if LocalPlayer():GetNWInt("playerKills") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        end

                        if newModelUnlockType == "streak" then
                            if LocalPlayer():GetNWInt("highestKillStreak") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        end

                        if newModelUnlockType == "special" then
                            if LocalPlayer():SteamID() == "STEAM_0:1:514443768" then
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            else
                                surface.PlaySound("common/wpn_denyselect.wav")
                            end
                        end
                    end

                    local BackButton = vgui.Create("DImageButton", DockBackButton)
                    BackButton:SetPos(0, 0)
                    BackButton:SetImage("mainmenu/backbutton.png")
                    BackButton:SizeToContents()
                    BackButton.DoClick = function()
                        MainPanel:Show()
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
                draw.DrawText("OPTIONS", "AmmoCountSmall", 5 + textAnim, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            end
            OptionsButton.DoClick = function()
                MainPanel:Hide()

                if not IsValid(OptionsPanel) then
                    local OptionsPanel = MainMenu:Add("OptionsPanel")

                    local OptionsScroller = vgui.Create("DScrollPanel", OptionsPanel)
                    OptionsScroller:Dock(FILL)

                    local OptionsTextHolder = vgui.Create("DPanel", OptionsScroller)
                    OptionsTextHolder:Dock(TOP)
                    OptionsTextHolder:SetSize(0, 200)

                    OptionsTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("OPTIONS", "AmmoCount", 20, 20, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Tweak your experience.", "PlayerNotiName", 20, 130, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local DockInputs = vgui.Create("DPanel", OptionsScroller)
                    DockInputs:Dock(TOP)
                    DockInputs:SetSize(0, 200)

                    local DockUI = vgui.Create("DPanel", OptionsScroller)
                    DockUI:Dock(TOP)
                    DockUI:SetSize(0, 520)

                    local DockAudio = vgui.Create("DPanel", OptionsScroller)
                    DockAudio:Dock(TOP)
                    DockAudio:SetSize(0, 240)

                    local DockViewmodel = vgui.Create("DPanel", OptionsScroller)
                    DockViewmodel:Dock(TOP)
                    DockViewmodel:SetSize(0, 240)

                    local DockCrosshair = vgui.Create("DPanel", OptionsScroller)
                    DockCrosshair:Dock(TOP)
                    DockCrosshair:SetSize(0, 675)

                    local DockHitmarker = vgui.Create("DPanel", OptionsScroller)
                    DockHitmarker:Dock(TOP)
                    DockHitmarker:SetSize(0, 315)

                    local DockScopes = vgui.Create("DPanel", OptionsScroller)
                    DockScopes:Dock(TOP)
                    DockScopes:SetSize(0, 245)

                    local DockPerformance = vgui.Create("DPanel", OptionsScroller)
                    DockPerformance:Dock(TOP)
                    DockPerformance:SetSize(0, 330)

                    local DockBackButton = vgui.Create("DPanel", OptionsScroller)
                    DockBackButton:Dock(TOP)
                    DockBackButton:SetSize(0, 100)

                    local BackButton = vgui.Create("DImageButton", DockBackButton)
                    BackButton:SetPos(0, 0)
                    BackButton:SetImage("mainmenu/backbutton.png")
                    BackButton:SizeToContents()
                    BackButton.DoClick = function()
                        MainPanel:Show()
                        OptionsPanel:Hide()
                    end

                    DockInputs.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("INPUTS", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("ADS Sensitivity", "SettingsLabel", 155, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Toggle ADS", "SettingsLabel", 55, 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Grappling Hook Keybind", "SettingsLabel", 135, 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local adsSensitivity = DockInputs:Add("DNumSlider")
                    adsSensitivity:SetPos(-85, 70)
                    adsSensitivity:SetSize(250, 30)
                    adsSensitivity:SetConVar("cl_tfa_scope_sensitivity")
                    adsSensitivity:SetMin(0)
                    adsSensitivity:SetMax(100)
                    adsSensitivity:SetDecimals(0)

                    local ironsToggle = DockInputs:Add("DCheckBox")
                    ironsToggle:SetPos(20, 110)
                    ironsToggle:SetConVar("cl_tfa_ironsights_toggle")
                    ironsToggle:SetValue(true)
                    ironsToggle:SetSize(30, 30)

                    local grappleBind = DockInputs:Add("DBinder")
                    grappleBind:SetPos(22.5, 150)
                    grappleBind:SetSize(100, 30)
                    grappleBind:SetSelectedNumber(GetConVar("frest_bindg"):GetInt())

                    function grappleBind:OnChange(num)
                        selectedGrappleBind = grappleBind:GetSelectedNumber()
                        RunConsoleCommand("frest_bindg", selectedGrappleBind)
                    end

                    DockUI.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("UI", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Skip Game Intro", "SettingsLabel", 55, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable UI", "SettingsLabel", 55, 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Kill UI", "SettingsLabel", 55, 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Death UI", "SettingsLabel", 55, 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Health Anchor", "SettingsLabel", 125, 225, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Ammo Style", "SettingsLabel", 125, 265, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Velocity Counter", "SettingsLabel", 55, 305, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Kill UI Accolades", "SettingsLabel", 55, 345, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Reload Hints", "SettingsLabel", 55, 385, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill UI Anchor", "SettingsLabel", 125, 425, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Death UI Anchor", "SettingsLabel", 125, 465, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local skipIntroButton = DockUI:Add("DCheckBox")
                    skipIntroButton:SetPos(20, 70)
                    skipIntroButton:SetConVar("tm_skipintro")
                    skipIntroButton:SetSize(30, 30)

                    local enableUIButton = DockUI:Add("DCheckBox")
                    enableUIButton:SetPos(20, 110)
                    enableUIButton:SetConVar("tm_enableui")
                    enableUIButton:SetSize(30, 30)

                    local enableKillUIButton = DockUI:Add("DCheckBox")
                    enableKillUIButton:SetPos(20, 150)
                    enableKillUIButton:SetConVar("tm_enablekillpopup")
                    enableKillUIButton:SetValue(true)
                    enableKillUIButton:SetSize(30, 30)

                    local enableDeathUIButton = DockUI:Add("DCheckBox")
                    enableDeathUIButton:SetPos(20, 190)
                    enableDeathUIButton:SetConVar("tm_enabledeathpopup")
                    enableDeathUIButton:SetValue(true)
                    enableDeathUIButton:SetSize(30, 30)

                    local healthAnchor = DockUI:Add("DComboBox")
                    healthAnchor:SetPos(20, 230)
                    healthAnchor:SetSize(100, 30)
                    if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 0 then
                        healthAnchor:SetValue("Left Side")
                    elseif CLIENT and GetConVar("tm_healthanchor"):GetInt() == 1 then
                        healthAnchor:SetValue("Middle")
                    else
                        healthAnchor:SetValue("Below Crosshair")
                    end
                    healthAnchor:AddChoice("Left Side")
                    healthAnchor:AddChoice("Middle")
                    healthAnchor:AddChoice("Below Crosshair")
                    healthAnchor.OnSelect = function(self, value)
                        RunConsoleCommand("tm_healthanchor", value - 1)
                    end

                    local ammoStyle = DockUI:Add("DComboBox")
                    ammoStyle:SetPos(20, 270)
                    ammoStyle:SetSize(100, 30)
                    if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 0 then
                        ammoStyle:SetValue("Numeric")
                    elseif CLIENT and GetConVar("tm_ammostyle"):GetInt() == 1 then
                        ammoStyle:SetValue("Bar")
                    elseif CLIENT and GetConVar("tm_ammostyle"):GetInt() == 2 then
                        ammoStyle:SetValue("Below Crosshair")
                    else
                        ammoStyle:SetValue("Centered Numeric")
                    end
                    ammoStyle:AddChoice("Numeric")
                    ammoStyle:AddChoice("Bar")
                    ammoStyle:AddChoice("Below Crosshair")
                    ammoStyle:AddChoice("Centered Numeric")
                    ammoStyle.OnSelect = function(self, value)
                        RunConsoleCommand("tm_ammostyle", value - 1)
                    end

                    local velocityToggle = DockUI:Add("DCheckBox")
                    velocityToggle:SetPos(20, 310)
                    velocityToggle:SetConVar("tm_showspeed")
                    velocityToggle:SetValue(true)
                    velocityToggle:SetSize(30, 30)

                    local accoladeToggle = DockUI:Add("DCheckBox")
                    accoladeToggle:SetPos(20, 350)
                    accoladeToggle:SetConVar("tm_enableaccolades")
                    accoladeToggle:SetValue(true)
                    accoladeToggle:SetSize(30, 30)

                    local reloadHintsToggle = DockUI:Add("DCheckBox")
                    reloadHintsToggle:SetPos(20, 390)
                    reloadHintsToggle:SetConVar("tm_reloadhints")
                    reloadHintsToggle:SetValue(true)
                    reloadHintsToggle:SetSize(30, 30)

                    local killUIAnchor = DockUI:Add("DComboBox")
                    killUIAnchor:SetPos(20, 430)
                    killUIAnchor:SetSize(100, 30)
                    if CLIENT and GetConVar("tm_killuianchor"):GetInt() == 0 then
                        killUIAnchor:SetValue("Bottom")
                    else
                        killUIAnchor:SetValue("Top")
                    end
                    killUIAnchor:AddChoice("Bottom")
                    killUIAnchor:AddChoice("Top")
                    killUIAnchor.OnSelect = function(self, value)
                        RunConsoleCommand("tm_killuianchor", value - 1)
                    end

                    local deathUIAnchor = DockUI:Add("DComboBox")
                    deathUIAnchor:SetPos(20, 470)
                    deathUIAnchor:SetSize(100, 30)
                    if CLIENT and GetConVar("tm_deathuianchor"):GetInt() == 0 then
                        deathUIAnchor:SetValue("Bottom")
                    else
                        deathUIAnchor:SetValue("Top")
                    end
                    deathUIAnchor:AddChoice("Bottom")
                    deathUIAnchor:AddChoice("Top")
                    deathUIAnchor.OnSelect = function(self, value)
                        RunConsoleCommand("tm_deathuianchor", value - 1)
                    end

                    DockAudio.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("AUDIO", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable Hitsounds", "SettingsLabel", 55, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Menu Music", "SettingsLabel", 55, 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Menu Music Volume", "SettingsLabel", 155, 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Community Requested Music", "SettingsLabel", 55, 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local hitSoundsButton = DockAudio:Add("DCheckBox")
                    hitSoundsButton:SetPos(20, 70)
                    hitSoundsButton:SetConVar("tm_hitsounds")
                    hitSoundsButton:SetSize(30, 30)

                    local menuMusicButton = DockAudio:Add("DCheckBox")
                    menuMusicButton:SetPos(20, 110)
                    menuMusicButton:SetConVar("tm_menumusic")
                    menuMusicButton:SetSize(30, 30)

                    function menuMusicButton:OnChange(bVal)
                        if (bVal) then
                            menuMusic:Play()
                            menuMusic:ChangeVolume(GetConVar("tm_menumusicvolume"):GetFloat() / 4 * 1.2)
                        else
                            menuMusic:FadeOut(2)
                        end
                    end

                    local menuMusicVolume = DockAudio:Add("DNumSlider")
                    menuMusicVolume:SetPos(-85, 150)
                    menuMusicVolume:SetSize(250, 30)
                    menuMusicVolume:SetConVar("tm_menumusicvolume")
                    menuMusicVolume:SetMin(0)
                    menuMusicVolume:SetMax(1)
                    menuMusicVolume:SetDecimals(2)

                    menuMusicVolume.OnValueChanged = function(self, value)
                        menuMusic:ChangeVolume(GetConVar("tm_menumusicvolume"):GetFloat() / 4)
                    end

                    local communityMusicButton = DockAudio:Add("DCheckBox")
                    communityMusicButton:SetPos(20, 190)
                    communityMusicButton:SetConVar("tm_communitymusic")
                    communityMusicButton:SetSize(30, 30)

                    DockViewmodel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("MODEL", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("VM FOV Multiplier", "SettingsLabel", 155, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Centered Gun", "SettingsLabel", 55, 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Weapon Bobbing Multiplier", "SettingsLabel", 155, 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Invert Weapon Bobbing", "SettingsLabel", 55, 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local viewmodelFOV = DockViewmodel:Add("DNumSlider")
                    viewmodelFOV:SetPos(-85, 70)
                    viewmodelFOV:SetSize(250, 30)
                    viewmodelFOV:SetConVar("cl_tfa_viewmodel_multiplier_fov")
                    viewmodelFOV:SetMin(0.75)
                    viewmodelFOV:SetMax(2)
                    viewmodelFOV:SetDecimals(2)

                    local centeredVM = DockViewmodel:Add("DCheckBox")
                    centeredVM:SetPos(20, 110)
                    centeredVM:SetConVar("cl_tfa_viewmodel_centered")
                    centeredVM:SetSize(30, 30)

                    local bobbingMulti = DockViewmodel:Add("DNumSlider")
                    bobbingMulti:SetPos(-85, 150)
                    bobbingMulti:SetSize(250, 30)
                    bobbingMulti:SetConVar("cl_tfa_gunbob_intensity")
                    bobbingMulti:SetMin(1)
                    bobbingMulti:SetMax(2)
                    bobbingMulti:SetDecimals(1)

                    local invertBobbing = DockViewmodel:Add("DCheckBox")
                    invertBobbing:SetPos(20, 190)
                    invertBobbing:SetConVar("cl_tfa_gunbob_invertsway")
                    invertBobbing:SetSize(30, 30)

                    DockCrosshair.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("CROSSHAIR", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable", "SettingsLabel", 55 , 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Dot", "SettingsLabel", 55 , 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Pump Feedback", "SettingsLabel", 55 , 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Triangular Crosshair", "SettingsLabel", 55 , 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Color", "SettingsLabel", 245 , 225, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Length", "SettingsLabel", 155, 345, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Width", "SettingsLabel", 155, 385, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Gap Scale", "SettingsLabel", 155, 425, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Crosshair Outline", "SettingsLabel", 55, 465, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Outline Width", "SettingsLabel", 155, 505, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Outline Color", "SettingsLabel", 245 , 545, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local crosshairToggle = DockCrosshair:Add("DCheckBox")
                    crosshairToggle:SetPos(20, 70)
                    crosshairToggle:SetConVar("cl_tfa_hud_crosshair_enable_custom")
                    crosshairToggle:SetSize(30, 30)

                    local dotToggle = DockCrosshair:Add("DCheckBox")
                    dotToggle:SetPos(20, 110)
                    dotToggle:SetConVar("cl_tfa_hud_crosshair_dot")
                    dotToggle:SetSize(30, 30)

                    local pumpToggle = DockCrosshair:Add("DCheckBox")
                    pumpToggle:SetPos(20, 150)
                    pumpToggle:SetConVar("cl_tfa_hud_crosshair_pump")
                    pumpToggle:SetSize(30, 30)

                    local triangleToggle = DockCrosshair:Add("DCheckBox")
                    triangleToggle:SetPos(20, 190)
                    triangleToggle:SetConVar("cl_tfa_hud_crosshair_triangular")
                    triangleToggle:SetSize(30, 30)

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

                    local crosshairLength = DockCrosshair:Add("DNumSlider")
                    crosshairLength:SetPos(-85, 350)
                    crosshairLength:SetSize(250, 30)
                    crosshairLength:SetConVar("cl_tfa_hud_crosshair_length")
                    crosshairLength:SetMin(0.2)
                    crosshairLength:SetMax(2)
                    crosshairLength:SetDecimals(1)

                    local crosshairWidth = DockCrosshair:Add("DNumSlider")
                    crosshairWidth:SetPos(-85, 390)
                    crosshairWidth:SetSize(250, 30)
                    crosshairWidth:SetConVar("cl_tfa_hud_crosshair_width")
                    crosshairWidth:SetMin(1)
                    crosshairWidth:SetMax(4)
                    crosshairWidth:SetDecimals(1)

                    local crosshairGap = DockCrosshair:Add("DNumSlider")
                    crosshairGap:SetPos(-85, 430)
                    crosshairGap:SetSize(250, 30)
                    crosshairGap:SetConVar("cl_tfa_hud_crosshair_gap_scale")
                    crosshairGap:SetMin(0)
                    crosshairGap:SetMax(3)
                    crosshairGap:SetDecimals(1)

                    local outlineToggle = DockCrosshair:Add("DCheckBox")
                    outlineToggle:SetPos(20, 470)
                    outlineToggle:SetConVar("cl_tfa_hud_crosshair_outline_enabled")
                    outlineToggle:SetSize(30, 30)

                    local outlineWidth = DockCrosshair:Add("DNumSlider")
                    outlineWidth:SetPos(-85, 510)
                    outlineWidth:SetSize(250, 30)
                    outlineWidth:SetConVar("cl_tfa_hud_crosshair_outline_width")
                    outlineWidth:SetMin(0)
                    outlineWidth:SetMax(3)
                    outlineWidth:SetDecimals(1)

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

                    DockHitmarker.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("HITMARKERS", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable", "SettingsLabel", 55 , 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("3D/Dynamic Hitmarkers", "SettingsLabel", 55 , 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker Scale", "SettingsLabel", 155, 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker Color", "SettingsLabel", 245 , 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local hitmarkerToggle = DockHitmarker:Add("DCheckBox")
                    hitmarkerToggle:SetPos(20, 70)
                    hitmarkerToggle:SetConVar("cl_tfa_hud_hitmarker_enabled")
                    hitmarkerToggle:SetValue(true)
                    hitmarkerToggle:SetSize(30, 30)

                    local hitmarkerDynamicToggle = DockHitmarker:Add("DCheckBox")
                    hitmarkerDynamicToggle:SetPos(20, 110)
                    hitmarkerDynamicToggle:SetConVar("cl_tfa_hud_hitmarker_3d_all")
                    hitmarkerDynamicToggle:SetValue(true)
                    hitmarkerDynamicToggle:SetSize(30, 30)

                    local hitmarkerScale = DockHitmarker:Add("DNumSlider")
                    hitmarkerScale:SetPos(-85, 150)
                    hitmarkerScale:SetSize(250, 30)
                    hitmarkerScale:SetConVar("cl_tfa_hud_hitmarker_scale")
                    hitmarkerScale:SetMin(0.2)
                    hitmarkerScale:SetMax(2)
                    hitmarkerScale:SetDecimals(1)

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

                    DockScopes.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("SIGHTS & SCOPES", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Scope Shadows", "SettingsLabel", 55 , 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Reticle Color", "SettingsLabel", 245 , 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local scopeShadows = DockScopes:Add("DCheckBox")
                    scopeShadows:SetPos(20, 70)
                    scopeShadows:SetConVar("cl_tfa_3dscope_overlay")
                    scopeShadows:SetValue(true)
                    scopeShadows:SetSize(30, 30)

                    local scopeMixer = vgui.Create("DColorMixer", DockScopes)
                    scopeMixer:SetPos(20, 110)
                    scopeMixer:SetSize(215, 110)
                    scopeMixer:SetConVarR("cl_tfa_reticule_color_r")
                    scopeMixer:SetConVarG("cl_tfa_reticule_color_g")
                    scopeMixer:SetConVarB("cl_tfa_reticule_color_b")
                    scopeMixer:SetAlphaBar(true)
                    scopeMixer:SetPalette(false)
                    scopeMixer:SetWangs(true)

                    DockPerformance.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("PERFORMANCE", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("ADS Vignette", "SettingsLabel", 55 , 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("ADS DOF", "SettingsLabel", 55 , 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Inspection DOF", "SettingsLabel", 55 , 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Muzzle Gas Blur", "SettingsLabel", 55 , 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Bullet Tracers", "SettingsLabel", 55 , 225, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Ejected Shells Time", "SettingsLabel", 155 , 265, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local vignetteDOF = DockPerformance:Add("DCheckBox")
                    vignetteDOF:SetPos(20, 70)
                    vignetteDOF:SetConVar("cl_aimingfx_enabled")
                    vignetteDOF:SetValue(true)
                    vignetteDOF:SetSize(30, 30)

                    local ironSightDOF = DockPerformance:Add("DCheckBox")
                    ironSightDOF:SetPos(20, 110)
                    ironSightDOF:SetConVar("cl_tfa_fx_ads_dof")
                    ironSightDOF:SetValue(true)
                    ironSightDOF:SetSize(30, 30)

                    local inspectionDOF = DockPerformance:Add("DCheckBox")
                    inspectionDOF:SetPos(20, 150)
                    inspectionDOF:SetConVar("cl_tfa_inspection_bokeh")
                    inspectionDOF:SetValue(true)
                    inspectionDOF:SetSize(30, 30)

                    local gasBlur = DockPerformance:Add("DCheckBox")
                    gasBlur:SetPos(20, 190)
                    gasBlur:SetConVar("cl_tfa_fx_gasblur")
                    gasBlur:SetValue(true)
                    gasBlur:SetSize(30, 30)

                    local bulletTracers = DockPerformance:Add("DCheckBox")
                    bulletTracers:SetPos(20, 230)
                    bulletTracers:SetConVar("cl_tfa_ballistics_fx_tracers_mp")
                    bulletTracers:SetValue(true)
                    bulletTracers:SetSize(30, 30)

                    local ejectedDespawnTime = DockPerformance:Add("DNumSlider")
                    ejectedDespawnTime:SetPos(-85, 270)
                    ejectedDespawnTime:SetSize(250, 30)
                    ejectedDespawnTime:SetConVar("cl_tfa_fx_ejectionlife")
                    ejectedDespawnTime:SetMin(0)
                    ejectedDespawnTime:SetMax(10)
                    ejectedDespawnTime:SetDecimals(0)

                    DockBackButton.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
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
                    draw.DrawText("EXIT GAME", "AmmoCountSmall", 5 + textAnim, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                else
                    draw.DrawText("CONFIRM?", "AmmoCountSmall", 5 + textAnim, 5, Color(255, 0, 0), TEXT_ALIGN_LEFT)
                end
            end
            ExitButton.DoClick = function()
                if (disconnectConfirm == 0) then
                    disconnectConfirm = 1
                else
                    RunConsoleCommand("disconnect")
                end

                timer.Simple(3, function() disconnectConfirm = 0 end)
            end
    end

    if belowMinimumRes == true and LocalPlayer():GetNWBool("seenResWarning") ~= true then
        local ResWarning = vgui.Create("DPanel")
        ResWarning:SetPos(0, 0)
        ResWarning:SetSize(ScrW(), ScrH())
        ResWarning:MakePopup()

        local ResWarningLabel = vgui.Create("DLabel", ResWarning)
        ResWarningLabel:SetPos(10, 10)
        ResWarningLabel:SetText("You are playing on a resolution lower than 1024x762!" .. "\n" .. "Any problems that arise from your current resolution will not be addressed." .. "\n" .. "This popup will disappear in 8 seconds.")
        ResWarningLabel:SizeToContents()
        ResWarningLabel:SetDark(1)

        LocalPlayer():SetNWBool("seenResWarning", true)

        timer.Create("removeResWarning", 8, 1, function()
            ResWarning:Hide()
        end)
    end

    if CLIENT and GetConVar("tm_skipintro"):GetInt() == 0 and LocalPlayer():GetNWBool("seenIntro") ~= true then
        local Intro = vgui.Create("DPanel")
        Intro:SetPos(0, 0)
        Intro:SetSize(ScrW(), ScrH())
        Intro:MakePopup()

        Intro.Paint = function()
            surface.SetDrawColor(75, 75, 100, 255)
            surface.DrawRect(0, 0, Intro:GetWide(), Intro:GetTall())
            local rainbowColor = HSVToColor((CurTime() * 100) % 360, 1, 1)

            draw.SimpleText("TITANMOD", "AmmoCount", ScrW() / 2, ScrH() - 200, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("0.1b3", "MainMenuLoadoutWeapons", ScrW() / 2 + 320, ScrH() - 120, Color(255, 255, 255, 155), TEXT_ALIGN_CENTER)
            draw.SimpleText("Developed by Penial", "MainMenuLoadout", ScrW() / 2, ScrH() - 90, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("Tested by Portanator, Checked, Seven, Unlucky, Suomij, RandomSZ", "MainMenuLoadoutWeapons", ScrW() / 2, ScrH() - 60, Color(255, 255, 255), TEXT_ALIGN_CENTER)

            draw.SimpleText("WHAT'S NEW:", "MainMenuPlayerName", ScrW() / 2, ScrH() / 2 - 250, rainbowColor, TEXT_ALIGN_CENTER)

            --New things in a specific patch go below here with a 25 spacing on the Y
            draw.SimpleText("New redesigned and optimized Main Menu", "MainMenuLoadoutWeapons", ScrW() / 2, ScrH() / 2 - 200, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("Statistics page added to Main Menu", "MainMenuLoadoutWeapons", ScrW() / 2, ScrH() / 2 - 175, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("Work towards the Calling Card system", "MainMenuLoadoutWeapons", ScrW() / 2, ScrH() / 2 - 150, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("Alphabetically sorted weapon lists for things like stat reading", "MainMenuLoadoutWeapons", ScrW() / 2, ScrH() / 2 - 125, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("tm_forcesave updated to save all of the new statistics", "MainMenuLoadoutWeapons", ScrW() / 2, ScrH() / 2 - 100, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

        LocalPlayer():SetNWBool("seenIntro", true)

        if belowMinimumRes == true then
            timer.Create("removePopupIntroLowRes", 15.4, 1, function()
                Intro:Hide()
            end)
        else
            timer.Create("removePopupIntro", 7.4, 1, function()
                Intro:Hide()
            end)
        end
    end
end
concommand.Add("tm_openmainmenu", mainMenu)

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
    self:SetSize(600, ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("OptionsPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(600, ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CustomizePanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(400, ScrH())
    self:SetPos(600, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CustomizePreviewPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(600, ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("StatsPanel", PANEL, "Panel")