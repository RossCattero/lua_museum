include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props_combine/suit_charger001.mdl"

		self:SetModel(model);
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
	    self:SetUseType(SIMPLE_USE);

		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:Sleep();
			physObj:EnableMotion(true);
		end;


		for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
			if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
				self:SetPos(v:GetPos());
				self:SetAngles(v:GetAngles());
				SafeRemoveEntity(v);

				return;
			end;
		end;
	end;

function ENT:StartTouch( ent )
	if ent:GetClass() == "cw_item" && git(ent, "uniqueID") == 'item_battery_charger' then
		self:SetBattery(true);
		self:SetIsCharging(true);
		ent:Remove();
		self:EmitSound("items/battery_pickup.wav");
		timer.Create(math.random(999999)..self:GetClass(), 10, 1, function()
			self:EmitSound("hl1/fvox/fuzz.wav");
			if IsValid(self) && self:GetBattery() then
				self:SetIsCharging(false);
			end;
		end);
	end;
end;

function ENT:Use(activator, caller)
	if !self:GetIsCharging() && IsValid(self) && self:GetBattery() then
		self:EmitSound("items/battery_pickup.wav");
		self:SetBattery(false);
		activator:GiveItem(Clockwork.item:CreateInstance('item_battery_charger'), true);
	end;
end;