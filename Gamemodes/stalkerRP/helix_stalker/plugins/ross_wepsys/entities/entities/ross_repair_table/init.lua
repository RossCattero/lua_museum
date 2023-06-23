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

		if !self.itemInside then
			self.itemInside = {}
		end;

		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(true);
			physObj:Wake()
		end;

		self.weaponOnTable = ents.Create("prop_dynamic");
		self.weaponOnTable:SetModel("models/weapons/tfa_ins2/w_akm.mdl");
		self.weaponOnTable:SetPos(self:GetPos() + Vector(-30, -10, 37));
		self.weaponOnTable:SetAngles(self:GetAngles() + Angle(180, -90, 90));
		self.weaponOnTable:SetCollisionGroup( 20 );
		self.weaponOnTable:SetParent(self)
		self.weaponOnTable:Spawn();
		self.weaponOnTable:SetNoDraw(true);

		self.armorOnTable = ents.Create("prop_dynamic");
		self.armorOnTable:SetModel("models/kek1ch/novice_outfit.mdl");
		self.armorOnTable:SetPos(self:GetPos() + Vector(-30, -10, 37));
		self.armorOnTable:SetAngles(self:GetAngles() + Angle(180, -90, 180));
		self.armorOnTable:SetCollisionGroup( 20 );
		self.armorOnTable:SetParent(self)
		self.armorOnTable:Spawn();
		self.armorOnTable:SetNoDraw(true);

		if next(self.itemInside) != nil then
			if self.itemInside.base == 'base_weapons' then
				self.weaponOnTable:SetModel(ent:GetModel());
				self.weaponOnTable:SetNoDraw(false)
			else
				self.armorOnTable:SetModel(ent:GetModel());
				self.armorOnTable:SetNoDraw(false)
			end;
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

local function CountQualityPercent(entity)
	local counted = 0;
	local hundredPercent = 0;
	local data = entity:GetNetVar('data');
	local outInfo, buffer = data['outfit_info'], entity:GetItemTable().outfitInformation

	for k, v in pairs(outInfo) do
		counted = counted + v;
	end;
	for k, v in pairs(buffer) do
		hundredPercent = hundredPercent + v;
	end;
	
	return math.Round((counted * 100)/hundredPercent);
end;

function ENT:StartTouch(ent) -- base_outfit base base_weapons

	if ent:GetClass() == "ix_item" then
		local itemTBL = ent:GetItemTable();
		if table.Count(self.itemInside) == 0 && (itemTBL.base == "base_outfit" or itemTBL.base == "base_weapons") then
			if itemTBL.base == "base_weapons" then
			self.itemInside = {
				name = itemTBL.name,
				weight = itemTBL.weight,
				quality = ent:GetNetVar('data')['WeaponQuality'], 
				class = itemTBL.class,
				model = itemTBL.model,
				type = GetWeaponTFAtype(itemTBL.class),
				base = itemTBL.base
			}
			self.weaponOnTable:SetModel(ent:GetModel());
			self.weaponOnTable:SetNoDraw(false)
			elseif itemTBL.base == "base_outfit" then
				self.itemInside = {
					name = itemTBL.name,
					weight = itemTBL.weight,
					quality = CountQualityPercent(ent),
					qualityTable = ent:GetNetVar('data')["outfit_info"],
					qualityTableBuffer = ent:GetItemTable().outfitInformation,
					class = itemTBL.uniqueID,
					model = itemTBL.model,
					base = itemTBL.base,
					type = itemTBL.armorType
				}
				self.armorOnTable:SetModel(ent:GetModel());
				self.armorOnTable:SetNoDraw(false)
			end;
		ent:Remove();
		end;
	end;
	
end;

function ENT:Use(activator, caller)

	if activator:KeyDown(IN_SPEED) && table.Count(self.itemInside) != 0 then
		if self.itemInside.base == "base_outfit" then
			self.armorOnTable:SetNoDraw(true)
			self.armorOnTable:SetModel("");
			activator:GetCharacter():GetInventory():Add(self.itemInside.class or self.itemInside.uniqueID, 1, {
				outfit_info = self.itemInside["qualityTable"]
			})
		else
			self.weaponOnTable:SetNoDraw(true)
			self.weaponOnTable:SetModel("");
			activator:GetCharacter():GetInventory():Add(self.itemInside.class or self.itemInside.uniqueID, 1, {
				WeaponQuality = self.itemInside["quality"]
			})
		end;
		self.itemInside = {}
		activator:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav")
		return;
	end;

	netstream.Start(activator, "Populate_repair_table", self.itemInside, self)
end;