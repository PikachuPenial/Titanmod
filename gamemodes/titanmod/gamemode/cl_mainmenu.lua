local MainMenu

function mainMenu()
    if (MainMenu == nil) then
    MainMenu = vgui.Create("DFrame")
        MainMenu:SetSize(600,500)
        MainMenu:Center()
        MainMenu:SetTitle("")
        MainMenu:SetDraggable(false)
        MainMenu:ShowCloseButton(false)
        MainMenu:SetDeleteOnClose(false)
        MainMenu.Paint = function()
            surface.SetDrawColor(40, 40, 40, 200)
            surface.DrawRect(0, 0, MainMenu:GetWide(), MainMenu:GetTall())

            surface.SetDrawColor(60, 60, 60, 200)
            surface.DrawRect(0, 24, MainMenu:GetWide(), MainMenu:GetTall())
        end

        mainMenuAddButtons(MainMenu)
        gui.EnableScreenClicker(true)
    else
        if (MainMenu:IsVisible()) then
            MainMenu:SetVisible(false)
            gui.EnableScreenClicker(false)
        else
            MainMenu:SetVisible(true)
            gui.EnableScreenClicker(true)
        end
    end
end
concommand.Add("tm_openmainmenu", mainMenu)

function mainMenuAddButtons()
    local spawnButton = vgui.Create("DButton")
    spawnButton:SetParent(MainMenu)
    spawnButton:SetText("Spawn")
    spawnButton:SetSize(125, 75)
    spawnButton:Center()
    spawnButton.Paint = function()
        surface.SetDrawColor(150, 150, 150, 255)
        surface.DrawRect(0, 0, spawnButton:GetWide(), spawnButton:GetTall())

        surface.SetDrawColor(100, 100, 100, 225)
        surface.DrawRect(0, 74, spawnButton:GetWide(), 1)
        surface.DrawRect(124, 0, 1, spawnButton:GetTall())
    end
end