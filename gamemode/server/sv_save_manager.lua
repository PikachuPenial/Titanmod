hook.Add("Initialize", "InitPlayerNetworking", function() sql.Query("CREATE TABLE IF NOT EXISTS PlayerData64 ( SteamID INTEGER, Key TEXT, Value TEXT, SteamName TEXT);") end )

-- IMPORTANT FUNCTIONS
function SetPlayerData(steamID64, key, value)
    local query = sql.Query("SELECT Value FROM PlayerData64 WHERE SteamID = " .. steamID64 .. " AND Key = " .. SQLStr( key ) .. ";")

    -- if we need to make a new PData entry
    if query == nil then sql.Query("INSERT INTO PlayerData64 ( SteamID, Key, Value ) VALUES( " .. steamID64 .. ", " .. SQLStr( key ) .. ", " .. SQLStr( value ) .. ");") end

    -- if we need to update an existing entry
    if query != nil then sql.Query("UPDATE PlayerData64 SET Value = " .. SQLStr( value ) .. " WHERE SteamID = " .. steamID64 .. " AND Key = " .. SQLStr( key ) .. ";") end
end

function GetPlayerData(steamID64, key)
    local query = sql.QueryValue("SELECT Value FROM PlayerData64 WHERE SteamID = " .. steamID64 .. " AND Key = " .. SQLStr( key ) .. ";")
    return query
end

-- NETWORKING
function InitializeNetworkBool(ply, key, value)
    local v = tobool(value)
    local pdata = tobool(GetPlayerData(ply:SteamID64(), key))
    if pdata != nil then ply:SetNWBool(key, pdata) else ply:SetNWBool(key, v) end
end

function InitializeNetworkInt(ply, key, value)
    local v = tonumber(value)
    local pdata = tonumber(GetPlayerData(ply:SteamID64(), key))
    if pdata != nil then ply:SetNWInt(key, pdata) else ply:SetNWInt(key, v) end
end

function InitializeNetworkFloat(ply, key, value)
    local v = tonumber(value)
    local pdata = tonumber(GetPlayerData(ply:SteamID64(), key))
    if pdata != nil then ply:SetNWFloat(key, pdata) else ply:SetNWFloat(key, v) end
end

function InitializeNetworkString(ply, key, value)
    local pdata = GetPlayerData(ply:SteamID64(), key)
    if pdata != nil then ply:SetNWString(key, pdata) else ply:SetNWString(key, value) end
end

function UninitializeNetworkBool(ply, key)
    if ply:SteamID64() != nil then SetPlayerData(ply:SteamID64(), key, ply:GetNWBool(key)) else SetPlayerData(ply:GetNWInt("playerID64"), key, ply:GetNWBool(key)) end
end

function UninitializeNetworkInt(ply, key)
    if ply:SteamID64() != nil then SetPlayerData(ply:SteamID64(), key, ply:GetNWInt(key)) else SetPlayerData(ply:GetNWInt("playerID64"), key, ply:GetNWInt(key)) end
end

function UninitializeNetworkFloat(ply, key)
    if ply:SteamID64() != nil then SetPlayerData(ply:SteamID64(), key, ply:GetNWFloat(key)) else SetPlayerData(ply:GetNWInt("playerID64"), key, ply:GetNWFloat(key)) end
end

function UninitializeNetworkString(ply, key)
    if ply:SteamID64() != nil then SetPlayerData(ply:SteamID64(), key, ply:GetNWString(key)) else SetPlayerData(ply:GetNWInt("playerID64"), key, ply:GetNWString(key)) end
end

function GM:PlayerDisconnected(ply)
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	-- stats
	UninitializeNetworkInt(ply, "playerKills")
	UninitializeNetworkInt(ply, "playerDeaths")
	UninitializeNetworkInt(ply, "playerScore")
	UninitializeNetworkInt(ply, "matchesPlayed")
	UninitializeNetworkInt(ply, "matchesWon")
	UninitializeNetworkInt(ply, "highestKillStreak")
	UninitializeNetworkInt(ply, "highestKillGame")
	UninitializeNetworkInt(ply, "farthestKill")

	-- leveling
	UninitializeNetworkInt(ply, "playerLevel")
	UninitializeNetworkInt(ply, "playerPrestige")
	UninitializeNetworkInt(ply, "playerXP")

	-- customizatoin
	UninitializeNetworkString(ply, "chosenPlayermodel")
	UninitializeNetworkString(ply, "chosenPlayercard")
	UninitializeNetworkString(ply, "chosenMelee")

	-- accolades
	UninitializeNetworkInt(ply, "playerAccoladeOnStreak")
	UninitializeNetworkInt(ply, "playerAccoladeBuzzkill")
	UninitializeNetworkInt(ply, "playerAccoladeLongshot")
	UninitializeNetworkInt(ply, "playerAccoladePointblank")
	UninitializeNetworkInt(ply, "playerAccoladeSmackdown")
	UninitializeNetworkInt(ply, "playerAccoladeHeadshot")
	UninitializeNetworkInt(ply, "playerAccoladeClutch")

	-- weapon stats
	for i = 1, #weaponArray do
		UninitializeNetworkInt(ply, "killsWith_" .. weaponArray[i][1])
	end

	sql.Query("UPDATE PlayerData64 SET SteamName = " .. SQLStr(ply:GetNWString("playerName")) .. " WHERE SteamID = " .. ply:SteamID64() .. ";")
end

function GM:ShutDown()
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	for k, v in pairs(player.GetHumans()) do
		-- stats
		UninitializeNetworkInt(v, "playerKills")
		UninitializeNetworkInt(v, "playerDeaths")
		UninitializeNetworkInt(v, "playerScore")
		UninitializeNetworkInt(v, "matchesPlayed")
		UninitializeNetworkInt(v, "matchesWon")
		UninitializeNetworkInt(v, "highestKillStreak")
		UninitializeNetworkInt(v, "highestKillGame")
		UninitializeNetworkInt(v, "farthestKill")

		-- leveling
		UninitializeNetworkInt(v, "playerLevel")
		UninitializeNetworkInt(v, "playerPrestige")
		UninitializeNetworkInt(v, "playerXP")

		-- customizatoin
		UninitializeNetworkString(v, "chosenPlayermodel")
		UninitializeNetworkString(v, "chosenPlayercard")
		UninitializeNetworkString(ply, "chosenMelee")

		-- accolades
		UninitializeNetworkInt(v, "playerAccoladeOnStreak")
		UninitializeNetworkInt(v, "playerAccoladeBuzzkill")
		UninitializeNetworkInt(v, "playerAccoladeLongshot")
		UninitializeNetworkInt(v, "playerAccoladePointblank")
		UninitializeNetworkInt(v, "playerAccoladeSmackdown")
		UninitializeNetworkInt(v, "playerAccoladeHeadshot")
		UninitializeNetworkInt(v, "playerAccoladeClutch")

		-- weapon stats
		for i = 1, #weaponArray do
			UninitializeNetworkInt(v, "killsWith_" .. weaponArray[i][1])
		end

		sql.Query("UPDATE PlayerData64 SET SteamName = " .. SQLStr(v:GetNWString("playerName")) .. " WHERE SteamID = " .. v:SteamID64() .. ";")
	end
end