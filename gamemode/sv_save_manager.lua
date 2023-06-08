hook.Add("Initialize", "InitPlayerNetworking", function()
    sql.Query("CREATE TABLE IF NOT EXISTS PlayerData64 ( SteamID INTEGER, Key TEXT, Value TEXT);")
end )

--IMPORTANT FUNCTIONS
function SetPlayerData(steamID64, key, value)
    local query = sql.Query("SELECT Value FROM PlayerData64 WHERE SteamID = " .. steamID64 .. " AND Key = " .. SQLStr( key ) .. ";")

    --If we need to make a new PData entry.
    if query == nil then sql.Query("INSERT INTO PlayerData64 ( SteamID, Key, Value ) VALUES( " .. steamID64 .. ", " .. SQLStr( key ) .. ", " .. SQLStr( value ) .. ");") end

    --If we need to update an existing entry.
    if query != nil then sql.Query("UPDATE PlayerData64 SET Value = " .. SQLStr( value ) .. " WHERE SteamID = " .. steamID64 .. " AND Key = " .. SQLStr( key ) .. ";") end
end

function GetPlayerData(steamID64, key)
    local query = sql.QueryValue("SELECT Value FROM PlayerData64 WHERE SteamID = " .. steamID64 .. " AND Key = " .. SQLStr( key ) .. ";")
    return query
end

--NETWORKING
function InitializeNetworkBool(ply, key, value)
    local v = tobool(value)
    local pdata = tobool(GetPlayerData(ply:SteamID64(), key))
    if pdata == nil then ply:SetNWBool(key, v) else ply:SetNWBool(key, pdata) end
end

function InitializeNetworkInt(ply, key, value)
    local v = tonumber(value)
    local pdata = tonumber(GetPlayerData(ply:SteamID64(), key))
    if pdata == nil then ply:SetNWInt(key, v) else ply:SetNWInt(key, pdata) end
end

function InitializeNetworkFloat(ply, key, value)
    local v = tonumber(value)
    local pdata = tonumber(GetPlayerData(ply:SteamID64(), key))
    if pdata == nil then ply:SetNWFloat(key, v) else ply:SetNWFloat(key, pdata) end
end

function InitializeNetworkString(ply, key, value)
    local pdata = GetPlayerData(ply:SteamID64(), key)
    if pdata == nil then ply:SetNWString(key, value) else ply:SetNWString(key, pdata) end
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