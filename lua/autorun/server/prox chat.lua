CreateConVar("sv_maxVoiceAudible",1500,FCVAR_ARCHIVE,"Maximum distance for listener to still be able to hear the talker.")
CreateConVar("sv_proxChatEnable",1,FCVAR_ARCHIVE,"Enables/disables proximity chat.")

hook.Add("PlayerCanHearPlayersVoice","Maximum Range",function(listener,talker)
	if (tonumber( listener:GetPos():Distance( talker:GetPos() ) ) > tonumber( GetConVar("sv_maxVoiceAudible"):GetInt()) and tonumber(GetConVar("sv_proxChatEnable"):GetInt()) == 1) then 
		return false, false
	else 
		return true, true
	end

end )

