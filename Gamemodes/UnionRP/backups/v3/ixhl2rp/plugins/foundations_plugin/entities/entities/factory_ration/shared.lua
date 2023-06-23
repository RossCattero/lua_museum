ENT.Base = "base_entity"
ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "ration packet";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.PhysgunDisabled = false;

ENT.ShowPlayerInteraction = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "PacketUp")
end;