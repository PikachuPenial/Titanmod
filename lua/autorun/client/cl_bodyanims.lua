local playermodelbones = {"ValveBiped.Bip01_R_Clavicle", "ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_L_Clavicle", "ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_L_Wrist", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_L_Finger4", "ValveBiped.Bip01_L_Finger41", "ValveBiped.Bip01_L_Finger42", "ValveBiped.Bip01_L_Finger3", "ValveBiped.Bip01_L_Finger31", "ValveBiped.Bip01_L_Finger32", "ValveBiped.Bip01_L_Finger2", "ValveBiped.Bip01_L_Finger21", "ValveBiped.Bip01_L_Finger22", "ValveBiped.Bip01_L_Finger1", "ValveBiped.Bip01_L_Finger11", "ValveBiped.Bip01_L_Finger12", "ValveBiped.Bip01_L_Finger0", "ValveBiped.Bip01_L_Finger01", "ValveBiped.Bip01_L_Finger02", "ValveBiped.Bip01_R_Finger4", "ValveBiped.Bip01_R_Finger41", "ValveBiped.Bip01_R_Finger42", "ValveBiped.Bip01_R_Finger3", "ValveBiped.Bip01_R_Finger31", "ValveBiped.Bip01_R_Finger32", "ValveBiped.Bip01_R_Finger2", "ValveBiped.Bip01_R_Finger21", "ValveBiped.Bip01_R_Finger22", "ValveBiped.Bip01_R_Finger1", "ValveBiped.Bip01_R_Finger11", "ValveBiped.Bip01_R_Finger12", "ValveBiped.Bip01_R_Finger0", "ValveBiped.Bip01_R_Finger01", "ValveBiped.Bip01_R_Finger02"}

BodyAnim = nil
BodyAnimMDL = nil
BodyAnimMDLarm = nil
BodyAnimWEPMDL = nil
BodyAnimCycle = 0
BodyAnimEyeAng = Angle(0, 0, 0)
local BodyAnimPos = Vector(0, 0, 0)
local BodyAnimSmoothAng = false
local BodyAnimAngLerp = Angle(0, 0, 0)
local BodyAnimAngLerpM = Angle(0, 0, 0)
local DidDraw = false
local FOVLerp = 0
local FOVLerp2 = 0
local AnimString = "nil"
BodyAnimString = "nil"
local angclosenuff = false
local savedeyeangb = Angle(0, 0, 0)
local bodylockview = false
local bodyanimdone = false
local holstertime = 0
local animmodelstring = ""
local showweapon = false
local usefullbody = false
local followplayer = true
local deleteonend = true
local customlimitup = 0
local customlimitdown = 0
local customlimithor = 0
local customlimit360 = false
local customlimitdownclassic = false
local lockang = false
local ignorez = false
local customcycle = false
local deathanim = false
local allowmove = false
local allowedangchange = false
BodyAnimSpeed = 1
BodyAnimFollow = false
BodyAnimLockDirection = 0 --0 left, 1 right, 2 none
local attach = nil
local attachId = nil
bodyanimlastattachang = Angle(0, 0, 0)
local weapontoidle = nil
local enhancedcameraconvar = "check"
local ecenabled = false

function RemoveBodyAnim(noang)
    local ply = LocalPlayer()
    local ang = ply:EyeAngles()
    local newang = ply:EyeAngles()
    local whydoineedtodothis = 0.001
    local noang = noang or false

    if allowedangchange then
        newang = ang + BodyAnimEyeAng
    else
        newang = BodyAnimEyeAng
    end

    if IsValid(BodyAnim) then
        BodyAnim:SetNoDraw(true)

        if IsValid(BodyAnimMDL) then
            BodyAnimMDL:SetNoDraw(true)

            if BodyAnimMDL.callback ~= nil then
                BodyAnimMDL:RemoveCallback("BuildBonePositions", BodyAnimMDL.callback)
            end

            BodyAnimMDL:Remove()
        end

        if IsValid(BodyAnimMDLarm) then
            BodyAnimMDLarm:Remove()
        end

        if IsValid(BodyAnimWEPMDL) then
            BodyAnimWEPMDL:Remove()
        end

        BodyAnim:Remove()
        ply:DrawViewModel(true)
        DidDraw = false

        if not noang then
            ply:SetEyeAngles(Angle(newang.x, newang.y, 0))
        end
        --timer.Simple(whydoineedtodothis,function() ply:SetEyeAngles( Angle(newang.x,newang.y,0)) end) --what the fuckk
    end

    local currentwep = ply:GetActiveWeapon()
    local vm = ply:GetViewModel()

    if IsValid(currentwep) then
        weapontoidle = currentwep
        currentwep:SendWeaponAnim(ACT_VM_DRAW)

        timer.Simple(vm:SequenceDuration(vm:SelectWeightedSequence(ACT_VM_DRAW)), function()
            if ply:GetActiveWeapon() == weapontoidle and weapontoidle:GetSequenceActivityName(weapontoidle:GetSequence()) == "ACT_VM_DRAW" then
                weapontoidle:GetSequenceActivityName(weapontoidle:GetSequence())
                weapontoidle:SendWeaponAnim(ACT_VM_IDLE)
            end
        end)
    end
end

function StartBodyAnim(animtable)
    local ply = LocalPlayer()
    AnimString = animtable.AnimString
    BodyAnimString = AnimString
    BodyAnimSmoothAng = animtable.BodyAnimSmoothAng or true
    animmodelstring = animtable.animmodelstring
    usefullbody = animtable.usefullbody or 2
    showweapon = animtable.showweapon or false
    BodyAnimSpeed = animtable.BodyAnimSpeed or 1
    customang = animtable.customang or "nil"
    customlerp = animtable.customlerp or 0.1
    FOVLerp = animtable.FOVLerp or 0
    customlimitdown = animtable.customlimitdown or 0
    customlimitup = animtable.customlimitup or 0
    customlimit360 = animtable.customlimit360 or false
    customlimithor = animtable.customlimithor or 0
    customlimitdownclassic = animtable.customlimitdownclassic or false
    deleteonend = animtable.deleteonend
    followplayer = animtable.followplayer or false
    lockang = animtable.lockang or false
    allowmove = animtable.allowmove or false
    ignorez = animtable.ignorez or false
    deathanim = animtable.deathanim or false
    customcycle = animtable.customcycle or false

    if deleteonend == nil then
        deleteonend = true
    end

    if followplayer == nil then
        followplayer = true
    end

    BodyAnimAngLerp = ply:EyeAngles()
    if AnimString == nil or (not ply:Alive() and not deathanim) then return end
    --if IsValid(BodyAnimMDL) then RemoveBodyAnim(LocalPlayer():EyeAngles()) return end
    BodyAnimAngLerpM = ply:EyeAngles()
    ply:SetEyeAngles(Angle(0, BodyAnimAngLerpM.y, 0))
    savedeyeangb = Angle(0, 0, 0)
    BodyAnim = ClientsideModel("models/" .. tostring(animmodelstring) .. ".mdl", RENDERGROUP_BOTH)

    if customang == "nil" then
        BodyAnim:SetAngles(Angle(0, ply:EyeAngles().y, 0))
    else
        BodyAnim:SetAngles(Angle(0, customang, 0))
    end

    BodyAnim:SetPos(ply:GetPos())
    --BodyAnim:SetParent(ply)
    BodyAnim:SetNoDraw(false)
    local plymodel = ply
    local playermodel = string.Replace(ply:GetModel(), "models/models/", "models/")
    local handsmodel = string.Replace(ply:GetHands():GetModel(), "models/models/", "models/")

    if not util.IsValidModel(playermodel) then
        local modelpath = ply:GetPData(playermodel, 0)

        if modelpath ~= 0 then
            playermodel = modelpath
        else
            chat.PlaySound()
            chat.AddText(Color(255, 0, 0), "Your playermodel has a misconfigured path, use another, or follow this guide\nhttps://pastebin.com/hgNqSEcG")
        end
    end

    if not util.IsValidModel(handsmodel) then
        local modelpath = ply:GetPData(handsmodel, 0)

        if modelpath ~= 0 then
            handsmodel = modelpath
        else
            chat.PlaySound()
            chat.AddText(Color(255, 0, 0), "Your playermodel has a misconfigured path (hands), use another, or follow this guide\nhttps://pastebin.com/hgNqSEcG")
        end
    end

    if usefullbody == 2 then
        BodyAnimMDL = ClientsideModel(playermodel, RENDERGROUP_BOTH)
        BodyAnimMDL.GetPlayerColor = ply:GetHands().GetPlayerColor
        BodyAnimMDL:SnatchModelInstance(ply)
        BodyAnimMDLarm = ClientsideModel(handsmodel, RENDERGROUP_BOTH)
        BodyAnimMDLarm.GetPlayerColor = ply:GetHands().GetPlayerColor
        BodyAnimMDLarm:SetLocalPos(Vector(0, 0, 0))
        BodyAnimMDLarm:SetLocalAngles(Angle(0, 0, 0))
        BodyAnimMDLarm:SetParent(BodyAnim)
        BodyAnimMDLarm:AddEffects(EF_BONEMERGE)

        for num, _ in pairs(ply:GetHands():GetBodyGroups()) do
            BodyAnimMDLarm:SetBodygroup(num - 1, ply:GetHands():GetBodygroup(num - 1))
            BodyAnimMDLarm:SetSkin(ply:GetHands():GetSkin())
        end

        BodyAnimMDL.callback = BodyAnimMDL:AddCallback("BuildBonePositions", function(ent, numbones)
            if IsValid(BodyAnimMDL) then
                for k, v in pairs(playermodelbones) do
                    local plybone = BodyAnimMDL:LookupBone(v)

                    if plybone ~= nil then
                        local mat = BodyAnimMDL:GetBoneMatrix(plybone)

                        if mat ~= nil then
                            mat:Scale(Vector(0, 0, 0))
                            BodyAnimMDL:SetBoneMatrix(plybone, mat)
                        end
                    end
                end
            end
        end)
    elseif usefullbody == 1 then
        BodyAnimMDL = ClientsideModel(playermodel, RENDERGROUP_BOTH)
    else
        BodyAnimMDL = ClientsideModel(string.Replace(handsmodel, "models/models/", "models/"), RENDERGROUP_BOTH)
        BodyAnimMDL.GetPlayerColor = ply:GetHands().GetPlayerColor
        plymodel = ply:GetHands()
    end

    for num, _ in pairs(plymodel:GetBodyGroups()) do
        BodyAnimMDL:SetBodygroup(num - 1, plymodel:GetBodygroup(num - 1))
        BodyAnimMDL:SetSkin(plymodel:GetSkin())
    end

    BodyAnimMDL:SetLocalPos(Vector(0, 0, 0))
    BodyAnimMDL:SetLocalAngles(Angle(0, 0, 0))
    BodyAnimMDL:SetParent(BodyAnim)
    BodyAnimMDL:AddEffects(EF_BONEMERGE)
    BodyAnim:SetSequence(AnimString)

    if tobool(showweapon) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetModel() ~= "" then
        BodyAnimWEPMDL = ClientsideModel(ply:GetActiveWeapon():GetModel(), RENDERGROUP_BOTH)
        BodyAnimWEPMDL:SetPos(ply:GetPos())
        BodyAnimWEPMDL:SetAngles(Angle(0, EyeAngles().y, 0))
        BodyAnimWEPMDL:SetParent(BodyAnim)
        BodyAnimWEPMDL:AddEffects(EF_BONEMERGE)
    end

    if BodyAnimMDL:LookupBone("ValveBiped.Bip01_Head1") ~= nil and not ply:ShouldDrawLocalPlayer() then
        BodyAnimMDL:ManipulateBoneScale(BodyAnimMDL:LookupBone("ValveBiped.Bip01_Head1"), Vector(0, 0, 0))
    end

    ply:DrawViewModel(false)
    BodyAnimCycle = 0
    DidDraw = false
    FOVLerp2 = 0
    angclosenuff = false
    bodyanimdone = false
end

concommand.Add("StartBodyAnim", function(ply, cmd, args)
    local animtable = {}
    animtable.AnimString = tostring(args[1])
    animtable.BodyAnimSmoothAng = args[2] or false
    animtable.animmodelstring = args[3] or "bagbodyanim"
    animtable.usefullbody = args[4] or 0
    animtable.showweapon = args[5] or false
    animtable.BodyAnimSpeed = args[6] or 1
    animtable.customang = args[7] or "nil"
    animtable.customlerp = args[8] or 0.1
    animtable.FOVLerp = tonumber(args[9]) or 0
    StartBodyAnim(animtable)
end)

concommand.Add("BodyAnim_RegisterPlayermodel", function(ply, cmd, args)
    local playermodel = ply:GetModel()
    local modelpath = args[1] or playermodel
    local isvalidply = util.IsValidModel(playermodel)
    local isvalidcustom = util.IsValidModel(modelpath)

    if modelpath ~= playermodel and isvalidcustom and not isvalidply then
        ply:SetPData(playermodel, modelpath)
        print("BodyAnim will now use " .. modelpath .. " instead of " .. playermodel)
    elseif isvalidply then
        print("ERROR: " .. playermodel .. " is already correct. Aborting")
    elseif not isvalidcustom then
        print("ERROR: " .. modelpath .. " is not a valid model")
    end
end)

concommand.Add("BodyAnim_RegisterPlayerhands", function(ply, cmd, args)
    local handsmodel = ply:GetHands():GetModel()
    local modelpath = args[1] or handsmodel
    local isvalidhands = util.IsValidModel(handsmodel)
    local isvalidcustom = util.IsValidModel(modelpath)

    if modelpath ~= handsmodel and isvalidcustom and not isvalidhands then
        ply:SetPData(handsmodel, modelpath)
        print("BodyAnim will now use " .. modelpath .. " instead of " .. handsmodel .. " (hands)")
    elseif isvalidhands then
        print("ERROR: " .. handsmodel .. " is already correct. Aborting")
    elseif not isvalidcustom then
        print("ERROR: " .. modelpath .. " is not a valid model")
    end
end)

hook.Add("Think", "BodyAnimThink", function()
    local ply = LocalPlayer()

    if enhancedcameraconvar == "check" then
        enhancedcameraconvar = GetConVar("cl_ec_enabled")
    end

    if (not ply:Alive() and not deathanim) and IsValid(BodyAnim) then
        RemoveBodyAnim()

        return
    end

    if not IsValid(BodyAnimMDL) or not IsValid(BodyAnim) then
        if enhancedcameraconvar ~= "check" and enhancedcameraconvar then
            if ecenabled and not enhancedcameraconvar:GetBool() then
                enhancedcameraconvar:SetBool(true)
                ecenabled = false
            end
        end

        return
    end

    if enhancedcameraconvar ~= "check" and enhancedcameraconvar then
        if enhancedcameraconvar:GetBool() then
            enhancedcameraconvar:SetBool(false)
            ecenabled = true
        end
    end

    if not bodyanimdone then
        BodyAnimCycle = BodyAnimCycle + FrameTime() / BodyAnim:SequenceDuration() * BodyAnimSpeed
    end

    if not customcycle then
        BodyAnim:SetCycle(BodyAnimCycle)
    end

    FOVLerp2 = Lerp(0.01, FOVLerp2, FOVLerp)

    if followplayer then
        BodyAnim:SetPos(ply:GetPos())
    end

    if deleteonend and not customcycle and BodyAnimCycle >= 1 then
        RemoveBodyAnim()
    end
end)

local lastattachpos = Vector(0, 0, 0)

hook.Add("CalcView", "BodyAnimCalcView2", function(ply, pos, angles, fov)
    if (IsValid(BodyAnimMDL) or IsValid(BodyAnim)) then
        local view = {}

        if attach ~= nil then
            view.origin = attach.Pos
            view.fov = fov + FOVLerp2

            if savedeyeangb == Angle(0, 0, 0) then
                savedeyeangb = Angle(0, attach.Ang.y, 0)
            end

            if BodyAnimSmoothAng and not angclosenuff then
                ply:SetEyeAngles(Angle(0, 0, 0))

                if (BodyAnimAngLerp.x - attach.Ang.x) >= -0.6 and (BodyAnimAngLerp.x - attach.Ang.x) <= 0.9 then
                    angclosenuff = true
                end

                BodyAnimAngLerp = LerpAngle(customlerp, BodyAnimAngLerp, Angle(attach.Ang.x * 1.5, attach.Ang.y, attach.Ang.z))
                view.angles = Angle(math.Clamp(BodyAnimAngLerp.x, -90, 30), BodyAnimAngLerp.y, BodyAnimAngLerp.z)
            else
                view.angles = attach.Ang + ply:EyeAngles()
                allowedangchange = true
            end

            if lockang then
                view.angles = attach.Ang
                allowedangchange = false
            end

            BodyAnimEyeAng = attach.Ang
            BodyAnimPos = attach.Pos
            lastattachpos = attach.Pos
            bodyanimlastattachang = ply:EyeAngles()
            view.pos = attach.Pos
            local vm = ply:GetViewModel()

            if IsValid(vm) and not vm:GetNoDraw() then
                vm:SetNoDraw(true)
            end

            if not ply:ShouldDrawLocalPlayer() then
                ply:SetNoDraw(false)

                return view
            else
                ply:SetNoDraw(true)
            end
        end

        if (attach == nil) or CurTime() < mantletimer then
            view.pos = lastattachpos

            return lastattachpos
        end
    end
end)

hook.Add("CreateMove", "BodyLimitMove", function(cmd)
    local ply = LocalPlayer()

    if IsValid(BodyAnim) and IsValid(BodyAnimMDL) then
        attachId = BodyAnim:LookupAttachment("eyes")
        attach = BodyAnim:GetAttachment(attachId)
    end

    if IsValid(BodyAnimMDL) then
        if not allowmove then
                    cmd:ClearButtons()
	          cmd:ClearMovement()
        end

    end
end)

--[[hook.Add("PreDrawOpaqueRenderables", "IgnoreZBodyAnim", function()
    if IsValid(BodyAnimMDL) then
        if ignorez then
            cam.IgnoreZ(true)

            if IsValid(BodyAnimMDLarm) then
                -BodyAnimMDLarm:DrawModel()
            else
                BodyAnimMDL:DrawModel()
            end

            cam.IgnoreZ(false)
        end
    end
end)]]

hook.Add("InputMouseApply", "BodyLimitView", function(cmd, x, y, ang)
    --print(vecang:Forward()*Vector(1,1,0)," | ",savedeyeangb:Forward())
    --print(vecangf:DistToSqr(savedeyeangb:Right()))
    if not IsValid(BodyAnim) then return end
    local ply = LocalPlayer()
    local vecang = Angle(0, 0, 0)
    local vecplyang = Angle(0, 0, 0)
    local vecangf = Vector(0, 0, 0)

    if angclosenuff then
        vecang = cmd:GetViewAngles() + BodyAnimEyeAng
        vecplyang = cmd:GetViewAngles()
        vecangf = vecang:Forward() * Vector(1, 1, 0)
    end

    local limitdown = 50

    if customlimitdownclassic then
        limitdown = 50 + customlimitdown
    else
        limitdown = ((vecangf:DistToSqr(savedeyeangb:Forward() * Vector(1, 1, 0)) * 20)) + customlimitdown
    end

    local limitup = -69 + customlimitup
    local limithor = 0.6 + customlimithor

    if IsValid(BodyAnimMDL) and angclosenuff then
        if vecang.x < limitup then
            bodylockview = true
            cmd:SetViewAngles(Angle(limitup, vecplyang.y, 0))
        end

        if vecang.x > limitdown then
            bodylockview = true
            cmd:SetViewAngles(Angle(limitdown - BodyAnimEyeAng.x, vecplyang.y, 0))
        end

        if not customlimit360 then
            if vecangf:DistToSqr(savedeyeangb:Forward() * Vector(1, 1, 0)) > limithor - 0.01 then
                bodylockview = true

                if vecangf:DistToSqr(savedeyeangb:Right()) > limithor then
                    BodyAnimLockDirection = 0
                    cmd:SetViewAngles(vecplyang - Angle(0, 1, 0))
                else
                    BodyAnimLockDirection = 1
                    cmd:SetViewAngles(vecplyang + Angle(0, 1, 0))
                end

                cmd:SetMouseX(1)

                return true
            else
                bodylockview = false
                BodyAnimLockDirection = 2
            end
        else
            if vecangf:DistToSqr(savedeyeangb:Forward() * Vector(1, 1, 0)) > limithor - 0.01 then
                if vecangf:DistToSqr(savedeyeangb:Right()) > limithor then
                    BodyAnimLockDirection = 0
                else
                    BodyAnimLockDirection = 1
                end
            else
                BodyAnimLockDirection = 2
            end

            bodylockview = false
        end
    end
end)