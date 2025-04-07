
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "8mm"
ATTACHMENT.ShortName = "8mm" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "8mm Kurz Conversion",
	TFA.AttachmentColors["+"], "15% more damage",
	TFA.AttachmentColors["-"], "25% less RPM",
	TFA.AttachmentColors["-"], "75% more vertical recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 1.15 end,
		["RPM"] = function(wep, stat) return 500 end,
		["KickUp"] = function( wep, stat ) return stat * 1.75 end,
		["KickDown"] = function( wep, stat ) return stat * 1.75 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_Owen.1.CONV") end,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end