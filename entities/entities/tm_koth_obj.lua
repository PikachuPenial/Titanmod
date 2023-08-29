ENT.Base = "base_brush"
ENT.Type = "brush"

local KOTHCords = KOTHPos[game.GetMap()]
ENT.Origin = KOTHCords.Origin
ENT.Size = KOTHCords.BrushSize

if SERVER then
    function ENT:Initialize()
        self:SetSolid(SOLID_BBOX)
        self:SetCollisionBounds(self.Origin + self.Size, self.Origin - self.Size)
    end

    function ENT:StartTouch(ply)
        if !ply:IsPlayer() then return end
        table.insert(hillOccupants, ply)
        ply:SetNWBool("onOBJ", true)
        HillStatusCheck()
    end

    function ENT:EndTouch(ply)
        if !ply:IsPlayer() then return end
        table.RemoveByValue(hillOccupants, ply)
        ply:SetNWBool("onOBJ", false)
        HillStatusCheck()
    end
end