include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

local PLUGIN = PLUGIN;

function ENT:Initialize()
	self:SetModel(PLUGIN.modelList[math.random(1, #PLUGIN.modelList)])
	self:DrawShadow(true);
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetUseType(SIMPLE_USE);

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then 
			physObj:EnableMotion(false); 
			physObj:Sleep(); 
	end;

	self:ResetSequence( "LineIdle01" )

	if !self.spawned then
		timer.Simple(0, function()
				self:SetPos(self:GetPos() - Vector(0, 0, 4.5))
				self.spawned = true;
		end)
	end;

	BANKING_ENTS[self] = {
			class = self:GetClass(),
			position = self:GetPos(),
			angles = self:GetAngles()
	}
end;

function ENT:Think()
		self:NextThink( CurTime() )
		return true
end

function ENT:Use(act)
		if act:HasBankingAccount() then
			act:ReceiveBankingInfo()
			netstream.Start(act, 'Banking::StartTalk')

			BANKING_LOGS:AddLog(act:GetName(), "Accessed the NPC talker")
		else
			act:notify("You don't have a banking account to talk with me.")
		end;
end;

function ENT:OnRemove()
	BANKING_ENTS[self] = nil;
end;