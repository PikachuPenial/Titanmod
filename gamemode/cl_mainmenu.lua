local MainMenu

function mainMenu()
    if LocalPlayer():Alive() then return end

    local client = LocalPlayer()
    local chosenMusic
    local musicName
    local musicList
    local requestedBy

    local mapID
    local mapName
    local mapDesc
    local mapThumb

    local canPrestige
    if LocalPlayer():GetNWInt("playerLevel") ~= 60 then canPrestige = false else canPrestige = true end

    if ScrW() < 1024 and ScrH() < 768 then
        belowMinimumRes = true
    else
        belowMinimumRes = false
    end

    if CLIENT and GetConVar("tm_communitymusic"):GetInt() == 0 then
        musicList = {"music/sicktwisteddemented_sewerslvt.wav"}
        chosenMusic = (musicList[math.random(#musicList)])
    else
        musicList = {"music/sicktwisteddemented_sewerslvt.wav", "music/takecare_ultrakillost.wav", "music/immaculate_visage.wav", "music/tabgmenumusic.wav", "music/altarsofapostasy_ultrakillost.wav", "music/sneakysnitch_kevinmacleod.wav", "music/waster_bladee.wav", "music/systemfiles_zedorfski.wav"}
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

        for m, t in pairs(mapArr) do
            if game.GetMap() == t[1] then
                mapID = t[1]
                mapName = t[2]
                mapDesc = t[3]
                mapThumb = t[4]
            end
        end

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

                if mapID ~= nil then
                    draw.SimpleText(mapName, "MainMenuMusicName", ScrW() - 210, ScrH() - 50, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                    draw.SimpleText(mapDesc, "StreakText", ScrW() - 210, ScrH() - 25, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                    draw.SimpleText("Map Uptime: " .. math.Round(CurTime()) .. "s", "StreakText", ScrW() - 5, ScrH() - 250, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                    draw.SimpleText("Server Uptime: " .. math.Round(RealTime()) .. "s", "StreakText", ScrW() - 5, ScrH() - 230, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                else
                    draw.SimpleText("Playing on " .. game.GetMap(), "MainMenuMusicName", ScrW() - 5, ScrH() - 35, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                    draw.SimpleText("Map uptime: " .. math.Round(CurTime()) .. "s", "StreakText", ScrW() - 5, ScrH() - 70, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                    draw.SimpleText("Server uptime: " .. math.Round(SysTime()) .. "s", "StreakText", ScrW() - 5, ScrH() - 50, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                end

                draw.SimpleText(LocalPlayer():GetNWInt("playerLevel"), "AmmoCountSmall", 440, -5, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                if LocalPlayer():GetNWInt("playerPrestige") ~= 0 and LocalPlayer():GetNWInt("playerLevel") ~= 60 then
                    draw.SimpleText("P" .. LocalPlayer():GetNWInt("playerPrestige"), "StreakText", 660, 37.5, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                elseif LocalPlayer():GetNWInt("playerPrestige") ~= 0 and LocalPlayer():GetNWInt("playerLevel") == 60 then
                    draw.SimpleText("P" .. LocalPlayer():GetNWInt("playerPrestige"), "StreakText", 535, 37.5, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                end

                if LocalPlayer():GetNWInt("playerLevel") ~= 60 then
                    draw.SimpleText(math.Round(LocalPlayer():GetNWInt("playerXP"), 0) .. " / " .. math.Round(LocalPlayer():GetNWInt("playerXPToNextLevel"), 0) .. " XP", "StreakText", 660, 57.5, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                    draw.SimpleText(LocalPlayer():GetNWInt("playerLevel") + 1, "StreakText", 665, 72.5, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                    surface.SetDrawColor(30, 30, 30, 200)
                    surface.DrawRect(440, 80, 220, 10)

                    surface.SetDrawColor(200, 200, 0, 200)
                    surface.DrawRect(440, 80, (LocalPlayer():GetNWInt("playerXP") / LocalPlayer():GetNWInt("playerXPToNextLevel")) * 220, 10)
                else
                    draw.SimpleText("+ " .. math.Round(LocalPlayer():GetNWInt("playerXP"), 0) .. " XP", "StreakText", 535, 55, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
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
                        draw.DrawText("PRESTIGE TO P" .. LocalPlayer():GetNWInt("playerPrestige") + 1, "StreakText", 5 + textAnim, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("ARE YOU SURE?", "StreakText", 5 + textAnim, 5, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT)
                    end
                end
                PrestigeButton.DoClick = function()
                    if (prestigeConfirm == 0) then
                        prestigeConfirm = 1
                    else
                        LocalPlayer():ConCommand("tm_prestige")
                        PrestigeButton:Hide()
                    end
    
                    timer.Simple(3, function() prestigeConfirm = 0 end)
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
            CallingCard:SetPos(190, 10)
            CallingCard:SetSize(240, 80)
            CallingCard:SetImage(LocalPlayer():GetNWString("chosenPlayercard"), "cards/color/black.png")

            local CallingCardText = vgui.Create("DPanel", CallingCard)
            CallingCardText:SetPos(0, 0)
            CallingCardText:SetSize(240, 80)
            CallingCardText.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            end

            playerProfilePicture = vgui.Create("AvatarImage", MainPanel)
            playerProfilePicture:SetPos(195 + GetConVar("tm_cardpfpoffset"):GetInt(), 15)
            playerProfilePicture:SetSize(70, 70)
            playerProfilePicture:SetPlayer(LocalPlayer(), 184)
            playerProfilePicture.Paint = function()
                playerProfilePicture:SetPos(195 + GetConVar("tm_cardpfpoffset"):GetInt(), 15)
            end

            if mapID ~= nil then
                MapPreview = vgui.Create("DImage", MainPanel)
                MapPreview:SetPos(ScrW() - 205, ScrH() - 205)
                MapPreview:SetSize(200, 200)
                MapPreview:SetImage(mapThumb)
            end

            local PatchNotesButtonHolder = vgui.Create("DPanel", MainPanel)
            PatchNotesButtonHolder:SetPos(ScrW() - 49, ScrH() / 2 - 28)
            PatchNotesButtonHolder:SetSize(48, 48)
            PatchNotesButtonHolder.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 100))
            end

            local PatchNotesButton = vgui.Create("DImageButton", PatchNotesButtonHolder)
            PatchNotesButton:SetImage("icons/patchnotesicon.png")
            patchNotesAnim = 0
            patchNotesOpen = 0
            local buttonSize = 32
            PatchNotesButton.DoClick = function()
                if (patchNotesOpen == 0) then
                    patchNotesOpen = 1
                else
                    patchNotesOpen = 0
                end
            end
            PatchNotesButton.Paint = function(self, w, h)
                if PatchNotesButton:IsHovered() then
                    buttonSize = math.Clamp(buttonSize + 200 * FrameTime(), 0, 16)
                else
                    buttonSize = math.Clamp(buttonSize - 200 * FrameTime(), 0, 16)
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
            PatchNotesPanel:SetSize(420, 600)
            PatchNotesPanel:SetPos(ScrW() - 1, ScrH() / 2 - 300)
            PatchNotesPanel.Paint = function(self, w, h)
                PatchNotesPanel:SetPos(ScrW() - 1 - patchNotesAnim, ScrH() / 2 - 300)
                draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 0))
            end

            local PatchScroller = vgui.Create("DScrollPanel", PatchNotesPanel)
            PatchScroller:Dock(FILL)

            local PatchTextHeader = vgui.Create("DPanel", PatchScroller)
            PatchTextHeader:Dock(TOP)
            PatchTextHeader:SetSize(0, 90)
            PatchTextHeader.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, Color(100, 100, 100, 150))
                draw.SimpleText("PATCH NOTES", "OptionsHeader", 3, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("Scroll to view older patch notes.", "Health", 5, 50, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
            end

            local Patch06b1 = vgui.Create("DPanel", PatchScroller)
            Patch06b1:Dock(TOP)
            Patch06b1:SetSize(0, 230)
            Patch06b1.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, Color(100, 100, 100, 150))
                draw.SimpleText("0.6b1", "OptionsHeader", 3, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("11/14/22", "Health", 5, 50, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                draw.SimpleText("+ Player Leveling and Prestiging","StreakText", 5, 80, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Dynamic weapon spread","StreakText", 5, 100, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Scoreboard improvments", "StreakText", 5, 120, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Suicides no longer give accolades", "StreakText", 5, 140, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed Firing Range appearing in map vote", "StreakText", 5, 160, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Various efforts towards optimization", "StreakText", 5, 180, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Reduced recoil by 10% due to spread addition", "StreakText", 5, 200, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
            end

            local Patch05b1 = vgui.Create("DPanel", PatchScroller)
            Patch05b1:Dock(TOP)
            Patch05b1:SetSize(0, 290)
            Patch05b1.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, Color(100, 100, 100, 150))
                draw.SimpleText("0.5b1", "OptionsHeader", 3, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("11/10/22", "Health", 5, 50, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                draw.SimpleText("+ Added Shipment and Firing Range map","StreakText", 5, 80, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ New Primary weapons:", "StreakText", 5, 100, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Colt 9mm, FN 2000, LR-300", "StreakText", 5, 120, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ New Secondary weapons:", "StreakText", 5, 140, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Mare's Leg, MP-443 Grach", "StreakText", 5, 160, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Firing Range Weapon Spawning","StreakText", 5, 180, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Hit/Kill sound type options","StreakText", 5, 200, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Updated card and model menus", "StreakText", 5, 220, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Shortened some weapon names", "StreakText", 5, 240, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed YouTube link", "StreakText", 5, 260, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
            end

            local Patch04b2 = vgui.Create("DPanel", PatchScroller)
            Patch04b2:Dock(TOP)
            Patch04b2:SetSize(0, 170)
            Patch04b2.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, Color(100, 100, 100, 150))
                draw.SimpleText("0.4b2", "OptionsHeader", 3, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("11/08/22", "Health", 5, 50, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                draw.SimpleText("+ Map updates and optimizations","StreakText", 5, 80, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Accolade player models", "StreakText", 5, 100, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Scope Shadows are now forced off", "StreakText", 5, 120, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Many bug fixes", "StreakText", 5, 140, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
            end

            local Patch04b1 = vgui.Create("DPanel", PatchScroller)
            Patch04b1:Dock(TOP)
            Patch04b1:SetSize(0, 530)
            Patch04b1.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, Color(100, 100, 100, 150))
                draw.SimpleText("0.4b1", "OptionsHeader", 3, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("11/04/22", "Health", 5, 50, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                draw.SimpleText("+ Added Mall and Bridge map","StreakText", 5, 80, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ New Primary weapons:", "StreakText", 5, 100, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Honey Badger, RK62, PzB 39, WA-2000", "StreakText", 5, 120, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ New Secondary weapon:", "StreakText", 5, 140, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   OSP-18", "StreakText", 5, 160, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Match end UI","StreakText", 5, 180, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Revamped stats/model menus","StreakText", 5, 200, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ New community music track", "StreakText", 5, 220, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Beta participation rewards", "StreakText", 5, 240, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Buffed:", "StreakText", 5, 260, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("       Glock 17, Steyr AUG", "StreakText", 5, 280, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Nerfed:", "StreakText", 5, 300, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("      FG 42, KRISS Vector, Scropion Evo 3,", "StreakText", 5, 320, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("      PP-Bizon, Desert Eagle, ", "StreakText", 5, 340, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Added Map Vote Time command", "StreakText", 5, 360, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed Rooftops map", "StreakText", 5, 380, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed Kill UI updating incorrectly", "StreakText", 5, 400, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Optimized headshot tracking", "StreakText", 5, 420, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Flashlights are now rendered serverside", "StreakText", 5, 440, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Added Flashlight customization options", "StreakText", 5, 460, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Scoreboard is now sorted by player score", "StreakText", 5, 480, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Removed full auto from Mk. 14 EBR and M14", "StreakText", 5, 500, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
            end

            local Patch03b1 = vgui.Create("DPanel", PatchScroller)
            Patch03b1:Dock(TOP)
            Patch03b1:SetSize(0, 630)
            Patch03b1.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, Color(100, 100, 100, 150))
                draw.SimpleText("0.3b1", "OptionsHeader", 3, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("11/02/22", "Health", 5, 50, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                draw.SimpleText("+ Map voting","StreakText", 5, 80, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Player cards and card options","StreakText", 5, 100, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Revamped scoreboard","StreakText", 5, 120, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Weapon mastery","StreakText", 5, 140, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Revenge and Copycat accolade","StreakText", 5, 160, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ 5 optics","StreakText", 5, 180, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Buffed:", "StreakText", 5, 200, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("       Stevens 620", "StreakText", 5, 220, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Nerfed:", "StreakText", 5, 240, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("      Minimi Para", "StreakText", 5, 260, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Improved options and customize menus", "StreakText", 5, 280, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Added map information to main menu", "StreakText", 5, 300, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Loadout notification on player spawn", "StreakText", 5, 320, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Endless mode as a server option", "StreakText", 5, 340, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Maps are now included in the addon", "StreakText", 5, 360, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   AR-15 now defaults to full auto", "StreakText", 5, 380, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Players climb ladders 10% faster", "StreakText", 5, 400, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Grapple Hook refreshes on player kill", "StreakText", 5, 420, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Wallrun velocity slightly increased", "StreakText", 5, 440, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Death info now shows on a players suicide", "StreakText", 5, 460, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Optimized Kill UI", "StreakText", 5, 480, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed poor hit registration", "StreakText", 5, 500, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed new weapons not spawning after death", "StreakText", 5, 520, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed error on player suicide", "StreakText", 5, 540, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed error on players first death", "StreakText", 5, 560, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed error for loading player cards", "StreakText", 5, 580, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("- Player specific spectating due to bug", "StreakText", 5, 600, Color(250, 100, 100, 255), TEXT_ALIGN_LEFT)
            end

            local Patch02b1 = vgui.Create("DPanel", PatchScroller)
            Patch02b1:Dock(TOP)
            Patch02b1:SetSize(0, 510)
            Patch02b1.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, Color(100, 100, 100, 150))
                draw.SimpleText("0.2b1", "OptionsHeader", 3, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("10/22/22", "Health", 5, 50, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                draw.SimpleText("+ New Primary weapons:", "StreakText", 5, 80, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   M1919, MG 34, Thompson M1928", "StreakText", 5, 100, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Revamped and optimized Main Menu", "StreakText", 5, 120, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Dedicated Stats page", "StreakText", 5, 140, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Spectating system", "StreakText", 5, 160, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Patch Notes page (you are here)", "StreakText", 5, 180, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Developer Mode", "StreakText", 5, 200, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Buffed:", "StreakText", 5, 220, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("       Colt M1911, Walther P99", "StreakText", 5, 240, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Nerfed:", "StreakText", 5, 260, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("      Minimi Para, SCAR-H SSR, OTs-14 Groza,", "StreakText", 5, 280, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("      Beretta Mx4 Storm, Imbel IA2, XM8, MP7A1,", "StreakText", 5, 300, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("      FNP-45, PM-9, Colt M45A1, MK18, AEK-971", "StreakText", 5, 320, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fancy animations across the main menu", "StreakText", 5, 340, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed Clutch Accolade not being awarded", "StreakText", 5, 360, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Rounded played K/D on statistics", "StreakText", 5, 380, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   KIllcam no longer ends until player spawn", "StreakText", 5, 400, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Backend changes for future playercard support", "StreakText", 5, 420, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   tm_forcesave now saves Accolades", "StreakText", 5, 440, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Alphabetically sorted weapon arrays", "StreakText", 5, 460, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("- Removed Intro splash screen", "StreakText", 5, 480, Color(250, 100, 100, 255), TEXT_ALIGN_LEFT)
            end

            local Patch01b2 = vgui.Create("DPanel", PatchScroller)
            Patch01b2:Dock(TOP)
            Patch01b2:SetSize(0, 170)
            Patch01b2.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, Color(100, 100, 100, 150))
                draw.SimpleText("0.1b2", "OptionsHeader", 3, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("10/15/22", "Health", 5, 50, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                draw.SimpleText("+ Kill Cam", "StreakText", 5, 80, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ Clutch Accolade", "StreakText", 5, 100, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ 7 new Options", "StreakText", 5, 120, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Fixed some Options not saving after disconnect", "StreakText", 5, 140, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
            end

            local Patch01b1 = vgui.Create("DPanel", PatchScroller)
            Patch01b1:Dock(TOP)
            Patch01b1:SetSize(0, 430)
            Patch01b1.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 1, Color(100, 100, 100, 150))
                draw.SimpleText("0.1b1", "OptionsHeader", 3, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("10/14/22", "Health", 5, 50, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                draw.SimpleText("+ New Primary weapons:", "StreakText", 5, 80, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   KSVK 12.7, UMP9, Type-81", "StreakText", 5, 100, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ New Secondary weapon:", "StreakText", 5, 120, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   TCo Stim Pistol", "StreakText", 5, 140, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ New default Main Menu song ", "StreakText", 5, 160, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ New community music track", "StreakText", 5, 180, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ 3 new default playermodels", "StreakText", 5, 200, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("+ 3 new options", "StreakText", 5, 220, Color(100, 250, 100, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Buffed:", "StreakText", 5, 240, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("      UMP-45", "StreakText", 5, 260, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Nerfed:", "StreakText", 5, 280, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("      M14, Mk. 14 EBR", "StreakText", 5, 300, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Tweaked Grappling Hook cooldown (15 > 18s)", "StreakText", 5, 320, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Updated KRISS Vector", "StreakText", 5, 340, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   KM-2000 now gives the Smackdown Accolade", "StreakText", 5, 360, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Equalized audio on music tracks", "StreakText", 5, 380, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText("   Replaced Super Soilder PM with GMan PM", "StreakText", 5, 400, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
            end

            local StatisticsButton = vgui.Create("DImageButton", MainPanel)
            StatisticsButton:SetPos(10, 10)
            StatisticsButton:SetImage("icons/statsicon.png")
            StatisticsButton:SetSize(80, 80)
            StatisticsButton.DoClick = function()
                MainPanel:Hide()

                if not IsValid(StatisticsPanel) then
                    local comparisonSelectedPlayer = nil
                    local compraingWith = false
                    local playerSelected = false

                    local StatisticsPanel = MainMenu:Add("StatsPanel")
                    local StatisticsSlideoutPanel = MainMenu:Add("StatsSlideoutPanel")

                    local StatsQuickjumpHolder = vgui.Create("DPanel", StatisticsSlideoutPanel)
                    StatsQuickjumpHolder:Dock(TOP)
                    StatsQuickjumpHolder:SetSize(0, ScrH())

                    StatsQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
                    end

                    local StatsScroller = vgui.Create("DScrollPanel", StatisticsPanel)
                    StatsScroller:Dock(FILL)

                    local sbar = StatsScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50, 200))
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

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
                    StatsAccolades:SetSize(0, 400)

                    local StatsWeapons = vgui.Create("DPanel", StatsScroller)
                    StatsWeapons:Dock(TOP)
                    StatsWeapons:SetSize(0, 4600)

                    local comparePlayerStats = StatsTextHolder:Add("DComboBox")
                    comparePlayerStats:SetPos(524, 113)
                    comparePlayerStats:SetSize(200, 30)
                    comparePlayerStats:SetValue("Compare stats with...")
                    comparePlayerStats.OnSelect = function(_, _, value, id)
                        comparisonSelectedPlayerID = id
                        comparingWith = player.GetBySteamID(comparisonSelectedPlayerID)

                        playerSelected = true
                        comparePlayerStats:SetValue("Comparing with " .. value)

                        comparingWithPFP = vgui.Create("AvatarImage", StatsCombat)
                        comparingWithPFP:SetPos(656, 15)
                        comparingWithPFP:SetSize(64, 64)
                        comparingWithPFP:SetPlayer(comparingWith, 184)
                    end

                    for _, v in pairs(player.GetAll()) do
                        comparePlayerStats:AddChoice(v:Name(), v:SteamID())
                    end

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
                        draw.SimpleText(math.Round(trackingPlayer:GetNWInt("playerKDR"), 3), "SettingsLabel", 500, 185, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Highest Player Killstreak:", "SettingsLabel", 20, 220, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("highestKillStreak"), "SettingsLabel", 500, 220, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        if playerSelected == true and comparingWith ~= false then
                            draw.SimpleText(comparingWith:GetNWInt("playerScore"), "SettingsLabel", 720, 80, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerKills"), "SettingsLabel", 720, 115, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerDeaths"), "SettingsLabel", 720, 150, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(math.Round(comparingWith:GetNWInt("playerKDR"), 3), "SettingsLabel", 720, 185, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("highestKillStreak"), "SettingsLabel", 720, 220, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                        end
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

                        draw.SimpleText("Revenge Kills:", "SettingsLabel", 20, 325, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeRevenge"), "SettingsLabel", 500, 325, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        draw.SimpleText("Copycat Kills:", "SettingsLabel", 20, 360, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText(trackingPlayer:GetNWInt("playerAccoladeCopycat"), "SettingsLabel", 500, 360, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                        if playerSelected == true and comparingWith ~= false then
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeHeadshot"), "SettingsLabel", 720, 80, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeSmackdown"), "SettingsLabel", 720, 115, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeClutch"), "SettingsLabel", 720, 150, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeLongshot"), "SettingsLabel", 720, 185, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladePointblank"), "SettingsLabel", 720, 220, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeOnStreak"), "SettingsLabel", 720, 255, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeBuzzkill"), "SettingsLabel", 720, 290, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeRevenge"), "SettingsLabel", 720, 325, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            draw.SimpleText(comparingWith:GetNWInt("playerAccoladeCopycat"), "SettingsLabel", 720, 360, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                        end
                    end

                    StatsWeapons.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("WEAPONS", "OptionsHeader", 20, 20, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        for p, t in pairs(weaponsArr) do
                            draw.SimpleText(t[2] .. " Kills: ", "SettingsLabel", 20, 80 + ((p - 1) * 35), Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                            draw.SimpleText(trackingPlayer:GetNWInt("killsWith_" .. t[1]), "SettingsLabel", 500, 80 + ((p - 1) * 35), Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)

                            if playerSelected == true and comparingWith ~= false then
                                draw.SimpleText(comparingWith:GetNWInt("killsWith_" .. t[1]), "SettingsLabel", 720, 80 + ((p - 1) * 35), Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT)
                            end
                        end
                    end

                    localPFP = vgui.Create("AvatarImage", StatsCombat)
                    localPFP:SetPos(436, 15)
                    localPFP:SetSize(64, 64)
                    localPFP:SetPlayer(LocalPlayer(), 184)

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
                        StatsScroller:ScrollToChild(StatsCombat)
                    end

                    local AccoladesJump = vgui.Create("DImageButton", StatsQuickjumpHolder)
                    AccoladesJump:SetPos(4, 152)
                    AccoladesJump:SetSize(48, 48)
                    AccoladesJump:SetImage("icons/accoladeicon.png")
                    AccoladesJump:SetTooltip("Accolade Stats")
                    AccoladesJump.DoClick = function()
                        StatsScroller:ScrollToChild(StatsAccolades)
                    end

                    local WeaponsJump = vgui.Create("DImageButton", StatsQuickjumpHolder)
                    WeaponsJump:SetPos(4, 204)
                    WeaponsJump:SetSize(48, 48)
                    WeaponsJump:SetImage("icons/weaponicon.png")
                    WeaponsJump:SetTooltip("Weapon Stats")
                    WeaponsJump.DoClick = function()
                        StatsScroller:ScrollToChild(StatsWeapons)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", StatsQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout.DoClick = function()
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
                draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
            end

            local SpectateTextHeader = vgui.Create("DPanel", SpectatePanel)
            SpectateTextHeader:Dock(TOP)
            SpectateTextHeader:SetSize(0, 70)
            SpectateTextHeader.Paint = function(self, w, h)
                draw.SimpleText("SPECTATE", "UITiny", 3, 0, Color(0, 0, 0), TEXT_ALIGN_LEFT)
            end

            local spectatePicker = SpectateTextHeader:Add("DComboBox")
            spectatePicker:SetPos(0, 40)
            spectatePicker:SetSize(170, 30)
            spectatePicker:SetValue("Spectate...")
            spectatePicker:AddChoice("Freecam")
            local spectateFreecam = false
            local playerSelected = false
            spectatePicker.OnSelect = function(_, _, value, id)
                if id ~= nil then
                    currentlySpectatingPlayerID = id
                    currentlySpectating = player.GetBySteamID(currentlySpectatingPlayerID)
                    playerSelected = true
                    spectateFreecam = false
                else
                    spectateFreecam = true
                    playerSelected = false
                end
                spectatePicker:SetValue("Spectating " .. value)

                if spectateFreecam == true then
                    RunConsoleCommand("tm_spectate", "free")
                end

                if playerSelected == true then
                    RunConsoleCommand("tm_spectate", "player", currentlySpectating)
                end

                MainMenu:Remove(false)
                gui.EnableScreenClicker(false)
                LocalPlayer():ConCommand("tm_closemainmenu")

                menuMusic:FadeOut(2)
            end

            --for _, v in pairs(player.GetAll()) do
                --spectatePicker:AddChoice(v:Name(), v:SteamID())
            --end

            local SpectateButton = vgui.Create("DImageButton", MainPanel)
            SpectateButton:SetPos(100, 10)
            SpectateButton:SetImage("icons/spectateicon.png")
            SpectateButton:SetSize(80, 80)
            local spectatePanelOpen = 0
            SpectateButton.DoClick = function()
                if (spectatePanelOpen == 0) then
                    spectatePanelOpen = 1
                    SpectatePanel:SizeTo(-1, 70, 1, 0, 0.1)
                else
                    spectatePanelOpen = 0
                    SpectatePanel:SizeTo(-1, 0, 1, 0, 0.1)
                    spectatePicker:SetValue("Spectate...")
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
                gui.OpenURL("https://www.youtube.com/channel/UC1aCX3i4L6TyEv_rmo_HeRA")
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
                    if v[1] == LocalPlayer():GetNWString("loadoutPrimary") then
                        draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + textAnim, 15, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end
                    if v[1] == LocalPlayer():GetNWString("loadoutSecondary") then
                        draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + textAnim, 40 , Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end
                    if v[1] == LocalPlayer():GetNWString("loadoutMelee") then
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
                    pushButtonsAbove = math.Clamp(pushButtonsAbove + 600     * FrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, ScrH() / 2 - pushButtonsAbove)
                    CustomizeButton:SizeTo(-1, 200, 0, 0, 1)
                else
                    textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
                    pushButtonsAbove = math.Clamp(pushButtonsAbove - 600 * FrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, ScrH() / 2 - pushButtonsAbove)
                    CustomizeButton:SizeTo(-1, 100, 0, 0, 1)
                end
                draw.DrawText("CUSTOMIZE", "AmmoCountSmall", 5 + textAnim, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                SpawnButton:SetPos(0, ScrH() / 2 - 100 - pushButtonsAbove)
            end

            CustomizeModelButton:SetPos(0, 100)
            CustomizeModelButton:SetText("")
            CustomizeModelButton:SetSize(180, 100)
            CustomizeModelButton.Paint = function()
                draw.DrawText("MODEL", "AmmoCountESmall", 5 + textAnim, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            end

            CustomizeCardButton:SetPos(180, 100)
            CustomizeCardButton:SetText("")
            CustomizeCardButton:SetSize(160, 100)
            CustomizeCardButton.Paint = function()
                draw.DrawText("CARD", "AmmoCountESmall", 5 + textAnim, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            end

            CustomizeCardButton.DoClick = function()
                MainPanel:Hide()
                local currentCard = LocalPlayer():GetNWString("chosenPlayercard")

                if not IsValid(CardPanel) then
                    local CardPanel = MainMenu:Add("CardPanel")
                    local CardSlideoutPanel = MainMenu:Add("CardSlideoutPanel")

                    local CardQuickjumpHolder = vgui.Create("DPanel", CardSlideoutPanel)
                    CardQuickjumpHolder:Dock(TOP)
                    CardQuickjumpHolder:SetSize(0, ScrH())

                    CardQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
                    end

                    local newCard
                    local newCardName
                    local newCardDesc
                    local newCardUnlockType
                    local newCardUnlockValue

                    local totalCards = 166
                    local cardsUnlocked = 0

                    local defaultCardsTotal = 0
                    local defaultCardsUnlocked = 0

                    local killCardsTotal = 0
                    local killCardsUnlocked = 0

                    local accoladeCardsTotal = 0
                    local accoladeCardsUnlocked = 0

                    local masteryCardsTotal = 0
                    local masteryCardsUnlocked = 0

                    local colorCardsTotal = 0
                    local colorCardsUnlocked = 0

                    --Checking for the players currently equipped card.
                    for k, v in pairs(cardArr) do
                        if v[1] == currentCard and v[4] ~= "mastery" then
                            newCard = v[1]
                            newCardName = v[2]
                            newCardDesc = v[3]
                            newCardUnlockType = v[4]
                            newCardUnlockValue = v[5]
                        elseif v[1] == currentCard and v[4] == "mastery" then
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
                        draw.RoundedBox(5, 0, 0, w, h, Color(40, 40, 40, 200))
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local CardTextHolder = vgui.Create("DPanel", CardScroller)
                    CardTextHolder:Dock(TOP)
                    CardTextHolder:SetSize(0, 140)

                    CardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("CARDS", "AmmoCountSmall", 257.5, 20, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        draw.SimpleText(cardsUnlocked .. " / " .. totalCards .. " cards unlocked", "Health", 257.5, 100, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                    end

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
                    DockAccoladeCards:SetSize(0, 666)

                    --Mastery related Playercards
                    local TextMastery = vgui.Create("DPanel", CardScroller)
                    TextMastery:Dock(TOP)
                    TextMastery:SetSize(0, 90)

                    local DockMasteryCards = vgui.Create("DPanel", CardScroller)
                    DockMasteryCards:Dock(TOP)
                    DockMasteryCards:SetSize(0, 5360)

                    --Color related Playercards
                    local TextColor = vgui.Create("DPanel", CardScroller)
                    TextColor:Dock(TOP)
                    TextColor:SetSize(0, 90)

                    local DockColorCards = vgui.Create("DPanel", CardScroller)
                    DockColorCards:Dock(TOP)
                    DockColorCards:SetSize(0, 500)

                    local TextOptions = vgui.Create("DPanel", CardScroller)
                    TextOptions:Dock(TOP)
                    TextOptions:SetSize(0, 60)

                    local DockCardOptions = vgui.Create("DPanel", CardScroller)
                    DockCardOptions:Dock(TOP)
                    DockCardOptions:SetSize(0, 75)

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

                    local MasteryCardList = vgui.Create("DIconLayout", DockMasteryCards)
                    MasteryCardList:Dock(TOP)
                    MasteryCardList:SetSpaceY(5)
                    MasteryCardList:SetSpaceX(20)

                    local ColorCardList = vgui.Create("DIconLayout", DockColorCards)
                    ColorCardList:Dock(TOP)
                    ColorCardList:SetSpaceY(5)
                    ColorCardList:SetSpaceX(20)

                    DefaultCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    KillCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    AccoladeCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    MasteryCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    ColorCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    local CardPreviewPanel = MainMenu:Add("CardPreviewPanel")

                    local CardsPreviewScroller = vgui.Create("DScrollPanel", CardPreviewPanel)
                    CardsPreviewScroller:Dock(FILL)

                    local PreviewCardTextHolder = vgui.Create("DPanel", CardsPreviewScroller)
                    PreviewCardTextHolder:Dock(TOP)
                    PreviewCardTextHolder:SetSize(0, 170)

                    CallingCard = vgui.Create("DImage", PreviewCardTextHolder)
                    CallingCard:SetPos(137.5, 10)
                    CallingCard:SetSize(240, 80)
                    CallingCard:SetImage(newCard)

                    ProfilePicture = vgui.Create("AvatarImage", CallingCard)
                    ProfilePicture:SetPos(5 + GetConVar("tm_cardpfpoffset"):GetInt(), 5)
                    ProfilePicture:SetSize(70, 70)
                    ProfilePicture:SetPlayer(LocalPlayer(), 184)
                    ProfilePicture.Paint = function()
                        ProfilePicture:SetPos(5 + GetConVar("tm_cardpfpoffset"):GetInt(), 5)
                    end

                    PreviewCardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))

                        if currentCard ~= nil then
                            draw.SimpleText(newCardName, "PlayerNotiName", 5, 90, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                            draw.SimpleText(newCardDesc, "Health", 5, 135, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        end

                        if newCardUnlockType == "default" then
                            draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                        end

                        if newCardUnlockType == "color" then
                            draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                        end

                        if newCardUnlockType == "kills" then
                            if LocalPlayer():GetNWInt("playerKills") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText(LocalPlayer():GetNWInt("playerKills") .. "/" .. newCardUnlockValue .. " Kills", "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText(LocalPlayer():GetNWInt("playerKills") .. "/" .. newCardUnlockValue .. " Kills", "Health", 510, 135, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        if newCardUnlockType == "streak" then
                            if LocalPlayer():GetNWInt("highestKillStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Highest Streak: " .. LocalPlayer():GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Highest Streak: " .. LocalPlayer():GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        --Accolades
                        if newCardUnlockType == "headshot" then
                            if LocalPlayer():GetNWInt("playerAccoladeHeadshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Headshots: " .. LocalPlayer():GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Headshots: " .. LocalPlayer():GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end
                        
                        if newCardUnlockType == "smackdown" then
                            if LocalPlayer():GetNWInt("playerAccoladeSmackdown") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Melee Kills: " .. LocalPlayer():GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Melee Kills: " .. LocalPlayer():GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        if newCardUnlockType == "clutch" then
                            if LocalPlayer():GetNWInt("playerAccoladeClutch") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Clutches: " .. LocalPlayer():GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Clutches: " .. LocalPlayer():GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        if newCardUnlockType == "longshot" then
                            if LocalPlayer():GetNWInt("playerAccoladeLongshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Longshots: " .. LocalPlayer():GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Longshots: " .. LocalPlayer():GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        if newCardUnlockType == "pointblank" then
                            if LocalPlayer():GetNWInt("playerAccoladePointblank") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Point Blanks: " .. LocalPlayer():GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Point Blanks: " .. LocalPlayer():GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        if newCardUnlockType == "killstreaks" then
                            if LocalPlayer():GetNWInt("playerAccoladeOnStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Killstreaks Started: " .. LocalPlayer():GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Killstreaks Started: " .. LocalPlayer():GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        if newCardUnlockType == "buzzkills" then
                            if LocalPlayer():GetNWInt("playerAccoladeBuzzkill") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Buzzkills: " .. LocalPlayer():GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Buzzkills: " .. LocalPlayer():GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        if newCardUnlockType == "revenge" then
                            if LocalPlayer():GetNWInt("playerAccoladeRevenge") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Revenge Kills: " .. LocalPlayer():GetNWInt("playerAccoladeRevenge") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Revenge Kills: " .. LocalPlayer():GetNWInt("playerAccoladeRevenge") .. "/" .. newCardUnlockValue, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        --Mastery
                        if newCardUnlockType == "mastery" then
                            if LocalPlayer():GetNWInt("killsWith_" .. newCardUnlockValue) < 50 then
                                draw.SimpleText("Locked", "PlayerNotiName", 510, 90, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Kills w/ gun: " .. LocalPlayer():GetNWInt("killsWith_" .. newCardUnlockValue) .. "/" .. 50, "Health", 510, 135, Color(250, 0, 0, 255), TEXT_ALIGN_RIGHT)
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 510, 90, Color(0, 250, 0, 255), TEXT_ALIGN_RIGHT)
                                draw.SimpleText("Kills w/ gun: " .. LocalPlayer():GetNWInt("killsWith_" .. newCardUnlockValue) .. "/" .. 50, "Health", 510, 135, Color(0, 255, 0, 255), TEXT_ALIGN_RIGHT)
                            end
                        end

                        CallingCard:SetImage(newCard)
                    end

                    for k, v in pairs(cardArr) do
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
                            end
                        end

                        if v[4] == "kills" or v[4] == "streak" then
                            local card = vgui.Create("DImageButton", DockKillCards)
                            card:SetImage(v[1])
                            card:SetTooltip(v[2] .. "\n" .. v[3])
                            card:SetSize(240, 80)
                            KillCardList:Add(card)

                            killCardsTotal = killCardsTotal + 1

                            if v[4] == "kills" and LocalPlayer():GetNWInt("playerKills") < v[5] or v[4] == "streak" and LocalPlayer():GetNWInt("highestKillStreak") < v[5] then
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
                            end
                        end

                        if v[4] == "headshot" or v[4] == "smackdown" or v[4] == "clutch" or v[4] == "longshot" or v[4] == "pointblank" or v[4] == "killstreaks" or v[4] == "buzzkills" or v[4] == "revenge" then
                            local card = vgui.Create("DImageButton", DockAccoladeCards)
                            card:SetImage(v[1])
                            card:SetTooltip(v[2] .. "\n" .. v[3])
                            card:SetSize(240, 80)
                            AccoladeCardList:Add(card)

                            accoladeCardsTotal = accoladeCardsTotal + 1

                            if v[4] == "headshot" and LocalPlayer():GetNWInt("playerAccoladeHeadshot") < v[5] or v[4] == "smackdown" and LocalPlayer():GetNWInt("playerAccoladeSmackdown") < v[5] or v[4] == "clutch" and LocalPlayer():GetNWInt("playerAccoladeClutch") < v[5] or v[4] == "longshot" and LocalPlayer():GetNWInt("playerAccoladeLongshot") < v[5] or v[4] == "pointblank" and LocalPlayer():GetNWInt("playerAccoladePointblank") < v[5] or v[4] == "killstreaks" and LocalPlayer():GetNWInt("playerAccoladeOnStreak") < v[5] or v[4] == "buzzkills" and LocalPlayer():GetNWInt("playerAccoladeBuzzkill") < v[5] or v[4] == "revenge" and LocalPlayer():GetNWInt("playerAccoladeRevenge") < v[5] then
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
                            end
                        end

                        if v[4] == "color" then
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
                            end
                        end

                        if v[4] == "mastery" then
                            local card = vgui.Create("DImageButton", DockMasteryCards)
                            card:SetImage(v[1])
                            card:SetTooltip(v[2] .. "\n" .. v[3])
                            card:SetSize(240, 80)
                            MasteryCardList:Add(card)

                            masteryCardsTotal = masteryCardsTotal + 1

                            if v[4] == "mastery" and LocalPlayer():GetNWInt("killsWith_" .. v[5]) < 50 then
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
                            end
                        end
                    end

                    TextDefault.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Default", "OptionsHeader", 257.5, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        draw.SimpleText(defaultCardsUnlocked .. " / " .. defaultCardsUnlocked, "Health", 257.5, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                    end

                    TextKill.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Kills", "OptionsHeader", 257.5, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)

                        if killCardsUnlocked == killCardsTotal then
                            draw.SimpleText(killCardsUnlocked .. " / " .. killCardsTotal, "Health", 257.5, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(killCardsUnlocked .. " / " .. killCardsTotal, "Health", 257.5, 55, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        end
                    end

                    TextAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Accolades", "OptionsHeader", 257.5, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)

                        if accoladeCardsUnlocked == accoladeCardsTotal then
                            draw.SimpleText(accoladeCardsUnlocked .. " / " .. accoladeCardsTotal, "Health", 257.5, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(accoladeCardsUnlocked .. " / " .. accoladeCardsTotal, "Health", 257.5, 55, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        end
                    end

                    TextMastery.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Mastery", "OptionsHeader", 257.5, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)

                        if masteryCardsUnlocked == masteryCardsTotal then
                            draw.SimpleText(masteryCardsUnlocked .. " / " .. masteryCardsTotal, "Health", 257.5, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(masteryCardsUnlocked .. " / " .. masteryCardsTotal, "Health", 257.5, 55, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        end
                    end

                    TextColor.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Solid Colors", "OptionsHeader", 257.5, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        draw.SimpleText(colorCardsUnlocked .. " / " .. colorCardsTotal, "Health", 257.5, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                    end

                    TextOptions.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Card Options", "OptionsHeader", 257.5, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                    end

                    DockDefaultCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    DockKillCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    DockAccoladeCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    DockMasteryCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    DockColorCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end

                    DockCardOptions.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Profile Picture X Offset", "SettingsLabel", 257.5, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
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
                        if newCardUnlockType == "default" then
                            surface.PlaySound("common/wpn_select.wav")
                            RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                            RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                            MainPanel:Show()
                            CardPanel:Hide()
                            CardPreviewPanel:Hide()
                            CardSlideoutPanel:Hide()
                        end

                        if newCardUnlockType == "kills" then
                            if LocalPlayer():GetNWInt("playerKills") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "streak" then
                            if LocalPlayer():GetNWInt("highestKillStreak") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "headshot" then
                            if LocalPlayer():GetNWInt("playerAccoladeHeadshot") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "smackdown" then
                            if LocalPlayer():GetNWInt("playerAccoladeSmackdown") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "clutch" then
                            if LocalPlayer():GetNWInt("playerAccoladeClutch") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "longshot" then
                            if LocalPlayer():GetNWInt("playerAccoladeLongshot") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "pointblank" then
                            if LocalPlayer():GetNWInt("playerAccoladePointblank") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "killstreaks" then
                            if LocalPlayer():GetNWInt("playerAccoladeOnStreak") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "buzzkills" then
                            if LocalPlayer():GetNWInt("playerAccoladeBuzzkill") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "revenge" then
                            if LocalPlayer():GetNWInt("playerAccoladeRevenge") < newCardUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end

                        if newCardUnlockType == "color" then
                            surface.PlaySound("common/wpn_select.wav")
                            RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue)
                            RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                            MainPanel:Show()
                            CardPanel:Hide()
                            CardPreviewPanel:Hide()
                            CardSlideoutPanel:Hide()
                        end

                        if newCardUnlockType == "mastery" then
                            if LocalPlayer():GetNWInt("killsWith_" .. newCardUnlockValue) < masteryUnlock then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayercard", newCard, newCardUnlockType, newCardUnlockValue, masteryUnlock)
                                RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                                MainPanel:Show()
                                CardPanel:Hide()
                                CardPreviewPanel:Hide()
                                CardSlideoutPanel:Hide()
                            end
                        end
                    end

                    local offset = DockCardOptions:Add("DNumSlider")
                    offset:SetPos(-15, 0)
                    offset:SetSize(400, 100)
                    offset:SetConVar("tm_cardpfpoffset")
                    offset:SetMin(0)
                    offset:SetMax(160)
                    offset:SetDecimals(0)

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
                        CardScroller:ScrollToChild(TextDefault)
                    end

                    local KillsJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    KillsJump:SetPos(4, 152)
                    KillsJump:SetSize(48, 48)
                    KillsJump:SetImage("icons/uikillicon.png")
                    KillsJump:SetTooltip("Kills")
                    KillsJump.DoClick = function()
                        CardScroller:ScrollToChild(TextKill)
                    end

                    local AccoladeJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    AccoladeJump:SetPos(4, 204)
                    AccoladeJump:SetSize(48, 48)
                    AccoladeJump:SetImage("icons/accoladeicon.png")
                    AccoladeJump:SetTooltip("Accolades")
                    AccoladeJump.DoClick = function()
                        CardScroller:ScrollToChild(TextAccolade)
                    end

                    local WeaponJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    WeaponJump:SetPos(4, 256)
                    WeaponJump:SetSize(48, 48)
                    WeaponJump:SetImage("icons/weaponicon.png")
                    WeaponJump:SetTooltip("Mastery")
                    WeaponJump.DoClick = function()
                        CardScroller:ScrollToChild(TextMastery)
                    end

                    local PaletteJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    PaletteJump:SetPos(4, 308)
                    PaletteJump:SetSize(48, 48)
                    PaletteJump:SetImage("icons/paletteicon.png")
                    PaletteJump:SetTooltip("Solid Colors")
                    PaletteJump.DoClick = function()
                        CardScroller:ScrollToChild(TextColor)
                    end

                    local OptionsJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    OptionsJump:SetPos(4, 360)
                    OptionsJump:SetSize(48, 48)
                    OptionsJump:SetImage("icons/settingsicon.png")
                    OptionsJump:SetTooltip("Card Options")
                    OptionsJump.DoClick = function()
                        CardScroller:ScrollToChild(TextOptions)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", CardQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
                        MainPanel:Show()
                        CardPanel:Hide()
                        CardPreviewPanel:Hide()
                        CardSlideoutPanel:Hide()
                        RunConsoleCommand("tm_setcardpfpoffset", GetConVar("tm_cardpfpoffset"):GetInt())
                    end
                end
            end

            CustomizeModelButton.DoClick = function()
                MainPanel:Hide()

                local previewModel = LocalPlayer():GetNWString("chosenPlayermodel")

                if not IsValid(CustomizePanel) then
                    local CustomizePanel = MainMenu:Add("CustomizePanel")
                    local CustomizeSlideoutPanel = MainMenu:Add("CustomizeSlideoutPanel")

                    local newModel
                    local newModelName
                    local newModelDesc
                    local newModelUnlockType
                    local newModelUnlockValue

                    local totalModels = 35
                    local modelsUnlocked = 0

                    local defaultModelsTotal = 0
                    local defaultModelsUnlocked = 0

                    local killModelsTotal = 0
                    local killModelsUnlocked = 0

                    local streakModelsTotal = 0
                    local streakModelsUnlocked = 0

                    local accoladeModelsTotal = 0
                    local accoladeModelsUnlocked = 0

                    local specialModelsTotal = 0
                    local specialModelsUnlocked = 0

                    local ModelQuickjumpHolder = vgui.Create("DPanel", CustomizeSlideoutPanel)
                    ModelQuickjumpHolder:Dock(TOP)
                    ModelQuickjumpHolder:SetSize(0, ScrH())

                    ModelQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
                    end

                    local CustomizeScroller = vgui.Create("DScrollPanel", CustomizePanel)
                    CustomizeScroller:Dock(FILL)

                    local sbar = CustomizeScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, Color(40, 40, 40, 200))
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local CustomizeTextHolder = vgui.Create("DPanel", CustomizeScroller)
                    CustomizeTextHolder:Dock(TOP)
                    CustomizeTextHolder:SetSize(0, 140)

                    CustomizeTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("MODELS", "AmmoCountSmall", w / 2, 20, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        draw.SimpleText(modelsUnlocked .. " / " .. totalModels .. " models unlocked", "Health", w / 2, 100, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                    end

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
                    DockModelsAccolade:SetSize(0, 620)

                    --Special Playermodels
                    local TextSpecial = vgui.Create("DPanel", CustomizeScroller)
                    TextSpecial:Dock(TOP)
                    TextSpecial:SetSize(0, 90)

                    local DockModelsSpecial = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsSpecial:Dock(TOP)
                    DockModelsSpecial:SetSize(0, 155)

                    --Creating playermodel lists
                    local DefaultModelList = vgui.Create("DIconLayout", DockModels)
                    DefaultModelList:Dock(TOP)
                    DefaultModelList:SetSpaceY(5)
                    DefaultModelList:SetSpaceX(5)

                    DefaultModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    local KillsModelList = vgui.Create("DIconLayout", DockModelsKills)
                    KillsModelList:Dock(TOP)
                    KillsModelList:SetSpaceY(5)
                    KillsModelList:SetSpaceX(5)

                    KillsModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    local StreakModelList = vgui.Create("DIconLayout", DockModelsStreak)
                    StreakModelList:Dock(TOP)
                    StreakModelList:SetSpaceY(5)
                    StreakModelList:SetSpaceX(5)

                    StreakModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    local AccoladeModelList = vgui.Create("DIconLayout", DockModelsAccolade)
                    AccoladeModelList:Dock(TOP)
                    AccoladeModelList:SetSpaceY(5)
                    AccoladeModelList:SetSpaceX(5)

                    AccoladeModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    end

                    local SpecialModelList = vgui.Create("DIconLayout", DockModelsSpecial)
                    SpecialModelList:Dock(TOP)
                    SpecialModelList:SetSpaceY(5)
                    SpecialModelList:SetSpaceX(5)

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
                        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
                    end

                    local NewModelTextHolder = vgui.Create("DPanel", PreviewScroller)
                    NewModelTextHolder:Dock(TOP)
                    NewModelTextHolder:SetSize(0, 160)

                    NewModelTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))

                        if newModel ~= nil then
                            draw.SimpleText("Selected playermodel:", "Health", w / 2, 10, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
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

                        if newModelUnlockType == "headshot" then
                            if LocalPlayer():GetNWInt("playerAccoladeHeadshot") < newModelUnlockValue then
                                draw.SimpleText("Headshots: " .. LocalPlayer():GetNWInt("playerAccoladeHeadshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Headshots: " .. LocalPlayer():GetNWInt("playerAccoladeHeadshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end
                        
                        if newModelUnlockType == "smackdown" then
                            if LocalPlayer():GetNWInt("playerAccoladeSmackdown") < newModelUnlockValue then
                                draw.SimpleText("Smackdowns: " .. LocalPlayer():GetNWInt("playerAccoladeSmackdown") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Smackdowns: " .. LocalPlayer():GetNWInt("playerAccoladeSmackdown") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "clutch" then
                            if LocalPlayer():GetNWInt("playerAccoladeClutch") < newModelUnlockValue then
                                draw.SimpleText("Clutches: " .. LocalPlayer():GetNWInt("playerAccoladeClutch") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Clutches: " .. LocalPlayer():GetNWInt("playerAccoladeClutch") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "longshot" then
                            if LocalPlayer():GetNWInt("playerAccoladeLongshot") < newModelUnlockValue then
                                draw.SimpleText("Longshots: " .. LocalPlayer():GetNWInt("playerAccoladeLongshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Longshots: " .. LocalPlayer():GetNWInt("playerAccoladeLongshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "pointblank" then
                            if LocalPlayer():GetNWInt("playerAccoladePointblank") < newModelUnlockValue then
                                draw.SimpleText("Point Blanks: " .. LocalPlayer():GetNWInt("playerAccoladePointblank") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Point Blanks: " .. LocalPlayer():GetNWInt("playerAccoladePointblank") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "killstreaks" then
                            if LocalPlayer():GetNWInt("playerAccoladeOnStreak") < newModelUnlockValue then
                                draw.SimpleText("Killstreaks Started: " .. LocalPlayer():GetNWInt("playerAccoladeOnStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Killstreaks Started: " .. LocalPlayer():GetNWInt("playerAccoladeOnStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "buzzkills" then
                            if LocalPlayer():GetNWInt("playerAccoladeBuzzkill") < newModelUnlockValue then
                                draw.SimpleText("Buzzkills: " .. LocalPlayer():GetNWInt("playerAccoladeBuzzkill") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Buzzkills: " .. LocalPlayer():GetNWInt("playerAccoladeBuzzkill") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "revenge" then
                            if LocalPlayer():GetNWInt("playerAccoladeRevenge") < newModelUnlockValue then
                                draw.SimpleText("Revenge Kills: " .. LocalPlayer():GetNWInt("playerAccoladeRevenge") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Revenge Kills: " .. LocalPlayer():GetNWInt("playerAccoladeRevenge") .. " / " .. newModelUnlockValue, "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "special" and newModelUnlockValue == "name" then
                            if LocalPlayer():SteamID() == "STEAM_0:1:514443768" then
                                draw.SimpleText("Unlocked", "Health", w / 2, 130, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("[CLASSIFIED]", "Health", w / 2, 130, Color(0, 0, 250, 255), TEXT_ALIGN_CENTER)
                            end
                        end

                        if newModelUnlockType == "special" and newModelUnlockValue == "beta" then
                            if LocalPlayer():GetNWInt("playerBetaTimePlayed") < 10800 then
                                draw.SimpleText("Time Played: " .. LocalPlayer():GetNWInt("playerBetaTimePlayed") .. " / " .. 10800 .. "s", "Health", w / 2, 130, Color(250, 0, 0, 255), TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Time Played: " .. LocalPlayer():GetNWInt("playerBetaTimePlayed") .. " / " .. 10800 .. "s", "Health", w / 2, 130, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
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
                        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
                    end

                    local SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                    selectedModelShown = false

                    for k, v in pairs(modelArr) do
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
                            icon:SetSize(150, 150)
                            KillsModelList:Add(icon)

                            killModelsTotal = killModelsTotal + 1

                            if v[4] == "kills" and LocalPlayer():GetNWInt("playerKills") < v[5] then
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
                            icon:SetSize(150, 150)
                            StreakModelList:Add(icon)

                            streakModelsTotal = streakModelsTotal + 1

                            if LocalPlayer():GetNWInt("highestKillStreak") < v[5] then
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
                            icon:SetSize(150, 150)
                            SpecialModelList:Add(icon)

                            specialModelsTotal = specialModelsTotal + 1

                            if v[5] == "name" and ply:SteamID() ~= "STEAM_0:1:514443768" or v[5] == "beta" and LocalPlayer():GetNWInt("playerBetaTimePlayed") < 10800 then
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
                            else
                                specialModelsUnlocked = specialModelsUnlocked + 1
                                modelsUnlocked = modelsUnlocked + 1
                            end

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

                        if v[4] == "headshot" or v[4] == "smackdown" or v[4] == "clutch" or v[4] == "longshot" or v[4] == "pointblank" or v[4] == "killstreaks" or v[4] == "buzzkills" or v[4] == "revenge" then
                            local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                            icon:SetModel(v[1])
                            icon:SetTooltip(v[2] .. "\n" .. v[3])
                            icon:SetSize(150, 150)
                            AccoladeModelList:Add(icon)

                            accoladeModelsTotal = accoladeModelsTotal + 1

                            if v[4] == "headshot" and LocalPlayer():GetNWInt("playerAccoladeHeadshot") < v[5] or v[4] == "smackdown" and LocalPlayer():GetNWInt("playerAccoladeSmackdown") < v[5] or v[4] == "clutch" and LocalPlayer():GetNWInt("playerAccoladeClutch") < v[5] or v[4] == "longshot" and LocalPlayer():GetNWInt("playerAccoladeLongshot") < v[5] or v[4] == "pointblank" and LocalPlayer():GetNWInt("playerAccoladePointblank") < v[5] or v[4] == "killstreaks" and LocalPlayer():GetNWInt("playerAccoladeOnStreak") < v[5] or v[4] == "buzzkills" and LocalPlayer():GetNWInt("playerAccoladeBuzzkill") < v[5] or v[4] == "revenge" and LocalPlayer():GetNWInt("playerAccoladeRevenge") < v[5] then
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
                        draw.SimpleText("Default", "OptionsHeader", w / 2, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        draw.SimpleText(defaultModelsUnlocked .. " / " .. defaultModelsTotal, "Health", w / 2, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                    end

                    TextKills.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Kills", "OptionsHeader", w / 2, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)

                        if killModelsUnlocked == killModelsTotal then
                            draw.SimpleText(killModelsUnlocked .. " / " .. killModelsTotal, "Health", w / 2, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(killModelsUnlocked .. " / " .. killModelsTotal, "Health", w / 2, 55, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        end
                    end

                    TextStreak.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Streaks", "OptionsHeader", w / 2, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)

                        if streakModelsUnlocked == streakModelsTotal then
                            draw.SimpleText(streakModelsUnlocked .. " / " .. streakModelsTotal, "Health", w / 2, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(streakModelsUnlocked .. " / " .. streakModelsTotal, "Health", w / 2, 55, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        end
                    end

                    TextAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Accolades", "OptionsHeader", w / 2, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)

                        if accoladeModelsUnlocked == accoladeModelsTotal then
                            draw.SimpleText(accoladeModelsUnlocked .. " / " .. accoladeModelsTotal, "Health", w / 2, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(accoladeModelsUnlocked .. " / " .. accoladeModelsTotal, "Health", w / 2, 55, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        end
                    end

                    TextSpecial.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("Special", "OptionsHeader", w / 2, 0, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)

                        if specialModelsUnlocked == specialModelsTotal then
                            draw.SimpleText(specialModelsUnlocked .. " / " .. specialModelsTotal, "Health", w / 2, 55, Color(0, 250, 0, 255), TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(specialModelsUnlocked .. " / " .. specialModelsTotal, "Health", w / 2, 55, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        end
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

                    DockModelsAccolade.Paint = function(self, w, h)
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
                            CustomizeSlideoutPanel:Hide()
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
                                CustomizeSlideoutPanel:Hide()
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
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        end

                        if newModelUnlockType == "headshot" then
                            if LocalPlayer():GetNWInt("playerAccoladeHeadshot") < newModelUnlockValue then
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

                        if newModelUnlockType == "smackdown" then
                            if LocalPlayer():GetNWInt("playerAccoladeSmackdown") < newModelUnlockValue then
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

                        if newModelUnlockType == "clutch" then
                            if LocalPlayer():GetNWInt("playerAccoladeClutch") < newModelUnlockValue then
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

                        if newModelUnlockType == "longshot" then
                            if LocalPlayer():GetNWInt("playerAccoladeLongshot") < newModelUnlockValue then
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

                        if newModelUnlockType == "pointblank" then
                            if LocalPlayer():GetNWInt("playerAccoladePointblank") < newModelUnlockValue then
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

                        if newModelUnlockType == "killstreaks" then
                            if LocalPlayer():GetNWInt("playerAccoladeOnStreak") < newModelUnlockValue then
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

                        if newModelUnlockType == "buzzkills" then
                            if LocalPlayer():GetNWInt("playerAccoladeBuzzkill") < newModelUnlockValue then
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

                        if newModelUnlockType == "revenge" then
                            if LocalPlayer():GetNWInt("playerAccoladeRevenge") < newModelUnlockValue then
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

                        if newModelUnlockType == "special" and newModelUnlockValue == "name" then
                            if LocalPlayer():SteamID() == "STEAM_0:1:514443768" then
                                surface.PlaySound("common/wpn_select.wav")
                                RunConsoleCommand("tm_selectplayermodel", newModel, newModelUnlockType, newModelUnlockValue)
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            else
                                surface.PlaySound("common/wpn_denyselect.wav")
                            end
                        end

                        if newModelUnlockType == "special" and newModelUnlockValue == "beta" then
                            if LocalPlayer():GetNWInt("playerBetaTimePlayed") < 10800 then
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
                        CustomizeScroller:ScrollToChild(TextDefault)
                    end

                    local KillsJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    KillsJump:SetPos(4, 152)
                    KillsJump:SetSize(48, 48)
                    KillsJump:SetImage("icons/uikillicon.png")
                    KillsJump:SetTooltip("Kills")
                    KillsJump.DoClick = function()
                        CustomizeScroller:ScrollToChild(TextKills)
                    end

                    local StreaksJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    StreaksJump:SetPos(4, 204)
                    StreaksJump:SetSize(48, 48)
                    StreaksJump:SetImage("icons/streakicon.png")
                    StreaksJump:SetTooltip("Streaks")
                    StreaksJump.DoClick = function()
                        CustomizeScroller:ScrollToChild(TextStreak)
                    end

                    local AccoladeJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    AccoladeJump:SetPos(4, 256)
                    AccoladeJump:SetSize(48, 48)
                    AccoladeJump:SetImage("icons/accoladeicon.png")
                    AccoladeJump:SetTooltip("Accolades")
                    AccoladeJump.DoClick = function()
                        CustomizeScroller:ScrollToChild(TextAccolade)
                    end

                    local SpecialJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    SpecialJump:SetPos(4, 305)
                    SpecialJump:SetSize(48, 48)
                    SpecialJump:SetImage("icons/specialicon.png")
                    SpecialJump:SetTooltip("Special")
                    SpecialJump.DoClick = function()
                        CustomizeScroller:ScrollToChild(TextSpecial)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
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
                draw.DrawText("OPTIONS", "AmmoCountSmall", 5 + textAnim, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            end
            OptionsButton.DoClick = function()
                MainPanel:Hide()

                if not IsValid(OptionsPanel) then
                    local OptionsPanel = MainMenu:Add("OptionsPanel")
                    local OptionsSlideoutPanel = MainMenu:Add("OptionsSlideoutPanel")

                    local OptionsQuickjumpHolder = vgui.Create("DPanel", OptionsSlideoutPanel)
                    OptionsQuickjumpHolder:Dock(TOP)
                    OptionsQuickjumpHolder:SetSize(0, ScrH())

                    OptionsQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 200))
                    end

                    local OptionsScroller = vgui.Create("DScrollPanel", OptionsPanel)
                    OptionsScroller:Dock(FILL)

                    local sbar = OptionsScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50, 200))
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local DockInputs = vgui.Create("DPanel", OptionsScroller)
                    DockInputs:Dock(TOP)
                    DockInputs:SetSize(0, 200)

                    local DockUI = vgui.Create("DPanel", OptionsScroller)
                    DockUI:Dock(TOP)
                    DockUI:SetSize(0, 520)

                    local DockAudio = vgui.Create("DPanel", OptionsScroller)
                    DockAudio:Dock(TOP)
                    DockAudio:SetSize(0, 440)

                    local DockViewmodel = vgui.Create("DPanel", OptionsScroller)
                    DockViewmodel:Dock(TOP)
                    DockViewmodel:SetSize(0, 325)

                    local DockCrosshair = vgui.Create("DPanel", OptionsScroller)
                    DockCrosshair:Dock(TOP)
                    DockCrosshair:SetSize(0, 675)

                    local DockHitmarker = vgui.Create("DPanel", OptionsScroller)
                    DockHitmarker:Dock(TOP)
                    DockHitmarker:SetSize(0, 315)

                    local DockScopes = vgui.Create("DPanel", OptionsScroller)
                    DockScopes:Dock(TOP)
                    DockScopes:SetSize(0, 195)

                    local DockPerformance = vgui.Create("DPanel", OptionsScroller)
                    DockPerformance:Dock(TOP)
                    DockPerformance:SetSize(0, 360)

                    local SettingsCog = vgui.Create("DImage", OptionsQuickjumpHolder)
                    SettingsCog:SetPos(12, 12)
                    SettingsCog:SetSize(32, 32)
                    SettingsCog:SetImage("icons/settingsicon.png")

                    local InputsJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    InputsJump:SetPos(4, 100)
                    InputsJump:SetSize(48, 48)
                    InputsJump:SetTooltip("Inputs")
                    InputsJump:SetImage("icons/mouseicon.png")
                    InputsJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockInputs)
                    end

                    local UIJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    UIJump:SetPos(4, 152)
                    UIJump:SetSize(48, 48)
                    UIJump:SetTooltip("UI")
                    UIJump:SetImage("icons/uiicon.png")
                    UIJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockUI)
                    end

                    local AudioJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    AudioJump:SetPos(4, 204)
                    AudioJump:SetSize(48, 48)
                    AudioJump:SetTooltip("Audio")
                    AudioJump:SetImage("icons/audioicon.png")
                    AudioJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockAudio)
                    end

                    local ModelJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    ModelJump:SetPos(4, 256)
                    ModelJump:SetSize(48, 48)
                    ModelJump:SetTooltip("Viewmodel")
                    ModelJump:SetImage("icons/weaponicon.png")
                    ModelJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockViewmodel)
                    end

                    local CrosshairJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    CrosshairJump:SetPos(4, 308)
                    CrosshairJump:SetSize(48, 48)
                    CrosshairJump:SetTooltip("Crosshair")
                    CrosshairJump:SetImage("icons/crosshairicon.png")
                    CrosshairJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockCrosshair)
                    end

                    local HitmarkerJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    HitmarkerJump:SetPos(4, 360)
                    HitmarkerJump:SetSize(48, 48)
                    HitmarkerJump:SetTooltip("Hitmarkers")
                    HitmarkerJump:SetImage("icons/hitmarkericon.png")
                    HitmarkerJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockHitmarker)
                    end

                    local ScopesJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    ScopesJump:SetPos(4, 412)
                    ScopesJump:SetSize(48, 48)
                    ScopesJump:SetTooltip("Scopes")
                    ScopesJump:SetImage("icons/sighticon.png")
                    ScopesJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockScopes)
                    end

                    local PerformanceJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    PerformanceJump:SetPos(4, 464)
                    PerformanceJump:SetSize(48, 48)
                    PerformanceJump:SetTooltip("Performance")
                    PerformanceJump:SetImage("icons/performanceicon.png")
                    PerformanceJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockPerformance)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, ScrH() - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout.DoClick = function()
                        MainPanel:Show()
                        OptionsSlideoutPanel:Hide()
                        OptionsPanel:Hide()
                    end

                    DockInputs.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("INPUT", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

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

                        draw.SimpleText("Enable UI", "SettingsLabel", 55, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Kill UI", "SettingsLabel", 55, 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Death UI", "SettingsLabel", 55, 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Health Anchor", "SettingsLabel", 125, 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Ammo Style", "SettingsLabel", 125, 225, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Velocity Counter", "SettingsLabel", 55, 265, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Kill UI Accolades", "SettingsLabel", 55, 305, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Reload Hints", "SettingsLabel", 55, 345, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill UI Anchor", "SettingsLabel", 125, 385, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Death UI Anchor", "SettingsLabel", 125, 425, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local enableUIButton = DockUI:Add("DCheckBox")
                    enableUIButton:SetPos(20, 70)
                    enableUIButton:SetConVar("tm_enableui")
                    enableUIButton:SetSize(30, 30)

                    local enableKillUIButton = DockUI:Add("DCheckBox")
                    enableKillUIButton:SetPos(20, 110)
                    enableKillUIButton:SetConVar("tm_enablekillpopup")
                    enableKillUIButton:SetValue(true)
                    enableKillUIButton:SetSize(30, 30)

                    local enableDeathUIButton = DockUI:Add("DCheckBox")
                    enableDeathUIButton:SetPos(20, 150)
                    enableDeathUIButton:SetConVar("tm_enabledeathpopup")
                    enableDeathUIButton:SetValue(true)
                    enableDeathUIButton:SetSize(30, 30)

                    local healthAnchor = DockUI:Add("DComboBox")
                    healthAnchor:SetPos(20, 190)
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
                    ammoStyle:SetPos(20, 230)
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
                    velocityToggle:SetPos(20, 270)
                    velocityToggle:SetConVar("tm_showspeed")
                    velocityToggle:SetValue(true)
                    velocityToggle:SetSize(30, 30)

                    local accoladeToggle = DockUI:Add("DCheckBox")
                    accoladeToggle:SetPos(20, 310)
                    accoladeToggle:SetConVar("tm_enableaccolades")
                    accoladeToggle:SetValue(true)
                    accoladeToggle:SetSize(30, 30)

                    local reloadHintsToggle = DockUI:Add("DCheckBox")
                    reloadHintsToggle:SetPos(20, 350)
                    reloadHintsToggle:SetConVar("tm_reloadhints")
                    reloadHintsToggle:SetValue(true)
                    reloadHintsToggle:SetSize(30, 30)

                    local killUIAnchor = DockUI:Add("DComboBox")
                    killUIAnchor:SetPos(20, 390)
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
                    deathUIAnchor:SetPos(20, 430)
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

                    local HUDEditorButton = vgui.Create("DButton", DockUI)
                    HUDEditorButton:SetPos(20, 470)
                    HUDEditorButton:SetText("")
                    HUDEditorButton:SetSize(500, 40)
                    local textAnim = 0
                    HUDEditorButton.Paint = function()
                        if HUDEditorButton:IsHovered() then
                            textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 25)
                        else
                            textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 25)
                        end
                        draw.DrawText("Open HUD Editor", "SettingsLabel", 0 + textAnim, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    end
                    HUDEditorButton.DoClick = function()
                    end

                    DockAudio.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("AUDIO", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable Hit Sounds", "SettingsLabel", 55, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Kill Sounds", "SettingsLabel", 55, 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hit Sound Style", "SettingsLabel", 125, 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill Sound Style", "SettingsLabel", 125, 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Menu Music", "SettingsLabel", 55, 225, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Menu Music Volume", "SettingsLabel", 155, 265, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Community Requested Menu Music", "SettingsLabel", 55, 305, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Game End Music", "SettingsLabel", 55, 345, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Game End Music Volume", "SettingsLabel", 155, 385, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local hitSoundsButton = DockAudio:Add("DCheckBox")
                    hitSoundsButton:SetPos(20, 70)
                    hitSoundsButton:SetConVar("tm_hitsounds")
                    hitSoundsButton:SetSize(30, 30)

                    local killSoundButton = DockAudio:Add("DCheckBox")
                    killSoundButton:SetPos(20, 110)
                    killSoundButton:SetConVar("tm_killsound")
                    killSoundButton:SetSize(30, 30)

                    local hitSoundsType = DockAudio:Add("DComboBox")
                    hitSoundsType:SetPos(20, 150)
                    hitSoundsType:SetSize(100, 30)
                    if CLIENT and GetConVar("tm_hitsoundtype"):GetInt() == 0 then
                        hitSoundsType:SetValue("Rust")
                    end
                    hitSoundsType:AddChoice("Rust")
                    hitSoundsType.OnSelect = function(self, value)
                        RunConsoleCommand("tm_hitsoundtype", value - 1)
                    end

                    local killSoundsType = DockAudio:Add("DComboBox")
                    killSoundsType:SetPos(20, 190)
                    killSoundsType:SetSize(100, 30)
                    if CLIENT and GetConVar("tm_killsoundtype"):GetInt() == 0 then
                        killSoundsType:SetValue("Call Of Duty")
                    end
                    killSoundsType:AddChoice("Call Of Duty")
                    killSoundsType.OnSelect = function(self, value)
                        RunConsoleCommand("tm_killsoundtype", value - 1)
                    end

                    local menuMusicButton = DockAudio:Add("DCheckBox")
                    menuMusicButton:SetPos(20, 230)
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
                    menuMusicVolume:SetPos(-85, 270)
                    menuMusicVolume:SetSize(250, 30)
                    menuMusicVolume:SetConVar("tm_menumusicvolume")
                    menuMusicVolume:SetMin(0)
                    menuMusicVolume:SetMax(1)
                    menuMusicVolume:SetDecimals(2)

                    menuMusicVolume.OnValueChanged = function(self, value)
                        menuMusic:ChangeVolume(GetConVar("tm_menumusicvolume"):GetFloat() / 4)
                    end

                    local communityMusicButton = DockAudio:Add("DCheckBox")
                    communityMusicButton:SetPos(20, 310)
                    communityMusicButton:SetConVar("tm_communitymusic")
                    communityMusicButton:SetSize(30, 30)

                    local gameEndMusicButton = DockAudio:Add("DCheckBox")
                    gameEndMusicButton:SetPos(20, 350)
                    gameEndMusicButton:SetConVar("tm_gameendmusic")
                    gameEndMusicButton:SetSize(30, 30)

                    local gameEndMusicVolume = DockAudio:Add("DNumSlider")
                    gameEndMusicVolume:SetPos(-85, 390)
                    gameEndMusicVolume:SetSize(250, 30)
                    gameEndMusicVolume:SetConVar("tm_gameendmusicvolume")
                    gameEndMusicVolume:SetMin(0)
                    gameEndMusicVolume:SetMax(1)
                    gameEndMusicVolume:SetDecimals(2)

                    DockViewmodel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("WEAPONRY", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("VM FOV Multiplier", "SettingsLabel", 155, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Centered Gun", "SettingsLabel", 55, 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Weapon Bobbing Multiplier", "SettingsLabel", 155, 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Flashlight Color", "SettingsLabel", 245, 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
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

                    local flashlightMixer = vgui.Create("DColorMixer", DockViewmodel)
                    flashlightMixer:SetPos(20, 190)
                    flashlightMixer:SetSize(215, 110)
                    flashlightMixer:SetConVarR("tpf_cl_color_red")
                    flashlightMixer:SetConVarG("tpf_cl_color_green")
                    flashlightMixer:SetConVarB("tpf_cl_color_blue")
                    flashlightMixer:SetAlphaBar(false)
                    flashlightMixer:SetPalette(false)
                    flashlightMixer:SetWangs(true)

                    DockCrosshair.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("CROSSHAIR", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable Crosshair", "SettingsLabel", 55 , 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
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

                        draw.SimpleText("Enable Hitmarkers", "SettingsLabel", 55 , 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
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

                        draw.SimpleText("Reticle Color", "SettingsLabel", 245 , 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local scopeMixer = vgui.Create("DColorMixer", DockScopes)
                    scopeMixer:SetPos(20, 70)
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
                        draw.SimpleText("Flashlight Shadows", "SettingsLabel", 55 , 305, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
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

                    local flashlightShadows = DockPerformance:Add("DCheckBox")
                    flashlightShadows:SetPos(20, 310)
                    flashlightShadows:SetConVar("tpf_cl_shadows")
                    flashlightShadows:SetValue(true)
                    flashlightShadows:SetSize(30, 30)
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
end
concommand.Add("tm_openmainmenu", mainMenu)

function ShowLoadoutOnSpawn()
    for k, v in pairs(weaponsArr) do
        if v[1] == LocalPlayer():GetNWString("loadoutPrimary") then
            primaryWeapon = v[2]
        end
        if v[1] == LocalPlayer():GetNWString("loadoutSecondary") then
            secondaryWeapon = v[2]
        end
        if v[1] == LocalPlayer():GetNWString("loadoutMelee") then
            meleeWeapon = v[2]
        end
    end

    notification.AddProgress("LoadoutText", "Current Loadout:\n" .. primaryWeapon .. "\n" .. secondaryWeapon .. "\n" .. meleeWeapon)
    timer.Simple(3, function()
        notification.Kill("LoadoutText")
    end)
end
concommand.Add("tm_showloadout", ShowLoadoutOnSpawn)


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
    self:SetSize(475, ScrH())
    self:SetPos(56, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CustomizePanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(400, ScrH())
    self:SetPos(531, 0)
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
    self:SetSize(656, ScrH())
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("HUDEditorPanel", PANEL, "Panel")