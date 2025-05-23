scrW, scrH = ScrW(), ScrH()
center_x, center_y = ScrW() / 2, ScrH() / 2

local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)

local gameEnded = false
local matchStartPopupSeen = false
local feedArray = {}
local chatArray = {}

local crosshair = {}
local hitmarker = {}
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
local reloadBind = "Reload Bind"

function UpdateHUD()
    -- calling GetConVar() is pretty expensive so we cache ConVars here so GetConVar() isn't ran multiple times a frame
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
        ["show_r"] = GetConVar("tm_hud_crosshair_show_r"):GetInt(),
        ["sprint"] = GetConVar("tm_hud_crosshair_sprint"):GetInt()
    }

    hitmarker = {
        ["enabled"] = GetConVar("tm_hud_hitmarker"):GetInt(),
        ["gap"] = GetConVar("tm_hud_hitmarker_gap"):GetInt(),
        ["size"] = GetConVar("tm_hud_hitmarker_size"):GetInt(),
        ["thickness"] = GetConVar("tm_hud_hitmarker_thickness"):GetInt(),
        ["opacity"] = GetConVar("tm_hud_hitmarker_opacity"):GetInt(),
        ["duration"] = GetConVar("tm_hud_hitmarker_duration"):GetInt(),
        ["hit_r"] = GetConVar("tm_hud_hitmarker_color_hit_r"):GetInt(),
        ["hit_g"] = GetConVar("tm_hud_hitmarker_color_hit_g"):GetInt(),
        ["hit_b"] = GetConVar("tm_hud_hitmarker_color_hit_b"):GetInt(),
        ["head_r"] = GetConVar("tm_hud_hitmarker_color_head_r"):GetInt(),
        ["head_g"] = GetConVar("tm_hud_hitmarker_color_head_g"):GetInt(),
        ["head_b"] = GetConVar("tm_hud_hitmarker_color_head_b"):GetInt(),
    }

    matchHUD = {
        ["y"] = TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt())
    }

    healthHUD = {
        ["size"] = TM.HUDScale(GetConVar("tm_hud_health_size"):GetInt()),
        ["x"] = TM.HUDScale(GetConVar("tm_hud_health_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()),
        ["y"] = TM.HUDScale(GetConVar("tm_hud_health_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()),
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
        ["x"] = TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()),
        ["y"] = TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt()),
        ["ammobar_r"] = GetConVar("tm_hud_ammo_bar_color_r"):GetInt(),
        ["ammobar_g"] = GetConVar("tm_hud_ammo_bar_color_g"):GetInt(),
        ["ammobar_b"] = GetConVar("tm_hud_ammo_bar_color_b"):GetInt()
    }

    equipmentHUD = {
        ["x"] = TM.HUDScale(GetConVar("tm_hud_equipment_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()),
        ["y"] = TM.HUDScale(GetConVar("tm_hud_equipment_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()),
    }

    feedHUD = {
        ["x"] = TM.HUDScale(GetConVar("tm_hud_killfeed_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()),
        ["y"] = TM.HUDScale(GetConVar("tm_hud_killfeed_offset_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()),
        ["opacity"] = GetConVar("tm_hud_killfeed_opacity"):GetInt()
    }

    killdeathHUD = {
        ["x"] = TM.HUDScale(GetConVar("tm_hud_killdeath_offset_x"):GetInt()),
        ["y"] = TM.HUDScale(GetConVar("tm_hud_killdeath_offset_y"):GetInt()),
        ["killicon_r"] = GetConVar("tm_hud_kill_iconcolor_r"):GetInt(),
        ["killicon_g"] = GetConVar("tm_hud_kill_iconcolor_g"):GetInt(),
        ["killicon_b"] = GetConVar("tm_hud_kill_iconcolor_b"):GetInt()
    }

    kpoHUD = {
        ["x"] = TM.HUDScale(GetConVar("tm_hud_keypressoverlay_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()),
        ["y"] = TM.HUDScale(GetConVar("tm_hud_keypressoverlay_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()),
        ["inactive_r"] = GetConVar("tm_hud_keypressoverlay_inactive_r"):GetInt(),
        ["inactive_g"] = GetConVar("tm_hud_keypressoverlay_inactive_g"):GetInt(),
        ["inactive_b"] = GetConVar("tm_hud_keypressoverlay_inactive_b"):GetInt(),
        ["actuated_r"] = GetConVar("tm_hud_keypressoverlay_actuated_r"):GetInt(),
        ["actuated_g"] = GetConVar("tm_hud_keypressoverlay_actuated_g"):GetInt(),
        ["actuated_b"] = GetConVar("tm_hud_keypressoverlay_actuated_b"):GetInt()
    }

    velocityHUD = {
        ["x"] = TM.HUDScale(GetConVar("tm_hud_velocitycounter_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()),
        ["y"] = TM.HUDScale(GetConVar("tm_hud_velocitycounter_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt())
    }

    objHUD = {
        ["scale"] = TM.HUDScale(GetConVar("tm_hud_obj_scale"):GetInt()),
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
        ["x"] = TM.HUDScale(GetConVar("tm_hud_bounds_x"):GetInt()),
        ["y"] = TM.HUDScale(GetConVar("tm_hud_bounds_y"):GetInt())
    }

    sounds = {
        ["hit_enabled"] = GetConVar("tm_hitsounds"):GetInt(),
        ["kill_enabled"] = GetConVar("tm_killsound"):GetInt(),
        ["hit"] = GetConVar("tm_hitsoundtype"):GetInt(),
        ["kill"] = GetConVar("tm_killsoundtype"):GetInt(),
        ["hs_kill"] = GetConVar("tm_headshotkillsoundtype"):GetInt()
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
        ["music_volume"] = GetConVar("tm_musicvolume"):GetFloat()
    }

    actuatedColor = Color(kpoHUD["actuated_r"], kpoHUD["actuated_g"], kpoHUD["actuated_b"])
    inactiveColor = Color(kpoHUD["inactive_r"], kpoHUD["inactive_g"], kpoHUD["inactive_b"])
    if GetConVar("tm_hud_killfeed_style"):GetInt() == 0 then feedEntryPadding = TM.HUDScale(-20) else feedEntryPadding = TM.HUDScale(20) end
    if GetConVar("tm_hud_equipment_anchor"):GetInt() == 0 then equipAnchor = "left" elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 1 then equipAnchor = "center" elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 2 then equipAnchor = "right" end

    if input.LookupBinding("+reload") != nil then reloadBind = input.LookupBinding("+reload") end
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

local function MatchStartPopup(ply)
    if GetGlobal2Int("tm_matchtime", 0) - CurTime() > (GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt()) then return end
    if convars["hud_enable"] == 0 then return end
    if !IsValid(ply) then return end
    if activeGamemode == nil then return end
    local gm = string.upper(activeGamemode)
    local desc
    local winCondition
    matchStartPopupSeen = true
    surface.SetFont("HUD_AmmoCountSmall")
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
    elseif gm == "OVERKILL" then
        desc = "Eliminate other players with no weapon restrictions"
        winCondition = "Get the most score to WIN"
    elseif gm == "FISTICUFFS" then
        desc = "Eliminate other players with melee weapons"
        winCondition = "Get the most score to WIN"
    end

    if IsValid(GamemodePopup) then GamemodePopup:Remove() end
    if IsValid(GamemodeDesc) then GamemodeDesc:Remove() end
    GamemodePopup = vgui.Create("DFrame")
    GamemodePopup:SetSize(popupW + TM.HUDScale(8), 0)
    GamemodePopup:SizeTo(popupW + TM.HUDScale(8), popupH - TM.HUDScale(8), 1, 0, 0.1)
    GamemodePopup:SetX(scrW / 2 - (popupW / 2))
    GamemodePopup:SetTitle("")
    GamemodePopup:SetDraggable(false)
    GamemodePopup:ShowCloseButton(false)
    GamemodePopup.Paint = function(self, w, h)
        BlurPanel(GamemodePopup, 5)
        GamemodePopup:SetY(GamemodePopup:GetTall())
        surface.SetDrawColor(255, 255, 255, 128)
        surface.DrawRect(0, 0, GamemodePopup:GetWide(), TM.HUDScale(1))
        draw.RoundedBox(0, 0, 0, GamemodePopup:GetWide(), GamemodePopup:GetTall(), Color(0, 0, 0, 75))
        draw.SimpleText(gm, "HUD_AmmoCountSmall", w / 2, TM.HUDScale(-2), white, TEXT_ALIGN_CENTER)
    end

    local textW
    timer.Create("addAdditionalPopupInfo", 1.5, 1, function()
        surface.SetFont("HUD_Health")
        local descTextW, descTextH = select(1, surface.GetTextSize(desc))
        local winTextW, winTextH = select(1, surface.GetTextSize(winCondition))
        textW = math.max(descTextW, winTextW)

        GamemodeDesc = vgui.Create("DFrame")
        GamemodeDesc:SetSize(0, descTextH + winTextH + TM.HUDScale(2))
        GamemodeDesc:SizeTo(textW + TM.HUDScale(16), descTextH + winTextH + TM.HUDScale(2), 0.75, 0, 0.1)
        GamemodeDesc:SetY(GamemodePopup:GetTall() + popupH)
        GamemodeDesc:SetTitle("")
        GamemodeDesc:SetDraggable(false)
        GamemodeDesc:ShowCloseButton(false)
        GamemodeDesc.Paint = function(self, w, h)
            BlurPanel(GamemodeDesc, 5)
            GamemodeDesc:SetX(scrW / 2 - (textW / 2))
            surface.SetDrawColor(255, 255, 255, 128)
            surface.DrawRect(0, 0, GamemodeDesc:GetWide(), TM.HUDScale(1))
            draw.RoundedBox(0, 0, 0, GamemodeDesc:GetWide(), GamemodeDesc:GetTall(), Color(0, 0, 0, 75))
            draw.SimpleText(desc, "HUD_Health", w / 2, 0, white, TEXT_ALIGN_CENTER)
            draw.SimpleText(winCondition, "HUD_Health", w / 2, descTextH, white, TEXT_ALIGN_CENTER)
        end
    end)

    timer.Create("removeGamemodePopup", 6.5, 1, function()
        GamemodePopup:SizeTo(popupW + TM.HUDScale(8), 0, 0.75, 0, 0.1, function()
            GamemodePopup:Remove()
        end)

        GamemodeDesc:SizeTo(textW + TM.HUDScale(16), 0, 0.25, 0, 0.1, function()
            GamemodeDesc:Remove()
        end)
    end)
end

net.Receive("PlayerSpawn", function(len, pl)
    RunConsoleCommand("r_cleardecals")
    if convars["hud_enable"] == 0 then return end
    if activeGamemode != "Gun Game" and activeGamemode != "Fisticuffs" then ShowLoadoutOnSpawn(LocalPly) end
    if matchStartPopupSeen == false then MatchStartPopup(LocalPly) end
end )

hook.Add("RenderScreenspaceEffects", "IntermissionPostProcess", function()
    if GetGlobal2Int("tm_matchtime", 0) - CurTime() < (GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt()) then
        hook.Remove("RenderScreenspaceEffects", "IntermissionPostProcess")
        if LocalPlayer():Alive() then MatchStartPopup(LocalPlayer()) end
    end

    local intTime = (GetGlobal2Int("tm_matchtime", 0) - CurTime()) - (GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt())
    local pp = (-intTime / GetConVar("tm_intermissiontimer"):GetInt()) + 1

    local intermissionpp = {
        ["$pp_colour_contrast"] = math.max(0.5, pp),
        ["$pp_colour_colour"] = pp,
    }

    if ply:Alive() != true then return end

    DrawColorModify(intermissionpp)
end )

function HUDIntermission(client)
    draw.SimpleText("Match begins in", "HUD_WepNameKill", scrW / 2, scrH / 2 - TM.HUDScale(110), white, TEXT_ALIGN_CENTER)
    draw.SimpleText(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()) - (GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt()), "HUD_IntermissionText", scrW / 2, scrH / 2 - TM.HUDScale(100), white, TEXT_ALIGN_CENTER)
    draw.SimpleText("Press [" .. string.upper(input.GetKeyName(convars["menu_bind"])) .. "] to open menu", "HUD_WepNameKill", scrW / 2, scrH - TM.HUDScale(200), white, TEXT_ALIGN_CENTER)
end

local function CrosshairStateUpdate(client, wep)
    local gap = 0
    local velocity = tostring(math.Round(client:GetVelocity():Length()))

    if wep != NULL and type(wep.Primary.Spread) == "number" then
        if wep:GetIronSights() and wep:GetStat("PointFiring") == true then
            return 0
        else
            gap = gap + wep:GetStat("Primary.Spread") * 300
            if ply:KeyDown(IN_ATTACK) then gap = gap + 5 end
        end
    end
    if client:OnGround() and client:Crouching() or client:GetSliding() then return math.Clamp(math.Round(gap - 5), 0, 100) end
    if !client:OnGround() then gap = gap + 7 end
    gap = gap + velocity / 55

    return math.Clamp(math.Round(gap), 0, 100)
end

function HUDAlways(client)
    -- remaining match time
    timeText = string.FormattedTime(GetGlobal2Int("tm_matchtime", 0) - CurTime() + 1, "%2i:%02i")
    draw.SimpleText(activeGamemode .. " |" .. timeText, "HUD_Health", scrW / 2, TM.HUDScale(-5) + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)

    if activeGamemode == "Gun Game" then draw.SimpleText(ggLadderSize - client:GetNWInt("ladderPosition") .. " kills left", "HUD_Health", scrW / 2, TM.HUDScale(25) + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER) elseif activeGamemode == "Fiesta" and (GetGlobal2Int("FiestaTime", 0) - CurTime()) > 0 then draw.SimpleText(string.FormattedTime(math.Round(GetGlobal2Int("FiestaTime", 0) - CurTime() + 0.5), "%2i:%02i"), "HUD_Health", scrW / 2, TM.HUDScale(25) + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER) elseif activeGamemode == "Cranked" and timeUntilSelfDestruct != 0 then draw.SimpleText(timeUntilSelfDestruct, "HUD_Health", scrW / 2, TM.HUDScale(25) + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER) elseif activeGamemode == "KOTH" then
        if GetGlobal2String("tm_hillstatus") == "Occupied" then
            draw.SimpleText(GetGlobal2Entity("tm_entonhill"):GetName(), "HUD_Health", scrW / 2, TM.HUDScale(25) + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(GetGlobal2String("tm_hillstatus"), "HUD_Health", scrW / 2, TM.HUDScale(25) + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
        end
    elseif activeGamemode == "VIP" then
        if GetGlobal2Entity("tm_vip") != NULL then
            draw.SimpleText(GetGlobal2Entity("tm_vip"):GetName(), "HUD_Health", scrW / 2, TM.HUDScale(25) + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
            if GetGlobal2Entity("tm_vip") != client then draw.SimpleText(math.Round(client:GetPos():Distance(GetGlobal2Entity("tm_vip"):GetPos()) * 0.01905) .. "m", "HUD_Health", scrW / 2, TM.HUDScale(105) + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER) end
        else
            draw.SimpleText("No VIP", "HUD_Health", scrW / 2, TM.HUDScale(25) + matchHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
        end
    end

    -- kill feed
    surface.SetFont("HUD_StreakText")
    for k, v in pairs(feedArray) do
        if v[2] == 1 and v[2] != nil then surface.SetDrawColor(150, 50, 50, feedHUD["opacity"]) else surface.SetDrawColor(50, 50, 50, feedHUD["opacity"]) end
        local nameLength = select(1, surface.GetTextSize(v[1]))

        surface.DrawRect(feedHUD["x"], scrH - TM.HUDScale(20) + ((k - 1) * feedEntryPadding) - feedHUD["y"], nameLength + TM.HUDScale(5), TM.HUDScale(20))
        draw.SimpleText(v[1], "HUD_StreakText", TM.HUDScale(2.5) + feedHUD["x"], scrH - TM.HUDScale(22) + ((k - 1) * feedEntryPadding) - feedHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT)
    end

    -- objective indicator
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
        surface.DrawTexturedRect(scrW / 2 - TM.HUDScale(21), TM.HUDScale(60) + matchHUD["y"], TM.HUDScale(42), TM.HUDScale(42))
    end

    -- VIP status icons
    if activeGamemode == "VIP" then
        surface.SetDrawColor(objHUD["obj_occupied_r"], objHUD["obj_occupied_g"], objHUD["obj_occupied_b"], 225)
        surface.SetMaterial(hillEmptyMat)
        surface.DrawTexturedRect(scrW / 2 - TM.HUDScale(24), TM.HUDScale(57) + matchHUD["y"], TM.HUDScale(48), TM.HUDScale(48))
    end
end

local health
local weapon
local ammo
local adsFade = 1
local dyn = 0
local hitmarkerFade = 0
local hitColor = "hit"

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

    if (type(weapon.GetIronSights) == "function" and weapon:GetIronSights() and weapon:GetStat("PointFiring") == false) or (type(weapon.GetCustomizing) == "function" and weapon:GetCustomizing()) or (client:IsSprinting() and client:OnGround() and crosshair["sprint"] == 0) then adsFade = math.Clamp(adsFade - 7 * RealFrameTime(), 0, 1) else adsFade = math.Clamp(adsFade + 4 * RealFrameTime(), 0, 1) end
    -- crosshair
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

    -- hitmarkers
    if hitmarker["enabled"] == 1 then
        hitmarkerFade = math.Clamp(hitmarkerFade - 7 * RealFrameTime(), 0, hitmarker["duration"])
        surface.SetDrawColor(hitmarker[hitColor .. "_r"], hitmarker[hitColor .. "_g"], hitmarker[hitColor .. "_b"], hitmarker["opacity"] * math.min(1, hitmarkerFade))
        draw.NoTexture()
        surface.DrawTexturedRectRotated(center_x - hitmarker["gap"], center_y - hitmarker["gap"], hitmarker["thickness"] * math.min(1, hitmarkerFade), hitmarker["size"], 45)
        surface.DrawTexturedRectRotated(center_x + hitmarker["gap"], center_y- hitmarker["gap"], hitmarker["thickness"] * math.min(1, hitmarkerFade), hitmarker["size"], 135)
        surface.DrawTexturedRectRotated(center_x + hitmarker["gap"], center_y + hitmarker["gap"], hitmarker["thickness"] * math.min(1, hitmarkerFade), hitmarker["size"], 225)
        surface.DrawTexturedRectRotated(center_x - hitmarker["gap"], center_y + hitmarker["gap"], hitmarker["thickness"] * math.min(1, hitmarkerFade), hitmarker["size"], 315)
    end

    -- health
    LerpHealth()
    surface.SetDrawColor(50, 50, 50, 80)
    surface.DrawRect(healthHUD["x"], scrH - TM.HUDScale(30) - healthHUD["y"], healthHUD["size"], TM.HUDScale(30))

    if health <= (playerHealth / 1.5) then
        if health <= (playerHealth / 3) then
            surface.SetDrawColor(healthHUD["barlow_r"], healthHUD["barlow_g"], healthHUD["barlow_b"], 120)
        else
            surface.SetDrawColor(healthHUD["barmid_r"], healthHUD["barmid_g"], healthHUD["barmid_b"], 120)
        end
    else
        surface.SetDrawColor(healthHUD["barhigh_r"], healthHUD["barhigh_g"], healthHUD["barhigh_b"], 120)
    end

    surface.DrawRect(healthHUD["x"], scrH - TM.HUDScale(30) - healthHUD["y"], healthHUD["size"] * (math.max(0, smoothHP) / client:GetMaxHealth()), TM.HUDScale(30))
    draw.SimpleText(health, "HUD_Health", healthHUD["size"] + healthHUD["x"] - TM.HUDScale(10), scrH - TM.HUDScale(30) - healthHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT)

    -- ammo/weapon
    if weapon == NULL then return end
    if convars["ammo_style"] == 0 then
        -- numeric style
        draw.SimpleText(weapon:GetPrintName(), "HUD_GunPrintName", scrW - weaponHUD["x"], scrH - TM.HUDScale(50) - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT)
        if convars["kill_tracker"] == 1 then draw.SimpleText(client:GetNWInt("killsWith_" .. weapon:GetClass()) .. " kills", "HUD_StreakText", scrW - TM.MenuScale(5) - weaponHUD["x"], scrH - TM.HUDScale(170) - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT) end

        local ammoColor
        local ammoText
        if (weapon:Clip1() >= 0) then
            if (weapon:Clip1() == 0) then
                ammoColor = red
                ammoText = 0
            end
            ammoColor = Color(convars["text_r"], convars["text_g"], convars["text_b"])
            ammoText = weapon:Clip1()
        elseif weapon:GetPrintName() == "M134 Minigun" or weapon:GetPrintName() == "Fists" or weapon:GetPrintName() == "Riot Shield" or activeGamemode == "Gun Game" or activeGamemode == "Fisticuffs" then
            ammoColor = Color(convars["text_r"], convars["text_g"], convars["text_b"])
            ammoText = "∞"
        else
            ammoColor = Color(convars["text_r"], convars["text_g"], convars["text_b"])
            ammoText = "[" .. string.upper(reloadBind) .. "] THROW"
        end

        draw.SimpleText(ammoText, "HUD_AmmoCount", scrW - weaponHUD["x"], scrH - TM.HUDScale(165) - weaponHUD["y"], ammoColor, TEXT_ALIGN_RIGHT)
    elseif convars["ammo_style"] == 1 then
        -- bar style
        draw.SimpleText(weapon:GetPrintName(), "HUD_GunPrintName", scrW - weaponHUD["x"], scrH - TM.HUDScale(90) - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT)
        if convars["kill_tracker"] == 1 then draw.SimpleText(client:GetNWInt("killsWith_" .. weapon:GetClass()) .. " kills", "HUD_StreakText", scrW - weaponHUD["x"], scrH - TM.HUDScale(105) - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT) end

        if (weapon:Clip1() != 0) then
            surface.SetDrawColor(weaponHUD["ammobar_r"] - 205, weaponHUD["ammobar_g"] - 205, weaponHUD["ammobar_b"] - 205, 80)
            surface.DrawRect(scrW - TM.HUDScale(400) - weaponHUD["x"], scrH - TM.HUDScale(30) - weaponHUD["y"], TM.HUDScale(400), TM.HUDScale(30))
        else
            surface.SetDrawColor(255, 0, 0, 80)
            surface.DrawRect(scrW - TM.HUDScale(400) - weaponHUD["x"], scrH - TM.HUDScale(30) - weaponHUD["y"], TM.HUDScale(400), TM.HUDScale(30))
        end

        surface.SetDrawColor(weaponHUD["ammobar_r"], weaponHUD["ammobar_g"], weaponHUD["ammobar_b"], 175)
        if (weapon:Clip1() >= 0) then
            ammo = weapon:Clip1()
            LerpAmmo()
            surface.DrawRect(scrW - TM.HUDScale(400) - weaponHUD["x"], scrH - TM.HUDScale(30) - weaponHUD["y"], TM.HUDScale(400) * (math.Clamp(math.max(0, smoothAmmo) / weapon:GetMaxClip1(), 0, 1)), TM.HUDScale(30))
            draw.SimpleText(weapon:Clip1(), "HUD_Health", scrW - TM.HUDScale(390) - weaponHUD["x"], scrH - TM.HUDScale(30) - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT)
        elseif weapon:GetPrintName() == "M134 Minigun" or weapon:GetPrintName() == "Fists" or weapon:GetPrintName() == "Riot Shield" or activeGamemode == "Gun Game" or activeGamemode == "Fisticuffs" then
            surface.DrawRect(scrW - TM.HUDScale(400) - weaponHUD["x"], scrH - TM.HUDScale(30) - weaponHUD["y"], TM.HUDScale(400), TM.HUDScale(30))
            draw.SimpleText("∞", "HUD_Health", scrW - TM.HUDScale(390) - weaponHUD["x"], scrH - TM.HUDScale(32) - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT)
        else
            surface.DrawRect(scrW - TM.HUDScale(400) - weaponHUD["x"], scrH - TM.HUDScale(30) - weaponHUD["y"], TM.HUDScale(400), TM.HUDScale(30))
            draw.SimpleText("[" .. string.upper(reloadBind) .. "] THROW", "HUD_Health", scrW - TM.HUDScale(390) - weaponHUD["x"], scrH - TM.HUDScale(32) - weaponHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT)
        end
    end

    if convars["reload_hints"] == 1 and weapon:Clip1() == 0 then draw.SimpleText("[RELOAD]", "HUD_WepNameKill", scrW / 2, scrH / 2 + TM.HUDScale(185), red, TEXT_ALIGN_CENTER) end

    -- equipment
    local grappleMat = Material("icons/grapplehudicon.png", "noclamp smooth")
    local nadeMat = Material("icons/grenadehudicon.png", "noclamp smooth")
    local grappleText

    if client:GetAmmoCount("Grenade") > 0 then
        surface.SetMaterial(grappleMat)
        if Lerp((client:GetNWFloat("linat", CurTime()) - CurTime()) * 0.2, 0, 500) == 0 and !IsValid(client:SetNWEntity("lina",stando)) then
            surface.SetDrawColor(255,255,255,255)
            grappleText = string.upper(input.GetKeyName(convars["grapple_bind"]))
        else
            surface.SetDrawColor(255,200,200,100)
            grappleText = math.floor(client:GetNWFloat("linat", CurTime()) - CurTime() + 1)
        end
        surface.DrawTexturedRect(equipmentHUD["x"] - TM.HUDScale(45), scrH - TM.HUDScale(40) - equipmentHUD["y"], TM.HUDScale(35), TM.HUDScale(40))
        draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"] - TM.HUDScale(27.5), scrH - TM.HUDScale(65) - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)

        surface.SetMaterial(nadeMat)
        surface.SetDrawColor(255,255,255,255)
        surface.DrawTexturedRect(equipmentHUD["x"] + TM.HUDScale(10), scrH - TM.HUDScale(40) - equipmentHUD["y"], TM.HUDScale(35), TM.HUDScale(40))
        draw.SimpleText(string.upper(input.GetKeyName(convars["nade_bind"])), "HUD_StreakText", equipmentHUD["x"] + TM.HUDScale(27.5), scrH - TM.HUDScale(65) - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
    else
        surface.SetMaterial(grappleMat)
        if Lerp((client:GetNWFloat("linat",CurTime()) - CurTime()) * 0.2,0,500) == 0 and !IsValid(client:SetNWEntity("lina",stando)) then
            surface.SetDrawColor(255,255,255,255)
            grappleText = string.upper(input.GetKeyName(convars["grapple_bind"]))
        else
            surface.SetDrawColor(255,200,200,100)
            grappleText = math.floor(client:GetNWFloat("linat",CurTime()) - CurTime() + 1)
        end
        if equipAnchor == "left" then
            surface.DrawTexturedRect(equipmentHUD["x"] - TM.HUDScale(45), scrH - TM.HUDScale(40) - equipmentHUD["y"], TM.HUDScale(35), TM.HUDScale(40))
            draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"] - TM.HUDScale(27.5), scrH - TM.HUDScale(65) - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
        elseif equipAnchor == "center" then
            surface.DrawTexturedRect(equipmentHUD["x"] - TM.HUDScale(17.5), scrH - TM.HUDScale(40) - equipmentHUD["y"], TM.HUDScale(35), TM.HUDScale(40))
            draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"], scrH - TM.HUDScale(65) - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
        else
            surface.DrawTexturedRect(equipmentHUD["x"] + TM.HUDScale(10), scrH - TM.HUDScale(40) - equipmentHUD["y"], TM.HUDScale(35), TM.HUDScale(40))
            draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"] + TM.HUDScale(27.5), scrH - TM.HUDScale(65) - equipmentHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
        end
    end

    -- keypress overlay
    if convars["keypress_overlay"] == 1 then
        KPOKeyCheck(client)
        surface.SetMaterial(keyMat)
        surface.SetDrawColor(fColor)
        surface.DrawTexturedRect(TM.HUDScale(48) + kpoHUD["x"], 0 + kpoHUD["y"], TM.HUDScale(42), TM.HUDScale(42))
        surface.SetDrawColor(lColor)
        surface.DrawTexturedRect(0 + kpoHUD["x"], TM.HUDScale(48) + kpoHUD["y"], TM.HUDScale(42), TM.HUDScale(42))
        surface.SetDrawColor(bColor)
        surface.DrawTexturedRect(TM.HUDScale(48) + kpoHUD["x"], TM.HUDScale(48) + kpoHUD["y"], TM.HUDScale(42), TM.HUDScale(42))
        surface.SetDrawColor(rColor)
        surface.DrawTexturedRect(TM.HUDScale(96) + kpoHUD["x"], TM.HUDScale(48) + kpoHUD["y"], TM.HUDScale(42), TM.HUDScale(42))
        surface.SetMaterial(keyMatLong)
        surface.SetDrawColor(jColor)
        surface.DrawTexturedRect(0 + kpoHUD["x"], TM.HUDScale(96) + kpoHUD["y"], TM.HUDScale(138), TM.HUDScale(42))
        surface.SetMaterial(keyMatMed)
        surface.SetDrawColor(sColor)
        surface.DrawTexturedRect(0 + kpoHUD["x"], TM.HUDScale(144) + kpoHUD["y"], TM.HUDScale(66), TM.HUDScale(42))
        surface.SetDrawColor(cColor)
        surface.DrawTexturedRect(TM.HUDScale(72) + kpoHUD["x"], TM.HUDScale(144) + kpoHUD["y"], TM.HUDScale(66), TM.HUDScale(42))

        draw.SimpleText("W", "HUD_StreakText", TM.HUDScale(69) + kpoHUD["x"], TM.HUDScale(10) + kpoHUD["y"], fColor, TEXT_ALIGN_CENTER)
        draw.SimpleText("A", "HUD_StreakText", TM.HUDScale(21) + kpoHUD["x"], TM.HUDScale(58) + kpoHUD["y"], lColor, TEXT_ALIGN_CENTER)
        draw.SimpleText("S", "HUD_StreakText", TM.HUDScale(69) + kpoHUD["x"], TM.HUDScale(58) + kpoHUD["y"], bColor, TEXT_ALIGN_CENTER)
        draw.SimpleText("D", "HUD_StreakText", TM.HUDScale(117) + kpoHUD["x"], TM.HUDScale(58) + kpoHUD["y"], rColor, TEXT_ALIGN_CENTER)
        draw.SimpleText("JUMP", "HUD_StreakText", TM.HUDScale(69) + kpoHUD["x"], TM.HUDScale(106) + kpoHUD["y"], jColor, TEXT_ALIGN_CENTER)
        draw.SimpleText("RUN", "HUD_StreakText", TM.HUDScale(33) + kpoHUD["x"], TM.HUDScale(154) + kpoHUD["y"], sColor, TEXT_ALIGN_CENTER)
        draw.SimpleText("DUCK", "HUD_StreakText", TM.HUDScale(105) + kpoHUD["x"], TM.HUDScale(154) + kpoHUD["y"], cColor, TEXT_ALIGN_CENTER)
    end

    -- velocity counter
    if convars["velocity_counter"] == 1 then draw.SimpleText(tostring(math.Round(LocalPlayer():GetVelocity():Length())) .. " u/s", "HUD_Health", velocityHUD["x"], velocityHUD["y"], Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) end

    -- disclaimer for players connecting during an active gamemode and map vote
    if GetGlobal2Bool("tm_matchended") == true then
        draw.SimpleText("Match has ended", "HUD_GunPrintName", scrW / 2, scrH / 2 - TM.HUDScale(104), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
        draw.SimpleText("Sit tight, another match is about to begin!", "HUD_Health", scrW / 2, scrH / 2 - TM.HUDScale(18), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER)
    end

    -- cranked Bar
    if activeGamemode == "Cranked" and timeUntilSelfDestruct != 0 then
        surface.SetDrawColor(50, 50, 50, 80)
        surface.DrawRect(scrW / 2 - TM.HUDScale(75), TM.HUDScale(60) + matchHUD["y"], TM.HUDScale(150), TM.HUDScale(10))

        surface.SetDrawColor(objHUD["obj_contested_r"], objHUD["obj_contested_g"], objHUD["obj_contested_b"], 80)
        surface.DrawRect(scrW / 2 - TM.HUDScale(75), TM.HUDScale(60) + matchHUD["y"], TM.HUDScale(150) * (timeUntilSelfDestruct / crankedSelfDestructTime), TM.HUDScale(10))
    end
end

-- create the HUD hook depending on the gamemode being played
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
                    draw.WordBox(0, TM.HUDScale(8), TM.HUDScale(-14), "Hill", "HUD_StreakText", Color(0, 0, 0, 10 * indiFade), Color(convars["text_r"], convars["text_g"], convars["text_b"], 255 * indiFade), TEXT_ALIGN_CENTER)
                    draw.WordBox(0, 0, TM.HUDScale(11), math.Round(origin:Distance(LocalPlayer():GetPos()) * 0.01905, 0) .. "m", "HUD_Health", Color(0, 0, 0, 10 * indiFade), Color(convars["text_r"], convars["text_g"], convars["text_b"], 255 * indiFade), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            cam.IgnoreZ(false)
        end )

        if IsValid(KOTHPFP) then KOTHPFP:Remove() end
        KOTHPFP = vgui.Create("AvatarImage", HUD)
        KOTHPFP:SetPos(scrW / 2 - TM.HUDScale(21), TM.HUDScale(60) + matchHUD["y"])
        KOTHPFP:SetSize(TM.HUDScale(42), TM.HUDScale(42))
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
        VIPPFP:SetPos(scrW / 2 - TM.HUDScale(21), TM.HUDScale(60) + matchHUD["y"])
        VIPPFP:SetSize(TM.HUDScale(42), TM.HUDScale(42))
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
    LocalPly = LocalPlayer()
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
        notiColor = Color(100, 0, 0, 125)
        notiSecondaryColor = Color(255, 0, 0, 50)
    elseif notiType == "level" then
        if convars["screen_flashes"] == 1 then LocalPly:ScreenFade(SCREENFADE.IN, Color(255, 255, 0, 25), 0.3, 0) end
        surface.PlaySound("tmui/levelup.wav")
        notiIcon = notiLevel
        notiColor = Color(100, 100, 0, 125)
        notiSecondaryColor = Color(255, 255, 0, 50)
    elseif notiType == "gungame" then
        surface.PlaySound("tmui/timenotif.wav")
        notiIcon = notiKnife
        notiColor = Color(100, 0, 100, 125)
        notiSecondaryColor = Color(255, 0, 255, 50)
    elseif notiType == "warning" then
        surface.PlaySound("tmui/warning.wav")
        notiIcon = notiWarning
        notiColor = Color(100, 0, 0, 125)
        notiSecondaryColor = Color(255, 0, 0, 50)
    elseif notiType == "success" then
        surface.PlaySound("tmui/success.wav")
        notiIcon = notiSuccess
        notiColor = Color(0, 100, 0, 125)
        notiSecondaryColor = Color(0, 255, 0, 50)
    end

    if IsValid(Notif) then Notif:Remove() end
    Notif = vgui.Create("DFrame")
    Notif:SetSize(0, TM.HUDScale(42))
    Notif:SizeTo(textLength + TM.HUDScale(64), TM.HUDScale(42), 1, 0, 0.1)
    Notif:SetY(notis["y"])
    Notif:SetTitle("")
    Notif:SetDraggable(false)
    Notif:ShowCloseButton(false)
    Notif.Paint = function(self, w, h)
        BlurPanel(Notif, 3)
        Notif:SetX(scrW - Notif:GetWide() - notis["x"])
        surface.SetDrawColor(Color(255, 255, 255, 155))
        surface.DrawRect(0, 0, w, TM.HUDScale(1))
        surface.DrawRect(0, h - TM.HUDScale(1), w, TM.HUDScale(1))
        surface.DrawRect(0, 0, TM.HUDScale(1), h)
        surface.DrawRect(w - TM.HUDScale(1), 0, TM.HUDScale(1), h)
        draw.RoundedBox(0, 0, 0, Notif:GetWide(), Notif:GetTall(), notiColor)
        draw.RoundedBox(0, 0, 0, TM.HUDScale(42), TM.HUDScale(42), notiSecondaryColor)
        surface.SetMaterial(notiIcon)
        surface.SetDrawColor(white)
        surface.DrawTexturedRect(TM.HUDScale(3), TM.HUDScale(3), TM.HUDScale(36), TM.HUDScale(36))
        draw.SimpleText(notiText, "HUD_Health", TM.HUDScale(52), TM.HUDScale(5), white, TEXT_ALIGN_LEFT)
    end

    Notif:Show()
    Notif:MakePopup()
    Notif:SetMouseInputEnabled(false)
    Notif:SetKeyboardInputEnabled(false)

    timer.Create("removeNotification", 6.5, 1, function()
        Notif:SizeTo(textLength + TM.HUDScale(64), 0, 0.75, 0, 0.1, function()
            Notif:Remove()
        end)
    end)
end )

function DrawTarget() return false end
hook.Add("HUDDrawTargetID", "HidePlayerInfo", DrawTarget)

function DrawAmmoInfo() return false end
hook.Add("HUDAmmoPickedUp", "AmmoPickedUp", DrawAmmoInfo)

function DrawWeaponInfo() return false end
hook.Add("HUDWeaponPickedUp", "WeaponPickedUp", DrawWeaponInfo)

function DrawItemInfo() return false end
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

-- hides default HL2 HUD elements
hook.Add("HUDShouldDraw", "HideHL2HUD", function(name) if (chudlist[name]) then return false end end )

function GM:PlayerBindPress(ply, bind, pressed)
    if convars["quick_switching"] == 0 then return end
    if string.find(bind, "slot1") and pressed then return true end
    if string.find(bind, "slot2") and pressed then return true end
    if string.find(bind, "slot3") and pressed then return true end
end

local micIcon = Material("icons/microphoneicon.png", "noclamp smooth")
local function VoiceIcon()
    surface.SetDrawColor(65, 155, 80, 115)
    surface.SetMaterial(micIcon)
    surface.DrawTexturedRect(scrW / 2 - TM.HUDScale(21), TM.HUDScale(115) + matchHUD["y"], TM.HUDScale(42), TM.HUDScale(42))
end

hook.Add("PlayerStartVoice", "ImageOnVoice", function(ply)
    if ply != LocalPly then return true end
    hook.Add("HUDPaint", "VoiceIndicator", VoiceIcon)
    return true
end)

hook.Add("PlayerEndVoice", "ImageOnVoice", function()
    hook.Remove("HUDPaint", "VoiceIndicator")
end)

-- plays the received hitsound if a player hits another player
net.Receive("SendHitmarker", function(len, pl)
    if sounds["hit_enabled"] == 0 then return end
    local hit_reg = "hitsound/hit_" .. sounds["hit"] .. ".wav"
    local hit_reg_head = "hitsound/hit_head_" .. sounds["hit"] .. ".wav"

    local hitgroup = net.ReadUInt(4)
    hitmarkerFade = hitmarker["duration"]
    hitColor = "hit"
    local soundfile = hit_reg

    if (hitgroup == HITGROUP_HEAD) then
        hitColor = "head"
        soundfile = hit_reg_head
    end
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

-- displays after a player kills another player
local multiArray = {}
net.Receive("NotifyKill", function(len, ply)
    if convars["hud_enable"] == 0 then return end
    if gameEnded then return end
    local killedPlayer = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()
    local lastHitIn = net.ReadInt(5)
    local killStreak = net.ReadInt(10)

    local accoladeList = ""

    if IsValid(KillNotif) then KillNotif:Remove() end
    if IsValid(DeathNotif) then DeathNotif:Remove() end

    KillNotif = vgui.Create("DFrame")
    KillNotif:SetSize(scrW, 0)
    KillNotif:SetX(killdeathHUD["x"])
    KillNotif:SetY(scrH - killdeathHUD["y"])
    KillNotif:SetTitle("")
    KillNotif:SetDraggable(false)
    KillNotif:ShowCloseButton(false)
    KillNotif:SizeTo(scrW, TM.HUDScale(200), 0.5, 0, 0.1)

    local SkullHolder = vgui.Create("DFrame", KillNotif)
    SkullHolder:SetTitle("")
    SkullHolder:SetDraggable(false)
    SkullHolder:ShowCloseButton(false)
    SkullHolder:Center()

    SkullHolder.Paint = function(self, w, h) end

    -- displays the Accolades that the player accomplished during the kill, this is a very bad system, and I don't plan on reworking it, gg
    if lastHitIn == 1 then
        accoladeList = accoladeList .. "Headshot +20 | "
        table.insert(multiArray, "1")
    else
        table.insert(multiArray, "0")
    end

    for k, v in pairs(multiArray) do
        SkullHolder:SetSize(k * TM.HUDScale(55), TM.HUDScale(50))
        SkullHolder:Center()
        SkullHolder:SetY(TM.HUDScale(55))
        KillIcon = vgui.Create("DImage", SkullHolder)
        KillIcon:SetPos((k - 1) * TM.HUDScale(55) + TM.HUDScale(2.5), 0)
        KillIcon:SetSize(TM.HUDScale(50), 0)
        KillIcon:SetImage("icons/killicon.png")
        KillIcon:SizeTo(TM.HUDScale(50), TM.HUDScale(50), 0.75, 0, 0.1)

        if v == "1" then KillIcon:SetImageColor(red) else KillIcon:SetImageColor(Color(killdeathHUD["killicon_r"], killdeathHUD["killicon_g"], killdeathHUD["killicon_b"])) end
    end

    if LocalPly:Health() <= 15 then
        accoladeList = accoladeList .. "Clutch +20 | "
    end

    if killedFrom >= 40 then
        accoladeList = accoladeList .. "Longshot +" .. killedFrom .. " | "
    end

    if killedFrom <= 3 then
        accoladeList = accoladeList .. "Point Blank +20 | "
    end

    if killedWith == "Tanto" or killedWith == "Mace" or killedWith == "KM-2000" or killedWith == "Bowie Knife" or killedWith == "Butterfly Knife" or killedWith == "Carver" or killedWith == "Dagger" or killedWith == "Fire Axe" or killedWith == "Fists" or killedWith == "Karambit" or killedWith == "Kukri" or killedWith == "M9 Bayonet" or killedWith == "Nunchucks" or killedWith == "Red Rebel" or killedWith == "Tri-Dagger" or killedWith == "Thrown Knife" then
        accoladeList = accoladeList .. "Smackdown +20 | "
    end

    if killStreak >= 3 then
        onstreakScore = 10 * killStreak
        accoladeList = accoladeList .. "On Streak +" .. onstreakScore .. " | "
    end

    if killedPlayer:GetNWInt("killStreak") >= 3 then
        buzzkillScore = 10 * killedPlayer:GetNWInt("killStreak")
        accoladeList = accoladeList ..  "Buzz Kill +" .. buzzkillScore .. " | "
    end

    local streakColor
    local orangeColor = Color(255, 200, 100)
    local redColor = Color(255, 50, 50)
    local rainbowSpeed = 160
    local rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)

    -- dynamic text color depending on the killstreak of the player
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

        if killStreak > 1 then draw.SimpleText(killStreak .. " Kills", "HUD_StreakText", w / 2, TM.HUDScale(25), streakColor, TEXT_ALIGN_CENTER) end
        draw.SimpleText(killedPlayer:GetName(), "HUD_PlayerNotiName", w / 2, TM.HUDScale(100), white, TEXT_ALIGN_CENTER)
        draw.SimpleText(string.sub(accoladeList, 1, -4), "HUD_StreakText", w / 2, TM.HUDScale(160), white, TEXT_ALIGN_CENTER)
    end

    KillNotif:Show()
    KillNotif:MakePopup()
    KillNotif:SetMouseInputEnabled(false)
    KillNotif:SetKeyboardInputEnabled(false)

    if sounds["kill_enabled"] == 1 then
        if lastHitIn == 1 then surface.PlaySound("hitsound/kill_" .. sounds["hs_kill"] .. ".wav") else surface.PlaySound("hitsound/kill_" .. sounds["kill"] .. ".wav") end
    end

    timer.Create("killNotification", 3.5, 1, function()
        if IsValid(KillNotif) then
            KillNotif:MoveTo(killdeathHUD["x"], scrH, 0.5, 0, 0.15)
            KillNotif:SizeTo(scrW, 0, 0.5, 0, 0.1, function()
                KillNotif:Remove()
                table.Empty(multiArray)
            end)
            KillIcon:SizeTo(TM.HUDScale(50), 0, 0.25, 0, 0.1, function()
                KillIcon:Remove()
            end)
        end
    end)
end )

-- displays after a player dies to another player
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

    table.Empty(multiArray)

    

    timer.Create("respawnTimeHideHud", 4, 1, function()
        DeathNotif:Remove()
        hook.Remove("Think", "ShowRespawnTime")
    end)

    hook.Add("Think", "ShowRespawnTime", function() if timer.Exists("respawnTimeHideHud") then respawnTimeLeft = math.Round(timer.TimeLeft("respawnTimeHideHud"), 1) end end)

    DeathNotif = vgui.Create("DFrame")
    DeathNotif:SetSize(scrW, TM.HUDScale(300))
    DeathNotif:SetX(killdeathHUD["x"])
    DeathNotif:SetY(scrH - killdeathHUD["y"])
    DeathNotif:SetTitle("")
    DeathNotif:SetDraggable(false)
    DeathNotif:ShowCloseButton(false)
    DeathNotif:SetAlpha(0)

    DeathNotif:AlphaTo(255, 0.05, 0)

    DeathNotif.Paint = function(self, w, h)
        if !IsValid(killedBy) then DeathNotif:Remove() return end

        if lastHitIn == 1 then
            draw.SimpleText(killedFrom .. "m" .. " HS", "HUD_WepNameKill", w / 2 + TM.HUDScale(10), TM.HUDScale(151), red, TEXT_ALIGN_LEFT)
        else
            draw.SimpleText(killedFrom .. "m", "HUD_WepNameKill", w / 2 + TM.HUDScale(10), TM.HUDScale(151), white, TEXT_ALIGN_LEFT)
        end

        draw.SimpleText("Killed by", "HUD_StreakText", w / 2, TM.HUDScale(-3), white, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", "HUD_PlayerDeathName", w / 2, TM.HUDScale(117.5), white, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", "HUD_PlayerDeathName", w / 2, TM.HUDScale(142), white, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedBy:GetName(), "HUD_PlayerDeathName", w / 2 - TM.HUDScale(10), TM.HUDScale(117.5), white, TEXT_ALIGN_RIGHT)
        draw.SimpleText(killedWith, "HUD_PlayerDeathName", w / 2 + TM.HUDScale(10), TM.HUDScale(117.5), white, TEXT_ALIGN_LEFT)

        if killedBy:Health() <= 0 then
            draw.SimpleText("DEAD", "HUD_WepNameKill", w / 2 - TM.HUDScale(10), TM.HUDScale(151), red, TEXT_ALIGN_RIGHT)
        else
            draw.SimpleText(killedBy:Health() .. "HP", "HUD_WepNameKill", w / 2 - TM.HUDScale(10), TM.HUDScale(151), white, TEXT_ALIGN_RIGHT)
        end

        draw.SimpleText("Respawning in " .. respawnTimeLeft .. "s", "HUD_StreakText", w / 2 - TM.HUDScale(10), TM.HUDScale(192), white, TEXT_ALIGN_CENTER)
        draw.SimpleText("Press [" .. string.upper(input.GetKeyName(convars["menu_bind"])) .. "] to open menu", "HUD_WepNameKill", w / 2, TM.HUDScale(211), white, TEXT_ALIGN_CENTER)
    end

    KilledByCallingCard = vgui.Create("DImage", DeathNotif)
    KilledByCallingCard:SetPos(scrW / 2 - TM.HUDScale(120), TM.HUDScale(20))
    KilledByCallingCard:SetSize(TM.HUDScale(240), TM.HUDScale(80))
    if IsValid(killedBy) then KilledByCallingCard:SetImage(killedBy:GetNWString("chosenPlayercard"), "cards/color/black.png") end

    KilledByPlayerProfilePicture = vgui.Create("AvatarImage", KilledByCallingCard)
    KilledByPlayerProfilePicture:SetPos(TM.HUDScale(5), TM.HUDScale(5))
    KilledByPlayerProfilePicture:SetSize(TM.HUDScale(70), TM.HUDScale(70))
    KilledByPlayerProfilePicture:SetPlayer(killedBy, 184)

    if convars["screen_flashes"] == 1 then LocalPly:ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 45), 0.3, 0) end

    DeathNotif:Show()
    DeathNotif:MakePopup()
    DeathNotif:SetMouseInputEnabled(false)
    DeathNotif:SetKeyboardInputEnabled(false)
end )

-- displays to all players when a map vote begins
net.Receive("EndOfGame", function(len, ply)
    LocalPly = LocalPlayer()
    gameEnded = true
    DeleteHUDHook()
    local winningPlayer
    local wonMatch = false
    local mapPicked = 0
    local mapPickedName = ""
    local gamemodePicked
    local mapDecided = false
    local gamemodeDecided = false
    local decidedMap
    local decidedMode
    local VOIPActive = false
    local MuteActive = false
    local bonusXP = 750

    net.Receive("MapVoteSkipped", function(len, ply)
        decidedMap = net.ReadString()
        decidedMode = net.ReadInt(5)
    end)

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

    local firstMap = net.ReadString()
    local secondMap = net.ReadString()
    local thirdMap = net.ReadString()
    local firstMode = net.ReadInt(5)
    local secondMode = net.ReadInt(5)

    local firstMapName
    local firstMapThumb
    local secondMapName
    local secondMapThumb
    local thirdMapName
    local thirdMapThumb
    local decidedMapName
    local decidedMapThumb
    local firstModeName
    local secondModeName
    local decidedModeName

    for m, t in ipairs(mapArray) do
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

        if thirdMap == t[1] then
            thirdMapName = t[2]
            thirdMapThumb = t[3]
        end
    end

    for g, t in ipairs(gamemodeArray) do
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

    local gradientL = Material("overlay/gradient_c.png", "noclamp smooth")
    local gradientR = Material("overlay/gradient_c2.png", "noclamp smooth")

    local gradLColor
    local gradRColor
    if math.random(0, 1) == 0 then
        gradLColor = Color(100, 0, 255, 6)
        gradRColor = Color(100, 255, 255, 12)
    else
        gradLColor = Color(100, 255, 255, 6)
        gradRColor = Color(100, 0, 255, 12)
    end

    timer.Create("timeUntilNextMatch", 32, 1, function()
        hook.Add("Think", "RenderBehindPauseMenu", function()
            if !IsValid(LoadingPrompt) then return end
            if !gui.IsGameUIVisible() then LoadingPrompt:Show() else LoadingPrompt:Hide() end
        end)

        LoadingPrompt = vgui.Create("DFrame")
        LoadingPrompt:SetSize(scrW, scrH)
        LoadingPrompt:Center()
        LoadingPrompt:SetTitle("")
        LoadingPrompt:SetDraggable(false)
        LoadingPrompt:ShowCloseButton(false)
        LoadingPrompt:SetDeleteOnClose(false)
        LoadingPrompt:MakePopup()

        LoadingPrompt.Paint = function(self, w, h)
            BlurPanel(LoadingPrompt, 10)
            surface.SetDrawColor(35, 35, 35, 165)
            surface.DrawRect(0, 0, LoadingPrompt:GetWide(), LoadingPrompt:GetTall())

            surface.SetMaterial(gradientL)
            surface.SetDrawColor(gradLColor)
            surface.DrawTexturedRect(0, 0, scrW, scrH)

            surface.SetMaterial(gradientR)
            surface.SetDrawColor(gradRColor)
            surface.DrawTexturedRect(0, 0, scrW, scrH)

            draw.SimpleText("LOADING NEXT MATCH", "QuoteText", w / 2, h / 2, white, TEXT_ALIGN_CENTER)
        end
    end)

    timer.Create("ShowVotingMenu", 8, 1, function() StartVotingPhase() end)

    -- determine who won the match
    for k, v in pairs(connectedPlayers) do
        if k == 1 then winningPlayer = v end
    end

    if winningPlayer == LocalPly then
        wonMatch = true
        bonusXP = 1500
    end

    local expandTime = 4

    local anchorAnim = scrH / 2 - TM.MenuScale(110)
    timer.Create("ExpandDetails", expandTime, 1, function()
        anchorAnim = scrH / 2 - TM.MenuScale(220)
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

    if wonMatch == true then
        LocalPly:ScreenFade(SCREENFADE.OUT, Color(50, 50, 0, 190), 1, 7)
        MatchEndMusic = CreateSound(LocalPly, "music/matchvictory_" .. math.random(1, 3) .. ".mp3")
        MatchEndMusic:Play()
        MatchEndMusic:ChangeVolume(convars["music_volume"] * 0.75)

        MatchWinLoseText = vgui.Create("DPanel")
        MatchWinLoseText:SetSize(TM.MenuScale(800), TM.MenuScale(220))
        MatchWinLoseText:SetPos(scrW / 2 - TM.MenuScale(400), scrH)
        MatchWinLoseText:MakePopup()
        MatchWinLoseText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            textAnim = math.Clamp(textAnim - TM.MenuScale(1500) * FrameTime(), anchorAnim, scrH)
            MatchWinLoseText:SetY(textAnim)

            draw.SimpleText("VICTORY", "MatchEndText", w / 2, h / 2 - TM.MenuScale(90), white, TEXT_ALIGN_CENTER)
            draw.SimpleText(quote, "QuoteText", w / 2, h / 2 + TM.MenuScale(60), white, TEXT_ALIGN_CENTER)
        end
    else
        LocalPly:ScreenFade(SCREENFADE.OUT, Color(50, 0, 0, 190), 1, 7)
        MatchEndMusic = CreateSound(LocalPly, "music/matchdefeat_" .. math.random(1, 3) .. ".mp3")
        MatchEndMusic:Play()
        MatchEndMusic:ChangeVolume(convars["music_volume"])

        MatchWinLoseText = vgui.Create("DPanel")
        MatchWinLoseText:SetSize(TM.MenuScale(800), TM.MenuScale(220))
        MatchWinLoseText:SetPos(scrW / 2 - TM.MenuScale(400), scrH)
        MatchWinLoseText:MakePopup()
        MatchWinLoseText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            textAnim = math.Clamp(textAnim - TM.MenuScale(1500) * FrameTime(), anchorAnim, scrH)
            MatchWinLoseText:SetY(textAnim)

            draw.SimpleText("DEFEAT", "MatchEndText", w / 2, h / 2 - TM.MenuScale(90), white, TEXT_ALIGN_CENTER)
            draw.SimpleText(quote, "QuoteText", w / 2, h / 2 + TM.MenuScale(60), white, TEXT_ALIGN_CENTER)
        end
    end

    function ExpandDetails()
        DetailsPanel = vgui.Create("DPanel")
        DetailsPanel:SetSize(TM.MenuScale(800), TM.MenuScale(220))
        DetailsPanel:SetPos(scrW / 2 - TM.MenuScale(400), scrH)
        DetailsPanel:MakePopup()
        DetailsPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            textAnimTwo = math.Clamp(textAnimTwo - TM.MenuScale(3000) * FrameTime(), scrH / 2, scrH)
            DetailsPanel:SetY(textAnimTwo)
            if LocalPly:GetNWInt("playerLevel") != 60 then
                levelAnim = math.Clamp(levelAnim + (LocalPly:GetNWInt("playerXP") / LocalPly:GetNWInt("playerXPToNextLevel")) * FrameTime(), 0, LocalPly:GetNWInt("playerXP") / LocalPly:GetNWInt("playerXPToNextLevel"))
                xpCountUp = math.Clamp(xpCountUp + LocalPly:GetNWInt("playerXP") * FrameTime(), 0, LocalPly:GetNWInt("playerXP"))

                surface.SetDrawColor(30, 30, 30, 150)
                surface.DrawRect(w / 2 - TM.MenuScale(300), TM.MenuScale(50), TM.MenuScale(600), TM.MenuScale(15))
                surface.SetDrawColor(255, 255, 255)
                surface.DrawRect(w / 2 - TM.MenuScale(300), TM.MenuScale(50), levelAnim * TM.MenuScale(600), TM.MenuScale(15))
                draw.SimpleText(LocalPly:GetNWInt("playerLevel"), "StreakText", w / 2 - TM.MenuScale(300), TM.MenuScale(25), white, TEXT_ALIGN_LEFT)
                draw.SimpleText(LocalPly:GetNWInt("playerLevel") + 1, "StreakText", w / 2 + TM.MenuScale(300), TM.MenuScale(25), white, TEXT_ALIGN_RIGHT)
                draw.SimpleText(math.Round(xpCountUp) .. " / " .. LocalPly:GetNWInt("playerXPToNextLevel") .. "XP  ^", "StreakText", (w / 2 - TM.MenuScale(295)) + (levelAnim * TM.MenuScale(600)), TM.MenuScale(75), white, TEXT_ALIGN_RIGHT)
                draw.SimpleText("Earned " .. LocalPly:GetNWInt("playerScoreMatch") .. "XP + " .. bonusXP .. "XP Bonus", "StreakText", w / 2, TM.MenuScale(100), white, TEXT_ALIGN_CENTER)
            else
                levelAnim = math.Clamp(levelAnim + (1 / 1) * FrameTime(), 0, 1)

                surface.SetDrawColor(30, 30, 30, 150)
                surface.DrawRect(w / 2 - TM.MenuScale(300), TM.MenuScale(50), TM.MenuScale(600), TM.MenuScale(15))
                surface.SetDrawColor(255, 255, 255)
                surface.DrawRect(w / 2 - TM.MenuScale(300), TM.MenuScale(50), levelAnim * TM.MenuScale(600), TM.MenuScale(15))
                draw.SimpleText("MAX LEVEL", "StreakText", w / 2, TM.MenuScale(25), white, TEXT_ALIGN_CENTER)
                draw.SimpleText("Prestige at the Main Menu", "StreakText", w / 2, TM.MenuScale(65), white, TEXT_ALIGN_CENTER)
            end
        end
    end

    hook.Add("Think", "VotingTimerUpdate", function() if timer.Exists("timeUntilNextMatch") then timeUntilNextMatch = math.Round(timer.TimeLeft("timeUntilNextMatch")) end end)

    EndOfGameUI = vgui.Create("DFrame")
    EndOfGameUI:SetSize(scrW, scrH)
    EndOfGameUI:SetPos(0, 0)
    EndOfGameUI:SetTitle("")
    EndOfGameUI:SetDraggable(false)
    EndOfGameUI:ShowCloseButton(false)
    EndOfGameUI:MakePopup()
    EndOfGameUI.Paint = function(self, w, h)
        if VotingActive == false then return end
        BlurPanel(EndOfGameUI, 10)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 225))
        if timeUntilNextMatch > 10 then
            draw.SimpleText("Voting ends in " .. timeUntilNextMatch - 10 .. "s", "MainMenuLoadoutWeapons", TM.MenuScale(485), scrH - TM.MenuScale(55), white, TEXT_ALIGN_LEFT)
            draw.SimpleText("Match begins in " .. timeUntilNextMatch .. "s", "MainMenuLoadoutWeapons", TM.MenuScale(485), scrH - TM.MenuScale(30), white, TEXT_ALIGN_LEFT)
        else
            draw.SimpleText("Match begins in " .. timeUntilNextMatch .. "s", "MainMenuLoadoutWeapons", TM.MenuScale(485), scrH - TM.MenuScale(30), white, TEXT_ALIGN_LEFT)
        end
        if VOIPActive == true then draw.DrawText("MIC ENABLED", "MainMenuLoadoutWeapons", TM.MenuScale(485), scrH - TM.MenuScale(235), Color(0, 255, 0), TEXT_ALIGN_LEFT) else draw.DrawText("MIC DISABLED", "MainMenuLoadoutWeapons", TM.MenuScale(485), scrH - TM.MenuScale(235), Color(255, 0, 0), TEXT_ALIGN_LEFT) end
        if MuteActive == false then draw.DrawText("NOT MUTED", "MainMenuLoadoutWeapons", TM.MenuScale(485), scrH - TM.MenuScale(260), Color(0, 255, 0), TEXT_ALIGN_LEFT) else draw.DrawText("MUTED", "MainMenuLoadoutWeapons", TM.MenuScale(485), scrH - TM.MenuScale(260), Color(255, 0, 0), TEXT_ALIGN_LEFT) end
        draw.SimpleText("Had fun?", "MainMenuLoadoutWeapons", TM.MenuScale(700), scrH - TM.MenuScale(55), white, TEXT_ALIGN_LEFT)

        surface.SetFont("MainMenuLoadoutWeapons")
        for k, v in pairs(chatArray) do
            surface.SetDrawColor(25, 25, 25, 100)
            local textLength = select(1, surface.GetTextSize(v))

            surface.DrawRect(TM.MenuScale(485), TM.MenuScale(50) + ((k - 1) * TM.MenuScale(35)), textLength + TM.MenuScale(5), TM.MenuScale(30))
            draw.SimpleText(v, "MainMenuLoadoutWeapons", TM.MenuScale(487), TM.MenuScale(64) + ((k - 1) * TM.MenuScale(35)), white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    function StartVotingPhase()
        if IsValid(MatchWinLoseText) then MatchWinLoseText:Remove() end
        if IsValid(DetailsPanel) then DetailsPanel:Remove() end
        LocalPly:SetDSP(0)
        if IsValid(rue_underwater) then rue_underwater:Stop() end
        MatchEndMusic:ChangeVolume(0.2)
        VotingActive = true
        local EndOfGamePanel = vgui.Create("DPanel", EndOfGameUI)
        EndOfGamePanel:SetSize(TM.MenuScale(475), scrH)
        EndOfGamePanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
        end

        local MatchInformationPanel = vgui.Create("DPanel", EndOfGamePanel)
        MatchInformationPanel:Dock(TOP)
        MatchInformationPanel:SetSize(0, TM.MenuScale(50))
        MatchInformationPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
            draw.SimpleText("MATCH RESULTS", "GunPrintName", TM.MenuScale(237.5), TM.MenuScale(-3), white, TEXT_ALIGN_CENTER)
        end

        local modeOneVotes = 0
        local modeTwoVotes = 0
        local mapOneVotes = 0
        local mapTwoVotes = 0
        local mapThreeVotes = 0
        local VotingPanel = vgui.Create("DPanel", EndOfGamePanel)
        VotingPanel:Dock(BOTTOM)
        VotingPanel:SetSize(0, TM.MenuScale(290))
        VotingPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
            if mapDecided == false then
                if GetGlobal2Int("VotesOnMapOne", 0) != 0 or GetGlobal2Int("VotesOnMapTwo", 0) != 0 or GetGlobal2Int("VotesOnMapThree", 0) != 0 then
                    mapOneVotes = math.Round(GetGlobal2Int("VotesOnMapOne", 0) / (GetGlobal2Int("VotesOnMapOne", 0) + GetGlobal2Int("VotesOnMapTwo", 0) + GetGlobal2Int("VotesOnMapThree", 0)) * 100)
                    mapTwoVotes = math.Round(GetGlobal2Int("VotesOnMapTwo") / (GetGlobal2Int("VotesOnMapTwo", 0) + GetGlobal2Int("VotesOnMapOne", 0) + GetGlobal2Int("VotesOnMapThree", 0)) * 100)
                    mapThreeVotes = math.Round(GetGlobal2Int("VotesOnMapThree") / (GetGlobal2Int("VotesOnMapThree", 0) + GetGlobal2Int("VotesOnMapOne", 0) + GetGlobal2Int("VotesOnMapTwo", 0)) * 100)
                end
                if mapPicked == 1 then draw.RoundedBox(0, TM.MenuScale(10), TM.MenuScale(80), TM.MenuScale(145), TM.MenuScale(5), Color(50, 125, 50, 75)) end
                if mapPicked == 2 then draw.RoundedBox(0, TM.MenuScale(165), TM.MenuScale(80), TM.MenuScale(145), TM.MenuScale(5), Color(50, 125, 50, 75)) end
                if mapPicked == 3 then draw.RoundedBox(0, TM.MenuScale(320), TM.MenuScale(80), TM.MenuScale(145), TM.MenuScale(5), Color(50, 125, 50, 75)) end
                draw.SimpleText("MAP VOTE", "GunPrintName", w / 2, TM.MenuScale(5), white, TEXT_ALIGN_CENTER)

                draw.SimpleText(firstMapName, "MainMenuLoadoutWeapons", TM.MenuScale(10), TM.MenuScale(260), white, TEXT_ALIGN_LEFT)
                draw.SimpleText(secondMapName, "MainMenuLoadoutWeapons", w / 2, TM.MenuScale(260), white, TEXT_ALIGN_CENTER)
                draw.SimpleText(thirdMapName, "MainMenuLoadoutWeapons", TM.MenuScale(465), TM.MenuScale(260), white, TEXT_ALIGN_RIGHT)
                draw.SimpleText(mapOneVotes .. "% | " .. mapTwoVotes .. "% | " .. mapThreeVotes .. "%", "StreakText", w / 2, TM.MenuScale(55), white, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("NEXT MAP", "GunPrintName", w / 2, TM.MenuScale(5), white, TEXT_ALIGN_CENTER)
                draw.SimpleText(decidedMapName, "MainMenuLoadoutWeapons", w / 2, TM.MenuScale(255), white, TEXT_ALIGN_CENTER)
            end
        end

        local GamemodePanel = vgui.Create("DPanel", EndOfGamePanel)
        GamemodePanel:Dock(BOTTOM)
        GamemodePanel:SetSize(0, TM.MenuScale(100))
        GamemodePanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
            if gamemodeDecided == false then
                if GetGlobal2Int("VotesOnModeOne", 0) != 0 or GetGlobal2Int("VotesOnModeTwo", 0) != 0 then
                    modeOneVotes = math.Round(GetGlobal2Int("VotesOnModeOne", 0) / (GetGlobal2Int("VotesOnModeOne", 0) + GetGlobal2Int("VotesOnModeTwo", 0)) * 100)
                    modeTwoVotes = math.Round(GetGlobal2Int("VotesOnModeTwo") / (GetGlobal2Int("VotesOnModeTwo", 0) + GetGlobal2Int("VotesOnModeOne", 0)) * 100)
                end
                if gamemodePicked == 1 then draw.RoundedBox(0, TM.MenuScale(10), TM.MenuScale(62.5), TM.MenuScale(175), TM.MenuScale(9), Color(50, 125, 50, 75)) end
                if gamemodePicked == 2 then draw.RoundedBox(0, TM.MenuScale(290), TM.MenuScale(62.5), TM.MenuScale(175), TM.MenuScale(9), Color(50, 125, 50, 75)) end
                draw.SimpleText("GAMEMODE VOTE", "GunPrintName", w / 2, TM.MenuScale(5), white, TEXT_ALIGN_CENTER)
                draw.SimpleText(modeOneVotes .. "% | " .. modeTwoVotes .. "%", "StreakText", w / 2, TM.MenuScale(72), white, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("NEXT MODE", "GunPrintName", w / 2, TM.MenuScale(5), white, TEXT_ALIGN_CENTER)
                draw.SimpleText(decidedModeName, "MainMenuLoadoutWeapons", w / 2, TM.MenuScale(65), white, TEXT_ALIGN_CENTER)
            end
        end

        local MapChoice = vgui.Create("DImageButton", VotingPanel)
        local MapChoiceTwo = vgui.Create("DImageButton", VotingPanel)
        local MapChoiceThree = vgui.Create("DImageButton", VotingPanel)
        local ModeChoice = vgui.Create("DButton", GamemodePanel)
        local ModeChoiceTwo = vgui.Create("DButton", GamemodePanel)

        MapChoice:SetPos(TM.MenuScale(10), TM.MenuScale(85))
        MapChoice:SetText("")
        MapChoice:SetSize(TM.MenuScale(145), TM.MenuScale(175))
        MapChoice:SetImage(firstMapThumb)
        MapChoice:SetDepressImage(false)
        MapChoice.DoClick = function()
            net.Start("ReceiveMapVote")
            net.WriteString(firstMap)
            net.WriteString(mapPickedName)
            net.WriteUInt(1, 3)
            net.WriteUInt(mapPicked, 3)
            net.SendToServer()
            mapPicked = 1
            mapPickedName = firstMap
            surface.PlaySound("buttons/button15.wav")

            MapChoice:SetEnabled(false)
            MapChoiceTwo:SetEnabled(true)
            MapChoiceThree:SetEnabled(true)
        end

        MapChoiceTwo:SetPos(TM.MenuScale(165), TM.MenuScale(85))
        MapChoiceTwo:SetText("")
        MapChoiceTwo:SetSize(TM.MenuScale(145), TM.MenuScale(175))
        MapChoiceTwo:SetImage(secondMapThumb)
        MapChoiceTwo:SetDepressImage(false)
        MapChoiceTwo.DoClick = function()
            net.Start("ReceiveMapVote")
            net.WriteString(secondMap)
            net.WriteString(mapPickedName)
            net.WriteUInt(2, 3)
            net.WriteUInt(mapPicked, 3)
            net.SendToServer()
            mapPicked = 2
            mapPickedName = secondMap
            surface.PlaySound("buttons/button15.wav")

            MapChoice:SetEnabled(true)
            MapChoiceTwo:SetEnabled(false)
            MapChoiceThree:SetEnabled(true)
        end

        MapChoiceThree:SetPos(TM.MenuScale(320), TM.MenuScale(85))
        MapChoiceThree:SetText("")
        MapChoiceThree:SetSize(TM.MenuScale(145), TM.MenuScale(175))
        MapChoiceThree:SetImage(thirdMapThumb)
        MapChoiceThree:SetDepressImage(false)
        MapChoiceThree.DoClick = function()
            net.Start("ReceiveMapVote")
            net.WriteString(thirdMap)
            net.WriteString(mapPickedName)
            net.WriteUInt(3, 3)
            net.WriteUInt(mapPicked, 3)
            net.SendToServer()
            mapPicked = 3
            mapPickedName = thirdMap
            surface.PlaySound("buttons/button15.wav")

            MapChoice:SetEnabled(true)
            MapChoiceTwo:SetEnabled(true)
            MapChoiceThree:SetEnabled(false)
        end

        ModeChoice:SetPos(TM.MenuScale(10), TM.MenuScale(70))
        ModeChoice:SetText(firstModeName)
        ModeChoice:SetSize(TM.MenuScale(175), TM.MenuScale(30))
        ModeChoice:SetTooltip(firstModeDesc)
        ModeChoice.DoClick = function()
            net.Start("ReceiveModeVote")
            net.WriteInt(firstMode, 5)
            net.WriteInt(secondMode, 5)
            net.WriteUInt(1, 2)
            net.SendToServer()
            gamemodePicked = 1
            surface.PlaySound("buttons/button15.wav")

            ModeChoice:SetEnabled(false)
            ModeChoiceTwo:SetEnabled(true)
        end

        ModeChoiceTwo:SetPos(TM.MenuScale(290), TM.MenuScale(70))
        ModeChoiceTwo:SetText(secondModeName)
        ModeChoiceTwo:SetSize(TM.MenuScale(175), TM.MenuScale(30))
        ModeChoiceTwo:SetTooltip(secondModeDesc)
        ModeChoiceTwo.DoClick = function()
            net.Start("ReceiveModeVote")
            net.WriteInt(secondMode, 5)
            net.WriteInt(firstMode, 5)
            net.WriteUInt(2, 2)
            net.SendToServer()
            gamemodePicked = 2
            surface.PlaySound("buttons/button15.wav")

            ModeChoice:SetEnabled(true)
            ModeChoiceTwo:SetEnabled(false)
        end

        function MapVoteCompleted()
            for u, p in ipairs(mapArray) do
                if decidedMap == p[1] then
                    decidedMapName = p[2]
                    decidedMapThumb = p[3]
                end
            end

            for u, m in ipairs(gamemodeArray) do
                if decidedMode == m[1] then
                    decidedModeName = m[2]
                end
            end

            mapDecided = true
            gamemodeDecided = true
            MapChoice:Remove()
            MapChoiceTwo:Remove()
            MapChoiceThree:Remove()
            ModeChoice:Remove()
            ModeChoiceTwo:Remove()

            local DecidedMapThumb = vgui.Create("DImage", VotingPanel)
            DecidedMapThumb:SetPos(TM.MenuScale(150), TM.MenuScale(70))
            DecidedMapThumb:SetSize(TM.MenuScale(175), TM.MenuScale(175))
            DecidedMapThumb:SetImage(decidedMapThumb)
        end

        if matchVoting == false then MapVoteCompleted() end

        net.Receive("MapVoteCompleted", function(len, ply)
            decidedMap = net.ReadString()
            decidedMode = net.ReadInt(5)
            MapVoteCompleted()
        end )

        local DiscordButton = vgui.Create("DButton", EndOfGameUI)
        DiscordButton:SetPos(TM.MenuScale(700), scrH - TM.MenuScale(35))
        DiscordButton:SetText("")
        DiscordButton:SetSize(TM.MenuScale(255), TM.MenuScale(100))
        local textAnim = 0
        DiscordButton.Paint = function()
            if DiscordButton:IsHovered() then
                textAnim = math.Clamp(textAnim + TM.MenuScale(200) * FrameTime(), 0, TM.MenuScale(20))
            else
                textAnim = math.Clamp(textAnim - TM.MenuScale(200) * FrameTime(), 0, TM.MenuScale(20))
            end
            draw.DrawText("JOIN THE DISCORD!", "MainMenuLoadoutWeapons", textAnim, TM.MenuScale(5), Color(114, 137, 218), TEXT_ALIGN_LEFT)
        end
        DiscordButton.DoClick = function()
            surface.PlaySound("tmui/buttonclick.wav")
            gui.OpenURL("https://discord.gg/GRfvt27uGF")
        end

        local VOIPButton = vgui.Create("DImageButton", EndOfGameUI)
        VOIPButton:SetPos(TM.MenuScale(485), scrH - TM.MenuScale(205))
        VOIPButton:SetImage("icons/mutedmicrophoneicon.png")
        VOIPButton:SetSize(TM.MenuScale(80), TM.MenuScale(80))
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
        MuteButton:SetPos(TM.MenuScale(575), scrH - TM.MenuScale(205))
        MuteButton:SetImage("icons/muteicon.png")
        MuteButton:SetSize(TM.MenuScale(80), TM.MenuScale(80))
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
        ChatTextBox:SetPos(TM.MenuScale(485), TM.MenuScale(5))
        ChatTextBox:SetSize(TM.MenuScale(200), TM.MenuScale(35))
        ChatTextBox:SetPlaceholderText("Press ENTER to send message")
        ChatTextBox.OnEnter = function(self)
            if self:GetValue() == "" then return end
            RunConsoleCommand("say", self:GetValue())
        end

        local PlayerScrollPanel = vgui.Create("DScrollPanel", EndOfGamePanel)
        PlayerScrollPanel:Dock(FILL)
        PlayerScrollPanel:SetSize(EndOfGamePanel:GetWide(), 0)
        PlayerScrollPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        local sbar = PlayerScrollPanel:GetVBar()
        sbar:SetHideButtons(true)
        function sbar:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
        end
        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(0, TM.MenuScale(5), TM.MenuScale(8), TM.MenuScale(5), h - TM.MenuScale(16), Color(255, 255, 255, 175))
        end

        PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
        PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())

        for k, v in pairs(connectedPlayers) do
            -- constants for basic player information, much more optimized than checking every frame
            if !IsValid(v) then return end
            local name = v:GetName()
            local prestige = v:GetNWInt("playerPrestige")
            local level = v:GetNWInt("playerLevel")
            local frags = v:Frags()
            local deaths = v:Deaths()
            local ratio
            local score = v:GetNWInt("playerScoreMatch")

            surface.SetFont("Health")
            local nameLength = select(1, surface.GetTextSize(name .. " | " .. "P" .. prestige .. " L" .. level))

            -- format the K/D Ratio of a player, stops it from displaying INF when the player has gotten a kill, but has also not died yet
            if v:Frags() <= 0 then
                ratio = 0
            elseif v:Frags() >= 1 and v:Deaths() == 0 then
                ratio = v:Frags()
            else
                ratio = v:Frags() / v:Deaths()
            end

            local ratioRounded = math.Round(ratio, 2)

            local PlayerPanel = vgui.Create("DPanel", PlayerList)
            PlayerPanel:SetSize(PlayerList:GetWide(), TM.MenuScale(125))
            PlayerPanel:SetPos(0, 0)
            PlayerPanel.Paint = function(self, w, h)
                if !IsValid(v) then return end
                if k == 1 then draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 35, 40)) else draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 40)) end

                draw.SimpleText(name .. " | " .. "P" .. prestige .. " L" .. level, "Health", TM.MenuScale(10), 0, white, TEXT_ALIGN_LEFT)
                draw.SimpleText(frags, "Health", TM.MenuScale(285), TM.MenuScale(35), Color(0, 255, 0), TEXT_ALIGN_LEFT)
                draw.SimpleText(deaths, "Health", TM.MenuScale(285), TM.MenuScale(60), Color(255, 0, 0), TEXT_ALIGN_LEFT)
                draw.SimpleText(ratioRounded .. "", "Health", TM.MenuScale(285), TM.MenuScale(85), Color(255, 255, 0), TEXT_ALIGN_LEFT)
                draw.SimpleText(score, "Health", TM.MenuScale(427), TM.MenuScale(85), white, TEXT_ALIGN_RIGHT)

                surface.SetFont("CaliberText")
				local roleLength = 0
				local mutedLength = 0

				if usergroup == "dev" then
					draw.SimpleText("(dev)", "CaliberText", nameLength + TM.MenuScale(15), TM.MenuScale(5), Color(205, 255, 0), TEXT_ALIGN_LEFT)
					roleLength = select(1, surface.GetTextSize("(dev)"))
				elseif usergroup == "mod" then
					draw.SimpleText("(mod)", "CaliberText", nameLength + TM.MenuScale(15), TM.MenuScale(5), Color(255, 0, 100), TEXT_ALIGN_LEFT)
					roleLength = select(1, surface.GetTextSize("(mod)"))
				elseif usergroup == "contributor" then
					draw.SimpleText("(contributor)", "CaliberText", nameLength + TM.MenuScale(15), TM.MenuScale(5), Color(0, 110, 255), TEXT_ALIGN_LEFT)
					roleLength = select(1, surface.GetTextSize("(contributor)"))
				end

				if v:IsMuted() then
					draw.SimpleText("(muted)", "CaliberText", nameLength + roleLength + TM.MenuScale(15), TM.MenuScale(5), Color(255, 0, 0), TEXT_ALIGN_LEFT)
					mutedLength = select(1, surface.GetTextSize("(muted)"))
				end

				if v:GetFriendStatus() == "friend" then
					draw.SimpleText("(friend)", "CaliberText", nameLength + roleLength + mutedLength + TM.MenuScale(15), TM.MenuScale(5), Color(0, 255, 0), TEXT_ALIGN_LEFT)
					mutedLength = select(1, surface.GetTextSize("(friend)"))
				end
            end

            local KillsIcon = vgui.Create("DImage", PlayerPanel)
            KillsIcon:SetPos(TM.MenuScale(260), TM.MenuScale(42))
            KillsIcon:SetSize(TM.MenuScale(20), TM.MenuScale(20))
            KillsIcon:SetImage("icons/killicon.png")

            local DeathsIcon = vgui.Create("DImage", PlayerPanel)
            DeathsIcon:SetPos(TM.MenuScale(260), TM.MenuScale(67))
            DeathsIcon:SetSize(TM.MenuScale(20), TM.MenuScale(20))
            DeathsIcon:SetImage("icons/deathicon.png")

            local KDIcon = vgui.Create("DImage", PlayerPanel)
            KDIcon:SetPos(TM.MenuScale(260), TM.MenuScale(92))
            KDIcon:SetSize(TM.MenuScale(20), TM.MenuScale(20))
            KDIcon:SetImage("icons/ratioicon.png")

            local ScoreIcon = vgui.Create("DImage", PlayerPanel)
            ScoreIcon:SetPos(TM.MenuScale(432), TM.MenuScale(92))
            ScoreIcon:SetSize(TM.MenuScale(20), TM.MenuScale(20))
            ScoreIcon:SetImage("icons/scoreicon.png")

            local PlayerCallingCard = vgui.Create("DImage", PlayerPanel)
            PlayerCallingCard:SetPos(TM.MenuScale(10), TM.MenuScale(35))
            PlayerCallingCard:SetSize(TM.MenuScale(240), TM.MenuScale(80))

            if IsValid(v) then PlayerCallingCard:SetImage(v:GetNWString("chosenPlayercard"), "cards/color/black.png") end

            local PlayerProfilePicture = vgui.Create("AvatarImage", PlayerPanel)
            PlayerProfilePicture:SetPos(TM.MenuScale(15), TM.MenuScale(40))
            PlayerProfilePicture:SetSize(TM.MenuScale(70), TM.MenuScale(70))
            PlayerProfilePicture:SetPlayer(v, 184)

            -- allows the players profile to be clicked to display various options revolving around the specific player
			PlayerProfilePicture.OnMousePressed = function()
				local Menu = DermaMenu()

				local profileButton = Menu:AddOption("Open Steam Profile", function() gui.OpenURL("http://steamcommunity.com/profiles/" .. v:SteamID64()) end)
				profileButton:SetIcon("icon16/page_find.png")

				Menu:AddSpacer()

				local statistics = Menu:AddSubMenu("View Stats")
				local accolades = Menu:AddSubMenu("View Accolades")
				local weaponstatistics = Menu:AddSubMenu("View Weapon Stats")
				local weaponKills = weaponstatistics:AddSubMenu("Kills With")
				weaponKills:SetMaxHeight(ScrH() / 1.5)

				if v:GetInfoNum("tm_hidestatsfromothers", 0) == 0 or v == LocalPly then
					statistics:AddOption("Prestige " .. v:GetNWInt("playerPrestige") .. " Level " .. v:GetNWInt("playerLevel"))
					statistics:AddOption("Score: " .. v:GetNWInt("playerScore"))
					statistics:AddOption("Kills: " .. v:GetNWInt("playerKills"))
					statistics:AddOption("Deaths: " .. v:GetNWInt("playerDeaths"))
					statistics:AddOption("K/D Ratio: " .. math.Round(v:GetNWInt("playerKills") / v:GetNWInt("playerDeaths"), 3))
					statistics:AddOption("Highest Killstreak: " .. v:GetNWInt("highestKillStreak"))
					statistics:AddOption("Highest Kill Game: " .. v:GetNWInt("highestKillGame"))
					statistics:AddOption("Farthest Kill: " .. v:GetNWInt("farthestKill") .. "m")
					statistics:AddOption("Matches Played: " .. v:GetNWInt("matchesPlayed"))
					statistics:AddOption("Matches Won: " .. v:GetNWInt("matchesWon"))
					statistics:AddOption("W/L Ratio: " .. math.Round((v:GetNWInt("matchesWon") / v:GetNWInt("matchesPlayed")) * 100) .. "%")
					accolades:AddOption("Headshot Kills: " .. v:GetNWInt("playerAccoladeHeadshot"))
					accolades:AddOption("Smackdowns (Melee Kills): " .. v:GetNWInt("playerAccoladeSmackdown"))
					accolades:AddOption("Clutches (Kills with less than 15 HP): " .. v:GetNWInt("playerAccoladeClutch"))
					accolades:AddOption("Longshots: " .. v:GetNWInt("playerAccoladeLongshot"))
					accolades:AddOption("Point Blanks: " .. v:GetNWInt("playerAccoladePointblank"))
					accolades:AddOption("On Streaks (Kill Streaks Started): " .. v:GetNWInt("playerAccoladeOnStreak"))
					accolades:AddOption("Buzz Kills (Kill Streaks Ended): " .. v:GetNWInt("playerAccoladeBuzzkill"))
					for i = 1, #weaponArray do
						weaponKills:AddOption(weaponArray[i][2] .. ": " .. v:GetNWInt("killsWith_" .. weaponArray[i][1]))
					end
				else
					statistics:AddOption("This player has their stats hidden.")
					accolades:AddOption("This player has their stats hidden.")
					weaponKills:AddOption("This player has their stats hidden.")
				end

				Menu:AddSpacer()

				local copyMenu = Menu:AddSubMenu("Copy...")
				copyMenu:AddOption("Copy Name", function() SetClipboardText(v:GetName()) end):SetIcon("icon16/cut.png")
				copyMenu:AddOption("Copy SteamID64", function() SetClipboardText(v:SteamID64()) end):SetIcon("icon16/cut.png")

				if v != LocalPly then
					local muteToggle = Menu:AddOption("Mute Player", function(self)
						if v:IsMuted() then v:SetMuted(false) else v:SetMuted(true) end
					end)

					if v:IsMuted() then muteToggle:SetIcon("icon16/sound.png") muteToggle:SetText("Unmute Player") else muteToggle:SetIcon("icon16/sound_mute.png") muteToggle:SetText("Mute Player") end
				end

				Menu:Open()
            end
        end
    end

    EndOfGameUI:Show()
    gui.EnableScreenClicker(true)
end )

net.Receive("SendChatMessage", function(len, ply)
    local text = net.ReadString()
    table.insert(chatArray, text)
end)

-- updates the players time until self destruct on Cranked
net.Receive("NotifyCranked", function(len, ply)
    timeUntilSelfDestruct = crankedSelfDestructTime
    timer.Create("CrankedTimeUntilDeath", crankedSelfDestructTime, 1, function()
        hook.Remove("Think", "CrankedTimeLeft")
    end)

    hook.Add("Think", "CrankedTimeLeft", function()
        if timer.Exists("CrankedTimeUntilDeath") then timeUntilSelfDestruct = math.Round(timer.TimeLeft("CrankedTimeUntilDeath")) end
    end)
end)

-- shows the players loadout on the bottom left hand side of their screen
function ShowLoadoutOnSpawn(ply)
    if !IsValid(ply) then return end
    local primaryWeapon = ""
    local secondaryWeapon = ""
    local meleeWeapon = ""
    for i = 1, #weaponArray do
        if weaponArray[i][1] == ply:GetNWString("loadoutPrimary") and usePrimary then primaryWeapon = weaponArray[i][2] end
        if weaponArray[i][1] == ply:GetNWString("loadoutSecondary") and useSecondary then secondaryWeapon = weaponArray[i][2] end
        if weaponArray[i][1] == ply:GetNWString("loadoutMelee") and useMelee then meleeWeapon = weaponArray[i][2] end
    end
    notification.AddProgress("LoadoutText", "Current Loadout:\n" .. primaryWeapon .. "\n" .. secondaryWeapon .. "\n" .. meleeWeapon)
    timer.Simple(2.5, function()
        notification.Kill("LoadoutText")
    end)
end

-- conVar callbacks related to HUD editing, much more optimized and cleaner looking than repeadetly checking the players settings
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
cvars.AddChangeCallback("tm_headshotkillsoundtype", function(convar_name, value_old, value_new)
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
cvars.AddChangeCallback("tm_hud_crosshair_sprint", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_gap", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_size", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_thickness", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_opacity", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_duration", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_color_hit_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_color_hit_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_color_hit_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_color_head_r", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_color_head_g", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_hitmarker_color_head_b", function(convar_name, value_old, value_new)
    UpdateHUD()
end)
cvars.AddChangeCallback("tm_hud_scale", function(convar_name, value_old, value_new) UpdateHUD() end)
hook.Add("OnScreenSizeChanged", "ResolutionChange", function()
    scrW, scrH = ScrW(), ScrH()
    center_x, center_y = ScrW() / 2, ScrH() / 2
    UpdateHUD()
end)