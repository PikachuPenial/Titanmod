if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Salvo 12G Suppressor"
ATTACHMENT.ShortName   = "Salvo12"

ATTACHMENT.Icon        = "entities/eft_osprey.png"

ATTACHMENT.Description = { 
    TFA.AttachmentColors["+"], "Less firing noise", 
    TFA.AttachmentColors["+"], "Looks very cool", 
    TFA.AttachmentColors["+"], "25% Less vertical recoil",
    TFA.AttachmentColors["+"], "10% Less spread", 
    TFA.AttachmentColors["-"], "10% Lower zoom time",  
    TFA.AttachmentColors["-"], "10% Higher weight",  
}

ATTACHMENT.WeaponTable = {

	["VElements"] = {
		["suppressor_salvo12g"] = {
			["active"] = true
		},
		["standard_barrel"] = {
			["active"] = false
		}
	},
	
	["WElements"] = {
		["suppressor"] = {
			["active"] = true
		},
		["standard_barrel"] = {
			["active"] = false
		}
	},
	
	["Primary"] = {
		["KickUp"] = function(wep,stat) return stat * 0.75 end,
		["KickDown"] = function(wep,stat) return stat * 0.75 end,
		["Spread"] = function(wep,stat) return stat * 0.9 end,
		["IronAccuracy"] = function(wep,stat) return stat * 0.85 end,
		["Sound"] = function(wep,stat) return wep.Primary.SilencedSound or stat end
	},
	
	["MuzzleFlashEffect"] = "tfa_muzzleflash_silenced",
	["MuzzleAttachmentMod"] = function(wep,stat) return wep.MuzzleAttachmentSilenced or stat end,
	["Silenced"] = true,

	["MoveSpeed"] = function( wep, stat ) return stat * 0.90 end,
	["IronSightsMoveSpeed"] = function( wep, stat ) return stat * 0.90 end,
	["IronSightTime"] = function( wep, val ) return val * 1.1 end,
}

function ATTACHMENT:Attach(wep)
	wep.Silenced = true
	wep:SetSilenced(wep.Silenced)
end

function ATTACHMENT:Detach(wep)
	wep.Silenced = false
	wep:SetSilenced(wep.Silenced)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end