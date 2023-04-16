--Color array, saving space
local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)

local gameEnded = false
local feedArray = {}
local health
if game.GetMap() == "tm_firingrange" then playingFiringRange = true else playingFiringRange = false end

local healthSize = GetConVar("tm_hud_health_size"):GetInt()
local healthOffsetX = GetConVar("tm_hud_health_offset_x"):GetInt()
local healthOffsetY = GetConVar("tm_hud_health_offset_y"):GetInt()
local wepTextR = GetConVar("tm_hud_ammo_wep_text_color_r"):GetInt()
local wepTextG = GetConVar("tm_hud_ammo_wep_text_color_g"):GetInt()
local wepTextB = GetConVar("tm_hud_ammo_wep_text_color_b"):GetInt()
local ammoBarR = GetConVar("tm_hud_ammo_bar_color_r"):GetInt()
local ammoBarG = GetConVar("tm_hud_ammo_bar_color_g"):GetInt()
local ammoBarB = GetConVar("tm_hud_ammo_bar_color_b"):GetInt()
local ammoTextR = GetConVar("tm_hud_ammo_text_color_r"):GetInt()
local ammoTextG = GetConVar("tm_hud_ammo_text_color_g"):GetInt()
local ammoTextB = GetConVar("tm_hud_ammo_text_color_b"):GetInt()
local hpTextR = GetConVar("tm_hud_health_text_color_r"):GetInt()
local hpTextG = GetConVar("tm_hud_health_text_color_g"):GetInt()
local hpTextB = GetConVar("tm_hud_health_text_color_b"):GetInt()
local hpHighR = GetConVar("tm_hud_health_color_high_r"):GetInt()
local hpHighG = GetConVar("tm_hud_health_color_high_g"):GetInt()
local hpHighB = GetConVar("tm_hud_health_color_high_b"):GetInt()
local hpMidR = GetConVar("tm_hud_health_color_mid_r"):GetInt()
local hpMidG = GetConVar("tm_hud_health_color_mid_g"):GetInt()
local hpMidB = GetConVar("tm_hud_health_color_mid_b"):GetInt()
local hpLowR = GetConVar("tm_hud_health_color_low_r"):GetInt()
local hpLowG = GetConVar("tm_hud_health_color_low_g"):GetInt()
local hpLowB = GetConVar("tm_hud_health_color_low_b"):GetInt()
local equipOffsetX = GetConVar("tm_hud_equipment_offset_x"):GetInt()
local equipOffsetY = GetConVar("tm_hud_equipment_offset_y"):GetInt()
local feedOffsetX = GetConVar("tm_hud_killfeed_offset_x"):GetInt()
local feedOffsetY = GetConVar("tm_hud_killfeed_offset_y"):GetInt()
local feedOpacity = GetConVar("tm_hud_killfeed_opacity"):GetInt()
local kdOffsetX = GetConVar("tm_hud_killdeath_offset_x"):GetInt()
local kdOffsetY = GetConVar("tm_hud_killdeath_offset_y"):GetInt()
local kIconR = GetConVar("tm_hud_kill_iconcolor_r"):GetInt()
local kIconG = GetConVar("tm_hud_kill_iconcolor_g"):GetInt()
local kIconB = GetConVar("tm_hud_kill_iconcolor_b"):GetInt()

local StreakFont = "StreakText"
local NameFont = "PlayerNotiName"
local ArialFont = "Arial18"
local DeathFont = "PlayerDeathName"
local WepFont = "WepNameKill"

if GetConVar("tm_hud_font_kill"):GetInt() == 1 then
    StreakFont = "HUD_StreakText"
    NameFont = "HUD_PlayerNotiName"
end

if GetConVar("tm_hud_font_death"):GetInt() == 1 then
    ArialFont = "HUD_Arial18"
    DeathFont = "HUD_PlayerDeathName"
    WepFont = "HUD_WepNameKill"
end

if GetConVar("tm_hud_killfeed_style"):GetInt() == 0 then feedEntryPadding = -20 else feedEntryPadding = 20 end
if GetConVar("tm_hud_equipment_anchor"):GetInt() == 0 then equipAnchor = "left" elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 1 then equipAnchor = "center" elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 2 then equipAnchor = "right" end

function HUD()
    --Disables the HUD if the player has it disabled in Options.
    if GetConVar("tm_hud_enable"):GetInt() == 0 then return end
    if !LocalPlayer():Alive() or LocalPlayer():GetNWBool("mainmenu") == true or gameEnded == true then return end

    --Shows the players ammo and weapon depending on the style they have selected in Options.
    --Numeric Style
    if GetConVar("tm_hud_ammo_style"):GetInt() == 0 then
        if (LocalPlayer():GetActiveWeapon():IsValid()) and (LocalPlayer():GetActiveWeapon():GetPrintName() != nil) then
            draw.SimpleText(LocalPlayer():GetActiveWeapon():GetPrintName(), "HUD_GunPrintName", ScrW() - 15, ScrH() - 30, Color(wepTextR, wepTextG, wepTextB), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0)
            if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(LocalPlayer():GetNWInt("killsWith_" .. LocalPlayer():GetActiveWeapon():GetClass()) .. " kills", "HUD_StreakText", ScrW() - 25, ScrH() - 155, Color(wepTextR, wepTextG, wepTextB), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0) end
        end

        if (LocalPlayer():GetActiveWeapon():IsValid()) and (LocalPlayer():GetActiveWeapon():Clip1() == 0) then draw.SimpleText("0", "HUD_AmmoCount", ScrW() - 15, ScrH() - 100, red, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0) elseif (LocalPlayer():GetActiveWeapon():IsValid()) and (LocalPlayer():GetActiveWeapon():Clip1() >= 0) then draw.SimpleText(LocalPlayer():GetActiveWeapon():Clip1(), "HUD_AmmoCount", ScrW() - 15, ScrH() - 100, Color(ammoTextR, ammoTextG, ammoTextB), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0) end
    end

    --Bar Style
    if GetConVar("tm_hud_ammo_style"):GetInt() == 1 then
        if (LocalPlayer():GetActiveWeapon():IsValid()) and (LocalPlayer():GetActiveWeapon():GetPrintName() != nil) then
            draw.SimpleText(LocalPlayer():GetActiveWeapon():GetPrintName(), "HUD_GunPrintName", ScrW() - 15, ScrH() - 70, Color(wepTextR, wepTextG, wepTextB), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0)
            if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(LocalPlayer():GetNWInt("killsWith_" .. LocalPlayer():GetActiveWeapon():GetClass()) .. " kills", "HUD_StreakText", ScrW() - 18, ScrH() - 100, Color(wepTextR, wepTextG, wepTextB), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0) end
        end

        if (LocalPlayer():GetActiveWeapon():IsValid()) then
            if (LocalPlayer():GetActiveWeapon():Clip1() != 0) then
                surface.SetDrawColor(ammoBarR - 205, ammoBarG - 205, ammoBarB - 205, 80)
                surface.DrawRect(ScrW() - 415, ScrH() - 38, 400, 30)
            else
                surface.SetDrawColor(255, 0, 0, 80)
                surface.DrawRect(ScrW() - 415, ScrH() - 38, 400, 30)
            end

            surface.SetDrawColor(ammoBarR, ammoBarG, ammoBarB, 175)
            surface.DrawRect(ScrW() - 415, ScrH() - 38, 400 * (LocalPlayer():GetActiveWeapon():Clip1() / LocalPlayer():GetActiveWeapon():GetMaxClip1()), 30)
            if (LocalPlayer():GetActiveWeapon():Clip1() >= 0) then draw.SimpleText(LocalPlayer():GetActiveWeapon():Clip1(), "HUD_Health", ScrW() - 410, ScrH() - 24, Color(ammoTextR, ammoTextG, ammoTextB, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0) else draw.SimpleText("∞", "HUD_Health", ScrW() - 410, ScrH() - 24, Color(ammoTextR, ammoTextG, ammoTextB, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0) end
        end
    end

    --Displays a reload hint when the player is out of ammo.
    if GetConVar("tm_hud_reloadhint"):GetInt() == 1 and (LocalPlayer():GetActiveWeapon():IsValid()) and (LocalPlayer():GetActiveWeapon():Clip1() == 0) then draw.SimpleText("[RELOAD]", "HUD_WepNameKill", ScrW() / 2, ScrH() / 2 + 200, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0) end

    --Shows the players health depending on the style they have selected in Options.
    if LocalPlayer():Health() <= 0 then health = 0 else health = LocalPlayer():Health() end
    surface.SetDrawColor(50, 50, 50, 80)
    surface.DrawRect(10 + healthOffsetX, ScrH() - 38 - healthOffsetY, healthSize, 30)

    if LocalPlayer():Health() <= 66 then
        if LocalPlayer():Health() <= 33 then
            surface.SetDrawColor(hpLowR, hpLowG, hpLowB, 120)
        else
            surface.SetDrawColor(hpMidR, hpMidG, hpMidB, 120)
        end
    else
        surface.SetDrawColor(hpHighR, hpHighG, hpHighB, 120)
    end

    surface.DrawRect(10 + healthOffsetX, ScrH() - 38 - healthOffsetY, healthSize * (LocalPlayer():Health() / LocalPlayer():GetMaxHealth()), 30)
    draw.SimpleText(health, "HUD_Health", healthSize + healthOffsetX, ScrH() - 24 - healthOffsetY, Color(hpTextR, hpTextG, hpTextB), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0)

    --Shooting range disclaimer.    
    if playingFiringRange == true then draw.SimpleText("Use the scoreboard to spawn weapons.", "HUD_Health", ScrW() / 2, ScrH() - 25, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0) end

    --Grappling hook disclaimer.
    if (LocalPlayer():GetActiveWeapon():IsValid()) and LocalPlayer():GetActiveWeapon():GetPrintName() == "Grappling Hook" then draw.SimpleText("Press [" .. input.GetKeyName(GetConVar("frest_bindg"):GetInt()) .. "] to use your grappling hook.", "HUD_Health", ScrW() / 2, ScrH() / 2 + 75, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0) end

    --Kill feed
    for k, v in pairs(feedArray) do
        if v[2] == 1 and v[2] != nil then surface.SetDrawColor(150, 50, 50, feedOpacity) else surface.SetDrawColor(50, 50, 50, feedOpacity) end
        local nameLength = select(1, surface.GetTextSize(v[1]))

        surface.DrawRect(10 + feedOffsetX, ScrH() - 20 + ((k - 1) * feedEntryPadding) - feedOffsetY, nameLength + 5, 20)
        draw.SimpleText(v[1], "HUD_StreakText", 12.5 + feedOffsetX, ScrH() - 10 + ((k - 1) * feedEntryPadding) - feedOffsetY, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    --Remaining match time.
    local timeText = " ∞"
    if GetConVar("tm_endless"):GetInt() != 1 and game.GetMap() != "tm_firingrange" then timeText = string.FormattedTime(math.Round(GetGlobalInt("tm_matchtime", 0) - CurTime()), "%2i:%02i") end
    draw.SimpleText("FFA | " .. timeText, "HUD_Health", ScrW() / 2, 5, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    --Equipment
    local grappleMat = Material("icons/grapplehudicon.png")
    local nadeMat = Material("icons/grenadehudicon.png")
    local grappleText

    if LocalPlayer():HasWeapon("fres_grapple") and LocalPlayer():GetAmmoCount("Grenade") > 0 then
        surface.SetMaterial(grappleMat)
        if Lerp((LocalPlayer():GetNWFloat("linat",CurTime()) - CurTime()) * 0.2,0,500) == 0 and !IsValid(LocalPlayer():SetNWEntity("lina",stando)) then
            surface.SetDrawColor(255,255,255,255)
            grappleText = "[" .. input.GetKeyName(GetConVar("frest_bindg"):GetInt()) .. "]"
        else
            surface.SetDrawColor(255,200,200,100)
            grappleText = math.floor((LocalPlayer():GetNWFloat("linat",CurTime()) - CurTime()) + 0,5)
        end
        surface.DrawTexturedRect(equipOffsetX - 45, ScrH() - 47.5 - equipOffsetY, 35, 40)
        draw.SimpleText(grappleText, "HUD_StreakText", equipOffsetX - 27.5, ScrH() - 75 - equipOffsetY, color_white, TEXT_ALIGN_CENTER)

        surface.SetMaterial(nadeMat)
        surface.SetDrawColor(255,255,255,255)
        surface.DrawTexturedRect(equipOffsetX + 10, ScrH() - 47.5 - equipOffsetY, 35, 40)
        draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", equipOffsetX + 27.5, ScrH() - 75 - equipOffsetY, color_white, TEXT_ALIGN_CENTER)
    elseif LocalPlayer():HasWeapon("fres_grapple") then
        surface.SetMaterial(grappleMat)
        if Lerp((LocalPlayer():GetNWFloat("linat",CurTime()) - CurTime()) * 0.2,0,500) == 0 and !IsValid(LocalPlayer():SetNWEntity("lina",stando)) then
            surface.SetDrawColor(255,255,255,255)
            grappleText = "[" .. input.GetKeyName(GetConVar("frest_bindg"):GetInt()) .. "]"
        else
            surface.SetDrawColor(255,200,200,100)
            grappleText = math.floor((LocalPlayer():GetNWFloat("linat",CurTime()) - CurTime()) + 0,5)
        end
        if equipAnchor == "left" then
            surface.DrawTexturedRect(equipOffsetX - 45, ScrH() - 47.5 - equipOffsetY, 35, 40)
            draw.SimpleText(grappleText, "HUD_StreakText", equipOffsetX - 27.5, ScrH() - 75 - equipOffsetY, color_white, TEXT_ALIGN_CENTER)
        elseif equipAnchor == "center" then
            surface.DrawTexturedRect(equipOffsetX - 17.5, ScrH() - 47.5 - equipOffsetY, 35, 40)
            draw.SimpleText(grappleText, "HUD_StreakText", equipOffsetX, ScrH() - 75 - equipOffsetY, color_white, TEXT_ALIGN_CENTER)
        else
            surface.DrawTexturedRect(equipOffsetX + 10, ScrH() - 47.5 - equipOffsetY, 35, 40)
            draw.SimpleText(grappleText, "HUD_StreakText", equipOffsetX + 27.5, ScrH() - 75 - equipOffsetY, color_white, TEXT_ALIGN_CENTER)
        end
    elseif LocalPlayer():GetAmmoCount("Grenade") > 0 then
        surface.SetMaterial(nadeMat)
        surface.SetDrawColor(255,255,255,255)
        if equipAnchor == "left" then
            surface.DrawTexturedRect(equipOffsetX - 45, ScrH() - 47.5 - equipOffsetY, 35, 40)
            draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", equipOffsetX - 27.5, ScrH() - 75 - equipOffsetY, color_white, TEXT_ALIGN_CENTER)
        elseif equipAnchor == "center" then
            surface.DrawTexturedRect(equipOffsetX - 17.5, ScrH() - 47.5 - equipOffsetY, 35, 40)
            draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", equipOffsetX, ScrH() - 75 - equipOffsetY, color_white, TEXT_ALIGN_CENTER)
        else
            surface.DrawTexturedRect(equipOffsetX + 10, ScrH() - 47.5 - equipOffsetY, 35, 40)
            draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", equipOffsetX + 27.5, ScrH() - 75 - equipOffsetY, color_white, TEXT_ALIGN_CENTER)
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
        if name == v then return false end
    end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)

--Hides the default voice chat HUD and shows a custom message.
function GM:PlayerStartVoice(ply)
    voiceActive = true
    return
end

function GM:PlayerEndVoice(ply)
    voiceActive = false
end

--Plays the received hitsound if a player hits another player.
net.Receive("PlayHitsound", function(len, pl)
    if GetConVar("tm_hitsounds"):GetInt() == 0 then return end
    local hit_reg = "hitsound/hit_" .. GetConVar("tm_hitsoundtype"):GetInt() .. ".wav"
    local hit_reg_head = "hitsound/hit_head_" .. GetConVar("tm_hitsoundtype"):GetInt() .. ".wav"

    local hitgroup = net.ReadUInt(4)
    local soundfile = hit_reg

    if (hitgroup == HITGROUP_HEAD) then soundfile = hit_reg_head end
    surface.PlaySound(soundfile)
end )

net.Receive("KillFeedUpdate", function(len, ply)
    if GetConVar("tm_hud_enablekillfeed"):GetInt() == 0 then return end
    local playersInAction = net.ReadString()
    local victimLastHitIn = net.ReadInt(5)
    local attacker = net.ReadString()
    local streak = net.ReadInt(10)

    table.insert(feedArray, {playersInAction, victimLastHitIn})
    if table.Count(feedArray) >= (GetConVar("tm_hud_killfeed_limit"):GetInt() + 1) then table.remove(feedArray, 1) end
    timer.Create(playersInAction .. math.Round(CurTime()), 8, 1, function()
        table.remove(feedArray, 1)
    end)

    if streak == 5 or streak == 10 or streak == 15 or streak == 20 or streak == 25 or streak == 30 then
        table.insert(feedArray, {attacker .. " is on a " .. streak .. " killstreak", 0})
        if table.Count(feedArray) >= (GetConVar("tm_hud_killfeed_limit"):GetInt() + 1) then table.remove(feedArray, 1) end
        timer.Create(attacker .. streak .. math.Round(CurTime()), 8, 1, function()
            table.remove(feedArray, 1)
        end)
    end
end )

--Displays after a player kills another player.
net.Receive("NotifyKill", function(len, ply)
    if GetConVar("tm_hud_enablekill"):GetInt() == 0 then return end

    local killedPlayer = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()
    local lastHitIn = net.ReadInt(5)
    local killStreak = net.ReadInt(10)

    local seperator = ""

    if IsValid(KillNotif) then KillNotif:Remove() end

    if IsValid(DeathNotif) then DeathNotif:Remove() end

    KillNotif = vgui.Create("DFrame")
    KillNotif:SetSize(ScrW(), 200)
    KillNotif:SetX(kdOffsetX)
    KillNotif:SetY(ScrH() - kdOffsetY)
    KillNotif:SetTitle("")
    KillNotif:SetDraggable(false)
    KillNotif:ShowCloseButton(false)

    KillIcon = vgui.Create("DImage", KillNotif)
    KillIcon:SetPos(ScrW() / 2 - 25, 50)
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

    if killStreak >= 3 then
        onstreakScore = 10 * killStreak
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
        KillIcon:SetImageColor(red)
    else
        headshot = ""
        KillIcon:SetImageColor(Color(kIconR, kIconG, kIconB))
    end

    --Setting up variables related to colors, mostly for animations or dynamic text color.
    local streakColor
    local orangeColor = Color(255, 200, 100)
    local redColor = Color(255, 50, 50)
    local rainbowSpeed = 160
    local rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)

    --Dynamic text color depending on the killstreak of the player.
    if killStreak <= 2 then
        streakColor = white
    elseif killStreak <= 4 then
        streakColor = orangeColor
    elseif killStreak <= 6 then
        streakColor = redColor
    end

    KillNotif.Paint = function(self, w, h)
        if !IsValid(killedPlayer) then KillNotif:Remove() return end
        if killStreak >= 7 then streakColor = rainbowColor end
        rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)

        --Displays information about the player you killed, as well as the Accolades you achived.
        draw.SimpleText(killStreak .. " Kills", StreakFont, w / 2, 35, streakColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedPlayer:GetName(), NameFont, w / 2, 125, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if GetConVar("tm_hud_killaccolades"):GetInt() == 1 then
            --Please ignore the code below, pretend it does not exist.
            draw.SimpleText(seperator .. headshot .. onstreak .. clutch .. buzzkill .. marksman .. pointblank .. smackdown, StreakFont, w / 2, 160, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    KillNotif:Show()
    KillNotif:MakePopup()
    KillNotif:SetMouseInputEnabled(false)
    KillNotif:SetKeyboardInputEnabled(false)

    if GetConVar("tm_killsound"):GetInt() == 1 then surface.PlaySound("hitsound/kill_" .. GetConVar("tm_killsoundtype"):GetInt() .. ".wav") end

    --Creates a countdown for the kill UI, having it disappear after 3.5 seconds.
    timer.Create("killNotification", 3.5, 1, function()
        if IsValid(KillNotif) then
            KillNotif:MoveTo(kdOffsetX, ScrH(), 1, 0, 0.25, function()
                KillNotif:Remove()
            end)
        end
    end)
end )

--Displays after a player dies to another player
net.Receive("NotifyDeath", function(len, ply)
    if GetConVar("tm_hud_enabledeath"):GetInt() == 0 then return end

    local killedBy = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()
    local lastHitIn = net.ReadInt(5)
    local respawnTimeLeft = playerRespawnTime

    if IsValid(KillNotif) then KillNotif:Remove() end
    if IsValid(DeathNotif) then DeathNotif:Remove() end

    --Creates a cooldown for the death UI, having it disappear after 4 seconds.
    timer.Create("respawnTimeHideHud", playerRespawnTime, 1, function()
        DeathNotif:Remove()
        hook.Remove("Think", "ShowRespawnTime")
    end)

    --Gets the remaining respawn countdown, and sets it as a variable for later use.
    hook.Add("Think", "ShowRespawnTime", function()
        if timer.Exists("respawnTimeHideHud") then respawnTimeLeft = math.Round(timer.TimeLeft("respawnTimeHideHud"), 1) end
    end)

    DeathNotif = vgui.Create("DFrame")
    DeathNotif:SetSize(ScrW(), 300)
    DeathNotif:SetX(kdOffsetX)
    DeathNotif:SetY(ScrH() - kdOffsetY)
    DeathNotif:SetTitle("")
    DeathNotif:SetDraggable(false)
    DeathNotif:ShowCloseButton(false)
    local hint = table.Random(hintArray)

    DeathNotif.Paint = function(self, w, h)
        if !IsValid(killedBy) then DeathNotif:Remove() return end
        if lastHitIn == 1 then
            draw.SimpleText(killedFrom .. "m" .. " HS", WepFont, w / 2 + 10, 145, red, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(killedFrom .. "m", WepFont, w / 2 + 10, 145, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        --Information about the cause of your death, hopefully it wasn't too embarrising.
        draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 0))
        draw.SimpleText("Killed by", ArialFont, w / 2, 10, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", DeathFont, w / 2, 115.5, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", DeathFont, w / 2, 140, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", DeathFont, w / 2, 165, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedBy:GetName(), DeathFont, w / 2 - 10, 117.5, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedWith, DeathFont, w / 2 + 10, 117.5, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if killedBy:Health() <= 0 then
            draw.SimpleText("DEAD", WepFont, w / 2 - 10, 145, red, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(killedBy:Health() .. "HP", WepFont, w / 2 - 10, 145, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        draw.SimpleText("YOU " .. LocalPlayer():GetNWInt(killedBy:SteamID() .. "youKilled"), WepFont, w / 2 - 10, 170, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedBy:GetNWInt(LocalPlayer():SteamID() .. "youKilled") .. " FOE", WepFont, w / 2 + 10, 170, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        draw.SimpleText("Respawning in " .. respawnTimeLeft .. "s", WepFont, w / 2 - 10, 210, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Press [" .. input.GetKeyName(GetConVar("tm_mainmenubind"):GetInt()) .. "] to open the menu", WepFont, w / 2, 235, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("HINT: " .. hint, ArialFont, w / 2, 257.5, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    KilledByCallingCard = vgui.Create("DImage", DeathNotif)
    KilledByCallingCard:SetPos(ScrW() / 2 - 120, 20)
    KilledByCallingCard:SetSize(240, 80)
    if IsValid(killedBy) then KilledByCallingCard:SetImage(killedBy:GetNWString("chosenPlayercard"), "cards/color/black.png") end

    KilledByPlayerProfilePicture = vgui.Create("AvatarImage", KilledByCallingCard)
    KilledByPlayerProfilePicture:SetPos(5, 5)
    KilledByPlayerProfilePicture:SetSize(70, 70)
    KilledByPlayerProfilePicture:SetPlayer(killedBy, 184)

    LocalPlayer():ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 45), 0.3, 0)

    DeathNotif:Show()
    DeathNotif:MakePopup()
    DeathNotif:SetMouseInputEnabled(false)
    DeathNotif:SetKeyboardInputEnabled(false)
end )

--Displays to all players when a map vote begins.
net.Receive("EndOfGame", function(len, ply)
    local dof
    gameEnded = true
    local votedOnMap = false
    local mapPicked
    local mapDecided = false
    if IsValid(EndOfGameUI) then EndOfGameUI:Remove() end
    if GetConVar("tm_menudof"):GetInt() == 1 then dof = true end

    local firstMap = net.ReadString()
    local secondMap = net.ReadString()

    local firstMapName
    local firstMapThumb
    local secondMapName
    local secondMapThumb
    local decidedMapName
    local decidedMapThumb

    for m, t in pairs(mapArray) do
        if game.GetMap() == t[1] then
            mapPlayedOn = t[2]
        end

        if firstMap == t[1] then
            firstMapName = t[2]
            firstMapThumb = t[3]
        end

        if secondMap == t[1] then
            secondMapName = t[2]
            secondMapThumb = t[3]
        end
    end

    local timeUntilNextMatch = 30

    local connectedPlayers = player.GetAll()
    table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end)

    --Creates a timer so players can see how long it will be until the next match starts.
    timer.Create("timeUntilNextMatch", 30, 1, function()
    end)

    hook.Add("Think", "VotingTimerUpdate", function()
        if timer.Exists("timeUntilNextMatch") then timeUntilNextMatch = math.Round(timer.TimeLeft("timeUntilNextMatch")) end
    end)

    EndOfGameUI = vgui.Create("DPanel")
    EndOfGameUI:SetSize(ScrW(), ScrH())
    EndOfGameUI:SetPos(0, 0)
    EndOfGameUI:MakePopup()
    EndOfGameUI.Paint = function(self, w, h)
        if dof == true then DrawBokehDOF(4, 1, 0) end
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 225))
        if timeUntilNextMatch > 10 then
            draw.SimpleText("Voting ends in " .. timeUntilNextMatch - 10 .. "s", "MainMenuLoadoutWeapons", 485, ScrH() - 55, white, TEXT_ALIGN_LEFT)
        else
            draw.SimpleText("Match begins in " .. timeUntilNextMatch .. "s", "MainMenuLoadoutWeapons", 485, ScrH() - 55, white, TEXT_ALIGN_LEFT)
        end
        draw.SimpleText("[+1500XP win bonus]", "MainMenuLoadoutWeapons", 485, 100, white, TEXT_ALIGN_LEFT)
    end

    local EndOfGamePanel = vgui.Create("DPanel", EndOfGameUI)
    EndOfGamePanel:SetSize(475, ScrH())
    EndOfGamePanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
    end

    local MatchInformationPanel = vgui.Create("DPanel", EndOfGamePanel)
    MatchInformationPanel:Dock(TOP)
    MatchInformationPanel:SetSize(0, 100)
    MatchInformationPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
        draw.SimpleText("MATCH ENDED", "GunPrintName", 90, 15, white, TEXT_ALIGN_LEFT)
        draw.SimpleText("FFA on " .. mapPlayedOn .. " | " .. GetConVar("tm_matchlengthtimer"):GetInt() .. "s", "MainMenuLoadoutWeapons", 90, 65, white, TEXT_ALIGN_LEFT)
    end

    local VictoryImage = vgui.Create("DImage", MatchInformationPanel)
    VictoryImage:SetPos(0, 10)
    VictoryImage:SetSize(80, 80)
    VictoryImage:SetImage("icons/accoladeicon.png")

    local VotingPanel = vgui.Create("DPanel", EndOfGamePanel)
    VotingPanel:Dock(BOTTOM)
    VotingPanel:SetSize(0, 275)
    VotingPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
        if mapDecided == false then
            if mapPicked == 1 then draw.RoundedBox(0, 10, 70, 175, 175, Color(50, 125, 50, 75)) end
            if mapPicked == 2 then draw.RoundedBox(0, 290, 70, 175, 175, Color(50, 125, 50, 75)) end
            draw.SimpleText("MAP VOTE", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)

            draw.SimpleText(firstMapName, "MainMenuLoadoutWeapons", 10, 245, white, TEXT_ALIGN_LEFT)
            draw.SimpleText(secondMapName, "MainMenuLoadoutWeapons", 465, 245, white, TEXT_ALIGN_RIGHT)
            draw.SimpleText(GetGlobalInt("VotesOnMapOne", 0) .. " | " .. GetGlobalInt("VotesOnMapTwo"), "MainMenuLoadoutWeapons", w / 2, 245, white, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("NEXT MAP", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)
            draw.SimpleText(decidedMapName, "MainMenuLoadoutWeapons", w / 2, 245, white, TEXT_ALIGN_CENTER)
        end
    end

    local PlayerScrollPanel = vgui.Create("DScrollPanel", EndOfGamePanel)
    PlayerScrollPanel:Dock(FILL)
    PlayerScrollPanel:SetSize(EndOfGamePanel:GetWide(), 0)
    PlayerScrollPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
    end

    local sbar = PlayerScrollPanel:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(0, 0, 0, 150))
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 155))
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 155))
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
    end

    PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
    PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())

    for k, v in pairs(connectedPlayers) do
        --Constants for basic player information, much more optimized than checking every frame.
        local name = v:GetName()
        local prestige = v:GetNWInt("playerPrestige")
        local level = v:GetNWInt("playerLevel")
        local ping = v:Ping()
        local frags = v:Frags()
        local deaths = v:Deaths()
        local ratio
        local score = v:GetNWInt("playerScoreMatch")

        --Used to format the K/D Ratio of a player, stops it from displaying INF when the player has gotten a kill, but has also not died yet.
        if v:Frags() <= 0 then
            ratio = 0
        elseif v:Frags() >= 1 and v:Deaths() == 0 then
            ratio = v:Frags()
        else
            ratio = v:Frags() / v:Deaths()
        end

        local ratioRounded = math.Round(ratio, 2)

        local PlayerPanel = vgui.Create("DPanel", PlayerList)
        PlayerPanel:SetSize(PlayerList:GetWide(), 125)
        PlayerPanel:SetPos(0, 0)
        PlayerPanel.Paint = function(self, w, h)
            if not IsValid(v) then return end
            if k == 1 then draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 35, 40)) else draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 40)) end

            draw.SimpleText(name .. " | " .. "P" .. prestige .. " L" .. level .. " | " .. score .. " Score", "Health", 10, 0, white, TEXT_ALIGN_LEFT)
            draw.SimpleText(frags, "Health", 285, 35, Color(0, 255, 0), TEXT_ALIGN_LEFT)
            draw.SimpleText(deaths, "Health", 285, 60, Color(255, 0, 0), TEXT_ALIGN_LEFT)
            draw.SimpleText(ratioRounded, "Health", 285, 85, Color(255, 255, 0), TEXT_ALIGN_LEFT)
        end

        local KillsIcon = vgui.Create("DImage", PlayerPanel)
		KillsIcon:SetPos(260, 42)
		KillsIcon:SetSize(20, 20)
		KillsIcon:SetImage("icons/killicon.png")

		local DeathsIcon = vgui.Create("DImage", PlayerPanel)
		DeathsIcon:SetPos(260, 67)
		DeathsIcon:SetSize(20, 20)
		DeathsIcon:SetImage("icons/deathicon.png")

		local KDIcon = vgui.Create("DImage", PlayerPanel)
		KDIcon:SetPos(260, 92)
		KDIcon:SetSize(20, 20)
		KDIcon:SetImage("icons/ratioicon.png")

        --Displays a players calling card and profile picture.
        local PlayerCallingCard = vgui.Create("DImage", PlayerPanel)
        PlayerCallingCard:SetPos(10, 35)
        PlayerCallingCard:SetSize(240, 80)

        if IsValid(v) then PlayerCallingCard:SetImage(v:GetNWString("chosenPlayercard"), "cards/color/black.png") end

        local PlayerProfilePicture = vgui.Create("AvatarImage", PlayerCallingCard)
        PlayerProfilePicture:SetPos(5, 5)
        PlayerProfilePicture:SetSize(70, 70)
        PlayerProfilePicture:SetPlayer(v, 184)
    end

    local MapChoice = vgui.Create("DImageButton", VotingPanel)
    local MapChoiceTwo = vgui.Create("DImageButton", VotingPanel)

    MapChoice:SetPos(10, 70)
    MapChoice:SetText("")
    MapChoice:SetSize(175, 175)
    MapChoice:SetImage(firstMapThumb)
    MapChoice.DoClick = function()
        net.Start("ReceiveMapVote")
        net.WriteString(firstMap)
        net.WriteUInt(1, 2)
        net.SendToServer()
        votedOnMap = true
        mapPicked = 1
        surface.PlaySound("buttons/button15.wav")

        MapChoice:SetPos(20, 80)
        MapChoice:SetSize(155, 155)
        MapChoice:SetEnabled(false)
        MapChoiceTwo:SetEnabled(false)
    end

    MapChoiceTwo:SetPos(290, 70)
    MapChoiceTwo:SetText("")
    MapChoiceTwo:SetSize(175, 175)
    MapChoiceTwo:SetImage(secondMapThumb)
    MapChoiceTwo.DoClick = function()
        net.Start("ReceiveMapVote")
        net.WriteString(secondMap)
        net.WriteUInt(2, 2)
        net.SendToServer()
        votedOnMap = true
        mapPicked = 2
        surface.PlaySound("buttons/button15.wav")

        MapChoiceTwo:SetPos(300, 80)
        MapChoiceTwo:SetSize(155, 155)
        MapChoice:SetEnabled(false)
        MapChoiceTwo:SetEnabled(false)
	end

    net.Receive("MapVoteCompleted", function(len, ply)
        local decidedMap = net.ReadString()
        for u, p in pairs(mapArray) do
            if decidedMap == p[1] then
                decidedMapName = p[2]
                decidedMapThumb = p[3]
            end
        end

        mapDecided = true
        MapChoice:Remove()
        MapChoiceTwo:Remove()

        local DecidedMapThumb = vgui.Create("DImage", VotingPanel)
        DecidedMapThumb:SetPos(150, 70)
        DecidedMapThumb:SetText("")
        DecidedMapThumb:SetSize(175, 175)
        DecidedMapThumb:SetImage(decidedMapThumb)
    end )

    local ExitButton = vgui.Create("DButton", EndOfGameUI)
    ExitButton:SetPos(485, ScrH() - 35)
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
            draw.DrawText("EXIT GAME", "MainMenuLoadoutWeapons", textAnim, 5, white, TEXT_ALIGN_LEFT)
        else
            draw.DrawText("CONFIRM?", "MainMenuLoadoutWeapons", textAnim, 5, Color(255, 0, 0), TEXT_ALIGN_LEFT)
        end
    end
    ExitButton.DoClick = function()
        surface.PlaySound("tmui/buttonclick.wav")
        if (disconnectConfirm == 0) then
            disconnectConfirm = 1
        else
            RunConsoleCommand("disconnect")
        end

        timer.Simple(3, function() disconnectConfirm = 0 end)
    end

    EndOfGameUI:Show()
    gui.EnableScreenClicker(true)
end )

--Displays after a player levels up.
net.Receive("NotifyLevelUp", function(len, ply)
    if IsValid(LevelNotif) then LevelNotif:Remove() end
    local previousLevel = net.ReadInt(8)

    LevelNotif = vgui.Create("DFrame")
    LevelNotif:SetSize(600, 100)
    LevelNotif:SetX(ScrW() / 2 - 300)
    LevelNotif:SetY(ScrH())
    LevelNotif:SetTitle("")
    LevelNotif:SetDraggable(false)
    LevelNotif:ShowCloseButton(false)
    LevelNotif:MoveTo(ScrW() / 2 - 300, ScrH() - 110, 0.5, 0, 0.25)

    LevelNotif.Paint = function(self, w, h)
        draw.SimpleText("LEVEL UP", "HUD_PlayerNotiName", 300, 25, Color(255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(previousLevel .. "  > " .. previousLevel + 1, "HUD_PlayerNotiName", 300, 80, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    LevelNotif:Show()
    LevelNotif:MakePopup()
    LevelNotif:SetMouseInputEnabled(false)
    LevelNotif:SetKeyboardInputEnabled(false)

    LocalPlayer():ScreenFade(SCREENFADE.IN, Color(255, 255, 0, 45), 0.3, 0)
    surface.PlaySound("tmui/levelup.wav")

    timer.Create("LevelNotif", 6, 1, function()
        LevelNotif:MoveTo(ScrW() / 2 - 300, ScrH(), 1, 0, 0.25, function()
            LevelNotif:Remove()
        end)
    end)
end )

--Displays after a player levels up.
net.Receive("NotifyMatchTime", function(len, ply)
    if IsValid(TimeNotif) then TimeNotif:Remove() end
    matchTime = math.Round(net.ReadInt(16))
    matchTimeFormatted = string.FormattedTime(matchTime, "%i:%02i")

    if matchTime > 10 then
        TimeNotif = vgui.Create("DFrame")
        TimeNotif:SetSize(600, 100)
        TimeNotif:SetX(ScrW() / 2 - 300)
        TimeNotif:SetY(ScrH())
        TimeNotif:SetTitle("")
        TimeNotif:SetDraggable(false)
        TimeNotif:ShowCloseButton(false)
        TimeNotif:MoveTo(ScrW() / 2 - 300, ScrH() - 400, 0.5, 0, 0.25)

        TimeNotif.Paint = function(self, w, h)
            draw.SimpleText(matchTimeFormatted, "HUD_PlayerNotiName", 300, 25, Color(255, 0, 0, 241), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Remaining", "HUD_WepNameKill", 300, 60, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        TimeNotif:Show()
        TimeNotif:MakePopup()
        TimeNotif:SetMouseInputEnabled(false)
        TimeNotif:SetKeyboardInputEnabled(false)

        surface.PlaySound("tmui/timenotif.wav")

        timer.Create("TimeNotif", 4, 1, function()
            TimeNotif:MoveTo(ScrW() / 2 - 300, ScrH(), 1, 0, 0.25, function()
                TimeNotif:Remove()
            end)
        end)
    else
        TimeNotif = vgui.Create("DFrame")
        TimeNotif:SetSize(600, 100)
        TimeNotif:SetX(ScrW() / 2 - 300)
        TimeNotif:SetY(ScrH())
        TimeNotif:SetTitle("")
        TimeNotif:SetDraggable(false)
        TimeNotif:ShowCloseButton(false)
        TimeNotif:MoveTo(ScrW() / 2 - 300, ScrH() - 400, 0.5, 0, 0.25)

        TimeNotif.Paint = function(self, w, h)
            draw.SimpleText(math.Round(GetGlobalInt("tm_matchtime", 0) - CurTime()), "HUD_AmmoCount", 300, 45, Color(255, 0, 0, 241), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        TimeNotif:Show()
        TimeNotif:MakePopup()
        TimeNotif:SetMouseInputEnabled(false)
        TimeNotif:SetKeyboardInputEnabled(false)

        surface.PlaySound("tmui/timenotif.wav")

        timer.Create("TimeNotif", 10, 1, function()
            TimeNotif:Remove()
        end)
    end
end )

--Shows the players loadout on the bottom left hand side of their screen.
function ShowLoadoutOnSpawn()
    local primaryWeapon = ""
    local secondaryWeapon = ""
    local meleeWeapon = ""
    for k, v in pairs(weaponArray) do
        if v[1] == LocalPlayer():GetNWString("loadoutPrimary") and usePrimary then primaryWeapon = v[2] end
        if v[1] == LocalPlayer():GetNWString("loadoutSecondary") and useSecondary then secondaryWeapon = v[2] end
        if v[1] == LocalPlayer():GetNWString("loadoutMelee") and useMelee then meleeWeapon = v[2] end
    end
    notification.AddProgress("LoadoutText", "Current Loadout:\n" .. primaryWeapon .. "\n" .. secondaryWeapon .. "\n" .. meleeWeapon)
    timer.Simple(2.5, function()
        notification.Kill("LoadoutText")
    end)
end
concommand.Add("tm_showloadout", ShowLoadoutOnSpawn)

--ConVar callbacks related to HUD editing, much more optimized and cleaner looking than repeadetly checking the players settings.
cvars.AddChangeCallback("tm_hud_health_size", function(convar_name, value_old, value_new)
    healthSize = value_new
end)
cvars.AddChangeCallback("tm_hud_health_offset_x", function(convar_name, value_old, value_new)
    healthOffsetX = value_new
end)
cvars.AddChangeCallback("tm_hud_health_offset_y", function(convar_name, value_old, value_new)
    healthOffsetY = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_wep_text_color_r", function(convar_name, value_old, value_new)
    wepTextR = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_wep_text_color_g", function(convar_name, value_old, value_new)
    wepTextG = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_wep_text_color_b", function(convar_name, value_old, value_new)
    wepTextB = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_bar_color_r", function(convar_name, value_old, value_new)
    ammoBarR = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_bar_color_g", function(convar_name, value_old, value_new)
    ammoBarG = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_bar_color_b", function(convar_name, value_old, value_new)
    ammoBarB = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_text_color_r", function(convar_name, value_old, value_new)
    ammoTextR = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_text_color_g", function(convar_name, value_old, value_new)
    ammoTextG = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_text_color_b", function(convar_name, value_old, value_new)
    ammoTextB = value_new
end)
cvars.AddChangeCallback("tm_hud_health_text_color_r", function(convar_name, value_old, value_new)
    hpTextR = value_new
end)
cvars.AddChangeCallback("tm_hud_health_text_color_g", function(convar_name, value_old, value_new)
    hpTextG = value_new
end)
cvars.AddChangeCallback("tm_hud_health_text_color_b", function(convar_name, value_old, value_new)
    hpTextB = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_high_r", function(convar_name, value_old, value_new)
    hpHighR = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_high_g", function(convar_name, value_old, value_new)
    hpHighG = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_high_b", function(convar_name, value_old, value_new)
    hpHighB = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_mid_r", function(convar_name, value_old, value_new)
    hpMidR = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_mid_g", function(convar_name, value_old, value_new)
    hpMidG = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_mid_b", function(convar_name, value_old, value_new)
    hpMidB = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_low_r", function(convar_name, value_old, value_new)
    hpLowR = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_low_g", function(convar_name, value_old, value_new)
    hpLowG = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_low_b", function(convar_name, value_old, value_new)
    hpLowB = value_new
end)
cvars.AddChangeCallback("tm_hud_equipment_offset_x", function(convar_name, value_old, value_new)
    equipOffsetX = value_new
end)
cvars.AddChangeCallback("tm_hud_equipment_offset_y", function(convar_name, value_old, value_new)
    equipOffsetY = value_new
end)
cvars.AddChangeCallback("tm_hud_killfeed_offset_x", function(convar_name, value_old, value_new)
    feedOffsetX = value_new
end)
cvars.AddChangeCallback("tm_hud_killfeed_offset_y", function(convar_name, value_old, value_new)
    feedOffsetY = value_new
end)
cvars.AddChangeCallback("tm_hud_killfeed_opacity", function(convar_name, value_old, value_new)
    feedOpacity = value_new
end)
cvars.AddChangeCallback("tm_hud_killdeath_offset_x", function(convar_name, value_old, value_new)
    kdOffsetX = value_new
end)
cvars.AddChangeCallback("tm_hud_killdeath_offset_y", function(convar_name, value_old, value_new)
    kdOffsetY = value_new
end)
cvars.AddChangeCallback("tm_hud_kill_iconcolor_r", function(convar_name, value_old, value_new)
    kIconR = value_new
end)
cvars.AddChangeCallback("tm_hud_kill_iconcolor_g", function(convar_name, value_old, value_new)
    kIconG = value_new
end)
cvars.AddChangeCallback("tm_hud_kill_iconcolor_b", function(convar_name, value_old, value_new)
    kIconB = value_new
end)
cvars.AddChangeCallback("tm_hud_font_kill", function(convar_name, value_old, value_new)
    if value_new == "1" then
        StreakFont = "HUD_StreakText"
        NameFont = "HUD_PlayerNotiName"
    else
        StreakFont = "StreakText"
        NameFont = "PlayerNotiName"
    end
end)
cvars.AddChangeCallback("tm_hud_font_death", function(convar_name, value_old, value_new)
    if value_new == "1" then
        ArialFont = "HUD_Arial18"
        DeathFont = "HUD_PlayerDeathName"
        WepFont = "HUD_WepNameKill"
    else
        ArialFont = "Arial18"
        DeathFont = "PlayerDeathName"
        WepFont = "WepNameKill"
    end
end)
cvars.AddChangeCallback("tm_hud_killfeed_style", function(convar_name, value_old, value_new)
    if value_new == 0 then
        feedEntryPadding = -20
    else
        feedEntryPadding = 20
    end
end)
cvars.AddChangeCallback("tm_hud_equipment_anchor", function(convar_name, value_old, value_new)
    if value_new == 0 then
        equipAnchor = "left"
    elseif value_new == 1 then
        equipAnchor = "center"
    elseif value_new == 2 then
        equipAnchor = "right"
    end
end)