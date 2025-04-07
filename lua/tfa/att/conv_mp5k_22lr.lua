
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".22 LR"
ATTACHMENT.ShortName = ".22" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "22 Long Rifle Conversion",
	TFA.AttachmentColors["+"], "15% more RPM",
	TFA.AttachmentColors["-"], "20% less damage",
	TFA.AttachmentColors["-"], "50% more horizontal recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.8 end,
		["RPM"] = function(wep, stat) return 1035 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 1.5 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.INSS_MP5A5.Fire.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.INSS_MP5A5.Fire_Suppressed.CONV") end
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end