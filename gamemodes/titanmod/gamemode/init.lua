AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
AddCSLuaFile("!config.lua")
include("!config.lua")

for _, v in ipairs(file.Find("gamemodes/titanmod/gamemode/shared/*.lua", "GAME", "nameasc")) do
	AddCSLuaFile("shared/" .. v)
	include("shared/" .. v)
end

for _, v in ipairs(file.Find("gamemodes/titanmod/gamemode/client/*.lua", "GAME", "nameasc")) do
	AddCSLuaFile("client/" .. v)
end

for _, v in ipairs(file.Find("gamemodes/titanmod/gamemode/server/*.lua", "GAME", "nameasc")) do
	include("server/" .. v)
end