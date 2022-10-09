util.AddNetworkString("hitsound_msg")

local function isplayer(ent)
	return IsValid(ent) and ent:IsPlayer()
end

local function isvalidtarget(target)
	return IsValid(target) and (target:IsPlayer() or target:IsNPC() or target:IsNextBot())
end

local function xd_hit_sound(target, hitgroup, dmginfo)
	if (isplayer(dmginfo:GetAttacker()) and isvalidtarget(target) and dmginfo:GetDamage() > 0.9) then
		net.Start("hitsound_msg", true)
			net.WriteUInt(hitgroup, 4)
		net.Send(dmginfo:GetAttacker())
	end
end

hook.Add("ScalePlayerDamage", "zzzzzxd_hit_sound_ply", xd_hit_sound)
hook.Add("ScaleNPCDamage", "zzzzzxd_hit_sound_npc", xd_hit_sound)
hook.Add("PostEntityTakeDamage", "zzzzzxd_hit_sound_other", function(ent, dmginfo, took)
	if took and not dmginfo:IsBulletDamage() then xd_hit_sound(ent, HITGROUP_GENERIC, dmginfo) end
end)