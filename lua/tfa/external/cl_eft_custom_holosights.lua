TFA.EFTC = TFA.EFTC or {}

local useStencils = true

local function defineCanvas(ref)
	render.UpdateScreenEffectTexture()
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_REPLACE)
	render.SetStencilWriteMask(255)
	render.SetStencilTestMask(255)
	render.SetStencilReferenceValue(ref or 54)
end

local function drawOn()
	render.SetStencilCompareFunction(STENCIL_EQUAL)
end

local function stopCanvas()
	render.SetStencilEnable(false)
end

local CachedMaterials = {}

function TFA.EFTC.DrawHoloSight(wep, texture, parent, p, a, s)
	CachedMaterials[texture] = CachedMaterials[texture] or Material(texture, "noclamp nocull smooth")

	if wep.VMRedraw then return end
	wep.VMRedraw = true

	local model
	if isstring(parent) and wep.VElements[parent] and wep.VElements[parent].curmodel then
		model = wep.VElements[parent].curmodel
	end

	if useStencils and IsValid(model) then
		defineCanvas()

		render.SetBlend(0)
			model:DrawModel() -- we "draw" only parent model (for models without any attachments just use rtcircle model with 0 alpha as parent)
		render.SetBlend(1)

		drawOn()
	end

	render.OverrideDepthEnable(true, true)

	render.SetMaterial(CachedMaterials[texture])
	a = Angle(a)
	a:RotateAroundAxis(a:Right(), 90)
	render.DrawQuadEasy(p, a:Forward(), s * 2, s * 2, color_white, a.r + 90)

	render.OverrideDepthEnable(false, false)

	if useStencils and IsValid(model) then
		stopCanvas()
	end

	wep.VMRedraw = false
end

local sights = {}

function TFA.EFTC.GetHoloSightReticle(sighttype, rel)
	if isstring(sighttype) and sights[sighttype] then
		local data = table.Copy(sights[sighttype])
		data.rel = rel or sighttype
		data.yuri = true
		return data
	end

	return nil
end

function TFA.EFTC.AddHoloSightType(name, material, dist, up, size, bone)
	assert(name and material and dist and up and size)

	local tbl = sights[name] or {}
	tbl.type = "Quad"
	tbl.bone = bone or tbl.bone or "tag_reticle_attach"
	tbl.pos = Vector(dist, 0, up)
	tbl.angle = Angle(90, 0, 0)
	tbl.size = size
	tbl.draw_func_outer = function(wep, p, a, s) TFA.EFTC.DrawHoloSight(wep, material, name, p, a, s) end
	tbl.active = false

	sights[name] = tbl
end

hook.Add("TFAAttachmentsLoaded", "!TFA_EFTC_HoloSights", function()
	sights["debug"] = { type = "Quad", bone = "tag_reticle_attach", pos = Vector(0, 0, 0), angle = Angle(90, 0, 0), size = 0.5, draw_func_outer = function(wep,p,a,s) TFA.EFTC.DrawHoloSight(wep, "models/weapons/tfa_EFT/optics/mk4_crosshair", nil, p, a, s) end, active = true} -- adding this one manually

	if not render.SupportsPixelShaders_1_4() or not render.SupportsPixelShaders_2_0() or not render.SupportsVertexShaders_2_0() then
		print("[TFA EFTC] Your GPU does not support stencils - falling back to flat sights.") 

		useStencils = false

		TFA.EFTC.AddHoloSightType("sight_rmr", "models/weapons/tfa_eft/upgrades/sights/rmr/rmr_reticle", 0, 0, 0.15, "tag_reticle_attach")

		return
	end

	TFA.EFTC.AddHoloSightType("sight_rmr", "models/weapons/tfa_eft/upgrades/sights/rmr/rmr_reticle", 0, 0.065, 0.55, "tag_reticle_attach")
end)