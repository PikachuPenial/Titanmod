local MainMenu

function mainMenu()
    local client = LocalPlayer()
    local spawnTimeLeft
    local spawnTimeLeftClean

    if timer.Exists(client:SteamID() .. "respawnTime") then
        spawnTimeLeft = timer.TimeLeft(LocalPlayer():SteamID() .. "respawnTime")
        spawnTimeLeftClean = math.Round(spawnTimeLeft, 2)
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

            if timer.Exists(client:SteamID() .. "respawnTime") then
                draw.SimpleText(spawnTimeLeftClean, "AmmoCount", 50, 50, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
            end
        end

        local musicList = {"music/lsplash_chillwave.wav", "music/chris_c418.wav"}
        local menuMusic = CreateSound(client, musicList[math.random(#musicList)])

        menuMusic:Play()
        menuMusic:ChangeVolume(0.1)

        gui.EnableScreenClicker(true)

        LocalPlayer():SetNWBool("mainmenu", true)

        print(LocalPlayer():GetNWBool("mainmenu"))

        local MainPanel = MainMenu:Add("MainPanel")
            Logo = vgui.Create("DImage", MainPanel)
            Logo:SetPos(5, ScrH() - 740)
            Logo:SetSize(576, 256)
            Logo:SetImage("mainmenu/logo.png")

            local SpawnButton = vgui.Create("DImageButton", MainPanel)
            SpawnButton:SetPos(0, ScrH() - 455)
            SpawnButton:SetImage("mainmenu/spawnbutton.png")
            SpawnButton:SizeToContents()
            SpawnButton.DoClick = function()
                MainMenu:Remove(false)
                gui.EnableScreenClicker(false)
                menuMusic:FadeOut(4)

                LocalPlayer():Spawn()
                LocalPlayer():SetNWBool("mainmenu", false)
            end

            local CustomizeButton = vgui.Create("DImageButton", MainPanel)
            CustomizeButton:SetPos(0, ScrH() - 345)
            CustomizeButton:SetImage("mainmenu/customizebutton.png")
            CustomizeButton:SizeToContents()
            CustomizeButton.DoClick = function()
                MsgN("You clicked the image!")
            end

            local OptionsButton = vgui.Create("DImageButton", MainPanel)
            OptionsButton:SetPos(0, ScrH() - 235)
            OptionsButton:SetImage("mainmenu/optionsbutton.png")
            OptionsButton:SizeToContents()
            OptionsButton.DoClick = function()
                local margin = math.Round( ScrH() * 0.01 )

                if not IsValid(OptionsPanel) then
                    local OptionsPanel = MainMenu:Add("OptionsPanel")

                    local OptionsScroller = vgui.Create("DScrollPanel", OptionsPanel)
                    OptionsScroller:Dock(FILL)

                    OptionsScroller:SetKeyboardInputEnabled(true)

                    local OptionsTextHolder = vgui.Create("DPanel", OptionsScroller)
                    OptionsTextHolder:Dock(TOP)
                    OptionsTextHolder:SetSize(0, 200)

                    OptionsTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("OPTIONS", "AmmoCount", w / 2, 20, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        draw.SimpleText("Tweak your experience.", "PlayerNotiName", w / 2, 130, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                    end

                    local DockUI = vgui.Create("DPanel", OptionsScroller)
                    DockUI:Dock(TOP)
                    DockUI:SetSize(0, 280)

                    local DockAudio = vgui.Create("DPanel", OptionsScroller)
                    DockAudio:Dock(TOP)
                    DockAudio:SetSize(0, 120)

                    local DockViewmodel = vgui.Create("DPanel", OptionsScroller)
                    DockViewmodel:Dock(TOP)
                    DockViewmodel:SetSize(0, 160)

                    local DockCrosshair = vgui.Create("DPanel", OptionsScroller)
                    DockCrosshair:Dock(TOP)
                    DockCrosshair:SetSize(0, 600)

                    local DockScopes = vgui.Create("DPanel", OptionsScroller)
                    DockScopes:Dock(TOP)
                    DockScopes:SetSize(0, 320)

                    DockUI.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("UI", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable UI", "SettingsLabel", 55, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Kill Popup", "SettingsLabel", 55, 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Death Popup", "SettingsLabel", 55, 145, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Health Anchor", "SettingsLabel", 125, 185, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Ammo Style", "SettingsLabel", 125, 225, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
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
                    healthAnchor:SetValue("Select...")
                    healthAnchor:AddChoice("Left Side")
                    healthAnchor:AddChoice("Middle")
                    healthAnchor.OnSelect = function(self, value)
                        RunConsoleCommand("tm_healthanchor", value - 1)
                    end

                    local ammoStyle = DockUI:Add("DComboBox")
                    ammoStyle:SetPos(20, 230)
                    ammoStyle:SetSize(100, 30)
                    ammoStyle:SetValue("Select...")
                    ammoStyle:AddChoice("Numeric")
                    ammoStyle:AddChoice("Bar")
                    ammoStyle.OnSelect = function(self, value)
                        RunConsoleCommand("tm_ammostyle", value - 1)
                    end

                    DockAudio.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("AUDIO", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Hitsounds", "SettingsLabel", 55, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local hitSoundsButton = DockAudio:Add("DCheckBox")
                    hitSoundsButton:SetPos(20, 70)
                    hitSoundsButton:SetConVar("tm_hitsounds")
                    hitSoundsButton:SetSize(30, 30)

                    DockViewmodel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("MODEL", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Viewmodel FOV Multiplier", "SettingsLabel", 165, 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Centered Gun", "SettingsLabel", 55, 105, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
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

                    DockCrosshair.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("CROSSHAIR", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Crosshair Color", "SettingsLabel", 290 , 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarkers", "SettingsLabel", 55 , 315, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker Color", "SettingsLabel", 290 , 355, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local crosshairMixer = vgui.Create("DColorMixer", DockCrosshair)
                    crosshairMixer:SetPos(20, 70)
                    crosshairMixer:SetConVarR("cl_tfa_hud_crosshair_color_r")
                    crosshairMixer:SetConVarG("cl_tfa_hud_crosshair_color_g")
                    crosshairMixer:SetConVarB("cl_tfa_hud_crosshair_color_b")
                    crosshairMixer:SetConVarA("cl_tfa_hud_crosshair_color_a")
                    crosshairMixer:SetAlphaBar(true)
                    crosshairMixer:SetPalette(true)
                    crosshairMixer:SetWangs(true)

                    local hitmarkerToggle = DockCrosshair:Add("DCheckBox")
                    hitmarkerToggle:SetPos(20, 320)
                    hitmarkerToggle:SetConVar("cl_tfa_hud_hitmarker_enabled")
                    hitmarkerToggle:SetValue(true)
                    hitmarkerToggle:SetSize(30, 30)

                    local hitmarkerMixer = vgui.Create("DColorMixer", DockCrosshair)
                    hitmarkerMixer:SetPos(20, 360)
                    hitmarkerMixer:SetConVarR("cl_tfa_hud_hitmarker_color_r")
                    hitmarkerMixer:SetConVarG("cl_tfa_hud_hitmarker_color_g")
                    hitmarkerMixer:SetConVarB("cl_tfa_hud_hitmarker_color_b")
                    hitmarkerMixer:SetConVarA("cl_tfa_hud_hitmarker_color_a")
                    hitmarkerMixer:SetAlphaBar(true)
                    hitmarkerMixer:SetPalette(true)
                    hitmarkerMixer:SetWangs(true)

                    DockScopes.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("SCOPES", "OptionsHeader", 20, 0, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Reticle Color", "SettingsLabel", 290 , 65, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local scopeMixer = vgui.Create("DColorMixer", DockScopes)
                    scopeMixer:SetPos(20, 70)
                    scopeMixer:SetConVarR("cl_tfa_reticule_color_r")
                    scopeMixer:SetConVarG("cl_tfa_reticule_color_g")
                    scopeMixer:SetConVarB("cl_tfa_reticule_color_b")
                    scopeMixer:SetAlphaBar(true)
                    scopeMixer:SetPalette(true)
                    scopeMixer:SetWangs(true)
                end
            end

            local ExitButton = vgui.Create("DImageButton", MainPanel)
            ExitButton:SetPos(0, ScrH() - 125)
            ExitButton:SetImage("mainmenu/exitbutton.png")
            ExitButton:SizeToContents()
            ExitButton.DoClick = function()
                RunConsoleCommand("disconnect")
            end

    end
end
concommand.Add("tm_openmainmenu", mainMenu)

PANEL = {}
function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:SetPos(0, 0)
end
vgui.Register("MainPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(ScrW() / 3.4, ScrH())
    self:SetPos(ScrW() / 3, 0)
end
vgui.Register("OptionsPanel", PANEL, "Panel")