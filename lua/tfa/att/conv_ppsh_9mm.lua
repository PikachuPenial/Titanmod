
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "9mm"
ATTACHMENT.ShortName = "9mm" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "9mm Conversion",
	TFA.AttachmentColors["+"], "30% more RPM",
	TFA.AttachmentColors["-"], "35% less damage",
	TFA.AttachmentColors["-"], "150% more recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.65 end,
		["RPM"] = function(wep, stat) return 1250 end,
		["KickUp"] = function( wep, stat ) return stat * 2.5 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 2.5 end,
		["KickDown"] = function( wep, stat ) return stat * 2.5 end,
		["Sound"] = function( wep, stat ) return Sound("weapons/tfa_ppsh41/mp5k_fp_conv.wav") end,
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end