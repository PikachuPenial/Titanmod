inmantle = false
MantleAimHelper = nil
local mantleangle = Angle(0, 0, 0)
local mantledidangle = false
local mantlefinish = false
local mantlepos = Vector(0, 0, 0)
local mantleent = nil
local mantleentpos = Vector(0, 0, 0)
local mantlelimit = false
local mantlespeed = 1
local firstforward = false
local inputforward = false
local inputback = false
local inputjump = false
mantlecool = 0 --externally used
mantletimer = 0
local mantlejumptimer = 0
local bodyanimlockcache = 0
local mantlemousecache = 0
local mantlelastang = Angle(0, 0, 0)
local mantleanglerp = Angle(0, 0, 0)
local mantlebonelerp = 1
local mEyepos = Vector(0, 0, 0)
local mEyeang = Angle(0, 0, 0)
local mantlestarttime = 0
local mantlebeepdelay = 0
local BAGestureMatrix

local apex_automantle = CreateConVar("cl_ae_automantle", 0, {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "self explanatory")
local apex_manualjump = CreateConVar("cl_ae_manualjumpmantle", 0, {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "self explanatory")
local apex_slowmantle = CreateConVar("cl_ae_slowmantle", 0, {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "self explanatory")
local apex_usebody = CreateConVar("cl_ae_usebody", 1, {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "use the body or use c_")
local apex_altsounds = CreateConVar("cl_ae_altmantlingsounds", 1, {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "use quieter mantling sounds")
local apex_mantle = CreateConVar("sv_ae_mantle", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "self explanatory")
local apex_mantleshort = CreateConVar("sv_ae_mantleshort", 0, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "allow mantling on thin ledges")
local apex_mantle_angleleniency = CreateConVar("sv_ae_angleleniency", 10, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "0 allows mantling only onto flat surfaces. Use to reduce chances of getting stuck")
local apex_vwallrun = CreateConVar("sv_ae_vwallrun", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "self explanatory")
local apex_hwallrun = CreateConVar("sv_ae_hwallrun", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "self explanatory")
local wallrun_lookatwall = CreateConVar("sv_ae_mustlookatwall", 0, {FCVAR_ARCHIVE}, "look at wall to wallrun")
local apex_mantlespeed = CreateConVar("sv_ae_mantlespeed", 1, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CLIENTCMD_CAN_EXECUTE}, "mantle speed")
local crazymode = CreateConVar("cl_ae_fun", 0, {FCVAR_CLIENTCMD_CAN_EXECUTE}, "fun")

local leftarmbones = {"ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Bicep", "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_L_Wrist", "ValveBiped.Bip01_L_Elbow", "ValveBiped.Bip01_L_Ulna", "ValveBiped.Bip01_L_Finger4", "ValveBiped.Bip01_L_Finger41", "ValveBiped.Bip01_L_Finger42", "ValveBiped.Bip01_L_Finger3", "ValveBiped.Bip01_L_Finger31", "ValveBiped.Bip01_L_Finger32", "ValveBiped.Bip01_L_Finger2", "ValveBiped.Bip01_L_Finger21", "ValveBiped.Bip01_L_Finger22", "ValveBiped.Bip01_L_Finger1", "ValveBiped.Bip01_L_Finger11", "ValveBiped.Bip01_L_Finger12", "ValveBiped.Bip01_L_Finger0", "ValveBiped.Bip01_L_Finger01", "ValveBiped.Bip01_L_Finger02"}
local rightarmbones = {"ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Bicep", "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_R_Elbow", "ValveBiped.Bip01_R_Ulna", "ValveBiped.Bip01_R_Finger4", "ValveBiped.Bip01_R_Finger41", "ValveBiped.Bip01_R_Finger42", "ValveBiped.Bip01_R_Finger3", "ValveBiped.Bip01_R_Finger31", "ValveBiped.Bip01_R_Finger32", "ValveBiped.Bip01_R_Finger2", "ValveBiped.Bip01_R_Finger21", "ValveBiped.Bip01_R_Finger22", "ValveBiped.Bip01_R_Finger1", "ValveBiped.Bip01_R_Finger11", "ValveBiped.Bip01_R_Finger12", "ValveBiped.Bip01_R_Finger0", "ValveBiped.Bip01_R_Finger01", "ValveBiped.Bip01_R_Finger02"}
local fingers = {"ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_L_Forearm",}

local BodyAnimLockDirection = 2
local mantlenetdelay = 0

net.Receive("MantleInterrupt", function(len)
    if inmantle and IsValid(BodyAnim) then
        RemoveBodyAnim()
        mantlefinish = false
        inmantle = false
    end
end)

local function MantleInit(nang, nent, npos)
    local ply = LocalPlayer()

    local trledge = util.TraceLine({
        start = ply:EyePos() + Angle(0, ply:EyeAngles().y, 0):Forward() * 0 + Vector(0, 0, 10),
        endpos = ply:EyePos() + Angle(0, ply:EyeAngles().y, 0):Forward() * 35 + Vector(0, 0, 70),
        filter = ply
    })

    local pos = ply:EyePos() + Angle(0, ply:EyeAngles().y, 0):Forward() * 35 + Vector(0, 0, 25)

    local trhull = util.TraceHull({
        start = pos,
        endpos = pos,
        mins = Vector(-16, -16, 0),
        maxs = Vector(16, 16, 71),
        filter = ply
    })

    if apex_altsounds:GetBool() then
        ply:EmitSound("mantle/handstep" .. tostring(math.random(1, 4)) .. ".wav", 43 + math.random(-2, 2))
    else
        ply:EmitSound("mantle/mantle_lowmantle.wav")
    end

    mantlestarttime = CurTime()
    mantlebeepdelay = mantlestarttime + 0.25
    mantleangle = nang
    mEyepos = ply:EyePos()
    mEyeang = ply:EyeAngles()
    VWallrunning = false
    RemoveBodyAnim()
    local usebody = apex_usebody:GetBool() and 2 or 0
    mantleent = nent
    mantleentpos = mantleent:GetPos()
    ply:SetPos(npos)

    if mantleent:IsWorld() then
        mantleent = nil
    end

    mantlespeed = apex_mantlespeed:GetFloat()
    mantlejumptimer = CurTime() + 0.25

    local mantletable = {
        AnimString = "mantlemain",
        BodyAnimSmoothAng = 1,
        animmodelstring = "mantleanim",
        usefullbody = usebody,
        BodyAnimSpeed = mantlespeed,
        customlimithor = 1,
        customlimitdown = 0,
        customlimitup = 5,
        customlimitdownclassic = true,
        customlimit360 = true,
        followplayer = false,
        deleteonend = false,
          allowmove = true,
        ignorez = true
    }

    if apex_automantle:GetBool() and not trledge.Hit and not trhull.Hit then
        --ply:ConCommand("startbodyanim mantlemain 1 mantleanim "..tostring(usebody).." 0 "..tostring(mantlespeed))
        StartBodyAnim(mantletable)
        mantlelimit = false
    else
        --ply:ConCommand("startbodyanim mantlestart 1 mantleanim "..tostring(usebody).." 0 "..tostring(mantlespeed))
        mantletable.AnimString = "mantlestart"
        StartBodyAnim(mantletable)
        mantlelimit = true
    end

    inmantle = true
    mantledidangle = false
    mantlefinish = false
    mantlepos = ply:GetPos()
    firstforward = true
    MantleAimHelper = ClientsideModel("models/mantleanim.mdl", RENDERGROUP_BOTH)
    MantleAimHelper:SetAngles(Angle(0, ply:EyeAngles().y, 0))
    MantleAimHelper:SetPos(ply:GetPos())
    MantleAimHelper:SetSequence(ACT_VM_MISSRIGHT)
    MantleAimHelper:SetupBones()
end

local function MantleCheck()
    local ply = LocalPlayer()
    local movetype = ply:GetMoveType()
    local eyeang = ply:EyeAngles()
    if not apex_mantle:GetBool() or movetype == MOVETYPE_LADDER or movetype == MOVETYPE_NOCLIP or inmantle or (ply:GetVelocity().z >= 10 and not VWallrunning) or ply:Crouching() or ply:OnGround() or not ply:Alive() or not ply:KeyDown(IN_FORWARD) or mantlenetdelay > CurTime() then return end
    local trfront, trledge

    if not inmantle then
        trfront = util.TraceLine({
            start = ply:EyePos() - Vector(0, 0, 20),
            endpos = ply:EyePos() + Angle(0, ply:EyeAngles().y, 0):Forward() * 35 - Vector(0, 0, 20),
            filter = ply
        })

        trledge = util.TraceLine({
            start = ply:EyePos() + Angle(0, ply:EyeAngles().y, 0):Forward() * 24 + Vector(0, 0, 50),
            endpos = ply:EyePos() + Angle(0, ply:EyeAngles().y, 0):Forward() * 24 - Vector(0, 0, 50),
            filter = ply
        })
    end

    --ply:ChatPrint(tostring(trledge.Fraction).." | "..tostring(trledge.Hit).." | "..tostring(trfront.Hit))
    if not trfront.Hit and apex_mantleshort:GetBool() then
        trfront.Entity = trledge.Entity
        trfront.HitNormal = Angle(0, eyeang.y, 0):Forward() * -1
    end

    if (trfront.Hit or apex_mantleshort:GetBool()) and not trfront.Entity:IsNPC() and not trfront.Entity:IsPlayer() and not trfront.HitSky and not trledge.HitSky and trledge.Hit and trledge.Fraction < 0.56 and trledge.Fraction > 0.52 and trledge.HitNormal:DistToSqr(Vector(0, 0, 1)) * 10 <= apex_mantle_angleleniency:GetFloat() then
        local ang = trfront.HitNormal:Angle() - Angle(0, 180, 0)
        local ent = trfront.Entity
        local pos = ply:GetPos()
        mantlenetdelay = CurTime() + 0.1
        MantleInit(ang, ent, pos)
        net.Start("MantleRequest")
        net.WriteAngle(ang)
        net.WriteEntity(ent)
        net.WriteVector(pos)
        net.SendToServer()
    end
end

net.Receive("MantleStart", function()
    if inmantle then return end
    local ang = net.ReadAngle()
    local ent = net.ReadEntity()
    local pos = net.ReadVector()
    MantleInit(ang, ent, pos)
end)

hook.Add("InputMouseApply", "ApexMantleInputMouse", function(cmd, x, y, ang)
    if not inmantle or not IsValid(BodyAnim) then return end
    local ply = LocalPlayer()
    local vecang = Angle(0, 0, 0)
    local vecplyang = Angle(0, 0, 0)
    local vecangf = Vector(0, 0, 0)
    local savedeyeangb = Angle(0, BodyAnimEyeAng.y, 0)
    vecang = cmd:GetViewAngles() + BodyAnimEyeAng
    vecang = Angle(vecang.x * 1, vecang.y, 0)
    vecplyang = cmd:GetViewAngles()
    vecangf = vecang:Forward() * Vector(1, 1, 0)
    vecangdistf = vecangf:DistToSqr(savedeyeangb:Forward())
    vecangdistr = vecangf:DistToSqr(savedeyeangb:Right())

    if CurTime() - 0.1 > mantlestarttime and BodyAnimLockDirection == 2 and mantlemousecache ~= 2 then
        ply:EmitSound("mantle/handstep" .. tostring(math.random(1, 4)) .. ".wav", 43)
    end

    mantlemousecache = BodyAnimLockDirection

    if vecangdistf > 0.3 then
        if vecangdistr < 2 then
            BodyAnimLockDirection = 1
        elseif vecangdistr > 2 then
            BodyAnimLockDirection = 0
        end
    else
        BodyAnimLockDirection = 2
    end

    if vecangdistf > 1 and BodyAnimLockDirection ~= mantlemousecache and BodyAnimLockDirection ~= 2 then
        cmd:SetViewAngles(mantlelastang - Angle(0, x / math.pi * 0.001, 0))
        cmd:SetMouseX(0)
        BodyAnimLockDirection = mantlemousecache

        return true
    else
        mantlelastang = cmd:GetViewAngles()
    end
end)

hook.Add("CreateMove", "ApexMantleInput", function(cmd)
    inputforward = cmd:KeyDown(IN_FORWARD)
    inputback = cmd:KeyDown(IN_BACK)
    inputjump = cmd:KeyDown(IN_JUMP)
end)

hook.Add("Think", "ApexMantleThink", function()
    local ply = LocalPlayer()
    local IsValidBA = IsValid(BodyAnim)

    if not inmantle and IsValid(MantleAimHelper) then
        MantleAimHelper:Remove()
    end

    if not inmantle then
        MantleCheck()
        return
    end

    local mantletype = 1
    if apex_slowmantle:GetBool() then
        mantletype = 5
    end

    if IsValid(MantleAimHelper) and IsValidBA then
        local aimseq = tobool(BodyAnimLockDirection) and "mantleaimright" or "mantleaimleft"

        if BodyAnimLockDirection == 2 or BodyAnim:GetSequence() == 1 then
            aimseq = "mantleidle"
        end

        --if (BodyAnimLockDirection!=mantlemousecache or BodyAnimLockDirection!=bodyanimlockcache) and BodyAnimLockDirection!=2 then ply:EmitSound("mantle/Fol_Sprint_Rustle_0"..tostring(math.random(1,5))..".wav") end
        MantleAimHelper:SetSequence(aimseq)

        if BodyAnimLockDirection == 2 then
            mantlebonelerp = math.Clamp(mantlebonelerp + FrameTime() * 6, 0, 1)
            mantleanglerp = LerpAngle(0.075, mantleanglerp, BodyAnim:GetAngles())
            MantleAimHelper:SetAngles(mantleanglerp)
            BodyAnimMDL:SetParent(BodyAnim)
        else
            mantleanglerp = LerpAngle(0.075, mantleanglerp, Angle(-math.abs(ply:EyeAngles().x * 0.3), mantleangle.y + ply:EyeAngles().y, 0))
            MantleAimHelper:SetAngles(mantleanglerp)
            MantleAimHelper:SetPos(ply:GetPos())
            mantlebonelerp = math.Clamp(mantlebonelerp - FrameTime() * 6.5, 0, 1)

            if IsValid(BodyAnimMDLarm) then
                if not ply:ShouldDrawLocalPlayer() then
                    BodyAnimMDL:SetParent(nil)
                    BodyAnimMDL:SetPos(ply:GetPos() - Vector(0, 0, 10000))
                end
            end
        end

        if BodyAnimLockDirection ~= 2 then
            bodyanimlockcache = BodyAnimLockDirection
        end

        MantleAimHelper:FrameAdvance()
    end

    if not ply:Alive() and inmantle then
        inmantle = false
    end

    if inmantle and not mantledidangle then
        if IsValidBA then
            BodyAnim:SetAngles(mantleangle)
            mantledidangle = true
        end
    end

    local trledge = util.TraceLine({
        start = mEyepos + Angle(0, mEyeang.y, 0):Forward() * 0 + Vector(0, 0, 10),
        endpos = mEyepos + Angle(0, mEyeang.y, 0):Forward() * 35 + Vector(0, 0, 70),
        filter = ply
    })

    local pos = ply:EyePos() + Angle(0, mantleangle.y, 0):Forward() * 35 + Vector(0, 0, 25)

    local trhull = util.TraceHull({
        start = pos,
        endpos = pos,
        mins = Vector(-16, -16, 0),
        maxs = Vector(26, 26, 71),
        filter = ply,
        ignoreworld = false
    })

    if inmantle and IsValidBA then
        local facingwall = BodyAnimLockDirection == 2
        local altsounds = apex_altsounds:GetBool()
        local BodyAnimSequence = BodyAnim:GetSequence()
        local manualjump = not apex_manualjump:GetBool() and inputjump

        if game.SinglePlayer() then
            inputforward = ply:KeyPressed(IN_FORWARD)
            inputback = ply:KeyPressed(IN_BACK)
            inputjump = ply:KeyPressed(IN_JUMP)
        end

        if IsValid(mantleent) and mantleent:GetPos() ~= mantleentpos then
            BodyAnim:SetPos(ply:GetPos())
            mantleentpos = mantleent:GetPos()
        end

        if BodyAnimSequence == 3 then
            BodyAnimCycle = 0
            BodyAnim:SetSequence(0)
        end

        if not inputforward then
            firstforward = false
        end

        --fuck off with the spacespamming
        if (inputforward or manualjump) and facingwall and BodyAnimSequence == 0 and mantlelimit and not firstforward and not trledge.Hit and not trhull.Hit then
            if altsounds then
                ply:EmitSound("mantle/mantlealt" .. tostring(math.random(1, 2)) .. ".wav")
            else
                ply:EmitSound("mantle/mantle_extralow.wav")
            end
        elseif (inputforward or manualjump) and BodyAnimSequence == 0 and CurTime() > mantlebeepdelay and facingwall and (trledge.Hit or trhull.Hit) then
            mantlebeepdelay = CurTime() + 0.5
            ply:EmitSound("common/wpn_denyselect.wav", 43)
        end

        if (not inputforward or trledge.Hit or trhull.Hit) and BodyAnimSequence == mantletype and BodyAnimCycle < 0.5 and not mantlelimit then
            BodyAnim:SetSequence(0)
            mantlelimit = true
        elseif (inputforward or manualjump) and facingwall and not firstforward and not trledge.Hit and not trhull.Hit and BodyAnimSequence == 0 then
            BodyAnimCycle = 0
            BodyAnim:SetSequence(mantletype)
        elseif inputback and BodyAnimSequence == 0 then
            BodyAnimCycle = 0
            BodyAnim:SetSequence(2)
        elseif inputjump and CurTime() > mantlejumptimer and BodyAnimSequence == 0 then
            if facingwall then
                local jumpseq = BodyAnim:GetSequenceName(BodyAnim:LookupSequence("mantleup"))
                BodyAnimCycle = 0
                BodyAnim:SetSequence(jumpseq)
                mantlenetdelay = CurTime() + 0.45

                timer.Simple(BodyAnim:SequenceDuration(jumpseq) - 0.0375, function()
                    RemoveBodyAnim()
                    MantleAimHelper:Remove()
                    net.Start("MantleJump")
                    net.WriteBool(facingwall)
                    net.WriteAngle(ply:EyeAngles())
                    net.SendToServer()
                    inmantle = false
                end)
            else
                RemoveBodyAnim()
                MantleAimHelper:Remove()
                net.Start("MantleJump")
                net.WriteBool(facingwall)
                net.WriteAngle(ply:EyeAngles())
                net.SendToServer()
                inmantle = false
            end
        end

        if (BodyAnimCycle >= 0.5 and BodyAnimSequence == 1) or (BodyAnimCycle >= 0.8 and BodyAnimSequence == 2) or (BodyAnimCycle >= 0.8 and BodyAnimSequence == 5) then
            BodyAnimMDL:SetParent(nil)
            BodyAnimMDL:SetPos(ply:GetPos() - Vector(0, 0, 1000))
        end

        if BodyAnimCycle >= 0.95 and BodyAnimSequence == mantletype and not mantlefinish then
            local attachId = BodyAnim:LookupAttachment("eyes")
            local attach = BodyAnim:GetAttachment(attachId)
            BodyAnimMDL:SetNoDraw(true)
            net.Start("MantleEnd")
            net.WriteVector(attach.Pos)
            net.WriteBool(false)
            net.SendToServer()
            --ply:SetPos(EyePos()-Vector(0,0,64))
            mantlefinish = true
            mantlecool = CurTime() + 0.25
            mantlepos = attach.Pos - Vector(0, 0, 64)
            mantletimer = CurTime() + (game.SinglePlayer() and 0.03 or (0.05 + ply:Ping() / 750))
        elseif BodyAnimCycle >= 0.6 and BodyAnimSequence == 2 and not mantlefinish then
            local attachId = BodyAnim:LookupAttachment("eyes")
            local attach = BodyAnim:GetAttachment(attachId)
            BodyAnimMDL:SetNoDraw(true)
            net.Start("MantleEnd")
            net.WriteVector(attach.Pos)
            net.WriteBool(true)
            net.SendToServer()
            --ply:SetPos(EyePos()-Vector(0,0,64))
            mantlefinish = true
            mantlecool = CurTime() + 0.25
            mantlepos = attach.Pos - Vector(0, 0, 64)
            mantletimer = CurTime()
        end

        if inmantle and mantlefinish and ply:GetPos() ~= mantlepos then
            --if !IsValid(BodyAnim) then ply:SetEyeAngles(bodyanimlastattachang) end
            if CurTime() > mantletimer then
                BodyAnimMDL:SetNoDraw(true)
                RemoveBodyAnim()
                mantlefinish = false
                inmantle = false
            end
        end
    end
end)

hook.Add("NeedsDepthPass", "ApexMantleAim", function()
    -- if IsValid(MantleAimHelper) then
    -- print("==INIT==")
    -- for i=0, MantleAimHelper:GetBoneCount()-1 do
    -- print( i, MantleAimHelper:GetBoneName( i ) )
    -- end
    -- print("==END==")
    -- end
    --==========================
    if IsValid(BodyAnim) and IsValid(MantleAimHelper) and not (BodyAnim:GetSequence() == 1 and BodyAnimCycle > 0.5) and BodyAnim:GetSequenceName(BodyAnim:GetSequence()) ~= "mantlestart" then
        MantleAimHelper:SetupBones()
        local rigpick = tobool(bodyanimlockcache) and rightarmbones or leftarmbones

        for k, v in pairs(rigpick) do
            BAGestureMatrix = MantleAimHelper:GetBoneMatrix(MantleAimHelper:LookupBone(rigpick[k]))
            local BABone = BodyAnim:LookupBone(v)

            if BABone ~= nil then
                local BABoneMatrix = BodyAnim:GetBoneMatrix(BABone)
                local BABoneMatrixCache = BABoneMatrix:ToTable()
                local BAGestureMatrixCache = BAGestureMatrix:ToTable()

                for k, v in pairs(BAGestureMatrixCache) do
                    for l, b in pairs(v) do
                        BAGestureMatrixCache[k][l] = Lerp(mantlebonelerp, b, BABoneMatrixCache[k][l])
                    end
                end

                BodyAnim:SetBoneMatrix(BABone, Matrix(BAGestureMatrixCache))
            end

            if crazymode:GetBool() and BABone ~= nil then
                MantleAimHelper:ManipulateBoneJiggle(BABone, 1)
            end
        end

        BodyAnimMDL:SetupBones()

        if IsValid(BodyAnimMDLarm) then
            BodyAnimMDLarm:SetupBones()
        end
    end
end)

--==========================
hook.Add("PopulateToolMenu", "MantlingMenu", function()
    spawnmenu.AddToolMenuOption("Options", "Mantling", "MantlingMenuServer", "Server", "", "", function(panel)
        panel:ClearControls()

        panel:AddControl("Header", {
            Description = "Serverside/Admin Mantling Settings\nby areV and datæ\n"
        })

        panel:AddControl("Checkbox", {
            Label = "Mantling",
            Command = "sv_ae_mantle"
        })

        panel:AddControl("Checkbox", {
            Label = "Wallrunning (Vertical)",
            Command = "sv_ae_vwallrun"
        })

        panel:AddControl("Checkbox", {
            Label = "Wallrunning (Horizontal)",
            Command = "sv_ae_hwallrun"
        })

        panel:AddControl("Checkbox", {
            Label = "↳ Must look at wall",
            Command = "sv_ae_mustlookatwall"
        })

        panel:AddControl("Slider", {
            Label = "Angle Leniency",
            Command = "sv_ae_angleleniency",
            Min = 0,
            Max = 100
        })

        panel:AddControl("Slider", {
            Label = "Mantling Speed",
            Command = "sv_ae_mantlespeed",
            Type = "float",
            Min = 0.1,
            Max = 2
        })

        panel:AddControl("Checkbox", {
            Label = "Mantle short walls",
            Command = "sv_ae_mantleshort"
        })

        panel:AddControl("Label", {
            Text = "Angle Leniency determines the max steepness allowed for mantling\n10 is the default, 0 allows only flat surfaces\n\nMantle short walls will let you grab onto ledges with no support below them, e.g where your legs would float"
        })
    end)

    spawnmenu.AddToolMenuOption("Options", "Mantling", "MantlingMenuClient", "Client", "", "", function(panel)
        panel:ClearControls()

        panel:AddControl("Header", {
            Description = "Clientside Mantling Settings\nby areV and datæ\n"
        })

        panel:AddControl("Checkbox", {
            Label = "Full Body",
            Command = "cl_ae_usebody"
        })

        panel:AddControl("Checkbox", {
            Label = "Alternate Sounds",
            Command = "cl_ae_altmantlingsounds"
        })

        panel:AddControl("Checkbox", {
            Label = "Manual Jump",
            Command = "cl_ae_manualjumpmantle"
        })
    end)
end)