
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "5.45"
ATTACHMENT.ShortName = "545" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "5.45x39mm Conversion",
	TFA.AttachmentColors["+"], "60% less recoil",
	TFA.AttachmentColors["+"], "30% less spread",
	TFA.AttachmentColors["-"], "15% less damage",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.85 end,
		["Spread"] = function( wep, stat ) return stat * 0.7 end,
		["KickUp"] = function( wep, stat ) return stat * 0.4 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 0.4 end,
		["KickDown"] = function( wep, stat ) return stat * 0.4 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.AK400.Semi.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.AK400.Semi_Silenced.CONV") end,
		["LoopSound"] = function( wep, stat ) return Sound("TFA_INS2.AK400.FireLoop.CONV") end,
		["LoopSoundTail"] = function( wep, stat ) return Sound("TFA_INS2.AK400.FireLoop_Tail.CONV") end,
		["LoopSoundSilenced"] = function( wep, stat ) return Sound("TFA_INS2.AK400.FireLoop_Silenced.CONV") end,
		["LoopSoundTailSilenced"] = function( wep, stat ) return Sound("TFA_INS2.AK400.FireLoop_Silenced_Tail.CONV") end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end