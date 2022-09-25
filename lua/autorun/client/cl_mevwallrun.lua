VWallrunning = false
VWallrunTimer = 0
local VWallrunningang = Angle(0, 0, 0)
local HWallrunAng = 0
local HWallrunEyeAng = 0
HWallrunning = false
HWallrunningdir = 0
local lastnetint = 0

local animtable = {
    AnimString = "verticalwallrun",
    animmodelstring = "mantleanim",
    usefullbody = 2,
    BodyAnimSpeed = 1.1,
    customlerp = 0.05,
    customlimit360 = false,
    deleteonend = false,
    customlimitdownclassic = true,
    ignorez = true
}

net.Receive("VWallrunStart", function(len)
    VWallrunningang = net.ReadAngle()
    animtable.customang = VWallrunningang.y

    if IsValid(VMLegs) then
        VMLegs:Remove()
        VMLegsPlayer:Remove()
    end

    StartBodyAnim(animtable)
    --LocalPlayer():ConCommand("startbodyanim verticalwallrun 1 mantleanim 0 0 1.1 "..tostring(VWallrunningang.y).." 0.05")
    VWallrunning = true
    VWallrunTimer = CurTime() + 0.1
end)

hook.Add("Think", "VWallrunThink", function()
    local ply = LocalPlayer()

    if IsValid(BodyAnim) and VWallrunning then
        BodyAnim:SetPos(ply:GetPos())

        if VWallrunTimer < CurTime() and not inmantle then
            BodyAnimSpeed = math.Clamp(BodyAnimSpeed - (0.0065), 0.05, 1)
        end
    end

    --[[elseif not IsValid(BodyAnim) and VWallrunning then
        local activewep = ply:GetActiveWeapon()
        local usingrh

        if IsValid(activewep) then
            usingrh = activewep:GetClass() == "runnerhands"
        end

        if usingrh then
            if activewep:GetSequence() ~= 1 then
                activewep:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
            end
        end]]
end)

net.Receive("VWallrunEnd", function(len)
    local ply = LocalPlayer()
    RemoveBodyAnim()
    VWallrunning = false

    
    --[[local activewep = ply:GetActiveWeapon()
    local usingrh

    if IsValid(activewep) then
        usingrh = activewep:GetClass() == "runnerhands"
    end

    if usingrh then
        if activewep:GetSequence() ~= 1 then
            activewep:SendWeaponAnim(ACT_VM_HITCENTER)
        end
    end]]
end)

hook.Add("Think", "HWallrunThink", function()
    local ply = LocalPlayer()

    if not IsValid(BodyAnim) and HWallrunning then
        if lastnetint == -1 then
            HWallrunEyeAng = Lerp(RealFrameTime()*8, HWallrunEyeAng, HWallrunAng)
        else
            HWallrunEyeAng = Lerp(RealFrameTime()*4, HWallrunEyeAng, HWallrunAng)
        end

        local eyeang = ply:EyeAngles()
        ply:SetEyeAngles(Angle(eyeang.x, eyeang.y, HWallrunEyeAng))

        if math.abs(ply:EyeAngles().z) < 0.0001 and lastnetint == -1 then
            HWallrunning = false
        end
    end
end)

net.Receive("HWallrunAng", function(len)
    local ply = LocalPlayer()
    lastnetint = net.ReadInt(2)

    if lastnetint == 0 then
        HWallrunAng = -10
        LocalPlayer():SetEyeAngles(Angle(ply:EyeAngles().x, ply:EyeAngles().y, 0))
        HWallrunEyeAng = 0
        HWallrunning = true
    elseif lastnetint == 1 then
        HWallrunAng = 10
        HWallrunEyeAng = 0
        LocalPlayer():SetEyeAngles(Angle(ply:EyeAngles().x, ply:EyeAngles().y, 0))
        HWallrunning = true
    else
        HWallrunAng = 0
    end

    HWallrunningdir = lastnetint

    if VManip_Cycle ~= nil then
        if (lastnetint == -1 and VManip_Gestureonhold == true) or (lastnetint ~= -1) then
            LocalPlayer():ConCommand("VManip_DoAnim handslide")
        elseif (lastnetint == -1 and VManip_Gestureonhold == false and IsValid(VMGesture)) then
            VMGesture:Remove()
            VMGesture = nil
        end
    end
end)