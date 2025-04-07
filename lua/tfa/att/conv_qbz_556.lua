
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "5.56"
ATTACHMENT.ShortName = "5.56" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "5.56×45mm Conversion",
	TFA.AttachmentColors["+"], "20% more RPM",
	TFA.AttachmentColors["+"], "25% less recoil",
	TFA.AttachmentColors["-"], "25% less damage",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.75 end,
		["RPM"] = function(wep, stat) return 800 end,
		["KickUp"] = function(wep, stat) return stat * 0.75 end,
		["KickDown"] = function(wep, stat) return stat * 0.75 end,
		["KickHorizontal"] = function(wep, stat) return stat * 0.75 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.T97.Fire.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.T97.Fire_Suppressed.CONV") end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end