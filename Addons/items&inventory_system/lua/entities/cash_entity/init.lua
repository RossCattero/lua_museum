include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()
		self:SetModel("models/props_lab/box01a.mdl")
		self:DrawShadow(true);
		self:SetSolid(SOLID_BBOX);
		self:PhysicsInit(SOLID_BBOX);
		self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		self:SetCollisionGroup(20)

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then
		physObj:EnableMotion(true);
		physObj:Wake();
	end;
end;

function ENT:Use(player) 
	player:SetCash( math.Clamp(player:GetCash() + self.cashAmount or 0, 0, 10000) );
	self:Remove();
end;