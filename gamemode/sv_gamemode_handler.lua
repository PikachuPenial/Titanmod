local activeGamemode = GetGlobalString("ActiveGamemode", "FFA")

local randPrimary = {}
local randSecondary = {}
local randMelee = {}

local ggLadder = {}
local ggRandMelee = {}

local fiestaPrimary
local fiestaSecondary
local fiestaMelee

util.AddNetworkString("NotifyGGThreat")

function ShuffleFiestaLoadout()
    SetGlobalInt("FiestaTime", fiestaShuffleTime + GetGlobalInt("FiestaTime"))
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
            v:SetNWInt("timesUsed_" .. v:GetNWString("loadoutPrimary"), v:GetNWInt("timesUsed_" .. v:GetNWString("loadoutPrimary")) + 1)
            v:Give(v:GetNWString("loadoutSecondary"))
            v:SetNWInt("timesUsed_" .. v:GetNWString("loadoutSecondary"), v:GetNWInt("timesUsed_" .. v:GetNWString("loadoutSecondary")) + 1)
            v:Give(v:GetNWString("loadoutMelee"))
            v:SetNWInt("timesUsed_" .. v:GetNWString("loadoutMelee"), v:GetNWInt("timesUsed_" .. v:GetNWString("loadoutMelee")) + 1)
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
    SetGlobalInt("FiestaTime", fiestaShuffleTime)
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
        if (v[3] == "primary" or v[3] == "secondary") and v[1] != "st_stim_pistol" and v[1] != "swat_shield" and v[1] != "tfa_ins2_ak400" and v[1] != "tfa_ins2_cq300" and v[1] != "tfa_ins2_ump45" and itemsAdded < (ggLadderSize - 1) then
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

function HandlePlayerInitialSpawn(ply)
    if activeGamemode == "FFA" or activeGamemode == "Shotty Snipers" then
        --This sets the players loadout as Networked Strings, this is mainly used to show the players loadout in the Main Menu and to track statistics.
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
    end

    if activeGamemode == "Fiesta" then
        ply:SetNWString("loadoutPrimary", fiestaPrimary)
        ply:SetNWString("loadoutSecondary", fiestaSecondary)
        ply:SetNWString("loadoutMelee", fiestaMelee)
    end

    if activeGamemode == "Gun Game" then
        ply:SetNWInt("ladderPosition", 0)
    end
end

function HandlePlayerSpawn(ply)
    if activeGamemode == "FFA" or activeGamemode == "Shotty Snipers" then
        if usePrimary == true then
            ply:Give(ply:GetNWString("loadoutPrimary"))
            ply:SetNWInt("timesUsed_" .. ply:GetNWString("loadoutPrimary"), ply:GetNWInt("timesUsed_" .. ply:GetNWString("loadoutPrimary")) + 1)
        end
        if useSecondary == true then
            ply:Give(ply:GetNWString("loadoutSecondary"))
            ply:SetNWInt("timesUsed_" .. ply:GetNWString("loadoutSecondary"), ply:GetNWInt("timesUsed_" .. ply:GetNWString("loadoutSecondary")) + 1)
        end
        if useMelee == true then
            ply:Give(ply:GetNWString("loadoutMelee"))
            ply:SetNWInt("timesUsed_" .. ply:GetNWString("loadoutMelee"), ply:GetNWInt("timesUsed_" .. ply:GetNWString("loadoutMelee")) + 1)
        end
        ply:SetAmmo(grenadesOnSpawn, "Grenade")
    end

    if activeGamemode == "Fiesta" then
        ply:Give(ply:GetNWString("loadoutPrimary"))
        ply:SetNWInt("timesUsed_" .. ply:GetNWString("loadoutPrimary"), ply:GetNWInt("timesUsed_" .. ply:GetNWString("loadoutPrimary")) + 1)

        ply:Give(ply:GetNWString("loadoutSecondary"))
        ply:SetNWInt("timesUsed_" .. ply:GetNWString("loadoutSecondary"), ply:GetNWInt("timesUsed_" .. ply:GetNWString("loadoutSecondary")) + 1)

        ply:Give(ply:GetNWString("loadoutMelee"))
        ply:SetNWInt("timesUsed_" .. ply:GetNWString("loadoutMelee"), ply:GetNWInt("timesUsed_" .. ply:GetNWString("loadoutMelee")) + 1)

        ply:SetAmmo(grenadesOnSpawn, "Grenade")
    end

    if activeGamemode == "Gun Game" then
        local wepToGive = ggLadder[ply:GetNWInt("ladderPosition") + 1]
        ply:Give(wepToGive[1])
        ply:Give(wepToGive[2])
        ply:SetNWInt("timesUsed_" .. wepToGive[1], ply:GetNWInt("timesUsed_" .. wepToGive[1]) + 1)
        ply:SetNWInt("timesUsed_" .. wepToGive[2], ply:GetNWInt("timesUsed_" .. wepToGive[2]) + 1)
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
        ply:SetNWInt("timesUsed_" .. wepToGive[1], ply:GetNWInt("timesUsed_" .. wepToGive[1]) + 1)
        ply:SetNWInt("timesUsed_" .. wepToGive[2], ply:GetNWInt("timesUsed_" .. wepToGive[2]) + 1)
        if ply:GetNWInt("ladderPosition") == (ggLadderSize - 1) then
            net.Start("NotifyGGThreat")
            net.WriteString(ply:GetName())
            net.Broadcast()
        end
    end
end

function HandlePlayerDeath(ply, weaponName)
    if activeGamemode == "FFA" or activeGamemode == "Shotty Snipers" then
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
    end

    if activeGamemode == "Gun Game" then
        if (weaponName == "Tanto" or weaponName == "Japanese Ararebo" or weaponName == "KM-2000" or weaponName == "Suicide") and ply:GetNWInt("ladderPosition") != 0 then ply:SetNWInt("ladderPosition", ply:GetNWInt("ladderPosition") - 1) end
    end
end