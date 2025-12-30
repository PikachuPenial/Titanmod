-- fuck me
local possibleSpawnEnts = {
	["info_player_start"] = true,
	["info_player_deathmatch"] = true,
	["info_player_combine"] = true,
	["info_player_rebel"] = true,
	["info_coop_spawn"] = true,
	["info_player_counterterrorist"] = true,
	["info_player_terrorist"] = true,
	["info_player_axis"] = true,
	["info_player_allies"] = true,
	["gmod_player_start"] = true,
	["info_player_teamspawn"] = true,
	["ins_spawnpoint"] = true,
	["aoc_spawnpoint"] = true,
	["dys_spawn_point"] = true,
	["info_player_pirate"] = true,
	["info_player_viking"] = true,
	["info_player_knight"] = true,
	["diprip_start_team_blue"] = true,
	["diprip_start_team_red"] = true,
	["info_player_red"] = true,
	["info_player_blue"] = true,
	["info_player_coop"] = true,
	["info_player_human"] = true,
	["info_player_zombie"] = true,
	["info_player_zombiemaster"] = true,
	["info_player_fof"] = true,
	["info_player_desperado"] = true,
	["info_player_vigilante"] = true,
	["info_survivor_rescue"] = true,
	["info_player_attacker"] = true,
	["info_player_defender"] = true,
	["info_ff_teamspawn"] = true
}

local possibleSpawns = {}

function GM:InitPostEntity()
	for _, ent in ipairs(ents.GetAll()) do
		if (possibleSpawnEnts[ent:GetClass()]) then
			possibleSpawns[#possibleSpawns + 1] = ent
		end
	end
end

hook.Add("IsSpawnpointSuitable", "CheckSpawnPoint", function(ply, spawnpointent, bMakeSuitable)
	local pos = spawnpointent:GetPos()

	local entities = ents.FindInBox(pos + Vector(-512, -512, -512), pos + Vector(512, 512, 512))
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
	if possibleSpawns[1] == nil then return false end

	for i = 0, #possibleSpawns do
		local randomSpawn = math.random(#possibleSpawns)

		if (hook.Call("IsSpawnpointSuitable", GAMEMODE, ply, possibleSpawns[randomSpawn], i == #possibleSpawns)) then
			return possibleSpawns[randomSpawn]
		end
	end

	local randomSpawn = math.random(#possibleSpawns)
	return possibleSpawns[randomSpawn]
end