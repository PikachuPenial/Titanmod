local hit_reg = "hitsound/hit_reg.wav"
local hit_reg_head = "hitsound/hit_reg_head.wav"

net.Receive("PlayHitsound", function(len, pl)
	if CLIENT and GetConVar("tm_hitsounds"):GetInt() == 1 then
		local hitgroup = net.ReadUInt(4)
		local soundfile = hit_reg
		if hitgroup == HITGROUP_HEAD then
			soundfile = hit_reg_head
		end

		surface.PlaySound(soundfile)
	end
end )