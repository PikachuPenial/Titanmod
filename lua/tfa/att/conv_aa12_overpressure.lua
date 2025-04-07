
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "+P"
ATTACHMENT.ShortName = "+P" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "Overpressure Conversion",
	TFA.AttachmentColors["+"], "100% more RPM",
	TFA.AttachmentColors["-"], "33% less damage",
	TFA.AttachmentColors["-"], "50% more spread",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.67 end,
		["RPM"] = function(wep, stat) return 540 end,
		["Spread"] = function( wep, stat ) return stat * 1.50 end,
		["IronAccuracy"] = function( wep, stat ) return stat * 1.50 end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end