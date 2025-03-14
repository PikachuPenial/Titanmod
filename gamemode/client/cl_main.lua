timer.Create("cleanMap", 15, 0, function()
	RunConsoleCommand("r_cleardecals")
end)

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