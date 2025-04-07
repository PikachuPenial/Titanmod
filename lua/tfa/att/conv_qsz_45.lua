
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".45 ACP"
ATTACHMENT.ShortName = ".45" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".45 ACP Conversion",
	TFA.AttachmentColors["+"], "25% more damage",
	TFA.AttachmentColors["-"], "125% more vertical recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 1.25 end,
		["KickUp"] = function( wep, stat ) return stat * 2.25 end,
		["KickDown"] = function( wep, stat ) return stat * 2.25 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 2.25 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.QSZ92.1.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.QSZ92.2.CONV") end
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end