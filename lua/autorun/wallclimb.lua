resource.AddFile("sound/ClimbSound1.wav")
resource.AddFile("sound/ClimbSound2.wav")
resource.AddFile("sound/ClimbSound3.wav")
resource.AddFile("sound/wallrun.wav")

if (SERVER) then 
	
	local fueraweaps = {
"weapon_physgun",
"weapon_physcannon",
"weapon_pistol",
"weapon_crowbar",
"weapon_slam",
"weapon_357",
"weapon_smg1",
"weapon_ar2",
"weapon_crossbow",
"weapon_shotgun",
"weapon_frag",
"weapon_stunstick",
"weapon_rpg",
"gmod_camera",
"gmod_toolgun"}

function climbb_Spawn(ply)
ply:GetViewModel():SetNoDraw(false)
ply.Lastclimbb = CurTime()
ply.LastJump = CurTime()
end
hook.Add("PlayerSpawn","climbb_Spawn",climbb_Spawn)

function WallJumpSound(ply)
	ply:EmitSound("player/footsteps/tile" .. math.random(1, 4) .. ".wav", math.Rand(60, 80), math.Rand(70, 90))
end

function WallRunSound(ply)
	ply:EmitSound("wallrun.wav")
end

function climbb()
for id,ply in pairs (player.GetAll()) do


if ply.ArmaEquipar and CurTime() >= ply.ArmaEquipar then
if not ply:Alive() then return end
ply.ArmaEquipar = nil
if ply:GetActiveWeapon():IsValid() then
if table.HasValue(fueraweaps,ply:GetActiveWeapon():GetClass()) then
timer.Simple(0.02,function()
ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
end)
else
timer.Simple(0.02,function()
ply:GetActiveWeapon():SendWeaponAnim(ACT_VM_DRAW)
ply:GetActiveWeapon():Deploy()
end)
end
ply:GetViewModel():SetNoDraw(false)
end
end
--Walljump Left--
	if (ply:KeyDown(IN_MOVELEFT) and ply:KeyDown(IN_JUMP)) and ply.LastJump and CurTime() >= ply.LastJump then
	tracedata={}
	tracedata.start = ply:EyePos() + (ply:GetRight() * 1)
	tracedata.endpos = ply:EyePos() + (ply:GetRight() * 32)
	tracedata.filter = ply
	local traceWallRight = util.TraceLine(tracedata)

	if (traceWallRight.Hit) then
					if ply:OnGround() then
					ply:ViewPunch(Angle(0, 0, -10));
					ply:SetLocalVelocity(((ply:GetRight() * -1) * 175) + (ply:GetUp() * 170));
					WallJumpSound(ply)
					ply.LastJump = CurTime() + 1.0
					end
					if not ply:OnGround() then
					ply:ViewPunch(Angle(0, 0, -10));
					ply:SetLocalVelocity(((ply:GetRight() * -1) * 175) + (ply:GetUp() * 280));
					WallJumpSound(ply)
					ply.LastJump = CurTime() + 1.0
					end
					end
					end
	--Waljump Left end--
	--Walljump Right--
	if (ply:KeyDown(IN_MOVERIGHT) and ply:KeyDown(IN_JUMP)) and ply.LastJump and CurTime() >= ply.LastJump then
	tracedata={}
	tracedata.start = ply:EyePos() + (ply:GetRight() * -1)
	tracedata.endpos = ply:EyePos() + (ply:GetRight() * -32)
	tracedata.filter = ply
	local traceWallLeft = util.TraceLine(tracedata)

	if (traceWallLeft.Hit) then
					if ply:OnGround() then
					ply:ViewPunch(Angle(0, 0, 10));
					ply:SetLocalVelocity(((ply:GetRight() * 1) * 175) + (ply:GetUp() * 170));
					WallJumpSound(ply)
					ply.LastJump = CurTime() + 1.0
					end
					if not ply:OnGround() then
					ply:ViewPunch(Angle(0, 0, 10));
					ply:SetLocalVelocity(((ply:GetRight() * 1) * 175) + (ply:GetUp() * 280));
					WallJumpSound(ply)
					ply.LastJump = CurTime() + 1.0
					end
					end
					end
	--Waljump Right end--
if not( ply:Crouching() ) then
if ply:KeyDown(IN_SPEED)and ply:KeyDown(IN_FORWARD) then
	end
	if ply.Lastclimbb and CurTime() >= ply.Lastclimbb and not( ply:Crouching() ) then

	--WallRunRight--
	if ply:KeyDown(IN_MOVERIGHT) and ply:KeyDown(IN_SPEED)and ply:KeyDown(IN_FORWARD) then
	tracedata={}
	tracedata.start = ply:EyePos() + (ply:GetUp() * -1) + (ply:GetForward() * 32)
	tracedata.endpos = ply:EyePos()+ (ply:GetUp() * -73) + (ply:GetForward() * 64)
	tracedata.filter = ply
	local traceWalRLow = util.TraceLine(tracedata)

	tracedata={}
	tracedata.start = ply:EyePos() + (ply:GetForward() * 32)
	tracedata.endpos = ply:EyePos() + (ply:GetForward() * 64)
	tracedata.filter = ply
	local traceWalRHigh = util.TraceLine(tracedata)

	tracedata={}
	tracedata.start = ply:EyePos() + (ply:GetRight() * 1)
	tracedata.endpos = ply:EyePos() + (ply:GetRight() * 32)
	tracedata.filter = ply
	local traceWalRRight = util.TraceLine(tracedata)

	if not (traceWalRLow.Hit) and not (traceWalRHigh.Hit) and (traceWalRRight.Hit) then
	ply:ViewPunch(Angle(0, 0, -15));
	WallRunSound(ply)
	ply:SetLocalVelocity(Vector(0,0,210) + (ply:EyeAngles():Right()*200 +  ply:GetForward()*360))
	ply.Lastclimbb = CurTime() + 1.5
	end
	end
	--WallRunRight end--
		--WallRunLeft--
	if ply:KeyDown(IN_MOVELEFT) and ply:KeyDown(IN_SPEED)and ply:KeyDown(IN_FORWARD) then
	tracedata={}
	tracedata.start = ply:EyePos() + (ply:GetUp() * -1) + (ply:GetForward() * 32)
	tracedata.endpos = ply:EyePos()+ (ply:GetUp() * -73) + (ply:GetForward() * 64)
	tracedata.filter = ply
	local traceWalRLow = util.TraceLine(tracedata)

	tracedata={}
	tracedata.start = ply:EyePos() + (ply:GetForward() * 32)
	tracedata.endpos = ply:EyePos() + (ply:GetForward() * 64)
	tracedata.filter = ply
	local traceWalRHigh = util.TraceLine(tracedata)

	tracedata={}
	tracedata.start = ply:EyePos() + (ply:GetRight() * -1)
	tracedata.endpos = ply:EyePos() + (ply:GetRight() * -32)
	tracedata.filter = ply
	local traceWalRRight = util.TraceLine(tracedata)

	if not (traceWalRLow.Hit) and not (traceWalRHigh.Hit) and (traceWalRRight.Hit) then
	ply:ViewPunch(Angle(0, 0, 15));
	WallRunSound(ply)
	ply:SetLocalVelocity(Vector(0,0,210) + (ply:EyeAngles():Right()*-200 +  ply:GetForward()*360))
	ply.Lastclimbb = CurTime() + 1.5
	end
	end
	--WallRunLeft end--

end
end
end
end
hook.Add("Think","climbb",climbb)

end
