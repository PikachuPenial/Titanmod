
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = ".22 LR"
ATTACHMENT.ShortName = "22LR" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], ".22 LR Conversion",
	TFA.AttachmentColors["+"], "50% more damage",
	TFA.AttachmentColors["-"], "40% less RPM",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep, stat) return stat * 1.5 end,
		["RPM"] = function(wep, stat) return 600 end,
		["Sound"] = function( wep, stat ) return Sound("Weapon_IMIUZI_TFA_N_1.CONV") end,
	},
	["FireModes"] = {"Semi"}
}

function ATTACHMENT:Attach(wep)
	wep.Primary.Automatic = false
end

function ATTACHMENT:Detach(wep)
	wep.Primary.Automatic = true
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end