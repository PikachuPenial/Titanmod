if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "AAC Illusion Silencer"
ATTACHMENT.ShortName   = "AAC"

ATTACHMENT.Icon        = "entities/eft_aac.png" 

ATTACHMENT.Description = { 
    TFA.AttachmentColors["+"], "Less firing noise", 
    TFA.AttachmentColors["+"], "15% Less spread", 
    TFA.AttachmentColors["+"], "15% Less vertical recoil" ,
    TFA.AttachmentColors["-"], "8% Less damage",
}

ATTACHMENT.WeaponTable = {

	["VElements"] = {
		["suppressor_aac"] = {
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
		["Damage"] = function(wep,stat) return stat * 0.95 end,
		["KickUp"] = function(wep,stat) return stat * 0.85 end,
		["KickDown"] = function(wep,stat) return stat * 0.85 end,
		["Spread"] = function(wep,stat) return stat * 0.85 end,
		["IronAccuracy"] = function(wep,stat) return stat * 0.85 end,
		["Sound"] = function(wep,stat) return wep.Primary.SilencedSound or stat end
	},
	
	["MuzzleFlashEffect"] = "tfa_muzzleflash_silenced",
	["MuzzleAttachmentMod"] = function(wep,stat) return wep.MuzzleAttachmentSilenced or stat end,
	["Silenced"] = true,
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