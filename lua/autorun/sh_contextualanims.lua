if SERVER then
util.AddNetworkString("VManip_BarnacleGrip")

hook.Add("PlayerUse","VManip_UseAnim",function(ply,ent)

local usecooldown=ply.usecooldown or 0
if ent!=nil and ply:KeyPressed(IN_USE) and CurTime()>usecooldown and !ent.LFS then --fix LFS
	net.Start("VManip_SimplePlay") net.WriteString("use") net.Send(ply) ply.usecooldown=CurTime()+1
end

end)

hook.Add("PlayerPostThink","VManip_BarnacleCheck",function(ply) --EFlag does not return correct value clientside

local check=ply.barnaclecheck!=2
local eflag=ply:IsEFlagSet(EFL_IS_BEING_LIFTED_BY_BARNACLE)

if eflag and check then
	ply.barnaclecheck=1
elseif !check and !eflag then
	ply.barnaclecheck=0
	ply.barnacledelay=CurTime()+1
	net.Start("VManip_BarnacleGrip") net.WriteBool(false) net.Send(ply)
end

if ply.barnaclecheck==1 then
	ply.barnaclecheck=2
	net.Start("VManip_BarnacleGrip") net.WriteBool(true) net.Send(ply)
end

end)

hook.Add("EntityTakeDamage","VManip_ShieldExplosion",function(ply,dmg)
	if !ply:IsPlayer() then return end
	local dmgtype=dmg:GetDamageType()
	if dmgtype==DMG_BLAST or dmgtype==134217792 then
		net.Start("VManip_SimplePlay") net.WriteString("shieldexplosion") net.Send(ply)
	end
end)

elseif CLIENT then

local vmp_contextual_voicechat = CreateClientConVar("cl_vmanip_voicechat", 1, true, false,"Toggles the voice chat animation")


net.Receive("VManip_BarnacleGrip",function(len)

local choked=net.ReadBool()
local ply=LocalPlayer()

if choked then
	VManip:QueueAnim("barnaclechoke")
	ply.barnaclegrip=true
else
	VManip:QuitHolding("barnaclechoke")
	ply.barnaclegrip=false
end

end)

hook.Add("CreateMove","VManip_SwimAnims",function(cmd)

local ply=LocalPlayer()
if ply:WaterLevel()<2 then
	local vmpcuranim=VManip:GetCurrentAnim()
	if vmpcuranim=="swimleft" or vmpcuranim=="swimforward" then
		VManip:QuitHolding()
	end
return end

local buttons=cmd:GetButtons()
local movingleft=bit.band(buttons,IN_MOVELEFT)!=0
local movingforward=(bit.band(buttons,IN_FORWARD)!=0 or bit.band(buttons,IN_MOVERIGHT)!=0)
local vmpcuranim=VManip:GetCurrentAnim()

if !VManip:IsActive() then
	if movingleft then
		VManip:PlayAnim("swimleft")
	elseif movingforward then
		VManip:PlayAnim("swimforward")
	end
else
	if !movingleft and vmpcuranim=="swimleft" then
		VManip:QuitHolding("swimleft") return
	elseif !movingforward and vmpcuranim=="swimforward" then
		VManip:QuitHolding("swimforward") return
	end
end

end)


hook.Add("PlayerStartVoice","VManip_StartVoiceAnim",function(ply)
if vmp_contextual_voicechat:GetBool() and ply==LocalPlayer() then
	VManip:PlayAnim("voicechat")
end
end)
hook.Add("PlayerEndVoice","VManip_EndVoiceAnim",function(ply)
if vmp_contextual_voicechat:GetBool() and ply==LocalPlayer() then
	VManip:QuitHolding("voicechat")
end
end)

end