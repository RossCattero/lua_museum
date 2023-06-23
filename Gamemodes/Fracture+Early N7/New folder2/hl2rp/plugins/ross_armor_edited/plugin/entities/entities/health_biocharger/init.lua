include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props_combine/health_charger001.mdl"

		self:SetModel(model);
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
	    self:SetUseType(SIMPLE_USE);
		

		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:Sleep();
			physObj:EnableMotion(true);
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

	if (!self.bio || CurTime() >= self.bio) then
		if !self:GetBiomaterial() then

			self:SetBiomaterial(true);

		end;
		self.bio = CurTime() + 10
	end;

end;

function ENT:Use(activator, caller)
	if self:GetBiomaterial() then
		activator:GiveItem(Clockwork.item:CreateInstance('med_biogel'), true);
		self:SetBiomaterial(false);
	end;
end;