AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hitsound.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_killhud.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_mainmenu.lua")

include("shared.lua")
include("sv_hitsound.lua")
include("concommands.lua")

function GM:Initialize()
	print("Gamemode Initialized")
end

--Player setup
function GM:PlayerSpawn(ply)
	ply:SetGravity(.72)
	ply:SetMaxHealth(100)
	ply:SetRunSpeed(275)
	ply:SetWalkSpeed(165)
	ply:SetJumpPower(150)

	ply:SetLadderClimbSpeed(140)
	ply:SetSlowWalkSpeed(78)

	ply:SetCrouchedWalkSpeed(0.5)
	ply:SetDuckSpeed(0.65)
	ply:SetUnDuckSpeed(0.65)

	local playerModels = {"models/player/barney.mdl", "models/player/Group03/female_02.mdl", "models/player/Group03/male_02.mdl", "models/player/Group03/male_03.mdl", "models/player/Group03/male_08.mdl"}
	local randPrimary = {"tfa_nam_ppsh41", "tfa_ins2_aek971", "tfa_ins2_ak400", "tfa_ins2_abakan", "tfa_ins2_cw_ar15", "tfa_inss_asval", "tfa_inss_aug", "tfa_ins2_warface_awm", "tfa_ins2_warface_bt_mp9", "tfa_ins2_barrett_m98_bravo", "tfa_ins2_cz805", "tfa_ins2_famas", "tfa_ins2_fn_fal", "tfa_ins2_hk_mg36", "tfa_inss2_hk_mp5a5", "tfa_howa_type_64", "tfa_ins2_ksg", "tfa_ins2_m14retro", "tfa_doithompsonm1a1", "tfa_ins2_mk14ebr", "tfa_ins2_mk18", "tfa_ins2_mosin_nagant", "tfa_inss_mp7_new", "tfa_ins2_nova", "tfa_ins2_norinco_qbz97", "tfa_ins2_pd2_remington_msr", "tfa_ins2_rpk_74m", "tfa_ins2_l85a2", "tfa_ins2_scar_h_ssr", "tfa_ins2_sks", "tfa_ins2_sterling", "tfa_ins2_ump45", "tfa_ins2_imi_uzi", "tfa_ins2_br99", "tfa_ins2_vhsd2", "tfa_ins2_xm8", "tfa_fml_p90_tac", "tfa_at_kriss_vector", "tfa_ismc_ak12_rpk", "tfa_inss_aks74u", "tfa_new_inss_galil", "tfa_doimp40", "tfa_ins2_rfb", "tfa_at_shak_12", "tfa_ins2_imbelia2", "tfa_doibren", "tfa_doim1918", "tfa_doimg42", "tfa_doistg44", "tfa_ins2_remington_m870", "tfa_ins2_sv98", "tfa_ins2_warface_orsis_t5000", "tfa_ins2_warface_amp_dsr1", "tfa_ins2_warface_ax308", "tfa_nam_m79", "tfa_doilewis", "tfa_doi_enfield", "tfa_doifg42", "tfa_ins2_ar57", "tfa_doiowen"}
	local randSecondary = {"tfa_ins2_colt_m45", "tfa_ins2_cz75", "tfa_ins2_deagle", "tfa_ins2_fiveseven_eft", "tfa_ins2_izh43sw", "tfa_ins2_m9", "tfa_ins2_swmodel10", "tfa_ins2_mr96", "tfa_ins2_ots_33_pernach", "tfa_ins2_s&w_500", "bocw_mac10_alt", "tfa_ins2_walther_p99", "tfa_new_m1911", "tfa_new_glock17", "tfa_inss_makarov", "tfa_new_p226", "tfa_doim3greasegun", "tfa_ins2_gsh18", "tfa_ins2_mk23", "tfa_ins2_mp5k", "tfa_ins_sandstorm_tariq"}
	local randMelee = {"tfa_japanese_exclusive_tanto"}

	debugPrim = (randPrimary[math.random(#randPrimary)])
	debugSec = (randSecondary[math.random(#randSecondary)])
	debugMelee = (randMelee[math.random(#randMelee)])

	ply:SetModel(playerModels[math.random(#playerModels)])
	ply:Give(debugPrim)
	--print(debugPrim)
	ply:Give(debugSec)
	--print(debugSec)
	ply:Give(debugMelee)
	ply:SetupHands()

	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
end

function GM:PlayerInitialSpawn(ply)
	--Checking if PData exists for the player. If the PData exists, it will load the players save. If the PData does not exist, it will create a new save for the player.
	if (ply:GetPData("playerKills") == nil) then ply:SetNWInt("playerKills", 0) else ply:SetNWInt("playerKills", tonumber(ply:GetPData("playerKills"))) end
	if (ply:GetPData("playerDeaths") == nil) then ply:SetNWInt("playerDeaths", 0) else ply:SetNWInt("playerDeaths", tonumber(ply:GetPData("playerDeaths"))) end
	if (ply:GetPData("playerKDR") == nil) then ply:SetNWInt("playerKDR", 1) else ply:SetNWInt("playerKDR", tonumber(ply:GetPData("playerKDR"))) end
	if (ply:GetPData("playerScore") == nil) then ply:SetNWInt("playerScore", 0) else ply:SetNWInt("playerScore", tonumber(ply:GetPData("playerScore"))) end
	if (ply:GetPData("highestKillStreak") == nil) then ply:SetNWInt("highestKillStreak", 0) else ply:SetNWInt("highestKillStreak", tonumber(ply:GetPData("highestKillStreak"))) end
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if (victim == attacker) then
		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + 1)
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))
		victim:SetNWInt("killStreak", 0)
	else
		attacker:SetNWInt("playerKills", attacker:GetNWInt("playerKills") + 1)
		attacker:SetNWInt("playerKDR", attacker:GetNWInt("playerKills") / attacker:GetNWInt("playerDeaths"))
		attacker:SetNWInt("killStreak", attacker:GetNWInt("killStreak") + 1)
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 100)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 100)

		if attacker:GetNWInt("killStreak") >= attacker:GetNWInt("highestKillStreak") then
			attacker:SetNWInt("highestKillStreak", attacker:GetNWInt("killStreak"))
		end

		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + 1)
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))
		victim:SetNWInt("killStreak", 0)
	end
end

function GM:ShowSpare1(ply)
	RunConsoleCommand("tm_openmainmenu")
end

util.AddNetworkString("NotifyKill")
util.AddNetworkString("DeathHud")

hook.Add("PlayerDeath", "KillNotification", function(victim, inflictor, attacker)
	local weaponInfo
	local weaponName
	local rawDistance = victim:GetPos():Distance(attacker:GetPos())
	local distance = math.Round(rawDistance * 0.01905)

	if (attacker:GetActiveWeapon():IsValid()) then
		weaponInfo = weapons.Get(attacker:GetActiveWeapon():GetClass())
		weaponName = weaponInfo["PrintName"]
	end

	if (victim ~= attacker) and (inflictor ~= nil) then
		net.Start("NotifyKill")
		net.WriteEntity(victim)
		net.Send(attacker)
	end

	if (victim ~= attacker) and (inflictor ~= nil) then
		net.Start("DeathHud")
		net.WriteEntity(attacker)
		net.WriteString(weaponName)
		net.WriteFloat(distance)
		net.Send(victim)
	end

	timer.Create(victim:SteamID() .. "respawnTime", 5, 1, function()
		victim:Spawn()
	end)

	--Score calculations will go here
	if distance >= 25 then

	end

	if victim:GetNWInt("killStreak") >= 3 then

	end
end)

hook.Add("PlayerDeathThink", "DisableNormalRespawn", function(ply)
	if not timer.Exists(ply:SteamID() .. "respawnTime") then
		return
	else
		return false
	end
end)

local function Regeneration()
	local speed = 0.15
	local damageDelay = 3.5
	local max = 100
	local time = FrameTime()

	for _, ply in pairs(player.GetAll()) do
		if (ply:Alive()) then
			local health = ply:Health()

			if (health < (ply.LastHealth or 0)) then
				ply.HealthRegenNext = CurTime() + damageDelay
			end

			if (CurTime() > (ply.HealthRegenNext or 0)) then
				ply.HealthRegen = (ply.HealthRegen or 0) + time
			 	if (ply.HealthRegen >= speed) then
					local add = math.floor(ply.HealthRegen / speed)
					ply.HealthRegen = ply.HealthRegen - (add * speed)
					if (health < max or speed < 0) then
						ply:SetHealth(math.min(health + add, max))
					end
				end
			end

			ply.LastHealth = ply:Health()
		end
	end
end
hook.Add("Think", "HealthRegen.Think", Regeneration)

function GM:PlayerDisconnected(ply)
	--Statistics
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerScore", ply:GetNWInt("playerScore"))

	--Streaks
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))
end

function GM:ShutDown()
	for k, v in pairs(player.GetHumans()) do
		--Statistics
		v:SetPData("playerKills", v:GetNWInt("playerKills"))
		v:SetPData("playerDeaths", v:GetNWInt("playerDeaths"))
		v:SetPData("playerKDR", v:GetNWInt("playerKDR"))
		v:SetPData("playerScore", v:GetNWInt("playerScore"))

		--Streaks
		v:SetPData("highestKillStreak", v:GetNWInt("highestKillStreak"))
	end
end