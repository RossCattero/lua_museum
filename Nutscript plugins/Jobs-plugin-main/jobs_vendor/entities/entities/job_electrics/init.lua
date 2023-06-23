include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

local PLUGIN = PLUGIN;

function ENT:Initialize()
	self:SetModel("models/props/de_nuke/nuclearcontrolbox.mdl")
	self:DrawShadow(true);
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetUseType(SIMPLE_USE);

	self.repairItem = "screw_tool"

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

	local filter = RecipientFilter()
	filter:AddAllPlayers()
	self.LoopingSound = CreateSound(self, "ambient/machines/lab_loop1.wav", filter)
	self.LoopingSound:Play()
end;

function ENT:CreateZap()
		local pos = self:GetPos()
		local e = EffectData()
		e:SetOrigin( pos + self:GetUp() * math.random( 0.1, 0.5 ) )
		e:SetStart( pos )
		e:SetNormal( pos )
		e:SetMagnitude( 2 )
		
		util.Effect( "StunstickImpact", e )
end;

function ENT:Broke(bool)
		if bool then 
			self.LoopingSound:Stop()
			self:EmitSound("ambient/energy/zap"..math.random(1, 3)..".wav")
		else
			self.LoopingSound:Play()
		end;
		self:SetIsBroken(bool)

		if self:GetIsBroken() && !timer.Exists(self:EntIndex() .. " - is broken") then
			local uniqueID = self:EntIndex() .. " - is broken"
			timer.Create(uniqueID, 1, 0, function()
					if !timer.Exists(uniqueID) || !self:IsValid() || !self:GetIsBroken() then timer.Remove(uniqueID) return; end;
					self:EmitSound("ambient/energy/zap"..math.random(1, 3)..".wav")
					self:CreateZap()
			end);
		end;
end;

function ENT:SetWorkPos(id)
		self.workPos = id;
end;

function ENT:OnRemove()
		if self.LoopingSound then
			self.LoopingSound:Stop()
		end
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

		act:EmitSound("physics/metal/metal_box_strain"..math.random(1, 4)..".wav")

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