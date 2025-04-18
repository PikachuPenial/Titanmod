local activeGamemode
SetGlobal2Bool("tm_matchended", false)

function GM:InitPostEntity()
	activeGamemode = GetGlobal2String("ActiveGamemode", "FFA")
	SetGlobal2Bool("tm_intermission", true)
	SetGlobal2Int("tm_matchtime", GetConVar("tm_matchlengthtimer"):GetInt() + GetConVar("tm_intermissiontimer"):GetInt())
	print("Titanmod Initialized on " .. game.GetMap() .. " on the " .. activeGamemode .. " gamemode")

	hook.Add("Think", "IntermissionFreeze", function()
		local time = GetGlobal2Int("tm_matchtime", 0)
		if time - CurTime() < (time - GetConVar("tm_intermissiontimer"):GetInt()) then
			SetGlobal2Bool("tm_intermission", false)
			for k, ply in pairs(player.GetAll()) do ply:Freeze(false) end
			if activeGamemode == "Fiesta" then CreateFiestaTimer() end
			hook.Remove("Think", "IntermissionFreeze")
			hook.Remove("CanPlayerSuicide", "IntermissionBlocksSuicide")
		end
	end )
end

util.AddNetworkString("PlayerInitialSpawn")
util.AddNetworkString("PlayerSpawn")
util.AddNetworkString("OpenMainMenu")
util.AddNetworkString("CloseMainMenu")
util.AddNetworkString("SendHitmarker")
util.AddNetworkString("NotifyKill")
util.AddNetworkString("NotifyDeath")
util.AddNetworkString("SendNotification")
util.AddNetworkString("KillFeedUpdate")
util.AddNetworkString("EndOfGame")
util.AddNetworkString("MapVoteCompleted")
util.AddNetworkString("MapVoteSkipped")
util.AddNetworkString("ReceiveMapVote")
util.AddNetworkString("ReceiveModeVote")
util.AddNetworkString("ReceivePostGameMute")
util.AddNetworkString("BeginSpectate")
util.AddNetworkString("PlayerGearChange")
util.AddNetworkString("PlayerModelChange")
util.AddNetworkString("PlayerCardChange")
util.AddNetworkString("PlayerPrestige")
util.AddNetworkString("GrabLeaderboardData")
util.AddNetworkString("SendLeaderboardData")
util.AddNetworkString("SendChatMessage")

RunConsoleCommand("mp_friendlyfire", "1")

function OpenMainMenu(ply)
	net.Start("OpenMainMenu")
	if timer.Exists(ply:SteamID() .. "respawnTime") then net.WriteFloat(timer.TimeLeft(ply:SteamID() .. "respawnTime")) else net.WriteFloat(0) end
	net.Send(ply)
	ply:SetNWBool("mainmenu", true)
end

net.Receive("PlayerInitialSpawn", function(len, ply)
	ply:KillSilent()
	OpenMainMenu(ply)
	sql.Query("UPDATE PlayerData64 SET SteamName = " .. SQLStr(ply:Name()) .. " WHERE SteamID = " .. ply:SteamID64() .. ";")
end)

function GM:PlayerSpawn(ply)
	ply:UnSpectate()
	ply:SetGravity(.72 * playerGravityMulti)
	ply:SetHealth(playerHealth)
	ply:SetMaxHealth(playerHealth)
	ply:SetRunSpeed(275 * playerSpeedMulti)
	ply:SetWalkSpeed(165 * playerSpeedMulti)
	ply:SetJumpPower(150 * playerJumpMulti)
	ply:SetLadderClimbSpeed(155 * playerSpeedMulti)
	ply:SetSlowWalkSpeed(165 * playerSpeedMulti)
	ply:SetCrouchedWalkSpeed(0.6 * playerCrouchWalkSpeedMulti)
	ply:SetDuckSpeed(0.4 * playerDuckStateMulti)
	ply:SetUnDuckSpeed(0.4 * playerDuckStateMulti)
	ply:SetCanWalk(false)
	ply:SetModel(ply:GetNWString("chosenPlayermodel"))
	ply:SetupHands()
	ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
	ply:DrawShadow(false)
	if GetGlobal2Bool("tm_intermission") then ply:Freeze(true) end

	if ply:GetInfoNum("tm_customfov", 0) == 1 then ply:SetFOV(ply:GetInfoNum("tm_customfov_value", 100)) end

	net.Start("PlayerSpawn")
	net.Send(ply)

	HandlePlayerSpawn(ply)

	ply:SetNWBool("mainmenu", false)
	ply:SetNWInt("killStreak", 0)
	ply:SetNWFloat("linat", CurTime() + 3)

	ply:SetViewOffsetDucked(Vector(0, 0, 42))
end

function GM:PlayerInitialSpawn(ply)
	ply:SetNWInt("playerID64", ply:SteamID64())
	ply:SetNWString("playerName", ply:Name())

	SetupPlayerData(ply)

	ply:SetCanZoom(false)
	HandlePlayerInitialSpawn(ply)
end

net.Receive("BeginSpectate", function(len, ply)
	if timer.Exists(ply:SteamID() .. "respawnTime") then return end
	if ply:Alive() then return end
	if GetGlobal2Bool("tm_intermission") then return end
	ply:SetNWBool("mainmenu", false)
	ply:UnSpectate()
	ply:Spectate(OBS_MODE_ROAMING)
	net.Start("SendNotification")
	net.WriteString("Press your menu bind to return to the main menu")
	net.WriteString("warning")
	net.Send(ply)
end )

net.Receive("GrabLeaderboardData", function(len, ply)
	local key = net.ReadString()
	local manual = net.ReadBool()

	if manual then
		if timer.Exists(ply:SteamID64() .. "_GrabBoardDataCooldown") then return end
		timer.Create(ply:SteamID64() .. "_GrabBoardDataCooldown", 3, 1, function() end)
	end

	local tbl
	-- if key == "level" then
		-- tbl = sql.Query("SELECT P.steamid AS SteamID, p.steamname AS SteamName, (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerPrestige') AS prestige, (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerLevel') AS level, ((SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerPrestige') + 1) * 60 + (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerLevel') - 60 AS Value FROM PlayerData64 P GROUP BY P.steamid ORDER BY Value DESC LIMIT 100;")
	-- elseif key == "kd" then
		-- tbl = sql.Query("SELECT P.steamid AS SteamID, p.steamname AS SteamName, CAST((SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerKills') as float) / (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'playerDeaths') AS Value FROM PlayerData64 P GROUP BY p.steamid ORDER BY Value DESC LIMIT 100;")
	-- elseif key == "wl" then
		-- tbl = sql.Query("SELECT P.steamid AS SteamID, p.steamname AS SteamName, CAST((SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'matchesWon') as float) / (SELECT value FROM PlayerData64 WHERE SteamID = P.steamid AND key = 'matchesPlayed') * 100 AS Value FROM PlayerData64 P GROUP BY p.steamid ORDER BY Value DESC LIMIT 100;")
	-- else
		-- tbl = sql.Query("SELECT SteamID, SteamName, Value FROM PlayerData64 WHERE Key = " .. SQLStr(key) .. " ORDER BY Value + 0 DESC LIMIT 100;")
	-- end

	tbl = sql.Query("SELECT SteamID, SteamName, Value FROM PlayerData64 WHERE Key = " .. SQLStr(key) .. " ORDER BY Value + 0 DESC LIMIT 100;")

	net.Start("SendLeaderboardData", true)
	net.WriteTable(tbl)
	net.Send(ply)
end )

-- custom gamemode damage profile
function GM:ScalePlayerDamage(target, hitgroup, dmginfo)
	if not dmginfo:IsDamageType(DMG_SLASH) then
		if (hitgroup == HITGROUP_HEAD) then dmginfo:ScaleDamage(1.25) elseif (hitgroup == HITGROUP_CHEST) or (hitgroup == HITGROUP_STOMACH) then dmginfo:ScaleDamage(1) elseif (hitgroup == HITGROUP_LEFTARM) or (hitgroup == HITGROUP_RIGHTARM) or (hitgroup == HITGROUP_LEFTLEG) or (hitgroup == HITGROUP_RIGHTLEG) then dmginfo:ScaleDamage(0.75) end
	else
		dmginfo:ScaleDamage(1)
	end

	if not dmginfo:GetAttacker():IsPlayer() then return end
	net.Start("SendHitmarker", true)
	net.WriteUInt(hitgroup, 4)
	net.Send(dmginfo:GetAttacker())
end

-- self-explosive knockback
local function ExplosiveKnockback(ent, dmginfo)
	if not dmginfo:IsExplosionDamage() then return end
	if not ent:IsPlayer() then return end

	local attacker = dmginfo:GetAttacker()
	if attacker != ent then return end

	local dmgForce = dmginfo:GetDamageForce()
	local newForce = dmgForce * 1.15
	dmginfo:SetDamageForce(newForce)
	ent:SetVelocity(newForce / 70)
	dmginfo:ScaleDamage(0.3)
end
hook.Add("EntityTakeDamage", "ExplosiveKnockback", ExplosiveKnockback)

-- change explosive audio distortion
hook.Add("OnDamagedByExplosion", "TinnitusSoundOnExplosion", function(ply, dmginfo)
    if IsValid(ply) and ply:IsPlayer() then
        ply:SetDSP(32, false)
        return false
    end
end)

-- disable fall damage
hook.Add("GetFallDamage", "DisableFallDmg", function(ply, speed) return false end)

-- hit flinch
hook.Add("EntityTakeDamage", "HitFlinch", function(target, dmginfo)
	if IsValid(target) and target:IsPlayer() then util.ScreenShake(target:GetPos(), 0.33, 3, 0.1, 500) end
end)

function GM:PlayerDeath(victim, inflictor, attacker)
	if GetGlobal2Bool("tm_matchended") == true then return end
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

		if inflictor:GetClass() == "npc_grenade_frag" then
			attacker:SetNWInt("killsWith_grenade", attacker:GetNWInt("killsWith_grenade") + 1)
		elseif inflictor:GetClass() == "tm_thrown_blade" then
			attacker:SetNWInt("killsWith_" .. attacker:GetNWString("chosenMelee"), attacker:GetNWInt("killsWith_" .. attacker:GetNWString("chosenMelee")) + 1)
		elseif (attacker:GetActiveWeapon():IsValid()) then
			weaponClassName = attacker:GetActiveWeapon():GetClass()
			attacker:SetNWInt("killsWith_" .. weaponClassName, attacker:GetNWInt("killsWith_" .. weaponClassName) + 1)
		end

		if grappleKillReset == true then attacker:SetNWFloat("linat", attacker:GetNWFloat("linat", 20) - 10) end
		attacker.HealthRegenNext = 0
	end

	-- decides if the player should respawn, or if they should not, for instances where the player is in the Main Menu
	timer.Create(victim:SteamID() .. "respawnTime", 4, 1, function()
		if victim:GetNWBool("mainmenu") == false and victim != nil then
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

		net.Start("KillFeedUpdate")
		net.WriteString(victim:GetName() .. " commited suicide")
		net.WriteFloat(0)
		net.WriteString(victim:GetName())
		net.WriteInt(1, 10)
		net.Broadcast()

		HandlePlayerDeath(victim, "Suicide")
		return
	end

	local weaponInfo
	local weaponName
	local rawDistance = victim:GetPos():Distance(attacker:GetPos())
	local distance = math.Round(rawDistance * 0.01905)
	local victimHitgroup = victim:LastHitGroup()

	if inflictor:GetClass() == "npc_grenade_frag" then
		weaponName = "Grenade"
	elseif inflictor:GetClass() == "tm_thrown_blade" then
		weaponName = "Thrown Knife"
	elseif (attacker:GetActiveWeapon():IsValid()) then
		weaponInfo = weapons.Get(attacker:GetActiveWeapon():GetClass())
		weaponName = weaponInfo["PrintName"]
	else
		weaponName = ""
	end

	if (victim != attacker) and (inflictor != nil) then
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

		net.Start("KillFeedUpdate")
		net.WriteString(attacker:GetName() .. " [" .. weaponName .. "] " .. victim:GetName())
		net.WriteInt(victimHitgroup, 5)
		net.WriteString(attacker:GetName())
		net.WriteInt(attacker:GetNWInt("killStreak"), 10)
		net.Broadcast()

		if victim:GetInfoNum("tm_deathcam", 1) == 1 and deathCamera == true then
			timer.Simple(0.75, function()
				victim:SpectateEntity(attacker)
				victim:SetupHands(attacker)

				if not IsValid(victim) or not IsValid(attacker) then return end
				victim:SetObserverMode(OBS_MODE_FREEZECAM)

				timer.Simple(1.25, function()
					if not IsValid(victim) or not IsValid(attacker) then return end
					victim:SetObserverMode(OBS_MODE_IN_EYE)
				end)
			end)
		end
	end

	HandlePlayerDeath(victim, weaponName)
	HandlePlayerKill(attacker, victim, weaponName)

	if distance >= attacker:GetNWInt("farthestKill") then attacker:SetNWInt("farthestKill", distance) end

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

	if weaponName == "Tanto" or weaponName == "Mace" or weaponName == "KM-2000" or weaponName == "Bowie Knife" or weaponName == "Butterfly Knife" or weaponName == "Carver" or weaponName == "Dagger" or weaponName == "Fire Axe" or weaponName == "Fists" or weaponName == "Karambit" or weaponName == "Kukri" or weaponName == "M9 Bayonet" or weaponName == "Nunchucks" or weaponName == "Red Rebel" or weaponName == "Tri-Dagger" or weaponName == "Thrown Knife" then
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

		for k, v in ipairs(levelArray) do
			if (curLvl + 1) == k then ply:SetNWInt("playerXPToNextLevel", v) end
		end

		net.Start("SendNotification")
		net.WriteString("You are now level " .. curLvl + 1 .. "!")
		net.WriteString("level")
		net.Send(ply)
	end
end

net.Receive("CloseMainMenu", function(len, ply)
	ply:SetNWBool("mainmenu", false)
	if not timer.Exists(ply:SteamID() .. "respawnTime") then
		ply:Spawn()
	end
end )

function GM:PlayerDeathThink(ply)
	if timer.Exists(ply:SteamID() .. "respawnTime") then
		return false
	end
end

net.Receive("PlayerGearChange", function(len, ply)
	local selecterGear = net.ReadString()
	for i = 1, #gearArray do
		if selecterGear == gearArray[i][1] then
			local gearID = gearArray[i][1]
			local gearUnlock = gearArray[i][4]
			local gearKills = gearArray[i][5]
			local gearLevel = gearArray[i][6]
			local playerTotalLevel = (ply:GetNWInt("playerPrestige") * 60) + ply:GetNWInt("playerLevel")

			if gearUnlock == "default" then
				ply:SetNWString("chosenMelee", gearID)

				if activeGamemode != "Gun Game" and activeGamemode != "Fiesta" then
					ply:SetNWString("loadoutMelee", gearID)
				end
			elseif gearUnlock == "melee" and ply:GetNWInt("playerAccoladeSmackdown") >= gearKills then
				ply:SetNWString("chosenMelee", gearID)

				if activeGamemode != "Gun Game" and activeGamemode != "Fiesta" then
					ply:SetNWString("loadoutMelee", gearID)
				end
			elseif gearUnlock == "melee" and playerTotalLevel >= gearLevel then
				ply:SetNWString("chosenMelee", gearID)

				if activeGamemode != "Gun Game" and activeGamemode != "Fiesta" then
					ply:SetNWString("loadoutMelee", gearID)
				end
			end
		end
	end
end )

net.Receive("PlayerModelChange", function(len, ply)
	local selectedModel = net.ReadString()
	for i = 1, #modelArray do
		if selectedModel == modelArray[i][1] then
			local modelID = modelArray[i][1]
			local modelUnlock = modelArray[i][3]
			local modelValue = modelArray[i][4]

			if modelUnlock == "default" then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "kills" and ply:GetNWInt("playerKills") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "matches" and ply:GetNWInt("matchesPlayed") >= modelValue then
				ply:SetNWString("chosenPlayermodel", modelID)
			elseif modelUnlock == "wins" and ply:GetNWInt("matchesWon") >= modelValue then
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

net.Receive("PlayerCardChange", function(len, ply)
	local selectedCard = net.ReadString()
	local masteryUnlockReq = 50
	for i = 1, #cardArray do
		if selectedCard == cardArray[i][1] then
			local cardID = cardArray[i][1]
			local cardUnlock = cardArray[i][4]
			local cardValue = cardArray[i][5]
			local playerTotalLevel = (ply:GetNWInt("playerPrestige") * 60) + ply:GetNWInt("playerLevel")

			if cardUnlock == "default" or cardUnlock == "color" or cardUnlock == "pride" then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "kills" and ply:GetNWInt("playerKills") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "matches" and ply:GetNWInt("matchesPlayed") >= cardValue then
				ply:SetNWString("chosenPlayercard", cardID)
			elseif cardUnlock == "wins" and ply:GetNWInt("matchesWon") >= cardValue then
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

net.Receive("PlayerPrestige", function(len, ply)
	if ply:GetNWInt("playerLevel") >= 60 then
		local pres = ply:GetNWInt("playerPrestige", 0)
		local nextPres = pres + 1
		ply:SetNWInt("playerLevel", 1)
		ply:SetNWInt("playerPrestige", nextPres)
		ply:SetNWInt("playerXP", 0)
		ply:SetNWInt("playerXPToNextLevel", 750)

		-- force save to the file early
		if GetConVar("tm_developermode"):GetInt() == 0 then SavePlayerData(ply) end
	end
end )

if healthRegeneration == true then
	local function Regeneration()
		for _, ply in pairs(player.GetAll()) do
			if ply:Alive() then
				if (ply:Health() < (ply.LastHealth or 0)) then ply.HealthRegenNext = CurTime() + healthRegenDamageDelay end
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

	-- begins the process of ending a match
	function EndMatch()
		SetGlobal2Int("VotesOnModeOne", 0)
		SetGlobal2Int("VotesOnModeTwo", 0)
		SetGlobal2Int("VotesOnMapOne", 0)
		SetGlobal2Int("VotesOnMapTwo", 0)
		SetGlobal2Int("VotesOnMapThree", 0)
		SetGlobal2Bool("tm_matchended", true)
		timer.Remove("matchStatusCheck")

		hook.Remove("PlayerCanHearPlayersVoice", "ProxVOIP")
		hook.Add("PlayerCanHearPlayersVoice", "ProxVOIPPostMatch", function(listener,talker)
			if listener:GetNWBool("PostGameMute") == true then
				return false, false
			else
				return true, false
			end
		end )

		net.Receive("ReceivePostGameMute", function(len, ply)
			ply:SetNWBool("PostGameMute", net.ReadBool())
		end )

		hook.Add("PlayerSay", "SendToEORChat", function(ply, text)
			net.Start("SendChatMessage")
			net.WriteString(ply:GetName() .. " | " .. text)
			net.Broadcast()
		end )

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
		local mapPoolSecondary = {}
		local modePool = {}
		local modePoolSecondary = {}

		-- primary map pool will only contain maps suitable for the current player count
		-- secondary map pool will contain every map in the game

		-- primary mode pool will only contain modes that are simplistic in nature
		-- secondary mode pool will only contain modes with complicated elements (objectives, weird modifiers, etc)

		-- makes sure that the map currently being played is not added to the map pool, and check if maps are allowed to be added to the map pool
		for m, v in RandomPairs(availableMaps) do
			if game.GetMap() != v then table.insert(mapPool, v) end
		end

		for m, v in RandomPairs(availableMaps) do
			if game.GetMap() != v then table.insert(mapPoolSecondary, v) end
		end

		-- remove maps from primary map pool if they are not fit for current player count
		for p, v in ipairs(mapArray) do
			if player.GetCount() > 5 and v[5] != 0 then table.RemoveByValue(mapPool, v[1]) end
			if player.GetCount() <= 5 and v[5] == 0 then table.RemoveByValue(mapPool, v[1]) end
		end

		for g, v in RandomPairs(gamemodeArray) do
			if activeGamemode != v and v[4] == true then table.insert(modePool, v[1]) end
		end

		for g, v in RandomPairs(gamemodeArray) do
			if activeGamemode != v and v[4] == false then table.insert(modePoolSecondary, v[1]) end
		end

		firstMap = mapPool[1]
		table.RemoveByValue(mapPoolSecondary, firstMap) -- make sure that the same map isnt on both votes
		secondMap = mapPoolSecondary[1]
		table.RemoveByValue(mapPoolSecondary, secondMap) -- you'd never guess
		thirdMap = mapPoolSecondary[1]

		firstMode = modePool[1]
		secondMode = modePoolSecondary[2]

		hook.Add("PlayerDisconnected", "ServerEmptyDuringVoteCheck", function()
			timer.Create("DelayBeforeEmptyCheck", 5, 1, function() -- delaying by a few seconds, just in case
				if player.GetCount() == 0 then RunConsoleCommand("changelevel", firstMap) end
			end)
		end )

		-- failsafe for empty servers, will skip to a new map if there are no players connected to the server
		if player.GetCount() == 0 then RunConsoleCommand("changelevel", firstMap) return end

		for k, v in pairs(player.GetAll()) do
			v:SetLaggedMovementValue(0.2)
			v:SetNWBool("PostGameMute", false)
		end

		-- failsafe in case map votes are just not generated
		if firstMap == nil then firstMap = "tm_arctic" end
		if secondMap == nil then secondMap = "tm_mall" end
		if thirdMap == nil then thirdMap = "tm_station" end

		net.Start("EndOfGame")
		net.WriteString(firstMap)
		net.WriteString(secondMap)
		net.WriteString(thirdMap)
		net.WriteInt(firstMode, 5)
		net.WriteInt(secondMode, 5)
		net.Broadcast()

		timer.Create("killAfterDelay", 8, 1, function()
			for k, v in pairs(player.GetAll()) do
				v:KillSilent()
			end
		end)

		local connectedPlayers = player.GetHumans()
		if activeGamemode == "Gun Game" then table.sort(connectedPlayers, function(a, b) return a:GetNWInt("ladderPosition") > b:GetNWInt("ladderPosition") end) else table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end) end

		for k, v in pairs(connectedPlayers) do
			if player.GetCount() > 1 then
				v:SetNWInt("matchesPlayed", v:GetNWInt("matchesPlayed") + 1)
				if v:Frags() >= v:GetNWInt("highestKillGame") then v:SetNWInt("highestKillGame", v:Frags()) end
				if k == 1 then
					v:SetNWInt("matchesWon", v:GetNWInt("matchesWon") + 1)
					v:SetNWInt("playerXP", v:GetNWInt("playerXP") + (1500 * xpMultiplier))
					CheckForPlayerLevel(v)
				else
					v:SetNWInt("playerXP", v:GetNWInt("playerXP") + (750 * xpMultiplier))
					CheckForPlayerLevel(v)
				end
			end
		end

		if matchVoting == true then
			timer.Create("mapVoteStatus", 22, 1, function()
				local newMapTable = {}
				local newModeTable = {}
				local maxMapVotes = 0
				local maxModeVotes = 0

				for k, v in pairs(mapVotes) do
					if v > maxMapVotes then
						maxMapVotes = v
					end
				end

				for k, v in ipairs(availableMaps) do
					if mapVotes[k] == maxMapVotes then
						table.insert(newMapTable, v)
					end
				end

				for k, v in pairs(modeVotes) do
					if v > maxModeVotes then
						maxModeVotes = v
					end
				end

				for k, v in ipairs(gamemodeArray) do
					if modeVotes[k] == maxModeVotes then
						table.insert(newModeTable, v[1])
					end
				end

				mapVoteOpen = false
				newMap = newMapTable[math.random(#newMapTable)]
				newMode = newModeTable[math.random(#newModeTable)]

				net.Start("MapVoteCompleted")
				net.WriteString(newMap)
				net.WriteInt(newMode, 5)
				net.Broadcast()
			end)
		else
			mapVoteOpen = false
			newMap = mapPoolSecondary[1]
			if math.random(0, 1) == 0 then
				newMode = modePool[1]
			else
				newMode = modePoolSecondary[1]
			end

			net.Start("MapVoteSkipped")
			net.WriteString(newMap)
			net.WriteInt(newMode, 5)
			net.Broadcast()
		end

		timer.Create("newMapCooldown", 33, 1, function()
			RunConsoleCommand("changelevel", newMap)
			RunConsoleCommand("tm_gamemode", newMode)
		end)
	end

	-- calls for a match end once the match timer has concluded
	local function MatchStatusCheck()
		local currentTime = math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime())
		if CurTime() > GetGlobal2Int("tm_matchtime", 0) then EndMatch() end

		if currentTime == 300 or currentTime == 60 or currentTime == 10 then
			net.Start("SendNotification")
			net.WriteString(string.FormattedTime(currentTime, "%i:%02i") .. " remaining in the match!")
			net.WriteString("time")
			net.Broadcast()
		end
	end

	-- checking the match time periodically to determine when a match should end
	timer.Create("matchStatusCheck", 1, 0, MatchStatusCheck)

	net.Receive("ReceiveMapVote", function(len, ply)
		if mapVoteOpen == false then return end

		local votedMap = net.ReadString()
		local unvotedMap = net.ReadString()
		local mapIndex = net.ReadUInt(3)
		local unvotedMapIndex = net.ReadUInt(3)
		local unvotedMapInt = ""
		local revote = false

		if playersVoted != nil then
			for k, v in pairs(playersVoted) do
				if v == ply then revote = true end
			end
		end

		if revote == false then
			for k, v in ipairs(availableMaps) do
				if v == votedMap then
					mapVotes[k] = mapVotes[k] + 1
					table.insert(playersVoted, ply)
					if mapIndex	== 1 then SetGlobal2Int("VotesOnMapOne", GetGlobal2Int("VotesOnMapOne", 0) + 1, 0) elseif mapIndex == 2 then SetGlobal2Int("VotesOnMapTwo", GetGlobal2Int("VotesOnMapTwo", 0) + 1, 0) elseif mapIndex == 3 then SetGlobal2Int("VotesOnMapThree", GetGlobal2Int("VotesOnMapThree", 0) + 1, 0) end
				end
			end
		else
			if unvotedMapIndex == 1 then unvotedMapInt = "VotesOnMapOne" elseif unvotedMapIndex == 2 then unvotedMapInt = "VotesOnMapTwo" elseif unvotedMapIndex == 3 then unvotedMapInt = "VotesOnMapThree" end
			for k, v in ipairs(availableMaps) do
				if v == votedMap then
					mapVotes[k] = mapVotes[k] + 1
					if mapIndex	== 1 then
						SetGlobal2Int("VotesOnMapOne", GetGlobal2Int("VotesOnMapOne", 0) + 1, 0)
						SetGlobal2Int(unvotedMapInt, GetGlobal2Int(unvotedMapInt, 0) - 1, 0)
					elseif mapIndex == 2 then
						SetGlobal2Int("VotesOnMapTwo", GetGlobal2Int("VotesOnMapTwo", 0) + 1, 0)
						SetGlobal2Int(unvotedMapInt, GetGlobal2Int(unvotedMapInt, 0) - 1, 0)
					elseif mapIndex == 3 then
						SetGlobal2Int("VotesOnMapThree", GetGlobal2Int("VotesOnMapThree", 0) + 1, 0)
						SetGlobal2Int(unvotedMapInt, GetGlobal2Int(unvotedMapInt, 0) - 1, 0)
					end
				end

				if v == unvotedMap then mapVotes[k] = mapVotes[k] - 1 end
			end
		end
	end )

	net.Receive("ReceiveModeVote", function(len, ply)
		if mapVoteOpen == false then return end

		local votedMode = net.ReadInt(5)
		local unvotedMode = net.ReadInt(5)
		local modeIndex = net.ReadUInt(2)
		local revote = false

		if playersVotedMode != nil then
			for k, v in pairs(playersVotedMode) do
				if v == ply then revote = true end
			end
		end

		if revote == false then
			for k, v in ipairs(gamemodeArray) do
				if v[1] == votedMode then
					modeVotes[k] = modeVotes[k] + 1
					table.insert(playersVotedMode, ply)
					if modeIndex == 1 then SetGlobal2Int("VotesOnModeOne", GetGlobal2Int("VotesOnModeOne", 0) + 1, 0) elseif modeIndex == 2 then SetGlobal2Int("VotesOnModeTwo", GetGlobal2Int("VotesOnModeTwo", 0) + 1, 0) end
				end
			end
		else
			for k, v in ipairs(gamemodeArray) do
				if v[1] == votedMode then
					modeVotes[k] = modeVotes[k] + 1
					if modeIndex == 1 then
						SetGlobal2Int("VotesOnModeOne", GetGlobal2Int("VotesOnModeOne", 0) + 1, 0)
						SetGlobal2Int("VotesOnModeTwo", GetGlobal2Int("VotesOnModeTwo", 0) - 1, 0) 
					elseif modeIndex == 2 then
						SetGlobal2Int("VotesOnModeTwo", GetGlobal2Int("VotesOnModeTwo", 0) + 1, 0) 
						SetGlobal2Int("VotesOnModeOne", GetGlobal2Int("VotesOnModeOne", 0) - 1, 0)
					end
				end

				if v[1] == unvotedMode then modeVotes[k] = modeVotes[k] - 1 end
			end
		end
	end )

	function ForceEndMatchCommand(ply, cmd, args)
		if ply:IsAdmin() then EndMatch() end
	end
	concommand.Add("tm_forceendmatch", ForceEndMatchCommand)
end

function AddMatchTimeCommand(ply, cmd, args)
	if ply:IsAdmin() then SetGlobal2Int("tm_matchtime", GetGlobal2Int("tm_matchtime", GetConVar("tm_matchlengthtimer"):GetInt()) + args[1]) end
end
concommand.Add("tm_addmatchtime", AddMatchTimeCommand)

function ReduceMatchTimeCommand(ply, cmd, args)
	if ply:IsAdmin() then SetGlobal2Int("tm_matchtime", GetGlobal2Int("tm_matchtime", GetConVar("tm_matchlengthtimer"):GetInt()) - args[1]) end
end
concommand.Add("tm_reducematchtime", ReduceMatchTimeCommand)

-- modifies base game voice chat to be proximity based
hook.Add("PlayerCanHearPlayersVoice", "ProxVOIP", function(listener,talker)
	if (tonumber(listener:GetPos():Distance(talker:GetPos())) > proxChatRange) then
		return false, false
	else
		return true, true
	end
end )

-- disable traditional suiciding when in the intermission phase
hook.Add("CanPlayerSuicide", "IntermissionBlocksSuicide", function(ply)
	if GetGlobal2Bool("tm_intermission") then return false end
end )