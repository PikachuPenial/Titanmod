include("shared.lua")
include("sh_movement.lua")
include("cl_hud.lua")
include("cl_scoreboard.lua")
include("cl_menu.lua")

-- Used to clear the map of decals (blood, bullet impacts, etc) every 15 seconds, helps people with shitty computers
timer.Create("cleanMap", 15, 0, function()
	RunConsoleCommand("r_cleardecals")
end)

function GM:InitPostEntity()
	activeGamemode = GetGlobal2String("ActiveGamemode", "FFA")
end

function UpdateFonts()
	surface.CreateFont("GunPrintName", {
		font = "Arial",
		extended = false,
		size = 56,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("MainMenuLoadoutWeapons", {
		font = "Arial",
		extended = false,
		size = 26,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("MainMenuDescription", {
		font = "Arial",
		extended = false,
		size = 24,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("MainMenuTitle", {
		font = "Arial",
		extended = false,
		size = 45,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("MatchEndText", {
		font = "Arial",
		extended = false,
		size = 180,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("QuoteText", {
		font = "Tahoma",
		extended = false,
		size = 22,
		weight = 200,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = true,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = true,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("AmmoCountESmall", {
		font = "Arial",
		extended = false,
		size = 48,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("AmmoCountSmall", {
		font = "Arial",
		extended = false,
		size = 96,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("OptionsHeader", {
		font = "Arial",
		extended = false,
		size = 64,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("Health", {
		font = "Tahoma",
		extended = false,
		size = 30,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("StreakText", {
		font = "Tahoma",
		extended = false,
		size = 22,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("CaliberText", {
		font = "Tahoma",
		extended = false,
		size = 18,
		weight = 550,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("PlayerNotiName", {
		font = "Arial",
		extended = false,
		size = 52,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("SettingsLabel", {
		font = "Arial",
		extended = false,
		size = 38,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )


	surface.CreateFont("HUD_GunPrintName", {
		font = GetConVar("tm_hud_font"):GetString(),
		extended = false,
		size = 56,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("HUD_AmmoCount", {
		font = GetConVar("tm_hud_font"):GetString(),
		extended = false,
		size = 128,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("HUD_WepNameKill", {
		font = GetConVar("tm_hud_font"):GetString(),
		extended = false,
		size = 28,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("HUD_Health", {
		font = GetConVar("tm_hud_font"):GetString(),
		extended = false,
		size = 30,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("HUD_StreakText", {
		font = GetConVar("tm_hud_font"):GetString(),
		extended = false,
		size = 22,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("HUD_PlayerNotiName", {
		font = GetConVar("tm_hud_font"):GetString(),
		extended = false,
		size = 52,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )

	surface.CreateFont("HUD_PlayerDeathName", {
		font = GetConVar("tm_hud_font"):GetString(),
		extended = false,
		size = 36,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
end
UpdateFonts()
cvars.AddChangeCallback("tm_hud_font", function(convar_name, value_old, value_new) UpdateFonts() end)
hook.Add("OnScreenSizeChanged", "ResChange", function()
	scrW, scrH = ScrW(), ScrH()

	center_x, center_y = ScrW() / 2, ScrH() / 2
	scale = center_y * (2 / 1080)
	UpdateFonts()
end)

hook.Add("PreRegisterSWEP", "TitanmodBob", function(swep, class)
	-- Weapon bob
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

		-- Multipliers
		breathIntensity = breathIntensitySmooth * gunbob_intensity * 0.525
		walkIntensity = walkIntensitySmooth * gunbob_intensity * 1.45

		-- Breathing / walking while ADS
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

		-- Constant offset
		pos:Add(riLocal * walkVec.x * flip_v)
		pos:Add(fwLocal * walkVec.y)
		pos:Add(upLocal * walkVec.z)

		-- Jumping
		local trigX = -math.Clamp(zVelocitySmooth / 200, -1, 1) * math.pi / 2
		local jumpIntensity = (3 + math.Clamp(math.abs(zVelocitySmooth) - 100, 0, 200) / 200 * 4) * (1 - (self2.IronSightsProgressUnpredicted or self:GetIronSightsProgress()) * 0.8)
		pos:Add(ri * math.sin(trigX) * scale_r * 0.1 * jumpIntensity * flip_v * 0.25)
		pos:Add(-up * math.sin(trigX) * scale_r * 0.1 * jumpIntensity * 0.25)
		ang:RotateAroundAxis(ang:Forward(), math.sin(trigX) * scale_r * jumpIntensity * flip_v * 0.25)

		-- Rolling with horizontal motion
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
end )

hook.Add("PreRegisterSWEP", "TitanmodSway", function(swep, class)
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

		-- Modify position/angle
		positionCompensation = 0.2 + 0.2 * ((self2.IronSightsProgressUnpredicted or self:GetIronSightsProgress()) or 0)
		pos:Add(-motion.y * positionCompensation * 0.66 * fac * ang:Right() * flipFactor) -- Compensate position for yaw
		pos:Add(-motion.p * positionCompensation * fac * ang:Up()) -- Compensate position for pitch
		ang:RotateAroundAxis(ang:Right(), motion.p * fac)
		ang:RotateAroundAxis(ang:Up(), -motion.y * 0.66 * fac * flipFactor)
		ang:RotateAroundAxis(ang:Forward(), counterMotion.r * 0.5 * fac * flipFactor)

		return pos, ang
	end
end )

-- Damage indicator
local indmat = Material("materials/ttt_dmgdirect/indicator.png", "mips smooth")
indmat:SetInt("$flags", 16 + 32 + 128)

local cvarname = "tm_hud_dmgindicator"
local enabled = GetConVar("tm_hud_dmgindicator"):GetBool()
local red, green, blue, alpha = GetConVar("tm_hud_dmgindicator_color_r"):GetInt(), GetConVar("tm_hud_dmgindicator_color_g"):GetInt(), GetConVar("tm_hud_dmgindicator_color_b"):GetInt(), GetConVar("tm_hud_dmgindicator_opacity"):GetInt()

cvars.AddChangeCallback(cvarname, function(name, old, new)
	enabled = tonumber(new) == 1
end)
cvars.AddChangeCallback("tm_hud_dmgindicator_color_r", function(name, old, new)
	red = tonumber(new)
end)
cvars.AddChangeCallback("tm_hud_dmgindicator_color_g", function(name, old, new)
	green = tonumber(new)
end)
cvars.AddChangeCallback("tm_hud_dmgindicator_color_b", function(name, old, new)
	blue = tonumber(new)
end)
cvars.AddChangeCallback("tm_hud_dmgindicator_opacity", function(name, old, new)
	alpha = tonumber(new)
end)

local localply = LocalPlayer()
hook.Add("InitPostEntity", "InitPostEntity", function()
	localply = LocalPlayer()
end)

local head, tail
local pool_size, pool = 0
local RealTime = RealTime
net.Receive("DMGIndicator", function()
	if not enabled then return end

	local len = net.ReadUInt(10) / 1023 * 1024
	local pos = localply:EyePos()
	for i = 1, 3 do pos[i] = pos[i] - (net.ReadUInt(10) / (1023 * 0.5) - 1) * len end

	local ind = tail
	local push
	if pool then
		push = pool
		pool = push.nxtpool
		pool_size = pool_size - 1
	else
		push = {0, 0, 0}
	end

	push.birth = RealTime()
	push.dmg = net.ReadUInt(8) / 255
	push[1], push[2], push[3] = pos.x, pos.y, pos.z
	tail = push

	if ind then
		ind.nxt = tail
	else
		head = tail
	end
end)

local SetMaterial, SetDrawColor, DrawTexturedRectRotated = surface.SetMaterial, surface.SetDrawColor, surface.DrawTexturedRectRotated
local min, max, atan2, sin, cos = math.min, math.max, math.atan2, math.sin, math.cos
hook.Add("HUDPaint", "DamageIndicator", function()
	if not head then return end
	if not (IsValid(localply) and localply:Alive()) then
		local ind = head
		head, tail = nil, nil

		::clear::

		if pool_size < 8 then
			ind.nxtpool = pool
			pool = ind
			pool_size = pool_size + 1
		else
			ind.nxtpool = nil
		end

		local nxt = ind.nxt
		if nxt then
			ind.nxt = nil
			ind = nxt
			goto clear
		end
		return
	end

	local realtime = RealTime()

	local eyepos = localply:EyePos()
	local ex, ey, ez = eyepos[1], eyepos[2], eyepos[3]
	local eyeang = localply:EyeAngles()
	local epit, eyaw = eyeang[1], (eyeang[2] - 180) * 0.017453292519943

	SetMaterial(indmat)
	local ind, prev = head

	::loop::

	local lifetime = realtime - ind.birth
	local dmg = ind.dmg
	local max_lifetime = 1 + 1 * dmg
	local nxt = ind.nxt

	if lifetime > max_lifetime then
		if pool_size < 8 then
			ind.nxtpool = pool
			pool = ind
			pool_size = pool_size + 1
		else
			ind.nxtpool = nil
		end

		ind.nxt = nil
		prev, ind = ind, prev

		if prev == head then
			head = nxt
			if not nxt then
				tail = nil
				return
			end
		else
			ind.nxt = nxt
		end
	else
		local lifeperc = lifetime / max_lifetime

		SetDrawColor(red, green, blue, lifeperc > (2 / 3) and alpha * (3 - 3 * lifeperc) or alpha)
		local x, y, z = ex - ind[1], ey - ind[2], ez - ind[3]
		local dist2dsq = x * x + y * y
		local dist3dsq = dist2dsq + z * z
		local yaw = atan2(y, x) - eyaw
		local pitch = (
			180 - epit + atan2(z, dist2dsq ^ 0.5) * 57.295779513082
		) % 360 - 180
		local w = dmg < 0.2 and 8 + 120 * dmg or 16 + 80 * dmg
		local h = 80 + 64 * min(max(pitch * (-1 / 90), -1), 1)
		local radius = 64 + 96 * min(dist3dsq ^ 0.5 * (1 / 1024), 1) + h * (425 / 512 * 0.5) + (lifetime < 0.1 and 320 * (0.1 - lifetime) or 0)
		DrawTexturedRectRotated(center_x - radius * sin(yaw) * scale, center_y - radius * cos(yaw) * scale, w * scale, h * scale * (512 / 425), yaw * 57.295779513082)
	end
	prev, ind = ind, nxt
	if ind then
		goto loop
	end
end)

local length = 0.4
local ease = 0.25
local amount = 60

hook.Add("PreGamemodeLoaded", "SmoothScrolling", function()
	local function sign(num)
		return num > 0
	end

	local function getBiggerPos(signOld, signNew, old, new)
		if signOld != signNew then return new end
		if signNew then
			return math.max(old, new)
		else
			return math.min(old, new)
		end
	end

	local dermaCtrs = vgui.GetControlTable("DVScrollBar")
	local tScroll = 0
	local newerT = 0

	function dermaCtrs:AddScroll(dlta)
		self.Old_Pos = nil
		self.Old_Sign = nil

		local OldScroll = self:GetScroll()
		dlta = dlta * amount

		local anim = self:NewAnimation(length, 0, ease)
		anim.StartPos = OldScroll
		anim.TargetPos = OldScroll + dlta + tScroll
		tScroll = tScroll + dlta

		local ctime = RealTime()
		local doing_scroll = true
		newerT = ctime

		anim.Think = function(anim, pnl, fraction)
			local nowpos = Lerp(fraction, anim.StartPos, anim.TargetPos)
			if ctime == newerT then
				self:SetScroll(getBiggerPos(self.Old_Sign, sign(dlta), self.Old_Pos, nowpos))
				tScroll = tScroll - (tScroll * fraction)
			end
			if doing_scroll then
				self.Old_Sign = sign(dlta)
				self.Old_Pos = nowpos
			end
			if ctime != newerT then doing_scroll = false end
		end

		return math.Clamp(self:GetScroll() + tScroll, 0, self.CanvasSize) != self:GetScroll()
	end

	derma.DefineControl("DVScrollBar", "Smooth Scrollbar", dermaCtrs, "Panel")
end)

-- Forcefully disable the use of the TFA crosshair
hook.Add("TFA_DrawCrosshair", "DisableTFACrosshair", function(ply)
    return true
end)