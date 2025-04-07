
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "8mm"
ATTACHMENT.ShortName = "8mm" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "8mm Kurz Conversion",
	TFA.AttachmentColors["+"], "20% more damage",
	TFA.AttachmentColors["-"], "40% less RPM",
	TFA.AttachmentColors["-"], "40% more recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 1.2 end,
		["RPM"] = function(wep, stat) return 400 end,
		["KickUp"] = function( wep, stat ) return stat * 1.4 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 1.4 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_mp40.1.CONV") end,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end