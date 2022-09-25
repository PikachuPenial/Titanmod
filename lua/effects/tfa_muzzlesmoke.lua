local ang
local limit_particle_cv = GetConVar( "cl_tfa_fx_muzzlesmoke_limited" )
local SMOKEDELAY = 0.5 -- 0.385  

function EFFECT:Init(data)
	self.WeaponEnt = data:GetEntity()
	
	if not IsValid(self.WeaponEnt) then return end
	
	self.WeaponEntOG = self.WeaponEnt
	
	if limit_particle_cv:GetBool() and self.WeaponEnt:GetOwner() ~= LocalPlayer() then return end

	self.Attachment = data:GetAttachment()
	
	local smoketrail = "muzzle_smoke_trail"
	local delay = self.WeaponEnt.GetStat and self.WeaponEnt:GetStat("SmokeDelay") or self.WeaponEnt.SmokeDelay

	if self.WeaponEnt.SmokeParticle then
		smoketrail = self.WeaponEnt.SmokeParticle
	end

	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)

	if IsValid(self.WeaponEnt:GetOwner()) then
		if self.WeaponEnt:GetOwner() == LocalPlayer() then
			if not self.WeaponEnt:IsFirstPerson() then
				ang = self.WeaponEnt:GetOwner():EyeAngles()
				ang:Normalize()
				self.Forward = ang:Forward()
			else
				self.WeaponEnt = self.WeaponEnt:GetOwner():GetViewModel()
			end
		else
			ang = self.WeaponEnt:GetOwner():EyeAngles()
			ang:Normalize()
			self.Forward = ang:Forward()
		end
	end

	if TFA.GetMZSmokeEnabled == nil or TFA.GetMZSmokeEnabled() then
		local e = self.WeaponEnt
		local w = self.WeaponEntOG
		local a = self.Attachment
		local tn = "tfasmokedelay_" .. w:EntIndex() .. "_" .. a
		local sp = smoketrail

		if timer.Exists(tn) then
			timer.Remove(tn)
		end

		e.SmokePCF = e.SmokePCF or {}

		local _a = w:GetStat("Akimbo") and a or 1

		if IsValid(e.SmokePCF[_a]) then
			e.SmokePCF[_a]:StopEmission()
		end

		timer.Create(tn, delay or SMOKEDELAY, 1, function()
			if not IsValid(e) then return end
			e.SmokePCF[_a] = CreateParticleSystem(e, sp, PATTACH_POINT_FOLLOW, a)

			if IsValid(e.SmokePCF[_a]) then
				e.SmokePCF[_a]:StartEmission()
			end	
		end)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end