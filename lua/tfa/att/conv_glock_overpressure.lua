
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "+P"
ATTACHMENT.ShortName = "+P" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "Overpressure Conversion",
	TFA.AttachmentColors["+"], "No burst delay",
	TFA.AttachmentColors["-"], "20% less damage",
	TFA.AttachmentColors["-"], "400% more spread",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["BurstDelay"] = function( wep, stat ) return 0.0001 end,
		["Damage"] = function(wep, stat) return stat * 0.80 end,
		["Spread"] = function( wep, stat ) return stat * 4 end,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end