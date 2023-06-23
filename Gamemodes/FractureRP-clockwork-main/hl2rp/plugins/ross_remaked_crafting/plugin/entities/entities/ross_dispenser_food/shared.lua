ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "Ration Dispenser";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = false;

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("ross_dispenser_food")
	entity:SetPos(trace.HitPos + Vector(0, 0, 10))
	local model = "models/props_lab/binderblue.mdl"

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
	-- self:NetworkVar(type, slot, name, extended=nil)
	self:NetworkVar("Bool", 0, "RegimeTurned")

	self:SetRegimeTurned(true)
end;