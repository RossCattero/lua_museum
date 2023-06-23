ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Sensor";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = '[Ross] Entites'

function ENT:GetDefaultModel()
	return 'models/kingpommes/starwars/misc/misc_panel_2.mdl';
end;

function ENT:SetupDataTables()
	self:NetworkVar('String', 0, "Index")		// unique ID of every terminal.
	self:NetworkVar('String', 1, "GroupIndex")	// group ID of every terminal.
	self:NetworkVar("Bool", 0, "Grouped");		// Is this sensor in group?
end;