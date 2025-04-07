
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".22 LR"
ATTACHMENT.ShortName = ".22" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "22 Long Rifle Conversion",
	TFA.AttachmentColors["+"], "15% more RPM",
	TFA.AttachmentColors["-"], "15% less damage",
	TFA.AttachmentColors["-"], "40% more recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.85 end,
		["RPM"] = function(wep, stat) return 800 end,
		["KickUp"] = function( wep, stat ) return stat * 1.4 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 1.4 end,
		["KickDown"] = function( wep, stat ) return stat * 1.4 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_M4_9MM.1.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("Weapon_M4_9MM.2.CONV") end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end