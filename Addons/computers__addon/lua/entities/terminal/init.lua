include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetModel(self:GetDefaultModel())
	self:DrawShadow(true);
	self:SetSolid(SOLID_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetUseType(SIMPLE_USE);

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then
		physObj:EnableMotion(false);
		physObj:Sleep();
	end;

	self.terminalIndex = os.time() + math.random(100, 1000);
	self.isUsed = false;
	self.isLoggedIn = false;
	if !Terminals[self.terminalIndex] then
		Terminals[self.terminalIndex] = {
			username = "",
			password = "",
			logs = {}
		}
	end
	self:SetTerminalIndex(self.terminalIndex)
	self:SetNeedLogin(string.len(Terminals[self.terminalIndex]['username']) > 0 && string.len(Terminals[self.terminalIndex]['password']) > 0);

	for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == self:GetDefaultModel()) then
			self:SetPos(v:GetPos());
			self:SetAngles(v:GetAngles());
			SafeRemoveEntity(v);

			return;
		end;
	end;
end;

function ENT:Use(act)
	if !self.isUsed then
		local massive 	= Terminals[self.terminalIndex]
		local logs 		= massive['logs'];
		netstream.Start( act, "createTerminal", logs )

		self.isUsed = true;
	end;
end;

function ENT:OnRemove()
	Terminals[self.terminalIndex] = nil;
end;