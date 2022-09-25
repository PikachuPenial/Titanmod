local chestvec = Vector(0,0,32)
local thoraxvec = Vector(0,0,48)
local eyevec = Vector(0,0,64)
local mantlevec = Vector(0,0,16)
local vault1vec = Vector(0,0,24)

local vpunch1 = Angle(0,0,-1)
local vpunch2 = Angle(-1,0,0)

//DT vars
local meta = FindMetaTable("Player")
function meta:GetMantle()
	return self:GetDTInt(13)
end
function meta:SetMantle(value)
	return self:SetDTInt(13, value)
end

function meta:GetMantleLerp()
	return self:GetDTFloat(13)
end
function meta:SetMantleLerp(value)
	return self:SetDTFloat(13, value)
end

function meta:GetMantleStartPos()
	return self:GetDTVector(13)
end
function meta:SetMantleStartPos(value)
	return self:SetDTVector(13, value)
end

function meta:GetMantleEndPos()
	return self:GetDTVector(14)
end
function meta:SetMantleEndPos(value)
	return self:SetDTVector(14, value)
end

local pkweps = { --these already have their own climbing
["parkourmod"] = true,
["m_sprinting"] = true
}

local function PlayVaultAnim(ply, legs)
	if game.SinglePlayer() and SERVER then
		ply:SendLua('if VManip then VManip:PlayAnim("vault") end')
		if legs then
			ply:SendLua('if VMLegs then VMLegs:PlayAnim("test") end')
		end
		return
	end
	if CLIENT and VManip then
		VManip:PlayAnim("vault")
		if legs then
			VMLegs:PlayAnim("test")
		end
	end
end

local function Vault1(ply, mv, ang, t, h)
	t.start = mv:GetOrigin() + eyevec + ang:Forward()* 50
	t.endpos = t.start - (chestvec)
	t.filter = ply
	t.mask = MASK_PLAYERSOLID
	t = util.TraceLine(t)
	if (t.Entity and t.Entity.IsNPC) and (t.Entity:IsNPC() or t.Entity:IsPlayer()) then
		return false
	end
	if t.Hit and t.Fraction > 0.5 then
		local tsafety = {}
		tsafety.start = t.StartPos - ang:Forward() * 50
		tsafety.endpos = t.StartPos
		tsafety.filter = ply
		tsafety.mask = MASK_PLAYERSOLID
		tsafety = util.TraceLine(tsafety)
		
		if tsafety.Hit then return false end
		
		h.start = t.HitPos + mantlevec
		h.endpos = h.start
		h.filter = ply
		h.mask = MASK_PLAYERSOLID
		h.mins, h.maxs = ply:GetCollisionBounds()
		local hulltr = util.TraceHull(h)
		if !hulltr.Hit then
			if t.HitNormal.x != 0 then t.HitPos.z = t.HitPos.z + 12 end
			ply:SetMantleStartPos(mv:GetOrigin())
			ply:SetMantleEndPos(t.HitPos + mantlevec)
			ply:SetMantleLerp(0)
			ply:SetMantle(1)
			PlayVaultAnim(ply)
			ply:ViewPunch(vpunch1)
			if SERVER then ply:PlayStepSound(1) end
			return true
		end
	end
	return false
end

local function Vault2(ply, mv, ang, t, h)
	t.start = mv:GetOrigin() + chestvec
	t.endpos = t.start + ang:Forward() * 20
	t.filter = ply
	t.mask = MASK_PLAYERSOLID

	local vaultpos = t.endpos + ang:Forward() * 50
	t = util.TraceLine(t)
	if (t.Entity and t.Entity.IsNPC) and (t.Entity:IsNPC() or t.Entity:IsPlayer()) then
		return false
	end
	
	if t.Hit and t.Fraction > 0.5 then
		local tsafety = {}
		tsafety.start = mv:GetOrigin() + eyevec
		tsafety.endpos = tsafety.start + ang:Forward() * 50
		tsafety.filter = ply
		tsafety.mask = MASK_PLAYERSOLID
		tsafety = util.TraceLine(tsafety)
		
		if tsafety.Hit then return false end
		
		local tsafety = {}
		tsafety.start = mv:GetOrigin() + eyevec + ang:Forward() * 50
		tsafety.endpos = tsafety.start - thoraxvec
		tsafety.filter = ply
		tsafety.mask = MASK_PLAYERSOLID
		tsafety = util.TraceLine(tsafety)
		
		if tsafety.Hit then return false end
		h.start = t.StartPos + ang:Forward() * 50
		h.endpos = h.start
		h.filter = ply
		h.mask = MASK_PLAYERSOLID
		h.mins, h.maxs = ply:GetCollisionBounds()
		local hulltr = util.TraceHull(h)
		if !hulltr.Hit then
			ply:SetMantleStartPos(mv:GetOrigin())
			ply:SetMantleEndPos(vaultpos)
			ply:SetMantleLerp(0)
			ply:SetMantle(2)
			PlayVaultAnim(ply, true)
			ply:ViewPunch(vpunch2)
			if SERVER then ply:EmitSound("vmanip/goprone_0"..math.random(1,3)..".wav") end
			return true
		end
	end
	return false
end

hook.Add("SetupMove", "vmanip_vault", function(ply, mv, cmd)

	if ply.MantleDisabled then
		return
	end
	
	if !ply:Alive() then
		if ply:GetMantle() != 0 then 
			ply:SetMantle(0)
		end
		return
	end
	
	if ply:GetMantle() == 0 then
		local mvtype = ply:GetMoveType()
		if (ply:OnGround() or mv:GetVelocity().z < -600 or mvtype == MOVETYPE_NOCLIP or mvtype == MOVETYPE_LADDER) then
			return
		end
	end
	
	local activewep = ply:GetActiveWeapon()
	if IsValid(activewep) and activewep.GetClass then
		if pkweps[activewep:GetClass()] then
			return
		end
	end
	
	ply.mantletr = ply.mantletr or {}
	ply.mantlehull = ply.mantlehull or {}
	local t = ply.mantletr
	local h = ply.mantlehull
	
	if ply:GetMantle() == 0 and !ply:OnGround() and mv:KeyDown(IN_FORWARD) and !mv:KeyDown(IN_DUCK) and !ply:Crouching() then
		local ang = mv:GetAngles()
		ang.x = 0 ang.z = 0
		if !Vault1(ply, mv, ang, t, h) then
			Vault2(ply, mv, ang, t, h)
		end
	end
	
	if ply:GetMantle() != 0 then
		mv:SetButtons(0)
		mv:SetMaxClientSpeed(0)
		mv:SetSideSpeed(0) mv:SetUpSpeed(0) mv:SetForwardSpeed(0)
		mv:SetVelocity(vector_origin)
		ply:SetMoveType(MOVETYPE_NOCLIP)
		
		local mantletype = ply:GetMantle()
		local mlerp = ply:GetMantleLerp()
		local FT = FrameTime()
		local TargetTick = (1/FT)/66.66
		local mlerpend = ((mantletype == 1 and 0.8) or 0.75)
		local mlerprate = ((mantletype == 1 and 0.075) or 0.1)/TargetTick

		ply:SetMantleLerp(Lerp(mlerprate, mlerp, 1))
		local mvec = LerpVector(ply:GetMantleLerp(), ply:GetMantleStartPos(), ply:GetMantleEndPos())
		mv:SetOrigin(mvec)

		if mlerp >= mlerpend or mvec:DistToSqr(ply:GetMantleEndPos()) < 280 then
			if ply:GetMantle() == 2 then
				local ang = mv:GetAngles()
				ang.x = 0 ang.z = 0
				mv:SetVelocity(ang:Forward() * 200)
			end
			ply:SetMantle(0)
			ply:SetMoveType(MOVETYPE_WALK)
			if SERVER and !ply:IsInWorld() then
				mv:SetOrigin(ply:GetMantleStartPos())
			end
			h.start = mv:GetOrigin()
			h.endpos = h.start
			h.filter = ply
			h.mask = MASK_PLAYERSOLID
			h.mins, h.maxs = ply:GetCollisionBounds()
			local hulltr = util.TraceHull(h)
			if hulltr.Hit then
				mv:SetOrigin(ply:GetMantleEndPos())
			end
		end
	end

end)