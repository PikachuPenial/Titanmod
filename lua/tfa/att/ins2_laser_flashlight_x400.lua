if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "SureFire X400 Laser + Flashlight"
ATTACHMENT.ShortName   = "X400"

ATTACHMENT.Icon        = "entities/eft_x400.png" 

ATTACHMENT.Description = { 
    TFA.AttachmentColors["+"], "Laser + Flashlight Modules",
    TFA.AttachmentColors["+"], "Enhanced laser point viewing distance",
    TFA.AttachmentColors["+"], "20% Lower base spread",
    TFA.AttachmentColors["-"], "5% Higher max spread",
    TFA.AttachmentColors["-"], "5% Lower zoom time",  
}

ATTACHMENT.WeaponTable = {

    ["VElements"] = {
		["laser_x400"] = {
			["active"] = true
		},
		["laser_beam_x400"] = {
			["active"] = true
		}
	},
	
	["WElements"] = {
		["laser"] = {
			["active"] = true
		},
		["laser_beam"] = {
			["active"] = true
		}
	},
	
	["Primary"] = {
		["Spread"] = function(wep,stat) return math.max( stat * 0.80, stat - 0.01 ) end,
		["SpreadMultiplierMax"] = function(wep,stat) return stat * ( 1 / 0.8 ) * 1.05 end,
	},

	["IronSightTime"] = function( wep, val ) return val * 1.05 end,

	["LaserSightAttachment"]      = function(wep,stat) return wep.LaserSightModAttachment end,
	["LaserSightAttachmentWorld"] = function(wep,stat) return wep.LaserSightModAttachmentWorld or wep.LaserSightModAttachment end,

	["LaserDistance"]        = 12 * 250,
	["LaserDistanceVisual"]  = 12 * 7.5,
	["laserFOV"]             = 0.8,
	
	["FlashlightAttachment"] = 1,
	["FlashlightDistance"]   = 10 * 85,
	["FlashlightBrightness"] = 8.5,
	["FlashlightFOV"]        = 55,
	
	FlashlightSoundToggleOn = Sound("TFA_INS2.FlashlightOn"),
	FlashlightSoundToggleOff = Sound("TFA_INS2.FlashlightOff"),
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end