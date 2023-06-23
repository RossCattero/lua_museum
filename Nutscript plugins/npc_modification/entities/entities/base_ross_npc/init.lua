include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then 
		physObj:EnableMotion(false); 
		physObj:Sleep(); 
	end;

	if !self.spawned then
		timer.Simple(0, function()
			self:SetPos(self:GetPos() - Vector(0, 0, 4.5))
			self.spawned = true;
		end)
	end;

	nut.rossnpcs.entities[ self ] = true;

	self:SetData()
end;

function ENT:SetData( data )
	self.data = data or {};
	self.data.model = self.data.model or "models/Humans/Group01/male_02.mdl"
	self.data.name = self.data.name or "John Doe"
	self.data.sequence = self.data.sequence or 4
	if self.OnSetData then
		self:OnSetData()
	end;
	self:setNetVar("data", self.data)
	
	self:SetModel(self.data.model)
	self:ResetSequence( self.data.sequence )
	self:DrawShadow(true);
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetUseType(SIMPLE_USE);
end;

function ENT:Think()
	self:NextThink( CurTime() )
	return true
end