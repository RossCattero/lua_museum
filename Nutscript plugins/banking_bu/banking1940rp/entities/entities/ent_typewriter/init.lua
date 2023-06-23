local PLUGIN = PLUGIN;
include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetModel("models/props_c17/cashregister01a.mdl")
	self:DrawShadow(true);
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE);

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then physObj:EnableMotion(false); physObj:Sleep(); end;
end;

function ENT:Use(act)
		local hasFlag = act:getChar():hasFlags(BANKING_WRITER_FLAG)
		if hasFlag then
			netstream.Start(act, 'Banking::OpenWriter')
		else
			act:notify("You don't know how to use it.")
		end;
end;