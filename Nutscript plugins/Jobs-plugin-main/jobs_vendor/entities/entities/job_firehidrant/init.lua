local PLUGIN = PLUGIN;
include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");
PrecacheParticleSystem( "WaterSurfaceExplosion" )

function ENT:Initialize()
	self:SetModel("models/props/cs_assault/firehydrant.mdl")
	self:DrawShadow(true);
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetUseType(SIMPLE_USE);

	self.repairItem = "wrench_tool"

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
end;

function ENT:WaterSplash(scale)
		local pos = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetScale( scale )
		effectdata:SetFlags( 0 )
		util.Effect( "WaterSplash", effectdata, true, true )
end;

function ENT:Broke(bool)
		self:SetIsBroken(bool)

		if self:GetIsBroken() && !timer.Exists(self:EntIndex() .. " - is broken") then
			self:EmitSound("physics/metal/metal_barrel_impact_hard7.wav")

			timer.Simple(2, function()
					self:WaterSplash( 1024 )

					local uniqueID = self:EntIndex() .. " - is broken"
					timer.Create(uniqueID, 1, 0, function()					
							if !timer.Exists(uniqueID) || !self:IsValid() || !self:GetIsBroken() then timer.Remove(uniqueID) return; end;
							self:WaterSplash( 16 )
					end)
			end)
		end
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

		act:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1,3)..".wav")

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