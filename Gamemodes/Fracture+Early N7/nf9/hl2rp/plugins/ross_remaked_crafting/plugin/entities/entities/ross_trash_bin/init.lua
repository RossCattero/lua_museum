include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/container_m.mdl"

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

function ENT:StartTouch(ent)
	if ent:IsValid() && ent:GetClass() == 'cw_item' && self:GetBodygroup(1) == 1 then
		ent:Remove();
	end;
end;

function ENT:Use(activator, caller)
	local c = CurTime();
	if (!self.open || c >= self.open) then
		
		if self:GetBodygroup(1) == 0 then
			self:SetBodygroup(1, 1);
			self:EmitSound('doors/default_move.wav')
		else 
			self:SetBodygroup(1, 0);
			self:EmitSound('doors/default_stop.wav')
		end;

		self.open = c + 0.5;
	end;
end;