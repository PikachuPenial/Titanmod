hook.Add("Initialize", "InitPlayerNetworking", function() sql.Query("CREATE TABLE IF NOT EXISTS PlayerData64 ( SteamID INTEGER, Key TEXT, Value TEXT, SteamName TEXT);") end )

local modelFiles = {}
local cardFiles = {}

for i = 1, #modelArray do
	table.insert(modelFiles, modelArray[i][1])
end
for i = 1, #cardArray do
	table.insert(cardFiles, cardArray[i][1])
end

-- NETWORKING
function InitializeNetworkInt(ply, query, key, value)
	if query == "new" then ply:SetNWInt(key, tonumber(value)) return end

	for k, v in ipairs(query) do
		if key == v.Key then
			ply:SetNWInt(key, tonumber(v.Value))
			return
		end
	end

	ply:SetNWInt(key, tonumber(value))
end

function InitializeNetworkString(ply, query, key, value)
	if query == "new" then ply:SetNWString(key, tostring(value)) return end

	for k, v in ipairs(query) do
		if key == v.Key then
			ply:SetNWString(key, tostring(v.Value))
			return
		end
	end

	ply:SetNWString(key, tostring(value))
end

function UninitializeNetworkInt(ply, query, key)
	local id64 = ply:SteamID64() or ply:GetNWInt("playerID64")
	local value = tonumber(ply:GetNWInt(key))
	if query == "new" then sql.Query("INSERT INTO PlayerData64 (SteamID, Key, Value) VALUES(" .. id64 .. ", " .. SQLStr(key) .. ", " .. SQLStr(value) .. ");") return end
	sql.Query("UPDATE PlayerData64 SET Value = " .. SQLStr(value) .. " WHERE SteamID = " .. id64 .. " AND Key = " .. SQLStr(key) .. ";")
end

function UninitializeNetworkString(ply, query, key)
	local id64 = ply:SteamID64() or ply:GetNWString("playerID64")
	local value = tostring(ply:GetNWString(key))
	if query == "new" then sql.Query("INSERT INTO PlayerData64 (SteamID, Key, Value) VALUES(" .. id64 .. ", " .. SQLStr(key) .. ", " .. SQLStr(value) .. ");") return end
	sql.Query("UPDATE PlayerData64 SET Value = " .. SQLStr(value) .. " WHERE SteamID = " .. id64 .. " AND Key = " .. SQLStr(key) .. ";")
end

function SetupPlayerData(ply)
	local query = sql.Query("SELECT Key, Value FROM PlayerData64 WHERE SteamID = " .. ply:SteamID64() .. ";")
	if query == nil then query = "new" end

	InitializeNetworkString(ply, query, "chosenPlayermodel", "models/player/Group03/male_02.mdl")
	InitializeNetworkString(ply, query, "chosenPlayercard", "cards/default/construct.png")
	InitializeNetworkString(ply, query, "chosenMelee", "tfa_km2000_knife")
	InitializeNetworkInt(ply, query, "playerKills", 0)
	InitializeNetworkInt(ply, query, "playerDeaths", 0)
	InitializeNetworkInt(ply, query, "playerScore", 0)
	InitializeNetworkInt(ply, query, "matchesPlayed", 0)
	InitializeNetworkInt(ply, query, "matchesWon", 0)
	InitializeNetworkInt(ply, query, "highestKillStreak", 0)
	InitializeNetworkInt(ply, query, "highestKillGame", 0)
	InitializeNetworkInt(ply, query, "farthestKill", 0)
	InitializeNetworkInt(ply, query, "playerLevel", 1)
	InitializeNetworkInt(ply, query, "playerPrestige", 0)
	InitializeNetworkInt(ply, query, "playerXP", 0)
	InitializeNetworkInt(ply, query, "playerAccoladeHeadshot", 0)
	InitializeNetworkInt(ply, query, "playerAccoladeSmackdown", 0)
	InitializeNetworkInt(ply, query, "playerAccoladeLongshot", 0)
	InitializeNetworkInt(ply, query, "playerAccoladePointblank", 0)
	InitializeNetworkInt(ply, query, "playerAccoladeOnStreak", 0)
	InitializeNetworkInt(ply, query, "playerAccoladeBuzzkill", 0)
	InitializeNetworkInt(ply, query, "playerAccoladeClutch", 0)
	for i = 1, #weaponArray do InitializeNetworkInt(ply, query, "killsWith_" .. weaponArray[i][1], 0) end

	for k, v in ipairs(levelArray) do
		if ply:GetNWInt("playerLevel") == k and v != "prestige" then ply:SetNWInt("playerXPToNextLevel", v) end
	end

	-- checks for potential save file corruption and will fix it accordingly
	if not table.HasValue(modelFiles, ply:GetNWString("chosenPlayermodel")) then ply:SetNWString("chosenPlayermodel", "models/player/Group03/male_02.mdl") end
	if not table.HasValue(cardFiles, ply:GetNWString("chosenPlayercard")) then ply:SetNWString("chosenPlayercard", "cards/default/construct.png") end
end

function SavePlayerData(ply)
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	local id64 = ply:SteamID64() or ply:GetNWInt("playerID64")
	local query = sql.Query("SELECT Key, Value FROM PlayerData64 WHERE SteamID = " .. id64 .. ";")
	if query == nil then query = "new" end

	sql.Query("START TRANSACTION;")
	sql.Query("LOCK TABLE [WRITE|READ] PlayerData64;")
	UninitializeNetworkInt(ply, query, "playerKills")
	UninitializeNetworkInt(ply, query, "playerDeaths")
	UninitializeNetworkInt(ply, query, "playerScore")
	UninitializeNetworkInt(ply, query, "matchesPlayed")
	UninitializeNetworkInt(ply, query, "matchesWon")
	UninitializeNetworkInt(ply, query, "highestKillStreak")
	UninitializeNetworkInt(ply, query, "highestKillGame")
	UninitializeNetworkInt(ply, query, "farthestKill")
	UninitializeNetworkInt(ply, query, "playerLevel")
	UninitializeNetworkInt(ply, query, "playerPrestige")
	UninitializeNetworkInt(ply, query, "playerXP")
	UninitializeNetworkString(ply, query, "chosenPlayermodel")
	UninitializeNetworkString(ply, query, "chosenPlayercard")
	UninitializeNetworkString(ply, query, "chosenMelee")
	UninitializeNetworkInt(ply, query, "playerAccoladeOnStreak")
	UninitializeNetworkInt(ply, query, "playerAccoladeBuzzkill")
	UninitializeNetworkInt(ply, query, "playerAccoladeLongshot")
	UninitializeNetworkInt(ply, query, "playerAccoladePointblank")
	UninitializeNetworkInt(ply, query, "playerAccoladeSmackdown")
	UninitializeNetworkInt(ply, query, "playerAccoladeHeadshot")
	UninitializeNetworkInt(ply, query, "playerAccoladeClutch")
	for i = 1, #weaponArray do UninitializeNetworkInt(ply, query, "killsWith_" .. weaponArray[i][1]) end
	sql.Query("UPDATE PlayerData64 SET SteamName = " .. SQLStr(ply:GetNWString("playerName")) .. " WHERE SteamID = " .. id64 .. ";")
	sql.Query("UNLOCK TABLE PlayerData64;")
	sql.Query("COMMIT;")
end

function GM:PlayerDisconnected(ply) SavePlayerData(ply) end
function GM:ShutDown() for k, v in pairs(player.GetHumans()) do SavePlayerData(v) end end