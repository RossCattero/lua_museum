ENT.Type = "anim";
ENT.Author = "zamboni & Ross";
ENT.PrintName = "ForceField";
ENT.Spawnable		= true;
ENT.AdminOnly		= true;
ENT.RenderGroup 	= RENDERGROUP_BOTH;
ENT.PhysgunDisabled = true;

function ENT:SpawnFunction(player, trace)
	if !(trace.Hit) then return; end;
	local entity = ents.Create("ross_forcefield");

	entity:SetPos(trace.HitPos + Vector(0, 0, 40));
	entity:SetAngles(Angle(0, trace.HitNormal:Angle().y - 90, 0));
	entity:Spawn();
	entity.Owner = player;

	return entity;
end;

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "IsTurned" )
	self:NetworkVar( "Entity", 1, "EntInfo" )
end;