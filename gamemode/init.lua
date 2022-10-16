AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_mainmenu.lua")

include("shared.lua")
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

	ply:SetModel(ply:GetNWString("chosenPlayermodel"))
	ply:SetupHands()
	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)

	ply:Give(ply:GetNWInt("loadoutPrimary"))
	ply:Give(ply:GetNWInt("loadoutSecondary"))
	ply:Give(ply:GetNWInt("loadoutMelee"))

	ply:SetNWInt("killStreak", 0)
end

function GM:PlayerInitialSpawn(ply)
	--Checking if PData exists for the player. If the PData exists, it will load the players save. If the PData does not exist, it will create a new save for the player.
	if (ply:GetPData("playerKills") == nil) then ply:SetNWInt("playerKills", 0) else ply:SetNWInt("playerKills", tonumber(ply:GetPData("playerKills"))) end
	if (ply:GetPData("playerDeaths") == nil) then ply:SetNWInt("playerDeaths", 0) else ply:SetNWInt("playerDeaths", tonumber(ply:GetPData("playerDeaths"))) end
	if (ply:GetPData("playerKDR") == nil) then ply:SetNWInt("playerKDR", 1) else ply:SetNWInt("playerKDR", tonumber(ply:GetPData("playerKDR"))) end
	if (ply:GetPData("playerScore") == nil) then ply:SetNWInt("playerScore", 0) else ply:SetNWInt("playerScore", tonumber(ply:GetPData("playerScore"))) end
	if (ply:GetPData("highestKillStreak") == nil) then ply:SetNWInt("highestKillStreak", 0) else ply:SetNWInt("highestKillStreak", tonumber(ply:GetPData("highestKillStreak"))) end
	if (ply:GetPData("chosenPlayermodel") == nil) then ply:SetNWString("chosenPlayermodel", "models/player/Group03/male_02.mdl") else ply:SetNWString("chosenPlayermodel", ply:GetPData("chosenPlayermodel")) end
	if (ply:GetPData("playerAccoladeHeadshot") == nil) then ply:SetNWInt("playerAccoladeHeadshot", 0) else ply:SetNWInt("playerAccoladeHeadshot", tonumber(ply:GetPData("playerAccoladeHeadshot"))) end
	if (ply:GetPData("playerAccoladeSmackdown") == nil) then ply:SetNWInt("playerAccoladeSmackdown", 0) else ply:SetNWInt("playerAccoladeSmackdown", tonumber(ply:GetPData("playerAccoladeSmackdown"))) end
	if (ply:GetPData("playerAccoladeLongshot") == nil) then ply:SetNWInt("playerAccoladeLongshot", 1) else ply:SetNWInt("playerAccoladeLongshot", tonumber(ply:GetPData("playerAccoladeLongshot"))) end
	if (ply:GetPData("playerAccoladePointblank") == nil) then ply:SetNWInt("playerAccoladePointblank", 0) else ply:SetNWInt("playerAccoladePointblank", tonumber(ply:GetPData("playerAccoladePointblank"))) end
	if (ply:GetPData("playerAccoladeOnStreak") == nil) then ply:SetNWInt("playerAccoladeOnStreak", 0) else ply:SetNWInt("playerAccoladeOnStreak", tonumber(ply:GetPData("playerAccoladeOnStreak"))) end
	if (ply:GetPData("playerAccoladeBuzzkill") == nil) then ply:SetNWInt("playerAccoladeBuzzkill", 0) else ply:SetNWInt("playerAccoladeBuzzkill", tonumber(ply:GetPData("playerAccoladeBuzzkill"))) end
	if (ply:GetPData("playerAccoladeClutch") == nil) then ply:SetNWInt("playerAccoladeClutch", 0) else ply:SetNWInt("playerAccoladeClutch", tonumber(ply:GetPData("playerAccoladeClutch"))) end

	timer.Create(ply:SteamID() .. "killOnFirstSpawn", 0.2, 1, function()
		ply:KillSilent()
	end)

	ply:ConCommand("tm_openmainmenu")

	local randPrimary = {"tfa_nam_ppsh41", "tfa_ins2_aek971", "tfa_ins2_ak400", "tfa_ins2_abakan", "tfa_ins2_cw_ar15", "tfa_inss_asval", "tfa_inss_aug", "tfa_ins2_warface_awm", "tfa_ins2_warface_bt_mp9", "tfa_ins2_barrett_m98_bravo", "tfa_ins2_cz805", "tfa_ins2_famas", "tfa_ins2_fn_fal", "tfa_ins2_hk_mg36", "tfa_inss2_hk_mp5a5", "tfa_howa_type_64", "tfa_ins2_ksg", "tfa_ins2_m14retro", "tfa_doithompsonm1a1", "tfa_ins2_mk14ebr", "tfa_fml_inss_mk18", "tfa_ins2_mosin_nagant", "tfa_inss_mp7_new", "tfa_ins2_nova", "tfa_ins2_norinco_qbz97", "tfa_ins2_pd2_remington_msr", "tfa_ins2_rpk_74m", "tfa_ins2_l85a2", "tfa_ins2_scar_h_ssr", "tfa_ins2_sks", "tfa_doisten", "tfa_ins2_ump45", "tfa_ins2_br99", "tfa_ins2_vhsd2", "tfa_ins2_xm8", "tfa_fml_p90_tac", "tfa_ins2_krissv", "tfa_ismc_ak12_rpk", "tfa_inss_aks74u", "tfa_new_inss_galil", "tfa_doimp40", "tfa_ins2_rfb", "tfa_at_shak_12", "tfa_ins2_imbelia2", "tfa_doibren", "tfa_doim1918", "tfa_doimg42", "tfa_doistg44", "tfa_ins2_remington_m870", "tfa_ins2_sv98", "tfa_ins2_warface_orsis_t5000", "tfa_ins2_warface_amp_dsr1", "tfa_ins2_warface_ax308", "tfa_nam_m79", "tfa_doilewis", "tfa_doi_enfield", "tfa_doifg42", "tfa_ins2_ar57", "tfa_doiowen", "tfa_ww1_mp18", "tfa_fas2_ppbizon", "tfa_ins2_akms", "tfa_ins2_pm9", "tfa_nam_stevens620", "tfa_ins2_saiga_spike", "tfa_ins2_spectre", "tfa_ins2_groza", "tfa_ins2_sc_evo", "tfa_ins2_spas12", "tfa_ins2_ddm4v5", "tfa_ins2_mx4", "tfa_doi_garand", "tfa_ins2_warface_cheytac_m200", "tfa_ins2_rpg7_scoped", "tfa_fml_lefrench_mas38", "tfa_ins2_minimi", "tfa_ins2_typhoon12", "tfa_ins2_mc255", "tfa_ins2_aa12", "tfa_ins2_sr2m_veresk", "tfa_blast_pindadss2", "tfa_ins2_acrc", "tfa_blast_lynx_msbsb", "tfa_blast_ksvk_cqb", "tfa_ins2_type81"}
	local randSecondary = {"tfa_ins2_colt_m45", "tfa_ins2_cz75", "tfa_ins2_deagle", "tfa_ins2_fiveseven_eft", "tfa_ins2_izh43sw", "tfa_ins2_m9", "tfa_ins2_swmodel10", "tfa_ins2_mr96", "tfa_ins2_ots_33_pernach", "tfa_ins2_s&w_500", "bocw_mac10_alt", "tfa_ins2_walther_p99", "tfa_new_m1911", "tfa_new_glock17", "tfa_inss_makarov", "tfa_new_p226", "tfa_doim3greasegun", "tfa_ins2_gsh18", "tfa_ins2_mk23", "tfa_ins2_mp5k", "tfa_ins_sandstorm_tariq", "tfa_ins2_qsz92", "tfa_ins2_imi_uzi", "tfa_ins2_fnp45", "st_stim_pistol"}
	local randMelee = {"tfa_japanese_exclusive_tanto", "tfa_ararebo_bf1", "tfa_km2000_knife", "fres_grapple"}

	ply:SetNWInt("loadoutPrimary", randPrimary[math.random(#randPrimary)])
	ply:SetNWInt("loadoutSecondary", randSecondary[math.random(#randSecondary)])
	ply:SetNWInt("loadoutMelee", randMelee[math.random(#randMelee)])
end

util.AddNetworkString("PlayHitsound")
util.AddNetworkString("NotifyKill")
util.AddNetworkString("DeathHud")

local function TestEntityForPlayer(ent)
	return IsValid(ent) and ent:IsPlayer()
end

local function HitSound(target, hitgroup, dmginfo)
	local serverHitHeadshot = false

	if (TestEntityForPlayer(dmginfo:GetAttacker())) then
		net.Start("PlayHitsound", true)
			net.WriteUInt(hitgroup, 4)
		net.Send(dmginfo:GetAttacker())

		if (hitgroup == HITGROUP_HEAD) then
			serverHitHeadshot = true
		end

		dmginfo:GetAttacker():SetNWBool("lastShotHead", serverHitHeadshot)
	end
end
hook.Add("ScalePlayerDamage", "HitSoundOnPlayerHit", HitSound)

function GM:PlayerDeath(victim, inflictor, attacker)
	if not IsValid(attacker) or victim == attacker or not attacker:IsPlayer() then
		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + 1)
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))
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

		attacker:SetNWInt(victim:SteamID() .. "youKilled", attacker:GetNWInt(victim:SteamID() .. "youKilled") + 1)
	end

	local randPrimary = {"tfa_nam_ppsh41", "tfa_ins2_aek971", "tfa_ins2_ak400", "tfa_ins2_abakan", "tfa_ins2_cw_ar15", "tfa_inss_asval", "tfa_inss_aug", "tfa_ins2_warface_awm", "tfa_ins2_warface_bt_mp9", "tfa_ins2_barrett_m98_bravo", "tfa_ins2_cz805", "tfa_ins2_famas", "tfa_ins2_fn_fal", "tfa_ins2_hk_mg36", "tfa_inss2_hk_mp5a5", "tfa_howa_type_64", "tfa_ins2_ksg", "tfa_ins2_m14retro", "tfa_doithompsonm1a1", "tfa_ins2_mk14ebr", "tfa_fml_inss_mk18", "tfa_ins2_mosin_nagant", "tfa_inss_mp7_new", "tfa_ins2_nova", "tfa_ins2_norinco_qbz97", "tfa_ins2_pd2_remington_msr", "tfa_ins2_rpk_74m", "tfa_ins2_l85a2", "tfa_ins2_scar_h_ssr", "tfa_ins2_sks", "tfa_doisten", "tfa_ins2_ump45", "tfa_ins2_br99", "tfa_ins2_vhsd2", "tfa_ins2_xm8", "tfa_fml_p90_tac", "tfa_ins2_krissv", "tfa_ismc_ak12_rpk", "tfa_inss_aks74u", "tfa_new_inss_galil", "tfa_doimp40", "tfa_ins2_rfb", "tfa_at_shak_12", "tfa_ins2_imbelia2", "tfa_doibren", "tfa_doim1918", "tfa_doimg42", "tfa_doistg44", "tfa_ins2_remington_m870", "tfa_ins2_sv98", "tfa_ins2_warface_orsis_t5000", "tfa_ins2_warface_amp_dsr1", "tfa_ins2_warface_ax308", "tfa_nam_m79", "tfa_doilewis", "tfa_doi_enfield", "tfa_doifg42", "tfa_ins2_ar57", "tfa_doiowen", "tfa_ww1_mp18", "tfa_fas2_ppbizon", "tfa_ins2_akms", "tfa_ins2_pm9", "tfa_nam_stevens620", "tfa_ins2_saiga_spike", "tfa_ins2_spectre", "tfa_ins2_groza", "tfa_ins2_sc_evo", "tfa_ins2_spas12", "tfa_ins2_ddm4v5", "tfa_ins2_mx4", "tfa_doi_garand", "tfa_ins2_warface_cheytac_m200", "tfa_ins2_rpg7_scoped", "tfa_fml_lefrench_mas38", "tfa_ins2_minimi", "tfa_ins2_typhoon12", "tfa_ins2_mc255", "tfa_ins2_aa12", "tfa_ins2_sr2m_veresk", "tfa_blast_pindadss2", "tfa_ins2_acrc", "tfa_blast_lynx_msbsb", "tfa_blast_ksvk_cqb", "tfa_ins2_type81"}
	local randSecondary = {"tfa_ins2_colt_m45", "tfa_ins2_cz75", "tfa_ins2_deagle", "tfa_ins2_fiveseven_eft", "tfa_ins2_izh43sw", "tfa_ins2_m9", "tfa_ins2_swmodel10", "tfa_ins2_mr96", "tfa_ins2_ots_33_pernach", "tfa_ins2_s&w_500", "bocw_mac10_alt", "tfa_ins2_walther_p99", "tfa_new_m1911", "tfa_new_glock17", "tfa_inss_makarov", "tfa_new_p226", "tfa_doim3greasegun", "tfa_ins2_gsh18", "tfa_ins2_mk23", "tfa_ins2_mp5k", "tfa_ins_sandstorm_tariq", "tfa_ins2_qsz92", "tfa_ins2_imi_uzi", "tfa_ins2_fnp45", "st_stim_pistol"}
	local randMelee = {"tfa_japanese_exclusive_tanto", "tfa_ararebo_bf1", "tfa_km2000_knife", "fres_grapple"}

	victim:SetNWInt("loadoutPrimary", randPrimary[math.random(#randPrimary)])
	victim:SetNWInt("loadoutSecondary", randSecondary[math.random(#randSecondary)])
	victim:SetNWInt("loadoutMelee", randMelee[math.random(#randMelee)])

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
		net.WriteString(weaponName)
		net.WriteFloat(distance)
		net.Send(attacker)
	end

	if (victim ~= attacker) and (inflictor ~= nil) then
		net.Start("DeathHud")
		net.WriteEntity(attacker)
		net.WriteString(weaponName)
		net.WriteFloat(distance)
		net.Send(victim)

		if attacker:GetPos():Distance(victim:GetPos()) < 5000 then
			victim:SpectateEntity(attacker)
			victim:Spectate(OBS_MODE_DEATHCAM)

			timer.Simple(1, function()
				if not IsValid(victim) or not IsValid(attacker) then return end

				victim:SpectateEntity(attacker)
				victim:Spectate(OBS_MODE_FIXED)

				victim:SendLua("surface.PlaySound('misc/freeze_cam.wav')")
			end)

			timer.Simple(4, function()
				if not IsValid(victim) then return end
				victim:UnSpectate()
			end)
		end
	end

	timer.Create(victim:SteamID() .. "respawnTime", 4, 1, function()
		if victim:GetNWBool("mainmenu") == false then
			victim:Spawn()
		end
	end)

	if attacker:GetNWInt("killStreak") >= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10 * attacker:GetNWInt("killStreak"))
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10 * attacker:GetNWInt("killStreak"))

		if attacker:GetNWInt("killStreak") == 3 then
			attacker:SetNWInt("playerAccoladeOnStreak", attacker:GetNWInt("playerAccoladeOnStreak") + 1)
		end
	end

	if victim:GetNWInt("killStreak") >= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10 * victim:GetNWInt("killStreak"))
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10 * victim:GetNWInt("killStreak"))
		attacker:SetNWInt("playerAccoladeBuzzkill", attacker:GetNWInt("playerAccoladeBuzzkill") + 1)
	end

	if attacker:Health() <= 15 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10)
		attacker:SetNWInt("playerAccoladeLongshot", attacker:GetNWInt("playerAccoladeLongshot") + 1)
	end

	if distance >= 40 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + distance)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + distance)
		attacker:SetNWInt("playerAccoladeLongshot", attacker:GetNWInt("playerAccoladeLongshot") + 1)
	end

	if distance <= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladePointblank", attacker:GetNWInt("playerAccoladePointblank") + 1)
	end

	if weaponName == "Tanto" or weaponName == "Japanese Ararebo" then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeSmackdown", attacker:GetNWInt("playerAccoladeSmackdown") + 1)
	end

	if attacker:GetNWBool("lastShotHead") == true then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeHeadshot", attacker:GetNWInt("playerAccoladeHeadshot") + 1)
	end
end

function GM:ShowHelp(ply)
	if !ply:Alive() then
		ply:ConCommand("tm_openmainmenu")
		ply:SetNWBool("mainmenu", true)
	end
end

function GM:ShowTeam(ply)
	if !ply:Alive() then
		ply:ConCommand("tm_openmainmenu")
		ply:SetNWBool("mainmenu", true)
	end
end

function GM:ShowSpare1(ply)
	if !ply:Alive() then
		ply:ConCommand("tm_openmainmenu")
		ply:SetNWBool("mainmenu", true)
	end
end

function GM:ShowSpare2(ply)
	if !ply:Alive() then
		ply:ConCommand("tm_openmainmenu")
		ply:SetNWBool("mainmenu", true)
	end
end

function CloseMainMenu(ply)
	if ply:GetNWBool("mainmenu") == true then
		ply:SetNWBool("mainmenu", false)
	end
end
concommand.Add("tm_closemainmenu", CloseMainMenu)

hook.Add("PlayerDeathThink", "DisableNormalRespawn", function(ply)
	if timer.Exists(ply:SteamID() .. "respawnTime") then
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
hook.Add("Think", "HealthRegen", Regeneration)

timer.Create("cleanMap", 60, 0, function()
	RunConsoleCommand("r_cleardecals")
end)

function GM:PlayerDisconnected(ply)
	--Statistics
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerScore", ply:GetNWInt("playerScore"))

	--Streaks
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))

	--Customizatoin
	ply:SetPData("chosenPlayermodel", ply:GetNWString("chosenPlayermodel"))

	--Accolades
	ply:SetPData("playerAccoladeOnStreak", ply:GetNWInt("playerAccoladeOnStreak"))
	ply:SetPData("playerAccoladeBuzzkill", ply:GetNWInt("playerAccoladeBuzzkill"))
	ply:SetPData("playerAccoladeLongshot", ply:GetNWInt("playerAccoladeLongshot"))
	ply:SetPData("playerAccoladePointblank", ply:GetNWInt("playerAccoladePointblank"))
	ply:SetPData("playerAccoladeSmackdown", ply:GetNWInt("playerAccoladeSmackdown"))
	ply:SetPData("playerAccoladeHeadshot", ply:GetNWInt("playerAccoladeHeadshot"))
	ply:SetPData("playerAccoladeClutch", ply:GetNWInt("playerAccoladeClutch"))
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

		--Customizatoin
		v:SetPData("chosenPlayermodel", v:GetNWString("chosenPlayermodel"))

		--Accolades
		v:SetPData("playerAccoladeOnStreak", v:GetNWInt("playerAccoladeOnStreak"))
		v:SetPData("playerAccoladeBuzzkill", v:GetNWInt("playerAccoladeBuzzkill"))
		v:SetPData("playerAccoladeLongshot", v:GetNWInt("playerAccoladeLongshot"))
		v:SetPData("playerAccoladePointblank", v:GetNWInt("playerAccoladePointblank"))
		v:SetPData("playerAccoladeSmackdown", v:GetNWInt("playerAccoladeSmackdown"))
		v:SetPData("playerAccoladeHeadshot", v:GetNWInt("playerAccoladeHeadshot"))
		v:SetPData("playerAccoladeClutch", v:GetNWInt("playerAccoladeClutch"))
	end
end