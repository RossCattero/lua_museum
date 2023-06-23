include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/mosi/fallout4/furniture/workstations/workshopbench.mdl"

		self:SetModel(model);
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		
		self.weaponOnTable = ents.Create("prop_dynamic");
		self.weaponOnTable:SetModel("models/weapons/tfa_ins2/w_akm.mdl");
		self.weaponOnTable:SetPos(self:GetPos() + Vector(-30, -10, 37));
		self.weaponOnTable:SetAngles(self:GetAngles() + Angle(180, -90, 90));
		self.weaponOnTable:SetCollisionGroup( 20 );
		self.weaponOnTable:SetParent(self)
		self.weaponOnTable:Spawn();

		self.weaponOnTable:SetNoDraw(true);

		self.Instruments = ents.Create("prop_dynamic");
		self.Instruments:SetModel("models/devcon/mrp/props/red_cargo_2.mdl");
		self.Instruments:SetPos(self:GetPos() + Vector(-35, -10, 20));
		self.Instruments:SetAngles(self:GetAngles());
		self.Instruments:SetCollisionGroup( 20 );
		self.Instruments:SetParent(self)
		self.Instruments:Spawn(); 

		self.Instruments:SetNoDraw(true);

		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(true);
			physObj:Wake()
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


function ENT:InsideWeaponCheck()
	if self:GetweaponUID() != '' then
		return true;
	end;
	return false;
end;

function ENT:CleanWeaponTables()
	self.weaponOnTable:SetNoDraw( true );

	self:SetweaponUID( '' );
	self:SetweaponItemID( '' );
	self:SetQuality( 0 );
end;

function ENT:CleanKitTables()
	self.Instruments:SetNoDraw(true);

	self:SetHasInstruments(false);
	self:SetRepairQuality(0);
end;

function ENT:StartTouch(ent)
	
	if ent:GetClass() == "cw_item" then
		if git(ent, "baseItem") == 'weapon_base' && !self:InsideWeaponCheck() && !git(ent, 'data')['Mag'] then

			self.weaponOnTable:SetModel( git(ent, "model") );
			self:SetweaponUID( git(ent, 'uniqueID') );
			self:SetweaponItemID( git(ent, 'itemID') );
			self:SetQuality( git(ent, 'data')['Quality'] );

			self.weaponOnTable:SetNoDraw(false);
			ent:Remove();
		end;
		if git(ent, 'uniqueID') == 'repair_kit_table' && git(ent, 'data')['RepQua'] > 0 && !self:GetHasInstruments() then

			self:SetHasInstruments(true);
			self:SetRepairQuality( git(ent, 'data')['RepQua'] );
			self.Instruments:SetNoDraw(false);

			ent:Remove();
		end;
	end;

end;

function ENT:Use(activator, caller)
end;