-- removing unneccessary server hook
if SERVER then
	hook.Add("Initialize", "SVHookRemoval", function() if timer.Exists("CheckHookTimes") then timer.Remove("CheckHookTimes") end end)
end

if CLIENT then
	-- optimized indexs
	local function RWEnt()
		local M_Entity = FindMetaTable("Entity")

		local E_GetTable = M_Entity.GetTable

		local val
		local et
		function M_Entity:__index(key)
			val = M_Entity[key]
			if val != nil then return val end

			et = E_GetTable(self)
			if et then
				return et[key]
			end
		end
	end

	local function RWPly()
		local M_Player = FindMetaTable("Player")
		local M_Entity = FindMetaTable("Entity")

		local E_GetTable = M_Entity.GetTable

		local val
		local pt
		function M_Player:__index(key)
			val = M_Player[key]
			if val != nil then return val end

			val = M_Entity[key]
			if val != nil then return val end

			pt = E_GetTable(self)
			if pt then
				return pt[key]
			end
		end
	end

	local function RWWep()
		local M_Weapon = FindMetaTable("Weapon")
		local M_Entity = FindMetaTable("Entity")

		local E_GetTable = M_Entity.GetTable
		local E_GetOwner = M_Entity.GetOwner

		local val
		local wt
		function M_Weapon:__index(key)
			val = M_Weapon[key]
			if val != nil then return val end

			val = M_Entity[key]
			if val != nil then return val end

			if key == "Owner" then return E_GetOwner(self) end

			wt = E_GetTable(self)
			if wt then
				return wt[key]
			end
		end
	end

	RWEnt()
	RWPly()
	RWWep()

	-- removing unneccessary client hooks
	hook.Add("InitPostEntity", "CLHookRemoval", function()
		hook.Remove("RenderScreenspaceEffects", "RenderColorModify")
		hook.Remove("RenderScreenspaceEffects", "RenderBloom")
		hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
		hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
		hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
		hook.Remove("RenderScreenspaceEffects", "RenderSobel")
		hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
		hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
		hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
		hook.Remove("RenderScene", "RenderStereoscopy")
		hook.Remove("RenderScene", "RenderSuperDoF")
		hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
		hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
		hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
		hook.Remove("PostRender", "RenderFrameBlend")
		hook.Remove("PreRender", "PreRenderFrameBlend")
		hook.Remove("Think", "DOFThink")
		hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
		hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
		hook.Remove("PostDrawEffects", "RenderWidgets")
		hook.Remove("PostDrawEffects", "RenderHalos")
	end)

	-- remove widget code every tick
	local function CLTickRemoval(ent)
		if ent:IsWidget() then
			hook.Add("PlayerTick", "TickWidgets", function(pl, mv) widgets.PlayerTick(pl, mv) end)
			hook.Remove("OnEntityCreated", "WidgetCreated")
		end
	end
	hook.Add("OnEntityCreated", "WidgetCreated", CLTickRemoval)
end

-- force multicore for clients
if CLIENT then
	hook.Add("InitPostEntity", "CLMulticore", function()
		timer.Simple(3, function() -- just in case
			RunConsoleCommand("gmod_mcore_test", "1")
			RunConsoleCommand("mat_queue_mode", "-1")
			RunConsoleCommand("cl_threaded_bone_setup", "1")
			RunConsoleCommand("r_threaded_client_shadow_manager", "1")
			RunConsoleCommand("r_threaded_particles", "1")
			RunConsoleCommand("r_threaded_renderables", "1")
			RunConsoleCommand("r_queued_ropes", "1")
			RunConsoleCommand("studio_queue_mode", "1")
		end)
	end)
end

-- map optimization
hook.Add("InitPostEntityMap", "MapOptimization", function()
	local shadowexists = 0

	for _, ent in pairs(ents.FindByClass("shadow_control")) do
		ent:SetKeyValue("disableallshadows", 1)
		shadowexists = 1
	end

	if shadowexists == 0 then
		local ent = ents.Create("shadow_control")
		if ent:IsValid() then
			ent:SetKeyValue("disableallshadows", 1)
			shadowexists = 1
		end
	end

	for _, ent in pairs(ents.FindByClass("func_precipitation")) do ent:Remove() end
	for _, ent in pairs(ents.FindByClass("func_smokevolume")) do ent:Remove() end
end)

-- prevent model related crashes
hook.Add("PlayerInitialSpawn", "CLPreventCrash", function(ply)
	ply:SendLua("RunConsoleCommand('r_drawmodeldecals', 0)")
	ply:SendLua("RunConsoleCommand('r_maxmodeldecal', 50)")
end)

-- optimized surface and draw functions
if SERVER or SurfaceRewrite then return end
SurfaceRewrite = true

local function empty() end

local surface = surface
local Color = Color
local color_white = color_white

local TEXT_ALIGN_CENTER	= 1
local TEXT_ALIGN_RIGHT = 2
local TEXT_ALIGN_BOTTOM	= 4

local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetTextPos = surface.SetTextPos
local surface_SetTextColor = surface.SetTextColor
local surface_DrawText = surface.DrawText
local surface_SetTexture = surface.SetTexture
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_GetTextureID = surface.GetTextureID

local string_sub = string.sub

local math_ceil = math.ceil

local Tex_Corner8 = surface_GetTextureID("gui/corner8")
local Tex_Corner16 = surface_GetTextureID("gui/corner16")
local Tex_white = surface_GetTextureID("vgui/white")

local CachedFontHeights = {}
local function draw_GetFontHeight(font)
	if CachedFontHeights[font] then return CachedFontHeights[font] end

	surface_SetFont(font)
	local _, h = surface_GetTextSize("W")
	CachedFontHeights[font] = h

	return h
end

local function draw_SimpleText(text, font, x, y, colour, xalign, yalign)
	surface_SetFont(font)

	if xalign == TEXT_ALIGN_CENTER then
		local w, _ = surface_GetTextSize(text)
		x = x - w / 2
	elseif xalign == TEXT_ALIGN_RIGHT then
		local w, _ = surface_GetTextSize(text)
		x = x - w
	end

	if yalign == TEXT_ALIGN_CENTER then
		local h = draw_GetFontHeight(font)
		y = y - h / 2
	elseif yalign == TEXT_ALIGN_BOTTOM then
		local h = draw_GetFontHeight(font)
		y = y - h
	end

	surface_SetTextPos(x, y)
	if colour then surface_SetTextColor(colour.r, colour.g, colour.b, colour.a) else surface_SetTextColor(255, 255, 255, 255) end
	surface_DrawText(text)
end

local function draw_DrawText(text, font, x, y, colour, xalign )
	local curX = x
	local curY = y
	local curString = ""

	surface_SetFont(font)
	local sizeX, lineHeight = surface_GetTextSize("\n")

	for i = 1, #text do
		local ch = string_sub(text, i, i)
		if ch == "\n" then
			if #curString > 0 then draw_SimpleText(curString, font, curX, curY, colour, xalign) end

			curY = curY + lineHeight / 2
			curX = x
			curString = ""
		elseif ch == "\t" then
			if #curString > 0 then draw_SimpleText(curString, font, curX, curY, colour, xalign) end
			local tmpSizeX, _ =  surface_GetTextSize(curString)
			curX = math_ceil( (curX + tmpSizeX) / 50 ) * 50
			curString = ""
		else
			curString = curString .. ch
		end
	end
	if #curString > 0 then draw_SimpleText(curString, font, curX, curY, colour, xalign) end
end

local function draw_RoundedBox(bordersize, x, y, w, h, color)
	surface_SetDrawColor(color)

	surface_DrawRect(x + bordersize, y, w - bordersize * 2, h)
	surface_DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
	surface_DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)

	surface_SetTexture(bordersize > 8 and Tex_Corner16 or Tex_Corner8)
	surface_DrawTexturedRectRotated(x + bordersize / 2 , y + bordersize / 2, bordersize, bordersize, 0)
	surface_DrawTexturedRectRotated(x + w - bordersize / 2 , y + bordersize / 2, bordersize, bordersize, 270)
	surface_DrawTexturedRectRotated(x + bordersize / 2 , y + h -bordersize / 2, bordersize, bordersize, 90)
	surface_DrawTexturedRectRotated(x + w - bordersize / 2 , y + h - bordersize / 2, bordersize, bordersize, 180)
end

local function draw_Text(tab)
	local text = tab.text
	local font = tab.font or "DermaDefault"
	local x = tab.pos[1] or 0
	local y = tab.pos[2] or 0
	local xalign = tab.xalign
	local yalign = tab.yalign

	surface_SetFont(font)

	if xalign == TEXT_ALIGN_CENTER then
		local w, _ = surface_GetTextSize(text)
		x = x - w / 2
	elseif xalign == TEXT_ALIGN_RIGHT then
		local w, _ = surface_GetTextSize(text)
		x = x - w
	end

	if yalign == TEXT_ALIGN_CENTER then
		local h = draw_GetFontHeight(font)
		y = y - h / 2
	end

	surface_SetTextPos(x, y)

	if tab.color then surface_SetTextColor(tab.color) else surface_SetTextColor(255, 255, 255, 255) end
	surface_DrawText(text)
end

function draw.WordBox(bordersize, x, y, text, font, color, fontcolor)
	surface_SetFont(font)
	local w, h = surface_GetTextSize(text)

	draw_RoundedBox(bordersize, x, y, w + bordersize * 2, h + bordersize * 2, color)

	surface_SetTextColor(fontcolor.r, fontcolor.g, fontcolor.b, fontcolor.a)
	surface_SetTextPos(x + bordersize, y + bordersize)
	surface_DrawText(text)
end

function draw.TextShadow(tab, distance, alpha)

	alpha = alpha or 200

	local color = tab.color
	local pos 	= tab.pos
	tab.color = Color(0, 0, 0, alpha)
	tab.pos = {pos[1] + distance, pos[2] + distance}

	draw_Text(tab)

	tab.color = color
	tab.pos = pos

	draw_Text(tab)
end

function draw.TexturedQuad(tab)
	surface_SetTexture(tab.texture)
	surface_SetDrawColor(tab.color or color_white)
	surface_DrawTexturedRect(tab.x, tab.y, tab.w, tab.h)
end

function draw.NoTexture()
	surface_SetTexture(Tex_white)
end

function draw.RoundedBoxEx(bordersize, x, y, w, h, color, a, b, c, d)
	surface_SetDrawColor(color)

	-- Draw as much of the rect as we can without textures
	surface_DrawRect(x + bordersize, y, w - bordersize * 2, h)
	surface_DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
	surface_DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)

	surface_SetTexture(bordersize > 8 and Tex_Corner16 or Tex_Corner8)

	if a then
		surface_DrawTexturedRectRotated(x + bordersize / 2 , y + bordersize / 2, bordersize, bordersize, 0)
	else
		surface_DrawRect(x, y, bordersize, bordersize)
	end

	if b then
		surface_DrawTexturedRectRotated(x + w - bordersize / 2 , y + bordersize / 2, bordersize, bordersize, 270)
	else
		surface_DrawRect(x + w - bordersize, y, bordersize, bordersize)
	end

	if c then
		surface_DrawTexturedRectRotated(x + bordersize / 2 , y + h -bordersize / 2, bordersize, bordersize, 90)
	else
		surface_DrawRect(x, y + h - bordersize, bordersize, bordersize)
	end

	if d then
		surface_DrawTexturedRectRotated(x + w - bordersize / 2 , y + h - bordersize / 2, bordersize, bordersize, 180)
	else
		surface_DrawRect(x + w - bordersize, y + h - bordersize, bordersize, bordersize)
	end
end

function draw.SimpleTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour)
	local steps = (outlinewidth * 2) / 3
	if steps < 1 then steps = 1 end

	for _x=-outlinewidth, outlinewidth, steps do
		for _y=-outlinewidth, outlinewidth, steps do
			draw_SimpleText(text, font, x + _x, y + _y, outlinecolour, xalign, yalign)
		end
	end

	draw_SimpleText(text, font, x, y, colour, xalign, yalign)
end

draw.GetFontHeight = draw_GetFontHeight
draw.SimpleText = draw_SimpleText
draw.DrawText = draw_DrawText
draw.RoundedBox = draw_RoundedBox
draw.Text = draw_Text

local SpeakFlexes = {
	["jaw_drop"] = true,
	["right_part"] = true,
	["left_part"] = true,
	["right_mouth_drop"] = true,
	["left_mouth_drop"] = true
}
local GESTURE_SLOT_VCD = GESTURE_SLOT_VCD
local ACT_GMOD_IN_CHAT = ACT_GMOD_IN_CHAT
hook.Add("Initialize", "InstallFunctions", function()
	function GAMEMODE:MouthMoveAnimation(pl)
		if pl:IsSpeaking() then
			pl.m_bWasSpeaking = true

			local FlexNum = pl:GetFlexNum() - 1
			if FlexNum <= 0 then return end
			local weight = math.Clamp(pl:VoiceVolume() * 2, 0, 2)
			for i = 0, FlexNum - 1 do
				if SpeakFlexes[pl:GetFlexName(i)] then
					pl:SetFlexWeight(i, weight)
				end
			end
		elseif pl.m_bWasSpeaking then
			pl.m_bWasSpeaking = false

			local FlexNum = pl:GetFlexNum() - 1
			if FlexNum <= 0 then return end
			for i = 0, FlexNum - 1 do
				if SpeakFlexes[pl:GetFlexName(i)] then
					pl:SetFlexWeight(i, 0)
				end
			end
		end
	end

	function GAMEMODE:GrabEarAnimation(pl)
		if pl:IsTyping() then
			pl.ChatGestureWeight = math.Approach(pl.ChatGestureWeight or 0, 1, FrameTime() * 5)
		elseif pl.ChatGestureWeight and pl.ChatGestureWeight > 0 then
			pl.ChatGestureWeight = math.Approach(pl.ChatGestureWeight, 0, FrameTime() * 5)
			if pl.ChatGestureWeight == 0 then
				pl.ChatGestureWeight = nil
			end
		end

		if pl.ChatGestureWeight then
			if pl:IsPlayingTaunt() then return end

			pl:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true)
			pl:AnimSetGestureWeight(GESTURE_SLOT_VCD, pl.ChatGestureWeight)
		end
	end
end)

drive.Move = empty
drive.FinishMove = empty
drive.StartMove = empty