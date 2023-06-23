ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Vault for robbery";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = '[Cattero] Entities'

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "ShutDown")
end;