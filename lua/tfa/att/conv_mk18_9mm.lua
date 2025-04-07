
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "9mm"
ATTACHMENT.ShortName = "9mm" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "9mm Conversion",
	TFA.AttachmentColors["+"], "40% more RPM",
	TFA.AttachmentColors["-"], "30% less damage",
	TFA.AttachmentColors["-"], "45% more spread",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.70 end,
		["RPM"] = function(wep, stat) return 1000 end,
		["Spread"] = function( wep, stat ) return stat * 1.45 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_INSS_FML_MK18.Pew.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("Weapon_INSS_FML_MK18.Pew2.CONV") end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end