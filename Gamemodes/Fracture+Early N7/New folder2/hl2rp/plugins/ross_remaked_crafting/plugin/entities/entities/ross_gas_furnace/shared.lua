ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Gas fur";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = false;

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("ross_gas_furnace")
	entity:SetPos(trace.HitPos + Vector(0, 0, 10))
	local model = "models/props_c17/furnitureStove001a.mdl"

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
	self:NetworkVar("Float", 0, "Fuel")
	self:NetworkVar("Bool", 1, "GasCan")

	self:SetGasCan(false);
	self:SetFuel(0);
end;