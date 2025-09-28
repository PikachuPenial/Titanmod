
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "7.62"
ATTACHMENT.ShortName = "7.62" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "7.62×51mm Conversion",
	TFA.AttachmentColors["+"], "100% more damage",
	TFA.AttachmentColors["-"], "50% less RPM",
	TFA.AttachmentColors["-"], "100% more recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 2 end,
		["RPM"] = function(wep, stat) return 425 end,
		["KickUp"] = function( wep, stat ) return stat * 2 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 2 end,
		["KickDown"] = function( wep, stat ) return stat * 2 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.HK416.1.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.HK416.2.CONV") end,
		["Automatic"] = function(wep, stat) return false end,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end