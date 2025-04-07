
if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "9mm"
ATTACHMENT.ShortName = "9mm" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {
	TFA.AttachmentColors["="], "9mm Conversion",
	TFA.AttachmentColors["+"], "+4 bullets in magazine",
	TFA.AttachmentColors["+"], "85% more RPM",
	TFA.AttachmentColors["-"], "50% less recoil",
	TFA.AttachmentColors["-"], "25% less damage",
}
ATTACHMENT.Icon = "attachments/conversion.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["mag"] = {
			["active"] = false,
		},
		["mag_ext"] = {
			["active"] = true,
		}
	},
	["WElements"] = {
		["mag"] = {
			["active"] = false,
		},
		["mag_ext"] = {
			["active"] = true,
		}
	},
	["Animations"] = {
		["reload"] = function(wep, _val)
			local val = table.Copy(_val)
			if val.type == TFA.Enum.ANIMATION_SEQ then
				val.value = val.value .. "_extmag"
			else
				val.type = TFA.Enum.ANIMATION_SEQ --Sequence or act
				val.value = "base_reload_extmag"
			end
			return (wep:CheckVMSequence(val.value) and val or _val), true, true
		end,
		["reload_empty"] = function(wep, _val)
			local val = table.Copy(_val)
			if val.type == TFA.Enum.ANIMATION_SEQ then
				val.value = val.value .. "_extmag"
			else
				val.type = TFA.Enum.ANIMATION_SEQ --Sequence or act
				val.value = "base_reload_empty_extmag"
			end
			return (wep:CheckVMSequence(val.value) and val or _val), true, true
		end,
	},
	["Primary"] = {
		["ClipSize"] = function(wep, val)
			return wep.Primary.ClipSize_ExtPistol or 12
		end,
		["Damage"] = function(wep, stat) return stat * 0.75 end,
		["RPM"] = function(wep, stat) return 600 end,
		["KickUp"] = function( wep, stat ) return stat * 0.5 end,
		["KickHorizontal"] = function( wep, stat ) return stat * 0.5 end,
		["KickDown"] = function( wep, stat ) return stat * 0.5 end,
		["Sound"] = function( wep, stat ) return Sound("TFA_INS2.Colt_M45.Fire.CONV") end,
		["SilencedSound"] = function( wep, stat ) return Sound("TFA_INS2.Colt_M45.Fire_Suppressed.CONV") end
	},
}

function ATTACHMENT:Detach(wep)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
