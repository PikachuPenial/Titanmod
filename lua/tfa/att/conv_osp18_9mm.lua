
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "9mm"
ATTACHMENT.ShortName = "9mm" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "9mm Conversion",
	TFA.AttachmentColors["-"], "30% less recoil",
	TFA.AttachmentColors["-"], "15% less damage",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.85 end,
		["RPM"] = function(wep, stat) return 600 end,
		["KickUp"] = function( wep, stat ) return stat * 0.7 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 0.7 end,
		["KickDown"] = function( wep, stat ) return stat * 0.7 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_L4D2.OSP18.1.CONV") end,
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
