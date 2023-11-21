local meta = FindMetaTable("Player")
function meta:GetSliding()
    return self:GetDTBool(20)
end

function meta:SetSliding(value)
    return self:SetDTBool(20, value)
end

function meta:GetSlidingTime()
    return self:GetDTFloat(20)
end

function meta:SetSlidingTime(value)
    return self:SetDTFloat(20, value)
end

local slide_sounds = {
    [MAT_DIRT] = {"datae/fol_slide_dirt_01.wav", "datae/fol_slide_dirt_02.wav", "datae/fol_slide_dirt_03.wav", "datae/fol_slide_dirt_04.wav"},
    [MAT_SAND] = {"datae/fol_slide_sand_01.wav", "datae/fol_slide_sand_02.wav", "datae/fol_slide_sand_03.wav", "datae/fol_slide_sand_04.wav"},
    [MAT_METAL] = {"datae/fol_slide_metal_01.wav", "datae/fol_slide_metal_02.wav", "datae/fol_slide_metal_03.wav"},
    [MAT_GLASS] = {"datae/fol_slide_glass_01.wav", "datae/fol_slide_glass_02.wav", "datae/fol_slide_glass_03.wav", "datae/fol_slide_glass_04.wav"},
    [MAT_GRATE] = {"datae/fol_slide_grate_01.wav",},
    [MAT_SLOSH] = {"ambient/water/water_splash1.wav", "ambient/water/water_splash2.wav", "ambient/water/water_splash3.wav"},
    [0] = {"datae/fol_slide_generic_01.wav", "datae/fol_slide_generic_02.wav", "datae/fol_slide_generic_03.wav"}
}

slide_sounds[MAT_GRASS] = slide_sounds[MAT_DIRT]
slide_sounds[MAT_SNOW] = slide_sounds[MAT_DIRT]
slide_sounds[MAT_VENT] = slide_sounds[MAT_METAL]

if game.SinglePlayer() then
    if SERVER then
        util.AddNetworkString("sliding_spfix")
    else
        net.Receive("sliding_spfix", function()
            if VManip then
                VManip:PlayAnim("vault")
            end

            local ply = LocalPlayer()
            ply.SlidingAngle = ply:GetVelocity():Angle()
        end)
    end
end

local slidepunch = Angle(-1, 0, -2.5)
local trace_down = Vector(0, 0, 32)
local trace_tbl = {}

local function SlideSurfaceSound(ply, pos)
    trace_tbl.start = pos
    trace_tbl.endpos = pos - trace_down
    trace_tbl.filter = ply
    local tr = util.TraceLine(trace_tbl)
    local sndtable = slide_sounds[tr.MatType] or slide_sounds[0]
    ply:EmitSound(sndtable[math.random(#sndtable)], math.random(40, 50), math.random(90, 110) + math.random(-4, 4))
    ply:EmitSound("datae/fol_sprint_rustle_0" .. math.random(1, 5) .. ".wav")

    if ply:WaterLevel() > 0 then
        sndtable = slide_sounds[MAT_SLOSH]
        ply:EmitSound(sndtable[math.random(#sndtable)])
    end
end

local slidetime = math.max(0.1, 1)

hook.Add("StartCommand", "SlideControl", function(ply, cmd)
    if ply:GetSliding() then
        cmd:ClearMovement()
        local bindType = ply:GetInfoNum("tm_slidecanceltype", 0)
        if (bindType == 0 or bindType == 1) then cmd:RemoveKey(IN_SPEED) elseif bindType == 2 then cmd:RemoveKey(IN_JUMP) end
        if bindType != 0 then slidelock = 0.45 else slidelock = 0.79 end
        local trueslidetime = (ply:GetSlidingTime() - CurTime()) / slidetime

        if (trueslidetime < 0.79 and bindType == 0 and ply:KeyDown(IN_DUCK) == false) or (trueslidetime < 0.79 and bindType == 1 and ply:KeyPressed(IN_JUMP)) or (trueslidetime < 0.79 and bindType == 2 and ply:KeyPressed(IN_SPEED)) then
            cmd:RemoveKey(IN_DUCK)
            ply:SetSliding(false)
            ply:SetSlidingTime(0)
            ply:SetDuckSpeed(0.75)
            ply:SetUnDuckSpeed(0.15)
        end

        if trueslidetime > slidelock then
            cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_DUCK))
        end
    end
end)

hook.Add("SetupMove", "tmmoveement", function(ply, mv, cmd)
    if not ply.OldDuckSpeed then
        ply.OldDuckSpeed = ply:GetDuckSpeed()
        ply.OldUnDuckSpeed = ply:GetUnDuckSpeed()
        ply.OldWalkSpeed = ply:GetWalkSpeed()
        ply.OldRunSpeed = ply:GetRunSpeed()
        ply.OldJumpPower = ply:GetJumpPower()
    end

    local sliding = ply:GetSliding()
    local speed = mv:GetVelocity():Length()
    local runspeed = ply:GetRunSpeed()
    local ducking = mv:KeyDown(IN_DUCK)
    local crouching = ply:Crouching()
    local sprinting = mv:KeyDown(IN_SPEED)
    local onground = ply:OnGround()
    local CT = CurTime()

    if ducking and sprinting and onground and not sliding and speed > runspeed * 0.5 then
        if timer.Exists(ply:SteamID64() .. "_SlideCD") then return end
        if not ply.CanSlide then return end
        timer.Create(ply:SteamID64() .. "_SlideCD", 1, 1, function()
        end)
        timer.Create(ply:SteamID64() .. "_WalkReset", 0.8, 1, function()
            ply:SetWalkSpeed(ply.OldWalkSpeed)
        end)
        ply.CanSlide = false
        ply.LandVelocity = mv:GetVelocity():Length()
        ply:SetSliding(true)
        ply:SetSlidingTime(CT + slidetime)
        ply:ViewPunch(slidepunch)
        ply:SetDuckSpeed(0.2)
        ply:SetUnDuckSpeed(0.2)
        ply:SetWalkSpeed(458) -- This is such a HORRIBLE way of fixing a exploit that allows people to cancel a slide at a certain time to crouch at sprint speed, but ive been trying to fix this well for multiple hours and can't take this anymore.
        ply:SetJumpPower(0)
        ply.SlidingAngle = mv:GetVelocity():Angle()

        if SERVER then
            local pos = mv:GetOrigin()
            SlideSurfaceSound(ply, pos)

            if game.SinglePlayer() then
                net.Start("sliding_spfix")
                net.Send(ply)
            end
        elseif VManip then
            VManip:PlayAnim("vault")
        end
    elseif (not ducking or not onground) and sliding then
        ply:SetSliding(false)
        ply:SetSlidingTime(0)
    end

    sliding = ply:GetSliding()

    if sliding and mv:KeyDown(IN_DUCK) then
        local slidedelta = (ply:GetSlidingTime() - CT) / slidetime
        speed = (math.max(276, ply.LandVelocity / 2 * slidetime) * math.min(0.85, (ply:GetSlidingTime() - CT + 0.5) / slidetime)) * (1 / engine.TickInterval()) * engine.TickInterval() * 1.55
        ply:SetMoveType(MOVETYPE_WALK)
        mv:SetVelocity(ply.SlidingAngle:Forward() * speed)
        local pos = mv:GetOrigin()

        if not ply.SlidingLastPos then
            ply.SlidingLastPos = pos
        end

        if pos.z > ply.SlidingLastPos.z + 1 then
            ply:SetSlidingTime(ply:GetSlidingTime() - 0.025)
        elseif slidedelta < 0.5 and pos.z < ply.SlidingLastPos.z - 1 then
            ply:SetSlidingTime(CT + slidetime * 0.5)
        end

        ply.SlidingLastPos = pos

        if CT > ply:GetSlidingTime() then
            ply:SetSliding(false)
            ply:SetSlidingTime(0)
            ply:SetDuckSpeed(ply.OldDuckSpeed)
            ply:SetUnDuckSpeed(ply.OldUnDuckSpeed)
            ply:SetWalkSpeed(ply.OldWalkSpeed)
            ply:SetJumpPower(ply.OldJumpPower)
        end
    end

    sliding = ply:GetSliding()

    if not crouching and not sliding then
        ply:SetDuckSpeed(ply.OldDuckSpeed)
        ply:SetUnDuckSpeed(ply.OldUnDuckSpeed)
        ply:SetWalkSpeed(ply.OldWalkSpeed)
        ply:SetJumpPower(ply.OldJumpPower)
        ply.CanSlide = true
    end
end)
-- ^^ Original Sliding portion of script created by datæ