include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_fence01b.mdl");
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:DrawShadow(false);

	if (!self.noCorrect) then
		local data = {};
		data.start = self:GetPos();
		data.endpos = self:GetPos() - Vector(0, 0, 300);
		data.filter = self;
		local trace = util.TraceLine(data);

		if trace.Hit and util.IsInWorld(trace.HitPos) and self:IsInWorld() then
			self:SetPos(trace.HitPos + Vector(0, 0, 39.9));
		end;

		data = {};
		data.start = self:GetPos();
		data.endpos = self:GetPos() + Vector(0, 0, 150);
		data.filter = self;
		trace = util.TraceLine(data);

		if (trace.Hit) then
			self:SetPos(self:GetPos() - Vector(0, 0, trace.HitPos:Distance(self:GetPos() + Vector(0, 0, 151))));
		end;
	end;

	data = {};
	data.start = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -16;
	data.endpos = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -600;
	data.filter = self;
	trace = util.TraceLine(data);

	self.post = ents.Create("prop_physics")
	self.post:SetModel("models/props_combine/combine_fence01a.mdl")
	self.post:SetPos(self.forcePos or trace.HitPos - Vector(0, 0, 50))
	self.post:SetAngles(Angle(0, self:GetAngles().y, 0));
	self.post:Spawn();
	self.post:PhysicsDestroy()
	self.post:SetCollisionGroup(COLLISION_GROUP_WORLD);
	self.post:DrawShadow(false);
	self.post:DeleteOnRemove(self);
	self:DeleteOnRemove(self.post);

	local verts = {
		{pos = Vector(0, 0, -35)},
		{pos = Vector(0, 0, 150)},
		{pos = self:WorldToLocal(self.post:GetPos()) + Vector(0, 0, 150)},
		{pos = self:WorldToLocal(self.post:GetPos()) + Vector(0, 0, 150)},
		{pos = self:WorldToLocal(self.post:GetPos()) - Vector(0, 0, 35)},
		{pos = Vector(0, 0, -35)},
	}

	self:PhysicsFromMesh(verts);

	local physObj = self:GetPhysicsObject();

	if (IsValid(physObj)) then
		physObj:SetMaterial("default_silent");
		physObj:EnableMotion(false);
	end;

	self:SetCustomCollisionCheck(true);
	self:EnableCustomCollisions(true);

	physObj = self.post:GetPhysicsObject();

	if (IsValid(physObj)) then
		physObj:EnableMotion(false);
	end;

	self.AllowedFactions = {};

	for k, v in pairs(Clockwork.faction.stored) do
		if !self.AllowedFactions[k] then
			self.AllowedFactions[k] = false;
		end;
	end;

	if !self:GetIsTurned() then
		self:SetIsTurned(true);
		self:SetSkin(0);
		self.post:SetSkin(0);				
		self:EmitSound("shield/activate.wav");
		-- self.ShieldLoop:Play();
	end;

	-- self.ShieldLoop = CreateSound(self, "ambient/machines/combine_shield_loop3.wav");
end;

function ENT:StartTouch(ent)

	if !self:GetIsTurned() then return end;

	if (ent:IsPlayer()) then
		if (Clockwork.plugin:Call("ShouldCollide", self, ent)) then
			if (!ent.ShieldTouch) then
				ent.ShieldTouch = CreateSound(ent, "ambient/machines/combine_shield_touch_loop1.wav");
				ent.ShieldTouch:Play();
				ent.ShieldTouch:ChangeVolume(0.25, 0);
			else
				ent.ShieldTouch:Play();
				ent.ShieldTouch:ChangeVolume(0.25, 0.5);
			end;
		end;
	end;

end;

function ENT:FieldTurnOn()
	if !self:GetIsTurned() then
		self:SetIsTurned(true);
		self:SetSkin(0);
		self.post:SetSkin(0);				
		self:EmitSound("shield/activate.wav");
		-- self.ShieldLoop:Play();
	end;
end;

function ENT:FieldTurnOff()
	if self:GetIsTurned() then
		self:SetIsTurned(false);
		self:SetSkin(1);
		self.post:SetSkin(1);				
		self:EmitSound("shield/deactivate.wav");
		-- self.ShieldLoop:Stop();
	end;
end;

function ENT:Touch(ent)

	if !self:GetIsTurned() then return end;

	if (ent:IsPlayer()) then
		if (Clockwork.plugin:Call("ShouldCollide", self, ent)) then
			if ent.ShieldTouch then
				ent.ShieldTouch:ChangeVolume(0.3, 0);
			end;
		end;
	end;

end;

function ENT:EndTouch(ent)

	if !self:GetIsTurned() then return end;

	if (ent:IsPlayer()) then
		if (Clockwork.plugin:Call("ShouldCollide", self, ent)) then
			if (ent.ShieldTouch) then
				ent.ShieldTouch:FadeOut(0.5);
			end;
		end;
	end;
end;

function ENT:Think()
	if !self:GetIsTurned() then return end;

	if (IsValid(self:GetPhysicsObject())) then
		self:GetPhysicsObject():EnableMotion(false);
	end;
end;

function ENT:OnRemove()
	
end;

function ENT:Use(activator, caller)
	if activator:KeyDown( IN_SPEED ) && activator:IsAdmin() then
		cable.send(activator, 'OpenForceFieldSettings', self, self.AllowedFactions);
		return;
	end;
	if Schema:PlayerIsCombine(activator) || activator:IsAdmin() then
		if !self:GetIsTurned() then
			self:FieldTurnOn()
		else
			self:FieldTurnOff()
		end;
	end;
end;