
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "9mm"
ATTACHMENT.ShortName = "9mm" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "9mm Conversion",
	TFA.AttachmentColors["+"], "30% more RPM",
	TFA.AttachmentColors["+"], "50% less recoil",
	TFA.AttachmentColors["-"], "20% less damage",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return 28 end,
		["RPM"] = function(wep, stat) return 770 end,
		["KickUp"] = function( wep, stat ) return stat * 0.5 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 0.5 end,
		["KickDown"] = function( wep, stat ) return stat * 0.5 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.UMP45.1.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.UMP45.2.CONV") end,
		["LoopSound"] = function( wep, stat ) return Sound("TFA_INS2.UMP45.Loop.CONV") end,
		["LoopSoundSilenced"] = function( wep, stat ) return Sound("TFA_INS2.UMP45.LoopSil.CONV") end,
		["LoopSoundTail"] = function( wep, stat ) return Sound("TFA_INS2.UMP45.LoopTail.CONV") end,
		["LoopSoundTailSilenced"] = function( wep, stat ) return Sound("TFA_INS2.UMP45.LoopTailSil.CONV") end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end