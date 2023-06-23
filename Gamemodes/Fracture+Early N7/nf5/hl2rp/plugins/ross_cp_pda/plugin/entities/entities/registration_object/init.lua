include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props_combine/breenconsole.mdl"

		self:SetModel(model);
		
		-- Для нестатичного.
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


		for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
			if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
				self:SetPos(v:GetPos());
				self:SetAngles(v:GetAngles());
				SafeRemoveEntity(v);

				return;
			end;
		end;
	end;

function ENT:Think()
	if self:GetAlert() then
		if (!self.alertt or CurTime() >= self.alertt) then
			self:EmitSound("ambient/alarms/klaxon1.wav")
			self.alertt = CurTime() + 1;
		end;
	end;
end;

function ENT:Use(activator, caller)
	if !Schema:PlayerIsCombine(activator) then
		self:SetAlert(true);
		return;
	end;
	if self:GetAlert() then
		self:SetAlert(false);
	end;
	cable.send(activator, 'OpenRegistrationObject', Schema.avaiblePDAs, CP_PDA.CivilProtectionChat);
end;