local activeGamemode = GetGlobal2String("ActiveGamemode", "FFA")

local randPrimary = {}
local randSecondary = {}
local randMelee = {}

local ggLadder = {}
local ggRandMelee = {}

local fiestaPrimary
local fiestaSecondary
local fiestaMelee

util.AddNetworkString("NotifyGGThreat")
util.AddNetworkString("NotifyCranked")

function ShuffleFiestaLoadout()
    SetGlobal2Int("FiestaTime", fiestaShuffleTime + GetGlobal2Int("FiestaTime"))
    fiestaPrimary = randPrimary[math.random(#randPrimary)]
    fiestaSecondary = randSecondary[math.random(#randSecondary)]
    fiestaMelee = randMelee[math.random(#randMelee)]

    for k, v in pairs(player.GetHumans()) do
        v:SetNWString("loadoutPrimary", fiestaPrimary)
        v:SetNWString("loadoutSecondary", fiestaSecondary)
        v:SetNWString("loadoutMelee", fiestaMelee)

        if v:Alive() then
            v:StripWeapons()
            v:Give(v:GetNWString("loadoutPrimary"))
            v:Give(v:GetNWString("loadoutSecondary"))
            v:Give(v:GetNWString("loadoutMelee"))
            v:SetAmmo(grenadesOnSpawn, "Grenade")
        end
    end
end

--Generate the table of available weapons if the gamemode is set to FFA.
if activeGamemode == "FFA" then
    for k, v in pairs(weaponArray) do
        if v[3] == "primary" then
            table.insert(randPrimary, v[1])
        elseif v[3] == "secondary" then
            table.insert(randSecondary, v[1])
        elseif v[3] == "melee" or v[3] == "gadget" then
            table.insert(randMelee, v[1])
        end
    end
end

--Generate the table of available weapons if the gamemode is set to Fiesta.
if activeGamemode == "Fiesta" then
    for k, v in pairs(weaponArray) do
        if v[3] == "primary" then
            table.insert(randPrimary, v[1])
        elseif v[3] == "secondary" then
            table.insert(randSecondary, v[1])
        elseif v[3] == "melee" or v[3] == "gadget" then
            table.insert(randMelee, v[1])
        end
    end

    fiestaPrimary = randPrimary[math.random(#randPrimary)]
    fiestaSecondary = randSecondary[math.random(#randSecondary)]
    fiestaMelee = randMelee[math.random(#randMelee)]
    SetGlobal2Int("FiestaTime", fiestaShuffleTime)
    timer.Create("FiestaShuffle", fiestaShuffleTime, 0, ShuffleFiestaLoadout)
end

--Generate weapon ladder if the gamemode is set to Gun Game.
if activeGamemode == "Gun Game" then
    for k, v in pairs(weaponArray) do
        if v[3] == "melee" or v[3] == "gadget" then
            table.insert(ggRandMelee, v[1])
        end
    end

    local ggWeaponArray = weaponArray
    local itemsAdded = 0
    table.Shuffle(ggWeaponArray)

    for k, v in pairs(ggWeaponArray) do
        if (v[3] == "primary" or v[3] == "secondary") and v[1] != "st_stim_pistol" and v[1] != "swat_shield" and v[1] != "tfa_ins2_ak400" and v[1] != "tfa_ins2_cq300" and v[1] != "tfa_ins2_ump45" and v[1] != "tfa_ins2_eftm4a1" and v[1] != "tfa_howa_type_64" and v[1] != "rust_bow" and v[1] != "rust_crossbow" and itemsAdded < (ggLadderSize - 1) then
            table.insert(ggLadder, {v[1], ggRandMelee[math.random(#ggRandMelee)]})
            itemsAdded = itemsAdded + 1
        end
    end
    table.insert(ggLadder, {"tfa_km2000_knife", "fres_grapple"})
end

--Generate the table of available weapons if the gamemode is set to Shotty Snipers.
if activeGamemode == "Shotty Snipers" then
    for k, v in pairs(weaponArray) do
        if v[4] == "sniper" and v[1] != "rust_bow" and v[1] != "rust_crossbow" then
            table.insert(randPrimary, v[1])
        elseif v[4] == "shotgun" then
            table.insert(randSecondary, v[1])
        elseif v[3] == "melee" or v[3] == "gadget" then
            table.insert(randMelee, v[1])
        end
    end
end

--Generate the table of available weapons if the gamemode is set to Cranked.
if activeGamemode == "Cranked" then
    for k, v in pairs(weaponArray) do
        if v[3] == "primary" then
            table.insert(randPrimary, v[1])
        elseif v[3] == "secondary" then
            table.insert(randSecondary, v[1])
        elseif v[3] == "melee" or v[3] == "gadget" then
            table.insert(randMelee, v[1])
        end
    end
end

function HandlePlayerInitialSpawn(ply)
    if activeGamemode == "Shotty Snipers" or activeGamemode == "Cranked" then
        --This sets the players loadout as Networked Strings, this is mainly used to show the players loadout in the Main Menu and to track statistics.
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
    end

    if activeGamemode == "Gun Game" then
        ply:SetNWInt("ladderPosition", 0)
    end
end

function HandlePlayerSpawn(ply)
    if activeGamemode == "Shotty Snipers" or activeGamemode == "Cranked" then
        if usePrimary == true then
            ply:Give(ply:GetNWString("loadoutPrimary"))
        end
        if useSecondary == true then
            ply:Give(ply:GetNWString("loadoutSecondary"))
        end
        if useMelee == true then
            ply:Give(ply:GetNWString("loadoutMelee"))
        end
        ply:SetAmmo(grenadesOnSpawn, "Grenade")
    end

    if activeGamemode == "Gun Game" then
        local wepToGive = ggLadder[ply:GetNWInt("ladderPosition") + 1]
        ply:Give(wepToGive[1])
        ply:Give(wepToGive[2])
    end
end

function HandlePlayerKill(ply, victim)
    if activeGamemode == "Gun Game" then
        if not ply:IsPlayer() or (ply == victim) then return end
        ply:SetNWInt("ladderPosition", ply:GetNWInt("ladderPosition") + 1)
        ply:StripWeapons()
        if ply:GetNWInt("ladderPosition") >= ggLadderSize then EndMatch() return end

        local wepToGive = ggLadder[ply:GetNWInt("ladderPosition") + 1]
        ply:Give(wepToGive[1])
        ply:Give(wepToGive[2])
        if ply:GetNWInt("ladderPosition") == (ggLadderSize - 1) then
            net.Start("NotifyGGThreat")
            net.WriteString(ply:GetName())
            net.Broadcast()
        end
    end

    if activeGamemode == "Cranked" then
        --Player buffs once they become "cranked".
        if ply:GetRunSpeed() <= (275 * playerSpeedMulti) then
            ply:SetRunSpeed(ply:GetRunSpeed() * crankedBuffMultiplier)
            ply:SetWalkSpeed(ply:GetWalkSpeed() * crankedBuffMultiplier)
            ply:SetLadderClimbSpeed(ply:GetLadderClimbSpeed() * crankedBuffMultiplier)
            ply:SetSlowWalkSpeed(ply:GetSlowWalkSpeed() * crankedBuffMultiplier)
            ply:SetCrouchedWalkSpeed(ply:GetCrouchedWalkSpeed() * crankedBuffMultiplier)
        end

        net.Start("NotifyCranked")
        net.Send(ply)
        timer.Create(ply:SteamID() .. "CrankedTimer", crankedSelfDestructTime, 1, function()
            if GetGlobal2Bool("tm_matchended") == true then return end
            local crankedExplosion = ents.Create( "env_explosion" )
            crankedExplosion:SetPos(ply:GetPos())
            crankedExplosion:Spawn()
            crankedExplosion:Fire("Explode")
            crankedExplosion:SetKeyValue("IMagnitude", 20)
            ply:Kill()
        end)
    end
end

function HandlePlayerDeath(ply, weaponName)
    if activeGamemode == "Shotty Snipers" then
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
    end

    if activeGamemode == "Gun Game" then
        if (weaponName == "Tanto" or weaponName == "Mace" or weaponName == "KM-2000" or weaponName == "Suicide") and ply:GetNWInt("ladderPosition") != 0 then ply:SetNWInt("ladderPosition", ply:GetNWInt("ladderPosition") - 1) end
    end

    if activeGamemode == "Cranked" then
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])

        if timer.Exists(ply:SteamID() .. "CrankedTimer") then timer.Remove(ply:SteamID() .. "CrankedTimer") end
    end
end

--Setting up functions depeneding on the gamemode being played, this does not look pretty, but it will stop us from running a shit ton of if statements to check which gamemode is being played.
--FFA & Shotty Snipers
if activeGamemode == "FFA" or activeGamemode == "Shotty Snipers" then
    function HandlePlayerInitialSpawn(ply)
        --This sets the players loadout as Networked Strings, this is mainly used to show the players loadout in the Main Menu and to track statistics.
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
    end

    function HandlePlayerSpawn(ply)
        if usePrimary == true then
            ply:Give(ply:GetNWString("loadoutPrimary"))
        end
        if useSecondary == true then
            ply:Give(ply:GetNWString("loadoutSecondary"))
        end
        if useMelee == true then
            ply:Give(ply:GetNWString("loadoutMelee"))
        end
        ply:SetAmmo(grenadesOnSpawn, "Grenade")
    end

    function HandlePlayerKill(ply, victim)
        return
    end

    function HandlePlayerDeath(ply, weaponName)
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
    end
end

--Fiesta
if activeGamemode == "Fiesta" then
    function HandlePlayerInitialSpawn(ply)
        ply:SetNWString("loadoutPrimary", fiestaPrimary)
        ply:SetNWString("loadoutSecondary", fiestaSecondary)
        ply:SetNWString("loadoutMelee", fiestaMelee)
    end

    function HandlePlayerSpawn(ply)
        ply:Give(ply:GetNWString("loadoutPrimary"))
        ply:Give(ply:GetNWString("loadoutSecondary"))
        ply:Give(ply:GetNWString("loadoutMelee"))
        ply:SetAmmo(grenadesOnSpawn, "Grenade")
    end

    function HandlePlayerKill(ply, victim)
        return
    end

    function HandlePlayerDeath(ply, weaponName)
        return
    end
end

--Gun Game
if activeGamemode == "Gun Game" then
    function HandlePlayerInitialSpawn(ply)
        ply:SetNWInt("ladderPosition", 0)
    end

    function HandlePlayerSpawn(ply)
        local wepToGive = ggLadder[ply:GetNWInt("ladderPosition") + 1]
        ply:Give(wepToGive[1])
        ply:Give(wepToGive[2])
    end

    function HandlePlayerKill(ply, victim)
        if not ply:IsPlayer() or (ply == victim) then return end
        ply:SetNWInt("ladderPosition", ply:GetNWInt("ladderPosition") + 1)
        ply:StripWeapons()
        if ply:GetNWInt("ladderPosition") >= ggLadderSize then EndMatch() return end

        local wepToGive = ggLadder[ply:GetNWInt("ladderPosition") + 1]
        ply:Give(wepToGive[1])
        ply:Give(wepToGive[2])
        if ply:GetNWInt("ladderPosition") == (ggLadderSize - 1) then
            net.Start("NotifyGGThreat")
            net.WriteString(ply:GetName())
            net.Broadcast()
        end
    end

    function HandlePlayerDeath(ply, weaponName)
        if (weaponName == "Tanto" or weaponName == "Mace" or weaponName == "KM-2000" or weaponName == "Suicide") and ply:GetNWInt("ladderPosition") != 0 then ply:SetNWInt("ladderPosition", ply:GetNWInt("ladderPosition") - 1) end
    end
end

--Cranked
if activeGamemode == "Cranked" then
    function HandlePlayerInitialSpawn(ply)
        --This sets the players loadout as Networked Strings, this is mainly used to show the players loadout in the Main Menu and to track statistics.
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
    end

    function HandlePlayerSpawn(ply)
        if usePrimary == true then
            ply:Give(ply:GetNWString("loadoutPrimary"))
        end
        if useSecondary == true then
            ply:Give(ply:GetNWString("loadoutSecondary"))
        end
        if useMelee == true then
            ply:Give(ply:GetNWString("loadoutMelee"))
        end
        ply:SetAmmo(grenadesOnSpawn, "Grenade")
    end

    function HandlePlayerKill(ply, victim)
        --Player buffs once they become "cranked".
        if ply:GetRunSpeed() <= (275 * playerSpeedMulti) then
            ply:SetRunSpeed(ply:GetRunSpeed() * crankedBuffMultiplier)
            ply:SetWalkSpeed(ply:GetWalkSpeed() * crankedBuffMultiplier)
            ply:SetLadderClimbSpeed(ply:GetLadderClimbSpeed() * crankedBuffMultiplier)
            ply:SetSlowWalkSpeed(ply:GetSlowWalkSpeed() * crankedBuffMultiplier)
            ply:SetCrouchedWalkSpeed(ply:GetCrouchedWalkSpeed() * crankedBuffMultiplier)
        end

        net.Start("NotifyCranked")
        net.Send(ply)
        timer.Create(ply:SteamID() .. "CrankedTimer", crankedSelfDestructTime, 1, function()
            if GetGlobal2Bool("tm_matchended") == true then return end
            ply:Kill()
        end)
    end

    function HandlePlayerDeath(ply, weaponName)
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])

        if timer.Exists(ply:SteamID() .. "CrankedTimer") then timer.Remove(ply:SteamID() .. "CrankedTimer") end
    end
end