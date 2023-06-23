include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()

		self:SetModel(entmodelindex());
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
	    self:SetUseType(SIMPLE_USE);
		
		self.cwInventory = self.cwInventory or {}
		self.weight = self.weight or 0
		self.cash = self.cwCash or 0

		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(false);
			physObj:Sleep();
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

function ENT:StartTouch(ent)
	if ent:IsValid() && ent:GetClass() == "cw_item" && git(ent, "baseItem") == "ration_base" && self.weight != 5 then 
		Clockwork.inventory:AddInstance(self.cwInventory, Clockwork.item:CreateInstance(git(ent, "uniqueID"), nil, git(ent, "data")))
		ent:Remove()
		self:EmitSound("items/ammocrate_open.wav")
		self.weight = math.Clamp(self.weight + git(ent, "weight"), 0, 5);
	end;
end;

function ENT:OnRemove()
	if (!Clockwork.kernel:IsShuttingDown()) then
		Clockwork.entity:DropItemsAndCash(self.cwInventory, self.cwCash, self:GetPos(), self);
		self.cwInventory = nil;
		self.cwCash = nil;
	end;
end;