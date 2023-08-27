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

    function ENT:StartTouch(ent)
        table.insert(hillOccupants, ent)
        ent:SetNWBool("onOBJ", true)
        HillStatusCheck()
    end

    function ENT:EndTouch(ent)
        table.RemoveByValue(hillOccupants, ent)
        ent:SetNWBool("onOBJ", false)
        HillStatusCheck()
    end

    function ENT:Touch(ent)

    end
end