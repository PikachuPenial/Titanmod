
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".280"
ATTACHMENT.ShortName = ".280" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".280 British Conversion",
	TFA.AttachmentColors["+"], "+5 bullets in magazine",
	TFA.AttachmentColors["+"], "50% less recoil",
	TFA.AttachmentColors["-"], "20% less damage",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["ClipSize"] = function(wep, stat) return 25 end,
		["Damage"] = function(wep, stat) return stat * 0.75 end,
		["KickUp"] = function( wep, stat ) return stat * 0.5 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 0.5 end,
		["KickDown"] = function( wep, stat ) return stat * 0.5 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.FAL.Fire.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.FAL.Fire_Suppressed.CONV") end
	},
}

function ATTACHMENT:Detach(wep)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end