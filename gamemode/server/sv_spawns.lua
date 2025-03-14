-- check if a spawn point is suitable to spawn in (if another player is within proximity of this spawn point, do not spawn the player there)
hook.Add("IsSpawnpointSuitable", "CheckSpawnPoint", function(ply, spawnpointent, bMakeSuitable)
	local pos = spawnpointent:GetPos()

	local entities = ents.FindInBox(pos + Vector(-640, -640, -384), pos + Vector(640, 640, 384))
	local entsBlocking = 0

	for _, v in ipairs(entities) do
		if (v:IsPlayer() and v:Alive()) then
			entsBlocking = entsBlocking + 1
		end
	end

	if (entsBlocking > 0) then return false end
	return true
end )