if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Tactical Point Shooting"
ATTACHMENT.ShortName   = "TPS"

ATTACHMENT.Icon        = "entities/tfa_tactical_point_shooting.png"

ATTACHMENT.Description = { 
    TFA.AttachmentColors["+"], "Better visibility for combat in close quarters.",
    TFA.AttachmentColors["+"], "Decrease aiming time.",
    TFA.AttachmentColors["+"], "Improves aiming mobility.",
    TFA.AttachmentColors["-"], "Ineffective for precision shooting.",  
    TFA.AttachmentColors["="], "Needs an laser sight attachment to be effective.",  
}

ATTACHMENT.WeaponTable = {
	["IronSightsPos"] = function( wep, val ) return wep.IronSightsPos_Point_Shooting or val end,
	["IronSightsAng"] = function( wep, val ) return wep.IronSightsAng_Point_Shooting or val end,
	["IronSightsPos_Kobra"] = function( wep, val ) return wep.IronSightsPos_Point_Shooting or val end,
	["IronSightsAng_Kobra"] = function( wep, val ) return wep.IronSightsAng_Point_Shooting or val end,
	["IronSightsPos_RDS"] = function( wep, val ) return wep.IronSightsPos_Point_Shooting or val end,
	["IronSightsAng_RDS"] = function( wep, val ) return wep.IronSightsAng_Point_Shooting or val end,
	["IronSightsPos_EOTech"] = function( wep, val ) return wep.IronSightsPos_Point_Shooting or val end,
	["IronSightsAng_EOTech"] = function( wep, val ) return wep.IronSightsAng_Point_Shooting or val end,
	["IronSightsPos_2XRDS"] = function( wep, val ) return wep.IronSightsPos_Point_Shooting or val end,
	["IronSightsAng_2XRDS"] = function( wep, val ) return wep.IronSightsAng_Point_Shooting or val end,
	["IronSightsPos_C79"] = function( wep, val ) return wep.IronSightsPos_Point_Shooting or val end,
	["IronSightsAng_C79"] = function( wep, val ) return wep.IronSightsAng_Point_Shooting or val end,
	["IronSightsPos_PO4X"] = function( wep, val ) return wep.IronSightsPos_Point_Shooting or val end,
	["IronSightsAng_PO4X"] = function( wep, val ) return wep.IronSightsAng_Point_Shooting or val end,
	["IronSightsPos_MX4"] = function( wep, val ) return wep.IronSightsPos_Point_Shooting or val end,
	["IronSightsAng_MX4"] = function( wep, val ) return wep.IronSightsAng_Point_Shooting or val end,
							
	["Secondary"] = {
		["IronFOV"] = function( wep, val ) return wep.Secondary.Point_Shooting_FOV or val * 0.65 end,
	},
	
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 1.1 end,
	["IronSightTime"] = function(wep, val) return val * 0.75 end,
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end