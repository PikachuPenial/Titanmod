function GM:InitPostEntity()
	activeGamemode = GetGlobal2String("ActiveGamemode", "FFA")
	net.Start("PlayerInitialSpawn")
	net.SendToServer()
end

if GetConVar("tm_renderhands"):GetInt() == 0 then hook.Add("PreDrawPlayerHands", "DisableHandRendering", function() return true end) end

cvars.AddChangeCallback("tm_renderhands", function(convar_name, value_old, value_new)
    if value_new == "1" then
		hook.Remove("PreDrawPlayerHands", "DisableHandRendering")
	else
		hook.Add("PreDrawPlayerHands", "DisableHandRendering", function() return true end)
	end
end)

local blurMat = Material("pp/blurscreen")
function BlurPanel(panel, strength)

    surface.SetMaterial(blurMat)
    surface.SetDrawColor(255, 255, 255, 255)

    local blurX, blurY = panel:LocalToScreen(0, 0)

    for i = 0.33, 1, 0.33 do

        blurMat:SetFloat("$blur", strength * i)
        blurMat:Recompute()
        if (render) then render.UpdateScreenEffectTexture() end
        surface.DrawTexturedRect(blurX * -1, blurY * -1, ScrW(), ScrH())

    end

end

function UpdatePopOutPos(panel, sideH, sideV, x, y)
	if sideH == true then
		panel:SetX(math.Clamp(x + 15, 10, ScrW() - panel:GetWide() - 10))
	else
		panel:SetX(math.Clamp(x - panel:GetWide() - 15, 10, ScrW() - panel:GetWide() - 10))
	end

	if sideV == true then
		panel:SetY(math.Clamp(y + 15, 60, ScrH() - panel:GetTall() - 20))
	else
		panel:SetY(math.Clamp(y - panel:GetTall() + 15, 60, ScrH() - panel:GetTall() - 20))
	end
end

hook.Add("OnScreenSizeChanged", "ResChange", function()
	scrW, scrH = ScrW(), ScrH()

	center_x, center_y = ScrW() / 2, ScrH() / 2
	scale = center_y * (2 / 1080)
	UpdateFonts()
end)

-- damage indicator
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
local scale = center_y * (2 / 1080)
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

-- suppression
local buildupspeed = 4
local bloom_intensity = 0.5

local effect_amount = 0

local function readVectorUncompressed()
	local tempVec = Vector(0,0,0)
	tempVec.x = net.ReadFloat()
	tempVec.y = net.ReadFloat()
	tempVec.z = net.ReadFloat()
	return tempVec
end

net.Receive("suppression_fire_event", function(len)
	local src = readVectorUncompressed()
	local dir = readVectorUncompressed()
	local entity = net.ReadEntity()
	if entity == LocalPlayer() then return end

	local tr = util.TraceLine({
		start = src,
		endpos = src + dir * 100000,
		mask = CONTENTS_WINDOW + CONTENTS_SOLID + CONTENTS_AREAPORTAL + CONTENTS_MONSTERCLIP + CONTENTS_CURRENT_0
	})

	local distance_from_line, nearest_point, dist_along_the_line = util.DistanceToLine(tr.StartPos, tr.HitPos, LocalPlayer():GetPos())

	if LocalPlayer():Alive() and nearest_point:Distance(LocalPlayer():GetPos()) < 100 then
		effect_amount = math.Clamp(effect_amount + 0.08 * buildupspeed, 0, 0.5)
		sound.Play("bul_snap/supersonic_snap_" .. math.random(1,18) .. ".wav", nearest_point, 75, 100, 1)
		sound.Play("bul_flyby/subsonic_" .. math.random(1,27) .. ".wav", nearest_point, 75, 100, 1)
	end
end)

local started_effect = false
hook.Add("Think", "suppression_loop", function() 
	if effect_amount == 0 then
		if started_effect then
			started_effect = false
		end
	 	return
	end

	effect_amount = math.Clamp(effect_amount - 1 * FrameTime(), 0, 0.5)
	started_effect = true
end)

local bloom_lerp = 0
hook.Add("RenderScreenspaceEffects", "suppression_ApplySuppression", function()
	if effect_amount == 0 then return end

	bloom_lerp = Lerp(6 * FrameTime(), bloom_lerp, effect_amount * bloom_intensity)
	DrawBloom(0.30, bloom_lerp , 0.33, 4.5, 1, 0, 1, 1, 1)
end)

local m = Material("vignette/vignette")
local alphanew = 0
hook.Add("RenderScreenspaceEffects", "suppression_vignette", function()
	if effect_amount == 0 then return end

	alphanew = Lerp(6 * FrameTime(), alphanew, effect_amount)

	render.SetMaterial(m)
	m:SetFloat("$alpha", alphanew)

	render.DrawScreenQuad()
end)

hook.Add("PlayerInitialSpawn", "SetEffectOnSpawn", function(ply)
	effect_amount = 0
end)

-- custom viewmodel inertia
if CLIENT then
    local lastEyeAng = Angle(0, 0, 0)
    local lastAngDiff = Angle(0, 0, 0)
    local currentOffset = Angle(0, 0, 0)
    local moveOffset = Angle(0, 0, 0)
    local overshootDecay = 0

    local function ApplyAllOffsets(ply, pos, ang)
		local isAiming = (IsValid(weapon) and (type(weapon.GetIronSights) == "function" and weapon:GetIronSights())) or ply:KeyDown(IN_ATTACK2)

        if not IsValid(ply) or not ply:Alive() or isAiming then return pos, ang end

        local ft = FrameTime()

        local inertiaSpeed = 6
        local baseTilt     = 2.5
        local strafeTilt   = 3
        local overshootStr = 1.2

        local curEye = ply:EyeAngles()
        if lastEyeAng.p == 0 and lastEyeAng.y == 0 and lastEyeAng.r == 0 then
            lastEyeAng = curEye
            lastAngDiff = Angle(0, 0, 0)
        end

        local angDiff = curEye - lastEyeAng
        angDiff:Normalize()

        local targetCamOffset = Angle(-angDiff.p * baseTilt, 0, angDiff.y * baseTilt)

        local lastSpeed = math.max(math.abs(lastAngDiff.p), math.abs(lastAngDiff.y))
        local curSpeed  = math.max(math.abs(angDiff.p), math.abs(angDiff.y))
        local decel = lastSpeed - curSpeed

        if decel > 0.08 then
            local overshootP = -lastAngDiff.p * (overshootStr * 0.12)
            local overshootR =  lastAngDiff.y * (overshootStr * 0.12)
            overshootDecay = math.min(1, overshootDecay + decel * 4)
            targetCamOffset = targetCamOffset + Angle(overshootP * overshootDecay, 0, overshootR * overshootDecay)
        end

        if overshootDecay > 0 then
            overshootDecay = Lerp(ft * 4, overshootDecay, 0)
        end

        local safeSpeed = math.Clamp(ft * inertiaSpeed, 0, 100)
        currentOffset = LerpAngle(safeSpeed, currentOffset, targetCamOffset)

        lastEyeAng = curEye
        lastAngDiff = angDiff

        local mvRight = ply:KeyDown(IN_MOVERIGHT)
        local mvLeft  = ply:KeyDown(IN_MOVELEFT)

        local targetMoveRoll = 0

        if mvRight then
            targetMoveRoll = strafeTilt
        elseif mvLeft then
            targetMoveRoll = -strafeTilt
        else
            targetMoveRoll = 0
        end

        local vel = ply:GetVelocity()
        local speed2d = vel:Length2D()
        if speed2d > 5 and (mvRight or mvLeft) then
            local rightDir = ply:EyeAngles():Right()
            local rightDot = vel:Dot(rightDir) / speed2d
            targetMoveRoll = Lerp(0.5, targetMoveRoll, rightDot * strafeTilt)
        end

        moveOffset.r = Lerp(ft * 4, moveOffset.r, targetMoveRoll)

        ang:RotateAroundAxis(ang:Right(), currentOffset.p)
        local wep = ply:GetActiveWeapon()
        local rollOffset = currentOffset.r + moveOffset.r
        if IsValid(wep) and wep.ViewModelFlip then
            rollOffset = -rollOffset
        end
        ang:RotateAroundAxis(ang:Forward(), rollOffset)

        return pos, ang
    end

	hook.Add("CalcViewModelView", "ViewmodelInertia", function(weapon, vm, oldPos, oldAng, pos, ang)
		local ply = LocalPlayer()
		if not IsValid(ply) or not ply:Alive() then return end
		ApplyAllOffsets(ply, pos, ang)
	end)
end

-- custom screen shake
local lastExtraRecoilTime = 0
local shakeMult = 0.33
local shakeSpeed = 0.67

if CLIENT then
	local lastMagCapacity = 0
    local lastWeapon = nil

    local ExtraScreenShakeTime = 0
    local ExtraScreenShakeDuration = 0
    local ExtraScreenShakeStrength = 0
    local ExtraScreenShakeViewOffset = Angle(0, 0, 0)

    local function ApplyExtraRecoil(weapon)
        if not IsValid(weapon) or not weapon.IsTFAWeapon then return end

        local currentTime = CurTime()
        if currentTime - lastExtraRecoilTime < 0.05 then return end

        lastExtraRecoilTime = currentTime

        local kickUp = weapon.Primary.KickUp or 0
        local kickDown = weapon.Primary.KickDown or 0
        local kickHorizontal = weapon.Primary.KickHorizontal or 0
        local staticRecoilFactor = weapon.Primary.StaticRecoilFactor or 0
        local extraRecoilAmount = (kickUp + kickDown + kickHorizontal + staticRecoilFactor) * 2

		local rpm = weapon.Primary.RPM or 600
		local RPMDuration = math.min((60 / rpm) + 0.1, 0.2)

		ExtraScreenShakeDuration = RPMDuration * shakeSpeed
		ExtraScreenShakeStrength = (extraRecoilAmount / 2) * shakeMult

		ExtraScreenShakeTime = ExtraScreenShakeDuration
		ExtraScreenShakeViewOffset = Angle(0, 0, 0)
    end

    local function DetectExtraRecoilFiring()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end

		local weapon = ply:GetActiveWeapon()

        if not IsValid(weapon) or not weapon.IsTFAWeapon then
            lastMagCapacity = 0
            lastWeapon = nil
            return
        end

        local currentMagCapacity = weapon:Clip1() or 0

        if weapon ~= lastWeapon then
            lastMagCapacity = currentMagCapacity
            lastWeapon = weapon
            return
        end

        if currentMagCapacity < lastMagCapacity then
            ApplyExtraRecoil(weapon)
            lastMagCapacity = currentMagCapacity
        else
            lastMagCapacity = currentMagCapacity
        end

        if ExtraScreenShakeTime > 0 then
            ExtraScreenShakeTime = math.max(0, ExtraScreenShakeTime - FrameTime())

            local timeProgress = ExtraScreenShakeTime / ExtraScreenShakeDuration
            local rollAngle = math.sin(timeProgress * math.pi * 4) * ExtraScreenShakeStrength * timeProgress

            ExtraScreenShakeViewOffset = Angle(0, 0, rollAngle)
        else
            ExtraScreenShakeViewOffset = Angle(0, 0, 0)
        end
    end

    hook.Add("CalcView", "TFA_ExtraScreenShake_View", function(ply, origin, angles, fov, znear, zfar)
        if ExtraScreenShakeViewOffset.roll ~= 0 then
            angles:Add(ExtraScreenShakeViewOffset)
        end
    end)

    timer.Create("ExtraRecoilFireDetectionLoop", 0.001, 0, DetectExtraRecoilFiring)
end 