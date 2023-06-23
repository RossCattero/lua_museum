ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Вода";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = false;

function ENT:SetupDataTables()
    self:NetworkVar('Float', 0, 'Level')

    self:NetworkVar('Bool', 1, 'Workable')
end;

function ENT:OnPopulateEntityInfo(tooltip)
	local sellername = tooltip:AddRow("name")
	sellername:SetImportant()
	sellername:SetText('Раздатчик воды')
	sellername:SetBackgroundColor(Color(255, 255, 255, 0))
	sellername:SetTextInset(8, 0)
	sellername:SizeToContents()
end