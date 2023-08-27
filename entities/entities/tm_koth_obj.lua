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
        print("PLAYER IS INSIDE HILL")
        table.insert(hillOccupants, ent)
    end

    function ENT:EndTouch(ent)
        print("PLAYER IS NO LONGER INSIDE HILL")
        table.RemoveByValue(hillOccupants, ent)
    end

    function ENT:Touch(ent)

    end
end