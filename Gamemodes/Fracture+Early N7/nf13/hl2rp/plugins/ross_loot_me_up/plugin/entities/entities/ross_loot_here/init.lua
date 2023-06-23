include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
	if !self.items then
		self.items = {}
	end;
	if !self.itemsInside then
		self.itemsInside = {}
	end;
	if !self.informTable then
		self.informTable = {
			model = "models/props_junk/wood_crate001a_damaged_old.mdl",
			maxitems = 1,
			timetospawn = 360,
			timetoclean = 360
		}
	end;
	self:SetModel(self.informTable['model']);
	self:DrawShadow(true);
	self:SetSolid(SOLID_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetUseType(SIMPLE_USE);

	for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == self.informTable['model']) then
			self:SetPos(v:GetPos());
			self:SetAngles(v:GetAngles());
			SafeRemoveEntity(v);

			return;
		end;
	end;
end;

function ENT:Think()
	if table.Count(self.items) == 0 then
		return;
	end;

	if !self.itemRemoveAll || CurTime() >= self.itemRemoveAll then
		self.itemRemoveAll = CurTime() + self.informTable['timetoclean'];
		self.itemsInside = {};
		return;
	end;

	if !self.itemspawn || CurTime() >= self.itemspawn then
		self.itemspawn = CurTime() + self.informTable['timetospawn'];
		for k, v in pairs(self.items) do
			if v == 0 then
				self.items[k] = v + 10;
			end;
		end;
		if table.Count(self.itemsInside) < tonumber(self.informTable['maxitems']) then
			for k, v in pairs(self.items) do
				if math.random(1, 100) <= v then
					self.itemsInside[k] = v
					self.items[k] = 0;
				end;
			end;
		end;
	end;
end;

function ENT:Use(activator, caller)

	if activator:KeyDown( IN_SPEED ) && (activator:IsSuperAdmin() or activator:IsAdmin()) then
		cable.send(activator, 'OpenSettingsRandomizer', self, self.informTable, self.items);
		return;
	end;

	if (activator.searchingCoolDown && CurTime() < activator.searchingCoolDown) or table.Count(self.itemsInside) == 0 then
		Clockwork.player:Notify(activator, 'Я не думаю, что смогу найти тут что-либо.')
		return;
	end;
	local simplerandom = math.random(2, 5) + (math.random(1, 2)*0.5);
	local action, percentage = Clockwork.player:GetAction(activator, true);
	if action == 'looting' then
		return;
	end;
	if !activator:Crouching() then
		activator:SetForcedAnimation('d3_c17_03_tower_idle')
	else
		activator:SetForcedAnimation('roofidle1')
	end;
	Clockwork.player:SetAction(activator, "looting", simplerandom);
	Clockwork.player:EntityConditionTimer(activator, self, self, simplerandom, 192, function()
		if !activator.searchingSound or CurTime() >= activator.searchingSound then
			activator:EmitSound('physics/wood/wood_solid_impact_soft'..math.random(1, 3)..'.wav')
			activator.searchingSound = CurTime() + math.random(2, 5)
		end;
		return activator:Alive() and !activator:IsRagdolled() and activator:GetVelocity():Length() == 0
	end, function(success)
		if (success) then
			for k, v in pairs(self.itemsInside) do
				if math.random(1, 100) <= v then
					activator:GiveItem(Clockwork.item:CreateInstance(k), true)
					self.itemsInside[k] = nil;
					activator:EmitSound('usesound/belt.mp3')
					activator.searchingCoolDown = CurTime() + 10;
					activator:SetForcedAnimation(false)
					return;
				end;
			end;
			Clockwork.player:Notify(activator, 'Тут ничего нет...')
			activator.searchingCoolDown = CurTime() + 10;
		end;
		if activator:SetForcedAnimation(false) then
			Clockwork.player:SetAction(activator, "looting", false);
		end;
	end);	
end;