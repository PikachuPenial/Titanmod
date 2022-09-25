local blankvec   = Vector(0, 0, 0)

EFFECT.Life      = 0.085
EFFECT.HeatSize  = 0.70

function EFFECT:Init(data)
	self.Position = blankvec
	self.WeaponEnt = data:GetEntity()
	self.WeaponEntOG = self.WeaponEnt
	self.Attachment = data:GetAttachment()
	self.Dir = data:GetNormal()

	local owent

	if IsValid(self.WeaponEnt) then
		owent = self.WeaponEnt:GetOwner()
	end

	if not IsValid(owent) then
		owent = self.WeaponEnt:GetParent()
	end

	if IsValid(owent) and owent:IsPlayer() then
		if owent ~= LocalPlayer() or owent:ShouldDrawLocalPlayer() then
			self.WeaponEnt = owent:GetActiveWeapon()
			if not IsValid(self.WeaponEnt) then return end
		else
			self.WeaponEnt = owent:GetViewModel()

			local theirweapon = owent:GetActiveWeapon()

			if IsValid(theirweapon) and theirweapon.ViewModelFlip or theirweapon.ViewModelFlipped then
				self.Flipped = true
			end

			if not IsValid(self.WeaponEnt) then return end
		end
	end

	if IsValid(self.WeaponEntOG) and self.WeaponEntOG.MuzzleAttachment then
		self.Attachment = self.WeaponEnt:LookupAttachment(self.WeaponEntOG.MuzzleAttachment)

		if not self.Attachment or self.Attachment <= 0 then
			self.Attachment = 1
		end

		if self.WeaponEntOG.Akimbo then
			self.Attachment = 2 - self.WeaponEntOG.AnimCycle
		end
	end

	local angpos = self.WeaponEnt:GetAttachment(self.Attachment)

	if not angpos or not angpos.Pos then
		angpos = {
			Pos = vector_origin,
			Ang = angle_zero
		}
	end

	if self.Flipped then
		local tmpang = (self.Dir or angpos.Ang:Forward()):Angle()
		local localang = self.WeaponEnt:WorldToLocalAngles(tmpang)
		localang.y = localang.y + 180
		localang = self.WeaponEnt:LocalToWorldAngles(localang)
		self.Dir = localang:Forward()
	end

    ParticleEffectAttach("muzzleflash_smg_bizon", PATTACH_POINT_FOLLOW, self.WeaponEnt, data:GetAttachment())    

	if GetConVar("cl_tfa_rms_smoke_shock"):GetFloat() >= 1 then
	    ParticleEffectAttach("muzzle_smoke_shock_small", PATTACH_POINT_FOLLOW, self.WeaponEnt, data:GetAttachment())
    end	
	
	self.Position = self:GetTracerShootPos(angpos.Pos, self.WeaponEnt, self.Attachment)
	self.Norm = self.Dir
	self.vOffset = self.Position

	local dir = self.Norm
	
    if GetConVar("cl_tfa_rms_muzzleflash_dynlight"):GetFloat() >= 1 then

    	local dlight

    	if IsValid(self.WeaponEnt) then
    		dlight = DynamicLight(self.WeaponEnt:EntIndex())
    	else
    		dlight = DynamicLight(0)
    	end

    	local fadeouttime = 0.025
 
	    if (dlight) then
		    dlight.Pos = self.Position + dir * 1 - dir:Angle():Right() * 5
    		dlight.r = 255
    		dlight.g = 197
    		dlight.b = 100
		    dlight.brightness = 0.95
		    dlight.Decay = 500
		    dlight.Size = 384
		    dlight.DieTime = CurTime() + fadeouttime
	    end
    end
	
	local emitter = ParticleEmitter(self.vOffset)
    local AddVel = Vector()
	
	if TFA.GetGasEnabled() then
		local particle = emitter:Add("sprites/heatwave", self.vOffset + dir*2)

		if (particle) then
			particle:SetVelocity(dir * 25 * self.HeatSize + 1.05 * AddVel)
			particle:SetLifeTime(0)
			particle:SetDieTime(self.Life)
			particle:SetStartAlpha(math.Rand(200, 225))
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(3, 5) * self.HeatSize)
			particle:SetEndSize(math.Rand(8, 12) * self.HeatSize)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-2, 2))
			particle:SetAirResistance(5)
			particle:SetGravity(Vector(0, 0, 40))
			particle:SetColor(255, 255, 255)
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end