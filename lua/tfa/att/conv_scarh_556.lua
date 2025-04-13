
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "5.56"
ATTACHMENT.ShortName = "5.56" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "5.56×45mm Conversion",
	TFA.AttachmentColors["+"], "30% more RPM",
	TFA.AttachmentColors["+"], "40% less recoil",
	TFA.AttachmentColors["-"], "30% less damage",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.7 end,
		["RPM"] = function(wep, stat) return 650 end,
		["KickUp"] = function(wep, stat) return stat * 0.6 end,
		["KickDown"] = function(wep, stat) return stat * 0.6 end,
		["KickHorizontal"] = function(wep, stat) return stat * 0.6 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.SCAR_SSR.Fire.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.SCAR_SSR.Fire_Suppressed.CONV") end
	},
	["SequenceRateOverride"] = {
		["iron_fire"] = 160 / 32,
		["iron_fire_a"] = 160 / 32,
		["iron_fire_b"] = 160 / 32,
		["iron_fire_c"] = 160 / 32,
		["iron_fire_d"] = 160 / 32,
		["iron_fire_e"] = 160 / 32,
		["iron_fire_f"] = 160 / 32,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end