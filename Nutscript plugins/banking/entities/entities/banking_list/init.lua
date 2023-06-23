include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

local PLUGIN = PLUGIN;

function ENT:Initialize()
	self:SetModel("models/props_lab/monitor01a.mdl")
	self:DrawShadow(true);
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE);

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then 
		physObj:EnableMotion(false); 
		physObj:Sleep(); 
	end;

	nut.rossnpcs.entities[self] = true;
end;

function ENT:Use(act)
	if act:getChar():hasFlags("B") then
		nut.banking.sendData(act,
		function()
			net.Start("nut.banking.bankeer.open")
			net.Send(act)
		end)
	else
		act:notify("You can't access this entity!");
	end
end;