ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Fire hydrant";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.Category = '[Cattero] Entities'
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
		self:NetworkVar("Bool", 0, "IsBroken")
end;