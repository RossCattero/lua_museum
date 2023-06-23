include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

local PLUGIN = PLUGIN;

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/plastic/plastic_panel1x1.mdl")
	self:SetMaterial("models/props_debris/plasterceiling008a")
	self:DrawShadow(true);
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetUseType(SIMPLE_USE);
	self:SetCollisionGroup(11)
	self:SetIsBroken(false)
	self:SetNoDraw(true)

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then physObj:EnableMotion(true); physObj:Wake(); end;

	for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
			self:SetPos(v:GetPos());
			self:SetAngles(v:GetAngles());
			SafeRemoveEntity(v);
			return;
		end;
	end;

	timer.Simple(0, function()
			local pos = self:GetPos()
			self:SetPos(Vector(pos.x, pos.y, pos.z - 1.5))
	end)
end;

function ENT:Broke()
	self:SetCollisionGroup(0)
	self:SetNoDraw(false)
	self:SetIsBroken(true)
end;

function ENT:Use(act)
		if !self:GetIsBroken() then
				return;
		end
end;

function ENT:SetWorkPos(uniqueID, id)
		self.workPos = id;
		self.workName = uniqueID
end;

function ENT:OnRemove()
		local list = PLUGIN.jobPoses;
		local id, uniqueID = self.workPos, self.workName

		if id && uniqueID && list && list[uniqueID] && list[uniqueID][id] then
				PLUGIN.jobPoses[uniqueID][id] = nil;
				PLUGIN:ListRefresh(uniqueID);
		end
end;