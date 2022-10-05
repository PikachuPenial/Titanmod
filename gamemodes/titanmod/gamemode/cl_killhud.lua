net.Receive("NotifyKill", function(len, ply)
    local killedPlayer = net.ReadEntity()

    if IsValid(KillNotif) then
        KillNotif:Hide()

        KillNotif = vgui.Create("DFrame")
        KillNotif:SetSize(200, 60)
        KillNotif:SetX(ScrW() / 2 - 100)
        KillNotif:SetY(ScrH() - 200)
        KillNotif:SetTitle("")
        KillNotif:SetDraggable(false)
        KillNotif:ShowCloseButton(false)
        KillNotif.Paint = function()
            draw.RoundedBox(5, 0, 0, KillNotif:GetWide(), KillNotif:GetTall(), Color(80, 80, 80, 100))
            draw.SimpleText(killedPlayer:GetName(), "PlayerNotiName", 100, 10, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

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
        KillNotif:SetSize(200, 60)
        KillNotif:SetX(ScrW() / 2 - 100)
        KillNotif:SetY(ScrH() - 200)
        KillNotif:SetTitle("")
        KillNotif:SetDraggable(false)
        KillNotif:ShowCloseButton(false)
        KillNotif.Paint = function()
            draw.RoundedBox(5, 0, 0, KillNotif:GetWide(), KillNotif:GetTall(), Color(80, 80, 80, 100))
            draw.SimpleText(killedPlayer:GetName(), "PlayerNotiName", 100, 10, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

        KillNotif:Show()
        KillNotif:MakePopup()
        KillNotif:SetMouseInputEnabled(false)
        KillNotif:SetKeyboardInputEnabled(false)

        surface.PlaySound("hitsound/hit_reg_head.wav")

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

    DeathNotif = vgui.Create("DFrame")
    DeathNotif:SetSize(300, 130)
    DeathNotif:SetX(ScrW() / 2 - 150)
    DeathNotif:SetY(ScrH() - 350)
    DeathNotif:SetTitle("")
    DeathNotif:SetDraggable(false)
    DeathNotif:ShowCloseButton(false)

    DeathNotif.Paint = function()
        if killedBy == nil or killedWith == nil then
            draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 100))
            draw.SimpleText("You commited suicide!", "Trebuchet18", 150, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        else
            draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 100))
            draw.SimpleText("Killed by", "Trebuchet18", 150, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(killedBy:GetName(), "PlayerNotiName", 150, 67.5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(killedWith .. " | " .. killedFrom .. "m", "WepNameKill", 150, 95, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    playerProfilePicture = vgui.Create("AvatarImage", DeathNotif)
    playerProfilePicture:SetPos(125, 20)
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