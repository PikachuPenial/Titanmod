
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".380"
ATTACHMENT.ShortName = "380" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".380 ACP Conversion",
	TFA.AttachmentColors["+"], "30% more RPM",
	TFA.AttachmentColors["-"], "10% less damage",
	TFA.AttachmentColors["-"], "50% more recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.90 end,
		["RPM"] = function(wep, stat) return 1444 end,
		["KickUp"] = function( wep, stat ) return stat * 1.5 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 1.5 end,
		["Sound"] = function( wep, stat ) return Sound("weapons/cw_mac10/MAC_WZ_conv.wav") end,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end