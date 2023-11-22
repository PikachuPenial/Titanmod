if customMovement == true then
local meta = FindMetaTable("Player")
function meta:GetWJTime()
    return self:GetDTFloat(20)
end
function meta:SetWJTime(value)
    return self:SetDTFloat(20, value)
end

function meta:GetWRTime()
    return self:GetDTFloat(22)
end
function meta:SetWRTime(value)
    return self:SetDTFloat(22, value)
end

function meta:GetWRTime()
    return self:GetDTFloat(22)
end
function meta:SetWRTime(value)
    return self:SetDTFloat(22, value)
end

function meta:GetSliding()
    return self:GetDTBool(24)
end
function meta:SetSliding(value)
    return self:SetDTBool(24, value)
end
function meta:GetCanSlide()
    return self:GetDTBool(25)
end
function meta:SetCanSlide(value)
    return self:SetDTBool(25, value)
end
function meta:GetSlidingTime()
    return self:GetDTFloat(24)
end
function meta:SetSlidingTime(value)
    return self:SetDTFloat(24, value)
end
function meta:GetSlidingCD()
    return self:GetDTFloat(26)
end
function meta:SetSlidingCD(value)
    return self:SetDTFloat(26, value)
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

local walljumpleftpunch = Angle(0, 0, -10)
local walljumprightpunch = Angle(0, 0, 10)
local wallrunleftpunch = Angle(0, 0, 15)
local wallrunrightpunch = Angle(0, 0, -15)
local slidepunch = Angle(-1, 0, -2.5)
local trace_down = Vector(0, 0, 32)
local trace_tbl = {}

local wallJumpTime = 1
local wallRunTime = 1.25
local slideTime = playerSlideDuration
local slideSpeed = playerSlideSpeedMulti

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

hook.Add("StartCommand", "SlideControl", function(ply, cmd)
    if ply:GetSliding() then
        cmd:ClearMovement()
        local bindType = ply:GetInfoNum("tm_slidecanceltype", 0)
        if (bindType == 0 or bindType == 1) then cmd:RemoveKey(IN_SPEED) elseif bindType == 2 then cmd:RemoveKey(IN_JUMP) end
        if bindType != 0 then slideLock = 0.45 else slideLock = 0.79 end
        local trueSlideTime = (ply:GetSlidingTime() - CurTime()) / slideTime

        if (trueSlideTime < 0.79 and bindType == 0 and ply:KeyDown(IN_DUCK) == false) or (trueSlideTime < 0.79 and bindType == 1 and ply:KeyPressed(IN_JUMP)) or (trueSlideTime < 0.79 and bindType == 2 and ply:KeyPressed(IN_SPEED)) then
            cmd:RemoveKey(IN_DUCK)
            ply:SetSliding(false)
            ply:SetSlidingTime(0)
            ply:SetDuckSpeed(0.75)
            ply:SetUnDuckSpeed(0.15)
        end

        if trueSlideTime > slideLock then
            cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_DUCK))
        end
    end
end)

hook.Add("Move", "TM_Move", function(ply, mv)
    if not ply.OldDuckSpeed then
        ply.OldDuckSpeed = ply:GetDuckSpeed()
        ply.OldUnDuckSpeed = ply:GetUnDuckSpeed()
        ply.OldWalkSpeed = ply:GetWalkSpeed()
        ply.OldRunSpeed = ply:GetRunSpeed()
        ply.OldJumpPower = ply:GetJumpPower()
    end

    local sprinting = mv:KeyDown(IN_SPEED)
    local goingLeft = mv:KeyDown(IN_MOVELEFT)
    local goingRight = mv:KeyDown(IN_MOVERIGHT)
    local jumping = mv:KeyDown(IN_JUMP)
    local onground = ply:OnGround()
    local sliding = ply:GetSliding()
    local speed = mv:GetVelocity():Length()
    local runspeed = ply:GetRunSpeed()
    local ducking = mv:KeyDown(IN_DUCK)
    local crouching = ply:Crouching()
    local CT = CurTime()

    local ang = mv:GetMoveAngles()
    local pos = mv:GetOrigin()
    local eyepos = pos + Vector(0, 0, 64)
    local vel = mv:GetVelocity()

    if onground then
        ply:SetWJTime(CT)
        ply:SetWRTime(CT)
    end

    if ply:GetMoveType() == MOVETYPE_LADDER then return end

    if ducking and sprinting and onground and not sliding and speed > runspeed * 0.5 then
        if not ply:GetCanSlide() then return end
        ply.Fatigue = math.min(1, (CT + slideTime) - (ply:GetSlidingCD()))
        ply:SetCanSlide(false)
        ply:SetSlidingCD(CT + slideTime)
        ply:SetSliding(true)
        ply:SetSlidingTime(CT + slideTime)
        ply:ViewPunch(slidepunch)
        ply:SetDuckSpeed(0.2)
        ply:SetUnDuckSpeed(0.2)
        ply:SetWalkSpeed(458) -- This is such a HORRIBLE way of fixing a exploit that allows people to cancel a slide at a certain time to crouch at sprint speed, but ive been trying to fix this well for multiple hours and can't take this anymore.
        ply:SetJumpPower(0)
        ply.LandVelocity = mv:GetVelocity():Length()
        ply.SlidingAngle = mv:GetVelocity():Angle()

        if SERVER then
            SlideSurfaceSound(ply, pos)
        elseif VManip then
            VManip:PlayAnim("vault")
        end
    elseif (not ducking or not onground) and sliding then
        ply:SetSliding(false)
        ply:SetSlidingTime(0)
    end

    sliding = ply:GetSliding()

    if sliding and mv:KeyDown(IN_DUCK) then
        local slideDelta = (ply:GetSlidingTime() - CT) / slideTime
        speed = math.max(200, (math.max(276, ply.LandVelocity / 2 * slideTime) * math.min(0.85, (ply:GetSlidingTime() - CT + 0.5) / slideTime)) * (1 / engine.TickInterval()) * engine.TickInterval() * slideSpeed * ply.Fatigue)

        vel = ply.SlidingAngle:Forward() * speed
        mv:SetVelocity(vel)
        mv:SetOrigin(pos)

        if not ply.SlidingLastPos then
            ply.SlidingLastPos = pos
        end

        if pos.z > ply.SlidingLastPos.z + 1 then
            ply:SetSlidingTime(ply:GetSlidingTime() - 0.025)
        elseif slideDelta < 0.5 and pos.z < ply.SlidingLastPos.z - 1 then
            ply:SetSlidingTime(CT + slideTime * 0.5)
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
        ply:SetCanSlide(true)
        ply:SetDuckSpeed(ply.OldDuckSpeed)
        ply:SetUnDuckSpeed(ply.OldUnDuckSpeed)
        ply:SetWalkSpeed(ply.OldWalkSpeed)
        ply:SetJumpPower(ply.OldJumpPower)
    end

    if goingLeft then
        -- WJ Left
        if jumping then
            if ply:GetWJTime() > CT then return end

            tracedata = {}
            tracedata.start = eyepos + (ang:Right() * 1)
            tracedata.endpos = eyepos + (ang:Right() * 32)
            tracedata.filter = ply
            local traceWallLeft = util.TraceLine(tracedata)

            if (traceWallLeft.Hit) then
                ply:SetWJTime(CT + wallJumpTime)
                ply:ViewPunch(walljumpleftpunch)
                if SERVER then ply:EmitSound("player/footsteps/tile" .. math.random(1, 4) .. ".wav", 70, 80) end
                vel = Vector(0, 0, 280) + ((ang:Right() * -1) * 175)
                mv:SetVelocity(vel)
                mv:SetOrigin(pos)
                return
            end
        end

        --WR Left
        if sprinting and not onground then
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
                mv:SetVelocity(vel)
                mv:SetOrigin(pos)
                return
            end
        end
    end

    if goingRight then
        -- WJ Right
        if jumping then
            if ply:GetWJTime() > CT then return end

            tracedata = {}
            tracedata.start = eyepos + (ang:Right() * -1)
            tracedata.endpos = eyepos + (ang:Right() * -32)
            tracedata.filter = ply
            local traceWallRight = util.TraceLine(tracedata)

            if (traceWallRight.Hit) then
                ply:SetWJTime(CT + wallJumpTime)
                ply:ViewPunch(walljumprightpunch)
                if SERVER then ply:EmitSound("player/footsteps/tile" .. math.random(1, 4) .. ".wav", 70, 80) end
                vel = Vector(0, 0, 280) + ((ang:Right() * 1) * 175)
                mv:SetVelocity(vel)
                mv:SetOrigin(pos)
                return
            end
        end

        -- WR Right
        if sprinting and not onground then
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
                mv:SetVelocity(vel)
                mv:SetOrigin(pos)
                return
            end
        end
    end
end)

hook.Add("FinishMove", "TM_FinishMove", function(ply, mv)
    ply:SetNetworkOrigin(mv:GetOrigin())
end)
end
-- ^^ Original Sliding portion of script created by datæ