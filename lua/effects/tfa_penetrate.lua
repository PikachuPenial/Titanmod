local PenetColor = Color(255, 255, 255, 255)
local PenetMat = Material("trails/smoke")
local PenetMat2 = Material("effects/yellowflare")
local cv_gv = GetConVar("sv_gravity")
local cv_sl = GetConVar("cl_tfa_fx_impact_ricochet_sparklife")

local DFX = {
	["AR2Tracer"] = true,
	["Tracer"] = true,
	["GunshipTracer"] = true,
	["GaussTracer"] = true,
	["AirboatGunTracer"] = true,
	["AirboatGunHeavyTracer"] = true
}

function EFFECT:Init(data)
	self.StartPos = data:GetOrigin()
	self.Dir = data:GetNormal()
	self.Dir:Normalize()
	self.Len = 32
	self.EndPos = self.StartPos + self.Dir * self.Len
	self.LifeTime = 0.75
	self.DieTime = CurTime() + self.LifeTime
	self.Thickness = 1
	self.Grav = Vector(0, 0, -cv_gv:GetFloat())
	self.PartMult = data:GetRadius()
	self.SparkLife = cv_sl:GetFloat()
	self.WeaponEnt = data:GetEntity()
	if not IsValid(self.WeaponEnt) then return end

	if self.WeaponEnt.TracerPCF then
		local traceres = util.QuickTrace(self.StartPos, self.Dir * 9999999, Entity(math.Round(data:GetScale())))
		self.EndPos = traceres.HitPos or self.StartPos
		local efn = self.WeaponEnt.TracerName
		local spos = self.StartPos
		local cnt = math.min(math.Round(data:GetMagnitude()), 6000)

		timer.Simple(cnt / 1000000, function()
			TFA.ParticleTracer(efn, spos, traceres.HitPos or spos, false)
		end)

		return
	end

	local tn = self.WeaponEnt.BulletTracerName

	if tn and tn ~= "" and not DFX[tn] then
		local fx = EffectData()
		fx:SetStart(self.StartPos)
		local traceres = util.QuickTrace(self.StartPos, self.Dir * 9999999, Entity(math.Round(data:GetScale())))
		self.EndPos = traceres.HitPos or self.StartPos
		fx:SetOrigin(self.EndPos)
		fx:SetEntity(self.WeaponEnt)
		fx:SetMagnitude(1)
		util.Effect(tn, fx)
		SafeRemoveEntityDelayed(self, 0)
		return
	else
		local emitter = ParticleEmitter(self.StartPos)

		local part = emitter:Add("effects/yellowflare", self.StartPos)
		part:SetStartAlpha(225)
		part:SetStartSize(1)
		part:SetDieTime(self.LifeTime / 5)
		part:SetEndSize(0)
		part:SetEndAlpha(0)
		part:SetRoll(math.Rand(0, 360))
		part:SetColor(200, 200, 200)
		part = emitter:Add("effects/yellowflare", self.StartPos)
		part:SetStartAlpha(255)
		part:SetStartSize(1.5 * self.PartMult)
		part:SetDieTime(self.LifeTime / 6)
		part:SetEndSize(0)
		part:SetEndAlpha(0)
		part:SetRoll(math.Rand(0, 360))
		part:SetColor(200, 200, 200)
		emitter:Finish()
	end
end

function EFFECT:Think()
	if self.DieTime and (CurTime() > self.DieTime) then return false end

	return true
end

function EFFECT:Render()
end