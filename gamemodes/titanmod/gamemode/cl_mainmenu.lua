local MainMenu

function mainMenu()
    if not IsValid(MainMenu) then
        MainMenu = vgui.Create("DFrame")
        MainMenu:SetSize(ScrW(), ScrH())
        MainMenu:Center()
        MainMenu:SetTitle("")
        MainMenu:SetDraggable(false)
        MainMenu:ShowCloseButton(false)
        MainMenu:SetDeleteOnClose(false)
        MainMenu.Paint = function()
            surface.SetDrawColor(40, 40, 40, 200)
            surface.DrawRect(0, 0, MainMenu:GetWide(), MainMenu:GetTall())
        end

        gui.EnableScreenClicker(true)
        MainMenu:SetKeyboardInputEnabled(true)

        LocalPlayer():SetNWBool("mainmenu", true)

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
                if not IsValid(OptionsPanel) then
                    local OptionsPanel = MainMenu:Add("OptionsPanel")

                    OptionsPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
                        draw.SimpleText("OPTIONS", "AmmoCount", w / 2, 20, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)
                        draw.SimpleText("Tweak your experience.", "PlayerNotiName", w / 2, 130, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER)

                        draw.SimpleText("UI", "AmmoCount", 20, 200, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("AUDIO", "AmmoCount", 20, 540, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("MODEL", "AmmoCount", 20, 715, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable UI", "SettingsLabel", 65, 325, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Kill Popup", "SettingsLabel", 65, 365, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Enable Death Popup", "SettingsLabel", 65, 405, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Health Anchor", "SettingsLabel", 135, 445, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Ammo Style", "SettingsLabel", 135, 485, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Hitsounds", "SettingsLabel", 65, 660, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Viewmodel FOV Multiplier", "SettingsLabel", 165, 840, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                        draw.SimpleText("Centered Gun", "SettingsLabel", 65, 880, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT)
                    end

                    local enableUIButton = OptionsPanel:Add("DCheckBox")
                    enableUIButton:SetPos(30, 330)
                    enableUIButton:SetConVar("tm_enableui")
                    enableUIButton:SetSize(30, 30)

                    local enableKillUIButton = OptionsPanel:Add("DCheckBox")
                    enableKillUIButton:SetPos(30, 370)
                    enableKillUIButton:SetConVar("tm_enablekillpopup")
                    enableKillUIButton:SetValue(true)
                    enableKillUIButton:SetSize(30, 30)

                    local enableDeathUIButton = OptionsPanel:Add("DCheckBox")
                    enableDeathUIButton:SetPos(30, 410)
                    enableDeathUIButton:SetConVar("tm_enabledeathpopup")
                    enableDeathUIButton:SetValue(true)
                    enableDeathUIButton:SetSize(30, 30)

                    local healthAnchor = OptionsPanel:Add("DComboBox")
                    healthAnchor:SetPos(30, 450)
                    healthAnchor:SetSize(100, 30)
                    healthAnchor:SetValue("Select...")
                    healthAnchor:AddChoice("Left Side")
                    healthAnchor:AddChoice("Middle")
                    healthAnchor.OnSelect = function(self, value)
                        RunConsoleCommand("tm_healthanchor", value - 1)
                        print(value - 1)
                    end

                    local ammoStyle = OptionsPanel:Add("DComboBox")
                    ammoStyle:SetPos(30, 490)
                    ammoStyle:SetSize(100, 30)
                    ammoStyle:SetValue("Select...")
                    ammoStyle:AddChoice("Numeric")
                    ammoStyle:AddChoice("Bar")
                    ammoStyle.OnSelect = function(self, value)
                        RunConsoleCommand("tm_ammostyle", value - 1)
                        print(value - 1)
                    end

                    local hitSoundsButton = OptionsPanel:Add("DCheckBox")
                    hitSoundsButton:SetPos(30, 665)
                    hitSoundsButton:SetConVar("tm_enableui")
                    hitSoundsButton:SetSize(30, 30)

                    local viewmodelFOV = OptionsPanel:Add("DNumSlider")
                    viewmodelFOV:SetPos(-75, 845)
                    viewmodelFOV:SetSize(250, 30)
                    viewmodelFOV:SetConVar("cl_tfa_viewmodel_multiplier_fov")
                    viewmodelFOV:SetMin(1)
                    viewmodelFOV:SetMax(2)
                    viewmodelFOV:SetDecimals(2)

                    local centeredVM = OptionsPanel:Add("DCheckBox")
                    centeredVM:SetPos(30, 885)
                    centeredVM:SetConVar("cl_tfa_viewmodel_centered")
                    centeredVM:SetSize(30, 30)
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