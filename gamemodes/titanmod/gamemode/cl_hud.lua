--Color array, saving space
local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)

local scrw = ScrW()
local scrh = ScrH()

local isAnimatingKill

function HUD()
	if CLIENT and GetConVar("tm_enableui"):GetInt() == 1 then
		local client = LocalPlayer()

		if !client:Alive() then
			return
		end

        if LocalPlayer():GetNWBool("mainmenu") == true then
            return
        end

        --Numeric Style
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 0 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() - 15, ScrH() - 60, white, TEXT_ALIGN_RIGHT, 0)
            end

            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("0", "AmmoCount", ScrW() - 15, ScrH() - 170, red, TEXT_ALIGN_RIGHT, 0)
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 175, red, TEXT_ALIGN_CENTER, 0)
            elseif (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() >= 0) then
                draw.SimpleText(client:GetActiveWeapon():Clip1(), "AmmoCount", ScrW() - 15, ScrH() - 170, white, TEXT_ALIGN_RIGHT, 0)
            end
        end

        --Bar Style
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 1 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() - 15, ScrH() - 100, white, TEXT_ALIGN_RIGHT, 0)
            end

            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 175, red, TEXT_ALIGN_CENTER, 0)
            end

            if (client:GetActiveWeapon():IsValid()) then
                surface.DrawRect(ScrW() - 420, ScrH() - 39, 400 * (client:GetActiveWeapon():Clip1() / client:GetActiveWeapon():GetMaxClip1()), 30)
            end
        end

        --Left Anchor
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 0 then
            surface.SetDrawColor(50, 50, 50, 255)
            surface.DrawRect(10, ScrH() - 38, 450 , 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100)
                else
                    surface.SetDrawColor(180, 180, 100)
                end
            else
                surface.SetDrawColor(100, 180, 100)
            end

            surface.DrawRect(10, ScrH() - 38, 450 * (client:Health() / client:GetMaxHealth()), 30)
            draw.SimpleText(client:Health(), "Health", 450, ScrH() - 39, white, TEXT_ALIGN_RIGHT, 0)
        end

        --Middle Anchor
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 1 then
            surface.SetDrawColor(50, 50, 50, 255)
            surface.DrawRect(ScrW() / 2 - 225, ScrH() - 38, 450 , 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100)
                else
                    surface.SetDrawColor(180, 180, 100)
                end
            else
                surface.SetDrawColor(100, 180, 100)
            end

            surface.DrawRect(ScrW() / 2 - 225, ScrH() - 38, 450 * (client:Health() / client:GetMaxHealth()), 30)
            draw.SimpleText(client:Health(), "Health", ScrW() / 2, ScrH() - 39, white, TEXT_ALIGN_CENTER, 0)
        end
    end
end
hook.Add("HUDPaint", "TestHud", HUD)

function DrawTarget()
    return false
end
hook.Add("HUDDrawTargetID", "HidePlayerInfo", DrawTarget)

function HideHud(name)
    for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudZoom", "CHudVoiceStatus"}) do
        if name == v then
            return false
        end
    end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)

function GM:PlayerStartVoice(ply)
    return
end

net.Receive("NotifyKill", function(len, ply)
    local killedPlayer = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()

    local seperator = ""

    if IsValid(KillNotif) then
        KillNotif:Hide()
    end

    KillNotif = vgui.Create("DFrame")
    KillNotif:SetSize(0, 200)
    KillNotif:SetX(ScrW() / 2 - 300)
    KillNotif:SetY(ScrH() - 335)
    KillNotif:SetTitle("")
    KillNotif:SetDraggable(false)
    KillNotif:ShowCloseButton(false)
    KillNotif:SizeTo(600, 200, 1, 0, 0.25)

    if LocalPlayer():GetNWInt("killStreak") >= 2 then
        onstreak = "On Streak"
        onstreakScore = 10 * LocalPlayer():GetNWInt("killStreak") + 10
        onstreakIndent = " +"
        onstreakSeperator = " | "
        seperator = "| "
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
        seperator = "| "
    else
        buzzkill = ""
        buzzkillScore = ""
        buzzkillIndent = ""
        buzzkillSeperator = ""
    end

    if killedFrom >= 40 then
        marksman = "Longshot"
        marksmanScore = killedFrom
        marksmanIndent = " +"
        marksmanSeperator = " | "
        seperator = "| "
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
        seperator = "| "
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
        seperator = "| "
    else
        smackdown = ""
        smackdownScore = ""
        smackdownIndent = ""
        smackdownSeperator = ""
    end

    print(hitgroup)
    if killedPlayer:GetNWInt("lastHitIn") == HITGROUP_HEAD then
        headshot = "Headshot"
        headshotScore = 20
        headshotIndent = " +"
        headshotSeperator = " | "
        seperator = "| "
    else
        headshot = ""
        headshotScore = ""
        headshotIndent = ""
        headshotSeperator = ""
    end

    KillNotif.Paint = function()
        draw.SimpleText(LocalPlayer():GetNWInt("killStreak") .. " Kills", "StreakText", 300, 25, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(killedPlayer:GetName(), "PlayerNotiName", 300, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(seperator .. headshot .. headshotIndent .. headshotScore .. headshotSeperator .. onstreak .. onstreakIndent .. onstreakScore .. onstreakSeperator .. buzzkill .. buzzkillIndent .. buzzkillScore .. buzzkillSeperator .. marksman .. marksmanIndent .. marksmanScore .. marksmanSeperator .. pointblank .. pointblankIndent .. pointblankScore .. pointblankSeperator .. smackdown .. smackdownIndent .. smackdownScore, "StreakText", 300, 150, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end

    KillIcon = vgui.Create("DImage", KillNotif)
    KillIcon:SetPos(275, 50)
    KillIcon:SetSize(50, 50)
    KillIcon:SetImage("icons/killicon.png")

    if killedPlayer:GetNWInt("lastHitIn") == HITGROUP_HEAD then
        KillIcon:SetImageColor(Color(255, 0, 0))
    end

    KillNotif:Show()
    KillNotif:MakePopup()
    KillNotif:SetMouseInputEnabled(false)
    KillNotif:SetKeyboardInputEnabled(false)

    surface.PlaySound("hitsound/killsound.wav")

    timer.Create("killNotification", 3.5, 1, function()
        KillNotif:SizeTo(0, 200, 1, 0.25, 0.25, function()
            KillNotif:Hide()
        end)
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

    timer.Create("respawnTimeHideHud", 4, 1, function()
        DeathNotif:Hide()
        timer.Remove("displaySpawnTimeRT")
    end)

    if timer.Exists("respawnTimeHideHud") then
        timer.Create("displaySpawnTimeRT", 0.10, 0, function()
            respawnTimeLeft = math.Round(timer.TimeLeft("respawnTimeHideHud"), 1)
        end)
    end

    DeathNotif = vgui.Create("DFrame")
    DeathNotif:SetSize(800, 200)
    DeathNotif:SetX(ScrW() / 2 - 400)
    DeathNotif:SetY(ScrH() - 350)
    DeathNotif:SetTitle("")
    DeathNotif:SetDraggable(false)
    DeathNotif:ShowCloseButton(false)

    DeathNotif.Paint = function()
        if killedBy == nil or killedWith == nil or !killedBy:IsPlayer() then
            draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 100))
            draw.SimpleText("You commited suicide!", "Trebuchet18", 200, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        else
            draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 0))
            draw.SimpleText("Killed by", "Trebuchet18", 400, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("|", "PlayerDeathName", 400, 65.5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("|", "PlayerDeathName", 400, 90, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(killedBy:GetName(), "PlayerDeathName", 390, 67.5, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            draw.SimpleText(killedWith, "PlayerDeathName", 410, 67.5, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            draw.SimpleText(killedBy:Health() .. "HP", "WepNameKill", 390, 100, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            draw.SimpleText(killedFrom .. "m", "WepNameKill", 410, 100, Color(255, 255, 255), TEXT_ALIGN_LEFT)

            draw.SimpleText("Respawning in     ", "WepNameKill", 390, 145, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            if respawnTimeLeft ~= nil or respawnTimeLeft > 4 or respawnTimeLeft < 0 then
                draw.SimpleText(respawnTimeLeft .. "s", "WepNameKill", 465, 145, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            end
            draw.SimpleText("Press [F1 - F4] to open the menu", "WepNameKill", 400, 170, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    CallingCard = vgui.Create("DImage", DeathNotif)
    CallingCard:SetPos(325, 20)
    CallingCard:SetSize(150, 50)
    CallingCard:SetImage("cards/industry.png")

    playerProfilePicture = vgui.Create("AvatarImage", DeathNotif)
    playerProfilePicture:SetPos(327.5, 22.5)
    playerProfilePicture:SetSize(45, 45)
    playerProfilePicture:SetPlayer(killedBy, 184)

    DeathNotif:Show()
    DeathNotif:MakePopup()
    DeathNotif:SetMouseInputEnabled(false)
    DeathNotif:SetKeyboardInputEnabled(false)
end )