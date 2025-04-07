
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".30-06"
ATTACHMENT.ShortName = "30-06" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".30-06 Springfield Conversion",
	TFA.AttachmentColors["+"], "65% more RPM",
	TFA.AttachmentColors["-"], "35% less damage",
	TFA.AttachmentColors["-"], "50% more recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.65 end,
		["RPM"] = function(wep, stat) return 900 end,
		["KickUp"] = function( wep, stat ) return stat * 1.5 end,
		["KickDown"] = function( wep, stat ) return stat * 1.5 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 1.5 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_Lewis.1.CONV") end
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end