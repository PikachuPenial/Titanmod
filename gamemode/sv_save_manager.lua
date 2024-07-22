
hook.Add("Initialize", "InitPlayerNetworking", function()
    sql.Query("CREATE TABLE IF NOT EXISTS PlayerData64 ( SteamID INTEGER, Key TEXT, Value TEXT, SteamName TEXT);")
end )

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