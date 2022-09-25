util.AddNetworkString("MantleRequest")
util.AddNetworkString("MantleStart")
util.AddNetworkString("MantleEnd")
util.AddNetworkString("MantleJump")
util.AddNetworkString("MantleInterrupt")
util.AddNetworkString("VWallrunStart")
util.AddNetworkString("VWallrunEnd")
util.AddNetworkString("HWallrunAng")

local apex_mantle = CreateConVar("sv_ae_mantle", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "self explanatory")
local apex_mantleshort = CreateConVar("sv_ae_mantleshort", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "allow mantling on thin ledges")
local apex_mantle_angleleniency = CreateConVar("sv_ae_angleleniency", 10, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "0 allows mantling only onto flat surfaces. Use to reduce chances of getting stuck")
local apex_vwallrun = CreateConVar("sv_ae_vwallrun", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "self explanatory")
local apex_hwallrun = CreateConVar("sv_ae_hwallrun", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "self explanatory")
local apex_mantlespeed = CreateConVar("sv_ae_mantlespeed", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "mantle speed")
local wallrun_lookatwall = CreateConVar("sv_ae_mustlookatwall", 0, {FCVAR_ARCHIVE}, "look at wall to wallrun")

local function MantleStart(ply, pos, ang, ent)
    ply.InVWallrun = false
    timer.Remove("wallrunfoot")
    ply:SetMoveType(MOVETYPE_NONE)
    ply:SetPos(pos)
    net.Start("MantleStart")
    net.WriteAngle(ang)
    net.WriteEntity(ent)
    net.WriteVector(pos)
    net.Send(ply)
    ply:ViewPunch(Angle(5, 0, 0))
    ply.InMantle = true
    ply.MantleAngle = ang

    if ply.LastVWallAng then
        ply.LastVWallAng = ply.LastVWallAng + Angle(0, 0, 1)
    end

    local isworldent = ent:IsWorld()

    if not isworldent then
        ply.MantleEnt = ent
        ply.MantleOrigPos1 = pos
        ply.MantleOrigPos2 = ent:GetPos()
    else
        ply.MantleEnt = nil
        ply.MantleOrigPos1 = 0
    end
end

local function MantleStop(ply)
    ply.InMantle = false
    net.Start("MantleInterrupt")
    net.Send(ply)
    ply:SetMoveType(MOVETYPE_WALK)
end

local function MantleCheckInterruptions(ply)
    if ply:GetMoveType() ~= MOVETYPE_NONE or (not IsValid(ply.MantleEnt) and ply.MantleOrigPos1 ~= 0) then
        MantleStop(ply)
    end
end

local function MantleUpdatePos(ply)
    if IsValid(ply.MantleEnt) then
        ply:SetPos(ply.MantleOrigPos1 + (ply.MantleEnt:GetPos() - ply.MantleOrigPos2))
    end
end

net.Receive("MantleRequest", function(len, ply)
    if ply.InMantle then return end
    local ang = net.ReadAngle()
    local ent = net.ReadEntity()
    local pos = net.ReadVector()
    local serverposdist = pos:DistToSqr(ply:GetPos())

    if game.SinglePlayer() or (not ply.InMantle and (not ply:OnGround() and serverposdist < 80 and util.IsInWorld(pos) and not ply.doingvault and ply:GetMoveType() ~= MOVETYPE_NOCLIP and not ent:IsNPC() and not ent:IsPlayer())) then
        MantleStart(ply, pos, ang, ent)
    else
        MantleStop(ply)
    end
end)

hook.Add("Think", "ApexMantleThink", function()
    if apex_mantle:GetBool() then
        for k, ply in pairs(player.GetAll()) do
            if (ply:OnGround() and ply:GetMoveType() ~= MOVETYPE_NONE) or (not ply:KeyDown(IN_FORWARD) and not ply.InMantle) or (CurTime() < (ply.LastMantleTime or 0)) or not ply:Alive() then
                if not ply:Alive() then
                    ply.InMantle = false
                end

                return
            end

            --ply:ChatPrint(tostring(trledge.Fraction).." | "..tostring(trledge.Hit).." | "..tostring(trfront.Hit))
            if ply.InMantle then
                MantleCheckInterruptions(ply)
                MantleUpdatePos(ply)
            end
        end
    end
end)

hook.Add("PlayerPostThink", "VerticalWallrunME", function(ply)
    if not apex_vwallrun:GetBool() and not ply.InVWallrun then return end
    if ply:GetMoveType() ~= MOVETYPE_WALK or not ply:KeyDown(IN_FORWARD) and not ply.InVWallrun then return end

    if not ply:KeyPressed(IN_JUMP) and not ply.InVWallrun then
        if ply:OnGround() then
            ply.LastVWallAng = nil
        end

        return
    end

    if ply.InVWallrun == nil or ply.VWallrunTimer == nil or ply.InMantle or not ply:Alive() then
        ply.InVWallrun = false
        ply.VWallrunTimer = CurTime()
        ply.VWallrunAng = Angle(0, 0, 0)
    end

    local trfront = nil

    if ply.LastVWallAng then
        trfront = util.TraceLine({
            start = ply:EyePos() - Vector(0, 0, 5),
            endpos = ply:EyePos() + Angle(0, ply.LastVWallAng.y - 180, 0):Forward() * 35 - Vector(0, 0, 5),
            filter = ply
        })
    end

    local eyetr = ply:GetEyeTrace()

    if not ply.InVWallrun and ply:GetVelocity().z > -550 and not eyetr.HitSky and eyetr.Fraction < 0.0008 and (not ply.LastVWallAng or eyetr.HitNormal:Angle() ~= ply.LastVWallAng) and not ply.InMantle then
        ply:EmitSound("mirrorsedge/ME_FootStep_ConcreteWallRun" .. tostring(math.random(1, 6)) .. ".wav")

        timer.Create("wallrunfoot", 0.215, 0, function()
            ply:EmitSound("mirrorsedge/ME_FootStep_ConcreteWallRun" .. tostring(math.random(1, 6)) .. ".wav")
        end)

        ply.InVWallrun = true
        ply.LastVWallAng = eyetr.HitNormal:Angle()
        ply.VWallrunTimer = CurTime() + 0.4
        net.Start("VWallrunStart")
        net.WriteAngle(eyetr.HitNormal:Angle() - Angle(0, 180, 0))
        net.Send(ply)
    elseif ply.InVWallrun and (not trfront.Hit or ply:KeyPressed(IN_DUCK) or (ply:GetVelocity().z < -550 and CurTime() < ply.VWallrunTimer)) then
        ply.InVWallrun = false
        net.Start("VWallrunEnd")
        net.Send(ply)
        timer.Remove("wallrunfoot")

        if not game.SinglePlayer() then
            ply:SetLocalVelocity(Vector(0, 0, 80))
        else
            ply:SetLocalVelocity(Vector(0, 0, -100))
        end
    elseif ply.InVWallrun and CurTime() < ply.VWallrunTimer then
        ply:SetLocalVelocity(Vector(0, 0, 280))
    elseif CurTime() < ply.VWallrunTimer + 1.25 and ply.InVWallrun then
        local vel = ply:GetVelocity()

        if CurTime() > ply.VWallrunTimer + 0.2 then
            timer.Remove("wallrunfoot")
        end

        ply:SetLocalVelocity(Vector(vel.x, vel.y, math.Clamp(vel.z + 5, -15, 100)))

        if ply:KeyPressed(IN_JUMP) then
            ply:EmitSound("mirrorsedge/ME_Footsteps_Congrete_Clean_WallRun_Slow_Faith" .. tostring(math.random(1, 7)) .. ".wav")
            ply:SetLocalVelocity(ply:EyeAngles():Forward() * 300 + Vector(0, 0, 200))
            ply.VWallrunTimer = 0
        end
    elseif ply.InVWallrun then
        ply.InVWallrun = false
        net.Start("VWallrunEnd")
        net.Send(ply)
        timer.Remove("wallrunfoot")
        ply:SetLocalVelocity(Vector(0, 0, 200))
    end
end)

net.Receive("MantleEnd", function(len, ply)
    if not ply.InMantle or not apex_mantle:GetBool() then return end
    local pos = net.ReadVector()
    local isdrop = net.ReadBool()

    if pos:DistToSqr(ply:GetPos()) < 17000 and util.IsInWorld(pos) then
        ply:SetPos(pos - Vector(0, 0, 64))
    end

    ply.InMantle = false
    ply.LastMantleTime = CurTime() + 0.25
    ply:SetMoveType(MOVETYPE_WALK)

    if not isdrop then
        ply:SetLocalVelocity(Vector(0, 0, 0))
    else
        ply:SetLocalVelocity(Vector(0, 0, -100) + ply.MantleAngle:Forward() * -200)
    end
end)

net.Receive("MantleJump", function(len, ply)
    if not ply.InMantle or not apex_mantle:GetBool() then return end
    ply:SetMoveType(MOVETYPE_WALK)
    ply:EmitSound("mantle/Fol_Sprint_Rustle_0" .. tostring(math.random(1, 5)) .. ".wav", 45, math.random(95, 120))
    local isupjump = net.ReadBool()
    local eyeang = net.ReadAngle()

    if isupjump then
        ply:ViewPunch(Angle(10, 0, 0))
        ply:SetLocalVelocity(Vector(0, 0, 300))
    else
        ply:SetLocalVelocity(eyeang:Forward() * 400 + Vector(0, 0, 100))
    end

    ply.InMantle = false
end)

--HWALLRUN
hook.Add("PlayerPostThink", "HorizontalWallrunME", function(ply)
          --local trleft = nil
          --local trright = nil
          local hitleft = false
    if (not apex_hwallrun:GetBool() or ply:GetMoveType() ~= MOVETYPE_WALK or not ply:KeyDown(IN_FORWARD)) and not ply.InHWallrun then return end

    if not ply:KeyPressed(IN_JUMP) and not ply.InHWallrun then
          mantlewallruntrleft = util.TraceLine({
                    start = ply:EyePos() - Vector(0, 0, 25),
                    endpos = ply:EyePos() + ply:EyeAngles():Right() * -35 - Vector(0, 0, 25),
                    filter = ply
                })
            
          mantlewallruntrright = util.TraceLine({
                    start = ply:EyePos() - Vector(0, 0, 25),
                    endpos = ply:EyePos() + ply:EyeAngles():Right() * 35 - Vector(0, 0, 25),
                    filter = ply
                })
        if ply:OnGround() then
          mantlewallruntrleft = util.TraceLine({
                    start = ply:EyePos() - Vector(0, 0, 25),
                    endpos = ply:EyePos() + ply:EyeAngles():Right() * -35 - Vector(0, 0, 25),
                    filter = ply
                })
            
          mantlewallruntrright = util.TraceLine({
                    start = ply:EyePos() - Vector(0, 0, 25),
                    endpos = ply:EyePos() + ply:EyeAngles():Right() * 35 - Vector(0, 0, 25),
                    filter = ply
                })
            ply.LastHWallAng = nil
            ply.HWallrunLastWall2 = Vector(0, 0, 0)
        end

        return
    end

    if ply.InHWallrun == nil or not ply:Alive() or ply.HWallrunDelay == nil then
        ply.HWallrunDelay = 0
        timer.Remove("wallrunhfoot")
        ply.HWallrunSpeed = Vector(0, 0, 0)
        ply.HWallrunLastWall2 = Vector(0, 0, 0)
        ply.HWallrunLastWall = nil
        ply.InHWallrun = false
        ply.HWallrunUp = 0
        ply.HWallrunTimer = CurTime()
        ply.LastHWallAng = nil
    end

    if ply.InHWallrun and ply:OnGround() then
        ply.HWallrunDelay = CurTime() + 0.15
        net.Start("HWallrunAng")
        net.WriteInt(-1, 2)
        net.Send(ply)
        ply.InHWallrun = false
        timer.Remove("wallrunhfoot")
    end

    if mantlewallruntrleft.Hit and mantlewallruntrright.Hit then
        return
    elseif mantlewallruntrleft.Hit then
        hitleft = true
        ply.LastHWallAng = mantlewallruntrleft.HitNormal
    else
        hitleft = false
        ply.LastHWallAng = mantlewallruntrright.HitNormal
    end

    if ply.InHWallrun then
        ply.HWallrunLastWall2 = ply.LastHWallAng
    end

    local hitleftint = hitleft and -1 or 1
    local trwalln = ply.LastHWallAng:Angle():Right() * hitleftint

    if mantlewallruntrleft.Hit or mantlewallruntrright.Hit then
        ply.HWallrunLastWall = trwalln
    end

    local trground = util.TraceLine({
        start = ply:EyePos(),
        endpos = ply:EyePos() - Vector(0, 0, 80),
        filter = ply
    })

    if not ply.InHWallrun and not ply.InVWallrun and (ply:GetEyeTrace().HitNormal == ply.LastHWallAng or not wallrun_lookatwall:GetBool()) and CurTime() > ply.HWallrunDelay and ply:GetVelocity().z > -450 and (mantlewallruntrleft.Hit or mantlewallruntrright.Hit) and (ply.LastHWallAng ~= ply.HWallrunLastWall2) then
        ply:SetEyeAngles(ply:EyeAngles() - Angle(0, 0, ply:EyeAngles().z))
        ply:ViewPunchReset()
        net.Start("HWallrunAng")
        net.WriteInt(hitleft and 1 or 0, 2)
        net.Send(ply)
        ply.InHWallrun = true

        timer.Create("wallrunhfoot", 0.205, 0, function()
            ply:EmitSound("mirrorsedge/ME_FootStep_ConcreteWallRun" .. tostring(math.random(1, 6)) .. ".wav")
        end)

        ply:EmitSound("mirrorsedge/ME_FootStep_ConcreteWallRun" .. tostring(math.random(1, 6)) .. ".wav")
        ply.HWallrunTimer = CurTime() + 1
        ply.HWallrunSpeed = ply:GetVelocity() * Vector(1, 1, 0)

        if trground.Hit then
            ply.HWallrunUp = CurTime() + 0.5
        end
    end

    local trace = {
        start = ply:GetPos(),
        endpos = ply:GetPos(),
        filter = ply
    }

    local trhull = util.TraceHull({
        start = ply:GetPos(),
        endpos = ply:GetPos(),
        maxs = Vector(44, 44, 72),
        mins = Vector(-44, -44, 0),
        filter = ply
    })

    if ply.InHWallrun and (not trhull.Hit or ply:KeyPressed(IN_DUCK) or ply.HWallrunTimer < CurTime()) then
        ply.HWallrunDelay = CurTime() + 0.15
        ply.InHWallrun = false
        timer.Remove("wallrunhfoot")
        net.Start("HWallrunAng")
        net.WriteInt(-1, 2)
        net.Send(ply)
    end

    if ply.InHWallrun then
          local trfront = util.TraceLine({
                    start = ply:EyePos() - Vector(0, 0, 20),
                    endpos = ply:EyePos() + Angle(0, ply:EyeAngles().y, 0):Forward() * 20 - Vector(0, 0, 40),
                    filter = ply
          })
          if trfront.Hit then
                    ply.HWallrunDelay = CurTime() + 0.15
                    net.Start("HWallrunAng")
                    net.WriteInt(-1, 2)
                    net.Send(ply)
                    ply.InHWallrun = false
                    timer.Remove("wallrunhfoot")
          end
        ply:SetLocalVelocity(ply.HWallrunLastWall * math.Clamp(300, 0, ply.HWallrunSpeed:Length()) + (Vector(0, 0, math.Clamp(ply.HWallrunUp - CurTime(), 0, 5) * 200)))

        if ply:KeyPressed(IN_JUMP) and ply.HWallrunTimer - CurTime() < 0.95 then
            ply.HWallrunDelay = CurTime() + 0.15
            net.Start("HWallrunAng")
            net.WriteInt(-1, 2)
            net.Send(ply)
            ply:SetLocalVelocity((ply:EyeAngles():Forward() * Vector(1, 1, 0)) * 350 + Vector(0, 0, 250))
            ply:EmitSound("mirrorsedge/ME_Footsteps_Congrete_Clean_WallRun_Slow_Faith" .. tostring(math.random(1, 7)) .. ".wav")
            ply.InHWallrun = false
            timer.Remove("wallrunhfoot")
        end
    end
end)