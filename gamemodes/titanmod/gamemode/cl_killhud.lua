net.Receive("NotifyKill", function(len, ply)
    local killedPlayer = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()

    if IsValid(KillNotif) then
        KillNotif:Hide()
    end

    KillNotif = vgui.Create("DFrame")
    KillNotif:SetSize(400, 200)
    KillNotif:SetX(ScrW() / 2 - 200)
    KillNotif:SetY(ScrH() - 335)
    KillNotif:SetTitle("")
    KillNotif:SetDraggable(false)
    KillNotif:ShowCloseButton(false)

    if LocalPlayer():GetNWInt("killStreak") >= 2 then
        onstreak = "On Streak"
        onstreakScore = 10 * LocalPlayer():GetNWInt("killStreak") + 10
        onstreakIndent = " +"
        onstreakSeperator = " | "
    else
        onstreak = ""
        onstreakScore = ""
        onstreakIndent = ""
        onstreakSeperator = ""
    end

    if killedPlayer:GetNWInt("killStreak") >= 3 then
        buzzkill = "Buzz Kill"
        buzzkillScore = 10 * killedPlayer:GetNWInt("killStreak")
        buzzkillIndent = " +"
        buzzkillSeperator = " | "
    else
        buzzkill = ""
        buzzkillScore = ""
        buzzkillIndent = ""
        buzzkillSeperator = ""
    end

    if killedFrom >= 40 then
        marksman = "Marksman"
        marksmanScore = killedFrom
        marksmanIndent = " +"
        marksmanSeperator = " | "
    else
        marksman = ""
        marksmanScore = ""
        marksmanIndent = ""
        marksmanSeperator = ""
    end

    if killedFrom <= 3 then
        pointblank = "Point Blank"
        pointblankScore = 20
        pointblankIndent = " +"
        pointblankSeperator = " | "
    else
        pointblank = ""
        pointblankScore = ""
        pointblankIndent = ""
        pointblankSeperator = ""
    end

    if killedWith == "Tanto" or killedWith == "Japanese Ararebo" then
        smackdown = "Smackdown"
        smackdownScore = 20
        smackdownIndent = " +"
        smackdownSeperator = " | "
    else
        smackdown = ""
        smackdownScore = ""
        smackdownIndent = ""
        smackdownSeperator = ""
    end

    KillNotif.Paint = function()
        draw.SimpleText(LocalPlayer():GetNWInt("killStreak") .. " Kills", "StreakText", 200, 25, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(killedPlayer:GetName(), "PlayerNotiName", 200, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(onstreak .. onstreakIndent .. onstreakScore .. onstreakSeperator .. buzzkill .. buzzkillIndent .. buzzkillScore .. buzzkillSeperator .. marksman .. marksmanIndent .. marksmanScore .. marksmanSeperator .. pointblank .. pointblankIndent .. pointblankScore .. pointblankSeperator .. smackdown .. smackdownIndent .. smackdownScore, "StreakText", 200, 150, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end

    KillIcon = vgui.Create("DImage", KillNotif)
    KillIcon:SetPos(175, 50)
    KillIcon:SetSize(50, 50)
    KillIcon:SetImage("icons/killicon.png")

    KillNotif:Show()
    KillNotif:MakePopup()
    KillNotif:SetMouseInputEnabled(false)
    KillNotif:SetKeyboardInputEnabled(false)

    surface.PlaySound("hitsound/killsound.wav")

    timer.Create("killNotification", 3.5, 1, function()
        KillNotif:Hide()
        notiAlreadyActive = false
    end)
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
    DeathNotif:SetSize(800, 200)
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

            draw.SimpleText("Respawning in     ", "WepNameKill", 390, 145, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            if respawnTimeLeft ~= nil or respawnTimeLeft >= 5 or respawnTimeLeft <= 0 then
                draw.SimpleText(respawnTimeLeft .. "s", "WepNameKill", 465, 145, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            end
            draw.SimpleText("Press [F1 - F4] to open the menu", "WepNameKill", 400, 170, Color(255, 255, 255), TEXT_ALIGN_CENTER)
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
        timer.Remove("displaySpawnTimeRT")
    end)

    timer.Create("artificialDelay", 0.10, 1, function()
        if timer.Exists("respawnTimeHideHud") then
            timer.Create("displaySpawnTimeRT", 0.10, 0, function()
                respawnTimeLeft = math.Round(timer.TimeLeft("respawnTimeHideHud"), 1)
            end)
        end
    end)
end )