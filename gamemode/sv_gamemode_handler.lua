local randPrimary = {}
local randSecondary = {}
local randMelee = {}

local gungameLadder = {}

util.AddNetworkString("NotifyGGThreat")

--Generate the table of available weapons if the gamemode is set to FFA.
if activeGamemode == "FFA" then
    for k, v in pairs(weaponArray) do
        if v[3] == "primary" then
            table.insert(randPrimary, v[1])
        elseif v[3] == "secondary" then
            table.insert(randSecondary, v[1])
        elseif v[3] == "melee" or "gadget" then
            table.insert(randMelee, v[1])
        end
    end
end

--Generate weapon ladder if the gamemode is set to Gun Game.
if activeGamemode == "Gun Game" then
    local ggWeaponArray = weaponArray
    local itemsAdded = 0
    table.Shuffle(ggWeaponArray)

    for k, v in pairs(ggWeaponArray) do
        if (v[3] == "primary" or v[3] == "secondary") and v[1] != "st_stim_pistol" and v[1] != "swat_shield" and itemsAdded < (ggLadderSize - 1) then
            table.insert(gungameLadder, v[1])
            itemsAdded = itemsAdded + 1
        end
    end
    table.insert(gungameLadder, "tfa_km2000_knife")
end

function HandlePlayerInitialSpawn(ply)
    if activeGamemode == "FFA" then
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
    if activeGamemode == "FFA" then
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

    if activeGamemode == "Gun Game" then
        ply:Give(gungameLadder[ply:GetNWInt("ladderPosition") + 1])
    end
end

function HandlePlayerKill(ply, victim)
    if not ply:IsPlayer() or (ply == victim) then return end
    ply:SetNWInt("ladderPosition", ply:GetNWInt("ladderPosition") + 1)
    ply:StripWeapons()
    if ply:GetNWInt("ladderPosition") >= ggLadderSize then EndMatch() return end

    ply:Give(gungameLadder[ply:GetNWInt("ladderPosition") + 1])
    if ply:GetNWInt("ladderPosition") == (ggLadderSize - 1) then
        net.Start("NotifyGGThreat")
        net.WriteString(ply:GetName())
        net.Broadcast()
    end
end

function HandlePlayerDeath(ply)
    if activeGamemode == "FFA" then
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
    end
end