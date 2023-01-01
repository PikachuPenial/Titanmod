AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("config.lua")

include("shared.lua")
include("concommands.lua")
include("config.lua")

function GM:Initialize()
	print("Titanmod Initialized")
end

local randPrimary = {}
local randSecondary = {}
local randMelee = {}

--This sets the players loadout for their next spawn. I would do this on player spawn if it weren't for loadout previewing on the Main Menu.
for k, v in pairs(weaponArray) do
	if v[3] == "primary" then
		table.insert(randPrimary, v[1])
	elseif v[3] == "secondary" then
		table.insert(randSecondary, v[1])
	elseif v[3] == "melee" and useMelee == true or "gadget" and useGadget == true then
		table.insert(randMelee, v[1])
	end
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
	ply:SetCrouchedWalkSpeed(0.5 * playerCrouchWalkSpeedMulti)
	ply:SetDuckSpeed(0.65 * playerDuckStateMulti)
	ply:SetUnDuckSpeed(0.65 * playerDuckStateMulti)

	ply:SetModel(ply:GetNWString("chosenPlayermodel"))
	ply:SetupHands()
	if damageKnockback == false then ply:AddEFlags(EFL_NO_DAMAGE_FORCES) end

	ply:Give(ply:GetNWString("loadoutPrimary"))
	ply:Give(ply:GetNWString("loadoutSecondary"))
	ply:Give(ply:GetNWString("loadoutMelee"))
	ply:SetAmmo(grenadesOnSpawn, "Grenade")

	ply:SetNWInt("killStreak", 0)
	ply:SetNWFloat("linat", 0)
	ply:ConCommand("tm_showloadout")
end

function GM:PlayerInitialSpawn(ply)
	--Checking if PData exists for the player. If the PData exists, it will load the players save. If the PData does not exist, it will create a new save for the player.
	if (ply:GetPData("playerKills") == nil) then ply:SetNWInt("playerKills", 0) else ply:SetNWInt("playerKills", tonumber(ply:GetPData("playerKills"))) end
	if (ply:GetPData("playerDeaths") == nil) then ply:SetNWInt("playerDeaths", 0) else ply:SetNWInt("playerDeaths", tonumber(ply:GetPData("playerDeaths"))) end
	if (ply:GetPData("playerKDR") == nil) then ply:SetNWInt("playerKDR", 1) else ply:SetNWInt("playerKDR", tonumber(ply:GetPData("playerKDR"))) end
	if (ply:GetPData("playerScore") == nil) then ply:SetNWInt("playerScore", 0) else ply:SetNWInt("playerScore", tonumber(ply:GetPData("playerScore"))) end
	if (ply:GetPData("matchesPlayed") == nil) then ply:SetNWInt("matchesPlayed", 0) else ply:SetNWInt("matchesPlayed", tonumber(ply:GetPData("matchesPlayed"))) end
	if (ply:GetPData("matchesWon") == nil) then ply:SetNWInt("matchesWon", 0) else ply:SetNWInt("matchesWon", tonumber(ply:GetPData("matchesWon"))) end
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

	--Checking if PData exists for every single fucking weapon, GG.
	for k, v in pairs(weaponArray) do
		if (ply:GetPData("killsWith_" .. v[1]) == nil) then ply:SetNWInt("killsWith_" .. v[1], 0) else ply:SetNWInt("killsWith_" .. v[1], tonumber(ply:GetPData("killsWith_" .. v[1]))) end
	end

	--This sets the players loadout as Networked Strings, this is mainly used to show the players loadout in the Main Menu.
	if usePrimary == true then ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)]) end
	if useSecondary == true then  ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)]) end
	if useMelee == true or useGadget == true then ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)]) end

	--Updates the players XP to next level based on their current level.
	for k, v in pairs(levelArray) do
		if ply:GetNWInt("playerLevel") == v[1] and v[2] ~= "prestige" then ply:SetNWInt("playerXPToNextLevel", v[2]) end
	end

	--Opens Main Menu on server connect if enabled by the user.
	timer.Create(ply:SteamID() .. "killOnFirstSpawn", 0.75, 1, function()
		ply:KillSilent()
		timer.Simple(0.25, function() ply:ConCommand("tm_openmainmenu") end) --Delaying by 0.25 because the menu just doesn't open sometimes, might fix, idk.
	end)
end

util.AddNetworkString("PlayHitsound")
util.AddNetworkString("NotifyKill")
util.AddNetworkString("NotifyDeath")
util.AddNetworkString("NotifyLevelUp")
util.AddNetworkString("KillFeedUpdate")
util.AddNetworkString("MapVoteHUD")
util.AddNetworkString("EndOfGame")
util.AddNetworkString("UpdateClientMapVoteTime")

--Enables the weapon spawner if its turned on in the config, or if playing on the Firing Range map.
if game.GetMap() == "tm_firingrange" or forceEnableWepSpawner == true then
	util.AddNetworkString("FiringRangeGiveWeapon")
end

net.Receive("FiringRangeGiveWeapon", function(len, ply)
	local selectedWeapon = net.ReadString()
	ply:StripWeapons()
	ply:Give(selectedWeapon)
end )

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
	if rocketJumping == false then return end
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
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 100 * xpMultiplier)

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
		if grappleKillReset == true then attacker:SetNWFloat("linat", 0) end
	end

	if usePrimary == true then victim:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)]) end
	if useSecondary == true then  victim:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)]) end
	if useMelee == true or useGadget == true then victim:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)]) end

	--Decides if the player should respawn, or if they should not, for instances where the player is in the Main Menu.
	timer.Create(victim:SteamID() .. "respawnTime", playerRespawnTime, 1, function()
		if victim:GetNWBool("mainmenu") == false and victim ~= nil then
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
		net.WriteEntity(victim)
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
		net.WriteEntity(attacker)
		net.Broadcast()

		--This will start the Kill Cam on a players death, this could look and run much better, but I don't feel like breaking anything right now.
		victim:SpectateEntity(attacker)
		victim:Spectate(OBS_MODE_DEATHCAM)

		timer.Simple(0.75, function()
			if not IsValid(victim) or not IsValid(attacker) then return end
			victim:Spectate(OBS_MODE_FREEZECAM)

			timer.Simple(1.25, function()
				if not IsValid(victim) or not IsValid(attacker) then return end
				victim:Spectate(OBS_MODE_IN_EYE)
			end)
		end)
	end

	--This scores attackers based on the Accolades they earned on a given kill, this looks pretty messy but its okay, I think.
	if attacker:GetNWInt("killStreak") >= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10 * attacker:GetNWInt("killStreak"))
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10 * attacker:GetNWInt("killStreak"))
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 10 * attacker:GetNWInt("killStreak") * xpMultiplier)

		if attacker:GetNWInt("killStreak") == 3 then
			attacker:SetNWInt("playerAccoladeOnStreak", attacker:GetNWInt("playerAccoladeOnStreak") + 1)
		end
	end

	if victim:GetNWInt("killStreak") >= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 10 * victim:GetNWInt("killStreak"))
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 10 * victim:GetNWInt("killStreak"))
		attacker:SetNWInt("playerAccoladeBuzzkill", attacker:GetNWInt("playerAccoladeBuzzkill") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 10 * victim:GetNWInt("killStreak") * xpMultiplier)
	end

	if attacker:Health() <= 15 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeClutch", attacker:GetNWInt("playerAccoladeClutch") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 20 * xpMultiplier)
	end

	if distance >= 40 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + distance)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + distance)
		attacker:SetNWInt("playerAccoladeLongshot", attacker:GetNWInt("playerAccoladeLongshot") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + distance * xpMultiplier)
	elseif distance <= 3 then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladePointblank", attacker:GetNWInt("playerAccoladePointblank") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 20 * xpMultiplier)
	end

	if weaponName == "Tanto" or weaponName == "Japanese Ararebo" or weaponName == "KM-2000" then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeSmackdown", attacker:GetNWInt("playerAccoladeSmackdown") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 20 * xpMultiplier)
	end

	if victim:LastHitGroup() == 1 and victim:IsPlayer() then
		attacker:SetNWInt("playerScore", attacker:GetNWInt("playerScore") + 20)
		attacker:SetNWInt("playerScoreMatch", attacker:GetNWInt("playerScoreMatch") + 20)
		attacker:SetNWInt("playerAccoladeHeadshot", attacker:GetNWInt("playerAccoladeHeadshot") + 1)
		attacker:SetNWInt("playerXP", attacker:GetNWInt("playerXP") + 20 * xpMultiplier)
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
	if not ply:Alive() then
		ply:ConCommand("tm_openmainmenu")
		ply:SetNWBool("mainmenu", true)
	end
end

function GM:ShowTeam(ply)
	if not ply:Alive() then
		ply:ConCommand("tm_openmainmenu")
		ply:SetNWBool("mainmenu", true)
	end
end

function GM:ShowSpare1(ply)
	if not ply:Alive() then
		ply:ConCommand("tm_openmainmenu")
		ply:SetNWBool("mainmenu", true)
	end
end

function GM:ShowSpare2(ply)
	if not ply:Alive() then
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
timer.Create("cleanMap", mapCleanupTime, 0, function()
	RunConsoleCommand("r_cleardecals")
end)

local mapVoteOpen = false
local mapVotes = {}
local playersVoted = {}
local firstMap
local secondMap

if table.HasValue(availableMaps, game.GetMap()) and GetConVar("tm_endless"):GetInt() ~= 1 and game.GetMap() ~= "tm_firingrange" then
	--Sets up Map Voting.
	timer.Create("startMapVote", mapVoteTimer, 0, function()
		mapVotes = {}
		playersVoted = {}

		for k, v in RandomPairs(availableMaps) do
			table.insert(mapVotes, 0)
		end

		--Failsafe for empty servers, will skip the map vote if a server has no players.
		if #player.GetHumans() == 0 then return end

		mapVoteOpen = true

		local mapPool = {}

		--Makes sure that the map currently being played is not added to the map pool.
		for m, v in RandomPairs(availableMaps) do
			if game.GetMap() ~= v and v ~= "tm_firingrange" and v ~= "skip" then
				table.insert(mapPool, v)
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
			if maxVotes == 0 or table.HasValue(newMapTable, "skip") == true then PrintMessage(HUD_PRINTTALK, "Play will continue on this map as voted for, a new map vote will commence in " .. mapVoteTimer .. " seconds!") return end

			newMap = newMapTable[math.random(#newMapTable)]

			for k, v in pairs(player.GetAll()) do
				v:KillSilent()
			end

			net.Start("EndOfGame")
			net.WriteString(newMap)
			net.Broadcast()

			local connectedPlayers = player.GetAll()
			table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end)

			for k, v in pairs(connectedPlayers) do
				v:SetNWInt("matchesPlayed", v:GetNWInt("matchesPlayed") + 1)
				if k == 1 then v:SetNWInt("matchesWon", v:GetNWInt("matchesWon") + 1) end
			end

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

		if validMapVote == false then print("The map you attempted to vote for does not exist.") return end
		--if votedMap ~= firstMap or votedMap ~= secondMap then print("The map you attempted to vote for was not picked for this voting phase.") return end
	end
	concommand.Add("tm_voteformap", PlayerMapVote)

	local clientMapTimeLeft
	timer.Create("updateClientMapVoteTime", 15, 0, function()
		clientMapTimeLeft = math.Round(timer.TimeLeft("startMapVote"))

		net.Start("UpdateClientMapVoteTime", true)
		net.WriteFloat(clientMapTimeLeft)
		net.Broadcast()
	end)
end

--Saves the players statistics when they leave, or when the server shuts down.
function GM:PlayerDisconnected(ply)
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	if game.GetMap() == "tm_firingrange" then return end
	if forceDisableProgression == true then return end

	--Statistics
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerScore", ply:GetNWInt("playerScore"))
	ply:SetPData("matchesPlayed", ply:GetNWInt("matchesPlayed"))
	ply:SetPData("matchesWon", ply:GetNWInt("matchesWon"))

	--Streaks
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))

	--Leveling
	ply:SetPData("playerLevel", ply:GetNWInt("playerLevel"))
	ply:SetPData("playerPrestige", ply:GetNWInt("playerPrestige"))
	ply:SetPData("playerXP", ply:GetNWInt("playerXP"))

	--Customizatoin
	ply:SetPData("chosenPlayermodel", ply:GetNWString("chosenPlayermodel"))
	ply:SetPData("chosenPlayercard", ply:GetNWString("chosenPlayercard"))

	--Accolades
	ply:SetPData("playerAccoladeOnStreak", ply:GetNWInt("playerAccoladeOnStreak"))
	ply:SetPData("playerAccoladeBuzzkill", ply:GetNWInt("playerAccoladeBuzzkill"))
	ply:SetPData("playerAccoladeLongshot", ply:GetNWInt("playerAccoladeLongshot"))
	ply:SetPData("playerAccoladePointblank", ply:GetNWInt("playerAccoladePointblank"))
	ply:SetPData("playerAccoladeSmackdown", ply:GetNWInt("playerAccoladeSmackdown"))
	ply:SetPData("playerAccoladeHeadshot", ply:GetNWInt("playerAccoladeHeadshot"))
	ply:SetPData("playerAccoladeClutch", ply:GetNWInt("playerAccoladeClutch"))

	--Weapon Statistics
	for p, t in pairs(weaponArray) do
		ply:SetPData("killsWith_" .. t[1], ply:GetNWInt("killsWith_" .. t[1]))
	end
end

function GM:ShutDown()
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	if game.GetMap() == "tm_firingrange" then return end
	if forceDisableProgression == true then return end

	for k, v in pairs(player.GetHumans()) do
		--Statistics
		v:SetPData("playerKills", v:GetNWInt("playerKills"))
		v:SetPData("playerDeaths", v:GetNWInt("playerDeaths"))
		v:SetPData("playerKDR", v:GetNWInt("playerKDR"))
		v:SetPData("playerScore", v:GetNWInt("playerScore"))
		v:SetPData("matchesPlayed", v:GetNWInt("matchesPlayed"))
		v:SetPData("matchesWon", v:GetNWInt("matchesWon"))

		--Streaks
		v:SetPData("highestKillStreak", v:GetNWInt("highestKillStreak"))

		--Leveling
		v:SetPData("playerLevel", v:GetNWInt("playerLevel"))
		v:SetPData("playerPrestige", v:GetNWInt("playerPrestige"))
		v:SetPData("playerXP", v:GetNWInt("playerXP"))

		--Customizatoin
		v:SetPData("chosenPlayermodel", v:GetNWString("chosenPlayermodel"))
		v:SetPData("chosenPlayercard", v:GetNWString("chosenPlayercard"))

		--Accolades
		v:SetPData("playerAccoladeOnStreak", v:GetNWInt("playerAccoladeOnStreak"))
		v:SetPData("playerAccoladeBuzzkill", v:GetNWInt("playerAccoladeBuzzkill"))
		v:SetPData("playerAccoladeLongshot", v:GetNWInt("playerAccoladeLongshot"))
		v:SetPData("playerAccoladePointblank", v:GetNWInt("playerAccoladePointblank"))
		v:SetPData("playerAccoladeSmackdown", v:GetNWInt("playerAccoladeSmackdown"))
		v:SetPData("playerAccoladeHeadshot", v:GetNWInt("playerAccoladeHeadshot"))
		v:SetPData("playerAccoladeClutch", v:GetNWInt("playerAccoladeClutch"))

		--Weapon Statistics
		for p, t in pairs(weaponArray) do
			v:SetPData("killsWith_" .. t[1], v:GetNWInt("killsWith_" .. t[1]))
		end
	end
end