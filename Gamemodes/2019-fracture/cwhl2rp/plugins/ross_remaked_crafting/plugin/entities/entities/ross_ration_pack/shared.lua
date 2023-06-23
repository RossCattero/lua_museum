ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "ration packet";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.PhysgunDisabled = true;

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("ross_ration_pack")
	entity:SetPos(trace.HitPos + Vector(0, 0, 90))
	local model = "models/weapons/w_package.mdl"

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
	--self:NetworkVar("", 0, "")
	self:NetworkVar("Bool", 0, "IsBroken")
end;