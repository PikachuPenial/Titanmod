--This is only here to help me test kills easier, will be removed when no-longer needed.
function TestKillNoti(ply, cmd, args)
    net.Start("NotifyKill")
    net.WriteEntity(ply)
    net.Send(ply)
end
concommand.Add("testkill", TestKillNoti)

--This is only here to help me test deaths easier, will be removed when no-longer needed.
function TestDeathNoti(ply, cmd, args)
	net.Start("DeathHud")
	net.WriteEntity(ply)
	net.WriteString("the rope")
	net.WriteFloat(100)
	net.Send(ply)
end
concommand.Add("testdeath", TestDeathNoti)

--Allows the player to save their local stats to the sv.db file without having to leave the server.
function ForceSave(ply, cmd, args)
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerScore", ply:GetNWInt("playerScore"))
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))
end
concommand.Add("tm_forcesave", ForceSave)

--Allows the Main Menu to change the players current playermodel.
function PlayerModelChange(ply, cmd, args)
	local modelList = {}
    modelList[1] = {"models/player/Group03/male_02.mdl", "Male", "The default male character.", "default", "default"}
    modelList[2] = {"models/player/Group03/female_02.mdl", "Female", "The default female character.", "default", "default"}
    modelList[3] = {"models/player/Group01/male_03.mdl", "Casual Male", "Why so serious?", "default", "default"}
    modelList[4] = {"models/player/mossman.mdl", "Casual Female", "Why so serious?", "default", "default"}
    modelList[5] = {"models/player/Group03m/male_05.mdl", "Doctor", "I need a medic bag.", "default", "default"}
    modelList[6] = {"models/player/Group03m/female_06.mdl", "Nurse", "I need a medic bag.", "default", "default"}
    modelList[7] = {"models/player/barney.mdl", "Barney", "Not purple this time.", "default", "default"}
    modelList[8] = {"models/player/breen.mdl", "Breen", "i couldn't think of anything", "default", "default"}
    modelList[9] = {"models/player/kleiner.mdl", "Kleiner", "But in the end.", "default", "default"}
    modelList[10] = {"models/player/Group01/male_07.mdl", "Male 07", "The one, the only.", "kills", 100}
    modelList[11] = {"models/player/alyx.mdl", "Alyx", "ughhhhhhhhh.", "kills", 300}
    modelList[12] = {"models/player/hostage/hostage_04.mdl", "Scientist", "Bill Nye.", "kills", 500}
    modelList[13] = {"models/player/gman_high.mdl", "GMan", "Where is 3?", "kills", 1000}
    modelList[14] = {"models/player/p2_chell.mdl", "Chell", "Funny portal reference.", "kills", 2000}
    modelList[15] = {"models/player/leet.mdl", "Badass", "So cool.", "kills", 3000}
    modelList[16] = {"models/player/arctic.mdl", "Arctic", "I don't think it's cold in here.", "streak", 5}
    modelList[17] = {"models/player/riot.mdl", "Riot", "Tanto Addict.", "streak", 10}
    modelList[18] = {"models/player/gasmask.mdl", "Hazmat Suit", "This isn't Rust.", "streak", 15}
    modelList[19] = {"models/player/police.mdl", "Officer", "Pick up the can.", "streak", 20}
    modelList[20] = {"models/player/combine_soldier_prisonguard.mdl", "Cobalt Soilder", "No green card?", "streak", 25}
    modelList[21] = {"models/walterwhite/playermodels/walterwhitechem.mdl", "Drug Dealer", "waltuh.", "streak", 30}
    modelList[22] = {"models/cyanblue/fate/astolfo/astolfo.mdl", "Astolfo", "I was forced to do this.", "special", "name"}

	for k, v in pairs(modelList) do
		if (args[1] == v[1]) then

			local modelID = v[1]
			local modelUnlock = v[4]
			local modelValue = v[5]

			if modelUnlock == "default" then
				ply:SetNWInt("chosenPlayermodel", modelID)
			end

			if modelUnlock == "kills" and ply:GetNWInt("playerKills") >= modelValue then
				ply:SetNWInt("chosenPlayermodel", modelID)
			end

			if modelUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= modelValue then
				ply:SetNWInt("chosenPlayermodel", modelID)
			end

			if modelUnlock == "special" and ply:SteamID() == "STEAM_0:1:514443768" then
				ply:SetNWInt("chosenPlayermodel", modelID)
			end
		end
	end
end
concommand.Add("tm_selectplayermodel", PlayerModelChange)