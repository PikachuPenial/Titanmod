--Color array, saving space
local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)

local gameEnded = false

function HUD()
    --Disables the HUD if the player has it disabled in Options.
	if CLIENT and GetConVar("tm_enableui"):GetInt() == 1 then
		local client = LocalPlayer()

		if !client:Alive() then
			return
		end

        --Hides the HUD if the player has the Main Menu open.
        if LocalPlayer():GetNWBool("mainmenu") == true then
            return
        end

        --Hides the HUD if the player is viewing the Game End menu.
        if gameEnded == true then
            return
        end

        --Shows the players ammo and weapon depending on the style they have selected in Options.
        --Numeric Style
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 0 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() - 15, ScrH() - 60, white, TEXT_ALIGN_RIGHT, 0)
            end

            if CLIENT and GetConVar("tm_reloadhints"):GetInt() == 1 and (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("0", "AmmoCount", ScrW() - 15, ScrH() - 170, red, TEXT_ALIGN_RIGHT, 0)
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 175, red, TEXT_ALIGN_CENTER, 0)
            elseif (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() >= 0) then
                draw.SimpleText(client:GetActiveWeapon():Clip1(), "AmmoCount", ScrW() - 15, ScrH() - 170, white, TEXT_ALIGN_RIGHT, 0)
            end
        end

        --Middle Numeric Style
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 3 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() / 2, ScrH() - 60, white, TEXT_ALIGN_CENTER, 0)
            end

            if CLIENT and GetConVar("tm_reloadhints"):GetInt() == 1 and (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("0", "AmmoCount", ScrW() / 2, ScrH() - 170, red, TEXT_ALIGN_CENTER, 0)
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 175, red, TEXT_ALIGN_CENTER, 0)
            elseif (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() >= 0) then
                draw.SimpleText(client:GetActiveWeapon():Clip1(), "AmmoCount", ScrW() / 2, ScrH() - 170, white, TEXT_ALIGN_CENTER, 0)
            end
        end

        --Bar Style
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 1 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() - 15, ScrH() - 100, white, TEXT_ALIGN_RIGHT, 0)
            end

            if CLIENT and GetConVar("tm_reloadhints"):GetInt() == 1 and (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 175, red, TEXT_ALIGN_CENTER, 0)
            end

            if (client:GetActiveWeapon():IsValid()) then
                if not (client:GetActiveWeapon():Clip1() == 0) then
                    surface.SetDrawColor(50, 50, 50, 80)
                    surface.DrawRect(ScrW() - 415, ScrH() - 39, 400, 30)
                else
                    surface.SetDrawColor(255, 0, 0, 80)
                    surface.DrawRect(ScrW() - 415, ScrH() - 39, 400, 30)
                end

                surface.SetDrawColor(255, 255, 255, 175)
                surface.DrawRect(ScrW() - 415, ScrH() - 39, 400 * (client:GetActiveWeapon():Clip1() / client:GetActiveWeapon():GetMaxClip1()), 30)
                draw.SimpleText(client:GetActiveWeapon():Clip1(), "Health", ScrW() - 410, ScrH() - 40, Color(50, 50, 50, 255), TEXT_ALIGN_LEFT, 0)
            end
        end

        --Below Crosshair
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 2 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() - 15, ScrH() - 60, white, TEXT_ALIGN_RIGHT, 0)
            end

            if CLIENT and GetConVar("tm_reloadhints"):GetInt() == 1 and (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("0", "GunPrintName", ScrW() / 2, ScrH() / 2 + 120, red, TEXT_ALIGN_CENTER, 0)
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 170, red, TEXT_ALIGN_CENTER, 0)
            elseif (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() >= 0) then
                draw.SimpleText(client:GetActiveWeapon():Clip1(), "GunPrintName", ScrW() / 2, ScrH() / 2 + 120, white, TEXT_ALIGN_CENTER, 0)
            end
        end

        --Shows the players health depending on the style they have selected in Options.
        --Left Anchor
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 0 then
            surface.SetDrawColor(50, 50, 50, 80)
            surface.DrawRect(10, ScrH() - 38, 450, 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100, 120)
                else
                    surface.SetDrawColor(180, 180, 100, 120)
                end
            else
                surface.SetDrawColor(100, 180, 100, 120)
            end

            surface.DrawRect(10, ScrH() - 38, 450 * (client:Health() / client:GetMaxHealth()), 30)
            if client:Health() <= 0 then
                draw.SimpleText("0", "Health", 450, ScrH() - 39, white, TEXT_ALIGN_RIGHT, 0)
            else
                draw.SimpleText(client:Health(), "Health", 450, ScrH() - 39, white, TEXT_ALIGN_RIGHT, 0)
            end
        end

        --Middle Anchor
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 1 then
            surface.SetDrawColor(50, 50, 50, 80)
            surface.DrawRect(ScrW() / 2 - 225, ScrH() - 38, 450 , 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100, 120)
                else
                    surface.SetDrawColor(180, 180, 100, 120)
                end
            else
                surface.SetDrawColor(100, 180, 100, 120)
            end

            surface.DrawRect(ScrW() / 2 - 225, ScrH() - 38, 450 * (client:Health() / client:GetMaxHealth()), 30)
            if client:Health() <= 0 then
                draw.SimpleText("0", "Health", ScrW() / 2, ScrH() - 39, white, TEXT_ALIGN_CENTER, 0)
            else
                draw.SimpleText(client:Health(), "Health", ScrW() / 2, ScrH() - 39, white, TEXT_ALIGN_CENTER, 0)
            end
        end

        if CLIENT and GetConVar("tm_showspeed"):GetInt() == 1 then
            draw.SimpleText(LocalPlayer():GetVelocity(), "Health", ScrW() / 2, 10, white, TEXT_ALIGN_CENTER, 0)
        end

        --Below Crosshair
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 2 then
            surface.SetDrawColor(50, 50, 50, 80)
            surface.DrawRect(ScrW() / 2 - 100, ScrH() / 2 + 200, 150 , 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100, 120)
                else
                    surface.SetDrawColor(180, 180, 100, 120)
                end
            else
                surface.SetDrawColor(100, 180, 100, 120)
            end

            surface.DrawRect(ScrW() / 2 - 100, ScrH() / 2 + 200, 200 * (client:Health() / client:GetMaxHealth()), 30)
            if client:Health() <= 0 then
                draw.SimpleText("0", "Health", ScrW() / 2, ScrH() / 2 + 200, white, TEXT_ALIGN_CENTER, 0)
            else
                draw.SimpleText(client:Health(), "Health", ScrW() / 2, ScrH() / 2 + 200, white, TEXT_ALIGN_CENTER, 0)
            end
        end

        --Velocity Counter
        if CLIENT and GetConVar("tm_showspeed"):GetInt() == 1 then
            draw.SimpleText(LocalPlayer():GetVelocity(), "Health", ScrW() / 2, 10, white, TEXT_ALIGN_CENTER, 0)
        end

        --Shooting range disclaimer
        if game.GetMap() == "tm_firingrange" then
            draw.SimpleText("Use the scoreboard to spawn weapons.", "Health", ScrW() / 2, 10, white, TEXT_ALIGN_CENTER, 0)
        end
    end
end
hook.Add("HUDPaint", "TestHud", HUD)

--Hides the players info that shows up when aiming at another player.
function DrawTarget()
    return false
end
hook.Add("HUDDrawTargetID", "HidePlayerInfo", DrawTarget)

--Hides default HL2 HUD elements.
function HideHud(name)
    for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudZoom", "CHudVoiceStatus", "CHudDamageIndicator"}) do
        if name == v then
            return false
        end
    end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)

--Hides the default voice chat HUD.
function GM:PlayerStartVoice(ply)
    return
end

--Plays the received hitsound if a player hits another player.
net.Receive("PlayHitsound", function(len, pl)
    if CLIENT and GetConVar("tm_hitsounds"):GetInt() == 1 then
        local hit_reg = "hitsound/hit_reg.wav"
        local hit_reg_head = "hitsound/hit_reg_head.wav"

        local hitgroup = net.ReadUInt(4)
        local soundfile = hit_reg

        if (hitgroup == HITGROUP_HEAD) then
            soundfile = hit_reg_head
        end

        surface.PlaySound(soundfile)
    end
end )

--Displays after a player kills another player.
net.Receive("NotifyKill", function(len, ply)
    local killedPlayer = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()
    local lastHitIn = net.ReadFloat()

    local seperator = ""

    if IsValid(KillNotif) then
        KillNotif:Hide()
    end

    KillNotif = vgui.Create("DFrame")
    KillNotif:SetSize(600, 200)
    KillNotif:SetX(ScrW() / 2 - 300)
    if CLIENT and GetConVar("tm_killuianchor"):GetInt() == 0 then
        KillNotif:SetY(ScrH() - 335)
    else
        KillNotif:SetY(115)
    end
    KillNotif:SetTitle("")
    KillNotif:SetDraggable(false)
    KillNotif:ShowCloseButton(false)

    KillIcon = vgui.Create("DImage", KillNotif)
    KillIcon:SetPos(275, 50)
    KillIcon:SetSize(50, 50)
    KillIcon:SetImage("icons/killicon.png")

    --Displays the Accolades that the player accomplished during the kill, this is a very bad system, and I don't plan on reworking it, gg.
    if LocalPlayer():Health() <= 15 then
        clutch = "Clutch +20 | "
        seperator = "| "
    else
        clutch = ""
    end

    if killedFrom >= 40 then
        marksman = "Longshot +" .. killedFrom .. " | "
        seperator = "| "
    else
        marksman = ""
    end

    if killedFrom <= 3 then
        pointblank = "Point Blank +20 | "
        seperator = "| "
    else
        pointblank = ""
    end

    if killedWith == "Tanto" or killedWith == "Japanese Ararebo" or killedWith == "KM-2000" then
        smackdown = "Smackdown +20 |"
        seperator = "| "
    else
        smackdown = ""
    end

    if killedPlayer:SteamID() == LocalPlayer():GetNWInt("recentlyKilledBy") and LocalPlayer():GetNWBool("gotRevenge") == false then
        if killedPlayer:SteamID() == LocalPlayer():SteamID() then return end
        revenge = "Revenge +10 | "
    else
        revenge = ""
    end

    if LocalPlayer():GetNWInt("killStreak") >= 2 then
        onstreakScore = 10 * LocalPlayer():GetNWInt("killStreak") + 10
        onstreak = "On Streak +" .. onstreakScore .. " | "
        seperator = "| "
    else
        onstreakScore = ""
        onstreak = ""
    end

    if killedPlayer:GetNWInt("killStreak") >= 3 then
        buzzkillScore = 10 * killedPlayer:GetNWInt("killStreak")
        buzzkill = "Buzz Kill +" .. buzzkillScore .. " | "
        seperator = "| "
    else
        buzzkillScore = ""
        buzzkill = ""
    end

    if lastHitIn == 1 then
        headshot = "Headshot +20 | "
        seperator = "| "
        KillIcon:SetImageColor(Color(255, 0, 0))
    else
        headshot = ""
        KillIcon:SetImageColor(Color(255, 255, 255))
    end

    --Setting up variables related to colors, mostly for animations or dynamic text color.
    local streakColor
    local whiteColor = Color(255, 255, 255)
    local orangeColor = Color(255, 200, 100)
    local redColor = Color(255, 50, 50)
    local rainbowColor
    local rainbowSpeed = 160

    KillNotif.Paint = function()
        --Dynamic text color depending on the killstreak of the player.
        if LocalPlayer():GetNWInt("killStreak") <= 2 then
            streakColor = whiteColor
        elseif LocalPlayer():GetNWInt("killStreak") <= 4 then
            streakColor = orangeColor
        elseif LocalPlayer():GetNWInt("killStreak") <= 6 then
            streakColor = redColor
        elseif LocalPlayer():GetNWInt("killStreak") >= 7 then
            streakColor = rainbowColor
        end
        rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)

        --Displays information about the player you killed, as well as the Accolades you achived.
        draw.SimpleText(LocalPlayer():GetNWInt("killStreak") .. " Kills", "StreakText", 300, 25, streakColor, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedPlayer:GetName(), "PlayerNotiName", 300, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        if CLIENT and GetConVar("tm_enableaccolades"):GetInt() == 1 then
            --Please ignore the code below, pretend it does not exist.
            draw.SimpleText(seperator .. headshot .. onstreak .. revenge .. clutch .. buzzkill .. marksman .. pointblank .. smackdown, "StreakText", 300, 150, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    KillNotif:Show()
    KillNotif:MakePopup()
    KillNotif:SetMouseInputEnabled(false)
    KillNotif:SetKeyboardInputEnabled(false)

    surface.PlaySound("hitsound/killsound.wav")

    --Creates a countdown for the kill UI, having it disappear after 3.5 seconds.
    timer.Create("killNotification", 3.5, 1, function()
        KillNotif:SizeTo(0, 200, 1, 0, 0.25, function()
            KillNotif:Hide()
        end)
        notiAlreadyActive = false
    end)
end )

--Displays after a player dies to another player
net.Receive("DeathHud", function(len, ply)
    local killedBy = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()
    local lastHitIn = net.ReadFloat()

    local respawnTimeLeft = 4

    if IsValid(KillNotif) then
        KillNotif:Hide()
        notiAlreadyActive = false
    end

    --Creates a cooldown for the death UI, having it disappear after 4 seconds.
    timer.Create("respawnTimeHideHud", 4, 1, function()
        DeathNotif:Hide()
        hook.Remove("PlayerDeathThink", "ShowRespawnTime")
    end)

    --Gets the remaining respawn countdown, and sets it as a variable for later use.
    hook.Add("Think", "ShowRespawnTime", function(ply)
        if timer.Exists("respawnTimeHideHud") then
            respawnTimeLeft = math.Round(timer.TimeLeft("respawnTimeHideHud"), 1)
        end
    end)

    DeathNotif = vgui.Create("DFrame")
    DeathNotif:SetSize(800, 300)
    DeathNotif:SetX(ScrW() / 2 - 400)
    if CLIENT and GetConVar("tm_deathuianchor"):GetInt() == 0 then
        DeathNotif:SetY(ScrH() - 350)
    else
        DeathNotif:SetY(125)
    end
    DeathNotif:SetTitle("")
    DeathNotif:SetDraggable(false)
    DeathNotif:ShowCloseButton(false)

    DeathNotif.Paint = function()
    if lastHitIn == 1 then
            draw.SimpleText(killedFrom .. "m" .. " HS", "WepNameKill", 410, 130, Color(255, 0, 0), TEXT_ALIGN_LEFT)
        else
            draw.SimpleText(killedFrom .. "m", "WepNameKill", 410, 130, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        end

        --Information about the cause of your death, hopefully it wasn't too embarrising.
        draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 0))
        draw.SimpleText("Killed by", "Trebuchet18", 400, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText("|", "PlayerDeathName", 400, 95.5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText("|", "PlayerDeathName", 400, 120, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText("|", "PlayerDeathName", 400, 145, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(killedBy:GetName(), "PlayerDeathName", 390, 97.5, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        draw.SimpleText(killedWith, "PlayerDeathName", 410, 97.5, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        if killedBy:Health() <= 0 then
            draw.SimpleText("DEAD", "WepNameKill", 390, 130, Color(255, 0, 0), TEXT_ALIGN_RIGHT)
        else
            draw.SimpleText(killedBy:Health() .. "HP", "WepNameKill", 390, 130, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        end
        draw.SimpleText("YOU " .. LocalPlayer():GetNWInt(killedBy:SteamID() .. "youKilled"), "WepNameKill", 390, 155, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        draw.SimpleText(killedBy:GetNWInt(LocalPlayer():SteamID() .. "youKilled") .. " FOE", "WepNameKill", 410, 155, Color(255, 255, 255), TEXT_ALIGN_LEFT)

        draw.SimpleText("Respawning in     ", "WepNameKill", 390, 195, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        if respawnTimeLeft ~= nil or respawnTimeLeft > 4 or respawnTimeLeft < 0 then
            draw.SimpleText(respawnTimeLeft .. "s", "WepNameKill", 465, 195, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        end
        draw.SimpleText("Press [F1 - F4] to open the menu", "WepNameKill", 400, 220, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end

    KilledByCallingCard = vgui.Create("DImage", DeathNotif)
    KilledByCallingCard:SetPos(280, 20)
    KilledByCallingCard:SetSize(240, 80)
    KilledByCallingCard:SetImage(killedBy:GetNWString("chosenPlayercard"), "cards/color/black.png")

    killedByPlayerProfilePicture = vgui.Create("AvatarImage", DeathNotif)
    killedByPlayerProfilePicture:SetPos(285 + killedBy:GetNWInt("cardPictureOffset"), 25)
    killedByPlayerProfilePicture:SetSize(70, 70)
    killedByPlayerProfilePicture:SetPlayer(killedBy, 184)
    killedByPlayerProfilePicture.Paint = function()
        killedByPlayerProfilePicture:SetPos(285 + killedBy:GetNWInt("cardPictureOffset"), 25)
    end

    DeathNotif:Show()
    DeathNotif:MakePopup()
    DeathNotif:SetMouseInputEnabled(false)
    DeathNotif:SetKeyboardInputEnabled(false)
end )

--Displays to all players when a map vote begins.
net.Receive("MapVoteHUD", function(len, ply)
    local votedOnMap = false

    --Creates a cooldown for the Map Vote UI, having it disappear after 20 seconds.
    timer.Create("mapVoteTimeRemaining", 19, 1, function()
        if votedOnMap == false then RunConsoleCommand("tm_voteformap", "skip") end
        MapVoteHUD:SizeTo(0, 490, 1, 0, 0.25, function()
            MapVoteHUD:Hide()
        end)
    end)

    local firstMap = net.ReadString()
    local secondMap = net.ReadString()

    local firstMapName
    local firstMapThumb

    local secondMapName
    local secondMapThumb

    for o, v in pairs(mapArr) do
        if game.GetMap() == v[1] then currentMapName = v[2] end

        if firstMap == v[1] then
            firstMapName = v[2]
            firstMapThumb = v[4]
        end

        if secondMap == v[1] then
            secondMapName = v[2]
            secondMapThumb = v[4]
        end
    end

    MapVoteHUD = vgui.Create("DFrame")
    MapVoteHUD:SetSize(0, 490)
    MapVoteHUD:SetX(0)
    MapVoteHUD:SetY(ScrH() / 2 - 245)
    MapVoteHUD:SetTitle("")
    MapVoteHUD:SetDraggable(false)
    MapVoteHUD:ShowCloseButton(false)
    MapVoteHUD:SizeTo(200, 490, 1, 0, 0.25)

    MapVoteHUD.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150))
        draw.RoundedBox(0, 0, 0, 20, h, Color(40, 40, 40, 150))
        draw.SimpleText("MAP VOTE", "WepNameKill", 110, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)

        draw.SimpleText(firstMapName, "MapName", 110, 188, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(secondMapName, "MapName", 110, 388, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end

    local MapChoice = vgui.Create("DImageButton", MapVoteHUD)
    MapChoice:SetPos(30, 50)
    MapChoice:SetText("")
    MapChoice:SetSize(160, 160)
    MapChoice:SetImage(firstMapThumb)
    local choiceAnim = 0
    MapChoice.Paint = function()
        if MapChoice:IsHovered() then
            choiceAnim = math.Clamp(choiceAnim + 200 * FrameTime(), 0, 20)
        else
            choiceAnim = math.Clamp(choiceAnim - 200 * FrameTime(), 0, 20)
        end
        MapChoice:SetPos(30, 50 - choiceAnim)
    end
    MapChoice.DoClick = function()
        RunConsoleCommand("tm_voteformap", firstMap)
        votedOnMap = true

        surface.PlaySound("buttons/button15.wav")
        notification.AddProgress("VoteConfirmation", "You have successfully voted to play on " .. firstMapName .. "!")
        timer.Simple(4, function()
            notification.Kill("VoteConfirmation")
        end)

        MapVoteHUD:SizeTo(0, 490, 1, 0, 0.25, function()
            MapVoteHUD:Hide()
        end)
    end

    local MapChoiceTwo = vgui.Create("DImageButton", MapVoteHUD)
    MapChoiceTwo:SetPos(30, 250)
    MapChoiceTwo:SetText("")
    MapChoiceTwo:SetSize(160, 160)
    MapChoiceTwo:SetImage(secondMapThumb)
    local choiceTwoAnim = 0
    MapChoiceTwo.Paint = function()
        if MapChoiceTwo:IsHovered() then
            choiceTwoAnim = math.Clamp(choiceTwoAnim + 200 * FrameTime(), 0, 20)
        else
            choiceTwoAnim = math.Clamp(choiceTwoAnim - 200 * FrameTime(), 0, 20)
        end
        MapChoiceTwo:SetPos(30, 250 - choiceTwoAnim)
    end
    MapChoiceTwo.DoClick = function()
        RunConsoleCommand("tm_voteformap", secondMap)
        votedOnMap = true

        surface.PlaySound("buttons/button15.wav")
        notification.AddProgress("VoteConfirmation", "You have successfully voted to play on " .. secondMapName .. "!")
        timer.Simple(4, function()
            notification.Kill("VoteConfirmation")
        end)

        MapVoteHUD:SizeTo(0, 490, 1, 0, 0.25, function()
            MapVoteHUD:Hide()
        end)
    end

    local ContinueButton = vgui.Create("DButton", MapVoteHUD)
    ContinueButton:SetPos(20, 430)
    ContinueButton:SetText("")
    ContinueButton:SetSize(180, 60)
    local textAnim = 0
    ContinueButton.Paint = function()
        if ContinueButton:IsHovered() then
            textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 10)
        else
            textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 10)
        end

        draw.SimpleText("CONTINUE ON", "MapName", 90, 10 - textAnim, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(currentMapName, "WepNameKill", 90, 27.5 - textAnim, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
    ContinueButton.DoClick = function()
        RunConsoleCommand("tm_voteformap", "skip")
        votedOnMap = true

        surface.PlaySound("buttons/button15.wav")
        notification.AddProgress("VoteConfirmation", "You have successfully voted to continue playing on " .. currentMapName .. "!")
        timer.Simple(4, function()
            notification.Kill("VoteConfirmation")
        end)

        MapVoteHUD:SizeTo(0, 490, 1, 0, 0.25, function()
            MapVoteHUD:Hide()
        end)
    end

    MapVoteHUD:Show()
    MapVoteHUD:SetKeyboardInputEnabled(false)
end )

--Displays to all players when a map vote begins.
net.Receive("EndOfGame", function(len, ply)
    if IsValid(EndOfGameUI) then
        EndOfGameUI:Hide()
    end

    gameEnded = true
    RunConsoleCommand("tm_closemainmenu")

    local matchStartsIn = 30
    local nextMap = net.ReadString()
    local nextMapThumbnail = "maps/thumb/" .. nextMap .. ".png"

    --Creates a timer so players can see how long it will be until the next match starts.
    timer.Create("matchStartsIn", 30, 1, function()
    end)

    hook.Add("Think", "ShowNextMatchTime", function(ply)
        if timer.Exists("matchStartsIn") then
            matchStartsIn = math.Round(timer.TimeLeft("matchStartsIn"))
        end
    end)

    --Plays music on match end.
    local gameEndMusic = CreateSound(LocalPlayer(), "music/matchend.wav")
    gameEndMusic = GetConVar("tm_gameendmusicvolume"):GetInt() / 4

    if CLIENT and GetConVar("tm_gameendmusic"):GetInt() == 1 then
        gameEndMusic:Play()
        gameEndMusic:ChangeVolume(musicVolume * 1.2)
    end

    EndOfGameUI = vgui.Create("DPanel")
    EndOfGameUI:SetSize(ScrW(), 0)
    EndOfGameUI:SetPos(0, 0)
    EndOfGameUI:MakePopup()
    EndOfGameUI:SizeTo(ScrW(), ScrH(), 1.5, 0, 0.25)

    EndOfGameUI.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 225))
    end

    local TopBlock = vgui.Create("DPanel", EndOfGameUI)
    TopBlock:Dock(TOP)
    TopBlock:SetSize(0, ScrH() * 0.15)
    TopBlock.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
    end

    local PlayerScroller = vgui.Create("DHorizontalScroller", EndOfGameUI)
    PlayerScroller:Dock(TOP)
    PlayerScroller:SetSize(0, ScrH() * 0.7)

    local connectedPlayers = player.GetAll()
    table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end)

    for k, v in pairs(connectedPlayers) do
        local ratio
        local card = v:GetNWString("chosenPlayercard")

        if v:Frags() <= 0 then
            ratio = 0
        elseif v:Frags() >= 1 and v:Deaths() == 0 then
            ratio = v:Frags()
        else
            ratio = v:Frags() / v:Deaths()
        end

        local PlayerPanel = vgui.Create("DPanel", PlayerScroller)
        PlayerPanel:SetSize(400, ScrH() * 0.7)
        PlayerPanel.Paint = function(self, w, h)
            draw.SimpleText(v:GetNWInt("playerScoreMatch") .. " Score", "StreakText", w / 2, 30, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(v:GetName(), "GunPrintName", w / 2, h - 160, Color(255, 255, 255), TEXT_ALIGN_CENTER)

            draw.SimpleText(v:Frags(), "Health", 170, 150, Color(0, 255, 0), TEXT_ALIGN_CENTER)
            draw.SimpleText(v:Deaths(), "Health", 230, 150, Color(255, 0, 0), TEXT_ALIGN_CENTER)
            draw.SimpleText(math.Round(ratio, 2) .. " K/D", "StreakText", 200, 180, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

        KillsIcon = vgui.Create("DImage", PlayerPanel)
        KillsIcon:SetPos(155, 120)
        KillsIcon:SetSize(30, 30)
        KillsIcon:SetImage("icons/killicon.png")

        DeathsIcon = vgui.Create("DImage", PlayerPanel)
        DeathsIcon:SetPos(215, 120)
        DeathsIcon:SetSize(30, 30)
        DeathsIcon:SetImage("icons/deathicon.png")

        local PlayerModelDisplay = vgui.Create("DModelPanel", PlayerPanel)
        PlayerModelDisplay:SetSize(400, ScrH() * 0.7)
        PlayerModelDisplay:SetModel(v:GetNWString("chosenPlayermodel"))
        function PlayerModelDisplay:LayoutEntity(Entity) return end

        --Displays a players calling card and profile picture.
        playerMenuCallingCard = vgui.Create("DImage", PlayerPanel)
        playerMenuCallingCard:SetPos(PlayerPanel:GetWide() / 2 - 120, PlayerPanel:GetTall() - 100)
        playerMenuCallingCard:SetSize(240, 80)
        playerMenuCallingCard:SetImage(card, "cards/color/black.png")

        playerMenuProfilePicture = vgui.Create("AvatarImage", playerMenuCallingCard)
        playerMenuProfilePicture:SetPos(5 + v:GetNWInt("cardPictureOffset"), 5)
        playerMenuProfilePicture:SetSize(70, 70)
        playerMenuProfilePicture:SetPlayer(v, 184)

        PlayerScroller:AddPanel(PlayerPanel)
    end


    local BottomBlock = vgui.Create("DPanel", EndOfGameUI)
    BottomBlock:Dock(TOP)
    BottomBlock:SetSize(0, ScrH() * 0.15)

    nextMapThumbImage = vgui.Create("DImage", BottomBlock)
    nextMapThumbImage:SetPos(5, 5)
    nextMapThumbImage:SetSize(BottomBlock:GetTall() - 10, BottomBlock:GetTall() - 10)
    nextMapThumbImage:SetImage(nextMapThumbnail)

    BottomBlock.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
        draw.SimpleText(nextMap, "MainMenuLoadoutWeapons", nextMapThumbImage:GetWide() + 15, h - 55, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        draw.SimpleText("Next match starts in " .. matchStartsIn .. "s", "MainMenuLoadoutWeapons", nextMapThumbImage:GetWide() + 15, h - 30, Color(255, 255, 255), TEXT_ALIGN_LEFT)
    end

    EndOfGameUI:Show()
    gui.EnableScreenClicker(true)
end )