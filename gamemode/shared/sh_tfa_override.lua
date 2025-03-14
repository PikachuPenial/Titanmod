
hook.Add("PreRegisterSWEP", "TFAOverride", function(swep, class)
	-- bobbing
	local vector_origin = Vector()
	SWEP.ti = 0
	SWEP.LastCalcBob = 0
	SWEP.tiView = 0
	SWEP.LastCalcViewBob = 0
	local TAU = math.pi * 2
	local rateScaleFac = 2
	local rate_up = 6 * rateScaleFac
	local scale_up = 0.5
	local rate_right = 3 * rateScaleFac
	local scale_right = -0.5
	local rate_forward_view = 3 * rateScaleFac
	local scale_forward_view = 0.35
	local rate_right_view = 3 * rateScaleFac
	local scale_right_view = -1
	local rate_p = 6 * rateScaleFac
	local scale_p = 3
	local rate_y = 3 * rateScaleFac
	local scale_y = 6
	local rate_r = 3 * rateScaleFac
	local scale_r = -6
	local pist_rate = 3 * rateScaleFac
	local pist_scale = 9
	local rate_clamp = 2 * rateScaleFac
	local walkIntensitySmooth, breathIntensitySmooth = 0, 0
	local walkRate = 160 / 60 * TAU / 1.085 / 2 * rateScaleFac
	local walkVec = Vector()
	local ownerVelocity, ownerVelocityMod = Vector(), Vector()
	local zVelocity, zVelocitySmooth = 0, 0
	local xVelocity, xVelocitySmooth, rightVec = 0, 0, Vector()
	local flatVec = Vector(1, 1, 0)
	local WalkPos = Vector()
	local WalkPosLagged = Vector()
	local gunbob_intensity_cvar = GetConVar("cl_tfa_gunbob_intensity")
	local gunbob_intensity = 0
	SWEP.VMOffsetWalk = Vector(0.5, -0.5, -0.5)
	SWEP.footstepTotal = 0
	SWEP.footstepTotalTarget = 0
	local upVec, riVec, fwVec = Vector(0, 0, 1), Vector(1, 0, 0), Vector(0, 1, 0)

	local function l_Lerp(t, a, b)
		if t <= 0 then return a end
		if t >= 1 then return b end
		return a + (b - a) * t
	end

	function SWEP:WalkBob(pos, ang, breathIntensity, walkIntensity, rate, ftv)
		local self2 = self:GetTable()
		if not self2.OwnerIsValid(self) then return end
		rate = math.min(rate or 0.5, rate_clamp)
		gunbob_intensity = gunbob_intensity_cvar:GetFloat()

		local ea = self:GetOwner():EyeAngles()
		local up = ang:Up()
		local ri = ang:Right()
		local fw = ang:Forward()
		local upLocal = upVec
		local riLocal = riVec
		local fwLocal = fwVec
		local delta = ftv
		local flip_v = self2.ViewModelFlip and -1 or 1
		self2.bobRateCached = rate
		self2.ti = self2.ti + delta * rate

		if self2.SprintStyle == nil then
			if self:GetStatL("SprintViewModelAngle") and self:GetStatL("SprintViewModelAngle").x > 5 then
				self2.SprintStyle = 1
			else
				self2.SprintStyle = 0
			end
		end

		walkIntensitySmooth = l_Lerp(delta * 10 * rateScaleFac, walkIntensitySmooth, walkIntensity)
		breathIntensitySmooth = l_Lerp(delta * 10 * rateScaleFac, breathIntensitySmooth, breathIntensity)
		walkVec = LerpVector(walkIntensitySmooth, vector_origin, self2.VMOffsetWalk)
		ownerVelocity = self:GetOwner():GetVelocity()
		zVelocity = ownerVelocity.z
		zVelocitySmooth = l_Lerp(delta * 7 * rateScaleFac, zVelocitySmooth, zVelocity)
		ownerVelocityMod = ownerVelocity * flatVec
		ownerVelocityMod:Normalize()
		rightVec = ea:Right() * flatVec
		rightVec:Normalize()
		xVelocity = ownerVelocity:Length2D() * ownerVelocityMod:Dot(rightVec)
		xVelocitySmooth = l_Lerp(delta * 5 * rateScaleFac, xVelocitySmooth, xVelocity)

		-- multipliers
		breathIntensity = breathIntensitySmooth * gunbob_intensity * 0.525
		walkIntensity = walkIntensitySmooth * gunbob_intensity * 1.45

		-- breathing/walking while ADS
		local breatheMult2 = math.Clamp((self2.IronSightsProgressUnpredicted2 or self:GetIronSightsProgress()), 0, 1)
		local breatheMult1 = 1 - breatheMult2

		pos:Add(riLocal * (math.sin(self2.ti * walkRate) - math.cos(self2.ti * walkRate)) * flip_v * breathIntensity * 0.2 * breatheMult1)
		pos:Add(upLocal * math.sin(self2.ti * walkRate) * breathIntensity * 0 * breatheMult1)

		pos:Add(riLocal * math.cos(self2.ti * walkRate / 2) * flip_v * breathIntensity * 0.2 * breatheMult2)
		pos:Add(upLocal * math.sin(self2.ti * walkRate) * breathIntensity * 0.1 * breatheMult2)

		ang:RotateAroundAxis(ri, math.sin(self2.ti * walkRate) * breathIntensity * breatheMult2 * .75)
		ang:RotateAroundAxis(up, math.sin(self2.ti * walkRate / 2) * breathIntensity * breatheMult2 * -1.0)
		ang:RotateAroundAxis(fw, math.sin(self2.ti * walkRate / 2) * breathIntensity * breatheMult2 * 2.0)

		self2.walkTI = (self2.walkTI or 0) + delta * 160 / 60 * self:GetOwner():GetVelocity():Length2D() / self:GetOwner():GetWalkSpeed()
		WalkPos.x = l_Lerp(delta * 5 * rateScaleFac, WalkPos.x, -math.sin(self2.ti * walkRate * 0.5) * gunbob_intensity * walkIntensity)
		WalkPos.y = l_Lerp(delta * 5 * rateScaleFac, WalkPos.y, math.sin(self2.ti * walkRate) / 1.5 * gunbob_intensity * walkIntensity)
		WalkPosLagged.x = l_Lerp(delta * 5 * rateScaleFac, WalkPosLagged.x, -math.sin((self2.ti * walkRate * 0.5) + math.pi / 3) * gunbob_intensity * walkIntensity)
		WalkPosLagged.y = l_Lerp(delta * 5 * rateScaleFac, WalkPosLagged.y, math.sin(self2.ti * walkRate + math.pi / 3) / 1.5 * gunbob_intensity * walkIntensity)
		pos:Add(WalkPos.x * 0.33 * riLocal)
		pos:Add(WalkPos.y * 0.25 * upLocal)
		ang:RotateAroundAxis(ri, -WalkPosLagged.y)
		ang:RotateAroundAxis(up, WalkPosLagged.x)
		ang:RotateAroundAxis(fw, WalkPos.x)

		-- constant offset
		pos:Add(riLocal * walkVec.x * flip_v)
		pos:Add(fwLocal * walkVec.y)
		pos:Add(upLocal * walkVec.z)

		-- jumping
		local trigX = -math.Clamp(zVelocitySmooth / 200, -1, 1) * math.pi / 2
		local jumpIntensity = (3 + math.Clamp(math.abs(zVelocitySmooth) - 100, 0, 200) / 200 * 4) * (1 - (self2.IronSightsProgressUnpredicted or self:GetIronSightsProgress()) * 1)
		pos:Add(ri * math.sin(trigX) * scale_r * 0.1 * jumpIntensity * flip_v * 0.25)
		pos:Add(-up * math.sin(trigX) * scale_r * 0.1 * jumpIntensity * 0.25)
		ang:RotateAroundAxis(ang:Forward(), math.sin(trigX) * scale_r * jumpIntensity * flip_v * 0)

		-- rolling with horizontal motion
		local xVelocityClamped = xVelocitySmooth

		if math.abs(xVelocityClamped) > 200 then
			local sign = (xVelocityClamped < 0) and -1 or 1
			xVelocityClamped = (math.sqrt((math.abs(xVelocityClamped) - 200) / 50) * 50 + 200) * sign
		end

		if math.Clamp(self2.IronSightsProgressUnpredicted2 or self:GetIronSightsProgress(), 0, 1) >= 0.5 then
			ang:RotateAroundAxis(ang:Forward(), xVelocityClamped * 0.0105 * flip_v)
		else
			ang:RotateAroundAxis(ang:Forward(), xVelocityClamped * 0.04 * flip_v)
		end

		return pos, ang
	end

	function SWEP:SprintBob(pos, ang, intensity, origPos, origAng)
		local self2 = self:GetTable()
		if not IsValid(self:GetOwner()) or not gunbob_intensity then return pos, ang end
		local flip_v = self2.ViewModelFlip and -1 or 1

		local eyeAngles = self:GetOwner():EyeAngles()
		local localUp = ang:Up()
		local localRight = ang:Right()
		local localForward = ang:Forward()

		intensity = intensity * gunbob_intensity * 1.5
		gunbob_intensity = gunbob_intensity_cvar:GetFloat()

		if intensity > 0.005 then
			if self2.SprintStyle == 1 then
				local intensity3 = math.max(intensity - 0.3, 0) / (1 - 0.3)
				ang:RotateAroundAxis(ang:Up(), math.sin(self2.ti * pist_rate) * pist_scale * intensity3 * 0.33 * 0.75)
				ang:RotateAroundAxis(ang:Forward(), math.sin(self2.ti * pist_rate) * pist_scale * intensity3 * 0.33 * -0.25)
				pos:Add(ang:Forward() * math.sin(self2.ti * pist_rate * 2 + math.pi) * pist_scale * -0.1 * intensity3 * 0.4)
				pos:Add(ang:Right() * math.sin(self2.ti * pist_rate) * pist_scale * 0.15 * intensity3 * 0.33 * 0.2)
			else
				pos:Add(localUp * math.sin(self2.ti * rate_up + math.pi) * scale_up * intensity * 0.33)
				pos:Add(localRight * math.sin(self2.ti * rate_right) * scale_right * intensity * flip_v * 0.33)
				pos:Add(eyeAngles:Forward() * math.max(math.sin(self2.ti * rate_forward_view), 0) * scale_forward_view * intensity * 0.33)
				pos:Add(eyeAngles:Right() * math.sin(self2.ti * rate_right_view) * scale_right_view * intensity * flip_v * 0.33)

				ang:RotateAroundAxis(localRight, math.sin(self2.ti * rate_p + math.pi) * scale_p * intensity * 0.33)
				pos:Add(-localUp * math.sin(self2.ti * rate_p + math.pi) * scale_p * 0.1 * intensity * 0.33)

				ang:RotateAroundAxis(localUp, math.sin(self2.ti * rate_y) * scale_y * intensity * flip_v * 0.33)
				pos:Add(localRight * math.sin(self2.ti * rate_y) * scale_y * 0.1 * intensity * flip_v * 0.33)

				ang:RotateAroundAxis(localForward, math.sin(self2.ti * rate_r) * scale_r * intensity * flip_v * 0.33)
				pos:Add(localRight * math.sin(self2.ti * rate_r) * scale_r * 0.05 * intensity * flip_v * 0.33)
				pos:Add(localUp * math.sin(self2.ti * rate_r) * scale_r * 0.1 * intensity * 0.33)
			end
		end

		return pos, ang
	end

	local cv_customgunbob = GetConVar("cl_tfa_gunbob_custom")
	local fac, bscale

	function SWEP:UpdateEngineBob()
		local self2 = self:GetTable()

		if cv_customgunbob:GetBool() then
			self2.BobScale = 0
			self2.SwayScale = 0

			return
		end

		local isp = self2.IronSightsProgressUnpredicted or self:GetIronSightsProgress()
		local wpr = self2.WalkProgressUnpredicted or self:GetWalkProgress()
		local spr = self:GetSprintProgress()

		fac = gunbob_intensity_cvar:GetFloat() * ((1 - isp) * 0.85 + 0.15)
		bscale = fac

		if spr > 0.005 then
			bscale = bscale * l_Lerp(spr, 1, self2.SprintBobMult)
		elseif wpr > 0.005 then
			bscale = bscale * l_Lerp(wpr, 1, l_Lerp(isp, self2.WalkBobMult, self2.WalkBobMult_Iron or self2.WalkBobMult))
		end

		self2.BobScale = bscale
		self2.SwayScale = fac
	end

    -- sway
    local function Clamp(a, b, c)
		if a < b then return b end
		if a > c then return c end
		return a
	end

	local function GetClampedCVarFloat(cvar)
		return Clamp(cvar:GetFloat(), cvar:GetMin(), cvar:GetMax())
	end

	local gunswaycvar = GetConVar("cl_tfa_gunbob_intensity")
	local gunswayinvertcvar = GetConVar("cl_tfa_gunbob_invertsway")
	local sv_tfa_weapon_weight = GetConVar("sv_tfa_weapon_weight")

	function SWEP:Sway(pos, ang, ftv)
		local self2 = self:GetTable()
		if not self:OwnerIsValid() then return pos, ang end
		fac = GetClampedCVarFloat(gunswaycvar) * 3 * ((1 - ((self2.IronSightsProgressUnpredicted or self:GetIronSightsProgress()) or 0)) * 0.85 + 0.012)
		if gunswayinvertcvar:GetBool() then fac = -fac end
		flipFactor = (self2.ViewModelFlip and -1 or 1)
		delta = delta or Angle()
		motion = motion or Angle()
		counterMotion = counterMotion or Angle()
		compensation = compensation or Angle()

		if ftv then
			eyeAngles = self:GetOwner():EyeAngles()
			viewPunch = self:GetOwner():GetViewPunchAngles()
			eyeAngles.p = eyeAngles.p - viewPunch.p
			eyeAngles.y = eyeAngles.y - viewPunch.y
			oldEyeAngles = oldEyeAngles or eyeAngles
			wiggleFactor = (1 - (sv_tfa_weapon_weight:GetBool() and self2.GetStatL(self, "RegularMoveSpeedMultiplier") or 1)) / 0.6 + 0.15
			swayRate = math.pow(sv_tfa_weapon_weight:GetBool() and self2.GetStatL(self, "RegularMoveSpeedMultiplier") or 1, 1.5) * 10
			rft = math.Clamp(ftv, 0.001, 1 / 20)
			local clampFac = 1.1 - math.min((math.abs(motion.p) + math.abs(motion.y) + math.abs(motion.r)) / 16, 1)
			delta.p = math.AngleDifference(eyeAngles.p, oldEyeAngles.p) / rft / 120 * clampFac
			delta.y = math.AngleDifference(eyeAngles.y, oldEyeAngles.y) / rft / 120 * clampFac
			delta.r = math.AngleDifference(eyeAngles.r, oldEyeAngles.r) / rft / 120 * clampFac
			oldEyeAngles = eyeAngles
			counterMotion = LerpAngle(rft * (swayRate * (0.75 + math.max(0, 0.5 - wiggleFactor))), counterMotion, -motion)
			compensation.p = math.AngleDifference(motion.p, -counterMotion.p)
			compensation.y = math.AngleDifference(motion.y, -counterMotion.y)
			motion = LerpAngle(rft * swayRate, motion, delta + compensation)
		end

		-- modify position/angle
		positionCompensation = 0.2 + 0.2 * ((self2.IronSightsProgressUnpredicted or self:GetIronSightsProgress()) or 0)
		pos:Add(-motion.y * positionCompensation * 0.66 * fac * ang:Right() * flipFactor)
		pos:Add(-motion.p * positionCompensation * fac * ang:Up())
		ang:RotateAroundAxis(ang:Right(), motion.p * fac)
		ang:RotateAroundAxis(ang:Up(), -motion.y * 0.66 * fac * flipFactor)
		ang:RotateAroundAxis(ang:Forward(), counterMotion.r * 0.5 * fac * flipFactor)

		return pos, ang
	end
end )

if CLIENT then
    -- forcefully disable the use of the TFA crosshair
    hook.Add("TFA_DrawCrosshair", "DisableTFACrosshair", function(ply) return true end)
end