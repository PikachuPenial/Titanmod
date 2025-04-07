
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "7.62"
ATTACHMENT.ShortName = "7.62" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "7.62×51mm Conversion",
	TFA.AttachmentColors["+"], "20% more damage",
	TFA.AttachmentColors["-"], "35% less RPM",
	TFA.AttachmentColors["-"], "35% more recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 1.2 end,
		["RPM"] = function(wep, stat) return 700 end,
		["KickUp"] = function( wep, stat ) return stat * 1.35 end,
		["KickDown"] = function( wep, stat ) return stat * 1.35 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 1.35 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_MG42.1.CONV") end
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end