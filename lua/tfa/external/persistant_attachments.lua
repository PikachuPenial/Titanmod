if not CLIENT then return end
local storagedir = "tfa_attachmentstorage"

local function TFAPA_SaveAttachments(weapon, attid, atttbl, categoty, attindex, forced)
	if not file.Exists(storagedir,"DATA") then file.CreateDir(storagedir) end	--Create file for storage if it doesn't exist
	timer.Simple(0.1, function() if LocalPlayer():Alive() and weapon:IsValid() then file.Write(storagedir.."/"..weapon:GetClass()..".dat", util.TableToJSON(weapon.AttachmentCache)) end end)
end

local function TFAPA_ApplyAttachments(weapon)
	if file.Exists(storagedir.."/"..weapon:GetClass()..".dat", "DATA") then
		local att_cache = util.JSONToTable(file.Read(storagedir.."/"..weapon:GetClass()..".dat", "DATA"))
		if not table.IsEmpty(att_cache) then	--This shouldn't EVER happen, but better safe than sorry
			for k, v in pairs(att_cache) do
				if LocalPlayer():Alive() and weapon:IsValid() then --Don't try to apply attachments if the player is dead or the weapon isn't valid
					if v ~= false then
						weapon:Attach(k)
					end
				end
			end
		end
	end
end

hook.Add("TFA_Attachment_Attached", "TFAPA_SaveAttachments", TFAPA_SaveAttachments)	--Stupid™
hook.Add("TFA_Attachment_Detached", "TFAPA_SaveAttachments", TFAPA_SaveAttachments)	--Stupid™
hook.Add("TFA_FinalInitAttachments", "TFAPA_ApplyAttachments", TFAPA_ApplyAttachments)
