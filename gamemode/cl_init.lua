include("shared.lua")
include("!config.lua")

for _, v in ipairs(file.Find("gamemodes/titanmod/gamemode/shared/*.lua", "GAME", "nameasc")) do
	include("shared/" .. v)
end

for _, v in ipairs(file.Find("gamemodes/titanmod/gamemode/client/*.lua", "GAME", "nameasc")) do
	include("client/" .. v)
end