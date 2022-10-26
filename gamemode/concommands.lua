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
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	--Statistics
	ply:SetPData("playerKills", ply:GetNWInt("playerKills"))
	ply:SetPData("playerDeaths", ply:GetNWInt("playerDeaths"))
	ply:SetPData("playerKDR", ply:GetNWInt("playerKDR"))
	ply:SetPData("playerScore", ply:GetNWInt("playerScore"))

	--Streaks
	ply:SetPData("highestKillStreak", ply:GetNWInt("highestKillStreak"))

	--Customizatoin
	ply:SetPData("chosenPlayermodel", ply:GetNWString("chosenPlayermodel"))
	ply:SetPData("chosenPlayercard", ply:GetNWString("chosenPlayermodel"))

	--Accolades
	ply:SetPData("playerAccoladeOnStreak", ply:GetNWInt("playerAccoladeOnStreak"))
	ply:SetPData("playerAccoladeBuzzkill", ply:GetNWInt("playerAccoladeBuzzkill"))
	ply:SetPData("playerAccoladeLongshot", ply:GetNWInt("playerAccoladeLongshot"))
	ply:SetPData("playerAccoladePointblank", ply:GetNWInt("playerAccoladePointblank"))
	ply:SetPData("playerAccoladeSmackdown", ply:GetNWInt("playerAccoladeSmackdown"))
	ply:SetPData("playerAccoladeHeadshot", ply:GetNWInt("playerAccoladeHeadshot"))
	ply:SetPData("playerAccoladeClutch", ply:GetNWInt("playerAccoladeClutch"))

	print("Save was successful!")
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

--Allows the Main Menu to change the players current playercard.
function PlayercardChange(ply, cmd, args)
    local cardList = {}
    cardList[1] = {"cards/default/barrels.png", "Barrels", "kaboom.", "default", "default"}
    cardList[2] = {"cards/default/construct.png", "Construct", "A classic.", "default", "default"}
    cardList[3] = {"cards/default/grapple.png", "Grapple Hook", "360 no scope.", "default", "default"}
    cardList[4] = {"cards/default/industry.png", "Industry", "To dupe, or not to dupe.", "default", "default"}
    cardList[5] = {"cards/default/overhead.png", "Overhead", "Trees.", "default", "default"}
    cardList[6] = {"cards/default/specops.png", "Spec Ops", "NVG's and stuff.", "default", "default"}
    cardList[7] = {"cards/kills/pistoling.png", "Pistoling", "9x19 my beloved.", "kills", 300}
    cardList[8] = {"cards/kills/smoke.png", "Smoke", "Cool soilders doing things.", "kills", 1200}
    cardList[9] = {"cards/kills/titan.png", "Titan", "Titanfall 2 <3", "kills", 2500}
	cardList[10] = {"cards/kills/killstreak10.png", "Convoy", "helicoboptor.", "streak", 10}
    cardList[11] = {"cards/kills/killstreak20.png", "On Fire", "You did pretty well.", "streak", 20}
    cardList[12] = {"cards/kills/killstreak30.png", "Nuclear", "pumpkin eater.", "streak", 30}
	cardList[13] = {"cards/accolades/headshot_200.png", "Headshot You", "I headshot you.", "headshot", 200}
    cardList[14] = {"cards/accolades/headshot_750.png", "Headhunter", "S&W addict.", "headshot", 750}
    cardList[15] = {"cards/accolades/smackdown_50.png", "Karambit", "Movement players favorite.", "smackdown", 50}
	cardList[16] = {"cards/accolades/smackdown_150.png", "Samuri", "Fruit ninja enjoyer.", "smackdown", 150}
    cardList[17] = {"cards/accolades/clutch_40.png", "Desert Eagle", "crunch!", "clutch", 40}
    cardList[18] = {"cards/accolades/clutch_120.png", "Magnum", "even louder crunch!", "clutch", 120}
    cardList[19] = {"cards/accolades/longshot_80.png", "Down Sights", "Bipod down.", "longshot", 80}
    cardList[20] = {"cards/accolades/longshot_250.png", "Stalker", "buy awp bruv.", "longshot", 250}
    cardList[21] = {"cards/accolades/pointblank_125.png", "Showers", "Drip or drown BEAR.", "pointblank", 125}
    cardList[22] = {"cards/accolades/pointblank_450.png", "No Full Auto", "in buildings.", "pointblank", 450}
    cardList[23] = {"cards/accolades/killstreaks_80.png", "Soilder", "bang bang pow.", "killstreaks", 80}
    cardList[24] = {"cards/accolades/killstreaks_240.png", "Badass", "Never look back.", "killstreaks", 240}
    cardList[25] = {"cards/accolades/buzzkills_80.png", "Wobblers", "I. am. alive.", "buzzkills", 80}
    cardList[26] = {"cards/accolades/buzzkills_240.png", "Execution", "Bye bye.", "buzzkills", 240}

	for k, v in pairs(cardList) do
		if (args[1] == v[1]) then

			local cardID = v[1]
			local cardUnlock = v[4]
			local cardValue = v[5]

			if cardUnlock == "default" then
				ply:SetNWInt("chosenPlayercard", cardID)
			end

			if cardUnlock == "kills" and ply:GetNWInt("playerKills") >= cardValue then
				ply:SetNWInt("chosenPlayercard", cardID)
			end

			if cardUnlock == "streak" and ply:GetNWInt("highestKillStreak") >= cardValue then
				ply:SetNWInt("chosenPlayercard", cardID)
			end

			if cardUnlock == "headshot" and ply:GetNWInt("playerAccoladeHeadshot") >= cardValue then
				ply:SetNWInt("chosenPlayercard", cardID)
			end

			if cardUnlock == "smackdown" and ply:GetNWInt("playerAccoladeSmackdown") >= cardValue then
				ply:SetNWInt("chosenPlayercard", cardID)
			end

			if cardUnlock == "clutch" and ply:GetNWInt("playerAccoladeClutch") >= cardValue then
				ply:SetNWInt("chosenPlayercard", cardID)
			end

			if cardUnlock == "longshot" and ply:GetNWInt("playerAccoladeLongshot") >= cardValue then
				ply:SetNWInt("chosenPlayercard", cardID)
			end

			if cardUnlock == "pointblank" and ply:GetNWInt("playerAccoladePointblank") >= cardValue then
				ply:SetNWInt("chosenPlayercard", cardID)
			end

			if cardUnlock == "killstreaks" and ply:GetNWInt("playerAccoladeOnStreak") >= cardValue then
				ply:SetNWInt("chosenPlayercard", cardID)
			end

			if cardUnlock == "buzzkills" and ply:GetNWInt("playerAccoladeBuzzkill") >= cardValue then
				ply:SetNWInt("chosenPlayercard", cardID)
			end
		end
	end
end
concommand.Add("tm_selectplayercard", PlayercardChange)

--Allows the player to spectate other players or to free roam at will using this command, or from the spectate dropdown in the Main Menu.
function StartCustomSpectate(ply, cmd, args)
	if (args[1] == "free") then
		ply:UnSpectate()
		ply:Spectate(OBS_MODE_ROAMING)
		ply:SetNWBool("isSpectating", true)
	elseif (args[1] == "player") then
		ply:UnSpectate()
		ply:SpectateEntity(args[2])
		ply:Spectate(OBS_MODE_IN_EYE)
		ply:SetNWBool("isSpectating", true)
	end
end
concommand.Add("tm_spectate", StartCustomSpectate)