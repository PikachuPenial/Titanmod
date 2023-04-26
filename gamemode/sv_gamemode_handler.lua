--Creates weapon table for usage in FFA
local randPrimary = {}
local randSecondary = {}
local randMelee = {}

for k, v in pairs(weaponArray) do
	if v[3] == "primary" then
		table.insert(randPrimary, v[1])
	elseif v[3] == "secondary" then
		table.insert(randSecondary, v[1])
	elseif v[3] == "melee" or "gadget" then
		table.insert(randMelee, v[1])
	end
end

function HandlePlayerInitialSpawn(ply)
    if activeGamemode == "FFA" then
        --This sets the players loadout as Networked Strings, this is mainly used to show the players loadout in the Main Menu and to track statistics.
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
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
end

function HandlePlayerKill(ply)

end

function HandlePlayerDeath(ply)
    if activeGamemode == "FFA" then
        ply:SetNWString("loadoutPrimary", randPrimary[math.random(#randPrimary)])
        ply:SetNWString("loadoutSecondary", randSecondary[math.random(#randSecondary)])
        ply:SetNWString("loadoutMelee", randMelee[math.random(#randMelee)])
    end
end