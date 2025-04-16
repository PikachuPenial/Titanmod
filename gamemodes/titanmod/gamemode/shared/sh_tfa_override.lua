hook.Add("PreRegisterSWEP", "TFAOverride", function(swep, class)
	if SWEP.Base != "tfa_gun_base" and SWEP.Base != "tm_knife_base" and SWEP.Base != "rust_throwable_melee_base" then return end

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

	local function l_mathMin(a, b) return (a < b) and a or b end
	local function l_mathMax(a, b) return (a > b) and a or b end
	local function l_ABS(a) return (a < 0) and -a or a end

	local function l_mathApproach(a, b, delta)
		if a < b then
			return l_mathMin(a + l_ABS(delta), b)
		else
			return l_mathMax(a - l_ABS(delta), b)
		end
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

	local sprint_cv = GetConVar("sv_tfa_sprint_enabled")

	function SWEP:TFAFinishMove(ply, velocity, movedata)
		local ft = FrameTime()
		local self2 = self:GetTable()
		local isply = ply:IsPlayer()

		if CLIENT then
			self2.LastUnpredictedVelocity = velocity
		end

		local speedmult = Lerp(self:GetIronSightsProgress(), sv_tfa_weapon_weight:GetBool() and self:GetStatL("RegularMoveSpeedMultiplier") or 1, self:GetStatL("AimingDownSightsSpeedMultiplier"))

		local jr_targ = math.min(math.abs(velocity.z) / 500, 1)
		self:SetJumpRatio(l_mathApproach(self:GetJumpRatio(), jr_targ, (jr_targ - self:GetJumpRatio()) * ft * 20))
		self2.JumpRatio = self:GetJumpRatio()
		self:SetCrouchingRatio(l_mathApproach(self:GetCrouchingRatio(), (self:IsOwnerCrouching()) and 1 or 0, ft / self2.ToCrouchTime))
		self2.CrouchingRatio = self:GetCrouchingRatio()

		local status = self2.GetStatus(self)
		local oldsprinting, oldwalking = self:GetSprinting(), self:GetWalking()
		local vellen = velocity:Length2D()

		if sprint_cv:GetBool() and not self:GetStatL("AllowSprintAttack", false) and movedata then
			self:SetSprinting(vellen > ply:GetRunSpeed() * 0.6 * speedmult and movedata:KeyDown(IN_SPEED) and ply:OnGround() and not ply:GetSliding() and not ply:Crouching())
		else
			self:SetSprinting(false)
		end

		self:SetWalking(vellen > ((isply and ply:GetWalkSpeed() or TFA.GUESS_NPC_WALKSPEED) * (sv_tfa_weapon_weight:GetBool() and self:GetStatL("RegularMoveSpeedMultiplier", 1) or 1) * .75) and ply:GetNW2Bool("TFA_IsWalking") and ply:OnGround() and not self:GetSprinting() and not self:GetCustomizing())

		self2.walking_updated = oldwalking ~= self:GetWalking()
		self2.sprinting_updated = oldsprinting ~= self:GetSprinting()

		if self:GetCustomizing() and (self2.GetIronSights(self) or not TFA.Enum.ReadyStatus[status]) then
			self:ToggleCustomize()
		end

		local spr = self:GetSprinting()
		local walk = self:GetWalking()

		local sprt = spr and 1 or 0
		local walkt = walk and 1 or 0
		local adstransitionspeed = (spr or walk) and 7.5 or 12.5

		self:SetSprintProgress(l_mathApproach(self:GetSprintProgress(), sprt, (sprt - self:GetSprintProgress()) * ft * adstransitionspeed))
		self:SetWalkProgress(l_mathApproach(self:GetWalkProgress(), walkt, (walkt - self:GetWalkProgress()) * ft * adstransitionspeed))

		self:SetLastVelocity(vellen)
	end

	function SWEP:ToggleInspect()
		if self:GetOwner():IsNPC() then return false end -- NPCs can't look at guns silly

		local self2 = self:GetTable()

		if (self:GetIronSights() or self:GetStatus() ~= TFA.Enum.STATUS_IDLE) and not self:GetCustomizing() then return end

		self:SetCustomizing(not self:GetCustomizing())
		self2.Inspecting = self:GetCustomizing()
		self:SetCustomizeUpdated(true)

		return self:GetCustomizing()
	end

	local l_CT = CurTime
	function SWEP:IronSights()
		local self2 = self:GetTable()
		local owent = self:GetOwner()
		if not IsValid(owent) then return end

		ct = l_CT()
		stat = self:GetStatus()

		local issprinting = self:GetSprinting()
		local iswalking = self:GetWalking()

		local issighting = self:GetIronSightsRaw()
		local isplayer = owent:IsPlayer()
		local old_iron_sights_final = self:GetIronSightsOldFinal()

		if TFA.Enum.ReloadStatus[stat] and self2.GetStatL(self, "IronSightsReloadLock") then
			issighting = old_iron_sights_final
		end

		if issighting and isplayer and owent:InVehicle() and not owent:GetAllowWeaponsInVehicle() then
			issighting = false
			self:SetIronSightsRaw(false)
		end

		-- self:SetLastSightsStatusCached(false)
		local userstatus = issighting

		if issprinting and not owent:GetSliding() and not owent:Crouching() then
			issighting = false
		end

		if issighting and not TFA.Enum.IronStatus[stat] and (not self:GetStatL("IronSightsReloadEnabled") or not TFA.Enum.ReloadStatus[stat]) then
			issighting = false
		end

		if issighting and self:IsSafety() then
			issighting = false
		end

		if stat == TFA.Enum.STATUS_FIREMODE and self:GetIsCyclingSafety() then
			issighting = false
		end

		local isbolt = self2.GetStatL(self, "BoltAction")
		local isbolt_forced = self2.GetStatL(self, "BoltAction_Forced")
		if isbolt or isbolt_forced then
			if stat == TFA.Enum.STATUS_SHOOTING and not self2.LastBoltShoot then
				self2.LastBoltShoot = l_CT()
			end

			if self2.LastBoltShoot then
				if stat == TFA.Enum.STATUS_SHOOTING then
					if l_CT() > self2.LastBoltShoot + self2.GetStatL(self, "BoltTimerOffset") then
						issighting = false
					end
				else
					self2.LastBoltShoot = nil
				end
			end

			if (stat == TFA.Enum.STATUS_IDLE and self:GetReloadLoopCancel(true)) or stat == TFA.Enum.STATUS_PUMP then
				issighting = false
			end
		end

		local sightsMode = self2.GetStatL(self, "Sights_Mode")
		local sprintMode = self2.GetStatL(self, "Sprint_Mode")
		local walkMode = self2.GetStatL(self, "Walk_Mode")
		local customizeMode = self2.GetStatL(self, "Customize_Mode")

		if old_iron_sights_final ~= issighting and sightsMode == TFA.Enum.LOCOMOTION_LUA then -- and stat == TFA.Enum.STATUS_IDLE then
			self:SetNextIdleAnim(-1)
		end

		local smi = (sightsMode ~= TFA.Enum.LOCOMOTION_LUA)
			and old_iron_sights_final ~= issighting

		local spi = (sprintMode ~= TFA.Enum.LOCOMOTION_LUA)
			and self2.sprinting_updated

		local wmi = (walkMode ~= TFA.Enum.LOCOMOTION_LUA)
			and self2.walking_updated

		local cmi = (customizeMode ~= TFA.Enum.LOCOMOTION_LUA)
			and self:GetCustomizeUpdated()

		self:SetCustomizeUpdated(false)

		if
			(smi or spi or wmi or cmi) and
			(self:GetStatus() == TFA.Enum.STATUS_IDLE or
				(self:GetStatus() == TFA.Enum.STATUS_SHOOTING and self:CanInterruptShooting()))
			and not self:GetReloadLoopCancel()
		then
			local toggle_is = old_iron_sights_final ~= issighting

			if issighting and self:GetSprinting() then
				toggle_is = true
			end

			local success, _ = self:Locomote(toggle_is and (sightsMode ~= TFA.Enum.LOCOMOTION_LUA), issighting, spi, issprinting, wmi, iswalking, cmi, self:GetCustomizing())

			if not success and (toggle_is and smi or spi or wmi or cmi) then
				self:SetNextIdleAnim(-1)
			end
		end

		self:SetIronSightsOldFinal(issighting)

		return userstatus, issighting
	end

	-- disable fire mode/safety toggling
	function SWEP:ProcessFireMode()
		return
	end

	function SWEP:TranslateFOV(fov)
		local self2 = self:GetTable()

		self2.LastTranslatedFOV = fov

		local retVal = hook.Run("TFA_PreTranslateFOV", self, fov)

		if retVal then return retVal end

		self2.CorrectScopeFOV(self)

		local ironprog = self2.IronSightsProgressPredicted or self2.GetIronSightsProgress(self)
		if self2.GetStatL(self, "Secondary.OwnerFOVUseThreshold", self2.GetStatL(self, "Scoped")) then
			local threshold = math.min(self2.GetStatL(self, "Secondary.OwnerFOVThreshold", self2.GetStatL(self, "ScopeOverlayThreshold")), 0.999999)

			ironprog = ironprog < threshold and 0 or math.max(ironprog - threshold, 0) / (1 - threshold)
		end

		local nfov = l_Lerp(ironprog, fov, fov * math.min(self2.GetStatL(self, "Secondary.OwnerFOV") / 90, 1))

		local ret = nfov
		if CLIENT then
			if GetConVar("tm_customfov_sprint"):GetInt() == 1 then
				ret = l_Lerp(self2.SprintProgressPredicted or self2.GetSprintProgress(self), nfov, nfov + self2.GetStatL(self, "SprintFOVOffset", 5))
			end
		end

		if self2.OwnerIsValid(self) and not self2.IsMelee then
			local vpa = self:GetOwner():GetViewPunchAngles()

			ret = ret + math.abs(vpa.p) / 4 + math.abs(vpa.y) / 4 + math.abs(vpa.r) / 4
		end

		ret = hook.Run("TFA_TranslateFOV", self, ret) or ret

		return ret
	end
end )

if CLIENT then
    -- forcefully disable the use of the TFA crosshair
    hook.Add("TFA_DrawCrosshair", "DisableTFACrosshair", function(ply) return true end)

	-- force users selected FOV when spectating
	hook.Add("TFA_TranslateFOV", "DisableClientFOVChange", function(ply)
		local localPly = LocalPlayer()
		if localPly:Alive() then return end
		if localPly:GetInfoNum("tm_customfov", 0) == 1 then
			return localPly:GetInfoNum("tm_customfov_value", 100)
		else
			return localPly:GetInfoNum("fov_desired", 75)
		end
	end)
end