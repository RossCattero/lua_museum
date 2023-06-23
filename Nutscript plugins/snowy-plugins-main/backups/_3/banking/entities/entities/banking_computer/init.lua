include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

local PLUGIN = PLUGIN;

function ENT:Initialize()
	self:SetModel("models/props_lab/monitor02.mdl")
	self:SetSkin(1)
	self:DrawShadow(true);
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE);

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then 
			physObj:EnableMotion(false); 
			physObj:Sleep(); 
	end;

	for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
			self:SetPos(v:GetPos());
			self:SetAngles(v:GetAngles());
			SafeRemoveEntity(v);
			return;
		end;
	end;
end;

function ENT:Use(act)
		if act:getChar():hasFlags("B") then
				local data = pon.encode({PLUGIN.bankingAccounts, PLUGIN.generalFund})
				netstream.Start(act, "bank::openBanking", data)
				PLUGIN:BankingLog("Access to banking data", act:Name(), 1);
		else
				act:notify("You don't know the password to access to the banking database.")
		end
end;