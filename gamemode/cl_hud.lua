scrW, scrH = ScrW(), ScrH()
center_x, center_y = ScrW() / 2, ScrH() / 2
scale = center_y * (2 / 1080)

local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)

local gameEnded = false
local matchStartPopupSeen = false
local feedArray = {}

local crosshair = {}
local matchHUD = {}
local healthHUD = {}
local weaponHUD = {}
local equipmentHUD = {}
local feedHUD = {}
local killdeathHUD = {}
local kpoHUD = {}
local velocityHUD = {}
local objHUD = {}
local sounds = {}
local convars = {}

function UpdateHUD()
    -- Calling GetConVar() is pretty expensive so we cache ConVars here so GetConVar() isn't ran multiple times a frame
    crosshair = {
        ["enabled"] = GetConVar("tm_hud_crosshair"):GetInt(),
        ["style"] = GetConVar("tm_hud_crosshair_style"):GetInt(),
        ["gap"] = GetConVar("tm_hud_crosshair_gap"):GetInt(),
        ["size"] = GetConVar("tm_hud_crosshair_size"):GetInt(),
        ["thickness"] = GetConVar("tm_hud_crosshair_thickness"):GetInt(),
        ["dot"] = GetConVar("tm_hud_crosshair_dot"):GetInt(),
        ["outline"] = GetConVar("tm_hud_crosshair_outline"):GetInt(),
        ["opacity"] = GetConVar("tm_hud_crosshair_opacity"):GetInt(),
        ["r"] = GetConVar("tm_hud_crosshair_color_r"):GetInt(),
        ["g"] = GetConVar("tm_hud_crosshair_color_g"):GetInt(),
        ["b"] = GetConVar("tm_hud_crosshair_color_b"):GetInt(),
        ["outline_r"] = GetConVar("tm_hud_crosshair_outline_color_r"):GetInt(),
        ["outline_g"] = GetConVar("tm_hud_crosshair_outline_color_g"):GetInt(),
        ["outline_b"] = GetConVar("tm_hud_crosshair_outline_color_b"):GetInt(),
        ["show_t"] = GetConVar("tm_hud_crosshair_show_t"):GetInt(),
        ["show_b"] = GetConVar("tm_hud_crosshair_show_b"):GetInt(),
        ["show_l"] = GetConVar("tm_hud_crosshair_show_l"):GetInt(),
        ["show_r"] = GetConVar("tm_hud_crosshair_show_r"):GetInt()
    }

    matchHUD = {
        ["y"] = GetConVar("tm_hud_bounds_y"):GetInt()
    }

    healthHUD = {
        ["size"] = GetConVar("tm_hud_health_size"):GetInt(),
        ["x"] = GetConVar("tm_hud_health_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(),
        ["y"] = GetConVar("tm_hud_health_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt(),
        ["barhigh_r"] = GetConVar("tm_hud_health_color_high_r"):GetInt(),
        ["barhigh_g"] = GetConVar("tm_hud_health_color_high_g"):GetInt(),
        ["barhigh_b"] = GetConVar("tm_hud_health_color_high_b"):GetInt(),
        ["barmid_r"] = GetConVar("tm_hud_health_color_mid_r"):GetInt(),
        ["barmid_g"] = GetConVar("tm_hud_health_color_mid_g"):GetInt(),
        ["barmid_b"] = GetConVar("tm_hud_health_color_mid_b"):GetInt(),
        ["barlow_r"] = GetConVar("tm_hud_health_color_low_r"):GetInt(),
        ["barlow_g"] = GetConVar("tm_hud_health_color_low_g"):GetInt(),
        ["barlow_b"] = GetConVar("tm_hud_health_color_low_b"):GetInt()
    }

    weaponHUD = {
        ["x"] = GetConVar("tm_hud_bounds_x"):GetInt(),
        ["y"] = GetConVar("tm_hud_bounds_y"):GetInt(),
        ["ammobar_r"] = GetConVar("tm_hud_ammo_bar_color_r"):GetInt(),
        ["ammobar_g"] = GetConVar("tm_hud_ammo_bar_color_g"):GetInt(),
        ["ammobar_b"] = GetConVar("tm_hud_ammo_bar_color_b"):GetInt()
    }

    equipmentHUD = {
        ["x"] = GetConVar("tm_hud_equipment_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(),
        ["y"] = GetConVar("tm_hud_equipment_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt(),
    }

    feedHUD = {
        ["x"] = GetConVar("tm_hud_killfeed_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(),
        ["y"] = GetConVar("tm_hud_killfeed_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt(),
        ["opacity"] = GetConVar("tm_hud_killfeed_opacity"):GetInt()
    }

    killdeathHUD = {
        ["x"] = GetConVar("tm_hud_killdeath_offset_x"):GetInt(),
        ["y"] = GetConVar("tm_hud_killdeath_offset_y"):GetInt(),
        ["killicon_r"] = GetConVar("tm_hud_kill_iconcolor_r"):GetInt(),
        ["killicon_g"] = GetConVar("tm_hud_kill_iconcolor_g"):GetInt(),
        ["killicon_b"] = GetConVar("tm_hud_kill_iconcolor_b"):GetInt()
    }

    kpoHUD = {
        ["x"] = GetConVar("tm_hud_keypressoverlay_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(),
        ["y"] = GetConVar("tm_hud_keypressoverlay_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt(),
        ["inactive_r"] = GetConVar("tm_hud_keypressoverlay_inactive_r"):GetInt(),
        ["inactive_g"] = GetConVar("tm_hud_keypressoverlay_inactive_g"):GetInt(),
        ["inactive_b"] = GetConVar("tm_hud_keypressoverlay_inactive_b"):GetInt(),
        ["actuated_r"] = GetConVar("tm_hud_keypressoverlay_actuated_r"):GetInt(),
        ["actuated_g"] = GetConVar("tm_hud_keypressoverlay_actuated_g"):GetInt(),
        ["actuated_b"] = GetConVar("tm_hud_keypressoverlay_actuated_b"):GetInt()
    }

    velocityHUD = {
        ["x"] = GetConVar("tm_hud_velocitycounter_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(),
        ["y"] = GetConVar("tm_hud_velocitycounter_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()
    }

    objHUD = {
        ["scale"] = GetConVar("tm_hud_obj_scale"):GetInt(),
        ["obj_empty_r"] = GetConVar("tm_hud_obj_color_empty_r"):GetInt(),
        ["obj_empty_g"] = GetConVar("tm_hud_obj_color_empty_g"):GetInt(),
        ["obj_empty_b"] = GetConVar("tm_hud_obj_color_empty_b"):GetInt(),
        ["obj_occupied_r"] = GetConVar("tm_hud_obj_color_occupied_r"):GetInt(),
        ["obj_occupied_g"] = GetConVar("tm_hud_obj_color_occupied_g"):GetInt(),
        ["obj_occupied_b"] = GetConVar("tm_hud_obj_color_occupied_b"):GetInt(),
        ["obj_contested_r"] = GetConVar("tm_hud_obj_color_contested_r"):GetInt(),
        ["obj_contested_g"] = GetConVar("tm_hud_obj_color_contested_g"):GetInt(),
        ["obj_contested_b"] = GetConVar("tm_hud_obj_color_contested_b"):GetInt()
    }

    notis = {
        ["x"] = GetConVar("tm_hud_bounds_x"):GetInt(),
        ["y"] = GetConVar("tm_hud_bounds_y"):GetInt()
    }

    sounds = {
        ["hit_enabled"] = GetConVar("tm_hitsounds"):GetInt(),
        ["kill_enabled"] = GetConVar("tm_killsound"):GetInt(),
        ["hit"] = GetConVar("tm_hitsoundtype"):GetInt(),
        ["kill"] = GetConVar("tm_killsoundtype"):GetInt()
    }

    convars = {
        ["text_r"] = GetConVar("tm_hud_text_color_r"):GetInt(),
        ["text_g"] = GetConVar("tm_hud_text_color_g"):GetInt(),
        ["text_b"] = GetConVar("tm_hud_text_color_b"):GetInt(),
        ["hud_enable"] = GetConVar("tm_hud_enable"):GetInt(),
        ["notif_enable"] = GetConVar("tm_hud_notifications"):GetInt(),
        ["ammo_style"] = GetConVar("tm_hud_ammo_style"):GetInt(),
        ["kill_tracker"] = GetConVar("tm_hud_killtracker"):GetInt(),
        ["reload_hints"] = GetConVar("tm_hud_reloadhint"):GetInt(),
        ["grapple_bind"] = GetConVar("frest_bindg"):GetInt(),
        ["nade_bind"] = GetConVar("tm_nadebind"):GetInt(),
        ["menu_bind"] = GetConVar("tm_mainmenubind"):GetInt(),
        ["keypress_overlay"] = GetConVar("tm_hud_keypressoverlay"):GetInt(),
        ["velocity_counter"] = GetConVar("tm_hud_velocitycounter"):GetInt(),
        ["quick_switching"] = GetConVar("tm_quickswitching"):GetInt(),
        ["killfeed_enable"] = GetConVar("tm_hud_enablekillfeed"):GetInt(),
        ["killfeed_limit"] = GetConVar("tm_hud_killfeed_limit"):GetInt(),
        ["screen_flashes"] = GetConVar("tm_screenflashes"):GetInt(),
        ["menu_dof"] = GetConVar("tm_menudof"):GetInt(),
        ["music_volume"] = GetConVar("tm_musicvolume"):GetFloat()
    }

    actuatedColor = Color(kpoHUD["actuated_r"], kpoHUD["actuated_g"], kpoHUD["actuated_b"])
    inactiveColor = Color(kpoHUD["inactive_r"], kpoHUD["inactive_g"], kpoHUD["inactive_b"])
    if GetConVar("tm_hud_killfeed_style"):GetInt() == 0 then feedEntryPadding = -20 else feedEntryPadding = 20 end
    if GetConVar("tm_hud_equipment_anchor"):GetInt() == 0 then equipAnchor = "left" elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 1 then equipAnchor = "center" elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 2 then equipAnchor = "right" end
end
UpdateHUD()

local keyMat = Material("icons/keyicon.png", "noclamp smooth")
local keyMatMed = Material("icons/keyiconmedium.png", "noclamp smooth")
local keyMatLong = Material("icons/keyiconlong.png", "noclamp smooth")

local fColor = white
local lColor = white
local bColor = white
local rColor = white
local jColor = white
local sColor = white
local cColor = white

local function KPOKeyCheck(client)
    if client:KeyDown(IN_FORWARD) then fColor = actuatedColor else fColor = inactiveColor end
    if client:KeyDown(IN_MOVELEFT) then lColor = actuatedColor else lColor = inactiveColor end
    if client:KeyDown(IN_BACK) then bColor = actuatedColor else bColor = inactiveColor end
    if client:KeyDown(IN_MOVERIGHT) then rColor = actuatedColor else rColor = inactiveColor end
    if client:KeyDown(IN_JUMP) then jColor = actuatedColor else jColor = inactiveColor end
    if client:KeyDown(IN_SPEED) then sColor = actuatedColor else sColor = inactiveColor end
    if client:KeyDown(IN_DUCK) then cColor = actuatedColor else cColor = inactiveColor end
end

local hillColor
local objIndicatorColor
local hillEmptyMat = Material("icons/kothempty.png")
local border = Material("overlay/objborder.png")

local LocalPly = LocalPlayer()
local timeUntilSelfDestruct = 0
local timeText = " ∞"

local function MatchStartPopup()
    print("CHECKING FOR HUD")
    if GetGlobal2Int("tm_matchtime", 0) - CurTime() > (GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt()) then return end
    print("PASSED INTERMISSION CHECK")
    if convars["hud_enable"] == 0 then return end
    local gm = string.upper(activeGamemode)
    local desc
    local winCondition
    matchStartPopupSeen = true
    surface.SetFont("AmmoCountSmall")
    local popupW, popupH = select(1, surface.GetTextSize(gm))

    if gm == "FFA" then
        desc = "Eliminate other players"
        winCondition = "Get the most score to WIN"
    elseif gm == "CRANKED" then
        desc = "Eliminate other players, movement boost on kill"
        winCondition = "Get the most score to WIN"
    elseif gm == "GUN GAME" then
        desc = "Eliminate other players to advance to the next weapon"
        winCondition = "Get a kill with every each to WIN"
    elseif gm == "SHOTTY SNIPERS" then
        desc = "Eliminate other players with snipers and shotguns"
        winCondition = "Get the most score to WIN"
    elseif gm == "FIESTA" then
        desc = "Eliminate other players with constantly changing loadouts"
        winCondition = "Get the most score to WIN"
    elseif gm == "QUICKDRAW" then
        desc = "Eliminate other players with secondaries"
        winCondition = "Get the most score to WIN"
    elseif gm == "KOTH" then
        desc = "Capture and defend the objective"
        winCondition = "Get the most score to WIN"
    elseif gm == "VIP" then
        desc = "Track down and kill the VIP, defend the status for yourself"
        winCondition = "Get the most score to WIN"
    end

    if IsValid(GamemodePopup) then GamemodePopup:Remove() end
    if IsValid(GamemodeDesc) then GamemodeDesc:Remove() end
    GamemodePopup = vgui.Create("DFrame")
    GamemodePopup:SetSize(popupW + 8, 0)
    GamemodePopup:SizeTo(-1, popupH - 8, 1, 0, 0.1)
    GamemodePopup:SetX(scrW / 2 - (popupW / 2))
    GamemodePopup:SetTitle("")
    GamemodePopup:SetDraggable(false)
    GamemodePopup:ShowCloseButton(false)
    GamemodePopup.Paint = function(self, w, h)
        GamemodePopup:SetY(GamemodePopup:GetTall())
        draw.RoundedBox(0, 0, 0, GamemodePopup:GetWide(), GamemodePopup:GetTall(), Color(50, 50, 50, 100))
        draw.SimpleText(gm, "AmmoCountSmall", w / 2, h / 2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    timer.Create("addAdditionalPopupInfo", 1.5, 1, function()
        surface.SetFont("HUD_Health")
        local descTextW, descTextH = select(1, surface.GetTextSize(desc))
        local winTextW, winTextH = select(1, surface.GetTextSize(winCondition))
        local textW = math.max(descTextW, winTextW)

        GamemodeDesc = vgui.Create("DFrame")
        GamemodeDesc:SetSize(0, descTextH + winTextH + 2)
        GamemodeDesc:SizeTo(textW + 16, descTextH + winTextH + 2, 0.75, 0, 0.1)
        GamemodeDesc:SetY(GamemodePopup:GetTall() + popupH)
        GamemodeDesc:SetTitle("")
        GamemodeDesc:SetDraggable(false)
        GamemodeDesc:ShowCloseButton(false)
        GamemodeDesc.Paint = function(self, w, h)
            GamemodeDesc:SetX(scrW / 2 - (textW / 2))
            draw.RoundedBox(0, 0, 0, GamemodeDesc:GetWide(), GamemodeDesc:GetTall(), Color(50, 50, 50, 100))
            draw.SimpleText(desc, "HUD_Health", w / 2, descTextH / 2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(winCondition, "HUD_Health", w / 2, descTextH + (winTextH / 2), white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end)

    timer.Create("removeGamemodePopup", 6.5, 1, function()
        GamemodePopup:SizeTo(-1, 0, 0.75, 0, 0.1, function()
            GamemodePopup:Remove()
        end)

        GamemodeDesc:SizeTo(-1, 0, 0.25, 0, 0.1, function()
            GamemodeDesc:Remove()
        end)
    end)
end

local TitanmodFOV = GetConVar("tm_customfov_value"):GetInt()
net.Receive("PlayerSpawn", function(len, pl)
    print("TRIGGERING SPAWN")
    if GetConVar("tm_customfov"):GetInt() == 0 then RunConsoleCommand("cl_tfa_viewmodel_multiplier_fov", "1") else RunConsoleCommand("cl_tfa_viewmodel_multiplier_fov", tostring((TitanmodFOV / -100) + 2)) end
    if convars["hud_enable"] == 0 then return end
    if activeGamemode != "Gun Game" then ShowLoadoutOnSpawn(LocalPly) end
    if matchStartPopupSeen == false then MatchStartPopup() end
end )

cvars.AddChangeCallback("tm_customfov_value", function(convar_name, value_old, value_new)
    TitanmodFOV = value_new
end)

hook.Add("RenderScreenspaceEffects", "IntermissionPostProcess", function()
    if GetGlobal2Int("tm_matchtime", 0) - CurTime() < (GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt()) then
        hook.Remove("RenderScreenspaceEffects", "IntermissionPostProcess")
        if LocalPlayer():Alive() then MatchStartPopup() end
    end

    local intTime = (GetGlobal2Int("tm_matchtime", 0) - CurTime()) - (GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt())
    local pp = (-intTime / GetConVar("tm_intermissiontimer"):GetInt()) + 1

    local intermissionpp = {
        [ "$pp_colour_contrast" ] = math.max(0.5, pp),
        [ "$pp_colour_colour" ] = pp,
    }

    if ply:Alive() != true then return end

    DrawColorModify(intermissionpp)
end )

function HUDIntermission(client)
    draw.SimpleText("Match begins in", "HUD_WepNameKill", scrW / 2, scrH / 2 - 190, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()) - (GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt()), "HUD_IntermissionText", scrW / 2, scrH / 2 - 100, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Press [" .. input.GetKeyName(convars["menu_bind"]) .. "] to open menu", "HUD_WepNameKill", scrW / 2, scrH - 200, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function CrosshairStateUpdate(client, wep)
    local gap = 0
    local velocity = tostring(math.Round(client:GetVelocity():Length()))

    if wep != NULL and type(wep.Primary.Spread) == "number" then
        gap = gap + wep.Primary.Spread * 300
        if ply:KeyDown(IN_ATTACK) then gap = gap + 5 end
    end
    if client:Crouching() then gap = gap - 5 end
    if !client:OnGround() then gap = gap + 7 end
    gap = gap + velocity / 55

    return math.Clamp(gap, 0, 100)
end

function HUDAlways(client)
    -- Remaining match time
    timeText = string.FormattedTime(GetGlobal2Int("tm_matchtime", 0) - CurTime(), "%2i:%02i")
    draw.SimpleText(activeGamemode .. " |" .. timeText, "HUD_Health", scrW / 2, -5 + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    if activeGamemode == "Gun Game" then draw.SimpleText(ggLadderSize - client:GetNWInt("ladderPosition") .. " kills left", "HUD_Health", scrW / 2, 25 + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP) elseif activeGamemode == "Fiesta" and (GetGlobal2Int("FiestaTime", 0) - CurTime()) > 0 then draw.SimpleText(string.FormattedTime(math.Round(GetGlobal2Int("FiestaTime", 0) - CurTime()), "%2i:%02i"), "HUD_Health", scrW / 2, 25 + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP) elseif activeGamemode == "Cranked" and timeUntilSelfDestruct != 0 then draw.SimpleText(timeUntilSelfDestruct, "HUD_Health", scrW / 2, 25 + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP) elseif activeGamemode == "KOTH" then
        if GetGlobal2String("tm_hillstatus") == "Occupied" then
            draw.SimpleText(GetGlobal2Entity("tm_entonhill"):GetName(), "HUD_Health", scrW / 2, 25 + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        else
            draw.SimpleText(GetGlobal2String("tm_hillstatus"), "HUD_Health", scrW / 2, 25 + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    elseif activeGamemode == "VIP" then
        if GetGlobal2Entity("tm_vip") != NULL then
            draw.SimpleText(GetGlobal2Entity("tm_vip"):GetName(), "HUD_Health", scrW / 2, 25 + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            if GetGlobal2Entity("tm_vip") != client then draw.SimpleText(math.Round(client:GetPos():Distance(GetGlobal2Entity("tm_vip"):GetPos()) * 0.01905) .. "m", "HUD_Health", scrW / 2, 105 + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP) end
        else
            draw.SimpleText("No VIP", "HUD_Health", scrW / 2, 25 + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    end

    -- Kill feed
    surface.SetFont("HUD_StreakText")
    for k, v in pairs(feedArray) do
        if v[2] == 1 and v[2] != nil then surface.SetDrawColor(150, 50, 50, feedHUD["opacity"]) else surface.SetDrawColor(50, 50, 50, feedHUD["opacity"]) end
        local nameLength = select(1, surface.GetTextSize(v[1]))

        surface.DrawRect(feedHUD["x"], scrH - 20 + ((k - 1) * feedEntryPadding) - feedHUD["y"], nameLength + 5, 20)
        draw.SimpleText(v[1], "HUD_StreakText", 2.5 + feedHUD["x"], scrH - 10 + ((k - 1) * feedEntryPadding) - feedHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Objective indicator
    if activeGamemode == "KOTH" then
        if GetGlobal2String("tm_hillstatus") == "Empty" then
            hillColor = Color(objHUD["obj_empty_r"], objHUD["obj_empty_g"], objHUD["obj_empty_b"], 3)
            objIndicatorColor = Color(objHUD["obj_empty_r"], objHUD["obj_empty_g"], objHUD["obj_empty_b"], 175)
        elseif GetGlobal2String("tm_hillstatus") == "Occupied" then
            hillColor = Color(objHUD["obj_occupied_r"], objHUD["obj_occupied_g"], objHUD["obj_occupied_b"], 3)
            objIndicatorColor = Color(objHUD["obj_occupied_r"], objHUD["obj_occupied_g"], objHUD["obj_occupied_b"], 175)
        else
            hillColor = Color(objHUD["obj_contested_r"], objHUD["obj_contested_g"], objHUD["obj_contested_b"], 3)
            objIndicatorColor = Color(objHUD["obj_contested_r"], objHUD["obj_contested_g"], objHUD["obj_contested_b"], 175)
        end

        surface.SetMaterial(border)
        surface.SetDrawColor(objIndicatorColor)
        if client:GetNWBool("onOBJ") then surface.DrawTexturedRect(0, 0, scrW, scrH) end
    elseif activeGamemode == "VIP" then
        surface.SetMaterial(border)
        surface.SetDrawColor(objHUD["obj_occupied_r"], objHUD["obj_occupied_g"], objHUD["obj_occupied_b"], 175)
        if GetGlobal2Entity("tm_vip", NULL) == client then surface.DrawTexturedRect(0, 0, scrW, scrH) end
    end

    -- KOTH status icons
    if activeGamemode == "KOTH" then
        if GetGlobal2String("tm_hillstatus") == "Empty" then
            surface.SetDrawColor(255, 255, 255, 100)
            surface.SetMaterial(hillEmptyMat)
        else
            surface.SetDrawColor(objHUD["obj_contested_r"], objHUD["obj_contested_g"], objHUD["obj_contested_b"], 100)
            surface.SetMaterial(hillEmptyMat)
        end
        surface.DrawTexturedRect(scrW / 2 - 21, 60 + matchHUD["y"], 42, 42)
    end

    -- VIP status icons
    if activeGamemode == "VIP" then
        surface.SetDrawColor(objHUD["obj_occupied_r"], objHUD["obj_occupied_g"], objHUD["obj_occupied_b"], 225)
        surface.SetMaterial(hillEmptyMat)
        surface.DrawTexturedRect(scrW / 2 - 24, 57 + matchHUD["y"], 48, 48)
    end
end

local health
local weapon
local ammo
local adsFade = 1
local dyn = 0

-- HUD lerp functinos
local smoothDyn = 0
local startDyn = 0
local newDyn = 0
local oldDyn = 0
local function LerpCrosshair()
    smoothDyn = Lerp((SysTime() - startDyn ) / 0.07, oldDyn, newDyn)

    if newDyn != dyn then
        if (smoothDyn != dyn) then newDyn = smoothDyn end
        oldDyn = newDyn
        startDyn = SysTime()
        newDyn = dyn
    end
end

local smoothHP = 0
local startHP = 0
local newHP = 0
local oldHP = 0
local function LerpHealth()
    smoothHP = Lerp((SysTime() - startHP ) / 0.1, oldHP, newHP)

    if newHP != health then
        if (smoothHP != health) then newHP = smoothHP end
        oldHP = newHP
        startHP = SysTime()
        newHP = health
    end
end

local smoothAmmo = 0
local startAmmo = 0
local newAmmo = 0
local oldAmmo = 0
local function LerpAmmo()
    smoothAmmo = Lerp((SysTime() - startAmmo ) / 0.1, oldAmmo, newAmmo)

    if newAmmo != ammo then
        if (smoothAmmo != ammo) then newAmmo = smoothAmmo end
        oldAmmo = newAmmo
        startAmmo = SysTime()
        newAmmo = ammo
    end
end

function HUDAlive(client)
    if client:Health() <= 0 then health = 0 else health = client:Health() end
    weapon = client:GetActiveWeapon()
    LerpCrosshair()

    if (type(weapon.GetIronSights) == "function" and weapon:GetIronSights()) or (client:IsSprinting() and client:OnGround()) then adsFade = math.Clamp(adsFade - 7 * RealFrameTime(), 0, 1) else adsFade = math.Clamp(adsFade + 4 * RealFrameTime(), 0, 1) end
    -- Crosshair
    if crosshair["style"] == 1 then
        dyn = CrosshairStateUpdate(client, weapon)
        LerpCrosshair(client)
    else dyn = 0 end
    if crosshair["enabled"] == 1 then
        if crosshair["outline"] == 1 then
            surface.SetDrawColor(Color(crosshair["outline_r"], crosshair["outline_g"], crosshair["outline_b"], crosshair["opacity"] * adsFade))
            if crosshair["show_r"] == 1 then surface.DrawRect(center_x + (crosshair["gap"] + smoothDyn) - 1, center_y - math.floor(crosshair["thickness"] / 2) - 1, crosshair["size"] + 2,  crosshair["thickness"] + 2) end
            if crosshair["show_l"] == 1 then surface.DrawRect(center_x - (crosshair["gap"] + smoothDyn) - crosshair["size"] + crosshair["thickness"] % 2 - 1, center_y - math.floor(crosshair["thickness"] / 2) - 1, crosshair["size"] + 2,  crosshair["thickness"] + 2) end
            if crosshair["show_b"] == 1 then surface.DrawRect(center_x - math.floor(crosshair["thickness"] / 2) - 1, center_y + (crosshair["gap"] + smoothDyn) - 1, crosshair["thickness"] + 2, crosshair["size"] + 2) end
            if crosshair["show_t"] == 1 then surface.DrawRect(center_x - math.floor(crosshair["thickness"] / 2) - 1, center_y - crosshair["size"] - (crosshair["gap"] + smoothDyn) + crosshair["thickness"] % 2 - 1, crosshair["thickness"] + 2, crosshair["size"] + 2) end
            if crosshair["dot"] == 1 then surface.DrawRect(center_x - math.floor(crosshair["thickness"] / 2) - 1, center_y - math.floor(crosshair["thickness"] / 2) - 1, crosshair["thickness"] + 2, crosshair["thickness"] + 2) end
        end
        surface.SetDrawColor(Color(crosshair["r"], crosshair["g"], crosshair["b"], crosshair["opacity"] * adsFade))
        if crosshair["show_r"] == 1 then surface.DrawRect(center_x + (crosshair["gap"] + smoothDyn), center_y - math.floor(crosshair["thickness"] / 2), crosshair["size"],  crosshair["thickness"]) end
        if crosshair["show_l"] == 1 then surface.DrawRect(center_x - (crosshair["gap"] + smoothDyn) - crosshair["size"] + crosshair["thickness"] % 2, center_y - math.floor(crosshair["thickness"] / 2), crosshair["size"],  crosshair["thickness"]) end
        if crosshair["show_b"] == 1 then surface.DrawRect(center_x - math.floor(crosshair["thickness"] / 2), center_y + (crosshair["gap"] + smoothDyn), crosshair["thickness"], crosshair["size"]) end
        if crosshair["show_t"] == 1 then surface.DrawRect(center_x - math.floor(crosshair["thickness"] / 2), center_y - crosshair["size"] - (crosshair["gap"] + smoothDyn) + crosshair["thickness"] % 2, crosshair["thickness"], crosshair["size"]) end
        if crosshair["dot"] == 1 then surface.DrawRect(center_x - math.floor(crosshair["thickness"] / 2), center_y - math.floor(crosshair["thickness"] / 2), crosshair["thickness"], crosshair["thickness"]) end
    end

    -- Health
    LerpHealth()
    surface.SetDrawColor(50, 50, 50, 80)
    surface.DrawRect(healthHUD["x"], scrH - 30 - healthHUD["y"], healthHUD["size"], 30)

    if health <= (playerHealth / 1.5) then
        if health <= (playerHealth / 3) then
            surface.SetDrawColor(healthHUD["barlow_r"], healthHUD["barlow_g"], healthHUD["barlow_b"], 120)
        else
            surface.SetDrawColor(healthHUD["barmid_r"], healthHUD["barmid_g"], healthHUD["barmid_b"], 120)
        end
    else
        surface.SetDrawColor(healthHUD["barhigh_r"], healthHUD["barhigh_g"], healthHUD["barhigh_b"], 120)
    end

    surface.DrawRect(healthHUD["x"], scrH - 30 - healthHUD["y"], healthHUD["size"] * (math.max(0, smoothHP) / client:GetMaxHealth()), 30)
    draw.SimpleText(health, "HUD_Health", healthHUD["size"] + healthHUD["x"] - 10, scrH - 15 - healthHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    -- Ammo/Weapon
    if weapon != NULL then ammo = weapon:Clip1() LerpAmmo() if convars["ammo_style"] == 0 then
        -- Numeric Style
        draw.SimpleText(weapon:GetPrintName(), "HUD_GunPrintName", scrW - weaponHUD["x"], scrH - 20 - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        if convars["kill_tracker"] == 1 then draw.SimpleText(client:GetNWInt("killsWith_" .. weapon:GetClass()) .. " kills", "HUD_StreakText", scrW + 2 - weaponHUD["x"], scrH - 155 - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
        if weapon:Clip1() == 0 then draw.SimpleText("0", "HUD_AmmoCount", scrW + 2 - weaponHUD["x"], scrH - 100 - weaponHUD["y"], red, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) elseif weapon:Clip1() >= 0 then draw.SimpleText(weapon:Clip1(), "HUD_AmmoCount", scrW + 2 - weaponHUD["x"], scrH - 100 - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
    elseif convars["ammo_style"] == 1 then
        -- Bar Style
        draw.SimpleText(weapon:GetPrintName(), "HUD_GunPrintName", scrW + 2 - weaponHUD["x"], scrH - 35 - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        if convars["kill_tracker"] == 1 then draw.SimpleText(client:GetNWInt("killsWith_" .. weapon:GetClass()) .. " kills", "HUD_StreakText", scrW + 2 - weaponHUD["x"], scrH - 85 - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM) end

        if (weapon:Clip1() != 0) then
            surface.SetDrawColor(weaponHUD["ammobar_r"] - 205, weaponHUD["ammobar_g"] - 205, weaponHUD["ammobar_b"] - 205, 80)
            surface.DrawRect(scrW - 400 - weaponHUD["x"], scrH - 30 - weaponHUD["y"], 400, 30)
        else
            surface.SetDrawColor(255, 0, 0, 80)
            surface.DrawRect(scrW - 400 - weaponHUD["x"], scrH - 30 - weaponHUD["y"], 400, 30)
        end

        surface.SetDrawColor(weaponHUD["ammobar_r"], weaponHUD["ammobar_g"], weaponHUD["ammobar_b"], 175)
        surface.DrawRect(scrW - 400 - weaponHUD["x"], scrH - 30 - weaponHUD["y"], 400 * (math.Clamp(math.max(0, smoothAmmo) / weapon:GetMaxClip1(), 0, 1)), 30)
        if (weapon:Clip1() >= 0) then draw.SimpleText(weapon:Clip1(), "HUD_Health", scrW - 390 - weaponHUD["x"], scrH - 15 - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) else draw.SimpleText("∞", "HUD_Health", scrW - 390 - weaponHUD["x"], scrH - 15 - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
    end
    if convars["reload_hints"] == 1 and weapon:Clip1() == 0 then draw.SimpleText("[RELOAD]", "HUD_WepNameKill", scrW / 2, scrH / 2 + 200, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end if weapon:GetPrintName() == "Grappling Hook" then draw.SimpleText("Press [" .. input.GetKeyName(convars["grapple_bind"]) .. "] to use your grappling hook.", "HUD_Health", scrW / 2, scrH / 2 + 75, Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end end

    -- Equipment
    local grappleMat = Material("icons/grapplehudicon.png", "noclamp smooth")
    local nadeMat = Material("icons/grenadehudicon.png", "noclamp smooth")
    local grappleText

    if client:HasWeapon("fres_grapple") and client:GetAmmoCount("Grenade") > 0 then
        surface.SetMaterial(grappleMat)
        if Lerp((client:GetNWFloat("linat",CurTime()) - CurTime()) * 0.2,0,500) == 0 and !IsValid(client:SetNWEntity("lina",stando)) then
            surface.SetDrawColor(255,255,255,255)
            grappleText = "[" .. input.GetKeyName(convars["grapple_bind"]) .. "]"
        else
            surface.SetDrawColor(255,200,200,100)
            grappleText = math.floor((client:GetNWFloat("linat",CurTime()) - CurTime()) + 0,5)
        end
        surface.DrawTexturedRect(equipmentHUD["x"] - 45, scrH - 40 - equipmentHUD["y"], 35, 40)
        draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"] - 27.5, scrH - 42.5 - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

        surface.SetMaterial(nadeMat)
        surface.SetDrawColor(255,255,255,255)
        surface.DrawTexturedRect(equipmentHUD["x"] + 10, scrH - 40 - equipmentHUD["y"], 35, 40)
        draw.SimpleText("[" .. input.GetKeyName(convars["nade_bind"]) .. "]", "HUD_StreakText", equipmentHUD["x"] + 27.5, scrH - 42.5 - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    elseif client:HasWeapon("fres_grapple") then
        surface.SetMaterial(grappleMat)
        if Lerp((client:GetNWFloat("linat",CurTime()) - CurTime()) * 0.2,0,500) == 0 and !IsValid(client:SetNWEntity("lina",stando)) then
            surface.SetDrawColor(255,255,255,255)
            grappleText = "[" .. input.GetKeyName(convars["grapple_bind"]) .. "]"
        else
            surface.SetDrawColor(255,200,200,100)
            grappleText = math.floor((client:GetNWFloat("linat",CurTime()) - CurTime()) + 0,5)
        end
        if equipAnchor == "left" then
            surface.DrawTexturedRect(equipmentHUD["x"] - 45, scrH - 40 - equipmentHUD["y"], 35, 40)
            draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"] - 27.5, scrH - 42.5 - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        elseif equipAnchor == "center" then
            surface.DrawTexturedRect(equipmentHUD["x"] - 17.5, scrH - 40 - equipmentHUD["y"], 35, 40)
            draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"], scrH - 42.5 - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        else
            surface.DrawTexturedRect(equipmentHUD["x"] + 10, scrH - 40 - equipmentHUD["y"], 35, 40)
            draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"] + 27.5, scrH - 42.5 - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end
    elseif client:GetAmmoCount("Grenade") > 0 then
        surface.SetMaterial(nadeMat)
        surface.SetDrawColor(255,255,255,255)
        if equipAnchor == "left" then
            surface.DrawTexturedRect(equipmentHUD["x"] - 45, scrH - 40 - equipmentHUD["y"], 35, 40)
            draw.SimpleText("[" .. input.GetKeyName(convars["nade_bind"]) .. "]", "HUD_StreakText", equipmentHUD["x"] - 27.5, scrH - 42.5 - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        elseif equipAnchor == "center" then
            surface.DrawTexturedRect(equipmentHUD["x"] - 17.5, scrH - 40 - equipmentHUD["y"], 35, 40)
            draw.SimpleText("[" .. input.GetKeyName(convars["nade_bind"]) .. "]", "HUD_StreakText", equipmentHUD["x"], scrH - 42.5 - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        else
            surface.DrawTexturedRect(equipmentHUD["x"] + 10, scrH - 40 - equipmentHUD["y"], 35, 40)
            draw.SimpleText("[" .. input.GetKeyName(convars["nade_bind"]) .. "]", "HUD_StreakText", equipmentHUD["x"] + 27.5, scrH - 42.5 - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end
    end

    -- Keypress Overlay
    if convars["keypress_overlay"] == 1 then
        KPOKeyCheck(client)
        surface.SetMaterial(keyMat)
        surface.SetDrawColor(fColor)
        surface.DrawTexturedRect(48 + kpoHUD["x"], 0 + kpoHUD["y"], 42, 42)
        surface.SetDrawColor(lColor)
        surface.DrawTexturedRect(0 + kpoHUD["x"], 48 + kpoHUD["y"], 42, 42)
        surface.SetDrawColor(bColor)
        surface.DrawTexturedRect(48 + kpoHUD["x"], 48 + kpoHUD["y"], 42, 42)
        surface.SetDrawColor(rColor)
        surface.DrawTexturedRect(96 + kpoHUD["x"], 48 + kpoHUD["y"], 42, 42)
        surface.SetMaterial(keyMatLong)
        surface.SetDrawColor(jColor)
        surface.DrawTexturedRect(0 + kpoHUD["x"], 96 + kpoHUD["y"], 138, 42)
        surface.SetMaterial(keyMatMed)
        surface.SetDrawColor(sColor)
        surface.DrawTexturedRect(0 + kpoHUD["x"], 144 + kpoHUD["y"], 66, 42)
        surface.SetDrawColor(cColor)
        surface.DrawTexturedRect(72 + kpoHUD["x"], 144 + kpoHUD["y"], 66, 42)

        draw.SimpleText("W", "HUD_StreakText", 69 + kpoHUD["x"], 21 + kpoHUD["y"], fColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("A", "HUD_StreakText", 21 + kpoHUD["x"], 69 + kpoHUD["y"], lColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("S", "HUD_StreakText", 69 + kpoHUD["x"], 69 + kpoHUD["y"], bColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("D", "HUD_StreakText", 117 + kpoHUD["x"], 69 + kpoHUD["y"], rColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("JUMP", "HUD_StreakText", 69 + kpoHUD["x"], 117 + kpoHUD["y"], jColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("RUN", "HUD_StreakText", 33 + kpoHUD["x"], 165 + kpoHUD["y"], sColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("DUCK", "HUD_StreakText", 105 + kpoHUD["x"], 165 + kpoHUD["y"], cColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Velocity Counter
    if convars["velocity_counter"] == 1 then draw.SimpleText(tostring(math.Round(LocalPlayer():GetVelocity():Length())) .. " u/s", "HUD_Health", velocityHUD["x"], velocityHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) end

    -- Disclaimer for players connecting during an active gamemode and map vote
    if GetGlobal2Bool("tm_matchended") == true then
        draw.SimpleText("Match has ended", "HUD_GunPrintName", scrW / 2, scrH / 2 - 160, Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Sit tight, another match is about to begin!", "HUD_Health", scrW / 2, scrH / 2 - 120, Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Cranked Bar
    if activeGamemode == "Cranked" and timeUntilSelfDestruct != 0 then
        surface.SetDrawColor(50, 50, 50, 80)
        surface.DrawRect(scrW / 2 - 75, 60 + matchHUD["y"], 150, 10)

        surface.SetDrawColor(objHUD["obj_contested_r"], objHUD["obj_contested_g"], objHUD["obj_contested_b"], 80)
        surface.DrawRect(scrW / 2 - 75, 60 + matchHUD["y"], 150 * (timeUntilSelfDestruct / crankedSelfDestructTime), 10)
    end
end

-- Create the HUD hook depending on the gamemode being played
function CreateHUDHook()
    if activeGamemode == "KOTH" then
        -- KOTH rendering
        local KOTHCords = KOTHPos[game.GetMap()]
        local origin = KOTHCords.Origin
        local size = KOTHCords.BrushSize
        local playerAngle
        local indiFade = 1

        hook.Add("PostDrawTranslucentRenderables", "TitanmodKOTHBoxRendering", function()
            if convars["hud_enable"] == 0 then return end
            render.SetColorMaterial()
            if LocalPlayer():GetNWBool("onOBJ") then
                render.DrawBox(origin - Vector(0, 0, -2), angle_zero, -size, size - Vector(0, 0, size[3] * 2), hillColor)
                return
            end
            render.DrawBox(origin, angle_zero, -size, size, hillColor)

            playerAngle = LocalPlayer():EyeAngles()
            playerAngle:RotateAroundAxis(playerAngle:Forward(), 90)
            playerAngle:RotateAroundAxis(playerAngle:Right(), 90)

            cam.IgnoreZ(true)
                cam.Start3D2D(origin, playerAngle, origin:Distance(LocalPlayer():GetPos()) * 0.0015 * objHUD["scale"])
                    if IsValid(weapon) and (type(weapon.GetIronSights) == "function" and weapon:GetIronSights()) then indiFade = math.Clamp(indiFade - 7 * RealFrameTime(), 0, 1) else indiFade = math.Clamp(indiFade + 4 * RealFrameTime(), 0, 1) end
                    draw.WordBox(0, 8, -25, "Hill", "HUD_StreakText", Color(0, 0, 0, 10 * indiFade), Color(convars["text_r"], convars["text_g"], convars["text_b"], 255 * indiFade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.WordBox(0, 0, 0, math.Round(origin:Distance(LocalPlayer():GetPos()) * 0.01905, 0) .. "m", "HUD_Health", Color(0, 0, 0, 10 * indiFade), Color(convars["text_r"], convars["text_g"], convars["text_b"], 255 * indiFade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                cam.End3D2D()
            cam.IgnoreZ(false)
        end )

        if IsValid(KOTHPFP) then KOTHPFP:Remove() end
        KOTHPFP = vgui.Create("AvatarImage", HUD)
        KOTHPFP:SetPos(scrW / 2 - 21, 60 + matchHUD["y"])
        KOTHPFP:SetSize(42, 42)
        KOTHPFP:Hide()

        pfpUpdated = false

        function UpdateKOTHPFP(client)
            if convars["hud_enable"] == 0 or !client:Alive() then KOTHPFP:Hide() return end
            if GetGlobal2String("tm_hillstatus") == "Empty" or GetGlobal2String("tm_hillstatus") == "Contested" then
                KOTHPFP:Hide()
                pfpUpdated = false
            else
                KOTHPFP:Show()
                if !pfpUpdated then KOTHPFP:SetPlayer(GetGlobal2Entity("tm_entonhill"), 184) end
                pfpUpdated = true
            end
        end

        hook.Add("HUDPaint", "DrawTMHUD", function()
            LocalPly = LocalPlayer()
            if GetGlobal2Bool("tm_intermission") then HUDIntermission(LocalPly) return end
            if convars["hud_enable"] == 0 then return end
            HUDAlways(LocalPly)
            UpdateKOTHPFP(LocalPly)
            if LocalPly:Alive() then HUDAlive(LocalPly) end
        end )
    elseif activeGamemode == "VIP" then
        -- VIP rendering
        if IsValid(VIPPFP) then VIPPFP:Remove() end
        VIPPFP = vgui.Create("AvatarImage", HUD)
        VIPPFP:SetPos(scrW / 2 - 21, 60 + matchHUD["y"])
        VIPPFP:SetSize(42, 42)
        VIPPFP:Hide()

        local vip = GetGlobal2Entity("tm_vip", NULL)
        local setPly
        function UpdateVIPPFP(client)
            if convars["hud_enable"] == 0 or !client:Alive() then VIPPFP:Hide() return end
            vip = GetGlobal2Entity("tm_vip", NULL)
            if vip == NULL then
                VIPPFP:Hide()
                setPly = NULL
            else
                VIPPFP:Show()
                if setPly != vip then
                    VIPPFP:SetPlayer(vip, 184)
                    setPly = vip
                end
            end
        end

        hook.Add("HUDPaint", "DrawTMHUD", function()
            LocalPly = LocalPlayer()
            if GetGlobal2Bool("tm_intermission") then HUDIntermission(LocalPly) return end
            if convars["hud_enable"] == 0 then return end
            HUDAlways(LocalPly)
            UpdateVIPPFP(LocalPly)
            if LocalPly:Alive() then HUDAlive(LocalPly) end
        end )
    else
        hook.Add("HUDPaint", "DrawTMHUD", function()
            LocalPly = LocalPlayer()
            if GetGlobal2Bool("tm_intermission") then HUDIntermission(LocalPly) return end
            if convars["hud_enable"] == 0 then return end
            HUDAlways(LocalPly)
            if LocalPly:Alive() then HUDAlive(LocalPly) end
        end )
    end
end

function DeleteHUDHook()
    hook.Remove("HUDPaint", "DrawTMHUD")
end

local notiClock = Material("icons/noti_clock.png", "noclamp smooth")
local notiLevel = Material("icons/noti_level.png", "noclamp smooth")
local notiKnife = Material("icons/noti_knife.png", "noclamp smooth")
local notiWarning = Material("icons/noti_warning.png", "noclamp smooth")
local notiSuccess = Material("icons/noti_success.png", "noclamp smooth")

net.Receive("SendNotification", function(len, ply)
    if convars["hud_enable"] == 0 or convars["notif_enable"] == 0 then return end
    local notiText = net.ReadString()
    local notiType = net.ReadString()
    surface.SetFont("HUD_Health")
    local textLength = select(1, surface.GetTextSize(notiText))

    local notiIcon
    local notiColor
    local notiSecondaryColor

    if notiType == "time" then
        surface.PlaySound("tmui/timenotif.wav")
        notiIcon = notiClock
        notiColor = Color(100, 0, 0, 155)
        notiSecondaryColor = Color(255, 0, 0, 50)
    elseif notiType == "level" then
        if convars["screen_flashes"] == 1 then LocalPly:ScreenFade(SCREENFADE.IN, Color(255, 255, 0, 25), 0.3, 0) end
        surface.PlaySound("tmui/levelup.wav")
        notiIcon = notiLevel
        notiColor = Color(100, 100, 0, 155)
        notiSecondaryColor = Color(255, 255, 0, 50)
    elseif notiType == "gungame" then
        surface.PlaySound("tmui/timenotif.wav")
        notiIcon = notiKnife
        notiColor = Color(100, 0, 100, 155)
        notiSecondaryColor = Color(255, 0, 255, 50)
    elseif notiType == "warning" then
        surface.PlaySound("tmui/warning.wav")
        notiIcon = notiWarning
        notiColor = Color(100, 0, 0, 155)
        notiSecondaryColor = Color(255, 0, 0, 50)
    elseif notiType == "success" then
        surface.PlaySound("tmui/success.wav")
        notiIcon = notiSuccess
        notiColor = Color(0, 100, 0, 155)
        notiSecondaryColor = Color(0, 255, 0, 50)
    end

    if IsValid(Notif) then Notif:Remove() end
    Notif = vgui.Create("DFrame")
    Notif:SetSize(0, 42)
    Notif:SizeTo(textLength + 64, -1, 1, 0, 0.1)
    Notif:SetY(notis["y"])
    Notif:SetTitle("")
    Notif:SetDraggable(false)
    Notif:ShowCloseButton(false)
    Notif.Paint = function(self, w, h)
        Notif:SetX(scrW - Notif:GetWide() - notis["x"])
        draw.RoundedBox(0, 0, 0, Notif:GetWide(), Notif:GetTall(), notiColor)
        draw.RoundedBox(0, 0, 0, 42, 42, notiSecondaryColor)
        surface.SetMaterial(notiIcon)
        surface.SetDrawColor(white)
        surface.DrawTexturedRect(3, 3, 36, 36)
        draw.SimpleText(notiText, "HUD_Health", 52, 20, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    Notif:Show()
    Notif:MakePopup()
    Notif:SetMouseInputEnabled(false)
    Notif:SetKeyboardInputEnabled(false)

    timer.Create("removeNotification", 6.5, 1, function()
        Notif:SizeTo(-1, 0, 0.75, 0, 0.1, function()
            Notif:Remove()
        end)
    end)
end )

-- Hides the players info that shows up when aiming at another player
function DrawTarget()
    return false
end
hook.Add("HUDDrawTargetID", "HidePlayerInfo", DrawTarget)

function DrawAmmoInfo()
    return false
end
hook.Add("HUDAmmoPickedUp", "AmmoPickedUp", DrawAmmoInfo)

function DrawWeaponInfo()
    return false
end
hook.Add("HUDWeaponPickedUp", "WeaponPickedUp", DrawWeaponInfo)

function DrawItemInfo()
    return false
end
hook.Add("HUDItemPickedUp", "ItemPickedUp", DrawItemInfo)

local chudlist = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudVoiceStatus"] = true,
    ["CHudDamageIndicator"] = true,
    ["CHUDQuickInfo"] = true,
    ["CHudCrosshair"] = true
}

-- Hides default HL2 HUD elements
hook.Add("HUDShouldDraw", "HideHL2HUD", function(name)
    if (chudlist[name]) then return false end
end )

function GM:PlayerBindPress(ply, bind, pressed)
    if convars["quick_switching"] == 0 then return end
    if string.find(bind, "slot1") and pressed then
        LocalPlayer():EmitSound("common/talk.wav", 50, 180)
        return true
    end
    if string.find(bind, "slot2") and pressed then
        LocalPlayer():EmitSound("common/talk.wav", 50, 180)
        return true
    end
    if string.find(bind, "slot3") and pressed then
        LocalPlayer():EmitSound("common/talk.wav", 50, 180)
        return true
    end
end

local micIcon = Material("icons/microphoneicon.png", "noclamp smooth")
local function VoiceIcon()
    surface.SetDrawColor(65, 155, 80, 155)
    surface.SetMaterial(micIcon)
    surface.DrawTexturedRect(scrW / 2 - 21, 150, 42, 42)
end

hook.Add("PlayerStartVoice", "ImageOnVoice", function(ply)
    if ply != LocalPly then return true end
    hook.Add("HUDPaint", "VoiceIndicator", VoiceIcon)
    return true
end)

hook.Add("PlayerEndVoice", "ImageOnVoice", function()
    hook.Remove("HUDPaint", "VoiceIndicator")
end)

-- Plays the received hitsound if a player hits another player
net.Receive("PlayHitsound", function(len, pl)
    if sounds["hit_enabled"] == 0 then return end
    local hit_reg = "hitsound/hit_" .. sounds["hit"] .. ".wav"
    local hit_reg_head = "hitsound/hit_head_" .. sounds["hit"] .. ".wav"

    local hitgroup = net.ReadUInt(4)
    local soundfile = hit_reg

    if (hitgroup == HITGROUP_HEAD) then soundfile = hit_reg_head end
    surface.PlaySound(soundfile)
end )

net.Receive("KillFeedUpdate", function(len, ply)
    if convars["killfeed_enable"] == 0 then return end
    local playersInAction = net.ReadString()
    local victimLastHitIn = net.ReadInt(5)
    local attacker = net.ReadString()
    local streak = net.ReadInt(10)

    table.insert(feedArray, {playersInAction, victimLastHitIn})
    if table.Count(feedArray) >= (convars["killfeed_limit"] + 1) then table.remove(feedArray, 1) end
    timer.Create(playersInAction .. math.Round(CurTime()), 8, 1, function()
        table.remove(feedArray, 1)
    end)

    if streak == 5 or streak == 10 or streak == 15 or streak == 20 or streak == 25 or streak == 30 then
        table.insert(feedArray, {attacker .. " is on a " .. streak .. " killstreak", 0})
        if table.Count(feedArray) >= (convars["killfeed_limit"] + 1) then table.remove(feedArray, 1) end
        timer.Create(attacker .. streak .. math.Round(CurTime()), 8, 1, function()
            table.remove(feedArray, 1)
        end)
    end
end )

-- Displays after a player kills another player
net.Receive("NotifyKill", function(len, ply)
    if convars["hud_enable"] == 0 then return end
    if gameEnded then return end
    local killedPlayer = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()
    local lastHitIn = net.ReadInt(5)
    local killStreak = net.ReadInt(10)

    local seperator = ""

    if IsValid(KillNotif) then KillNotif:Remove() end

    if IsValid(DeathNotif) then DeathNotif:Remove() end

    KillNotif = vgui.Create("DFrame")
    KillNotif:SetSize(scrW, 0)
    KillNotif:SetX(killdeathHUD["x"])
    KillNotif:SetY(scrH - killdeathHUD["y"])
    KillNotif:SetTitle("")
    KillNotif:SetDraggable(false)
    KillNotif:ShowCloseButton(false)
    KillNotif:SizeTo(scrW, 200, 0.5, 0, 0.1)

    KillIcon = vgui.Create("DImage", KillNotif)
    KillIcon:SetPos(scrW / 2 - 25, 50)
    KillIcon:SetSize(50, 0)
    KillIcon:SetImage("icons/killicon.png")
    KillIcon:SizeTo(50, 50, 0.75, 0, 0.1)

    -- Displays the Accolades that the player accomplished during the kill, this is a very bad system, and I don't plan on reworking it, gg
    if LocalPly:Health() <= 15 then
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

    if killedWith == "Tanto" or killedWith == "Mace" or killedWith == "KM-2000" then
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
        KillIcon:SetImageColor(Color(killdeathHUD["killicon_r"], killdeathHUD["killicon_g"], killdeathHUD["killicon_b"]))
    end

    local streakColor
    local orangeColor = Color(255, 200, 100)
    local redColor = Color(255, 50, 50)
    local rainbowSpeed = 160
    local rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)

    -- Dynamic text color depending on the killstreak of the player
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

        if killStreak > 1 then draw.SimpleText(killStreak .. " Kills", "HUD_StreakText", w / 2, h * 0.175, streakColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
        draw.SimpleText(killedPlayer:GetName(), "HUD_PlayerNotiName", w / 2, h * 0.625, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(seperator .. headshot .. onstreak .. clutch .. buzzkill .. marksman .. pointblank .. smackdown, "HUD_StreakText", w / 2, h * 0.8, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    KillNotif:Show()
    KillNotif:MakePopup()
    KillNotif:SetMouseInputEnabled(false)
    KillNotif:SetKeyboardInputEnabled(false)

    if sounds["kill_enabled"] == 1 then surface.PlaySound("hitsound/kill_" .. sounds["kill"] .. ".wav") end

    timer.Create("killNotification", 3.5, 1, function()
        if IsValid(KillNotif) then
            KillNotif:MoveTo(killdeathHUD["x"], scrH, 0.5, 0, 0.15)
            KillNotif:SizeTo(scrW, 0, 0.5, 0, 0.1, function()
                KillNotif:Remove()
            end)
            KillIcon:SizeTo(50, 0, 0.25, 0, 0.1, function()
                KillIcon:Remove()
            end)
        end
    end)
end )

--Displays after a player dies to another player
net.Receive("NotifyDeath", function(len, ply)
    hook.Remove("Tick", "KeyOverlayTracking")
    if timer.Exists("CounterUpdate") then timer.Remove("CounterUpdate") end
    if timer.Exists("CrankedTimeUntilDeath") then hook.Remove("Think", "CrankedTimeLeft") end
    timeUntilSelfDestruct = 0
    if convars["hud_enable"] == 0 then return end
    if gameEnded then return end

    local killedBy = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()
    local lastHitIn = net.ReadInt(5)
    local respawnTimeLeft = 4

    if IsValid(KillNotif) then KillNotif:Remove() end
    if IsValid(DeathNotif) then DeathNotif:Remove() end

    timer.Create("respawnTimeHideHud", 4, 1, function()
        DeathNotif:Remove()
        hook.Remove("Think", "ShowRespawnTime")
    end)

    hook.Add("Think", "ShowRespawnTime", function()
        if timer.Exists("respawnTimeHideHud") then respawnTimeLeft = math.Round(timer.TimeLeft("respawnTimeHideHud"), 1) end
    end)

    DeathNotif = vgui.Create("DFrame")
    DeathNotif:SetSize(scrW, 300)
    DeathNotif:SetX(killdeathHUD["x"])
    DeathNotif:SetY(scrH - killdeathHUD["y"])
    DeathNotif:SetTitle("")
    DeathNotif:SetDraggable(false)
    DeathNotif:ShowCloseButton(false)

    DeathNotif.Paint = function(self, w, h)
        if !IsValid(killedBy) then DeathNotif:Remove() return end
        if lastHitIn == 1 then
            draw.SimpleText(killedFrom .. "m" .. " HS", "HUD_WepNameKill", w / 2 + 10, 165, red, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(killedFrom .. "m", "HUD_WepNameKill", w / 2 + 10, 165, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        draw.SimpleText("Killed by", "HUD_StreakText", w / 2, 8, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", "HUD_PlayerDeathName", w / 2, 135.5, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", "HUD_PlayerDeathName", w / 2, 160, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedBy:GetName(), "HUD_PlayerDeathName", w / 2 - 10, 137.5, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedWith, "HUD_PlayerDeathName", w / 2 + 10, 137.5, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if killedBy:Health() <= 0 then
            draw.SimpleText("DEAD", "HUD_WepNameKill", w / 2 - 10, 165, red, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(killedBy:Health() .. "HP", "HUD_WepNameKill", w / 2 - 10, 165, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end

        draw.SimpleText("Respawning in " .. respawnTimeLeft .. "s", "HUD_StreakText", w / 2 - 10, 200, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Press [" .. input.GetKeyName(convars["menu_bind"]) .. "] to open menu", "HUD_WepNameKill", w / 2, 225, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    KilledByCallingCard = vgui.Create("DImage", DeathNotif)
    KilledByCallingCard:SetPos(scrW / 2 - 120, 20)
    KilledByCallingCard:SetSize(240, 80)
    if IsValid(killedBy) then KilledByCallingCard:SetImage(killedBy:GetNWString("chosenPlayercard"), "cards/color/black.png") end

    KilledByPlayerProfilePicture = vgui.Create("AvatarImage", KilledByCallingCard)
    KilledByPlayerProfilePicture:SetPos(5, 5)
    KilledByPlayerProfilePicture:SetSize(70, 70)
    KilledByPlayerProfilePicture:SetPlayer(killedBy, 184)

    if convars["screen_flashes"] == 1 then LocalPly:ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 45), 0.3, 0) end

    DeathNotif:Show()
    DeathNotif:MakePopup()
    DeathNotif:SetMouseInputEnabled(false)
    DeathNotif:SetKeyboardInputEnabled(false)
end )

-- Displays to all players when a map vote begins
net.Receive("EndOfGame", function(len, ply)
    gameEnded = true
    DeleteHUDHook()
    local dof
    local winningPlayer
    local wonMatch = false
    local votedOnMap = false
    local votedOnGamemode = false
    local mapPicked
    local gamemodePicked
    local mapDecided = false
    local gamemodeDecided = false
    local VOIPActive = false
    local MuteActive = false
    local bonusXP = 750

    if IsValid(KillNotif) then KillNotif:Remove() end
    if IsValid(DeathNotif) then DeathNotif:Remove() end
    if IsValid(EndOfGameUI) then EndOfGameUI:Remove() end
    if IsValid(KOTHPFP) then KOTHPFP:Remove() end
    if IsValid(VIPPFP) then VIPPFP:Remove() end
    hook.Remove("Think", "UpdateKOTHPFP")
    hook.Remove("Think", "UpdateVIPPFP")
    hook.Remove("PlayerStartVoice", "ImageOnVoice")
    hook.Remove("PlayerEndVoice", "ImageOnVoice")

    hook.Add("Think", "RenderEORBehindPauseMenu", function()
        if !IsValid(EndOfGameUI) then return end
        if !gui.IsGameUIVisible() then EndOfGameUI:Show() else EndOfGameUI:Hide() end
    end)

    if convars["menu_dof"] == 1 then dof = true end

    local firstMap = net.ReadString()
    local secondMap = net.ReadString()
    local firstMode = net.ReadInt(4)
    local secondMode = net.ReadInt(4)

    local firstMapName
    local firstMapThumb
    local secondMapName
    local secondMapThumb
    local decidedMapName
    local decidedMapThumb
    local firstModeName
    local secondModeName
    local decidedModeName

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

    for g, t in pairs(gamemodeArray) do
        if firstMode == t[1] then
            firstModeName = tostring(t[2])
            firstModeDesc = tostring(t[3])
        end

        if secondMode == t[1] then
            secondModeName = tostring(t[2])
            secondModeDesc = tostring(t[3])
        end
    end

    local timeUntilNextMatch = 33
    local VotingActive = false

    local connectedPlayers = player.GetHumans()
    if activeGamemode == "Gun Game" then table.sort(connectedPlayers, function(a, b) return a:GetNWInt("ladderPosition") > b:GetNWInt("ladderPosition") end) else table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end) end

    timer.Create("timeUntilNextMatch", 33, 1, function()
    end)

    timer.Create("ShowVotingMenu", 8, 1, function()
        StartVotingPhase()
    end)

    -- Determine who won the match
    for k, v in pairs(connectedPlayers) do
        if k == 1 then winningPlayer = v end
    end

    if winningPlayer == LocalPly then
        wonMatch = true
        bonusXP = 1500
    end

    local expandTime = 4

    local anchorAnim = scrH / 2 - 110
    timer.Create("ExpandDetails", expandTime, 1, function()
        anchorAnim = scrH / 2 - 220
        ExpandDetails()
    end)

    function HideHudPostGame(name)
        for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudZoom", "CHudVoiceStatus", "CHudDamageIndicator", "CHUDQuickInfo", "CHudCrosshair"}) do
            if name == v then return false end
        end
    end
    hook.Add("HUDShouldDraw", "HideDefaultHudPostGame", HideHudPostGame)

    local MatchEndMusic
    local textAnim = scrH
    local textAnimTwo = scrH
    local levelAnim = 0
    local xpCountUp = 0
    local quote = quoteArray[math.random(#quoteArray)]
    local chatArray = {}

    if wonMatch == true then
        LocalPly:ScreenFade(SCREENFADE.OUT, Color(50, 50, 0, 190), 1, 7)
        MatchEndMusic = CreateSound(LocalPly, "music/matchvictory.mp3")
        MatchEndMusic:Play()
        MatchEndMusic:ChangeVolume(convars["music_volume"] * 0.75)

        MatchWinLoseText = vgui.Create("DPanel")
        MatchWinLoseText:SetSize(800, 220)
        MatchWinLoseText:SetPos(scrW / 2 - 400, scrH)
        MatchWinLoseText:MakePopup()
        MatchWinLoseText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            textAnim = math.Clamp(textAnim - 1500 * FrameTime(), anchorAnim, scrH)
            MatchWinLoseText:SetY(textAnim)

            draw.SimpleText("VICTORY", "MatchEndText", w / 2, h / 2 - 90, white, TEXT_ALIGN_CENTER)
            draw.SimpleText(quote, "QuoteText", w / 2, h / 2 + 60, white, TEXT_ALIGN_CENTER)
        end
    else
        LocalPly:ScreenFade(SCREENFADE.OUT, Color(50, 0, 0, 190), 1, 7)
        MatchEndMusic = CreateSound(LocalPly, "music/matchdefeat.mp3")
        MatchEndMusic:Play()
        MatchEndMusic:ChangeVolume(convars["music_volume"])

        MatchWinLoseText = vgui.Create("DPanel")
        MatchWinLoseText:SetSize(800, 220)
        MatchWinLoseText:SetPos(scrW / 2 - 400, scrH)
        MatchWinLoseText:MakePopup()
        MatchWinLoseText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            textAnim = math.Clamp(textAnim - 1500 * FrameTime(), anchorAnim, scrH)
            MatchWinLoseText:SetY(textAnim)

            draw.SimpleText("DEFEAT", "MatchEndText", w / 2, h / 2 - 90, white, TEXT_ALIGN_CENTER)
            draw.SimpleText(quote, "QuoteText", w / 2, h / 2 + 60, white, TEXT_ALIGN_CENTER)
        end
    end

    function ExpandDetails()
        DetailsPanel = vgui.Create("DPanel")
        DetailsPanel:SetSize(800, 220)
        DetailsPanel:SetPos(scrW / 2 - 400, scrH)
        DetailsPanel:MakePopup()
        DetailsPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            textAnimTwo = math.Clamp(textAnimTwo - 3000 * FrameTime(), scrH / 2, scrH)
            DetailsPanel:SetY(textAnimTwo)
            if LocalPly:GetNWInt("playerLevel") != 60 then
                levelAnim = math.Clamp(levelAnim + (LocalPly:GetNWInt("playerXP") / LocalPly:GetNWInt("playerXPToNextLevel")) * FrameTime(), 0, LocalPly:GetNWInt("playerXP") / LocalPly:GetNWInt("playerXPToNextLevel"))
                xpCountUp = math.Clamp(xpCountUp + LocalPly:GetNWInt("playerXP") * FrameTime(), 0, LocalPly:GetNWInt("playerXP"))

                surface.SetDrawColor(30, 30, 30, 150)
                surface.DrawRect(w / 2 - 300, 50, 600, 15)
                surface.SetDrawColor(255, 255, 255)
                surface.DrawRect(w / 2 - 300, 50, levelAnim * 600, 15)
                draw.SimpleText(LocalPly:GetNWInt("playerLevel"), "StreakText", w / 2 - 300, 25, white, TEXT_ALIGN_LEFT)
                draw.SimpleText(LocalPly:GetNWInt("playerLevel") + 1, "StreakText", w / 2 + 300, 25, white, TEXT_ALIGN_RIGHT)
                draw.SimpleText(math.Round(xpCountUp) .. " / " .. LocalPly:GetNWInt("playerXPToNextLevel") .. "XP  ^", "StreakText", (w / 2 - 295) + (levelAnim * 600), 75, white, TEXT_ALIGN_RIGHT)
                draw.SimpleText("Earned " .. LocalPly:GetNWInt("playerScoreMatch") .. "XP + " .. bonusXP .. "XP Bonus", "StreakText", w / 2, 100, white, TEXT_ALIGN_CENTER)
            else
                levelAnim = math.Clamp(levelAnim + (1 / 1) * FrameTime(), 0, 1)

                surface.SetDrawColor(30, 30, 30, 150)
                surface.DrawRect(w / 2 - 300, 50, 600, 15)
                surface.SetDrawColor(255, 255, 255)
                surface.DrawRect(w / 2 - 300, 50, levelAnim * 600, 15)
                draw.SimpleText("MAX LEVEL", "StreakText", w / 2, 25, white, TEXT_ALIGN_CENTER)
                draw.SimpleText("Prestige at the Main Menu", "StreakText", w / 2, 65, white, TEXT_ALIGN_CENTER)
            end
        end
    end

    hook.Add("Think", "VotingTimerUpdate", function()
        if timer.Exists("timeUntilNextMatch") then timeUntilNextMatch = math.Round(timer.TimeLeft("timeUntilNextMatch")) end
    end)

    EndOfGameUI = vgui.Create("DFrame")
    EndOfGameUI:SetSize(scrW, scrH)
    EndOfGameUI:SetPos(0, 0)
    EndOfGameUI:SetTitle("")
    EndOfGameUI:SetDraggable(false)
    EndOfGameUI:ShowCloseButton(false)
    EndOfGameUI:MakePopup()
    EndOfGameUI.Paint = function(self, w, h)
        if VotingActive == false then return end
        if dof == true then DrawBokehDOF(4, 1, 0) end
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 225))
        if timeUntilNextMatch > 10 then
            draw.SimpleText("Voting ends in " .. timeUntilNextMatch - 10 .. "s", "MainMenuLoadoutWeapons", 485, scrH - 35, white, TEXT_ALIGN_LEFT)
        else
            draw.SimpleText("Match begins in " .. timeUntilNextMatch .. "s", "MainMenuLoadoutWeapons", 485, scrH - 55, white, TEXT_ALIGN_LEFT)
        end
        if VOIPActive == true then draw.DrawText("MIC ENABLED", "MainMenuLoadoutWeapons", 485, scrH - 235, Color(0, 255, 0), TEXT_ALIGN_LEFT) else draw.DrawText("MIC DISABLED", "MainMenuLoadoutWeapons", 485, scrH - 235, Color(255, 0, 0), TEXT_ALIGN_LEFT) end
        if MuteActive == false then draw.DrawText("NOT MUTED", "MainMenuLoadoutWeapons", 485, scrH - 260, Color(0, 255, 0), TEXT_ALIGN_LEFT) else draw.DrawText("MUTED", "MainMenuLoadoutWeapons", 485, scrH - 260, Color(255, 0, 0), TEXT_ALIGN_LEFT) end
        draw.SimpleText("Had fun?", "MainMenuLoadoutWeapons", 700, scrH - 55, white, TEXT_ALIGN_LEFT)

        for k, v in pairs(chatArray) do
            surface.SetDrawColor(50, 50, 50, 100)
            surface.SetFont("HUD_Health")
            local textLength = select(1, surface.GetTextSize(v[1]))

            surface.DrawRect(485, 55 + ((k - 1) * 20), textLength + 5, 20)
            draw.SimpleText(v[1], "MainMenuLoadoutWeapons", 487, 55 + ((k - 1) * 20), white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    function StartVotingPhase()
        if IsValid(MatchWinLoseText) then MatchWinLoseText:Remove() end
        if IsValid(DetailsPanel) then DetailsPanel:Remove() end
        MatchEndMusic:ChangeVolume(0.2)
        VotingActive = true
        local EndOfGamePanel = vgui.Create("DPanel", EndOfGameUI)
        EndOfGamePanel:SetSize(475, scrH)
        EndOfGamePanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
        end

        local MatchInformationPanel = vgui.Create("DPanel", EndOfGamePanel)
        MatchInformationPanel:Dock(TOP)
        MatchInformationPanel:SetSize(0, 50)
        MatchInformationPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
            draw.SimpleText("MATCH RESULTS", "GunPrintName", 237.5, -3, white, TEXT_ALIGN_CENTER)
        end

        local modeOneVotes = 0
        local modeTwoVotes = 0
        local mapOneVotes = 0
        local mapTwoVotes = 0
        local VotingPanel = vgui.Create("DPanel", EndOfGamePanel)
        VotingPanel:Dock(BOTTOM)
        VotingPanel:SetSize(0, 275)
        VotingPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
            if mapDecided == false then
                if GetGlobal2Int("VotesOnMapOne", 0) != 0 or GetGlobal2Int("VotesOnMapTwo", 0) != 0 then
                    mapOneVotes = math.Round(GetGlobal2Int("VotesOnMapOne", 0) / (GetGlobal2Int("VotesOnMapOne", 0) + GetGlobal2Int("VotesOnMapTwo", 0)) * 100)
                    mapTwoVotes = math.Round(GetGlobal2Int("VotesOnMapTwo") / (GetGlobal2Int("VotesOnMapTwo", 0) + GetGlobal2Int("VotesOnMapOne", 0)) * 100)
                end
                if mapPicked == 1 then draw.RoundedBox(0, 10, 70, 175, 175, Color(50, 125, 50, 75)) end
                if mapPicked == 2 then draw.RoundedBox(0, 290, 70, 175, 175, Color(50, 125, 50, 75)) end
                draw.SimpleText("MAP VOTE", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)

                draw.SimpleText(firstMapName, "MainMenuLoadoutWeapons", 10, 245, white, TEXT_ALIGN_LEFT)
                draw.SimpleText(secondMapName, "MainMenuLoadoutWeapons", 465, 245, white, TEXT_ALIGN_RIGHT)
                draw.SimpleText(mapOneVotes .. "% | " .. mapTwoVotes .. "%", "StreakText", w / 2, 245, white, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("NEXT MAP", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)
                draw.SimpleText(decidedMapName, "MainMenuLoadoutWeapons", w / 2, 245, white, TEXT_ALIGN_CENTER)
            end
        end

        local GamemodePanel = vgui.Create("DPanel", EndOfGamePanel)
        GamemodePanel:Dock(BOTTOM)
        GamemodePanel:SetSize(0, 100)
        GamemodePanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
            if gamemodeDecided == false then
                if GetGlobal2Int("VotesOnModeOne", 0) != 0 or GetGlobal2Int("VotesOnModeTwo", 0) != 0 then
                    modeOneVotes = math.Round(GetGlobal2Int("VotesOnModeOne", 0) / (GetGlobal2Int("VotesOnModeOne", 0) + GetGlobal2Int("VotesOnModeTwo", 0)) * 100)
                    modeTwoVotes = math.Round(GetGlobal2Int("VotesOnModeTwo") / (GetGlobal2Int("VotesOnModeTwo", 0) + GetGlobal2Int("VotesOnModeOne", 0)) * 100)
                end
                if gamemodePicked == 1 then draw.RoundedBox(0, 10, 62.5, 175, 20, Color(50, 125, 50, 75)) end
                if gamemodePicked == 2 then draw.RoundedBox(0, 290, 62.5, 175, 20, Color(50, 125, 50, 75)) end
                draw.SimpleText("GAMEMODE VOTE", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)
                draw.SimpleText(modeOneVotes .. "% | " .. modeTwoVotes .. "%", "StreakText", w / 2, 70, white, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("NEXT MODE", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)
                draw.SimpleText(decidedModeName, "MainMenuLoadoutWeapons", w / 2, 65, white, TEXT_ALIGN_CENTER)
            end
        end

        local MapChoice = vgui.Create("DImageButton", VotingPanel)
        local MapChoiceTwo = vgui.Create("DImageButton", VotingPanel)
        local ModeChoice = vgui.Create("DButton", GamemodePanel)
        local ModeChoiceTwo = vgui.Create("DButton", GamemodePanel)

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

        ModeChoice:SetPos(10, 70)
        ModeChoice:SetText(firstModeName)
        ModeChoice:SetSize(175, 30)
        ModeChoice:SetTooltip(firstModeDesc)
        ModeChoice.DoClick = function()
            net.Start("ReceiveModeVote")
            net.WriteInt(firstMode, 4)
            net.WriteUInt(1, 2)
            net.SendToServer()
            votedOnGamemode = true
            gamemodePicked = 1
            surface.PlaySound("buttons/button15.wav")

            ModeChoice:SetEnabled(false)
            ModeChoiceTwo:SetEnabled(false)
        end

        ModeChoiceTwo:SetPos(290, 70)
        ModeChoiceTwo:SetText(secondModeName)
        ModeChoiceTwo:SetSize(175, 30)
        ModeChoiceTwo:SetTooltip(secondModeDesc)
        ModeChoiceTwo.DoClick = function()
            net.Start("ReceiveModeVote")
            net.WriteInt(secondMode, 4)
            net.WriteUInt(2, 2)
            net.SendToServer()
            votedOnGamemode = true
            gamemodePicked = 2
            surface.PlaySound("buttons/button15.wav")

            ModeChoice:SetEnabled(false)
            ModeChoiceTwo:SetEnabled(false)
        end

        net.Receive("MapVoteCompleted", function(len, ply)
            local decidedMap = net.ReadString()
            local decidedMode = net.ReadInt(4)
            for u, p in pairs(mapArray) do
                if decidedMap == p[1] then
                    decidedMapName = p[2]
                    decidedMapThumb = p[3]
                end
            end

            for u, m in pairs(gamemodeArray) do
                if decidedMode == m[1] then
                    decidedModeName = m[2]
                end
            end

            mapDecided = true
            gamemodeDecided = true
            MapChoice:Remove()
            MapChoiceTwo:Remove()
            ModeChoice:Remove()
            ModeChoiceTwo:Remove()

            local DecidedMapThumb = vgui.Create("DImage", VotingPanel)
            DecidedMapThumb:SetPos(150, 70)
            DecidedMapThumb:SetText("")
            DecidedMapThumb:SetSize(175, 175)
            DecidedMapThumb:SetImage(decidedMapThumb)
        end )

        local DiscordButton = vgui.Create("DButton", EndOfGameUI)
        DiscordButton:SetPos(700, scrH - 35)
        DiscordButton:SetText("")
        DiscordButton:SetSize(255, 100)
        local textAnim = 0
        DiscordButton.Paint = function()
            if DiscordButton:IsHovered() then
                textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
            else
                textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
            end
            draw.DrawText("JOIN THE DISCORD!", "MainMenuLoadoutWeapons", textAnim, 5, Color(114, 137, 218), TEXT_ALIGN_LEFT)
        end
        DiscordButton.DoClick = function()
            surface.PlaySound("tmui/buttonclick.wav")
            gui.OpenURL("https:--discord.gg/GRfvt27uGF")
        end

        local VOIPButton = vgui.Create("DImageButton", EndOfGameUI)
        VOIPButton:SetPos(485, scrH - 205)
        VOIPButton:SetImage("icons/mutedmicrophoneicon.png")
        VOIPButton:SetSize(80, 80)
        VOIPButton:SetTooltip("Toggle Microphone")
        VOIPButton.DoClick = function()
            surface.PlaySound("tmui/buttonclick.wav")
            if permissions.IsGranted("voicerecord") == true then
                if (VOIPActive == false) then
                    VOIPActive = true
                    VOIPButton:SetImage("icons/microphoneicon.png")
                    permissions.EnableVoiceChat(true)
                else
                    VOIPActive = false
                    VOIPButton:SetImage("icons/mutedmicrophoneicon.png")
                    permissions.EnableVoiceChat(false)
                end
            else
                permissions.EnableVoiceChat(true)
            end
        end

        local MuteButton = vgui.Create("DImageButton", EndOfGameUI)
        MuteButton:SetPos(575, scrH - 205)
        MuteButton:SetImage("icons/muteicon.png")
        MuteButton:SetSize(80, 80)
        MuteButton:SetTooltip("Toggle Mute")
        MuteButton.DoClick = function()
            surface.PlaySound("tmui/buttonclick.wav")
            if (MuteActive == false) then
                MuteActive = true
                MuteButton:SetImage("icons/mutedmuteicon.png")
                net.Start("ReceivePostGameMute")
                net.WriteBool(true)
                net.SendToServer()
            else
                MuteActive = false
                MuteButton:SetImage("icons/muteicon.png")
                net.Start("ReceivePostGameMute")
                net.WriteBool(false)
                net.SendToServer()
            end
        end

        local ChatTextBox = vgui.Create("DTextEntry", EndOfGameUI)
        ChatTextBox:SetPos(485, 5)
        ChatTextBox:SetSize(200, 35)
        ChatTextBox:SetPlaceholderText("Press ENTER to send message")
        ChatTextBox.OnEnter = function(self)
            RunConsoleCommand("say", self:GetValue())
        end

        hook.Add("OnPlayerChat", "AddToChatArray", function(ply, strText, bTeam, bDead) 
            table.insert(chatArray, strText)
        end )

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
            -- Constants for basic player information, much more optimized than checking every frame
            if !IsValid(v) then return end
            local name = v:GetName()
            local prestige = v:GetNWInt("playerPrestige")
            local level = v:GetNWInt("playerLevel")
            local frags = v:Frags()
            local deaths = v:Deaths()
            local ratio
            local score = v:GetNWInt("playerScoreMatch")

            -- Used to format the K/D Ratio of a player, stops it from displaying INF when the player has gotten a kill, but has also not died yet
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
                if !IsValid(v) then return end
                if k == 1 then draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 35, 40)) else draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 40)) end

                draw.SimpleText(name .. " | " .. "P" .. prestige .. " L" .. level, "Health", 10, 0, white, TEXT_ALIGN_LEFT)
                draw.SimpleText(frags, "Health", 285, 35, Color(0, 255, 0), TEXT_ALIGN_LEFT)
                draw.SimpleText(deaths, "Health", 285, 60, Color(255, 0, 0), TEXT_ALIGN_LEFT)
                draw.SimpleText(ratioRounded .. "", "Health", 285, 85, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                draw.SimpleText(score, "Health", 427, 85, white, TEXT_ALIGN_RIGHT)
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

            local ScoreIcon = vgui.Create("DImage", PlayerPanel)
            ScoreIcon:SetPos(432, 92)
            ScoreIcon:SetSize(20, 20)
            ScoreIcon:SetImage("icons/scoreicon.png")

            local PlayerCallingCard = vgui.Create("DImage", PlayerPanel)
            PlayerCallingCard:SetPos(10, 35)
            PlayerCallingCard:SetSize(240, 80)

            if IsValid(v) then PlayerCallingCard:SetImage(v:GetNWString("chosenPlayercard"), "cards/color/black.png") end

            local PlayerProfilePicture = vgui.Create("AvatarImage", PlayerCallingCard)
            PlayerProfilePicture:SetPos(5, 5)
            PlayerProfilePicture:SetSize(70, 70)
            PlayerProfilePicture:SetPlayer(v, 184)
        end
    end

    EndOfGameUI:Show()
    gui.EnableScreenClicker(true)
end )

-- Updates the players time until self destruct on Cranked
net.Receive("NotifyCranked", function(len, ply)
    timeUntilSelfDestruct = crankedSelfDestructTime
    timer.Create("CrankedTimeUntilDeath", crankedSelfDestructTime, 1, function()
        hook.Remove("Think", "CrankedTimeLeft")
    end)

    hook.Add("Think", "CrankedTimeLeft", function()
        if timer.Exists("CrankedTimeUntilDeath") then timeUntilSelfDestruct = math.Round(timer.TimeLeft("CrankedTimeUntilDeath")) end
    end)
end )

-- Shows the players loadout on the bottom left hand side of their screen
function ShowLoadoutOnSpawn(ply)
    if !IsValid(ply) then return end
    local primaryWeapon = ""
    local secondaryWeapon = ""
    local meleeWeapon = ""
    for k, v in pairs(weaponArray) do
        if v[1] == ply:GetNWString("loadoutPrimary") and usePrimary then primaryWeapon = v[2] end
        if v[1] == ply:GetNWString("loadoutSecondary") and useSecondary then secondaryWeapon = v[2] end
        if v[1] == ply:GetNWString("loadoutMelee") and useMelee then meleeWeapon = v[2] end
    end
    notification.AddProgress("LoadoutText", "Current Loadout:\n" .. primaryWeapon .. "\n" .. secondaryWeapon .. "\n" .. meleeWeapon)
    timer.Simple(2.5, function()
        notification.Kill("LoadoutText")
    end)
end

-- ConVar callbacks related to HUD editing, much more optimized and cleaner looking than repeadetly checking the players settings
cvars.AddChangeCallback("tm_hud_health_size", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_offset_x", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_offset_y", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_text_color_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_text_color_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_text_color_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_ammo_bar_color_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_ammo_bar_color_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_ammo_bar_color_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_color_high_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_color_high_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_color_high_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_color_mid_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_color_mid_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_color_mid_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_color_low_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_color_low_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_health_color_low_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_equipment_offset_x", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_equipment_offset_y", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_killfeed_offset_x", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_killfeed_offset_y", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_killfeed_opacity", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_killdeath_offset_x", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_killdeath_offset_y", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_kill_iconcolor_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_kill_iconcolor_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_kill_iconcolor_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_x", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_y", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_inactive_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_inactive_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_inactive_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_actuated_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_actuated_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_actuated_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_x", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_y", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_scale", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_color_empty_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_color_empty_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_color_empty_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_color_occupied_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_color_occupied_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_color_occupied_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_color_contested_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_color_contested_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_obj_color_contested_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_killfeed_style", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_equipment_anchor", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hitsounds", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_killsound", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hitsoundtype", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_killsoundtype", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_enable", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_notification", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_ammo_style", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_killtracker", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_reloadhint", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("frest_bindg", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_nadebind", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_mainmenubind", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_velocitycounter", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_quickswitching", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_enablekillfeed", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_killfeed_limit", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_screenflashes", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_menudof", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_musicvolume", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_bounds_x", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_bounds_y", function(convar_name, value_old, value_new)
    UpdateHUD()
    if IsValid(KOTHPFP) then KOTHPFP:SetPos(scrW / 2 - 21, 60 + matchHUD["y"]) end
    if IsValid(VIPPFP) then VIPPFP:SetPos(scrW / 2 - 21, 60 + matchHUD["y"]) end
end)
cvars.AddChangeCallback("tm_hud_crosshair", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_style", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_gap", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_size", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_thickness", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_dot", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_outline", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_opacity", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_color_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_color_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_color_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_outline_color_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_outline_color_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_outline_color_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_show_t", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_show_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_show_l", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_show_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_crosshair_show_ads", function(convar_name, value_old, value_new)
    UpdateHUD()
end)