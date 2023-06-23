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

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then physObj:EnableMotion(true); physObj:Wake(); end;

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

function ENT:SetWorkPos(uniqueID, id)
		self.workPos = id;
		self.workName = uniqueID
end;

function ENT:Broke()
		self.LoopingSound:Stop()
		self:SetIsBroken(true)
		self:EmitSound("ambient/energy/zap"..math.random(1, 3)..".wav")

		local uniqueID = self:EntIndex() .. " - is broken"
		timer.Create(uniqueID, 1, 0, function()
				if !timer.Exists(uniqueID) || !self:IsValid() || !self:GetIsBroken() then timer.Remove(uniqueID) return; end;
				self:EmitSound("ambient/energy/zap"..math.random(1, 3)..".wav")
				self:CreateZap()
		end);
end;

function ENT:OnRemove()
		if self.LoopingSound then
			self.LoopingSound:Stop()
		end

		local list = PLUGIN.jobPoses;
		local id, uniqueID = self.workPos, self.workName

		if id && uniqueID && list && list[uniqueID] && list[uniqueID][id] then
				PLUGIN.jobPoses[uniqueID][id] = nil;
				PLUGIN:ListRefresh(uniqueID);
		end
end;