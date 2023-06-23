ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "UNION Terminal";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = false;

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("r_part_terminal")
	entity:SetPos(trace.HitPos + Vector(0, 0, 10))
	local model = "models/union/props/terminal.mdl"

	local angles = (entity:GetPos() - client:GetPos()):Angle()
	angles.p = 0
	angles.y = 0
	angles.r = 0

	entity:SetAngles(angles)
	entity:Spawn()
	entity:Activate()

	for k, v in pairs(ents.FindInBox(entity:LocalToWorld(entity:OBBMins()), entity:LocalToWorld(entity:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then 
			entity:SetPos(v:GetPos())
			entity:SetAngles(v:GetAngles())
			SafeRemoveEntity(v)

			break
		end
	end

	return entity
end;

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "TerminalCard")
end;