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

    function ENT:StartTouch()
        print("PLAYER IS INSIDE HILL")
    end

    function ENT:EndTouch()
        print("PLAYER IS NO LONGER INSIDE HILL")
    end

    function ENT:Touch()

    end
end