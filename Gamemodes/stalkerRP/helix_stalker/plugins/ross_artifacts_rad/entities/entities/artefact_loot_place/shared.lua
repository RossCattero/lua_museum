ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Artefact place";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.category = "FractureRP"

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("artefact_loot_place")
	entity:SetPos(trace.HitPos + Vector(0, 0, 20))
	local model = "models/hunter/blocks/cube025x025x025.mdl"

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
	self:NetworkVar("Float", 0, "Level")
end;