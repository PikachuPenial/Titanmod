
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".380"
ATTACHMENT.ShortName = "380" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".380 ACP Conversion",
	TFA.AttachmentColors["+"], "20% more RPM",
	TFA.AttachmentColors["-"], "20% less damage",
	TFA.AttachmentColors["-"], "100% more horizontal recoil",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 0.8 end,
		["RPM"] = function(wep, stat) return 850 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 2 end,
		["Sound"] = function( wep, stat ) return Sound("weapons/fas2_ppbizon/bizon_fire1_conv.wav") end,
		["SilencedSound"] = function( wep, stat ) return Sound("weapons/fas2_ppbizon/bizon_suppressed_fire1_conv.wav") end
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end