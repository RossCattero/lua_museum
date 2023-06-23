include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

local PLUGIN = PLUGIN;

function ENT:Initialize()
	self:SetModel("models/Police.mdl")
	self:DrawShadow(true);
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetUseType(SIMPLE_USE);

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then physObj:EnableMotion(true); physObj:Wake(); end;

	self:ResetSequence( "Batonidle1" )

	for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
			self:SetPos(v:GetPos());
			self:SetAngles(v:GetAngles());
			SafeRemoveEntity(v);
			return;
		end;
	end;

	if !self.spawned then
		timer.Simple(0, function()
				self:SetPos(self:GetPos() - Vector(0, 0, 4.5))
				self.spawned = true;
		end)
	end;
end;

function ENT:Think()
		self:NextThink( CurTime() )
		return true
end

function ENT:Use(act)
		if self.useCD && self.useCD > CurTime() then
				return;
		end

		self.useCD = CurTime() + 2;


		if act:CanAskTaxi() then
				netstream.Start(act, 'taxi::openInterface')
		else
				netstream.Start(act, 'taxi:dismiss')
		end;
end;