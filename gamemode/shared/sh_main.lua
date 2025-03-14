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
                if button == ply:GetInfoNum("tm_secondarybind", KEY_2) then
                    ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][2])
                end
                if button == ply:GetInfoNum("tm_meleebind", KEY_3) then
                    ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][2])
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
                if button == ply:GetInfoNum("tm_secondarybind", KEY_2) then
                    ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][2])
                end
                if button == ply:GetInfoNum("tm_meleebind", KEY_3) then
                    ply:SelectWeapon(ggLadder[ply:GetNWInt("ladderPosition") + 1][2])
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

hook.Add("TFA_GetStat", "AdjustTFAWepStats", function(weapon, stat, value)
    if stat == "TracerCount" then return 0 end
    if stat == "TracerName" then return "nil" or false end
    if stat == "DisableChambering" then return true end
    if stat == "Secondary.IronFOV_MX4" then return 64 end
    if stat == "CrouchRecoilMultiplier" then return 0.8 end
    if stat == "CrouchSpreadMultiplier" then return 0.7 end
    if stat == "IronSightsReloadEnabled" then return true end
    if stat == "IronSightsReloadLock" then return false end
end)

-- disable specific TFA attachments
hook.Add("TFABase_ShouldLoadAttachment", "DisableUBGL", function(id, path)
    if id and (id == "ins2_fg_gp25" or id == "ins2_fg_m203" or id == "r6s_flashhider_2" or id == "r6s_h_barrel" or id == "am_gib" or id == "am_magnum" or id == "am_match" or id == "flashlight" or id == "flashlight_lastac" or id == "ins2_eft_lastac2" or id == "tfa_at_fml_flashlight" or id == "un_flashlight" or id == "ins2_ub_flashlight") then
        return false
    end
end)

-- model array formatting (Model ID, Model Name, Model Description, Unlock Style, Unlock Value)
modelArray = {}
modelArray[1] = {"models/player/Group03/male_02.mdl", "Male", "default", "default"}
modelArray[2] = {"models/player/Group03/female_02.mdl", "Female", "default", "default"}
modelArray[3] = {"models/player/Group01/male_03.mdl", "Casual Male", "default", "default"}
modelArray[4] = {"models/player/mossman.mdl", "Casual Female", "default", "default"}
modelArray[5] = {"models/player/Group03m/male_05.mdl", "Doctor", "default", "default"}
modelArray[6] = {"models/player/Group03m/female_06.mdl", "Nurse", "default", "default"}
modelArray[7] = {"models/player/barney.mdl", "Barney", "default", "default"}
modelArray[8] = {"models/player/kleiner.mdl", "Kleiner", "default", "default"}
modelArray[9] = {"models/player/Group01/male_07.mdl", "Male 07", "kills", 100}
modelArray[10] = {"models/player/alyx.mdl", "Alyx", "kills", 300}
modelArray[11] = {"models/player/hostage/hostage_04.mdl", "Scientist", "kills", 500}
modelArray[12] = {"models/player/gman_high.mdl", "GMan", "kills", 1000}
modelArray[13] = {"models/player/p2_chell.mdl", "Chell", "kills", 2000}
modelArray[14] = {"models/player/leet.mdl", "Badass", "kills", 3000}
modelArray[15] = {"models/player/arctic.mdl", "Frozen", "streak", 5}
modelArray[16] = {"models/player/riot.mdl", "Riot", "streak", 10}
modelArray[17] = {"models/player/gasmask.mdl", "Hazard Suit", "streak", 15}
modelArray[18] = {"models/player/police.mdl", "Officer", "streak", 20}
modelArray[19] = {"models/player/combine_soldier_prisonguard.mdl", "Cobalt Soilder", "streak", 25}
modelArray[20] = {"models/walterwhite/playermodels/walterwhitechem.mdl", "Drug Dealer", "streak", 30}
modelArray[21] = {"models/halo2/spartan_red.mdl", "Red", "matches", 1}
modelArray[22] = {"models/Splinks/Hotline_Miami/Jacket/Drive/Player_jacket_Drive.mdl", "Drive", "matches", 5}
modelArray[23] = {"models/konnie/asapgaming/modernwarfare/grinchghillie.mdl", "Grinch", "matches", 20}
modelArray[24] = {"models/dizcordum/fallen_set.mdl", "Fallen", "matches", 50}
modelArray[25] = {"models/timbleweebs/azura/azura_cyberpunk_pm.mdl", "Ethereal", "matches", 100}
modelArray[26] = {"models/player/skeleton.mdl", "Bones", "matches", 200}
modelArray[27] = {"models/halo2/spartan_blue.mdl", "Blue", "wins", 1}
modelArray[28] = {"models/humans/group03/chemsuit.mdl", "Radioactive", "wins", 3}
modelArray[29] = {"models/COW MW22 Horangi/Horangi.mdl", "Horangi", "wins", 10}
modelArray[30] = {"models/dap_blood/playermodel/dap_blood.mdl", "V1", "wins", 20}
modelArray[31] = {"models/florian/comission/helljumper/helljumper.mdl", "Helljumper", "wins", 50}
modelArray[32] = {"models/player/zombie_fast.mdl", "Infected", "wins", 100}
modelArray[33] = {"models/paynamia/bms/gordon_survivor_player.mdl", "Gordon", "headshot", 125}
modelArray[34] = {"models/munch/mace/Mace.mdl", "Mace", "headshot", 250}
modelArray[35] = {"models/player/darky_m/rust/arctic_hazmat.mdl", "Arctic", "headshot", 450}
modelArray[36] = {"models/player/eft/shturman/eft_shturman/models/eft_shturman_pm.mdl", "Shturman", "headshot", 900}
modelArray[37] = {"models/player/darky_m/rust/scientist.mdl", "Cobalt", "smackdown", 40}
modelArray[38] = {"models/Splinks/Hotline_Miami/Jacket/Player_jacket.mdl", "Jacket", "smackdown", 80}
modelArray[39] = {"models/titanfall2_playermodel/kanepm.mdl", "Kane", "smackdown", 160}
modelArray[40] = {"models/auditor/r6s/707/vigil/chr_707_vigil.mdl", "Vigil", "smackdown", 320}
modelArray[41] = {"models/player/combine_super_soldier.mdl", "Super Soilder", "clutch", 30}
modelArray[42] = {"models/patrickbateman/Playermodels/patrickbateman.mdl", "Bateman", "clutch", 60}
modelArray[43] = {"models/player/darky_m/rust/spacesuit.mdl", "Spacesuit", "clutch", 150}
modelArray[44] = {"models/us_airforce/jetpilot_usaf.mdl", "Pilot", "clutch", 300}
modelArray[45] = {"models/player/john_marston.mdl", "Martson", "longshot", 30}
modelArray[46] = {"models/player/darky_m/rust/hazmat.mdl", "Hazmat", "longshot", 60}
modelArray[47] = {"models/player/darky_m/rust/nomad.mdl", "Nomad", "longshot", 150}
modelArray[48] = {"models/arachnit/csgonewsas/ctm_sasplayerwinter.mdl", "Winter SAS", "longshot", 300}
modelArray[49] = {"models/maxpayne3/ufe/ufepm.mdl", "UFE", "pointblank", 120}
modelArray[50] = {"models/starwarsbf1/Scoutrooper.mdl", "Scout", "pointblank", 240}
modelArray[51] = {"models/kyo/ghot.mdl", "Ghost", "pointblank", 480}
modelArray[52] = {"models/arachnit/csgonewsas/ctm_sasplayer.mdl", "SAS", "pointblank", 720}
modelArray[53] = {"models/Krueger_PlayerModel/Zaper/Krueger_Body.mdl", "Krueger", "killstreaks", 80}
modelArray[54] = {"models/player/tabspeasant.mdl", "Wobbler", "killstreaks", 160}
modelArray[55] = {"models/captainbigbutt/vocaloid/miku_classic.mdl", "Miku", "killstreaks", 320}
modelArray[56] = {"models/theboys/homelander.mdl", "Homelander", "killstreaks", 480}
modelArray[57] = {"models/player/voikanaa/snoop_dogg.mdl", "Snoop", "buzzkills", 60}
modelArray[58] = {"models/pacagma/humans/heroes/imc_hero_viper_player.mdl", "Viper", "buzzkills", 120}
modelArray[59] = {"models/auditor/titanfall2/cooper/chr_jackcooper.mdl", "Cooper", "buzzkills", 200}
modelArray[60] = {"models/auditor/re2/chr_hunk_pmrig.mdl", "Hunk", "buzzkills", 320}

-- calling card array formatting (Image File, Card Name, Card Description, Unlock Style, Unlock Value)
cardArray = {}
cardArray[1] = {"cards/default/barrels.png", "Barrels", "", "default", "default"}
cardArray[2] = {"cards/default/carbon.png", "Carbon", "", "default", "default"}
cardArray[3] = {"cards/default/construct.png", "Construct", "", "default", "default"}
cardArray[4] = {"cards/default/flare.png", "Flare", "", "default", "default"}
cardArray[5] = {"cards/default/flattywood.png", "Fattywood", "", "default", "default"}
cardArray[6] = {"cards/default/grapple.png", "Grapple", "", "default", "default"}
cardArray[7] = {"cards/default/industry.png", "Industry", "", "default", "default"}
cardArray[8] = {"cards/default/monkey.png", "Le Monk", "", "default", "default"}
cardArray[9] = {"cards/default/overhead.png", "Overhead", "", "default", "default"}
cardArray[10] = {"cards/default/specops.png", "Spec Ops", "", "default", "default"}
cardArray[11] = {"cards/default/stargazing.png", "Stargazing", "", "default", "default"}
cardArray[12] = {"cards/default/strobe.png", "Strobe", "", "default", "default"}
cardArray[13] = {"cards/kills/kill50.png", "Pistoling", "", "kills", 50}
cardArray[14] = {"cards/kills/kill200.png", "Smoke", "", "kills", 200}
cardArray[15] = {"cards/kills/kill500.png", "Titan", "", "kills", 500}
cardArray[16] = {"cards/kills/kill1000.png", "Hardened", "", "kills", 1000}
cardArray[17] = {"cards/kills/kill2000.png", "Leader", "", "kills", 2000}
cardArray[18] = {"cards/kills/kill3000.png", "Specialist", "", "kills", 3000}
cardArray[19] = {"cards/kills/streak5.png", "Convoy", "", "streak", 5}
cardArray[20] = {"cards/kills/streak10.png", "Expedition", "", "streak", 10}
cardArray[21] = {"cards/kills/streak15.png", "On Fire", "", "streak", 15}
cardArray[22] = {"cards/kills/streak20.png", "Artillery", "", "streak", 20}
cardArray[23] = {"cards/kills/streak25.png", "Timed", "", "streak", 25}
cardArray[24] = {"cards/kills/streak30.png", "Nuclear", "", "streak", 30}
cardArray[25] = {"cards/kills/matches1.png", "Noob", "", "matches", 1}
cardArray[26] = {"cards/kills/matches5.png", "Luke Warm", "", "matches", 5}
cardArray[27] = {"cards/kills/matches20.png", "Utility", "", "matches", 20}
cardArray[28] = {"cards/kills/matches50.png", "Lurking", "", "matches", 50}
cardArray[29] = {"cards/kills/matches100.png", "Expert", "", "matches", 100}
cardArray[30] = {"cards/kills/matches200.png", "Complete", "", "matches", 200}
cardArray[31] = {"cards/kills/wins1.png", "Victor", "", "wins", 1}
cardArray[32] = {"cards/kills/wins3.png", "Finish Line", "", "wins", 3}
cardArray[33] = {"cards/kills/wins10.png", "Confetti", "", "wins", 10}
cardArray[34] = {"cards/kills/wins20.png", "Improving", "", "wins", 20}
cardArray[35] = {"cards/kills/wins50.png", "Red Carpet", "", "wins", 50}
cardArray[36] = {"cards/kills/wins100.png", "Proud", "", "wins", 100}
cardArray[37] = {"cards/accolades/headshot1.png", "Headshot", "", "headshot", 50}
cardArray[38] = {"cards/accolades/headshot2.png", "Hunter", "", "headshot", 100}
cardArray[39] = {"cards/accolades/headshot3.png", "Icon", "", "headshot", 200}
cardArray[40] = {"cards/accolades/headshot4.png", "NODs", "", "headshot", 400}
cardArray[41] = {"cards/accolades/smackdown1.png", "Karambit", "", "smackdown", 25}
cardArray[42] = {"cards/accolades/smackdown2.png", "Samuri", "", "smackdown", 50}
cardArray[43] = {"cards/accolades/smackdown3.png", "Beach", "", "smackdown", 100}
cardArray[44] = {"cards/accolades/smackdown4.png", "Execution", "", "smackdown", 200}
cardArray[45] = {"cards/accolades/clutch1.png", "Deagle", "", "clutch", 30}
cardArray[46] = {"cards/accolades/clutch2.png", "Magnum", "", "clutch", 60}
cardArray[47] = {"cards/accolades/clutch3.png", "KRISS", "", "clutch", 100}
cardArray[48] = {"cards/accolades/clutch4.png", "FN", "", "clutch", 180}
cardArray[49] = {"cards/accolades/longshot1.png", "Downhill", "", "longshot", 30}
cardArray[50] = {"cards/accolades/longshot2.png", "Stalker", "", "longshot", 60}
cardArray[51] = {"cards/accolades/longshot3.png", "Highrise", "", "longshot", 100}
cardArray[52] = {"cards/accolades/longshot4.png", "Tactical", "", "longshot", 180}
cardArray[53] = {"cards/accolades/pointblank1.png", "Showers", "", "pointblank", 45}
cardArray[54] = {"cards/accolades/pointblank2.png", "Full Auto", "", "pointblank", 90}
cardArray[55] = {"cards/accolades/pointblank3.png", "Live Fire", "", "pointblank", 150}
cardArray[56] = {"cards/accolades/pointblank4.png", "Dual Wield", "", "pointblank", 275}
cardArray[57] = {"cards/accolades/killstreaks1.png", "Soilder", "", "killstreaks", 40}
cardArray[58] = {"cards/accolades/killstreaks2.png", "Badass", "", "killstreaks", 90}
cardArray[59] = {"cards/accolades/killstreaks3.png", "Skulls", "", "killstreaks", 160}
cardArray[60] = {"cards/accolades/killstreaks4.png", "Radiation", "", "killstreaks", 270}
cardArray[61] = {"cards/accolades/buzzkills1.png", "Wobblers", "", "buzzkills", 40}
cardArray[62] = {"cards/accolades/buzzkills2.png", "POV", "", "buzzkills", 90}
cardArray[63] = {"cards/accolades/buzzkills3.png", "Preperation", "", "buzzkills", 160}
cardArray[64] = {"cards/accolades/buzzkills4.png", "Twin Flame", "", "buzzkills", 270}
cardArray[65] = {"cards/color/red.png", "Red", "Solid red color", "color", "color"}
cardArray[66] = {"cards/color/orange.png", "Orange", "Solid orange color", "color", "color"}
cardArray[67] = {"cards/color/yellow.png", "Yellow", "Solid yellow color", "color", "color"}
cardArray[68] = {"cards/color/lime.png", "Lime", "Solid lime color", "color", "color"}
cardArray[69] = {"cards/color/cyan.png", "Cyan", "Solid cyan color", "color", "color"}
cardArray[70] = {"cards/color/blue.png", "Blue", "Solid blue color", "color", "color"}
cardArray[71] = {"cards/color/purple.png", "Purple", "Solid magenta color", "color", "color"}
cardArray[72] = {"cards/color/pink.png", "Pink", "Solid pink color", "color", "color"}
cardArray[73] = {"cards/color/brown.png", "Brown", "Solid brown color", "color", "color"}
cardArray[74] = {"cards/color/gray.png", "Gray", "Solid gray color", "color", "color"}
cardArray[75] = {"cards/color/white.png", "White", "Solid white color", "color", "color"}
cardArray[76] = {"cards/color/black.png", "Black", "Solid black color", "color", "color"}
cardArray[77] = {"cards/mastery/aa12.png", "Close Up", "AA-12 mastery", "mastery", "tfa_ins2_aa12"}
cardArray[78] = {"cards/mastery/acr.png", "Posted Up", "ACR mastery", "mastery", "tfa_ins2_acrc"}
cardArray[79] = {"cards/mastery/aek971.png", "Stalker", "AEK-971 mastery", "mastery", "tfa_ins2_aek971"}
cardArray[80] = {"cards/mastery/ak12.png", "Inspection", "AK-12 mastery", "mastery", "tfa_ins2_ak12"}
cardArray[81] = {"cards/mastery/ak400.png", "Overhead", "AK-400 mastery", "mastery", "tfa_ins2_ak400"}
cardArray[82] = {"cards/mastery/ak47.png", "Sunset", "AK-47 mastery", "mastery", "tfa_ins2_akms"}
cardArray[83] = {"cards/mastery/aks74u.png", "Loaded", "AKS-74U mastery", "mastery", "tfa_ins2_aks_r"}
cardArray[84] = {"cards/mastery/an94.png", "Hijacked", "AN-94 mastery", "mastery", "tfa_ins2_abakan"}
cardArray[85] = {"cards/mastery/ar57.png", "Ghost", "AR-57 mastery", "mastery", "tfa_ins2_ar57"}
cardArray[86] = {"cards/mastery/asval.png", "Obesa", "AS-VAL mastery", "mastery", "tfa_inss_asval"}
cardArray[87] = {"cards/mastery/ash12.png", "Interstellar", "ASh-12 mastery", "mastery", "tfa_pd2_ash12"}
cardArray[88] = {"cards/mastery/auga2.png", "Lightning", "AUG A2 mastery", "mastery", "tfa_fml_csgo_aug"}
cardArray[89] = {"cards/mastery/awm.png", "Dust II", "AWM mastery", "mastery", "tfa_cod_accuracy_international_l115a3"}
cardArray[90] = {"cards/mastery/ax308.png", "Range", "AX-308 mastery", "mastery", "tfa_ins2_warface_ax308"}
cardArray[91] = {"cards/mastery/barrettm98b.png", "Ready", "Barrett M98B mastery", "mastery", "tfa_ins2_barrett_m98_bravo"}
cardArray[92] = {"cards/mastery/berettamx4.png", "House", "Barrett Mx4 mastery", "mastery", "tfa_ins2_mx4"}
cardArray[93] = {"cards/mastery/bow.png", "Cargo Ship", "Bow mastery", "mastery", "rust_bow"}
cardArray[94] = {"cards/mastery/br99.png", "Rouge", "BR99 mastery", "mastery", "tfa_ins2_br99"}
cardArray[95] = {"cards/mastery/bren.png", "Flank", "Bren mastery", "mastery", "tfa_doibren"}
cardArray[96] = {"cards/mastery/colt9mm.png", "Magazines", "Colt 9mm mastery", "mastery", "tfa_ins2_m4_9mm"}
cardArray[97] = {"cards/mastery/crossbow.png", "Arrows", "Crossbow mastery", "mastery", "rust_crossbow"}
cardArray[98] = {"cards/mastery/cz75.png", "Nuke", "CZ 75 mastery", "mastery", "tfa_ins2_cz75"}
cardArray[99] = {"cards/mastery/cz805.png", "Showcase", "CZ 805 mastery", "mastery", "tfa_ins2_cz805"}
cardArray[100] = {"cards/mastery/deserteagle.png", "Mag Check", "Desert Eagle mastery", "mastery", "tfa_ins2_deagle"}
cardArray[101] = {"cards/mastery/dsr50.png", "Arena", "DSR-50 mastery", "mastery", "tfa_ins2_warface_amp_dsr1"}
cardArray[102] = {"cards/mastery/dualskorpion.png", "Celestial", "Dual Skorpions mastery", "mastery", "tfa_l4d2_skorpion_dual"}
cardArray[103] = {"cards/mastery/famas.png", "Siege", "Famas mastery", "mastery", "tfa_ins2_famas"}
cardArray[104] = {"cards/mastery/fg42.png", "Glint", "FG 42 mastery", "mastery", "tfa_doifg42"}
cardArray[105] = {"cards/mastery/fiveseven.png", "Galactic", "Fiveseven mastery", "mastery", "tfa_ins2_fiveseven_eft"}
cardArray[106] = {"cards/mastery/fn2000.png", "Armory", "FN 2000 mastery", "mastery", "tfa_ins2_fn_2000"}
cardArray[107] = {"cards/mastery/fnfal.png", "Exposed", "FN FAL mastery", "mastery", "tfa_ins2_fn_fal"}
cardArray[108] = {"cards/mastery/fnp45.png", "ACP", "FNP-45 mastery", "mastery", "tfa_ins2_fnp45"}
cardArray[109] = {"cards/mastery/g28.png", "Legacy", "G28 mastery", "mastery", "tfa_ins2_g28"}
cardArray[110] = {"cards/mastery/g36a1.png", "Aimpoint", "G36A1 mastery", "mastery", "tfa_ins2_g36a1"}
cardArray[111] = {"cards/mastery/glock18.png", "Ospery", "Glock 18 mastery", "mastery", "tfa_glk_gen4"}
cardArray[112] = {"cards/mastery/grenade.png", "Quasar", "Grenade mastery", "mastery", "grenade"}
cardArray[113] = {"cards/mastery/groza.png", "Bullpup", "Groza mastery", "mastery", "tfa_ins2_groza"}
cardArray[114] = {"cards/mastery/gsh18.png", "Skyscraper", "GSH-18 mastery", "mastery", "tfa_ins2_gsh18"}
cardArray[115] = {"cards/mastery/hk53.png", "Chains", "HK53 mastery", "mastery", "tfa_ins2_fml_hk53"}
cardArray[116] = {"cards/mastery/honeybadger.png", "Business", "Honey Badger mastery", "mastery", "tfa_ins2_cq300"}
cardArray[117] = {"cards/mastery/howatype64.png", "Cradle", "Howa Type 64 mastery", "mastery", "tfa_howa_type_64"}
cardArray[118] = {"cards/mastery/imbelia2.png", "Process", "Imbel IA2 mastery", "mastery", "tfa_ins2_imbelia2"}
cardArray[119] = {"cards/mastery/intervention.png", "Trickshot", "Intervention mastery", "mastery", "tfa_ins2_warface_cheytac_m200"}
cardArray[120] = {"cards/mastery/kacchainsaw.png", "Scare", "KAC ChainSAW mastery", "mastery", "ryry_tfa_chainsaw"}
cardArray[121] = {"cards/mastery/km2000.png", "Flatgrass", "KM-2000 mastery", "mastery", "tfa_km2000_knife"}
cardArray[122] = {"cards/mastery/krissvector.png", "Narkotica", "KRISS Vector mastery", "mastery", "tfa_ins2_krissv"}
cardArray[123] = {"cards/mastery/ksg.png", "Flames", "KSG mastery", "mastery", "tfa_ins2_ksg"}
cardArray[124] = {"cards/mastery/l85.png", "Groves", "L85 mastery", "mastery", "tfa_ins2_l85a2"}
cardArray[125] = {"cards/mastery/leeenfield.png", "Minecraft", "Lee Enfield master", "mastery", "tfa_doi_enfield"}
cardArray[126] = {"cards/mastery/lewis.png", "Big Bang", "Lewis mastery", "mastery", "tfa_doilewis"}
cardArray[127] = {"cards/mastery/lr300.png", "Oil Rig", "LR-300 mastery", "mastery", "tfa_ins2_zm_lr300"}
cardArray[128] = {"cards/mastery/m1garand.png", "Underworld", "M1 Garand mastery", "mastery", "tfa_doi_garand"}
cardArray[129] = {"cards/mastery/m14.png", "Bridge", "M14 mastery", "mastery", "tfa_ins2_m14retro"}
cardArray[130] = {"cards/mastery/m1911.png", "Relic", "M1911 mastery", "mastery", "tfa_nam_m1911"}
cardArray[131] = {"cards/mastery/m1918.png", "Bipod", "M1918 mastery", "mastery", "tfa_doim1918"}
cardArray[132] = {"cards/mastery/m1919.png", "Customs", "M1919 mastery", "mastery", "tfa_doim1919"}
cardArray[133] = {"cards/mastery/m249.png", "Camper", "M249 mastery", "mastery", "tfa_ins2_minimi"}
cardArray[134] = {"cards/mastery/m3grease.png", "Grease", "M3 Grease Gun mastery", "mastery", "tfa_doim3greasegun"}
cardArray[135] = {"cards/mastery/m45a1.png", "Legend", "M45A1 mastery", "mastery", "tfa_ins2_colt_m45"}
cardArray[136] = {"cards/mastery/m4a1.png", "Smug", "M4A1 mastery", "mastery", "tfa_ins2_eftm4a1"}
cardArray[137] = {"cards/mastery/m79.png", "Cool With It", "M79 mastery", "mastery", "tfa_nam_m79"}
cardArray[138] = {"cards/mastery/m9.png", "Full Metal", "M9 mastery", "mastery", "tfa_ins2_m9"}
cardArray[139] = {"cards/mastery/mac10.png", "Dev", "Mac 10 mastery", "mastery", "bocw_mac10_alt"}
cardArray[140] = {"cards/mastery/mace.png", "Industry", "Mace master", "mastery", "tfa_ararebo_bf1"}
cardArray[141] = {"cards/mastery/makarov.png", "Leaves", "Makarov mastery", "mastery", "tfa_ins2_pm"}
cardArray[142] = {"cards/mastery/maresleg.png", "High Optic", "Mare's Leg mastery", "mastery", "tfa_tfre_maresleg"}
cardArray[143] = {"cards/mastery/mas38.png", "Galaxy", "Mas 38 mastery", "mastery", "tfa_fml_lefrench_mas38"}
cardArray[144] = {"cards/mastery/mg34.png", "Heavy ", "MG 34 mastery", "mastery", "tfa_doimg34"}
cardArray[145] = {"cards/mastery/mg42.png", "D-Day", "MG 42 mastery", "mastery", "tfa_doimg42"}
cardArray[146] = {"cards/mastery/mk14ebr.png", "Prepared", "MK 14 EBR mastery", "mastery", "tfa_ins2_mk14ebr"}
cardArray[147] = {"cards/mastery/mk23.png", "Uranium", "MK 23 mastery", "mastery", "tfa_ins2_mk23"}
cardArray[148] = {"cards/mastery/mk18.png", "Waster", "MK18 mastery", "mastery", "tfa_fml_inss_mk18"}
cardArray[149] = {"cards/mastery/model10.png", "Walter", "Model 10 mastery", "mastery", "tfa_ins2_swmodel10"}
cardArray[150] = {"cards/mastery/mosin.png", "Rebirth", "Mosin Nagant mastery", "mastery", "tfa_ins2_mosin_nagant"}
cardArray[151] = {"cards/mastery/mp40.png", "Reflection", "MP 40 mastery", "mastery", "tfa_doimp40"}
cardArray[152] = {"cards/mastery/mp443.png", "Bush", "MP-443 mastery", "mastery", "tfa_ins2_mp443"}
cardArray[153] = {"cards/mastery/mp18.png", "Modern", "MP18 mastery", "mastery", "tfa_ww1_mp18"}
cardArray[154] = {"cards/mastery/mp5.png", "Select", "MP5 mastery", "mastery", "tfa_inss2_hk_mp5a5"}
cardArray[155] = {"cards/mastery/mp5k.png", "H&K", "MP5K mastery", "mastery", "tfa_ins2_mp5k"}
cardArray[156] = {"cards/mastery/mp7.png", "Oilspill", "MP7 mastery", "mastery", "tfa_ins2_mp7"}
cardArray[157] = {"cards/mastery/mp9.png", "Training", "MP9 mastery", "mastery", "tfa_ins2_warface_bt_mp9"}
cardArray[158] = {"cards/mastery/mpx.png", "Waterfall", "MPX mastery", "mastery", "tfa_jw_tti_mpx"}
cardArray[159] = {"cards/mastery/mr96.png", "Polish", "MR-96 mastery", "mastery", "tfa_ins2_mr96"}
cardArray[160] = {"cards/mastery/mts225.png", "Slug", "MTs225 mastery", "mastery", "tfa_ins2_mc255"}
cardArray[161] = {"cards/mastery/nova.png", "Dark Street", "Nova mastery", "mastery", "tfa_ins2_nova"}
cardArray[162] = {"cards/mastery/osp18.png", "Irons", "OSP-18 mastery", "mastery", "tfa_l4d2_osp18"}
cardArray[163] = {"cards/mastery/otspernach.png", "Speedloader", "OTs-33 Pernach mastery", "mastery", "tfa_ins2_ots_33_pernach"}
cardArray[164] = {"cards/mastery/owenmki.png", "Grid", "Owen Gun mastery", "mastery", "tfa_doiowen"}
cardArray[165] = {"cards/mastery/p320.png", "Sauer", "P320 mastery", "mastery", "tfa_ins2_p320_m18"}
cardArray[166] = {"cards/mastery/p90.png", "MISSING", "P90 mastery", "mastery", "tfa_fml_p90_tac"}
cardArray[167] = {"cards/mastery/pindad.png", "Labs", "Pindad SS2 mastery", "mastery", "tfa_blast_pindadss2"}
cardArray[168] = {"cards/mastery/pkp.png", "Royalty", "PKP mastery", "mastery", "tfa_ins2_pkp"}
cardArray[169] = {"cards/mastery/pm9.png", "Akimbo", "PM-9 mastery", "mastery", "tfa_ins2_pm9"}
cardArray[170] = {"cards/mastery/ppbizon.png", "Rainbow", "PP-19 Bizon mastery", "mastery", "tfa_fas2_ppbizon"}
cardArray[171] = {"cards/mastery/ppsh.png", "Mephitic", "PPSH mastery", "mastery", "tfa_nam_ppsh41"}
cardArray[172] = {"cards/mastery/pzb39.png", "Exotic", "PzB 39 mastery", "mastery", "tfa_ww2_pbz39"}
cardArray[173] = {"cards/mastery/qbz97.png", "Hideout", "QBZ-97 mastery", "mastery", "tfa_ins2_norinco_qbz97"}
cardArray[174] = {"cards/mastery/qsz92.png", "yippee", "QSZ-92 mastery", "mastery", "tfa_ins2_qsz92"}
cardArray[175] = {"cards/mastery/remingtonm870.png", "Code", "Remington M870 master", "mastery", "tfa_ins2_remington_m870"}
cardArray[176] = {"cards/mastery/remingtonmsr.png", "Lightshow", "Remington MSR mastery", "mastery", "tfa_ins2_pd2_remington_msr"}
cardArray[177] = {"cards/mastery/rfb.png", "Extraction", "RFB mastery", "mastery", "tfa_ins2_rfb"}
cardArray[178] = {"cards/mastery/rpg7.png", "Damascus", "RPG-7 mastery", "mastery", "tfa_ins2_rpg7_scoped"}
cardArray[179] = {"cards/mastery/rpk74m.png", "Elcan", "RPK-74M mastery", "mastery", "tfa_ins2_rpk_74m"}
cardArray[180] = {"cards/mastery/sw500.png", "Companion", "S&W 500 mastery", "mastery", "tfa_ins2_s&w_500"}
cardArray[181] = {"cards/mastery/sawedoff.png", "Halves", "Sawed Off mastery", "mastery", "tfa_ins2_izh43sw"}
cardArray[182] = {"cards/mastery/scarh.png", "Tilted", "SCAR-H mastery", "mastery", "tfa_ins2_scar_h_ssr"}
cardArray[183] = {"cards/mastery/scorpionevo.png", "Raid", "Scorpion Evo mastery", "mastery", "tfa_ins2_sc_evo"}
cardArray[184] = {"cards/mastery/skorpion.png", "Black Hole", "Skorpion mastery", "mastery", "tfa_l4d2_skorpion"}
cardArray[185] = {"cards/mastery/sks.png", "Scav", "SKS mastery", "mastery", "tfa_ins2_sks"}
cardArray[186] = {"cards/mastery/spas.png", "12 Gauge", "SPAS-12 mastery", "mastery", "tfa_ins2_spas12"}
cardArray[187] = {"cards/mastery/spectrem4.png", "Mall", "Spectre M4 mastery", "mastery", "tfa_ins2_spectre"}
cardArray[188] = {"cards/mastery/spikex1s.png", "Prototype", "Spike X1S mastery", "mastery", "tfa_ins2_saiga_spike"}
cardArray[189] = {"cards/mastery/sr2m.png", "Blueprint", "SR-2M mastery", "mastery", "tfa_ins2_sr2m_veresk"}
cardArray[190] = {"cards/mastery/sten.png", "Lens Flare", "Sten mastery", "mastery", "tfa_doisten"}
cardArray[191] = {"cards/mastery/stevens620.png", "Mod", "Stevens 620 mastery", "mastery", "tfa_nam_stevens620"}
cardArray[192] = {"cards/mastery/stg44.png", "Wood", "StG 44 mastery", "mastery", "tfa_doistg44"}
cardArray[193] = {"cards/mastery/sv98.png", "Vertigo", "SV-98 mastery", "mastery", "tfa_ins2_sv98"}
cardArray[194] = {"cards/mastery/t5000.png", "Reserve", "T-5000 mastery", "mastery", "tfa_ins2_warface_orsis_t5000"}
cardArray[195] = {"cards/mastery/tanto.png", "Shipment", "Tanto mastery", "mastery", "tfa_japanese_exclusive_tanto"}
cardArray[196] = {"cards/mastery/tariq.png", "Dog", "Tariq mastery", "mastery", "tfa_ins_sandstorm_tariq"}
cardArray[197] = {"cards/mastery/thompsonm1928.png", "Typewritter", "Thompson M1928 master", "mastery", "tfa_doithompsonm1928"}
cardArray[198] = {"cards/mastery/thompson.png", "Depression", "Thompson M1A1 master", "mastery", "tfa_doithompsonm1a1"}
cardArray[199] = {"cards/mastery/typhoonf12.png", "Ultrakill", "Typhoon F12 mastery", "mastery", "tfa_ins2_typhoon12"}
cardArray[200] = {"cards/mastery/ump.png", "Nuketown", "UMP mastery", "mastery", "tfa_ins2_ump45"}
cardArray[201] = {"cards/mastery/usp.png", "Strike", "USP mastery", "mastery", "tfa_ins2_usp_match"}
cardArray[202] = {"cards/mastery/uzi.png", "Alpha", "Uzi mastery", "mastery", "tfa_ins2_imi_uzi"}
cardArray[203] = {"cards/mastery/vhsd2.png", "Liminal", "VHS-D2 mastery", "mastery", "tfa_ins2_vhsd2"}
cardArray[204] = {"cards/mastery/waltherp99.png", "Advisory", "Walther P99 mastery", "mastery", "tfa_ins2_walther_p99"}
cardArray[205] = {"cards/mastery/webley.png", "Bear", "Webley mastery", "mastery", "tfa_doi_webley"}
cardArray[206] = {"cards/mastery/xm8.png", "Ragdoll", "XM8 mastery", "mastery", "tfa_ins2_xm8"}
cardArray[207] = {"cards/leveling/5.png", "Mist", "Prestige 0 Level 5", "level", 5}
cardArray[208] = {"cards/leveling/10.png", "Tech", "Prestige 0 Level 10", "level", 10}
cardArray[209] = {"cards/leveling/15.png", "Processing", "Prestige 0 Level 15", "level", 15}
cardArray[210] = {"cards/leveling/20.png", "Monolith", "Prestige 0 Level 20", "level", 20}
cardArray[211] = {"cards/leveling/25.png", "Kitty", "Prestige 0 Level 25", "level", 25}
cardArray[212] = {"cards/leveling/30.png", "Tonal", "Prestige 0 Level 30", "level", 30}
cardArray[213] = {"cards/leveling/35.png", "Gangster", "Prestige 0 Level 35", "level", 35}
cardArray[214] = {"cards/leveling/40.png", "Shark", "Prestige 0 Level 40", "level", 40}
cardArray[215] = {"cards/leveling/45.png", "Bath", "Prestige 0 Level 45", "level", 45}
cardArray[216] = {"cards/leveling/50.png", "Rig", "Prestige 0 Level 50", "level", 50}
cardArray[217] = {"cards/leveling/55.png", "Station", "Prestige 0 Level 55", "level", 55}
cardArray[218] = {"cards/leveling/60.png", "Scenic", "Prestige 0 Level 60", "level", 60}
cardArray[219] = {"cards/leveling/65.png", "Dunes", "Prestige 1 Level 5", "level", 65}
cardArray[220] = {"cards/leveling/70.png", "Pyro", "Prestige 1 Level 10", "level", 70}
cardArray[221] = {"cards/leveling/75.png", "Toxicity", "Prestige 1 Level 15", "level", 75}
cardArray[222] = {"cards/leveling/80.png", "Drainer", "Prestige 1 Level 20", "level", 80}
cardArray[223] = {"cards/leveling/85.png", "Aquarium", "Prestige 1 Level 25", "level", 85}
cardArray[224] = {"cards/leveling/90.png", "Drive", "Prestige 1 Level 30", "level", 90}
cardArray[225] = {"cards/leveling/95.png", "Nightfall", "Prestige 1 Level 35", "level", 95}
cardArray[226] = {"cards/leveling/100.png", "Thunder", "Prestige 1 Level 40", "level", 100}
cardArray[227] = {"cards/leveling/105.png", "Shift", "Prestige 1 Level 45", "level", 105}
cardArray[228] = {"cards/leveling/110.png", "Horizon", "Prestige 1 Level 50", "level", 110}
cardArray[229] = {"cards/leveling/115.png", "Summit", "Prestige 1 Level 55", "level", 115}
cardArray[230] = {"cards/leveling/120.png", "Illusion", "Prestige 1 Level 60", "level", 120}
cardArray[231] = {"cards/leveling/125.png", "Stare", "Prestige 2 Level 5", "level", 125}
cardArray[232] = {"cards/leveling/130.png", "Death", "Prestige 2 Level 10", "level", 130}
cardArray[233] = {"cards/leveling/135.png", "Man", "Prestige 2 Level 15", "level", 135}
cardArray[234] = {"cards/leveling/140.png", "Depths", "Prestige 2 Level 20", "level", 140}
cardArray[235] = {"cards/leveling/145.png", "Irony", "Prestige 2 Level 25", "level", 145}
cardArray[236] = {"cards/leveling/150.png", "Grass", "Prestige 2 Level 30", "level", 150}
cardArray[237] = {"cards/leveling/155.png", "Scott Up", "Prestige 2 Level 35", "level", 155}
cardArray[238] = {"cards/leveling/160.png", "Buzzkilled", "Prestige 2 Level 40", "level", 160}
cardArray[239] = {"cards/leveling/165.png", "Fumos", "Prestige 2 Level 45", "level", 165}
cardArray[240] = {"cards/leveling/170.png", "The Voices", "Prestige 2 Level 50", "level", 170}
cardArray[241] = {"cards/leveling/175.png", "Crisis", "Prestige 2 Level 55", "level", 175}
cardArray[242] = {"cards/leveling/180.png", "CRT", "Prestige 2 Level 60", "level", 180}
cardArray[243] = {"cards/leveling/185.png", "Operative", "Prestige 3 Level 5", "level", 185}
cardArray[244] = {"cards/leveling/190.png", "Cool Skull", "Prestige 3 Level 10", "level", 190}
cardArray[245] = {"cards/leveling/195.png", "Breakcore", "Prestige 3 Level 15", "level", 195}
cardArray[246] = {"cards/leveling/200.png", "Dr. Han", "Prestige 3 Level 20", "level", 200}
cardArray[247] = {"cards/leveling/205.png", "Waves", "Prestige 3 Level 25", "level", 205}
cardArray[248] = {"cards/leveling/210.png", "Universe", "Prestige 3 Level 30", "level", 210}
cardArray[249] = {"cards/leveling/215.png", "Invasion", "Prestige 3 Level 35", "level", 215}
cardArray[250] = {"cards/leveling/220.png", "Airship", "Prestige 3 Level 40", "level", 220}
cardArray[251] = {"cards/leveling/225.png", "Darkness", "Prestige 3 Level 45", "level", 225}
cardArray[252] = {"cards/leveling/230.png", "Arctic", "Prestige 3 Level 50", "level", 230}
cardArray[253] = {"cards/leveling/235.png", "Modern", "Prestige 3 Level 55", "level", 235}
cardArray[254] = {"cards/leveling/240.png", "Childhood", "Prestige 3 Level 60", "level", 240}
cardArray[255] = {"cards/pride/pride.png", "Pride", "<3", "pride", "pride"}
cardArray[256] = {"cards/pride/bi.png", "Bi", "<3", "pride", "pride"}
cardArray[257] = {"cards/pride/pan.png", "Pan", "<3", "pride", "pride"}
cardArray[258] = {"cards/pride/gay.png", "Gay", "<3", "pride", "pride"}
cardArray[259] = {"cards/pride/lesbian.png", "Lesbian", "<3", "pride", "pride"}
cardArray[260] = {"cards/pride/ace.png", "Ace", "<3", "pride", "pride"}
cardArray[261] = {"cards/pride/trans.png", "Trans", "<3", "pride", "pride"}
cardArray[262] = {"cards/pride/genderfluid.png", "Gen. Fluid", "<3", "pride", "pride"}
cardArray[263] = {"cards/pride/genderqueer.png", "Gen. Queer", "<3", "pride", "pride"}
cardArray[264] = {"cards/pride/nonbinary.png", "Nonbinary", "<3", "pride", "pride"}
cardArray[265] = {"cards/pride/agender.png", "Agender", "<3", "pride", "pride"}
cardArray[266] = {"cards/pride/zedo.png", "Zedo", "", "pride", "pride"}

-- creating a leveling array, this removes the consistency of the leveling, using set XP requierments per level instead of a formula
-- is this time consuming? yes, very much so, but its better trust me bro!
levelArray = {}
levelArray[1] = 750 -- +75 XP
levelArray[2] = 825
levelArray[3] = 900
levelArray[4] = 975
levelArray[5] = 1050
levelArray[6] = 1125
levelArray[7] = 1200
levelArray[8] = 1275
levelArray[9] = 1350
levelArray[10] = 1450 -- +100 XP
levelArray[11] = 1550
levelArray[12] = 1650
levelArray[13] = 1750
levelArray[14] = 1850
levelArray[15] = 1950
levelArray[16] = 2050
levelArray[17] = 2150
levelArray[18] = 2250
levelArray[19] = 2350
levelArray[20] = 2475 -- +125 XP
levelArray[21] = 2600
levelArray[22] = 2725
levelArray[23] = 2850
levelArray[24] = 2975
levelArray[25] = 3100
levelArray[26] = 3225
levelArray[27] = 3350
levelArray[28] = 3475
levelArray[29] = 3600
levelArray[30] = 3750 -- +150 XP
levelArray[31] = 3900
levelArray[32] = 4050
levelArray[33] = 4200
levelArray[34] = 4350
levelArray[35] = 4500
levelArray[36] = 4650
levelArray[37] = 4800
levelArray[38] = 4950
levelArray[39] = 5100
levelArray[40] = 5275 -- +175 XP
levelArray[41] = 5450
levelArray[42] = 5625
levelArray[43] = 5800
levelArray[44] = 5975
levelArray[45] = 6150
levelArray[46] = 6325
levelArray[47] = 6500
levelArray[48] = 6675
levelArray[49] = 6850
levelArray[50] = 7050 -- +200 XP
levelArray[51] = 7250
levelArray[52] = 7450
levelArray[53] = 7650
levelArray[54] = 7850
levelArray[55] = 8050
levelArray[56] = 8250
levelArray[57] = 8450
levelArray[58] = 8650
levelArray[59] = 8850
levelArray[60] = "prestige"

hintArray = {"Winning the match nets you bonus XP", "Suppressors might make your gun sound badass, but it will also lower your damage", "Be vigilant with the acidic flood while playing on the Mephitic map", "Follow CaptainBear on the Steam Workshop", "Switching to your secondary is 'usually' faster than reloading", "To win a match, a player must have more score than the rest of the competing players", "Voice chat is proximity based, do with this information as you see fit", "Slug ammunition turns your traditional shotgun into a marksman rifle", "Try personalizing yourself in the cuztomization menus", "Crouching completely eliminates your footstep audio, embrace the sneaky", "You can cycle through firing modes by using your Interact + Reload keys", "All melee weapons can be thrown with the reload key", "Air strafing is extremely useful, try to incorperate it into your playstyle", "Frag ammunition deafens hit players for a few seconds, and slows down their movement speed", "Explosive barrels can be used as a funny distraction", "Players can not shoot most weapons while submerged in water, use this to your advantage", "Almost everything you do in game is tracked, check out the stats page to compare yourself with others", "The grappling hook can easily be used to start favorable engagments", "Jumping and/or being in mid air gives your weapons less accuracy", "Sliding provides the same accuracy and recoil benefits as crouching", "Chaining multiple accolades together can give a big score/XP boost", "Accolades grant good amounts of score and XP", "Running any optic lowers your weapons ADS speed", "There are over 130+ weapons, try to get consistent with many different loadouts", "There is no scope glint, hardscope all you want", "Hip fire is an effective strategy while on the move", "Other players can see your flashlight, be cautious", "Certain playermodels may shine or stand out in dark enviroments", "Combine wall running and jumping for extremely unpredictable movement", "Wall running through a chokepoint can catch opponents off guard", "Wall jumping constantly allows for continuous climbing of said wall", "All melee weapons have a left and right click attack, learn how effective each are", "Attachments save throughout play sessions, tweak your guns once and you are done", "Some snipers and hand cannons can one shot to the torso", "Explosives hurt, don't aim downwards if you want to stay alive", "Crouching drastically increases your accuracy and recoil control", "Each weapon has its own distinct recoil pattern to master", "Your grappling hook cooldown refreshes on each kill", "Shooting the torso and/or head will guarintee good damage per shot", "You can sprint and/or slide in any direction, not just forwards", "Don't stand still, potshotters will have an easy time killing you", "The vehicles can be mounted and surfed on while playing the Bridge map", "Bunny hopping will help perserve velocity after landing from a grapple/slide"}
quoteArray = {'"thank you for playing my gamemode <3" -Penial', '"a jeep wrangler is less aerodynamic than a lobster" -P0w', '"meow" -Megu', '"my grandma drowned, drowned in drip" -RandomSZ', '"skill issue" -Strike Force Lightning', '"told my wife im going to the bank, didnt tell her which one" -stiel', '"go lick a gas pump" -Bomca', '"justice for cradle, we the people demand" -RandomSZ', '"women fear me, fish want me" -Tomato', '"gang where are you, blud where are you" -White Guy', '"any kief slayers" -Cream', '"if i was a tree, i would have no reason to love a human" -suomij', '"i wish someone wanted me like plankton wanted the formula" -Seven', '"but your honor, babies kick pregnant women all the time" -MegaSlayer', '"by the nine im tweakin" -MegaSlayer', '"ball torture is $4 usd on steam" -Portanator', '"your walls are never safe from the drywall muncher" -Vertex', '"im obviously not racist, ive kissed a black man" -Mattimeo', '"my balls are made of one thing..." -RubberBalls', '"im like that" -Homeless', '"i need about tree fiddy" -Random Films', '"bring out the whole ocean" -Robo', '"can we ban this guy" -Poopy', '"root beer" -Plat', '"never forget 9/11" -afiais', '"praise o monolith" -Medinator', '"why is he there" -Smity', '"shut it mate yer da sells avon" -zee!', '"holy fishpaste" -Zenthic', '"titanmod servers are as stable as a girl with blue hair" -TheBean', '"titanmod is my favorite tactical shooter" -Computery'}

if GetConVar("tm_developermode"):GetInt() == 1 then DeriveGamemode("sandbox") end