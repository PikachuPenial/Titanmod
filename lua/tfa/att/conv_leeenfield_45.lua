
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".45 ACP"
ATTACHMENT.ShortName = ".45" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".45 ACP Conversion",
	TFA.AttachmentColors["+"], "80% more RPM",
	TFA.AttachmentColors["+"], "50% faster reload time",
	TFA.AttachmentColors["-"], "25% less damage",
	TFA.AttachmentColors["-"], "40% more spread",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.75 end,
		["RPM"] = function(wep, stat) return 545 end,
		["Spread"] = function( wep, stat ) return stat * 1.4 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_DOI_ENFIELD.1.CONV") end,
	},
	["SequenceRateOverride"] = {
		["base_fire_end"] = 58 / 32,
		["iron_fire_end"] = 58 / 32,
		["reload_insert"] = 1.8,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end