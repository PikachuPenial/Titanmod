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

hintArray = {"Winning the match nets you bonus XP", "Suppressors might make your gun sound badass, but it will also lower your damage", "Be vigilant with the acidic flood while playing on the Mephitic map", "Follow CaptainBear on the Steam Workshop", "Switching to your secondary is 'usually' faster than reloading", "To win a match, a player must have more score than the rest of the competing players", "Voice chat is proximity based, do with this information as you see fit", "Slug ammunition turns your traditional shotgun into a marksman rifle", "Try personalizing yourself in the cuztomization menus", "Crouching completely eliminates your footstep audio, embrace the sneaky", "You can cycle through firing modes by using your Interact + Reload keys", "All melee weapons can be thrown with the reload key", "Air strafing is extremely useful, try to incorperate it into your playstyle", "Frag ammunition deafens hit players for a few seconds, and slows down their movement speed", "Explosive barrels can be used as a funny distraction", "Players can not shoot most weapons while submerged in water, use this to your advantage", "Almost everything you do in game is tracked, check out the stats page to compare yourself with others", "The grappling hook can easily be used to start favorable engagments", "Jumping and/or being in mid air gives your weapons less accuracy", "Sliding provides the same accuracy and recoil benefits as crouching", "Chaining multiple accolades together can give a big score/XP boost", "Accolades grant good amounts of score and XP", "Running any optic lowers your weapons ADS speed", "There are over 150+ weapons, try to get consistent with many different loadouts", "There is no scope glint, hardscope all you want", "Hip fire is an effective strategy while on the move", "Other players can see your flashlight, be cautious", "Certain playermodels may shine or stand out in dark enviroments", "Combine wall running and jumping for extremely unpredictable movement", "Wall running through a chokepoint can catch opponents off guard", "Wall jumping constantly allows for continuous climbing of said wall", "All melee weapons have a left and right click attack, learn how effective each are", "Attachments save throughout play sessions, tweak your guns once and you are done", "Some snipers and hand cannons can one shot to the torso", "Explosives hurt, don't aim downwards if you want to stay alive", "Crouching drastically increases your accuracy and recoil control", "Each weapon has its own distinct recoil pattern to master", "Your grappling hook cooldown refreshes on each kill", "Shooting the torso and/or head will guarintee good damage per shot", "You can sprint and/or slide in any direction, not just forwards", "Don't stand still, potshotters will have an easy time killing you", "The vehicles can be mounted and surfed on while playing the Bridge map", "Bunny hopping will help perserve velocity after landing from a grapple/slide"}
quoteArray = {'"thank you for playing my gamemode <3" -Penial', '"a jeep wrangler is less aerodynamic than a lobster" -P0w', '"meow" -Megu', '"my grandma drowned, drowned in drip" -RandomSZ', '"skill issue" -Strike Force Lightning', '"told my wife im going to the bank, didnt tell her which one" -stiel', '"go lick a gas pump" -Bomca', '"justice for cradle, we the people demand" -RandomSZ', '"women fear me, fish want me" -Tomato', '"gang where are you, blud where are you" -White Guy', '"any kief slayers" -Cream', '"if i was a tree, i would have no reason to love a human" -suomij', '"i wish someone wanted me like plankton wanted the formula" -Seven', '"but your honor, babies kick pregnant women all the time" -MegaSlayer', '"by the nine im tweakin" -MegaSlayer', '"ball torture is $4 usd on steam" -Portanator', '"your walls are never safe from the drywall muncher" -Vertex', '"im obviously not racist, ive kissed a black man" -Mattimeo', '"my balls are made of one thing..." -RubberBalls', '"im like that" -Homeless', '"i need about tree fiddy" -Random Films', '"bring out the whole ocean" -Robo', '"can we ban this guy" -Poopy', '"root beer" -Plat', '"never forget 9/11" -afiais', '"praise o monolith" -Medinator', '"shut it mate yer da sells avon" -zee!', '"holy fishpaste" -Zenthic', '"titanmod servers are as stable as a girl with blue hair" -TheBean', '"titanmod is my favorite tactical shooter" -Computery', '"all bark no bite" -Tana', '"a gay man is shooting me" -emaad', '"getting a rainbow wont bring your father back" -SenorDragon', '"wobbler, its on sight" -blackchromatic', '"Hi" -sean', '"aim trainers dont work" -rA warden'}

if GetConVar("tm_developermode"):GetInt() == 1 then DeriveGamemode("sandbox") end