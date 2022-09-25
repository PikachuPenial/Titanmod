if SERVER then
	util.AddNetworkString("TFA_ScreenShake")

	hook.Add("TFA_PostPrimaryAttack", "TFA_ScreenShakeDetect", function(wep)
		if wep:GetOwner():IsNPC() then return end
		if not wep.IsTFAWeapon then return end
		if not wep:GetOwner():Alive() then return end

		net.Start("TFA_ScreenShake")
		net.WriteBool(true)
		net.Send(wep:GetOwner())

		timer.Simple(0.0001, function()
			net.Start("TFA_ScreenShake")
			net.WriteBool(false)
			net.Send(wep:GetOwner())
		end)
	end)
end

if CLIENT then
	local tfa_screenshake_enabled = CreateClientConVar("cl_tfa_screenshake_enabled", 1)
	local tfa_screenshake_blur_enabled = CreateClientConVar("cl_tfa_screenshake_blur_enabled", 1)
	local tfa_screenshake_force_multiplier = CreateClientConVar("cl_tfa_screenshake_force_multiplier", 1)
	local tfa_screenshake_fov_force_multiplier = CreateClientConVar("cl_tfa_screenshake_fov_force_multiplier", 1)
	local tfa_screenshake_speed_multiplier = CreateClientConVar("cl_tfa_screenshake_speed_multiplier", 1)

	RunConsoleCommand("mat_motion_blur_enabled", 1)

	local function LerpUnclamped(t, from, to)
		return t + (from - t) * to
	end

	local function InElasticEasedLerp(fraction, from, to)
		return LerpUnclamped(math.ease.InElastic(fraction), from, to)
	end

	local ScreenShakeFOVFraction = 0
	local ScreenShakeFOV = 0
	local ScreenShakeLeftFraction = 0
	local ScreenShakeLeftAngle = Angle(0, 0, 0)
	local ScreenShakeLeft = Angle(0, 0, 0)
	local ScreenShakeRightFraction = 0
	local ScreenShakeRightAngle = Angle(0, 0, 0)
	local ScreenShakeRight = Angle(0, 0, 0)
	local ScreenShakeBlurFraction = 0

	net.Receive("TFA_ScreenShake", function(len, ply) -- Shitcode alert https://sun9-78.userapi.com/impg/TqYCCA61j-kxD-9MoVoUjTWvTXynuNA9Io5ioA/6gD0XRvMC7g.jpg?size=400x297&quality=95&sign=aca8a51f6971b828d7a31b56e7622ec1&type=album
		if net.ReadBool() then
			ScreenShakeFOVFraction = 1
			ScreenShakeLeftFraction = 1
			ScreenShakeBlurFraction = 1

			timer.Simple(0.04, function()
				ScreenShakeRightFraction = 1
			end)
		end
	end)

	hook.Add("CalcView", "TFA_CustomScreenShake", function (ply, origin, angles, fov, znear, zfar)
		local wep = ply:GetActiveWeapon()

		if not wep.IsTFAWeapon then return end
		if not ply:Alive() then return end
		if not tfa_screenshake_enabled:GetBool() then return end
		if ply:IsNPC() then return end

		local view = {}

		view.origin = origin
		view.angles = angles
		view.fov = fov
		view.znear = znear
		view.zfar = zfar
		view.drawviewer = false

		if (IsValid(wep)) then
			local func = wep.CalcView

			if (func) then
				view.origin, view.angles, view.fov = func(wep, ply, origin, angles, fov)
			end
		end

		local FOVMul = wep.ScreenShakeFOVMultiplier or 1
		local ForceMul = wep.ScreenShakeForceMultiplier or 1
		local SpeedMul = wep.ScreenShakeSpeedMultiplier or 1

		local ScreenShakeSmoothing = 25
		local ScreenShakeFOVForceMultiplier = tfa_screenshake_fov_force_multiplier:GetFloat() * (wep.Primary.KickUp + wep.Primary.KickHorizontal) * 7.5 * FOVMul
		local ScreenShakeForceMultiplier = tfa_screenshake_force_multiplier:GetFloat() * (wep.Primary.KickUp + wep.Primary.KickHorizontal) * 10 * ForceMul
		local ScreenShakeSpeedMultiplier = tfa_screenshake_speed_multiplier:GetFloat() * 2 * SpeedMul

		ScreenShakeFOVFraction = math.Approach(ScreenShakeFOVFraction, 0, FrameTime() * ScreenShakeSpeedMultiplier * 0.75)
		ScreenShakeFOV = InElasticEasedLerp(ScreenShakeFOVFraction, 0, ScreenShakeFOVForceMultiplier)

		ScreenShakeLeftFraction = math.Approach(ScreenShakeLeftFraction, 0, FrameTime() * ScreenShakeSpeedMultiplier)
		ScreenShakeLeftAngle = Angle(0, 0, InElasticEasedLerp(ScreenShakeLeftFraction, 0, ScreenShakeForceMultiplier))
		ScreenShakeLeft = LerpAngle(FrameTime() * ScreenShakeSmoothing, ScreenShakeLeft, ScreenShakeLeftAngle)

		ScreenShakeRightFraction = math.Approach(ScreenShakeRightFraction, 0, FrameTime() * ScreenShakeSpeedMultiplier)		
		ScreenShakeRightAngle = Angle(0, 0, InElasticEasedLerp(ScreenShakeRightFraction, 0, -ScreenShakeForceMultiplier))		
		ScreenShakeRight = LerpAngle(FrameTime() * ScreenShakeSmoothing, ScreenShakeRight, ScreenShakeRightAngle)

		view.angles = view.angles + ScreenShakeLeft + ScreenShakeRight
		view.fov = view.fov + ScreenShakeFOV

		return view -- I can't make it so that it doesn't break anything https://sun9-43.userapi.com/impg/PGm6IiHDHfMXj7w8mB-5E02OoILW6XQQ47C97w/c8JZpgKgoPo.jpg?size=793x917&quality=96&sign=9c9a1d6cad71c7efcc5629ad6dde79a8&type=album
	end)

	hook.Add("GetMotionBlurValues", "TFA_CustomScreenShake_Blur", function(h, v, f, r)
		local ply = LocalPlayer()
		local wep = ply:GetActiveWeapon()

		if not wep.IsTFAWeapon then return end
		if not ply:Alive() then return end
		if not tfa_screenshake_blur_enabled:GetBool() then return end
		if ply:IsNPC() then return end

		local ForceMul = wep.ScreenShakeForceMultiplier or 1
		local SpeedMul = wep.ScreenShakeSpeedMultiplier or 1

		local ScreenShakeBlurForce = tfa_screenshake_force_multiplier:GetFloat() * (wep.Primary.KickUp + wep.Primary.KickHorizontal) * .1 * ForceMul
		local ScreenShakeBlurSpeed = tfa_screenshake_speed_multiplier:GetFloat() * 10 * SpeedMul

		ScreenShakeBlurFraction = math.Approach(ScreenShakeBlurFraction, 0, FrameTime() * ScreenShakeBlurSpeed)

		return h, v, f + (ScreenShakeBlurFraction * ScreenShakeBlurForce), r
	end)
end