--color array, saving space
local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)

function HUD()
	if CLIENT and GetConVar("tm_hideui"):GetInt() == 0 then
		local client = LocalPlayer()

		if !client:Alive() then
			return
		end

        --Gun Hud
        if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
            draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() - 15, ScrH() - 60, white, TEXT_ALIGN_RIGHT, 0)
            draw.SimpleText(client:GetActiveWeapon():Clip1(), "AmmoCount", ScrW() - 15, ScrH() - 170, white, TEXT_ALIGN_RIGHT, 0)
        end

        --Left Anchor
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 0 then
            surface.SetDrawColor(50, 50, 50, 255)
            surface.DrawRect(10, ScrH() - 38, 450 , 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100)
                else
                    surface.SetDrawColor(180, 180, 100)
                end
            else
                surface.SetDrawColor(100, 180, 100)
            end

            surface.DrawRect(10, ScrH() - 38, 450 * (client:Health() / client:GetMaxHealth()), 30)
            draw.SimpleText(client:Health(), "Health", 450, ScrH() - 39, white, TEXT_ALIGN_RIGHT, 0)
        end

        --Middle Anchor
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 1 then
            surface.SetDrawColor(50, 50, 50, 255)
            surface.DrawRect(ScrW() / 2 - 225, ScrH() - 38, 450 , 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100)
                else
                    surface.SetDrawColor(180, 180, 100)
                end
            else
                surface.SetDrawColor(100, 180, 100)
            end

            surface.DrawRect(ScrW() / 2 - 225, ScrH() - 38, 450 * (client:Health() / client:GetMaxHealth()), 30)
            draw.SimpleText(client:Health(), "Health", ScrW() / 2, ScrH() - 39, white, TEXT_ALIGN_CENTER, 0)
        end
    end
end
hook.Add("HUDPaint", "TestHud", HUD)

function DrawTarget()
    return false
end
hook.Add("HUDDrawTargetID", "HidePlayerInfo", DrawTarget)

function HideHud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudZoom", "CHudVoiceStatus"}) do
		if name == v then
			return false
		end
	end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)