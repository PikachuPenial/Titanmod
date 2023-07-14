AddCSLuaFile("performance/sh_optimization.lua")
AddCSLuaFile("performance/cl_rewrite_entity_index.lua")
AddCSLuaFile("performance/cl_rewrite_player_index.lua")
AddCSLuaFile("performance/cl_rewrite_weapon_index.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("cl_scoreboard.lua")

include("sv_save_manager.lua")
include("shared.lua")
include("sv_gamemode_handler.lua")
include("concommands.lua")

hook.Remove("PlayerTick", "TickWidgets") --Frames per second my beloved.
local activeGamemode = GetGlobal2String("ActiveGamemode", "FFA")
SetGlobal2Bool("tm_matchended", false)

function GM:Initialize()
	print("Titanmod Initialized on " .. game.GetMap() .. " on the " .. activeGamemode .. " gamemode")
end

--Sets up the global match time variable, makes it easily sharable between server and client. I have been using GLua for over a year and I didn't know this fucking existed...
SetGlobal2Int("tm_matchtime", GetConVar("tm_matchlengthtimer"):GetInt())

--Force friendly fire. If it is off, we do not get lag compensation.
RunConsoleCommand("mp_friendlyfire", "1")

function OpenMainMenu(ply)
	net.Start("OpenMainMenu")
	if timer.Exists(ply:SteamID() .. "respawnTime") then net.WriteFloat(timer.TimeLeft(ply:SteamID() .. "respawnTime")) else net.WriteFloat(0) end
	net.Send(ply)
	ply:SetNWBool("mainmenu", true)
end

--Player setup, things like player movement and their loadout.
function GM:PlayerSpawn(ply)
	ply:UnSpectate()
	ply:SetGravity(.72 * playerGravityMulti)
	ply:SetHealth(playerHealth)
	ply:SetMaxHealth(playerHealth)
	ply:SetRunSpeed(275 * playerSpeedMulti)
	ply:SetWalkSpeed(165 * playerSpeedMulti)
	ply:SetJumpPower(150 * playerJumpMulti)
	ply:SetLadderClimbSpeed(155 * playerSpeedMulti)
	ply:SetSlowWalkSpeed(78 * playerSpeedMulti)
	ply:SetCrouchedWalkSpeed(0.6 * playerCrouchWalkSpeedMulti)
	ply:SetDuckSpeed(0.5 * playerDuckStateMulti)
	ply:SetUnDuckSpeed(0.5 * playerDuckStateMulti)
	ply:SetModel(ply:GetNWString("chosenPlayermodel"))
	ply:SetupHands()
	if damageKnockback == false then ply:AddEFlags(EFL_NO_DAMAGE_FORCES) end

	HandlePlayerSpawn(ply)

	ply:SetNWBool("mainmenu", false)
	ply:SetNWInt("killStreak", 0)
	ply:SetNWFloat("linat", 0)
	if ply:GetInfoNum("tm_hud_loadouthint", 1) == 1 and activeGamemode == "FFA" or activeGamemode == "Fiesta" or activeGamemode == "Shotty Snipers" then ply:ConCommand("tm_showloadout") end
	ply:SelectWeapon(ply:GetNWString("loadoutPrimary"))
end

function GM:PlayerInitialSpawn(ply)
	--Checking if PData exists for the player. If the PData exists, it will load the players save. If the PData does not exist, it will create a new save for the player.
	InitializeNetworkInt(ply, "playerKills", 0)
	InitializeNetworkInt(ply, "playerDeaths", 0)
	InitializeNetworkInt(ply, "playerScore", 0)
	InitializeNetworkInt(ply, "matchesPlayed", 0)
	InitializeNetworkInt(ply, "matchesWon", 0)
	InitializeNetworkInt(ply, "highestKillStreak", 0)
	InitializeNetworkInt(ply, "highestKillGame", 0)
	InitializeNetworkInt(ply, "farthestKill", 0)
	InitializeNetworkInt(ply, "playerLevel", 1)
	InitializeNetworkInt(ply, "playerPrestige", 0)
	InitializeNetworkInt(ply, "playerXP", 0)
	InitializeNetworkString(ply, "chosenPlayermodel", "models/player/Group03/male_02.mdl")
	InitializeNetworkString(ply, "chosenPlayercard", "cards/default/construct.png")
	InitializeNetworkInt(ply, "playerAccoladeHeadshot", 0)
	InitializeNetworkInt(ply, "playerAccoladeSmackdown", 0)
	InitializeNetworkInt(ply, "playerAccoladeLongshot", 0)
	InitializeNetworkInt(ply, "playerAccoladePointblank", 0)
	InitializeNetworkInt(ply, "playerAccoladeOnStreak", 0)
	InitializeNetworkInt(ply, "playerAccoladeBuzzkill", 0)
	InitializeNetworkInt(ply, "playerAccoladeClutch", 0)
	ply:SetNWInt("playerID64", ply:SteamID64())
	ply:SetNWString("playerName", ply:Name())

	--Checking if PData exists for every single fucking weapon, GG.
	for k, v in pairs(weaponArray) do
		InitializeNetworkInt(ply, "killsWith_" .. v[1], 0)
	end

	HandlePlayerInitialSpawn(ply)

	--Updates the players XP to next level based on their current level.
	for k, v in pairs(levelArray) do
		if ply:GetNWInt("playerLevel") == v[1] and v[2] ~= "prestige" then ply:SetNWInt("playerXPToNextLevel", v[2]) end
	end

	--Opens Main Menu on server connect if enabled by the user.
	timer.Create(ply:SteamID() .. "killOnFirstSpawn", 0.75, 1, function()
		ply:KillSilent()
		timer.Simple(0.75, function() --Delaying by 0.75 because the menu just doesn't open sometimes, might fix, idk.
			OpenMainMenu(ply)
			sql.Query("UPDATE PlayerData64 SET SteamName = " .. SQLStr(ply:Name()) .. " WHERE SteamID = " .. ply:SteamID64() .. ";")
		end)
	end)
end

util.AddNetworkString("OpenMainMenu")
util.AddNetworkString("CloseMainMenu")
util.AddNetworkString("PlayHitsound")
util.AddNetworkString("NotifyKill")
util.AddNetworkString("NotifyDeath")
util.AddNetworkString("NotifyLevelUp")
util.AddNetworkString("NotifyMatchTime")
util.AddNetworkString("KillFeedUpdate")
util.AddNetworkString("EndOfGame")
util.AddNetworkString("MapVoteCompleted")
util.AddNetworkString("ReceiveMapVote")
util.AddNetworkString("ReceiveModeVote")
util.AddNetworkString("BeginSpectate")
util.AddNetworkString("PlayerModelChange")
util.AddNetworkString("PlayerCardChange")
util.AddNetworkString("GrabLeaderboardData")
util.AddNetworkString("SendLeaderboardData")

net.Receive("BeginSpectate", function(len, ply)
	if ply:Alive() then return end
	ply:SetNWBool("mainmenu", false)
	ply:UnSpectate()
	ply:Spectate(OBS_MODE_ROAMING)
end )

net.Receive("GrabLeaderboardData", function(len, ply)
	if timer.Exists(ply:SteamID64() .. "_GrabBoardDataCooldown") then return end
	timer.Create(ply:SteamID64() .. "_GrabBoardDataCooldown", 1.25, 1, function()
	end)

	local key = net.ReadString()
	local tbl

	if key == "level" then
		tbl = sql.Query("SELECT P.steamid AS SteamID, p.steamname AS SteamName, (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerPrestige') AS prestige, (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerLevel') AS level, ((SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerPrestige') + 1) * 60 + (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerLevel') - 60 AS Value FROM PlayerData64 P GROUP BY P.steamid ORDER BY Value DESC LIMIT 50;")
	elseif key == "kd" then
		tbl = sql.Query("SELECT P.steamid AS SteamID, p.steamname AS SteamName, CAST((SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerKills') as float) / (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerDeaths') AS Value FROM PlayerData64 P GROUP BY p.steamid ORDER BY Value DESC LIMIT 50;")
	elseif key == "wl" then
		tbl = sql.Query("SELECT P.steamid AS SteamID, p.steamname AS SteamName, CAST((SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'matchesWon') as float) / (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'matchesPlayed') * 100 AS Value FROM PlayerData64 P GROUP BY p.steamid ORDER BY Value DESC LIMIT 50;")
	else
		tbl = sql.Query("SELECT SteamID, SteamName, Value FROM PlayerData64 WHERE Key = " .. SQLStr(key) .. " ORDER BY Value + 0 DESC LIMIT 50;")
	end

	net.Start("SendLeaderboardData", true)
	net.WriteTable(tbl)
	net.Send(ply)
end )

--Calculate how much damage should be done to a player based on the hitgroup that was damaged, and send a hitsound to the inflictor of the damage.
local function TestEntityForPlayer(ent)
	return IsValid(ent) and ent:IsPlayer()
end

function GM:ScalePlayerDamage(target, hitgroup, dmginfo)
	if (hitgroup == HITGROUP_HEAD) then dmginfo:ScaleDamage(1.25) elseif (hitgroup == HITGROUP_CHEST) or (hitgroup == HITGROUP_STOMACH) then dmginfo:ScaleDamage(1) elseif (hitgroup == HITGROUP_LEFTARM) or (hitgroup == HITGROUP_RIGHTARM) or (hitgroup == HITGROUP_LEFTLEG) or (hitgroup == HITGROUP_RIGHTLEG) then dmginfo:ScaleDamage(0.75) end --Custom gamemode damage profile
	if (TestEntityForPlayer(dmginfo:GetAttacker())) then
		net.Start("PlayHitsound", true)
			net.WriteUInt(hitgroup, 4)
		net.Send(dmginfo:GetAttacker())
	end
end

--Check if a spawn point is suitable to spawn in (if another player is within proximity of this spawn point, do not spawn the player there.)
hook.Add("IsSpawnpointSuitable", "CheckSpawnPoint", function(ply, spawnpointent, bMakeSuitable)
	local pos = spawnpointent:GetPos()

	local entities = ents.FindInBox(pos + Vector(-512, -512, -384), pos + Vector(512, 512, 384))
	if (ply:Team() == TEAM_SPECTATOR) then return true end
	local entsBlocking = 0

	for _, v in ipairs(entities) do
		if (v:IsPlayer() and v:Alive()) then
			entsBlocking = entsBlocking + 1
		end
	end

	if (entsBlocking > 0) then return false end
	return true
end )

--Rocket jumping.
local function ReduceRocketDamage(ent, dmginfo)
	if rocketJumping == false then return end
	if not dmginfo:IsExplosionDamage() then return end
	if not ent:IsPlayer() then return end
	if dmginfo:GetInflictor():GetClass() == "npc_grenade_frag" then return end

	local attacker = dmginfo:GetAttacker()
	if attacker ~= ent then return end

	local dmgForce = dmginfo:GetDamageForce()
	local newForce = dmgForce * 1.15
	dmginfo:SetDamageForce(newForce)
	ent:SetVelocity((newForce / 70) * rocketJumpForceMulti)
	dmginfo:ScaleDamage(0.3)
end
hook.Add("EntityTakeDamage", "RocketJumpEntityTakeDamage", ReduceRocketDamage)

--Tracking statistics and sending the Kill/Death UI on a players death.
function GM:PlayerDeath(victim, inflictor, attacker)
	if not IsValid(attacker) or victim == attacker or not attacker:IsPlayer() then
		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + 1)
	else
		attacker:SetNWInt("playerKills", attacker:GetNWInt("playerKills") + 1)
		attacker:SetNWInt("killStreak", attacker:GetNWInt("killStreak") + 1)
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 100)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 100)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + (100 * xpMultiplier))

		if attacker:GetNWInt("killStreak") >= attacker:GetNWInt("highestKillStreak") then attacker:SetNWInt("highestKillStreak", attacker:GetNWInt("killStreak")) end

		victim:SetNWInt("playerDeaths", victim:GetNWInt("playerDeaths") + 1)

		if (attacker:GetActiveWeapon():IsValid()) then
			weaponClassName = attacker:GetActiveWeapon():GetClass()
			attacker:SetNWInt("killsWith_" .. weaponClassName, attacker:GetNWInt("killsWith_" .. weaponClassName) + 1)
		end

		attacker:SetNWInt(victim:SteamID() .. "youKilled", attacker:GetNWInt(victim:SteamID() .. "youKilled") + 1)
		if grappleKillReset == true then attacker:SetNWFloat("linat", 0) end
		attacker.HealthRegenNext = 0
	end

	--Decides if the player should respawn, or if they should not, for instances where the player is in the Main Menu.
	timer.Create(victim:SteamID() .. "respawnTime", playerRespawnTime, 1, function()
		if victim:GetNWBool("mainmenu") == false and victim ~= nil then
			if not IsValid(victim) then return end
			if GetGlobal2Bool("tm_matchended") == true then return end
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

		if killFeed == true and suicideInFeed == false then return end
		net.Start("KillFeedUpdate")
		net.WriteString(victim:GetName() .. " commited suicide")
		net.WriteFloat(0)
		net.WriteString(victim:GetName())
		net.WriteInt(1, 10)
		net.Broadcast()

		HandlePlayerDeath(victim, "Suicide")
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
		net.WriteFloat(distance, 32)
		net.WriteInt(victimHitgroup, 5)
		net.WriteInt(attacker:GetNWInt("killStreak"), 10)
		net.Send(attacker)

		net.Start("NotifyDeath")
		net.WriteEntity(attacker)
		net.WriteString(weaponName)
		net.WriteFloat(distance)
		net.WriteInt(victimHitgroup, 5)
		net.Send(victim)

		if killFeed == true then
			net.Start("KillFeedUpdate")
			net.WriteString(attacker:GetName() .. " [" .. weaponName .. "] " .. victim:GetName())
			net.WriteInt(victimHitgroup, 5)
			net.WriteString(attacker:GetName())
			net.WriteInt(attacker:GetNWInt("killStreak"), 10)
			net.Broadcast()
		end

		--This will start the Kill Cam on a players death, this could look and run much better, but I don't feel like breaking anything right now.
		victim:SpectateEntity(attacker)
		victim:Spectate(OBS_MODE_DEATHCAM)

		timer.Simple(0.75, function()
			if not IsValid(victim) or not IsValid(attacker) then return end
			victim:SetObserverMode(OBS_MODE_FREEZECAM)

			timer.Simple(1.25, function()
				if not IsValid(victim) or not IsValid(attacker) then return end
				victim:SetObserverMode(OBS_MODE_IN_EYE)
			end)
		end)
	end

	HandlePlayerDeath(victim, weaponName)
	HandlePlayerKill(attacker, victim)

	if distance >= attacker:GetNWInt("farthestKill") then attacker:SetNWInt("farthestKill", distance) end

	--This scores attackers based on the Accolades they earned on a given kill, this looks pretty messy but its okay, I think.
	if attacker:GetNWInt("killStreak") >= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10 * attacker:GetNWInt("killStreak"))
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10 * attacker:GetNWInt("killStreak"))
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + (10 * attacker:GetNWInt("killStreak") * xpMultiplier))
		if attacker:GetNWInt("killStreak") == 3 then attacker:SetNWInt("playerAccoladeOnStreak", attacker:GetNWInt("playerAccoladeOnStreak") + 1) end
	end

	if victim:GetNWInt("killStreak") >= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10 * victim:GetNWInt("killStreak"))
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10 * victim:GetNWInt("killStreak"))
		attacker:SetNWInt("playerAccoladeBuzzkill", attacker:GetNWInt("playerAccoladeBuzzkill") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + (10 * victim:GetNWInt("killStreak") * xpMultiplier))
	end

	if attacker:Health() <= 15 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeClutch", attacker:GetNWInt("playerAccoladeClutch") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + (20 * xpMultiplier))
	end

	if distance >= 40 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + distance)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + distance)
		attacker:SetNWInt("playerAccoladeLongshot", attacker:GetNWInt("playerAccoladeLongshot") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + (distance * xpMultiplier))
	elseif distance <= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladePointblank", attacker:GetNWInt("playerAccoladePointblank") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + (20 * xpMultiplier))
	end

	if weaponName == "Tanto" or weaponName == "Mace" or weaponName == "KM-2000" then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeSmackdown", attacker:GetNWInt("playerAccoladeSmackdown") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + (20 * xpMultiplier))
	end

	if victim:LastHitGroup() == 1 and victim:IsPlayer() then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeHeadshot", attacker:GetNWInt("playerAccoladeHeadshot") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + (20 * xpMultiplier))
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
		net.WriteInt(curLvl, 8)
		net.Send(ply)
	end
end

net.Receive("CloseMainMenu", function(len, ply)
	ply:SetNWBool("mainmenu", false)
	if not timer.Exists(ply:SteamID() .. "respawnTime") then ply:Spawn() end
end )

--Overwritting the default respawn mechanics to lock players behind a spwan countdown.
function GM:PlayerDeathThink(ply)
	if timer.Exists(ply:SteamID() .. "respawnTime") then
		return false
	end
end

--Allows the Main Menu to change the players current playermodel.
net.Receive("PlayerModelChange", function(len, ply)
	local selectedModel = net.ReadString()
	for k, v in pairs(modelArray) do
		if selectedModel == v[1] then
			local modelID = v[1]
			local modelUnlock = v[3]
			local modelValue = v[4]

			if modelUnlock == "default" then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "kills" and ply:GetNWInt("playerKills") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "headshot" and ply:GetNWInt("playerAccoladeHeadshot") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "smackdown" and ply:GetNWInt("playerAccoladeSmackdown") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "clutch" and ply:GetNWInt("playerAccoladeClutch") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "longshot" and ply:GetNWInt("playerAccoladeLongshot") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "pointblank" and ply:GetNWInt("playerAccoladePointblank") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "killstreaks" and ply:GetNWInt("playerAccoladeOnStreak") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "buzzkills" and ply:GetNWInt("playerAccoladeBuzzkill") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			end
		end
	end
end )

--Allows the Main Menu to change the players current playercard.
net.Receive("PlayerCardChange", function(len, ply)
	local selectedCard = net.ReadString()
	local masteryUnlockReq = 50
	for k, v in pairs(cardArray) do
		if selectedCard == v[1] then
			local cardID = v[1]
			local cardUnlock = v[4]
			local cardValue = v[5]
			local playerTotalLevel = (ply:GetNWInt("playerPrestige") * 60) + ply:GetNWInt("playerLevel")

			if cardUnlock == "default" or cardUnlock == "color" or cardUnlock == "pride" then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "kills" and ply:GetNWInt("playerKills") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "headshot" and ply:GetNWInt("playerAccoladeHeadshot") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "smackdown" and ply:GetNWInt("playerAccoladeSmackdown") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "clutch" and ply:GetNWInt("playerAccoladeClutch") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "longshot" and ply:GetNWInt("playerAccoladeLongshot") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "pointblank" and ply:GetNWInt("playerAccoladePointblank") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "killstreaks" and ply:GetNWInt("playerAccoladeOnStreak") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "buzzkills" and ply:GetNWInt("playerAccoladeBuzzkill") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "level" and playerTotalLevel >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "mastery" and ply:GetNWInt("killsWith_" .. cardValue) >= masteryUnlockReq then
				ply:SetNWString("chosenPlayercard", cardID)
			end
		end
	end
end )

--Player health regeneration after not being hit for a period of time.
if healthRegeneration == true then
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
end

if table.HasValue(availableMaps, game.GetMap()) then
	local mapVoteOpen = false
	local mapVotes = {}
	local modeVotes = {}
	local playersVoted = {}
	local playersVotedMode = {}
	local firstMap
	local secondMap
	local firstMode
	local secondMode

	--Begins the process of ending a match.
	function EndMatch()
		SetGlobal2Bool("tm_matchended", true)
		timer.Remove("matchStatusCheck")

		mapVotes = {}
		playersVoted = {}
		modeVotes = {}
		playersVotedMode = {}

		for k, v in RandomPairs(availableMaps) do
			table.insert(mapVotes, 0)
		end

		for k, v in RandomPairs(gamemodeArray) do
			table.insert(modeVotes, 0)
		end

		mapVoteOpen = true

		local mapPool = {}
		local modePool = {}

		--Makes sure that the map currently being played is not added to the map pool, and check if maps are allowed to be added to the map pool.
		for m, v in RandomPairs(availableMaps) do
			if game.GetMap() ~= v then table.insert(mapPool, v) end
		end

		for p, v in pairs(mapArray) do
			if v[5] ~= 0 and player.GetCount() > v[5] then table.RemoveByValue(mapPool, v[1]) end
		end

		for g, v in RandomPairs(gamemodeArray) do
			table.insert(modePool, v[1])
		end

		firstMap = mapPool[1]
		secondMap = mapPool[2]
		firstMode = modePool[1]
		secondMode = modePool[2]

		hook.Add("PlayerDisconnected", "ServerEmptyDuringVoteCheck", function()
			timer.Create("DelayBeforeEmptyCheck", 5, 1, function() --Delaying by a few seconds, just in case.
				print(player.GetCount())
				if player.GetCount() == 0 then RunConsoleCommand("changelevel", firstMap) end
			end)
		end )

		--Failsafe for empty servers, will skip to a new map if there are no players connected to the server.
		if player.GetCount() == 0 then RunConsoleCommand("changelevel", firstMap) return end

		for k, v in pairs(player.GetAll()) do
			v:SetLaggedMovementValue(0.2)
		end

		net.Start("EndOfGame")
		net.WriteString(firstMap)
		net.WriteString(secondMap)
		net.WriteInt(firstMode, 4)
		net.WriteInt(secondMode, 4)
		net.Broadcast()

		timer.Create("killAfterDelay", 8, 1, function()
			for k, v in pairs(player.GetAll()) do
				v:KillSilent()
			end
		end)

		local connectedPlayers = player.GetHumans()
		if activeGamemode == "FFA" or activeGamemode == "Fiesta" or activeGamemode == "Shotty Snipers" then table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end) elseif activeGamemode == "Gun Game" then table.sort(connectedPlayers, function(a, b) return a:GetNWInt("ladderPosition") > b:GetNWInt("ladderPosition") end) end

		for k, v in pairs(connectedPlayers) do
			if player.GetCount() > 1 then
				v:SetNWInt("matchesPlayed", v:GetNWInt("matchesPlayed") + 1)
				if v:Frags() >= v:GetNWInt("highestKillGame") then v:SetNWInt("highestKillGame", v:Frags()) end
				if k == 1 then
					v:SetNWInt("matchesWon", v:GetNWInt("matchesWon") + 1)
					v:SetNWInt("playerXP", v:GetNWInt("playerXP") + 1500)
					CheckForPlayerLevel(v)
				end
			end
		end

		timer.Create("mapVoteStatus", 23, 1, function()
			local newMapTable = {}
			local newModeTable = {}
			local maxMapVotes = 0
			local maxModeVotes = 0

			for k, v in pairs(mapVotes) do
				if v > maxMapVotes then
					maxMapVotes = v
				end
			end

			for k, v in pairs(availableMaps) do
				if mapVotes[k] == maxMapVotes then
					table.insert(newMapTable, v)
				end
			end

			for k, v in pairs(modeVotes) do
				if v > maxModeVotes then
					maxModeVotes = v
				end
			end

			for k, v in pairs(gamemodeArray) do
				if modeVotes[k] == maxModeVotes then
					table.insert(newModeTable, v[1])
				end
			end

			mapVoteOpen = false
			newMap = newMapTable[math.random(#newMapTable)]
			newMode = newModeTable[math.random(#newModeTable)]

			net.Start("MapVoteCompleted")
			net.WriteString(newMap)
			net.WriteInt(newMode, 4)
			net.Broadcast()
		end)

		timer.Create("newMapCooldown", 33, 1, function()
			RunConsoleCommand("changelevel", newMap)
			RunConsoleCommand("tm_gamemode", newMode)
		end)
	end

	--Calls for a match end once the match timer has concluded.
	local function MatchStatusCheck()
		local currentTime = math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime())
		if CurTime() > GetGlobal2Int("tm_matchtime", 0) then EndMatch() end

		if currentTime == 300 or currentTime == 60 or currentTime == 10 then
			net.Start("NotifyMatchTime")
			net.WriteInt(currentTime, 16)
			net.Broadcast()
		end
	end

	--Checking the match time periodically to determine when a match should end.
	timer.Create("matchStatusCheck", 1, 0, MatchStatusCheck)

	net.Receive("ReceiveMapVote", function(len, ply)
		if playersVoted ~= nil then
			for k, v in pairs(playersVoted) do
				if v == ply then return end
			end
		end

		if mapVoteOpen == false then return end

		local votedMap = net.ReadString()
		local mapIndex = net.ReadUInt(2)
		local validMapVote = false

		for k, v in pairs(availableMaps) do
			if v == votedMap then
				validMapVote = true
				mapVotes[k] = mapVotes[k] + 1
				table.insert(playersVoted, ply)
			end
		end

		if validMapVote == false then return end
		if mapIndex	== 1 then SetGlobal2Int("VotesOnMapOne", GetGlobal2Int("VotesOnMapOne", 0) + 1, 0) elseif mapIndex == 2 then SetGlobal2Int("VotesOnMapTwo", GetGlobal2Int("VotesOnMapTwo", 0) + 1, 0) end
	end )

	net.Receive("ReceiveModeVote", function(len, ply)
		if playersVotedMode ~= nil then
			for k, v in pairs(playersVotedMode) do
				if v == ply then return end
			end
		end

		if mapVoteOpen == false then return end

		local votedMode = net.ReadInt(4)
		local modeIndex = net.ReadUInt(2)
		local validModeVote = false

		for k, v in pairs(gamemodeArray) do
			if v[1] == votedMode then
				validModeVote = true
				modeVotes[k] = modeVotes[k] + 1
				table.insert(playersVotedMode, ply)
			end
		end

		if validModeVote == false then return end
		if modeIndex == 1 then SetGlobal2Int("VotesOnModeOne", GetGlobal2Int("VotesOnModeOne", 0) + 1, 0) elseif modeIndex == 2 then SetGlobal2Int("VotesOnModeTwo", GetGlobal2Int("VotesOnModeTwo", 0) + 1, 0) end
	end )

	function ForceEndMatchCommand(ply, cmd, args)
		if ply:IsSuperAdmin() then EndMatch() end
	end
	concommand.Add("tm_forceendmatch", ForceEndMatchCommand)
end

--Sets up keybinds.
hook.Add("PlayerButtonDown", "NadeCock", function(ply, button)
	if button == ply:GetInfoNum("tm_mainmenubind", KEY_M) and not ply:Alive() then
		net.Start("OpenMainMenu")
		if timer.Exists(ply:SteamID() .. "respawnTime") then net.WriteFloat(timer.TimeLeft(ply:SteamID() .. "respawnTime")) else net.WriteFloat(0) end
		net.Send(ply)
		ply:SetNWBool("mainmenu", true)
	end
	if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("+quicknade") end
	hook.Add("PlayerButtonUp", "NadeThrow", function(ply, button)
		if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("-quicknade") end
	end)
end)

--Allows [F1 - F4] to trigger the Main Menu if the player is not alive.
function GM:ShowHelp(ply)
	if not ply:Alive() then OpenMainMenu() end
end

function GM:ShowTeam(ply)
	if not ply:Alive() then OpenMainMenu() end
end

function GM:ShowSpare1(ply)
	if not ply:Alive() then OpenMainMenu() end
end

function GM:ShowSpare2(ply)
	if not ply:Alive() then OpenMainMenu() end
end

--Auto saves player data if enabled by server admin.
if forceEnableAutoSaveTime ~= 0 then
	timer.Create("serverAutoSaveTimer", forceEnableAutoSaveTime, 0, function()
		for k, v in pairs(player.GetHumans()) do v:ConCommand("tm_forcesave") end
	end)
end

--Chat filter
function ChatFilter(pl, text, team, death)
	for k,v in pairs(chatFilterArray) do text = string.gsub(text, k, v) end
	return text
end
hook.Add("PlayerSay", "FilterHook", ChatFilter)

--Modifies base game voice chat to be proximity based.
hook.Add("PlayerCanHearPlayersVoice", "ProxVOIP", function(listener,talker)
	if not timer.Exists("newMapCooldown") then
		if (tonumber(listener:GetPos():Distance(talker:GetPos())) > proxChatRange) then
			return false, false
		else
			return true, true
		end
	else
		return true, false
	end
end )

--Saves the players statistics when they leave, or when the server shuts down.
function GM:PlayerDisconnected(ply)
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	--Statistics
	UninitializeNetworkInt(ply, "playerKills")
	UninitializeNetworkInt(ply, "playerDeaths")
	UninitializeNetworkInt(ply, "playerScore")
	UninitializeNetworkInt(ply, "matchesPlayed")
	UninitializeNetworkInt(ply, "matchesWon")
	UninitializeNetworkInt(ply, "highestKillStreak")
	UninitializeNetworkInt(ply, "highestKillGame")
	UninitializeNetworkInt(ply, "farthestKill")

	--Leveling
	UninitializeNetworkInt(ply, "playerLevel")
	UninitializeNetworkInt(ply, "playerPrestige")
	UninitializeNetworkInt(ply, "playerXP")

	--Customizatoin
	UninitializeNetworkString(ply, "chosenPlayermodel")
	UninitializeNetworkString(ply, "chosenPlayercard")

	--Accolades
	UninitializeNetworkInt(ply, "playerAccoladeOnStreak")
	UninitializeNetworkInt(ply, "playerAccoladeBuzzkill")
	UninitializeNetworkInt(ply, "playerAccoladeLongshot")
	UninitializeNetworkInt(ply, "playerAccoladePointblank")
	UninitializeNetworkInt(ply, "playerAccoladeSmackdown")
	UninitializeNetworkInt(ply, "playerAccoladeHeadshot")
	UninitializeNetworkInt(ply, "playerAccoladeClutch")

	--Weapon Statistics
	for p, t in pairs(weaponArray) do
		UninitializeNetworkInt(ply, "killsWith_" .. t[1])
	end

	sql.Query("UPDATE PlayerData64 SET SteamName = " .. SQLStr(ply:GetNWString("playerName")) .. " WHERE SteamID = " .. ply:SteamID64() .. ";")
end

function GM:ShutDown()
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	for k, v in pairs(player.GetHumans()) do
		--Statistics
		UninitializeNetworkInt(v, "playerKills")
		UninitializeNetworkInt(v, "playerDeaths")
		UninitializeNetworkInt(v, "playerScore")
		UninitializeNetworkInt(v, "matchesPlayed")
		UninitializeNetworkInt(v, "matchesWon")
		UninitializeNetworkInt(v, "highestKillStreak")
		UninitializeNetworkInt(v, "highestKillGame")
		UninitializeNetworkInt(v, "farthestKill")

		--Leveling
		UninitializeNetworkInt(v, "playerLevel")
		UninitializeNetworkInt(v, "playerPrestige")
		UninitializeNetworkInt(v, "playerXP")

		--Customizatoin
		UninitializeNetworkString(v, "chosenPlayermodel")
		UninitializeNetworkString(v, "chosenPlayercard")

		--Accolades
		UninitializeNetworkInt(v, "playerAccoladeOnStreak")
		UninitializeNetworkInt(v, "playerAccoladeBuzzkill")
		UninitializeNetworkInt(v, "playerAccoladeLongshot")
		UninitializeNetworkInt(v, "playerAccoladePointblank")
		UninitializeNetworkInt(v, "playerAccoladeSmackdown")
		UninitializeNetworkInt(v, "playerAccoladeHeadshot")
		UninitializeNetworkInt(v, "playerAccoladeClutch")

		--Weapon Statistics
		for p, t in pairs(weaponArray) do
			UninitializeNetworkInt(v, "killsWith_" .. t[1])
		end

		sql.Query("UPDATE PlayerData64 SET SteamName = " .. SQLStr(v:GetNWString("playerName")) .. " WHERE SteamID = " .. v:SteamID64() .. ";")
	end
end