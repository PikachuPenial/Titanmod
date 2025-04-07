
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "9x25"
ATTACHMENT.ShortName = "9x25" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "9x25mm Mauser Conversion",
	TFA.AttachmentColors["+"], "50% more RPM",
	TFA.AttachmentColors["-"], "20% less damage",
	TFA.AttachmentColors["-"], "75% more horizontal recoil",
	TFA.AttachmentColors["-"], "50% more spread",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.8 end,
		["RPM"] = function(wep, stat) return 820 end,
		["Spread"] = function( wep, stat ) return stat * 1.5 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 1.75 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_WW1_MP18_Fire.1.CONV") end,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end