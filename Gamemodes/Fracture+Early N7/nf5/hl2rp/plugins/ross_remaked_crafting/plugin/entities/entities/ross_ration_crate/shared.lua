ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Ration Crate";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = true;

function entmodelindex()
	return "models/Items/item_item_crate.mdl"
end;

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("ross_ration_crate")
	entity:SetPos(trace.HitPos + Vector(0, 0, 10))

	local angles = (entity:GetPos() - client:GetPos()):Angle()
	angles.p = 0
	angles.y = 0
	angles.r = 0

	entity:SetAngles(angles)
	entity:Spawn()
	entity:Activate()

	for k, v in pairs(ents.FindInBox(entity:LocalToWorld(entity:OBBMins()), entity:LocalToWorld(entity:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == entmodelindex()) then 
			entity:SetPos(v:GetPos())
			entity:SetAngles(v:GetAngles())
			SafeRemoveEntity(v)

			break
		end
	end

	return entity
end;

function ENT:SetupDataTables()
	--self:NetworkVar("", 0, "")
end;