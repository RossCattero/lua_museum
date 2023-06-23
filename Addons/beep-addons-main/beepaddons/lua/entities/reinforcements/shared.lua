ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Terminal to sabotage";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.Category = '[Ross] Entites'

function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "OBJid")
end;