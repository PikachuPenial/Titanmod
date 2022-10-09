net.Receive("NotifyKill", function(len, ply)
    local killedPlayer = net.ReadEntity()

    if IsValid(KillNotif) then
        KillNotif:Hide()

        KillNotif = vgui.Create("DFrame")
        KillNotif:SetSize(400, 100)
        KillNotif:SetX(ScrW() / 2 - 200)
        KillNotif:SetY(ScrH() - 335)
        KillNotif:SetTitle("")
        KillNotif:SetDraggable(false)
        KillNotif:ShowCloseButton(false)
        KillNotif.Paint = function()
            draw.SimpleText(killedPlayer:GetName(), "PlayerNotiName", 200, 50, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(killedPlayer:GetName(), "PlayerNotiName", 200, 50, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

        KillIcon = vgui.Create("DImage", KillNotif)
        KillIcon:SetPos(175, 0)
        KillIcon:SetSize(50, 50)
        KillIcon:SetImage("icons/killicon.png")

        KillNotif:Show()
        KillNotif:MakePopup()
        KillNotif:SetMouseInputEnabled(false)
        KillNotif:SetKeyboardInputEnabled(false)

        surface.PlaySound("hitsound/killsound.wav")

        timer.Create("killNotification", 3, 1, function()
            KillNotif:Hide()
            notiAlreadyActive = false
        end)
    else
        KillNotif = vgui.Create("DFrame")
        KillNotif:SetSize(400, 100)
        KillNotif:SetX(ScrW() / 2 - 200)
        KillNotif:SetY(ScrH() - 335)
        KillNotif:SetTitle("")
        KillNotif:SetDraggable(false)
        KillNotif:ShowCloseButton(false)
        KillNotif.Paint = function()
            draw.RoundedBox(5, 0, 0, KillNotif:GetWide(), KillNotif:GetTall(), Color(80, 80, 80, 0))
            draw.SimpleText(killedPlayer:GetName(), "PlayerNotiName", 200, 50, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

        KillIcon = vgui.Create("DImage", KillNotif)
        KillIcon:SetPos(175, 0)
        KillIcon:SetSize(50, 50)
        KillIcon:SetImage("icons/killicon.png")

        KillNotif:Show()
        KillNotif:MakePopup()
        KillNotif:SetMouseInputEnabled(false)
        KillNotif:SetKeyboardInputEnabled(false)

        surface.PlaySound("hitsound/killsound.wav")

        timer.Create("killNotification", 3, 1, function()
            KillNotif:Hide()
            notiAlreadyActive = false
        end)
    end
end )

net.Receive("DeathHud", function(len, ply)
    local killedBy = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()

    if IsValid(KillNotif) then
        KillNotif:Hide()
        notiAlreadyActive = false
    end

    DeathNotif = vgui.Create("DFrame")
    DeathNotif:SetSize(800, 130)
    DeathNotif:SetX(ScrW() / 2 - 400)
    DeathNotif:SetY(ScrH() - 350)
    DeathNotif:SetTitle("")
    DeathNotif:SetDraggable(false)
    DeathNotif:ShowCloseButton(false)

    DeathNotif.Paint = function()
        if killedBy == nil or killedWith == nil then
            draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 100))
            draw.SimpleText("You commited suicide!", "Trebuchet18", 200, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        else
            draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 0))
            draw.SimpleText("Killed by", "Trebuchet18", 400, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("|", "PlayerDeathName", 400, 65.5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("|", "PlayerDeathName", 400, 90, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(killedBy:GetName(), "PlayerDeathName", 390, 67.5, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            draw.SimpleText(killedWith, "PlayerDeathName", 410, 67.5, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            draw.SimpleText(killedBy:Health() .. "HP", "WepNameKill", 390, 100, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            draw.SimpleText(killedFrom .. "m", "WepNameKill", 410, 100, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        end
    end

    playerProfilePicture = vgui.Create("AvatarImage", DeathNotif)
    playerProfilePicture:SetPos(375, 20)
    playerProfilePicture:SetSize(50, 50)
    playerProfilePicture:SetPlayer(killedBy, 184)

    DeathNotif:Show()
    DeathNotif:MakePopup()
    DeathNotif:SetMouseInputEnabled(false)
    DeathNotif:SetKeyboardInputEnabled(false)

    timer.Create("respawnTimeHideHud", 5, 1, function()
        DeathNotif:Hide()
    end)
end )