player_manager.AddValidModel( "Astolfo", 				"models/CyanBlue/Fate/Astolfo/Astolfo.mdl" )
player_manager.AddValidHands( "Astolfo", "models/CyanBlue/Fate/Astolfo/c_arms/Astolfo_mesh3.mdl", 0, "00000000" )
list.Set( "PlayerOptionsModel",  "Astolfo",				"models/CyanBlue/Fate/Astolfo/Astolfo.mdl" )

--Add NPC
local NPC =
{
	Name = "(Fate/Apocrypha - Astolfo (v1)",
	Class = "npc_citizen",
	KeyValues = { citizentype = 4 },
	Model = "models/CyanBlue/Fate/Astolfo/npc/Astolfo.mdl",
	Category = "Fate/Apocrypha"
}

list.Set( "NPC", "npc_CB_astolfo", NPC )
