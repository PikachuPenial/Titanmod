AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_mainmenu.lua")

include("shared.lua")
include("concommands.lua")

function GM:Initialize()
	print("Titanmod Initialized")
end

--This table is for saving weapon statistics.
local weaponArray = {}
weaponArray[1] = {"tfa_ins2_aa12", "AA-12"}
weaponArray[2] = {"tfa_ins2_acrc", "ACR-C"}
weaponArray[3] = {"tfa_ins2_aek971", "AEK-971"}
weaponArray[4] = {"tfa_ins2_akms", "AKMS"}
weaponArray[5] = {"tfa_inss_aks74u", "AKS-74U"}
weaponArray[6] = {"tfa_ismc_ak12_rpk", "AK-12 (RPK)"}
weaponArray[7] = {"tfa_ins2_ak400", "AK-400"}
weaponArray[8] = {"tfa_ins2_warface_amp_dsr1", "AMP DSR-1"}
weaponArray[9] = {"tfa_ins2_abakan", "AN-94"}
weaponArray[10] = {"tfa_ins2_cw_ar15", "AR-15"}
weaponArray[11] = {"tfa_ins2_ar57", "AR-57"}
weaponArray[12] = {"tfa_at_shak_12", "ASh-12"}
weaponArray[13] = {"tfa_inss_asval", "AS-VAL"}
weaponArray[14] = {"tfa_ins2_warface_awm", "AWM"}
weaponArray[15] = {"tfa_ins2_warface_ax308", "AX-308"}
weaponArray[16] = {"tfa_ins2_barrett_m98_bravo", "Barrett M98B"}
weaponArray[17] = {"tfa_ins2_mx4", "Beretta Mx4 Storm"}
weaponArray[18] = {"tfa_doibren", "Bren"}
weaponArray[19] = {"tfa_ins2_warface_bt_mp9", "B&T MP9"}
weaponArray[20] = {"tfa_ins2_warface_cheytac_m200", "CheyTac M200"}
weaponArray[21] = {"tfa_new_m1911", "Colt M1911"}
weaponArray[22] = {"tfa_ins2_colt_m45", "Colt M45A1"}
weaponArray[23] = {"tfa_ins2_cz75", "CZ 75 B"}
weaponArray[24] = {"tfa_ins2_cz805", "CZ 805 BREN"}
weaponArray[25] = {"tfa_ins2_ddm4v5", "DDM4V5"}
weaponArray[26] = {"tfa_ins2_deagle", "Desert Eagle"}
weaponArray[27] = {"tfa_ins2_famas", "Famas F1"}
weaponArray[28] = {"tfa_blast_lynx_msbsb", "FB MSBS-B"}
weaponArray[29] = {"tfa_doifg42", "FG 42"}
weaponArray[30] = {"tfa_ins2_fiveseven_eft", "Fiveseven"}
weaponArray[31] = {"tfa_ins2_fn_fal", "FN FAL"}
weaponArray[32] = {"tfa_ins2_fnp45", "FNP-45"}
weaponArray[33] = {"tfa_new_inss_galil", "Galil"}
weaponArray[34] = {"tfa_new_glock17", "Glock 17"}
weaponArray[35] = {"fres_grapple", "Grappling Hook"}
weaponArray[36] = {"tfa_ins2_gsh18", "GSH-18"}
weaponArray[37] = {"tfa_howa_type_64", "Howa Type 64"}
weaponArray[38] = {"tfa_ins2_hk_mg36", "H&K MG36"}
weaponArray[39] = {"tfa_inss2_hk_mp5a5", "H&K MP5A5"}
weaponArray[40] = {"tfa_ins2_imbelia2", "Imbel IA2"}
weaponArray[41] = {"tfa_ins2_izh43sw", "IZH-43 Sawed Off"}
weaponArray[42] = {"tfa_ararebo_bf1", "Japanese Ararebo"}
weaponArray[43] = {"tfa_km2000_knife", "KM-2000"}
weaponArray[44] = {"tfa_ins2_krissv", "KRISS Vector"}
weaponArray[45] = {"tfa_ins2_ksg", "KSG"}
weaponArray[46] = {"tfa_blast_ksvk_cqb", "KSVK 12.7"}
weaponArray[47] = {"tfa_doi_enfield", "Lee-Enfield No. 4"}
weaponArray[48] = {"tfa_doilewis", "Lewis"}
weaponArray[49] = {"tfa_doi_garand", "M1 Garand"}
weaponArray[50] = {"tfa_ins2_m14retro", "M14"}
weaponArray[51] = {"tfa_doim3greasegun", "M3 Grease Gun"}
weaponArray[52] = {"tfa_ins2_m9", "M9"}
weaponArray[53] = {"tfa_nam_m79", "M79"}
weaponArray[54] = {"tfa_doim1918", "M1918"}
weaponArray[55] = {"tfa_doim1919", "M1919"}
weaponArray[56] = {"bocw_mac10_alt", "Mac 10"}
weaponArray[57] = {"tfa_inss_makarov", "Makarov"}
weaponArray[58] = {"tfa_fml_lefrench_mas38", "Mas 38"}
weaponArray[59] = {"tfa_doimg34", "MG 34"}
weaponArray[60] = {"tfa_doimg42", "MG 42"}
weaponArray[61] = {"tfa_ins2_minimi", "Minimi Para"}
weaponArray[62] = {"tfa_ins2_mk23", "MK 23"}
weaponArray[63] = {"tfa_fml_inss_mk18", "MK18"}
weaponArray[64] = {"tfa_ins2_mk14ebr", "Mk. 14 EBR"}
weaponArray[65] = {"tfa_ins2_swmodel10", "Model 10"}
weaponArray[66] = {"tfa_ins2_mosin_nagant", "Mosin Nagant"}
weaponArray[67] = {"tfa_doimp40", "MP 40"}
weaponArray[68] = {"tfa_ins2_mp5k", "MP5K"}
weaponArray[69] = {"tfa_inss_mp7_new", "MP7A1"}
weaponArray[70] = {"tfa_ww1_mp18", "MP18"}
weaponArray[71] = {"tfa_ins2_mr96", "MR-96"}
weaponArray[72] = {"tfa_ins2_mc255", "MTs225-12"}
weaponArray[73] = {"tfa_ins2_nova", "Nova"}
weaponArray[74] = {"tfa_ins2_warface_orsis_t5000", "Orsis T-5000"}
weaponArray[75] = {"tfa_ins2_groza", "OTs-14 Groza"}
weaponArray[76] = {"tfa_ins2_ots_33_pernach", "OTs-33 Pernach"}
weaponArray[77] = {"tfa_doiowen", "Owen Mk.I"}
weaponArray[78] = {"tfa_fml_p90_tac", "P90"}
weaponArray[79] = {"tfa_new_pf940", "PF940"}
weaponArray[80] = {"tfa_blast_pindadss2", "PINDAD SS2-V1"}
weaponArray[81] = {"tfa_ins2_pm9", "PM-9"}
weaponArray[82] = {"tfa_nam_ppsh41", "PPSH-41"}
weaponArray[83] = {"tfa_fas2_ppbizon", "PP-Bizon"}
weaponArray[84] = {"tfa_ins2_norinco_qbz97", "QBZ-97"}
weaponArray[85] = {"tfa_ins2_qsz92", "QSZ-92"}
weaponArray[86] = {"tfa_ins2_remington_m870", "Remington M870"}
weaponArray[87] = {"tfa_ins2_pd2_remington_msr", "Remington MSR"}
weaponArray[88] = {"tfa_ins2_rfb", "RFB"}
weaponArray[89] = {"tfa_ins2_rpg7_scoped", "RPG-7"}
weaponArray[90] = {"tfa_ins2_rpk_74m", "RPK-74M"}
weaponArray[91] = {"tfa_ins2_l85a2", "SA80"}
weaponArray[92] = {"tfa_ins2_scar_h_ssr", "SCAR-H SSR"}
weaponArray[93] = {"tfa_ins2_sc_evo", "Scorpion Evo 3"}
weaponArray[94] = {"tfa_new_p226", "SIG P226"}
weaponArray[95] = {"tfa_ins2_sks", "SKS"}
weaponArray[96] = {"tfa_ins2_spas12", "SPAS-12"}
weaponArray[97] = {"tfa_ins2_spectre", "Spectre M4"}
weaponArray[98] = {"tfa_ins2_saiga_spike", "Spike X15"}
weaponArray[99] = {"tfa_ins2_sr2m_veresk", "SR-2M Veresk"}
weaponArray[100] = {"tfa_doisten", "Sten Mk.II"}
weaponArray[101] = {"tfa_nam_stevens620", "Stevens 620"}
weaponArray[102] = {"tfa_inss_aug", "Steyr AUG"}
weaponArray[103] = {"tfa_doistg44", "StG44"}
weaponArray[104] = {"tfa_ins2_sv98", "SV-98"}
weaponArray[105] = {"tfa_ins2_s&w_500", "S&W 500"}
weaponArray[106] = {"tfa_japanese_exclusive_tanto", "Tanto"}
weaponArray[107] = {"tfa_ins_sandstorm_tariq", "Tariq"}
weaponArray[108] = {"st_stim_pistol", "TCo Stim Pistol"}
weaponArray[109] = {"tfa_doithompsonm1928", "Thompson M1928"}
weaponArray[110] = {"tfa_doithompsonm1a1", "Thompson M1A1"}
weaponArray[111] = {"tfa_ins2_type81", "Type 81"}
weaponArray[112] = {"tfa_ins2_typhoon12", "Typhoon F12 Custom"}
weaponArray[113] = {"tfa_ins2_ump45", "UMP .45"}
weaponArray[114] = {"tfa_ins2_ump9", "UMP9"}
weaponArray[115] = {"tfa_ins2_imi_uzi", "Uzi"}
weaponArray[116] = {"tfa_ins2_br99", "UZK-BR99"}
weaponArray[117] = {"tfa_ins2_vhsd2", "VHS-D2"}
weaponArray[118] = {"tfa_ins2_walther_p99", "Walther P99"}
weaponArray[119] = {"tfa_ins2_xm8", "XM8"}

local mapArray = {}
mapArray[1] = {"tm_darkstreets", "Dark Streets", "Limited movement and narrow chokepoints.", "maps/thumb/tm_darkstreets.png"}
mapArray[2] = {"tm_grid", "Grid", "Open, vibrant rooms connected via maze-like hallways.", "maps/thumb/tm_grid.png"}
mapArray[3] = {"tm_liminal_pool", "Liminal Pool", "Prone to sniping, many movemeny opportunities", "maps/thumb/tm_liminal_pool.png"}
mapArray[4] = {"tm_mephitic", "Mephitic", "Dark facility with a continuous acid flood.", "maps/thumb/tm_mephitic.png"}
mapArray[5] = {"tm_nuketown", "Nuketown", "Cult classic, predictible spawns and engagements.", "maps/thumb/tm_nuketown.png"}
--mapArray[6] = {"tm_rooftops", "Rooftops", "Mix of CQB and long range combat.", "maps/thumb/tm_rooftops.png"}
mapArray[6] = {"tm_cradle", "Cradle", "Wide and open with many grapple spots.", "maps/thumb/tm_cradle.png"}
mapArray[7] = {"tm_groves", "Groves", "Sandy environment with countless cover.", "maps/thumb/tm_groves.png"}

local availableMaps = {"tm_darkstreets", "tm_grid", "tm_liminal_pool", "tm_mephitic", "tm_nuketown", "tm_cradle", "tm_groves", "skip"} -- "skip" will have the map vote end in a continue if it ties with another map, requiring a majority vote for a new map.

--Player setup, things like player movement and their loadout.
function GM:PlayerSpawn(ply)
	ply:UnSpectate()

	ply:SetGravity(.72)
	ply:SetMaxHealth(100)
	ply:SetRunSpeed(275)
	ply:SetWalkSpeed(165)
	ply:SetJumpPower(150)

	ply:SetLadderClimbSpeed(155)
	ply:SetSlowWalkSpeed(78)

	ply:SetCrouchedWalkSpeed(0.5)
	ply:SetDuckSpeed(0.65)
	ply:SetUnDuckSpeed(0.65)

	ply:SetModel(ply:GetNWString("chosenPlayermodel"))
	ply:SetupHands()
	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)

	ply:Give(ply:GetNWString("loadoutPrimary"))
	ply:Give(ply:GetNWString("loadoutSecondary"))
	ply:Give(ply:GetNWString("loadoutMelee"))

	ply:SetNWInt("killStreak", 0)
	ply:SetNWFloat("linat", 0)
	ply:SetNWBool("gotRevenge", false)
	ply:SetNWBool("isSpectating", false)
	ply:ConCommand("tm_showloadout")
end

function GM:PlayerInitialSpawn(ply)
	--Checking if PData exists for the player. If the PData exists, it will load the players save. If the PData does not exist, it will create a new save for the player.
	if (ply:GetPData("playerKills") == nil) then ply:SetNWInt("playerKills", 0) else ply:SetNWInt("playerKills", tonumber(ply:GetPData("playerKills"))) end
	if (ply:GetPData("playerDeaths") == nil) then ply:SetNWInt("playerDeaths", 0) else ply:SetNWInt("playerDeaths", tonumber(ply:GetPData("playerDeaths"))) end
	if (ply:GetPData("playerKDR") == nil) then ply:SetNWInt("playerKDR", 1) else ply:SetNWInt("playerKDR", tonumber(ply:GetPData("playerKDR"))) end
	if (ply:GetPData("playerScore") == nil) then ply:SetNWInt("playerScore", 0) else ply:SetNWInt("playerScore", tonumber(ply:GetPData("playerScore"))) end
	if (ply:GetPData("highestKillStreak") == nil) then ply:SetNWInt("highestKillStreak", 0) else ply:SetNWInt("highestKillStreak", tonumber(ply:GetPData("highestKillStreak"))) end
	if (ply:GetPData("chosenPlayermodel") == nil) then ply:SetNWString("chosenPlayermodel", "models/player/Group03/male_02.mdl") else ply:SetNWString("chosenPlayermodel", ply:GetPData("chosenPlayermodel")) end
	if (ply:GetPData("chosenPlayercard") == nil) then ply:SetNWString("chosenPlayercard", "cards/default/construct.png") else ply:SetNWString("chosenPlayercard", ply:GetPData("chosenPlayercard")) end
	if (ply:GetPData("playerAccoladeHeadshot") == nil) then ply:SetNWInt("playerAccoladeHeadshot", 0) else ply:SetNWInt("playerAccoladeHeadshot", tonumber(ply:GetPData("playerAccoladeHeadshot"))) end
	if (ply:GetPData("playerAccoladeSmackdown") == nil) then ply:SetNWInt("playerAccoladeSmackdown", 0) else ply:SetNWInt("playerAccoladeSmackdown", tonumber(ply:GetPData("playerAccoladeSmackdown"))) end
	if (ply:GetPData("playerAccoladeLongshot") == nil) then ply:SetNWInt("playerAccoladeLongshot", 0) else ply:SetNWInt("playerAccoladeLongshot", tonumber(ply:GetPData("playerAccoladeLongshot"))) end
	if (ply:GetPData("playerAccoladePointblank") == nil) then ply:SetNWInt("playerAccoladePointblank", 0) else ply:SetNWInt("playerAccoladePointblank", tonumber(ply:GetPData("playerAccoladePointblank"))) end
	if (ply:GetPData("playerAccoladeOnStreak") == nil) then ply:SetNWInt("playerAccoladeOnStreak", 0) else ply:SetNWInt("playerAccoladeOnStreak", tonumber(ply:GetPData("playerAccoladeOnStreak"))) end
	if (ply:GetPData("playerAccoladeBuzzkill") == nil) then ply:SetNWInt("playerAccoladeBuzzkill", 0) else ply:SetNWInt("playerAccoladeBuzzkill", tonumber(ply:GetPData("playerAccoladeBuzzkill"))) end
	if (ply:GetPData("playerAccoladeClutch") == nil) then ply:SetNWInt("playerAccoladeClutch", 0) else ply:SetNWInt("playerAccoladeClutch", tonumber(ply:GetPData("playerAccoladeClutch"))) end
	if (ply:GetPData("playerAccoladeRevenge") == nil) then ply:SetNWInt("playerAccoladeRevenge", 0) else ply:SetNWInt("playerAccoladeRevenge", tonumber(ply:GetPData("playerAccoladeRevenge"))) end
	if (ply:GetPData("playerAccoladeCopycat") == nil) then ply:SetNWInt("playerAccoladeCopycat", 0) else ply:SetNWInt("playerAccoladeCopycat", tonumber(ply:GetPData("playerAccoladeCopycat"))) end
	if (ply:GetPData("cardPictureOffset") == nil) then ply:SetNWInt("cardPictureOffset", 0) else ply:SetNWInt("cardPictureOffset", tonumber(ply:GetPData("cardPictureOffset"))) end

	--Checking if PData exists for every single fucking gun, gg.
	for k, v in pairs(weaponArray) do
		if (ply:GetPData("killsWith_" .. v[1]) == nil) then ply:SetNWInt("killsWith_" .. v[1], 0) else ply:SetNWInt("killsWith_" .. v[1], tonumber(ply:GetPData("killsWith_" .. v[1]))) end
	end

	--Opens Main Menu on server connect if enabled by the user.
	timer.Create(ply:SteamID() .. "killOnFirstSpawn", 0.2, 1, function()
		ply:KillSilent()
	end)
	ply:ConCommand("tm_openmainmenu")

	--These lists contain each weapon seperated into their respective category, for use in generating player loadouts.
	local randPrimary = {"tfa_nam_ppsh41", "tfa_ins2_aek971", "tfa_ins2_ak400", "tfa_ins2_abakan", "tfa_ins2_cw_ar15", "tfa_inss_asval", "tfa_inss_aug", "tfa_ins2_warface_awm", "tfa_ins2_warface_bt_mp9", "tfa_ins2_barrett_m98_bravo", "tfa_ins2_cz805", "tfa_ins2_famas", "tfa_ins2_fn_fal", "tfa_ins2_hk_mg36", "tfa_inss2_hk_mp5a5", "tfa_howa_type_64", "tfa_ins2_ksg", "tfa_ins2_m14retro", "tfa_doithompsonm1a1", "tfa_ins2_mk14ebr", "tfa_fml_inss_mk18", "tfa_ins2_mosin_nagant", "tfa_inss_mp7_new", "tfa_ins2_nova", "tfa_ins2_norinco_qbz97", "tfa_ins2_pd2_remington_msr", "tfa_ins2_rpk_74m", "tfa_ins2_l85a2", "tfa_ins2_scar_h_ssr", "tfa_ins2_sks", "tfa_doisten", "tfa_ins2_ump45", "tfa_ins2_br99", "tfa_ins2_vhsd2", "tfa_ins2_xm8", "tfa_fml_p90_tac", "tfa_ins2_krissv", "tfa_ismc_ak12_rpk", "tfa_inss_aks74u", "tfa_new_inss_galil", "tfa_doimp40", "tfa_ins2_rfb", "tfa_at_shak_12", "tfa_ins2_imbelia2", "tfa_doibren", "tfa_doim1918", "tfa_doimg42", "tfa_doistg44", "tfa_ins2_remington_m870", "tfa_ins2_sv98", "tfa_ins2_warface_orsis_t5000", "tfa_ins2_warface_amp_dsr1", "tfa_ins2_warface_ax308", "tfa_nam_m79", "tfa_doilewis", "tfa_doi_enfield", "tfa_doifg42", "tfa_ins2_ar57", "tfa_doiowen", "tfa_ww1_mp18", "tfa_fas2_ppbizon", "tfa_ins2_akms", "tfa_ins2_pm9", "tfa_nam_stevens620", "tfa_ins2_saiga_spike", "tfa_ins2_spectre", "tfa_ins2_groza", "tfa_ins2_sc_evo", "tfa_ins2_spas12", "tfa_ins2_ddm4v5", "tfa_ins2_mx4", "tfa_doi_garand", "tfa_ins2_warface_cheytac_m200", "tfa_ins2_rpg7_scoped", "tfa_fml_lefrench_mas38", "tfa_ins2_minimi", "tfa_ins2_typhoon12", "tfa_ins2_mc255", "tfa_ins2_aa12", "tfa_ins2_sr2m_veresk", "tfa_blast_pindadss2", "tfa_ins2_acrc", "tfa_blast_lynx_msbsb", "tfa_blast_ksvk_cqb", "tfa_ins2_type81", "tfa_doim1919", "tfa_doimg34", "tfa_doithompsonm1928"}
	local randSecondary = {"tfa_ins2_colt_m45", "tfa_ins2_cz75", "tfa_ins2_deagle", "tfa_ins2_fiveseven_eft", "tfa_ins2_izh43sw", "tfa_ins2_m9", "tfa_ins2_swmodel10", "tfa_ins2_mr96", "tfa_ins2_ots_33_pernach", "tfa_ins2_s&w_500", "bocw_mac10_alt", "tfa_ins2_walther_p99", "tfa_new_m1911", "tfa_new_glock17", "tfa_inss_makarov", "tfa_new_p226", "tfa_doim3greasegun", "tfa_ins2_gsh18", "tfa_ins2_mk23", "tfa_ins2_mp5k", "tfa_ins_sandstorm_tariq", "tfa_ins2_qsz92", "tfa_ins2_imi_uzi", "tfa_ins2_fnp45", "st_stim_pistol"}
	local randMelee = {"tfa_japanese_exclusive_tanto", "tfa_ararebo_bf1", "tfa_km2000_knife", "fres_grapple"}

	--This sets the players loadout as Networked Integers, this is mainly used to show the players loadout in the Main Menu.
	ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
	ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
	ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
end

util.AddNetworkString("PlayHitsound")
util.AddNetworkString("NotifyKill")
util.AddNetworkString("DeathHud")
util.AddNetworkString("MapVoteHUD")
util.AddNetworkString("EndOfGame")
util.AddNetworkString("UpdateClientMapVoteTime")

--Sending a hitsound if a player attacks another player.
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

--Tracking statistics and sending the Kill/Death UI on a players death.
function GM:PlayerDeath(victim, inflictor, attacker)
	if not IsValid(attacker) or victim == attacker or not attacker:IsPlayer() then
		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + 1)
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))
		victim:SetNWBool("watchingKillCam", false)
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
		victim:SetNWBool("watchingKillCam", false)

		if (attacker:GetActiveWeapon():IsValid()) then
			weaponClassName = attacker:GetActiveWeapon():GetClass()
			attacker:SetNWInt("killsWith_" .. weaponClassName, attacker:GetNWInt("killsWith_" .. weaponClassName) + 1)
		end

		attacker:SetNWInt(victim:SteamID() .. "youKilled", attacker:GetNWInt(victim:SteamID() .. "youKilled") + 1)
		attacker:SetNWFloat("linat", 0)

		if attacker:SteamID() ~= victim:SteamID() then
			victim:SetNWInt("recentlyKilledBy", attacker:SteamID())
		end
	end

	--This sets the players loadout for their next spawn. I would do this on player spawn if it weren't for loadout previewing on the Main Menu.
	local randPrimary = {"tfa_nam_ppsh41", "tfa_ins2_aek971", "tfa_ins2_ak400", "tfa_ins2_abakan", "tfa_ins2_cw_ar15", "tfa_inss_asval", "tfa_inss_aug", "tfa_ins2_warface_awm", "tfa_ins2_warface_bt_mp9", "tfa_ins2_barrett_m98_bravo", "tfa_ins2_cz805", "tfa_ins2_famas", "tfa_ins2_fn_fal", "tfa_ins2_hk_mg36", "tfa_inss2_hk_mp5a5", "tfa_howa_type_64", "tfa_ins2_ksg", "tfa_ins2_m14retro", "tfa_doithompsonm1a1", "tfa_ins2_mk14ebr", "tfa_fml_inss_mk18", "tfa_ins2_mosin_nagant", "tfa_inss_mp7_new", "tfa_ins2_nova", "tfa_ins2_norinco_qbz97", "tfa_ins2_pd2_remington_msr", "tfa_ins2_rpk_74m", "tfa_ins2_l85a2", "tfa_ins2_scar_h_ssr", "tfa_ins2_sks", "tfa_doisten", "tfa_ins2_ump45", "tfa_ins2_br99", "tfa_ins2_vhsd2", "tfa_ins2_xm8", "tfa_fml_p90_tac", "tfa_ins2_krissv", "tfa_ismc_ak12_rpk", "tfa_inss_aks74u", "tfa_new_inss_galil", "tfa_doimp40", "tfa_ins2_rfb", "tfa_at_shak_12", "tfa_ins2_imbelia2", "tfa_doibren", "tfa_doim1918", "tfa_doimg42", "tfa_doistg44", "tfa_ins2_remington_m870", "tfa_ins2_sv98", "tfa_ins2_warface_orsis_t5000", "tfa_ins2_warface_amp_dsr1", "tfa_ins2_warface_ax308", "tfa_nam_m79", "tfa_doilewis", "tfa_doi_enfield", "tfa_doifg42", "tfa_ins2_ar57", "tfa_doiowen", "tfa_ww1_mp18", "tfa_fas2_ppbizon", "tfa_ins2_akms", "tfa_ins2_pm9", "tfa_nam_stevens620", "tfa_ins2_saiga_spike", "tfa_ins2_spectre", "tfa_ins2_groza", "tfa_ins2_sc_evo", "tfa_ins2_spas12", "tfa_ins2_ddm4v5", "tfa_ins2_mx4", "tfa_doi_garand", "tfa_ins2_warface_cheytac_m200", "tfa_ins2_rpg7_scoped", "tfa_fml_lefrench_mas38", "tfa_ins2_minimi", "tfa_ins2_typhoon12", "tfa_ins2_mc255", "tfa_ins2_aa12", "tfa_ins2_sr2m_veresk", "tfa_blast_pindadss2", "tfa_ins2_acrc", "tfa_blast_lynx_msbsb", "tfa_blast_ksvk_cqb", "tfa_ins2_type81", "tfa_doim1919", "tfa_doimg34", "tfa_doithompsonm1928"}
	local randSecondary = {"tfa_ins2_colt_m45", "tfa_ins2_cz75", "tfa_ins2_deagle", "tfa_ins2_fiveseven_eft", "tfa_ins2_izh43sw", "tfa_ins2_m9", "tfa_ins2_swmodel10", "tfa_ins2_mr96", "tfa_ins2_ots_33_pernach", "tfa_ins2_s&w_500", "bocw_mac10_alt", "tfa_ins2_walther_p99", "tfa_new_m1911", "tfa_new_glock17", "tfa_inss_makarov", "tfa_new_p226", "tfa_doim3greasegun", "tfa_ins2_gsh18", "tfa_ins2_mk23", "tfa_ins2_mp5k", "tfa_ins_sandstorm_tariq", "tfa_ins2_qsz92", "tfa_ins2_imi_uzi", "tfa_ins2_fnp45", "st_stim_pistol"}
	local randMelee = {"tfa_japanese_exclusive_tanto", "tfa_ararebo_bf1", "tfa_km2000_knife", "fres_grapple"}

	victim:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
	victim:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
	victim:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])

	--Decides if the player should respawn, or if they should not, for instances where the player is in the Main Menu.
	timer.Create(victim:SteamID() .. "respawnTime", 4, 1, function()
		if victim:GetNWBool("mainmenu") == false and victim:GetNWBool("isSpectating") == false then
			victim:SetNWBool("watchingKillCam", false)
			victim:Spawn()
			victim:UnSpectate()
		end
	end)

	if not attacker:IsPlayer() then
		net.Start("DeathHud")
		net.WriteEntity(victim)
		net.WriteString("Suicide")
		net.WriteFloat(0)
		net.Send(victim)
		return
	end

	--Sends the Kill and Death UI, as well as initiating the Kill Cam.
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

		--This will start the Kill Cam on a players death, this could look and run much better, but I don't feel like breaking anything right now.
		if attacker:GetPos():Distance(victim:GetPos()) < 5000 then
			victim:SetNWBool("watchingKillCam", true)
			victim:SpectateEntity(attacker)
			victim:Spectate(OBS_MODE_DEATHCAM)

			timer.Simple(0.75, function()
				if not IsValid(victim) or not IsValid(attacker) then return end

				victim:SpectateEntity(attacker)
				victim:Spectate(OBS_MODE_FREEZECAM)
			end)

			timer.Simple(2, function()
				if not IsValid(victim) or not IsValid(attacker) then return end

				victim:SpectateEntity(attacker)
				victim:Spectate(OBS_MODE_IN_EYE)
				--victim:SendLua("surface.PlaySound('misc/freeze_cam.wav')")
			end)
		end
	end

	--This scores attackers based on the Accolades they earned on a given kill, this looks pretty messy but its okay, I think.
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
		attacker:SetNWInt("playerAccoladeClutch", attacker:GetNWInt("playerAccoladeClutch") + 1)
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

	if weaponName == "Tanto" or weaponName == "Japanese Ararebo" or weaponName == "KM-2000" then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeSmackdown", attacker:GetNWInt("playerAccoladeSmackdown") + 1)
	end

	if attacker:GetNWBool("lastShotHead") == true then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeHeadshot", attacker:GetNWInt("playerAccoladeHeadshot") + 1)
	end

	if victim:SteamID() == attacker:GetNWInt("recentlyKilledBy") and attacker:GetNWBool("gotRevenge") == false then
		if victim:SteamID() == attacker:SteamID() then return end
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10)
		attacker:SetNWInt("playerAccoladeRevenge", attacker:GetNWInt("playerAccoladeRevenge") + 1)
		attacker:SetNWBool("gotRevenge", true)
	end

	--if victim ~= attacker and attacker:IsPlayer() and attacker:GetActiveWeapon():GetClass() == attacker:GetNWString("loadoutPrimary") and victim:GetNWString("loadoutPrimary") or attacker:GetNWString("loadoutSecondary") and victim:GetNWString("loadoutSecondary") or attacker:GetNWString("loadoutMelee") and victim:GetNWString("loadoutMelee") then
		--attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 40)
		--attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 40)
		--attacker:SetNWInt("playerAccoladeCopycat", attacker:GetNWInt("playerAccoladeCopycat") + 1)
	--end
end

--Allows [F1 - F4] to trigger the Main Menu if the player is not alive.
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

--Lets the server know when a player is no longer in the Main Menu.
function CloseMainMenu(ply)
	if ply:GetNWBool("mainmenu") == true then
		ply:SetNWBool("mainmenu", false)
	end

	if ply:GetNWBool("watchingKillCam") == true then
		ply:SetNWBool("watchingKillCam", false)
	end
end
concommand.Add("tm_closemainmenu", CloseMainMenu)

--Overwritting the default respawn mechanics to lock players behind a spwan countdown.
hook.Add("PlayerDeathThink", "DisableNormalRespawn", function(ply)
	if timer.Exists(ply:SteamID() .. "respawnTime") or timer.Exists("newMapCooldown") then
		return false
	end
end)

--Player health regeneration after not being hit for 3.5 seconds.
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

--Used to clear the map of decals (blood, bullet impacts, etc) every minute, helps people with shitty computers.
timer.Create("cleanMap", 60, 0, function()
	RunConsoleCommand("r_cleardecals")
end)

local mapVotes
local playersVoted = {}
local mapVoteOpen = false

if table.HasValue(availableMaps, game.GetMap()) and GetConVar("tm_endless"):GetInt() == 0 then
	--Sets up Map Voting.
	timer.Create("startMapVote", GetConVar("tm_mapvotetimer"):GetInt(), 0, function()
		mapVotes = {0, 0, 0, 0, 0, 0, 0, 0, 0} --Each zero corresponds with a map in the map pool, and the value will increase per vote, add an extra 0 for each map that is added to the map pool.
		playersVoted = {}

		--Failsafe for empty servers, will skip the map vote if a server has no players.
		if #player.GetHumans() == 0 then print("Map Vote skipped as their are no players on the server.") return end

		mapVoteOpen = true

		local mapPool = {}
		local firstMap
		local secondMap

		--Makes sure that the map currently being played is not added to the map pool.
		for m, v in RandomPairs(mapArray) do
			if game.GetMap() ~= v[1] then
				table.insert(mapPool, v[1])
			end
		end

		firstMap = mapPool[1]
		secondMap = mapPool[2]

		net.Start("MapVoteHUD")
		net.WriteString(firstMap)
		net.WriteString(secondMap)
		net.Broadcast()

		timer.Create("mapVoteStatus", 20, 1, function()
			local newMapTable = {}
			local maxVotes = 0

			for k, v in pairs(mapVotes) do
				if v > maxVotes then
					maxVotes = v
				end
			end

			for k, v in pairs(availableMaps) do
				if mapVotes[k] == maxVotes then
					table.insert(newMapTable, v)
				end
			end

			--If players vote to continue on current map, end the map vote and restart the timer, otherwise, begin the intermission process.
			if maxVotes == 0 or table.HasValue(newMapTable, "skip") == true then PrintMessage(HUD_PRINTTALK, "Play will continue on this map as voted for, a new map vote will commence in " .. GetConVar("tm_mapvotetimer"):GetInt() .. " seconds!") return end

			newMap = newMapTable[math.random(#newMapTable)]

			for k, v in pairs(player.GetAll()) do
				v:KillSilent()
			end

			net.Start("EndOfGame")
			net.WriteString(newMap)
			net.Broadcast()

			timer.Create("newMapCooldown", 30, 1, function()
				RunConsoleCommand("changelevel", newMap)
			end)
		end)
	end)

	local function PlayerMapVote(ply, cmd, args)
		if args[1] == nil then return end

		if playersVoted ~= nil then
			for k, v in pairs(playersVoted) do
				if v == ply then return end
			end
		end

		if mapVoteOpen == false then print("You can not vote for a map, as the map vote is not open yet.") return end

		local votedMap = args[1]
		local validMapVote = false

		for k, v in pairs(availableMaps) do
			if v == votedMap then
				validMapVote = true
				mapVotes[k] = mapVotes[k] + 1
			end
		end

		if validMapVote == false then return end
	end
	concommand.Add("tm_voteformap", PlayerMapVote)
end

local clientMapTimeLeft
timer.Create("updateClientMapVoteTime", 10, 0, function()
	if timer.Exists("startMapVote") then
		clientMapTimeLeft = math.Round(timer.TimeLeft("startMapVote"))

		net.Start("UpdateClientMapVoteTime", true)
		net.WriteFloat(clientMapTimeLeft)
		net.Broadcast()
	end
end)

--Saves the players statistics when they leave, or when the server shuts down.
function GM:PlayerDisconnected(ply)
	if GetConVar("tm_developermode"):GetInt() == 1 then return end

	--Statistics
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerScore", ply:GetNWInt("playerScore"))

	--Streaks
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))

	--Customizatoin
	ply:SetPData("chosenPlayermodel", ply:GetNWString("chosenPlayermodel"))
	ply:SetPData("chosenPlayercard", ply:GetNWString("chosenPlayercard"))
	ply:SetPData("cardPictureOffset", ply:GetNWInt("cardPictureOffset"))

	--Accolades
	ply:SetPData("playerAccoladeOnStreak", ply:GetNWInt("playerAccoladeOnStreak"))
	ply:SetPData("playerAccoladeBuzzkill", ply:GetNWInt("playerAccoladeBuzzkill"))
	ply:SetPData("playerAccoladeLongshot", ply:GetNWInt("playerAccoladeLongshot"))
	ply:SetPData("playerAccoladePointblank", ply:GetNWInt("playerAccoladePointblank"))
	ply:SetPData("playerAccoladeSmackdown", ply:GetNWInt("playerAccoladeSmackdown"))
	ply:SetPData("playerAccoladeHeadshot", ply:GetNWInt("playerAccoladeHeadshot"))
	ply:SetPData("playerAccoladeClutch", ply:GetNWInt("playerAccoladeClutch"))
	ply:SetPData("playerAccoladeRevenge", ply:GetNWInt("playerAccoladeRevenge"))
	ply:SetPData("playerAccoladeCopycat", ply:GetNWInt("playerAccoladeCopycat"))

	--Weapon Statistics
	for p, t in pairs(weaponArray) do
		ply:SetPData("killsWith_" .. t[1], ply:GetNWInt("killsWith_" .. t[1]))
	end
end

function GM:ShutDown()
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
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
		v:SetPData("chosenPlayercard", v:GetNWString("chosenPlayercard"))
		v:SetPData("cardPictureOffset", v:GetNWInt("cardPictureOffset"))

		--Accolades
		v:SetPData("playerAccoladeOnStreak", v:GetNWInt("playerAccoladeOnStreak"))
		v:SetPData("playerAccoladeBuzzkill", v:GetNWInt("playerAccoladeBuzzkill"))
		v:SetPData("playerAccoladeLongshot", v:GetNWInt("playerAccoladeLongshot"))
		v:SetPData("playerAccoladePointblank", v:GetNWInt("playerAccoladePointblank"))
		v:SetPData("playerAccoladeSmackdown", v:GetNWInt("playerAccoladeSmackdown"))
		v:SetPData("playerAccoladeHeadshot", v:GetNWInt("playerAccoladeHeadshot"))
		v:SetPData("playerAccoladeClutch", v:GetNWInt("playerAccoladeClutch"))
		v:SetPData("playerAccoladeRevenge", v:GetNWInt("playerAccoladeRevenge"))
		v:SetPData("playerAccoladeCopycat", v:GetNWInt("playerAccoladeCopycat"))

		--Weapon Statistics
		for p, t in pairs(weaponArray) do
			v:SetPData("killsWith_" .. t[1], v:GetNWInt("killsWith_" .. t[1]))
		end
	end
end