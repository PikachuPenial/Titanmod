VMAnipFlashlight_Serv_CanputonShoulder = CreateConVar( "sv_VMANIPFlash_canAttachShoulder", "1", { FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_DONTRECORD, FCVAR_SERVER_CAN_EXECUTE }, "Toggles spawing with the flashlight." )
VMAnipFlashlight_Serv_UseOnlyShoulder = CreateConVar( "sv_VMANIPFlashlight_isOnlyUsingShoulder", "0", { FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_DONTRECORD, FCVAR_SERVER_CAN_EXECUTE }, "Toggles spawing with the flashlight." )
CreateClientConVar( "cl_VMANIPFlash_texture", "effects/VMAnip_Flashlight", true, true, "Path to flashlight texture, set in the options menu." )

-- Since people have had trouble with stuck flashlight spots
-- and I've failed to eliminate the problem so far, I'm adding
-- this as a temporary workaround.
if (CLIENT) then
local function LightOptions( CPanel )
    CPanel:AddControl( "Header", { Description = "Server Settings:" }  )
	CPanel:AddControl( "Checkbox", { Label = "Can players attach their flashlight to shoulder?", Command = "sv_VMANIPFlash_canAttachShoulder" } )
	CPanel:AddControl( "Checkbox", { Label = "Use ONLY shoulder flashlight?", Command = "sv_VMANIPFlashlight_isOnlyUsingShoulder" } )
	CPanel:AddControl( "Header", { Description = "     (aka Vanilla flashlight but with animation)" }  )
	CPanel:AddControl( "Header", { Description = "     Use this to attach flashlight to shoulder:" }  )
	CPanel:AddControl( "Header", { Description = "     bind t putFlashlightOnShoulder" }  )
	CPanel:AddControl( "Header", { Description = "Client Settings:" }  )
	CPanel:AddControl( "Header", { Description = "Select flashlight texture from those below. If you want to use your custom one - select *Default/User changed*" }  )
	local MatSelect = CPanel:MatSelect( "cl_VMANIPFlash_texture", nil, true, 0.33, 0.33 )
	for k, v in pairs( list.Get( "FlashlightTextures" ) ) do
		MatSelect:AddMaterial( v.Name or k, k )
	end
end
hook.Add( "PopulateToolMenu", "AddFLMenu", function()
	spawnmenu.AddToolMenuOption( "Options", "VM Anip Flashlight", "VMANIPFlashlightSettings", "Settings", "", "", LightOptions )
end )
end

list.Set( "FlashlightTextures", "effects/VMAnip_Flashlight", { Name = "VMAnip default LED" } )
list.Set( "FlashlightTextures", "effects/flashlight001", { Name = "Default/User changed" } )
list.Set( "FlashlightTextures", "effects/VMAnip_Flashlight_L4D2", { Name = "Left 4 Dead 2" } )
list.Set( "FlashlightTextures", "effects/VMAnip_Flashlight_CSGO", { Name = "CS:GO" } )
list.Set( "FlashlightTextures", "effects/VMAnip_Flashlight_DearEaster", { Name = "Dear Easter" } )
list.Set( "FlashlightTextures", "effects/VMAnip_Flashlight_Bonework", { Name = "Bonework" } )