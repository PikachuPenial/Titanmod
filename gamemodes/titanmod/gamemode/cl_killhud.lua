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
    local respawning = net.ReadBool()
    local killedBy = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()

    if respawning == false then
        KillNotif = vgui.Create("DFrame")
        KillNotif:SetSize(300, 130)
        KillNotif:SetX(ScrW() / 2 - 150)
        KillNotif:SetY(ScrH() - 350)
        KillNotif:SetTitle("")
        KillNotif:SetDraggable(false)
        KillNotif:ShowCloseButton(false)

        KillNotif.Paint = function()
            if killedBy == nil or killedWith == nil then
                draw.RoundedBox(5, 0, 0, KillNotif:GetWide(), KillNotif:GetTall(), Color(80, 80, 80, 100))
                draw.SimpleText("You commited suicide!", "Trebuchet18", 150, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            else
                draw.RoundedBox(5, 0, 0, KillNotif:GetWide(), KillNotif:GetTall(), Color(80, 80, 80, 100))
                draw.SimpleText("Killed by", "Trebuchet18", 150, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                draw.SimpleText(killedBy:GetName(), "PlayerNotiName", 150, 67.5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                draw.SimpleText(killedWith .. " | " .. killedFrom .. "m", "PlayerNotiName", 150, 95, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            end
        end

        playerProfilePicture = vgui.Create("AvatarImage", KillNotif)
        playerProfilePicture:SetPos(125, 20)
        playerProfilePicture:SetSize(50, 50)
        playerProfilePicture:SetPlayer(killedBy, 184)

        KillNotif:Show()
        KillNotif:MakePopup()
        KillNotif:SetMouseInputEnabled(false)
        KillNotif:SetKeyboardInputEnabled(false)
    else
        KillNotif:Hide()
    end
end )