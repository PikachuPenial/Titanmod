
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".50 BMG"
ATTACHMENT.ShortName = "50BMG" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".50 BMG Conversion",
	TFA.AttachmentColors["+"], "50% more damage",
	TFA.AttachmentColors["-"], "250% more recoil",
	TFA.AttachmentColors["-"], "250% more spread",
	TFA.AttachmentColors["-"], "30% longer rechambering speed",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 1.5 end,
		["RPM"] = function(wep, stat) return 25 end,
		["Spread"] = function( wep, stat ) return stat * 2.5 end,
		["KickUp"] = function( wep, stat ) return stat * 2.5 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 2.5 end,
		["KickDown"] = function( wep, stat ) return stat * 2.5 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_TFRE_Mares.Single.CONV") end,
	},

	["SequenceRateOverride"] = {
		["fire01"] = 0.7
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end