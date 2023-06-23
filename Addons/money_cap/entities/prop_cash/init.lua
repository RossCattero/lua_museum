local PLUGIN = PLUGIN;
include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	
	self:SetModel(MOD.model);
	self:DrawShadow(true);
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE);
	self:SetCollisionGroup(15)

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then physObj:EnableMotion(true); physObj:Wake(); end;

	self.money = 0;
end;

function ENT:Use( user )
		if self.money && self.money > 0 then
				user:addMoney( self.money )				
				self.money = 0;
		end
			
		user:EmitSound( "physics/body/body_medium_impact_soft" .. math.random(3, 5) .. ".wav" )
		self:Remove();
end;