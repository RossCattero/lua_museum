ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Раздатчик рационов";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = false;


function ENT:SetupDataTables()
    self:NetworkVar('Bool', 0, 'Turned')
    self:NetworkVar('Int', 0, 'Level')
end;