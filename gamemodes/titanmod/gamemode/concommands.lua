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
	net.WriteFloat(10)
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