include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props_c17/furnitureStove001a.mdl"

		self:SetModel(model);
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetUseType(SIMPLE_USE);

		self.inventoryInside = {
			pan = {},
			pot = {},
			littlepot = {},
			teapot = {}
		};

		self.konforka1 = ents.Create("prop_dynamic");
		self.konforka1:SetModel("models/props_interiors/pot01a.mdl");
		self.konforka1:SetPos(self:GetPos() + Vector(3, -12, 25));
		self.konforka1:SetAngles(self:GetAngles());
		self.konforka1:SetCollisionGroup( 20 );
		self.konforka1:SetParent(self)
		self.konforka1:Spawn();
		self.konforka1:SetNoDraw(true);

		self.konforka2 = ents.Create("prop_dynamic");
		self.konforka2:SetModel("models/props_c17/metalPot001a.mdl");
		self.konforka2:SetPos(self:GetPos() + Vector(3, 11, 25));
		self.konforka2:SetAngles(self:GetAngles());
		self.konforka2:SetCollisionGroup( 20 );
		self.konforka2:SetParent(self)
		self.konforka2:Spawn();
		self.konforka2:SetNoDraw(true);

		self.konforka3 = ents.Create("prop_dynamic");
		self.konforka3:SetModel("models/props_c17/metalPot002a.mdl");
		self.konforka3:SetPos(self:GetPos() + Vector(-10.5, -16, 21.5));
		self.konforka3:SetAngles(self:GetAngles() + Angle(0, 90, 0));
		self.konforka3:SetCollisionGroup( 20 );
		self.konforka3:SetParent(self)
		self.konforka3:Spawn();
		self.konforka3:SetNoDraw(true);

		self.konforka4 = ents.Create("prop_dynamic");
		self.konforka4:SetModel("models/props_interiors/pot02a.mdl");
		self.konforka4:SetPos(self:GetPos() + Vector(-10, 6, 23));
		self.konforka4:SetAngles(self:GetAngles());
		self.konforka4:SetCollisionGroup( 20 );
		self.konforka4:SetParent(self)
		self.konforka4:Spawn();
		self.konforka4:SetNoDraw(true);

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
	if ent:IsValid() && ent:GetClass() == "cw_item" && !self:GetGasCan() && self:GetFuel() == 0 && git(ent, "uniqueID") == "gas_fuel_tank" then 
		self:SetGasCan(true);
		self:SetFuel(git(ent, "data")["Fuel"])
		self:EmitSound("physics/metal/metal_barrel_impact_hard1.wav")
		ent:Remove();
	end;

	if ent:IsValid() && ent:GetClass() == "cw_item" then
		if git(ent, "uniqueID") == "frying_pan" && self.konforka3:GetNoDraw() == true then
			
			self:EmitSound("physics/metal/metal_barrel_impact_hard7.wav")
			self.konforka3:SetNoDraw(false);
			ent:Remove();
		elseif git(ent, "uniqueID") == "tea_pot" && self.konforka1:GetNoDraw() == true then
			
			self:EmitSound("physics/metal/metal_barrel_impact_hard7.wav")
			self.konforka1:SetNoDraw(false);
			ent:Remove();
		elseif git(ent, "uniqueID") == "big_potty" && self.konforka2:GetNoDraw() == true then
			
			self:EmitSound("physics/metal/metal_barrel_impact_hard7.wav")
			self.konforka2:SetNoDraw(false);
			ent:Remove();
		elseif git(ent, "uniqueID") == "little_potty" && self.konforka4:GetNoDraw() == true then
			
			self:EmitSound("physics/metal/metal_barrel_impact_hard7.wav")
			self.konforka4:SetNoDraw(false);	
			ent:Remove();
		end;
	end;
end;

function ENT:Use(activator, caller)
end;