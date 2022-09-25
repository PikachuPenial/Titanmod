if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name        = "Flechette Shells"             -- Fully attachment name
ATTACHMENT.ShortName   = "Flechette"                    -- Abbreviation, 5 chars or less please

ATTACHMENT.Icon        = "entities/flechetterounds.png" -- Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Flechette Darts",
    TFA.AttachmentColors["+"], "Improves Accuracy", 
    TFA.AttachmentColors["+"], "Improves Penetration", 
    TFA.AttachmentColors["+"], "+8 Pellets",   
    TFA.AttachmentColors["-"], "-50% Damage"
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
        ["IronAccuracy"] = function( wep, stat ) return math.max( stat * 0.75 ) end,
        ["Spread"] = function( wep, stat ) return math.max( stat * 0.75 ) end,
        ["PenetrationMultiplier"] = function( wep, stat ) return stat * 0.50 end,
        ["NumShots"] = function( wep, stat ) return stat + 8 end,
        ["Damage"] = function(wep,stat) return stat * 0.50 end,
	}
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end