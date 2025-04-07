
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".303"
ATTACHMENT.ShortName = ".303" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".303 Kurz Conversion",
	TFA.AttachmentColors["+"], "80% less recoil",
	TFA.AttachmentColors["-"], "40% less RPM",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["RPM"] = function(wep, stat) return 540 end,
		["KickUp"] = function( wep, stat ) return stat * 0.2 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 0.2 end,
		["KickDown"] = function( wep, stat ) return stat * 0.2 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_Fg42.1.CONV") end,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end