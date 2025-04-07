
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "9x39"
ATTACHMENT.ShortName = "9x39" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "9x39mm Conversion",
	TFA.AttachmentColors["+"], "15% more damage",
	TFA.AttachmentColors["-"], "20% less RPM",
	TFA.AttachmentColors["-"], "80% more recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 1.15 end,
		["RPM"] = function(wep, stat) return 600 end,
		["KickUp"] = function( wep, stat ) return stat * 1.8 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 1.8 end,
		["KickDown"] = function( wep, stat ) return stat * 1.8 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.GROZA.1.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.GROZA.2.CONV") end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end