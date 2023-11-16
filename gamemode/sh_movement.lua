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

function meta:GetWJTime()
    return self:GetDTFloat(20)
end
function meta:SetWJTime(value)
    return self:SetDTFloat(20, value)
end

function meta:GetWRTime()
    return self:GetDTFloat(20)
end
function meta:SetWRTime(value)
    return self:SetDTFloat(20, value)
end

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
        end)
    end
end

local trace_down = Vector(0, 0, 32)
local trace_tbl = {}

local slidepunch = Angle(-1, 0, -2.5)
local walljumpleftpunch = Angle(0, 0, -10)
local walljumprightpunch = Angle(0, 0, 10)
local wallrunleftpunch = Angle(0, 0, 15)
local wallrunrightpunch = Angle(0, 0, -15)

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

local slidetime = math.max(0.1, qslide_duration:GetFloat())
local wallJumpTime = 1
local wallRunTime = 1.25

hook.Add("Move", "TM_Move", function(ply, mv)
    if not ply.OldDuckSpeed then
        ply.OldDuckSpeed = ply:GetDuckSpeed()
        ply.OldUnDuckSpeed = ply:GetUnDuckSpeed()
        ply.OldWalkSpeed = ply:GetWalkSpeed()
        ply.OldRunSpeed = ply:GetRunSpeed()
        ply.OldJumpPower = ply:GetJumpPower()
    end

    local speed = mv:GetVelocity():Length()
    local runspeed = ply:GetRunSpeed()
    local ducking = mv:KeyDown(IN_DUCK)
    local sprinting = mv:KeyDown(IN_SPEED)
    local goingLeft = mv:KeyDown(IN_MOVELEFT)
    local goingRight = mv:KeyDown(IN_MOVERIGHT)
    local jumping = mv:KeyDown(IN_JUMP)
    crouching = ply:Crouching()
    onground = ply:OnGround()
    local CT = CurTime()

    local ang = mv:GetMoveAngles()
    local pos = mv:GetOrigin()
    local eyepos = pos + Vector(0, 0, 64)
    local vel = mv:GetVelocity()

    -- WR Left
    if goingLeft and sprinting and not onground then
        if ply:GetWRTime() > CT then return end

        tracedata = {}
        tracedata.start = eyepos + (ang:Up() * -1) + (ang:Forward() * 32)
        tracedata.endpos = eyepos + (ang:Up() * -53) + (ang:Forward() * 64)
        tracedata.filter = ply
        local traceWalLLow = util.TraceLine(tracedata)

        tracedata = {}
        tracedata.start = eyepos + (ang:Forward() * 32)
        tracedata.endpos = eyepos + (ang:Forward() * 64)
        tracedata.filter = ply
        local traceWalLHigh = util.TraceLine(tracedata)

        tracedata = {}
        tracedata.start = eyepos + (ang:Right() * -1)
        tracedata.endpos = eyepos + (ang:Right() * -32)
        tracedata.filter = ply
        local traceWalLRight = util.TraceLine(tracedata)

        if not traceWalLLow.Hit and not traceWalLHigh.Hit and traceWalLRight.Hit then
            ang.x = 0 ang.z = 0
            ply:SetWRTime(CT + wallRunTime)
            ply:ViewPunch(wallrunleftpunch)
            if SERVER then ply:EmitSound("wallrun.wav") end
            vel = Vector(0, 0, 210) + (ang:Right() * -200) + (ang:Forward() * 360)
        end
    end

    -- WR Right
    if goingRight and sprinting and not onground then
        if ply:GetWRTime() > CT then return end

        tracedata = {}
        tracedata.start = eyepos + (ang:Up() * -1) + (ang:Forward() * 32)
        tracedata.endpos = eyepos + (ang:Up() * -53) + (ang:Forward() * 64)
        tracedata.filter = ply
        local traceWalRLow = util.TraceLine(tracedata)

        tracedata = {}
        tracedata.start = eyepos + (ang:Forward() * 32)
        tracedata.endpos = eyepos + (ang:Forward() * 64)
        tracedata.filter = ply
        local traceWalRHigh = util.TraceLine(tracedata)

        tracedata = {}
        tracedata.start = eyepos + (ang:Right() * 1)
        tracedata.endpos = eyepos + (ang:Right() * 32)
        tracedata.filter = ply
        local traceWalRRight = util.TraceLine(tracedata)

        if not traceWalRLow.Hit and not traceWalRHigh.Hit and traceWalRRight.Hit then
            ang.x = 0 ang.z = 0
            ply:SetWRTime(CT + wallRunTime)
            ply:ViewPunch(wallrunrightpunch)
            if SERVER then ply:EmitSound("wallrun.wav") end
            vel = Vector(0, 0, 210) + (ang:Right() * 200) + (ang:Forward() * 360)
        end
    end

    if onground then
        ply:SetWJTime(CT)
        ply:SetWRTime(CT)
    end

    mv:SetVelocity(vel)
    mv:SetOrigin(pos)
end)

hook.Add("FinishMove", "TM_FinishMove", function(ply, mv)
    ply:SetNetworkOrigin(mv:GetOrigin())
end)
-- ^^ Original Sliding portion of script created by datæ