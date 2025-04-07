
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".45 ACP"
ATTACHMENT.ShortName = ".45" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".45 ACP Conversion",
	TFA.AttachmentColors["+"], "25% more damage",
	TFA.AttachmentColors["+"], "50% less horizontal recoil",
	TFA.AttachmentColors["-"], "25% less RPM",
	TFA.AttachmentColors["-"], "25% more spread",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 1.25 end,
		["RPM"] = function(wep, stat) return 750 end,
		["Spread"] = function(wep, stat) return stat * 1.25 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 0.5 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_FML_P90.Pew.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("Weapon_FML_P90.Pew2.CONV") end
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end