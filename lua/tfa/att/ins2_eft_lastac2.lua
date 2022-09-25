if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "LAS/TAC 2 tactical flashlight"
ATTACHMENT.ShortName   = "LAS/TAC 2"

ATTACHMENT.Icon        = "entities/eft_lastac2.png"

ATTACHMENT.Description = { 
    TFA.AttachmentColors["+"], "Improved Flashlight Module",
}

ATTACHMENT.WeaponTable = {

    ["VElements"] = {
		["flashlight_lastac"] = {
			["active"] = true
		}
	},
	
	["WElements"] = {
		["flashlight"] = {
			["active"] = true
		}
	},
	
	["FlashlightAttachment"] = 1,

	["FlashlightDistance"]   = 10 * 120,
	["FlashlightBrightness"] = 12,
	["FlashlightFOV"]        = 65,
	
	FlashlightSoundToggleOn  = Sound("TFA_INS2.FlashlightOn"),
	FlashlightSoundToggleOff = Sound("TFA_INS2.FlashlightOff"),
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end