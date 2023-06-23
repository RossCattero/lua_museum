include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
	    self:SetUseType(SIMPLE_USE);
		
		self.FoodInside = {}

		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(false);
			physObj:Sleep();
		end;

		self:SetModel(Clockwork.item:FindByID(self.uniqueLevel).model);


		for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
			if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
				self:SetPos(v:GetPos());
				self:SetAngles(v:GetAngles());
				SafeRemoveEntity(v);

				return;
			end;
		end;
	end;

function ENT:StartTouch(ent)
	if table.HasValue(Clockwork.item:FindByID(self.uniqueLevel).rationContains["items"], git(ent, "uniqueID")) && !table.Compare(self.FoodInside, Clockwork.item:FindByID(self.uniqueLevel).rationContains["items"]) && !self:GetIsBroken() then
		if git(ent, "foodtype") == 1 && git(ent, "portions") < 4 then
			return;
		elseif git(ent, "foodtype") == 2 && git(ent, "portions") < 5 then
			return; 
		end;
		table.insert(self.FoodInside, git(ent, "uniqueID"));
		ent:Remove();
		if table.HasValue(Clockwork.item:FindByID(self.uniqueLevel).rationContains["items"], self.FoodInside[1]) && table.HasValue(Clockwork.item:FindByID(self.uniqueLevel).rationContains["items"], self.FoodInside[2]) then
			Clockwork.entity:CreateItem(player, self.uniqueLevel, self:GetPos(), self:GetAngles());
			self:Remove();
		end;
	end;
end;