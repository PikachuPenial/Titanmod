AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hitsound.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_killhud.lua")

include("shared.lua")
include("sv_hitsound.lua")
include("cl_hud.lua")
include("cl_killhud.lua")
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
	local randPrimary = {"tfa_nam_ppsh41", "tfa_ins2_aek971", "tfa_ins2_ak400", "tfa_ins2_abakan", "tfa_ins2_cw_ar15", "tfa_inss_asval", "tfa_inss_aug", "tfa_ins2_warface_awm", "tfa_ins2_warface_bt_mp9", "tfa_ins2_barrett_m98_bravo", "tfa_ins2_cz805", "tfa_ins2_famas", "tfa_ins2_fn_fal", "tfa_ins2_hk_mg36", "tfa_inss2_hk_mp5a5", "tfa_howa_type_64", "tfa_ins2_ksg", "tfa_ins2_m14retro", "tfa_doithompsonm1a1", "tfa_ins2_eftm4a1", "tfa_ins2_mk14ebr", "tfa_ins2_mk18", "tfa_ins2_mosin_nagant", "tfa_inss_mp7_new", "tfa_ins2_nova", "tfa_ins2_norinco_qbz97", "tfa_ins2_pd2_remington_msr", "tfa_ins2_rpk_74m", "tfa_ins2_l85a2", "tfa_ins2_scar_h_ssr", "tfa_ins2_sks", "tfa_ins2_sterling", "tfa_ins2_ump45", "tfa_ins2_imi_uzi", "tfa_ins2_br99", "tfa_ins2_vhsd2", "tfa_ins2_xm8", "tfa_fml_p90_tac", "tfa_at_kriss_vector", "tfa_ismc_ak12_rpk", "tfa_inss_aks74u", "tfa_new_inss_galil", "tfa_doimp40", "tfa_ins2_rfb", "tfa_at_shak_12", "tfa_ins2_imbelia2", "tfa_doibren", "tfa_doim1918", "tfa_doimg42", "tfa_doistg44", "tfa_ins2_remington_m870", "tfa_ins2_sv98", "tfa_ins2_warface_orsis_t5000", "tfa_ins2_warface_amp_dsr1", "tfa_ins2_warface_ax308", "tfa_nam_m79", "tfa_doilewis", "tfa_doi_enfield"}
	local randSecondary = {"tfa_ins2_colt_m45", "tfa_ins2_cz75", "tfa_ins2_deagle", "tfa_ins2_fiveseven_eft", "tfa_ins2_izh43sw", "tfa_ins2_m9", "tfa_ins2_swmodel10", "tfa_ins2_mr96", "tfa_ins2_ots_33_pernach", "tfa_ins2_s&w_500", "bocw_mac10_alt", "tfa_ins2_walther_p99", "tfa_new_m1911", "tfa_new_glock17", "tfa_inss_makarov", "tfa_new_p226", "tfa_doim3greasegun", "tfa_ins2_gsh18", "tfa_ins2_mk23"}
	local randMelee = {"tfa_japanese_exclusive_tanto"}

	debugPrim = (randPrimary[math.random(#randPrimary)])
	debugSec = (randSecondary[math.random(#randSecondary)])
	debugMelee = (randMelee[math.random(#randMelee)])

	ply:SetModel(playerModels[math.random(#playerModels)])
	ply:Give(debugPrim)
	print(debugPrim)
	ply:Give(debugSec)
	print(debugSec)
	ply:Give(debugMelee)
	ply:SetupHands()

	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
end

function GM:PlayerInitialSpawn(ply)
	if (ply:GetPData("playerKills") == nil) then
		ply:SetNWInt("playerKills", 0)
	else
		ply:SetNWInt("playerKills", tonumber(ply:GetPData("playerKills")))
	end

	if (ply:GetPData("playerDeaths") == nil) then
		ply:SetNWInt("playerDeaths", 0)
	else
		ply:SetNWInt("playerDeaths", tonumber(ply:GetPData("playerDeaths")))
	end

	if (ply:GetPData("playerKDR") == nil) then
		ply:SetNWInt("playerKDR", 1)
	else
		ply:SetNWInt("playerKDR", tonumber(ply:GetPData("playerKDR")))
	end
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if (victim == attacker) then
		local deathGained = 1

		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + deathGained)
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))
		victim:SetNWInt("killStreak", 0)
	else
		local killGained = 1
		local deathGained = 1

		attacker:SetNWInt("playerKills", attacker:GetNWInt("playerKills") + killGained)
		attacker:SetNWInt("playerKDR", attacker:GetNWInt("playerKills") / attacker:GetNWInt("playerDeaths"))
		attacker:SetNWInt("killStreak", attacker:GetNWInt("killStreak") + 1)

		if attacker:GetNWInt("killStreak") >= attacker:GetNWInt("highestKillStreak") then
			attacker:SetNWInt("highestKillStreak", attacker:GetNWInt("killStreak"))
		end

		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + deathGained)
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))
		victim:SetNWInt("killStreak", 0)
	end
end

util.AddNetworkString("NotifyKill")
util.AddNetworkString("DeathHud")

hook.Add("PlayerDeath", "KillNotification", function(victim, inflictor, attacker)
	local weaponInfo
	if (attacker:GetActiveWeapon():IsValid()) then
		weaponInfo = weapons.Get(attacker:GetActiveWeapon():GetClass())
	end
	local rawDistance = victim:GetPos():Distance(attacker:GetPos())
	local distance = math.Round(rawDistance * 0.01905 * 10) / 10

	if (victim ~= attacker) and (inflictor ~= nil) then
		net.Start("NotifyKill")
		net.WriteEntity(victim)
		net.Send(attacker)

		net.Start("DeathHud")
		net.WriteBool(false)
		net.WriteEntity(attacker)
		if (attacker:GetActiveWeapon():IsValid()) then
			net.WriteString(weaponInfo["PrintName"])
		end
		net.WriteFloat(distance)
		net.Send(victim)

		timer.Create(victim:SteamID() .. "respawnTime", 4, 1, function()
			victim:Spawn()
		end)
	end
end)

hook.Add("PlayerDeathThink", "DisableNormalRespawn", function(ply)
	if not timer.Exists(ply:SteamID() .. "respawnTime") then
		return
	else
		return false
	end
end)

hook.Add("PlayerSpawn", "RemoveDeathHud", function(ply)
	net.Start("DeathHud")
	net.WriteBool(true)
	net.WriteEntity(ply)
	net.Send(ply)
end)

function GM:PlayerDisconnected(ply)
	--Statistics
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))

	--Streaks
	ply:SetPData("killStreak", ply:GetNWInt("killStreak"))
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))
end

function GM:ShutDown()
	for k, v in pairs(player.GetHumans()) do
		--Statistics
		v:SetPData("playerKills", v:GetNWInt("playerKills"))
		v:SetPData("playerDeaths", v:GetNWInt("playerDeaths"))
		v:SetPData("playerKDR", v:GetNWInt("playerKDR"))

		--Streaks
		v:SetPData("killStreak", v:GetNWInt("killStreak"))
		v:SetPData("highestKillStreak", v:GetNWInt("highestKillStreak"))
	end
end