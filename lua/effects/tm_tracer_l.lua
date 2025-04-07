
local tracer  = Material("trails/tm_tracer_large")
local smoke = Material("trails/smoke")
local width = 15
local life = 0.06

function EFFECT:Init(data)
	self.Position = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
	self:SetRenderBoundsWS(self.StartPos, self.EndPos)
    self.death = CurTime() + life
end

function EFFECT:Think()
    if (CurTime() > self.death) then return false end
    return true
end

function EFFECT:Render()
	local vel = (self.death - CurTime()) / life
	render.SetMaterial(smoke)
    render.DrawBeam(self.StartPos, self.EndPos, vel * width, 0, 1, Color(68, 46, 5, math.random(50, 65)))
    render.SetMaterial(tracer)
    render.DrawBeam(self.StartPos, self.EndPos, (vel / 2) * width, 0, 1)
end
