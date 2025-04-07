
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "5.56"
ATTACHMENT.ShortName = "5.56" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "5.56×45mm Conversion",
	TFA.AttachmentColors["+"], "15% more RPM",
	TFA.AttachmentColors["+"], "15% less recoil",
	TFA.AttachmentColors["-"], "10% less damage",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.9 end,
		["RPM"] = function(wep, stat) return 700 end,
		["KickUp"] = function(wep, stat) return stat * 0.85 end,
		["KickDown"] = function(wep, stat) return stat * 0.85 end,
		["KickHorizontal"] = function(wep, stat) return stat * 0.85 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_Stg44.1.CONV") end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end