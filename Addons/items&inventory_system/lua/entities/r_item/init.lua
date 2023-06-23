include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:SetItemTable(itemTable)
	if !self.itemTable then self.itemTable = {}; end;
	self.itemTable = itemTable
end;

function ENT:Initialize()
		self:SetModel(self.itemTable['model'])
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

function ENT:Use(player) end;
