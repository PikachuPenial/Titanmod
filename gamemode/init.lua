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

--This array is for setting up weapon tables and saving weapon statistics.
local weaponArray = {}
weaponArray[1] = {"tfa_ins2_aa12", "AA-12", "primary"}
weaponArray[2] = {"tfa_ins2_acrc", "ACR-C", "primary"}
weaponArray[3] = {"tfa_ins2_aek971", "AEK-971", "primary"}
weaponArray[4] = {"tfa_ins2_akms", "AKMS", "primary"}
weaponArray[5] = {"tfa_inss_aks74u", "AKS-74U", "primary"}
weaponArray[6] = {"tfa_ismc_ak12_rpk", "AK-12 (RPK)", "primary"}
weaponArray[7] = {"tfa_ins2_ak400", "AK-400", "primary"}
weaponArray[8] = {"tfa_ins2_warface_amp_dsr1", "AMP DSR-1", "primary"}
weaponArray[9] = {"tfa_ins2_abakan", "AN-94", "primary"}
weaponArray[10] = {"tfa_ins2_cw_ar15", "AR-15", "primary"}
weaponArray[11] = {"tfa_ins2_ar57", "AR-57", "primary"}
weaponArray[12] = {"tfa_at_shak_12", "ASh-12", "primary"}
weaponArray[13] = {"tfa_inss_asval", "AS-VAL", "primary"}
weaponArray[14] = {"tfa_ins2_warface_awm", "AWM", "primary"}
weaponArray[15] = {"tfa_ins2_warface_ax308", "AX-308", "primary"}
weaponArray[16] = {"tfa_ins2_barrett_m98_bravo", "Barrett M98B", "primary"}
weaponArray[17] = {"tfa_ins2_mx4", "Beretta Mx4", "primary"}
weaponArray[18] = {"tfa_doibren", "Bren", "primary"}
weaponArray[19] = {"tfa_ins2_warface_bt_mp9", "B&T MP9", "primary"}
weaponArray[20] = {"tfa_ins2_warface_cheytac_m200", "CheyTac M200", "primary"}
weaponArray[21] = {"tfa_ins2_m4_9mm", "Colt 9mm", "primary"}
weaponArray[22] = {"tfa_new_m1911", "Colt M1911", "secondary"}
weaponArray[23] = {"tfa_ins2_colt_m45", "Colt M45A1", "secondary"}
weaponArray[24] = {"tfa_ins2_cz75", "CZ 75 B", "secondary"}
weaponArray[25] = {"tfa_ins2_cz805", "CZ 805", "primary"}
weaponArray[26] = {"tfa_ins2_ddm4v5", "DDM4V5", "primary"}
weaponArray[27] = {"tfa_ins2_deagle", "Desert Eagle", "secondary"}
weaponArray[28] = {"tfa_ins2_famas", "Famas F1", "primary"}
weaponArray[29] = {"tfa_blast_lynx_msbsb", "FB MSBS-B", "primary"}
weaponArray[30] = {"tfa_doifg42", "FG 42", "primary"}
weaponArray[31] = {"tfa_ins2_fiveseven_eft", "Fiveseven", "secondary"}
weaponArray[32] = {"tfa_ins2_fn_2000", "FN 2000", "primary"}
weaponArray[33] = {"tfa_ins2_fn_fal", "FN FAL", "primary"}
weaponArray[34] = {"tfa_ins2_fnp45", "FNP-45", "secondary"}
weaponArray[35] = {"tfa_ins2_g28", "G28", "primary"}
weaponArray[36] = {"tfa_new_inss_galil", "Galil", "primary"}
weaponArray[37] = {"tfa_new_glock17", "Glock 17", "secondary"}
weaponArray[38] = {"fres_grapple", "Grappling Hook", "gadget"}
weaponArray[39] = {"tfa_ins2_gsh18", "GSH-18", "secondary"}
weaponArray[40] = {"tfa_ins2_cq300", "Honey Badger", "primary"}
weaponArray[41] = {"tfa_howa_type_64", "Howa Type 64", "primary"}
weaponArray[42] = {"tfa_ins2_hk_mg36", "H&K MG36", "primary"}
weaponArray[43] = {"tfa_inss2_hk_mp5a5", "H&K MP5A5", "primary"}
weaponArray[44] = {"tfa_ins2_imbelia2", "Imbel IA2", "primary"}
weaponArray[45] = {"tfa_ins2_izh43sw", "IZH-43 Sawed Off", "secondary"}
weaponArray[46] = {"tfa_ararebo_bf1", "Japanese Ararebo", "melee"}
weaponArray[47] = {"tfa_km2000_knife", "KM-2000", "melee"}
weaponArray[48] = {"tfa_ins2_krissv", "KRISS Vector", "primary"}
weaponArray[49] = {"tfa_ins2_ksg", "KSG", "primary"}
weaponArray[50] = {"tfa_blast_ksvk_cqb", "KSVK 12.7", "primary"}
weaponArray[51] = {"tfa_doi_enfield", "Lee-Enfield No. 4", "primary"}
weaponArray[52] = {"tfa_doilewis", "Lewis", "primary"}
weaponArray[53] = {"tfa_ins2_zm_lr300", "LR-300", "primary"}
weaponArray[54] = {"tfa_doi_garand", "M1 Garand", "primary"}
weaponArray[55] = {"tfa_doim3greasegun", "M3 Grease Gun", "secondary"}
weaponArray[56] = {"tfa_ins2_m9", "M9", "secondary"}
weaponArray[57] = {"tfa_ins2_m14retro", "M14", "primary"}
weaponArray[58] = {"tfa_nam_m79", "M79", "primary"}
weaponArray[59] = {"tfa_doim1918", "M1918", "primary"}
weaponArray[60] = {"tfa_doim1919", "M1919", "primary"}
weaponArray[61] = {"bocw_mac10_alt", "Mac 10", "secondary"}
weaponArray[62] = {"tfa_inss_makarov", "Makarov", "secondary"}
weaponArray[63] = {"tfa_tfre_maresleg", "Mare's Leg", "secondary"}
weaponArray[64] = {"tfa_fml_lefrench_mas38", "Mas 38", "primary"}
weaponArray[65] = {"tfa_doimg34", "MG 34", "primary"}
weaponArray[66] = {"tfa_doimg42", "MG 42", "primary"}
weaponArray[67] = {"tfa_ins2_minimi", "Minimi Para", "primary"}
weaponArray[68] = {"tfa_ins2_mk23", "MK 23", "secondary"}
weaponArray[69] = {"tfa_fml_inss_mk18", "MK18", "primary"}
weaponArray[70] = {"tfa_ins2_mk14ebr", "Mk. 14 EBR", "primary"}
weaponArray[71] = {"tfa_ins2_swmodel10", "Model 10", "secondary"}
weaponArray[72] = {"tfa_ins2_mosin_nagant", "Mosin Nagant", "primary"}
weaponArray[73] = {"tfa_doimp40", "MP 40", "primary"}
weaponArray[74] = {"tfa_ins2_mp443", "MP-443", "secondary"}
weaponArray[75] = {"tfa_ins2_mp5k", "MP5K", "secondary"}
weaponArray[76] = {"tfa_inss_mp7_new", "MP7A1", "primary"}
weaponArray[77] = {"tfa_ww1_mp18", "MP18", "primary"}
weaponArray[78] = {"tfa_ins2_mr96", "MR-96", "secondary"}
weaponArray[79] = {"tfa_ins2_mc255", "MTs225-12", "primary"}
weaponArray[80] = {"tfa_ins2_nova", "Nova", "primary"}
weaponArray[81] = {"tfa_ins2_warface_orsis_t5000", "Orsis T-5000", "primary"}
weaponArray[82] = {"tfa_l4d2_osp18", "OSP-18", "secondary"}
weaponArray[83] = {"tfa_ins2_groza", "OTs-14 Groza", "primary"}
weaponArray[84] = {"tfa_ins2_ots_33_pernach", "OTs-33 Pernach", "secondary"}
weaponArray[85] = {"tfa_doiowen", "Owen Mk.I", "primary"}
weaponArray[86] = {"tfa_fml_p90_tac", "P90", "primary"}
weaponArray[87] = {"tfa_blast_pindadss2", "PINDAD SS2-V1", "primary"}
weaponArray[88] = {"tfa_ins2_pm9", "PM-9", "primary"}
weaponArray[89] = {"tfa_nam_ppsh41", "PPSH-41", "primary"}
weaponArray[90] = {"tfa_fas2_ppbizon", "PP-Bizon", "primary"}
weaponArray[91] = {"tfa_ww2_pbz39", "PzB 39", "primary"}
weaponArray[92] = {"tfa_ins2_norinco_qbz97", "QBZ-97", "primary"}
weaponArray[93] = {"tfa_ins2_qsz92", "QSZ-92", "secondary"}
weaponArray[94] = {"tfa_ins2_remington_m870", "Remington M870", "primary"}
weaponArray[95] = {"tfa_ins2_pd2_remington_msr", "Remington MSR", "primary"}
weaponArray[96] = {"tfa_ins2_rfb", "RFB", "primary"}
weaponArray[97] = {"tfa_fml_rk62", "RK62", "primary"}
weaponArray[98] = {"tfa_ins2_rpg7_scoped", "RPG-7", "primary"}
weaponArray[99] = {"tfa_ins2_rpk_74m", "RPK-74M", "primary"}
weaponArray[100] = {"tfa_ins2_l85a2", "SA80", "primary"}
weaponArray[101] = {"tfa_ins2_scar_h_ssr", "SCAR-H", "primary"}
weaponArray[102] = {"tfa_ins2_sc_evo", "Scorpion Evo", "primary"}
weaponArray[103] = {"tfa_new_p226", "SIG P226", "secondary"}
weaponArray[104] = {"tfa_ins2_sks", "SKS", "primary"}
weaponArray[105] = {"tfa_ins2_spas12", "SPAS-12", "primary"}
weaponArray[106] = {"tfa_ins2_spectre", "Spectre M4", "primary"}
weaponArray[107] = {"tfa_ins2_saiga_spike", "Spike X15", "primary"}
weaponArray[108] = {"tfa_ins2_sr2m_veresk", "SR-2M Veresk", "primary"}
weaponArray[109] = {"tfa_doisten", "Sten Mk.II", "primary"}
weaponArray[110] = {"tfa_nam_stevens620", "Stevens 620", "primary"}
weaponArray[111] = {"tfa_inss_aug", "Steyr AUG", "primary"}
weaponArray[112] = {"tfa_doistg44", "StG44", "primary"}
weaponArray[113] = {"tfa_ins2_sv98", "SV-98", "primary"}
weaponArray[114] = {"tfa_ins2_s&w_500", "S&W 500", "secondary"}
weaponArray[115] = {"tfa_japanese_exclusive_tanto", "Tanto", "melee"}
weaponArray[116] = {"tfa_ins_sandstorm_tariq", "Tariq", "secondary"}
weaponArray[117] = {"st_stim_pistol", "TCo Stim Pistol", "secondary"}
weaponArray[118] = {"tfa_doithompsonm1928", "Thompson M1928", "primary"}
weaponArray[119] = {"tfa_doithompsonm1a1", "Thompson M1A1", "primary"}
weaponArray[120] = {"tfa_ins2_type81", "Type 81", "primary"}
weaponArray[121] = {"tfa_ins2_typhoon12", "Typhoon F12", "primary"}
weaponArray[122] = {"tfa_ins2_ump45", "UMP .45", "primary"}
weaponArray[123] = {"tfa_ins2_ump9", "UMP9", "primary"}
weaponArray[124] = {"tfa_ins2_imi_uzi", "Uzi", "secondary"}
weaponArray[125] = {"tfa_ins2_br99", "UZK-BR99", "primary"}
weaponArray[126] = {"tfa_ins2_vhsd2", "VHS-D2", "primary"}
weaponArray[127] = {"tfa_ins2_walther_p99", "Walther P99", "secondary"}
weaponArray[128] = {"tfa_ins2_xm8", "XM8", "primary"}

--This array contains all of the information for every map in the map pool.
local mapArray = {}
mapArray[1] = {"tm_arctic", "Arctic", "Snowy close quarters combat.", "maps/thumb/tm_arctic.png"}
mapArray[2] = {"tm_bridge", "Bridge", "Speeding cars act as hazards during your fights.", "maps/thumb/tm_bridge.png"}
mapArray[3] = {"tm_cradle", "Cradle", "Wide and open with many grapple spots.", "maps/thumb/tm_cradle.png"}
mapArray[4] = {"tm_darkstreets", "Dark Streets", "Limited movement and narrow chokepoints.", "maps/thumb/tm_darkstreets.png"}
mapArray[5] = {"tm_firingrange", "Firing Range", "Free weapon spawning, force disabled progression.", "maps/thumb/tm_firingrange.png"}
mapArray[6] = {"tm_grid", "Grid", "Open, vibrant rooms connected via maze-like hallways.", "maps/thumb/tm_grid.png"}
mapArray[7] = {"tm_groves", "Groves", "Sandy environment with countless cover.", "maps/thumb/tm_groves.png"}
mapArray[8] = {"tm_liminal_pool", "Liminal Pool", "Prone to sniping, many movemeny opportunities", "maps/thumb/tm_liminal_pool.png"}
mapArray[9] = {"tm_mall", "Mall", "Spacious shopping center with long sightlines.", "maps/thumb/tm_mall.png"}
mapArray[10] = {"tm_mephitic", "Mephitic", "Dark facility with a continuous acid flood.", "maps/thumb/tm_mephitic.png"}
mapArray[11] = {"tm_nuketown", "Nuketown", "Cult classic, predictible spawns and engagements.", "maps/thumb/tm_nuketown.png"}
mapArray[12] = {"tm_rig", "Rig", "Dark and rainy oil rig.", "maps/thumb/tm_rig.png"}
mapArray[13] = {"tm_rooftops", "Rooftops", "Mix of urban CQB and long range combat.", "maps/thumb/tm_rooftops.png"}
mapArray[14] = {"tm_shipment", "Shipment", "Extremely small and chaotic.", "maps/thumb/tm_shipment.png"}
mapArray[15] = {"tm_station", "Station", "A vertical and open battleground.", "maps/thumb/tm_station.png"}

local availableMaps = {"tm_darkstreets", "tm_grid", "tm_liminal_pool", "tm_mephitic", "tm_nuketown", "tm_rooftops", "tm_cradle", "tm_groves", "tm_mall", "tm_bridge", "tm_shipment", "tm_station", "tm_rig", "tm_arctic", "skip"} -- "skip" will have the map vote end in a continue if it ties with another map, requiring a majority vote for a new map.

--Creating a leveling array, this removes the consistency of the leveling, using developer set XP requierments per level instead of a formula. Is this time consuming? Yes, very much, but it feels more polished IMO.
local levelArray = {}
levelArray[1] = {1, 750} -- +75 XP
levelArray[2] = {2, 825}
levelArray[3] = {3, 900}
levelArray[4] = {4, 975}
levelArray[5] = {5, 1050}
levelArray[6] = {6, 1125}
levelArray[7] = {7, 1200}
levelArray[8] = {8, 1275}
levelArray[9] = {9, 1350}
levelArray[10] = {10, 1450} -- +100 XP
levelArray[11] = {11, 1550}
levelArray[12] = {12, 1650}
levelArray[13] = {13, 1750}
levelArray[14] = {14, 1850}
levelArray[15] = {15, 1950}
levelArray[16] = {16, 2050}
levelArray[17] = {17, 2150}
levelArray[18] = {18, 2250}
levelArray[19] = {19, 2350}
levelArray[20] = {20, 2475} -- +125 XP
levelArray[21] = {21, 2600}
levelArray[22] = {22, 2725}
levelArray[23] = {23, 2850}
levelArray[24] = {24, 2975}
levelArray[25] = {25, 3100}
levelArray[26] = {26, 3225}
levelArray[27] = {27, 3350}
levelArray[28] = {28, 3475}
levelArray[29] = {29, 3600}
levelArray[30] = {30, 3750} -- +150 XP
levelArray[31] = {31, 3900}
levelArray[32] = {32, 4050}
levelArray[33] = {33, 4200}
levelArray[34] = {34, 4350}
levelArray[35] = {35, 4500}
levelArray[36] = {36, 4650}
levelArray[37] = {37, 4800}
levelArray[38] = {38, 4950}
levelArray[39] = {39, 5100}
levelArray[40] = {40, 5275} -- +175 XP
levelArray[41] = {41, 5450}
levelArray[42] = {42, 5625}
levelArray[43] = {43, 5800}
levelArray[44] = {44, 5975}
levelArray[45] = {45, 6150}
levelArray[46] = {46, 6325}
levelArray[47] = {47, 6500}
levelArray[48] = {48, 6675}
levelArray[49] = {49, 6850}
levelArray[50] = {50, 7050} -- +200 XP
levelArray[51] = {51, 7250}
levelArray[52] = {52, 7450}
levelArray[53] = {53, 7650}
levelArray[54] = {54, 7850}
levelArray[55] = {55, 8075} -- +225 XP
levelArray[56] = {56, 8300}
levelArray[57] = {57, 8525}
levelArray[58] = {58, 8750}
levelArray[59] = {59, 8975}
levelArray[60] = {60, "prestige"}

local randPrimary = {}
local randSecondary = {}
local randMelee = {}

--This sets the players loadout for their next spawn. I would do this on player spawn if it weren't for loadout previewing on the Main Menu.
for k, v in pairs(weaponArray) do
	if v[3] == "primary" then
		table.insert(randPrimary, v[1])
	elseif v[3] == "secondary" then
		table.insert(randSecondary, v[1])
	elseif v[3] == "melee" or "gadget" then
		table.insert(randMelee, v[1])
	end
end

--Variables for the proprities of the player, things like health and movement speed.
local playerHealth = 100
local playerSpeedMulti = 1
local healthRegenSpeed = 0.15
local healthRegenDamageDelay = 3.5

--Player setup, things like player movement and their loadout.
function GM:PlayerSpawn(ply)
	ply:UnSpectate()

	ply:SetGravity(.72)
	ply:SetHealth(playerHealth)
	ply:SetMaxHealth(playerHealth)
	ply:SetRunSpeed(275 * playerSpeedMulti)
	ply:SetWalkSpeed(165 * playerSpeedMulti)
	ply:SetJumpPower(150)
	ply:SetLadderClimbSpeed(155 * playerSpeedMulti)
	ply:SetSlowWalkSpeed(78 * playerSpeedMulti)
	ply:SetCrouchedWalkSpeed(0.5)
	ply:SetDuckSpeed(0.65)
	ply:SetUnDuckSpeed(0.65)

	ply:SetModel(ply:GetNWString("chosenPlayermodel"))
	ply:SetupHands()
	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)

	ply:Give(ply:GetNWString("loadoutPrimary"))
	ply:Give(ply:GetNWString("loadoutSecondary"))
	ply:Give(ply:GetNWString("loadoutMelee"))
	ply:SetAmmo(1, "Grenade")

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
	if (ply:GetPData("playerLevel") == nil) then ply:SetNWInt("playerLevel", 1) else ply:SetNWInt("playerLevel", tonumber(ply:GetPData("playerLevel"))) end
	if (ply:GetPData("playerPrestige") == nil) then ply:SetNWInt("playerPrestige", 0) else ply:SetNWInt("playerPrestige", tonumber(ply:GetPData("playerPrestige"))) end
	if (ply:GetPData("playerXP") == nil) then ply:SetNWInt("playerXP", 0) else ply:SetNWInt("playerXP", tonumber(ply:GetPData("playerXP"))) end
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
	if (ply:GetPData("cardPictureOffset") == nil) then ply:SetNWInt("cardPictureOffset", 0) else ply:SetNWInt("cardPictureOffset", tonumber(ply:GetPData("cardPictureOffset"))) end

	--Checking if PData exists for every single fucking gun, gg.
	for k, v in pairs(weaponArray) do
		if (ply:GetPData("killsWith_" .. v[1]) == nil) then ply:SetNWInt("killsWith_" .. v[1], 0) else ply:SetNWInt("killsWith_" .. v[1], tonumber(ply:GetPData("killsWith_" .. v[1]))) end
	end

	--This sets the players loadout as Networked Integers, this is mainly used to show the players loadout in the Main Menu.
	ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
	ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
	ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])

	for k, v in pairs(levelArray) do
		if ply:GetNWInt("playerLevel") == v[1] and v[2] ~= "prestige" then ply:SetNWInt("playerXPToNextLevel", v[2]) end
	end

	--Opens Main Menu on server connect if enabled by the user.
	timer.Create(ply:SteamID() .. "killOnFirstSpawn", 0.2, 1, function()
		ply:KillSilent()
		ply:ConCommand("tm_openmainmenu")
	end)
end

net.Receive("FiringRangeGiveWeapon", function(len, ply)
	local selectedWeapon = net.ReadString()
	ply:StripWeapons()
	ply:Give(selectedWeapon)
end )

util.AddNetworkString("PlayHitsound")
util.AddNetworkString("NotifyKill")
util.AddNetworkString("NotifyDeath")
util.AddNetworkString("NotifyLevelUp")
util.AddNetworkString("KillFeedUpdate")
util.AddNetworkString("MapVoteHUD")
util.AddNetworkString("EndOfGame")
util.AddNetworkString("UpdateClientMapVoteTime")

if game.GetMap() == "tm_firingrange" then
	util.AddNetworkString("FiringRangeGiveWeapon")
end

--Sending a hitsound if a player attacks another player.
local function TestEntityForPlayer(ent)
	return IsValid(ent) and ent:IsPlayer()
end

local function HitSound(target, hitgroup, dmginfo)
	if (TestEntityForPlayer(dmginfo:GetAttacker())) then
		net.Start("PlayHitsound", true)
			net.WriteUInt(hitgroup, 4)
		net.Send(dmginfo:GetAttacker())
	end
end
hook.Add("ScalePlayerDamage", "HitSoundOnPlayerHit", HitSound)

--Rocket jumping.
local function reduceRocketDamage(ent, dmginfo)
	if not dmginfo:IsExplosionDamage() then return end
	if not ent:IsPlayer() then return end
	if dmginfo:GetInflictor():GetClass() == "npc_grenade_frag" then return end

	local attacker = dmginfo:GetAttacker()
	if attacker ~= ent then return end

	local dmgForce = dmginfo:GetDamageForce()
	local newForce = dmgForce * 1.15
	dmginfo:SetDamageForce(newForce)
	ent:SetVelocity(newForce / 70)
	dmginfo:ScaleDamage(0.3)
end
hook.Add("EntityTakeDamage", "rocketjumpsEntityTakeDamage", reduceRocketDamage)

--Tracking statistics and sending the Kill/Death UI on a players death.
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
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 100)

		if attacker:GetNWInt("killStreak") >= attacker:GetNWInt("highestKillStreak") then
			attacker:SetNWInt("highestKillStreak", attacker:GetNWInt("killStreak"))
		end

		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + 1)
		victim:SetNWInt("playerKDR", victim:GetNWInt("playerKills") / victim:GetNWInt("playerDeaths"))

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

	victim:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
	victim:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
	victim:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])

	--Decides if the player should respawn, or if they should not, for instances where the player is in the Main Menu.
	timer.Create(victim:SteamID() .. "respawnTime", 4, 1, function()
		if victim:GetNWBool("mainmenu") == false and victim:GetNWBool("isSpectating") == false and victim ~= nil then
			victim:Spawn()
			victim:UnSpectate()
		end
	end)

	if not attacker:IsPlayer() or (attacker == victim) then
		net.Start("NotifyDeath")
		net.WriteEntity(victim)
		net.WriteString("Suicide")
		net.WriteFloat(0)
		net.WriteBool(false)
		net.Send(victim)

		net.Start("KillFeedUpdate")
		net.WriteString(victim:GetName() .. " commited suicide")
		net.WriteFloat(0)
		net.Broadcast()
		return
	end

	--Sends the Kill and Death UI, as well as initiating the Kill Cam.
	local weaponInfo
	local weaponName
	local rawDistance = victim:GetPos():Distance(attacker:GetPos())
	local distance = math.Round(rawDistance * 0.01905)
	local victimHitgroup = victim:LastHitGroup()

	if (attacker:GetActiveWeapon():IsValid()) then
		weaponInfo = weapons.Get(attacker:GetActiveWeapon():GetClass())
		weaponName = weaponInfo["PrintName"]
	else
		weaponName = ""
	end

	if (victim ~= attacker) and (inflictor ~= nil) then
		net.Start("NotifyKill")
		net.WriteEntity(victim)
		net.WriteString(weaponName)
		net.WriteFloat(distance)
		net.WriteFloat(victimHitgroup)
		net.Send(attacker)

		net.Start("NotifyDeath")
		net.WriteEntity(attacker)
		net.WriteString(weaponName)
		net.WriteFloat(distance)
		net.WriteFloat(victimHitgroup)
		net.Send(victim)

		net.Start("KillFeedUpdate")
		net.WriteString(attacker:GetName() .. " [" .. weaponName .. "] " .. victim:GetName())
		net.WriteFloat(victimHitgroup)
		net.Broadcast()

		--This will start the Kill Cam on a players death, this could look and run much better, but I don't feel like breaking anything right now.
		victim:SpectateEntity(attacker)
		victim:Spectate(OBS_MODE_DEATHCAM)

		timer.Simple(0.75, function()
			if not IsValid(victim) or not IsValid(attacker) then return end
			victim:Spectate(OBS_MODE_FREEZECAM)
		end)

		timer.Simple(2, function()
			if not IsValid(victim) or not IsValid(attacker) then return end
			victim:Spectate(OBS_MODE_IN_EYE)
		end)
	end

	--This scores attackers based on the Accolades they earned on a given kill, this looks pretty messy but its okay, I think.
	if attacker:GetNWInt("killStreak") >= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10 * attacker:GetNWInt("killStreak"))
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10 * attacker:GetNWInt("killStreak"))
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 10 * attacker:GetNWInt("killStreak"))

		if attacker:GetNWInt("killStreak") == 3 then
			attacker:SetNWInt("playerAccoladeOnStreak", attacker:GetNWInt("playerAccoladeOnStreak") + 1)
		end
	end

	if victim:GetNWInt("killStreak") >= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10 * victim:GetNWInt("killStreak"))
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10 * victim:GetNWInt("killStreak"))
		attacker:SetNWInt("playerAccoladeBuzzkill", attacker:GetNWInt("playerAccoladeBuzzkill") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 10 * victim:GetNWInt("killStreak"))
	end

	if attacker:Health() <= 15 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10)
		attacker:SetNWInt("playerAccoladeClutch", attacker:GetNWInt("playerAccoladeClutch") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 20)
	end

	if distance >= 40 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + distance)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + distance)
		attacker:SetNWInt("playerAccoladeLongshot", attacker:GetNWInt("playerAccoladeLongshot") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + distance)
	elseif distance <= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladePointblank", attacker:GetNWInt("playerAccoladePointblank") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 20)
	end

	if weaponName == "Tanto" or weaponName == "Japanese Ararebo" or weaponName == "KM-2000" then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeSmackdown", attacker:GetNWInt("playerAccoladeSmackdown") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 20)
	end

	if victim:SteamID() == attacker:GetNWInt("recentlyKilledBy") and attacker:GetNWBool("gotRevenge") == false then
		if victim:SteamID() == attacker:SteamID() then return end
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10)
		attacker:SetNWInt("playerAccoladeRevenge", attacker:GetNWInt("playerAccoladeRevenge") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 10)
		attacker:SetNWBool("gotRevenge", true)
	end

	if victim:LastHitGroup() == 1 and victim:IsPlayer() then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeHeadshot", attacker:GetNWInt("playerAccoladeHeadshot") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 20)
	end

	CheckForPlayerLevel(attacker)
end

function CheckForPlayerLevel(ply)
	if ply:GetNWInt("playerLevel") == 60 then return end
	local curExp = ply:GetNWInt("playerXP")
	local curLvl = ply:GetNWInt("playerLevel")

	if (curExp >= ply:GetNWInt("playerXPToNextLevel")) then
		curExp = curExp - ply:GetNWInt("playerXPToNextLevel")
		ply:SetNWInt("playerLevel", curLvl + 1)
		ply:SetNWInt("playerXP", curExp)

		for k, v in pairs(levelArray) do
			if (curLvl + 1) == v[1] then ply:SetNWInt("playerXPToNextLevel", v[2]) end
		end

		net.Start("NotifyLevelUp")
		net.WriteFloat(curLvl)
		net.Send(ply)
	end
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
	for _, ply in pairs(player.GetAll()) do
		if (ply:Alive()) then

			if (ply:Health() < (ply.LastHealth or 0)) then
				ply.HealthRegenNext = CurTime() + healthRegenDamageDelay
			end

			if (CurTime() > (ply.HealthRegenNext or 0)) then
				ply.HealthRegen = (ply.HealthRegen or 0) + FrameTime()
			 	if (ply.HealthRegen >= healthRegenSpeed) then
					local add = math.floor(ply.HealthRegen / healthRegenSpeed)
					ply.HealthRegen = ply.HealthRegen - (add * healthRegenSpeed)
					if (ply:Health() < playerHealth or healthRegenSpeed < 0) then
						ply:SetHealth(math.min(ply:Health() + add, playerHealth))
					end
				end
			end

			ply.LastHealth = ply:Health()
		end
	end
end
hook.Add("Think", "HealthRegen", Regeneration)

--Used to clear the map of decals (blood, bullet impacts, etc) every 30 seconds, helps people with shitty computers.
timer.Create("cleanMap", 30, 0, function()
	RunConsoleCommand("r_cleardecals")
end)

local mapVotes
local playersVoted = {}
local mapVoteOpen = false

if table.HasValue(availableMaps, game.GetMap()) and GetConVar("tm_endless"):GetInt() == 0 and game.GetMap() ~= "tm_firingrange" then
	--Sets up Map Voting.
	timer.Create("startMapVote", GetConVar("tm_mapvotetimer"):GetInt(), 0, function()
		mapVotes = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} --Each zero corresponds with a map in the map pool, and the value will increase per vote, add an extra 0 for each map that is added to the map pool.
		playersVoted = {}

		--Failsafe for empty servers, will skip the map vote if a server has no players.
		if #player.GetHumans() == 0 then return end

		mapVoteOpen = true

		local mapPool = {}
		local firstMap
		local secondMap

		--Makes sure that the map currently being played is not added to the map pool.
		for m, v in RandomPairs(mapArray) do
			if game.GetMap() ~= v[1] and v[1] ~= "tm_firingrange" then
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

			mapVoteOpen = false

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
timer.Create("updateClientMapVoteTime", 15, 0, function()
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
	if game.GetMap() == "tm_firingrange" then return end

	--Statistics
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerScore", ply:GetNWInt("playerScore"))

	--Streaks
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))

	--Leveling
	ply:SetPData("playerLevel", ply:GetNWInt("playerLevel"))
	ply:SetPData("playerPrestige", ply:GetNWInt("playerPrestige"))
	ply:SetPData("playerXP", ply:GetNWInt("playerXP"))

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

	--Weapon Statistics
	for p, t in pairs(weaponArray) do
		ply:SetPData("killsWith_" .. t[1], ply:GetNWInt("killsWith_" .. t[1]))
	end
end

function GM:ShutDown()
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	if game.GetMap() == "tm_firingrange" then return end

	for k, v in pairs(player.GetHumans()) do
		--Statistics
		v:SetPData("playerKills", v:GetNWInt("playerKills"))
		v:SetPData("playerDeaths", v:GetNWInt("playerDeaths"))
		v:SetPData("playerKDR", v:GetNWInt("playerKDR"))
		v:SetPData("playerScore", v:GetNWInt("playerScore"))

		--Streaks
		v:SetPData("highestKillStreak", v:GetNWInt("highestKillStreak"))

		--Leveling
		v:SetPData("playerLevel", v:GetNWInt("playerLevel"))
		v:SetPData("playerPrestige", v:GetNWInt("playerPrestige"))
		v:SetPData("playerXP", v:GetNWInt("playerXP"))

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

		--Weapon Statistics
		for p, t in pairs(weaponArray) do
			v:SetPData("killsWith_" .. t[1], v:GetNWInt("killsWith_" .. t[1]))
		end
	end
end