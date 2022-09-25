// hi penial :skull:

util.AddNetworkString( "NotifyKill" ) // the name of the message

// if you don't know how hooks work, the "PlayerDeath" is the name of the hook that is added, "KillNotification" is the custom name created by me, and the function just declares as variables what the "PlayerDeath" hook returns

hook.Add("PlayerDeath", "KillNotification", function(victim, inflictor, attacker)

    net.Start( "NotifyKill" ) // Starting the message (goes first to initialize it)
    net.WriteString("this the string") // Contents of the message, is read clientside using net.ReadString(), can have multiple WriteShits
    net.Send(victim) // Sends it to ply (in this case the victim of the murder)

end)