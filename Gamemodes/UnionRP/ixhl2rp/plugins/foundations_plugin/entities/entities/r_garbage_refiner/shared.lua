ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Переработчик мусора";
ENT.Spawnable = true;
ENT.AdminSpawnable = false;


function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "ID")
    self:NetworkVar("Bool", 0, "Locked")
    self:NetworkVar("Bool", 1, "Turned")
end;