ENT.Type = "anim";
--ENT.Base = "base_gmodentity";
ENT.Author = "Ross";
ENT.PrintName = "Locker for Notepads";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = true;

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("cw_notepad_holder")
	entity:SetPos(trace.HitPos + Vector(0, 0, 90))

	local angles = (entity:GetPos() - client:GetPos()):Angle()
	angles.p = 0
	angles.y = 0
	angles.r = 0

	entity:SetAngles(angles)
	entity:Spawn()
	entity:Activate()

	for k, v in pairs(ents.FindInBox(entity:LocalToWorld(entity:OBBMins()), entity:LocalToWorld(entity:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == "models/props_office/file_cabinet_large_static.mdl") then 
			entity:SetPos(v:GetPos())
			entity:SetAngles(v:GetAngles())
			SafeRemoveEntity(v)

			break
		end
	end

	return entity
end