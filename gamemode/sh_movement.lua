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

local walljumpleftpunch = Angle(0, 0, -10)
local walljumprightpunch = Angle(0, 0, 10)
local wallrunleftpunch = Angle(0, 0, 15)
local wallrunrightpunch = Angle(0, 0, -15)

local wallJumpTime = 1
local wallRunTime = 1.25

hook.Add("Move", "TM_Move", function(ply, mv)
    local sprinting = mv:KeyDown(IN_SPEED)
    local goingLeft = mv:KeyDown(IN_MOVELEFT)
    local goingRight = mv:KeyDown(IN_MOVERIGHT)
    local jumping = mv:KeyDown(IN_JUMP)
    local onground = ply:OnGround()
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
-- ^^ Original Sliding portion of script created by datæ