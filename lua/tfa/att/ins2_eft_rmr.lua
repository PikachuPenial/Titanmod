if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Trijicon RMR"
ATTACHMENT.ShortName   = "RMR"

ATTACHMENT.Icon        = "entities/eft_rmr.png" 

ATTACHMENT.Description = { 
    TFA.AttachmentColors["+"], "5% Higher zoom", 
    TFA.AttachmentColors["-"], "7.5% Higher zoom time", 
}

ATTACHMENT.WeaponTable = {

	["VElements"] = {
		["rail_sights"] = {
			["active"] = true
		},
		["sight_rmr"] = {
			["active"] = true
		},
		["sights_folded"] = {
			["active"] = false
		},
		["sight_rmr_lens"] = {
			["active"] = true
		}
	},
	
	["WElements"] = {
		["rail_sights"] = {
			["active"] = true
		},
		["sight_rmr"] = {
			["active"] = true
		},
		["sights_folded"] = {
			["active"] = false
		},
		["sight_rmr_lens"] = {
			["active"] = true
		}
	},
	
	["IronSightsPos"] = function( wep, val ) return wep.IronSightsPos_RMR or val end,
	["IronSightsAng"] = function( wep, val ) return wep.IronSightsAng_RMR or val end,
	["IronSightTime"] = function( wep, val ) return val * 1.075 end,
	
	["EFT_SightVElement"] = "sight_rmr",
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end