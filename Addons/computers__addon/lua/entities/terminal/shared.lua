ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Terminal";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = '[Ross] Entites'

function ENT:GetDefaultModel()
	return 'models/eaprops/starwars_battlefront_2/starkiller/starkillerbase_computerpanellarge_01_mesh/starkillerbase_computerpanellarge_02_mesh.mdl';
end;

function ENT:SetupDataTables()
	self:NetworkVar('String', 0, "TerminalIndex")
	self:NetworkVar('Bool', 0, "NeedLogin")
end;