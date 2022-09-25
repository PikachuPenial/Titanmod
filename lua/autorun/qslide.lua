local qslide_duration = CreateConVar("sv_qslide_duration", 0.75, {FCVAR_REPLICATED, FCVAR_ARCHIVE})

local qslide_speedmult = CreateConVar("sv_qslide_speedmult", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE})

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

local slidepunch = Angle(-1, 0, -2.5)
local trace_down = Vector(0, 0, 32)
local trace_up = Vector(0, 0, 32)
local trace_tbl = {}

local function SlideSurfaceSound(ply, pos)
    trace_tbl.start = pos
    trace_tbl.endpos = pos - trace_down
    trace_tbl.filter = ply
    local tr = util.TraceLine(trace_tbl)
    local sndtable = slide_sounds[tr.MatType] or slide_sounds[0]
    ply:EmitSound(sndtable[math.random(#sndtable)], 75, 100 + math.random(-4, 4))
    ply:EmitSound("datae/fol_sprint_rustle_0" .. math.random(1, 5) .. ".wav")

    if ply:WaterLevel() > 0 then
        sndtable = slide_sounds[MAT_SLOSH]
        ply:EmitSound(sndtable[math.random(#sndtable)])
    end
end

hook.Add("SetupMove", "qslide", function(ply, mv, cmd)
    if not ply.OldDuckSpeed then
        ply.OldDuckSpeed = ply:GetDuckSpeed()
        ply.OldUnDuckSpeed = ply:GetUnDuckSpeed()
    end

    local sliding = ply:GetSliding()
    local speed = mv:GetVelocity():Length()
    local runspeed = ply:GetRunSpeed()
    local slidetime = math.max(0.1, qslide_duration:GetFloat())
    local ducking = mv:KeyDown(IN_DUCK)
    local crouching = ply:Crouching()
    local sprinting = mv:KeyDown(IN_SPEED)
    local onground = ply:OnGround()
    local CT = CurTime()

    if ducking and sprinting and onground and not sliding and not crouching and speed > runspeed * 0.5 then
        ply:SetSliding(true)
        ply:SetSlidingTime(CT + slidetime)
        ply:ViewPunch(slidepunch)
        ply:SetDuckSpeed(0.25)
        ply:SetUnDuckSpeed(0.3)
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
        local FT = FrameTime()
        local TargetTick = ((1 / FT) / 66.66) * 2.0831 --wtf
        local speed = ((runspeed) * math.min(0.85, ((ply:GetSlidingTime() - CT + 0.5) / slidetime)) * (1 / engine.TickInterval()) * engine.TickInterval()) * qslide_speedmult:GetFloat()
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
        end
    end

    sliding = ply:GetSliding()

    if not crouching and not sliding then
        ply:SetDuckSpeed(ply.OldDuckSpeed)
        ply:SetUnDuckSpeed(ply.OldUnDuckSpeed)
    end
end)

hook.Add("PlayerFootstep", "qslidestep", function(ply)
    if ply:GetSliding() then return true end
end)

hook.Add("StartCommand", "qslidespeed", function(ply, cmd)
    if ply:GetSliding() then
        cmd:RemoveKey(IN_SPEED)
        cmd:RemoveKey(IN_JUMP)
        cmd:ClearMovement()
        local slidetime = math.max(0.1, qslide_duration:GetFloat())

        if (ply:GetSlidingTime() - CurTime()) / slidetime > 0.6 then
            cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_DUCK))
        end
    end
end)

if CLIENT then
    local view = {}
    local lastz = 0
    local t = 0.05
    local qslide_view = CreateClientConVar("cl_qslide_view", 1)

    hook.Add("CalcView", "qslideView", function(ply, origin, angles, fov)
        if not qslide_view:GetBool() then return end
        local sliding = ply:GetSliding()

        if not ply:ShouldDrawLocalPlayer() and sliding or lastz ~= 0 then
            if not sliding then
                t = t + (2 * FrameTime())
            else
                t = 0.05
            end

            if ply.SlidingAngle then
                local z

                if sliding then
                    local slidetime = math.max(0.1, qslide_duration:GetFloat())
                    z = (ply.SlidingAngle:Right():Dot(angles:Forward()) * 15) * ((ply:GetSlidingTime() - CurTime()) / slidetime)
                else
                    z = 0
                end

                lastz = Lerp(t, lastz, z)
                angles.z = lastz
            end
        end
    end)

    hook.Add("GetMotionBlurValues", "qslideBlur", function(h, v, f, r)
        local ply = LocalPlayer()

        if ply:GetSliding() then
            local slidetime = math.max(0.1, qslide_duration:GetFloat())
            local t = (ply:GetSlidingTime() - CurTime()) / slidetime

            return h, v, f + 0.05 * t, r
        end
    end)
end