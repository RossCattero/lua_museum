include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props_wasteland/laundry_washer003.mdl"

		self:SetModel(model);
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
	    self:SetUseType(SIMPLE_USE);

		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(true);
			physObj:Sleep();
		end;

		self.cwInventory = self.cwInventory or {}
		self.weight = self.weight or 0

		for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
			if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
				self:SetPos(v:GetPos());
				self:SetAngles(v:GetAngles());
				SafeRemoveEntity(v);

				return;
			end;
		end;
	end;

function ENT:SetData(inventory, cash, weight)
	self.cwInventory = inventory;
	self.weight = weight;
end;	

function ENT:StartTouch( ent )
	local avaibleSlots = {
		"body",
		"legs",
		"hands"
	}
	if ent:GetClass() == "cw_item" && git(ent, "baseItem") == "clothes_base" && table.HasValue(avaibleSlots, git(ent, "clothesslot")) && self.weight != 6 && self:GetTurnOn() == false then 
		Clockwork.inventory:AddInstance(self.cwInventory, Clockwork.item:CreateInstance(git(ent, "uniqueID"), git(ent, "itemID"), git(ent, "data")))
		ent:Remove()
		self:EmitSound("items/ammocrate_open.wav")
		self.weight = math.Clamp(self.weight + git(ent, "weight"), 0, 6);
	end;
	
	if ent:GetClass() == "cw_item" && git(ent, "uniqueID") == "analog_bleach" && git(ent, "data")["Clean"] > 0 && self:GetTurnOn() == false && self:GetAmountOfCleaning() != 10 then
		self:SetAmountOfCleaning(git(ent, "data")["Clean"]);
		ent:Remove();
	end;
	
end;

function ENT:Think()

end;

function ENT:Use(activator, caller)
end;