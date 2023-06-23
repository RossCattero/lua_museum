ENT.Type = "anim";
ENT.Author = "Ross";
ENT.PrintName = "SELLER";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = true;

function ENT:SpawnFunction(client, trace)
	local entity = ents.Create("ross_talking_npc")
	entity:SetPos(trace.HitPos + Vector(0, 0, 0))

	local angles = (entity:GetPos() - client:GetPos()):Angle()
	angles.p = 0
	angles.y = 0
	angles.r = 0

	entity:SetAngles(angles)
	entity:Spawn()
	entity:Activate()

	for k, v in pairs(ents.FindInBox(entity:LocalToWorld(entity:OBBMins()), entity:LocalToWorld(entity:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == "models/frp/citizen_male_01.mdl") then 
			entity:SetPos(v:GetPos())
			entity:SetAngles(v:GetAngles())
			SafeRemoveEntity(v)

			break
		end
	end

	return entity
end;

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "InfoName")

	self:NetworkVar("Bool", 1, "IsDisabled")
	self:NetworkVar("Bool", 2, "IsCwu")
	self:NetworkVar("Bool", 3, "IsDDD")
end;