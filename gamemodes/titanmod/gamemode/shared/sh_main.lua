if !game.SinglePlayer() then
    if GetGlobal2String("ActiveGamemode", "FFA") != "Gun Game" then
        hook.Add("PlayerButtonDown", "TitanmodKeybindings", function(ply, button)
            if SERVER then
                -- weapon quick switching
                if ply:GetInfoNum("tm_quickswitching", 1) == 0 then return end
                if button == ply:GetInfoNum("tm_primarybind", KEY_1) then
                    ply:SelectWeapon(ply:GetNWString("loadoutPrimary"))
                end
                if button == ply:GetInfoNum("tm_secondarybind", KEY_2) then
                    ply:SelectWeapon(ply:GetNWString("loadoutSecondary"))
                end
                if button == ply:GetInfoNum("tm_meleebind", KEY_3) then
                    ply:SelectWeapon(ply:GetNWString("loadoutMelee"))
                end

                -- menu
                if button == ply:GetInfoNum("tm_mainmenubind", KEY_M) then
                    if GetGlobal2Int("tm_matchtime", 0) - CurTime() > GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt() then
                        ply:KillSilent()
                        net.Start("OpenMainMenu")
                        net.WriteFloat(0)
                        net.Send(ply)
                    end
                    if ply:Alive() then return end
                    net.Start("OpenMainMenu")
                    if timer.Exists(ply:SteamID() .. "respawnTime") then net.WriteFloat(timer.TimeLeft(ply:SteamID() .. "respawnTime")) else net.WriteFloat(0) end
                    net.Send(ply)
                    ply:SetNWBool("mainmenu", true)
                end
            end
            if CLIENT then
                if GetGlobal2Bool("tm_intermission") then return end
                -- grenade
                if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("+quicknade") end
                hook.Add("PlayerButtonUp", "NadeThrow", function(ply, button)
                    if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("-quicknade") end
                end)
            end
        end)
    else
        hook.Add("PlayerButtonDown", "TitanmodKeybindings", function(ply, button)
            if SERVER then
                -- weapon quick switching
                if ply:GetInfoNum("tm_quickswitching", 1) == 0 then return end
                if button == ply:GetInfoNum("tm_primarybind", KEY_1) then
                    ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][1])
                end

                if (ply:GetNWInt("ladderPosition") == (ggLadderSize - 1)) == false then
                    if button == ply:GetInfoNum("tm_secondarybind", KEY_2) then
                        ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][2])
                    end
                    if button == ply:GetInfoNum("tm_meleebind", KEY_3) then
                        ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][2])
                    end
                end

                -- menu
                if button == ply:GetInfoNum("tm_mainmenubind", KEY_M) then
                    if GetGlobal2Int("tm_matchtime", 0) - CurTime() > GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt() then
                        ply:KillSilent()
                        net.Start("OpenMainMenu")
                        net.WriteFloat(0)
                        net.Send(ply)
                    end
                    if ply:Alive() then return end
                    net.Start("OpenMainMenu")
                    if timer.Exists(ply:SteamID() .. "respawnTime") then net.WriteFloat(timer.TimeLeft(ply:SteamID() .. "respawnTime")) else net.WriteFloat(0) end
                    net.Send(ply)
                    ply:SetNWBool("mainmenu", true)
                end
            end
            if CLIENT then
                if GetGlobal2Bool("tm_intermission") then return end
                -- grenade
                if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("+quicknade") end
                hook.Add("PlayerButtonUp", "NadeThrow", function(ply, button)
                    if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("-quicknade") end
                end)
            end
        end)
    end
else
    -- client sided binds do NOT work in single player, therefore it all needs to be server side
    if GetGlobal2String("ActiveGamemode", "FFA") != "Gun Game" then
        hook.Add("PlayerButtonDown", "TitanmodKeybindings", function(ply, button)
            if SERVER then
                -- weapon quick switching
                if ply:GetInfoNum("tm_quickswitching", 1) == 0 then return end
                if button == ply:GetInfoNum("tm_primarybind", KEY_1) then
                    ply:SelectWeapon(ply:GetNWString("loadoutPrimary"))
                end
                if button == ply:GetInfoNum("tm_secondarybind", KEY_2) then
                    ply:SelectWeapon(ply:GetNWString("loadoutSecondary"))
                end
                if button == ply:GetInfoNum("tm_meleebind", KEY_3) then
                    ply:SelectWeapon(ply:GetNWString("loadoutMelee"))
                end

                -- menu
                if button == ply:GetInfoNum("tm_mainmenubind", KEY_M) then
                    if GetGlobal2Int("tm_matchtime", 0) - CurTime() > GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt() then
                        ply:KillSilent()
                        net.Start("OpenMainMenu")
                        net.WriteFloat(0)
                        net.Send(ply)
                    end
                    if ply:Alive() then return end
                    net.Start("OpenMainMenu")
                    if timer.Exists(ply:SteamID() .. "respawnTime") then net.WriteFloat(timer.TimeLeft(ply:SteamID() .. "respawnTime")) else net.WriteFloat(0) end
                    net.Send(ply)
                    ply:SetNWBool("mainmenu", true)
                end
                if GetGlobal2Bool("tm_intermission") then return end

                -- grenade
                if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("+quicknade") end
                hook.Add("PlayerButtonUp", "NadeThrow", function(ply, button)
                    if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("-quicknade") end
                end)
            end
        end)
    else
        hook.Add("PlayerButtonDown", "TitanmodKeybindings", function(ply, button)
            if SERVER then
                -- weapon quick switching
                if ply:GetInfoNum("tm_quickswitching", 1) == 0 then return end
                if button == ply:GetInfoNum("tm_primarybind", KEY_1) then
                    ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][1])
                end
                if (ply:GetNWInt("ladderPosition") == (ggLadderSize - 1)) == false then
                    if button == ply:GetInfoNum("tm_secondarybind", KEY_2) then
                        ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][2])
                    end
                    if button == ply:GetInfoNum("tm_meleebind", KEY_3) then
                        ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][2])
                    end
                end

                -- menu
                if button == ply:GetInfoNum("tm_mainmenubind", KEY_M) then
                    if GetGlobal2Int("tm_matchtime", 0) - CurTime() > GetGlobal2Int("tm_matchtime", 0) - GetConVar("tm_intermissiontimer"):GetInt() then
                        ply:KillSilent()
                        net.Start("OpenMainMenu")
                        net.WriteFloat(0)
                        net.Send(ply)
                    end
                    if ply:Alive() then return end
                    net.Start("OpenMainMenu")
                    if timer.Exists(ply:SteamID() .. "respawnTime") then net.WriteFloat(timer.TimeLeft(ply:SteamID() .. "respawnTime")) else net.WriteFloat(0) end
                    net.Send(ply)
                    ply:SetNWBool("mainmenu", true)
                end
                if GetGlobal2Bool("tm_intermission") then return end

                -- grenade
                if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("+quicknade") end
                hook.Add("PlayerButtonUp", "NadeThrow", function(ply, button)
                    if button == ply:GetInfoNum("tm_nadebind", KEY_4) then ply:ConCommand("-quicknade") end
                end)
            end
        end)
    end
end

hook.Add("PlayerFootstep", "MuteCrouchFootsteps", function(ply, pos, foot, sound, volume, ktoslishet)
    if !ply:Crouching() then return end
    return true
end)

hook.Add("PlayerDeathSound", "OverrideDeathSound", function(ply) return true end)

-- hook.Add("TFA_MuzzleFlash", "DisableMuzzleFlash", function(Weapon) return false end)

hook.Add("TFA_GetStat", "AdjustTFAWepStats", function(weapon, stat, value)
    if stat == "Primary.RecoilResetTime" then return 0.2 end

    if stat == "TracerCount" then return 0 end
    if stat == "TracerName" then return "nil" or false end
    if stat == "DisableChambering" then return true end
    if stat == "CrouchRecoilMultiplier" then return 0.8 end
    if stat == "CrouchSpreadMultiplier" then return 0.7 end
    if stat == "IronSightsReloadEnabled" then return true end
    if stat == "IronSightsReloadLock" then return false end

    if stat == "Secondary.IronFOV" then return 70 end
    if stat == "Secondary.Point_Shooting_FOV" then return 70 end

    if stat == "Primary.Range" then return 0.6 * (3280 * 16) end
    if stat == "Primary.RangeFalloff" then return 1 end
end)

-- disable specific TFA attachments
hook.Add("TFABase_ShouldLoadAttachment", "DisableUBGL", function(id, path)
    if id and (id == "ins2_fg_gp25" or id == "ins2_fg_m203" or id == "r6s_flashhider_2" or id == "r6s_h_barrel" or id == "am_gib" or id == "am_magnum" or id == "am_match" or id == "flashlight" or id == "flashlight_lastac" or id == "ins2_eft_lastac2" or id == "tfa_at_fml_flashlight" or id == "un_flashlight" or id == "ins2_ub_flashlight") then
        return false
    end
end)

if GetConVar("tm_developermode"):GetInt() == 1 then DeriveGamemode("sandbox") end