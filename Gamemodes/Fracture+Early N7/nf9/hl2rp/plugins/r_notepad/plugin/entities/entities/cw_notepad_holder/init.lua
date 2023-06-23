include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()

		self:SetModel("models/props_office/file_cabinet_large_static.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self.cwInventory = self.cwInventory or {}
		self.weight = self.weight or 0
		self.cash = self.cwCash or 0

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end


		for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
			if (string.find(v:GetClass(), "prop") and v:GetModel() == "models/props_office/file_cabinet_large_static.mdl") then
				self:SetPos(v:GetPos())
				self:SetAngles(v:GetAngles())
				SafeRemoveEntity(v)

				return
			end
		end
	end

function ENT:SetData(inventory, cash, weight)
	self.cwInventory = inventory;
	self.weight = weight;
end;

function ENT:StartTouch(ent)
		if ent:IsValid() && ent:GetClass() == "cw_item" && git(ent, "baseItem") == "ross_notepad_base" && self.weight != 17 then 
			Clockwork.inventory:AddInstance(self.cwInventory, Clockwork.item:CreateInstance(git(ent, "uniqueID"), nil, git(ent, "data")))
			ent:Remove()
			self:EmitSound("items/ammocrate_open.wav")
			self.weight = math.Clamp(self.weight + git(ent, "weight"), 0, 17);
		end;
end;

-- Called when the entity is removed.
function ENT:OnRemove()
	if (!Clockwork.kernel:IsShuttingDown()) then
		Clockwork.entity:DropItemsAndCash(self.cwInventory, self.cwCash, self:GetPos(), self);
		self.cwInventory = nil;
		self.cwCash = nil;
	end;
end;