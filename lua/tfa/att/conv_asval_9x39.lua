
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "9x39"
ATTACHMENT.ShortName = "9x39" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "9x39mm Conversion",
	TFA.AttachmentColors["+"], "100% more damage",
	TFA.AttachmentColors["-"], "66% less RPM",
	TFA.AttachmentColors["-"], "100% more recoil",
	TFA.AttachmentColors["-"], "10% less mobility",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Bodygroups_V"] = {
		[1] = 1
	},
	["Bodygroups_W"] = {
		[1] = 1
	},
	["MoveSpeed"] = function(wep,stat) return stat * 0.9 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 0.9 end,
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 2 end,
		["RPM"] = function(wep, stat) return 300 end,
		["KickUp"] = function( wep, stat ) return stat * 2 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 2 end,
		["KickDown"] = function( wep, stat ) return stat * 2 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INSS.ASVAL.CONV.1") end,
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end