include("shared.lua")

-- client globals
TM = {}

-- all interfaces and fonts are developed on a 1920x1080 monitor
local tm_hud_scale = GetConVar("tm_hud_scale")
TM.HUDScale = function(size)
	if size > 0 then
        return math.max(1, size / 3 * (ScrW() / 640) * tm_hud_scale:GetFloat())
    else
        return math.min(-1, size / 3 * (ScrW() / 640) * tm_hud_scale:GetFloat())
    end
end

TM.MenuScale = function(size)
    if size > 0 then
        return math.max(1, size / 3 * (ScrW() / 640))
    else
        return math.min(-1, size / 3 * (ScrW() / 640))
    end
end

include("!config.lua")

for _, v in ipairs(file.Find("gamemodes/titanmod/gamemode/shared/*.lua", "GAME", "nameasc")) do
	include("shared/" .. v)
end

for _, v in ipairs(file.Find("gamemodes/titanmod/gamemode/client/*.lua", "GAME", "nameasc")) do
	include("client/" .. v)
end