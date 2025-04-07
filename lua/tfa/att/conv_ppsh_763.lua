
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "7.63"
ATTACHMENT.ShortName = "7.63" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "7.63x25mm Mauser Conversion",
	TFA.AttachmentColors["+"], "75% less recoil",
	TFA.AttachmentColors["+"], "50% less spread",
	TFA.AttachmentColors["-"], "20% less damage",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.8 end,
		["Spread"] = function(wep, stat) return stat * 0.5 end,
		["KickUp"] = function( wep, stat ) return stat * 0.25 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 0.25 end,
		["KickDown"] = function( wep, stat ) return stat * 0.25 end,
		["Sound"] = function( wep, stat ) return Sound("weapons/tfa_ppsh41/mp5k_fp_conv2.wav") end,
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end