ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "CP call monitor";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = false;

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("ross_cp_callmonitor")
	entity:SetPos(trace.HitPos + Vector(0, 0, 90))
	local model = "models/props/cs_office/tv_plasma.mdl"

	local angles = (entity:GetPos() - client:GetPos()):Angle()
	angles.p = 0
	angles.y = 0
	angles.r = 0

	entity.boolingan = false;

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
	self:NetworkVar("Float", 0, "TimeLeft")
	self:NetworkVar("Float", 1, "NumberDone")
	self:NetworkVar("Bool", 2, "Turned")
end;