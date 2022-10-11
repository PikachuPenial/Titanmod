if CLIENT then
    CreateClientConVar("cl_kn_rue_addon", 1, true, false)
    local app = 0
    local app_snd = 0
    local rue_underwater

    local function RUE_Effects()
        if ply:WaterLevel()==3 then
            DrawMaterialOverlay("rue_effects/rue_underwater", 0.1)
            ply:SetDSP(31)
            DrawMotionBlur(0.1, 0.5, 0)
            app = 0.1
            if (CurTime() >= app_snd) then
                rue_underwater = CreateSound(ply, Sound("rue_effects/rue_underwater.wav"))
                rue_underwater:Play()
                app_snd = CurTime() + SoundDuration("rue_effects/rue_underwater")
            end
        else
            app = math.Approach(app, 0, 0.001)
            if app != 0 then
                rue_underwater:Stop()
                ply:SetDSP(0)
                app_snd = 0
                DrawMotionBlur(0.1, 1, 0)
                DrawMaterialOverlay("rue_effects/rue_underwater", app)
                DrawMaterialOverlay("rue_effects/rue_outwater", app)
            end
        end
    end

    local function RUE()
        if GetConVarNumber("cl_kn_rue_addon") == 1 then
            ply = LocalPlayer()
            if (ply:GetMoveType() != MOVETYPE_NOCLIP and ply:Alive()) then
                RUE_Effects()
            else
                if (app_snd != 0 or app != 0) then
                    app = 0
                    app_snd = 0
                    ply:SetDSP(0)
                    rue_underwater:Stop()
                    DrawMotionBlur(0, 0, 0)
                end
            end
        end
    end

    hook.Add("RenderScreenspaceEffects", "RUE_kenni", RUE)
end