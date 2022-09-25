if CLIENT then
WBK_FlashlightIsActive = false
WBK_IsFlashlightOnShoulder = false
WBK_FlashlightObject = nil


hook.Add("PlayerBindPress", "FlashLight_KeyPress", function(ply, bind, pressed)
    if bind != "impulse 100" and bind != "+reload" then return end
	if bind == "+reload" and WBK_IsFlashlightOnShoulder then return end
	local VMAnimCurrentAnimIn = VManip:GetCurrentAnim() == "Flashlight_In"
	local VMAnimCurrentAnimShould = VManip:GetCurrentAnim() == "Flashlight_Shoulder_Take"
	if bind == "+reload" and !VMAnimCurrentAnimIn and !VMAnimCurrentAnimShould then return end
	local isOnlyOnShoulder = VMAnipFlashlight_Serv_UseOnlyShoulder:GetBool()
	if isOnlyOnShoulder then 
	WBK_IsFlashlightOnShoulder = true;
	local VMAnimCurrentAnimIn = VManip:GetCurrentAnim() == "Flashlight_In"
	local VMAnimCurrentAnimShould = VManip:GetCurrentAnim() == "Flashlight_Shoulder_Take"
    if VMAnimCurrentAnimIn || VMAnimCurrentAnimShould then
        VMAnimPlayedF = VManip:PlaySegment("Flashlight_Shoulder_Put", true)
            if VMAnimPlayedF then
			    LocalPlayer():EmitSound("wbk/flashlight_Shoulder_move_1.ogg")
				timer.Simple(0.1, function()
					LocalPlayer():EmitSound("wbk/flashlight_Shoulder_attach.ogg")
                end)
			    timer.Simple(0.5, function()
					WBK_IsFlashlightOnShoulder = true
                end)
             end
	end
	end
	if WBK_IsFlashlightOnShoulder == true && pressed == true then 
    VMAnimPlayedF = VManip:PlayAnim("Flashlight_EnableDisable")
    if VMAnimPlayedF then
	if WBK_FlashlightIsActive == true then 
	    LocalPlayer():EmitSound("wbk/flashlight_Shoulder_move_1.ogg")
	    timer.Simple(0.25, function()
            LocalPlayer():EmitSound("wbk/flashlight_enable.wav")
			WBK_FlashlightIsActive = false
			WBK_FlashlightObject:Remove()
            WBK_FlashlightObject = nil
        end)
    else
	    LocalPlayer():EmitSound("wbk/flashlight_takeIn.wav")
	    timer.Simple(0.25, function()
            LocalPlayer():EmitSound("wbk/flashlight_enable.wav")
			WBK_FlashlightIsActive = true
			WBK_FlashlightObject = ProjectedTexture()
            WBK_FlashlightObject:SetColor(Color(255, 255, 255))
			local VMAnipFlashlightActTexture = LocalPlayer():GetInfo( "cl_VMANIPFlash_texture" )
            WBK_FlashlightObject:SetTexture(VMAnipFlashlightActTexture)
            WBK_FlashlightObject:SetEnableShadows(true)
			WBK_FlashlightObject:SetShadowFilter( 0 )
            WBK_FlashlightObject:SetFOV(70)
        end)
	end
	end
	return true
    else
	if WBK_IsFlashlightOnShoulder == true then return end
    local VMAnimPlayedF
    local VMAnimCurrentAnimIn = VManip:GetCurrentAnim() == "Flashlight_In"
	local VMAnimCurrentAnimShould = VManip:GetCurrentAnim() == "Flashlight_Shoulder_Take"
    if VMAnimCurrentAnimIn || VMAnimCurrentAnimShould then
        VMAnimPlayedF = VManip:PlaySegment("Flashlight_Out", true)
        if VMAnimPlayedF then
			timer.Simple(0.3, function()
                LocalPlayer():EmitSound("wbk/flashlight_enable.wav")
				WBK_FlashlightIsActive = false
				WBK_FlashlightObject:Remove()
                WBK_FlashlightObject = nil
            end)
            timer.Simple(0.5, function()
                LocalPlayer():EmitSound("wbk/flashlight_takeOut.wav")
            end)
        end
    else
        VMAnimPlayedF = VManip:PlayAnim("Flashlight_In")
        if VMAnimPlayedF then
		    WBK_IsFlashlightOnShoulder = false
            LocalPlayer():EmitSound("wbk/flashlight_takeIn.wav")
            timer.Simple(0.4, function()
                LocalPlayer():EmitSound("wbk/flashlight_enable.wav")
				WBK_FlashlightIsActive = true
				WBK_FlashlightObject = ProjectedTexture()
                WBK_FlashlightObject:SetColor(Color(255, 255, 255))
			    local VMAnipFlashlightActTexture = LocalPlayer():GetInfo( "cl_VMANIPFlash_texture" )
                WBK_FlashlightObject:SetTexture(VMAnipFlashlightActTexture)
                WBK_FlashlightObject:SetEnableShadows(true)
				WBK_FlashlightObject:SetShadowFilter( 0 )
                WBK_FlashlightObject:SetFOV(70)
            end)
        end
    end
    VMAnimPlayedF = VMAnimPlayedF
    return true
	end
end)
local function solvetriangle(angle, dist)
    local a = angle / 2
    local b = dist
    return b * math.tan(a) * 2
end

local function WBK_SpawnFlashlight()
    if WBK_FlashlightIsActive && WBK_FlashlightObject then
        local mdl = VManip:GetVMGesture()
        if LocalPlayer():ShouldDrawLocalPlayer() or !IsValid(mdl) or WBK_IsFlashlightOnShoulder == true then
            WBK_FlashlightObject:SetPos(LocalPlayer():EyePos())
            WBK_FlashlightObject:SetAngles(LocalPlayer():EyeAngles())
			WBK_FlashlightObject:SetFarZ(654)
            WBK_FlashlightObject:Update()
        else
        local att = mdl:LookupAttachment("FlashLight")
        local posang = mdl:GetAttachment(att)
        WBK_FlashlightObject:SetPos(posang.Pos - (posang.Ang:Forward() * 10))
        WBK_FlashlightObject:SetAngles(posang.Ang + Angle(180, -10, 0))
		WBK_FlashlightObject:SetFarZ(824)
        WBK_FlashlightObject:Update()
		end
    end
end
hook.Add("Think", "FlashLight_EnableFlashlight", WBK_SpawnFlashlight)
--[[
Wanted to do a running anim, but it seems that VMAnip do not support smooth transitions between animations
local function WBK_PlayDiffAnims(ply)
    local VMAnimCurrentAnimIn = VManip:GetCurrentAnim() == "Flashlight_In"
	local VMAnimCurrentAnimLoop = VManip:GetCurrentAnim() == "Flashlight_Loop"
	local VMAnimCurrentAnimRun = VManip:GetCurrentAnim() == "Flashlight_Run"
    if (VMAnimCurrentAnimIn || VMAnimCurrentAnimLoop || VMAnimCurrentAnimRun) && WBK_FlashlightIsActive then
        if LocalPlayer():GetVelocity():Length() > LocalPlayer():GetRunSpeed() - 10 then 
		   VManip:PlaySegment("Flashlight_Run")
		else
		   VManip:PlaySegment("Flashlight_Loop")
	    end
	end
end
hook.Add("Think", "WBK_CheckAnimHandler", WBK_PlayDiffAnims) 
--]]





local function ToggleShoulderFlashlight(ply)
local isOnlyOnShoulder = VMAnipFlashlight_Serv_UseOnlyShoulder:GetBool()
if isOnlyOnShoulder then return end

if WBK_IsFlashlightOnShoulder == false then
    local VMAnimCurrentAnimIn = VManip:GetCurrentAnim() == "Flashlight_In"
	local VMAnimCurrentAnimShould = VManip:GetCurrentAnim() == "Flashlight_Shoulder_Take"
	local canPut = VMAnipFlashlight_Serv_CanputonShoulder:GetBool()
    if ((VMAnimCurrentAnimIn || VMAnimCurrentAnimShould) && canPut) then 
        VMAnimPlayedF = VManip:PlaySegment("Flashlight_Shoulder_Put", true)
            if VMAnimPlayedF then
			    LocalPlayer():EmitSound("wbk/flashlight_Shoulder_move_1.ogg")
				timer.Simple(0.1, function()
					LocalPlayer():EmitSound("wbk/flashlight_Shoulder_attach.ogg")
                end)
			    timer.Simple(0.5, function()
					WBK_IsFlashlightOnShoulder = true
                end)
             end
        end
	else
	VMAnimPlayedF = VManip:PlayAnim("Flashlight_Shoulder_Take")
        if VMAnimPlayedF then
		    LocalPlayer():EmitSound("wbk/flashlight_Shoulder_move_2.ogg")
            timer.Simple(0.4, function()
				WBK_IsFlashlightOnShoulder = false
				if WBK_FlashlightIsActive == false then 
                WBK_FlashlightIsActive = true
				WBK_FlashlightObject = ProjectedTexture()
                WBK_FlashlightObject:SetColor(Color(255, 255, 255))
			    local VMAnipFlashlightActTexture = LocalPlayer():GetInfo( "cl_VMANIPFlash_texture" )
                WBK_FlashlightObject:SetTexture(VMAnipFlashlightActTexture)
                WBK_FlashlightObject:SetEnableShadows(true)
				WBK_FlashlightObject:SetShadowFilter( 0 )
                WBK_FlashlightObject:SetFOV(70)
	            LocalPlayer():EmitSound("wbk/flashlight_Shoulder_detach.ogg")
		        end
            end)
        end
    end	
end





concommand.Add("putFlashlightOnShoulder",ToggleShoulderFlashlight)
end