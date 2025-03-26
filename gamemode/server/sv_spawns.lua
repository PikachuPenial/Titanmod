hook.Add("IsSpawnpointSuitable", "CheckSpawnPoint", function(ply, spawnpointent, bMakeSuitable)
	local pos = spawnpointent:GetPos()

	local entities = ents.FindInBox(pos + Vector(-512, -512, -128), pos + Vector(512, 512, 128))
	local entsBlocking = 0

	for _, v in ipairs(entities) do
		if (v:IsPlayer() and v:Alive()) then
			entsBlocking = entsBlocking + 1
		end
	end

	if (entsBlocking > 0) then return false end
	return true
end )

function GM:PlayerSelectSpawn(ply)
	local spawns = ents.FindByClass("info_player_start")
	local size = table.Count(spawns)

	for i = 0, size do
		local randomSpawn = math.random(#spawns)

		if (hook.Call("IsSpawnpointSuitable", GAMEMODE, ply, spawns[randomSpawn], i == size)) then
			return spawns[randomSpawn]
		end
	end

	return spawns[randomSpawn]
end