include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

local PLUGIN = PLUGIN;

function ENT:Initialize()
	self:SetMaterial(unBrokenMat)
	self:SetModel("models/props_phx/construct/plastic/plastic_panel1x1.mdl")
	self:SetMaterial("Models/effects/vol_light001")
	self:DrawShadow(false);
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetUseType(SIMPLE_USE);
	self:SetCollisionGroup(11)
	self:SetIsBroken(false)

	self.repairItem = "shovel_tool"

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then physObj:EnableMotion(false); physObj:Sleep(); end;

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

function ENT:Broke(bool)
	self:SetCollisionGroup(bool && 0 || 11)
	self:SetMaterial(bool && brokenMat || unBrokenMat)
	self:SetIsBroken(bool)
end;

function ENT:SetWorkPos(id)
		self.workPos = id;
end;

function ENT:Use(act)
		if !self:GetIsBroken() then
				act:notify("This entity is not broken.")
				return;
		end

		local trace = act:GetEyeTraceNoCursor()
		local char = act:getChar();
		local items = char:getInv():getItemsOfType(self.repairItem)

		if trace.Entity != self then 
			act:notify("You don't look on exact entity!")
			return 
		end;

		if #items == 0 then
				act:notify("You don't have an item to repair this entity!")
				return;
		end

		act:EmitSound("ambient/materials/rock5.wav")

		act:setActionMoving("Repairing the entity...", 5, 
		function() 
				if self:GetIsBroken() then
						act:FinishJob( self.workPos )
						self:Broke(false)
				end
		end, function(usr)
				local trace = usr:GetEyeTraceNoCursor()
				local char = usr:getChar();
				local items = char:getInv():getItemsOfType(self.repairItem)
				return trace.Entity == self && #items > 0
		end)
end;