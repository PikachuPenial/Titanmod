
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".308"
ATTACHMENT.ShortName = ".308" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".308 Winchester Conversion",
	TFA.AttachmentColors["+"], "45% more damage",
	TFA.AttachmentColors["-"], "35% less RPM",
	TFA.AttachmentColors["-"], "250% more recoil",
	TFA.AttachmentColors["-"], "6% less mobility",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["MoveSpeed"] = function(wep,stat) return stat * 0.94 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat * 0.94 end,
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 1.44 end,
		["RPM"] = function(wep, stat) return 275 end,
		["KickUp"] = function( wep, stat ) return stat * 2.5 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 2.5 end,
		["KickDown"] = function( wep, stat ) return stat * 2.5 end,
		["Sound"] = function( wep, stat ) return Sound("weapons/tfa_ins2_g28/g28-1_conv.wav") end,
		["SilencedSound"] = function( wep, stat ) return Sound("weapons/tfa_ins2_g28/g28_sil-1_conv.wav") end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end