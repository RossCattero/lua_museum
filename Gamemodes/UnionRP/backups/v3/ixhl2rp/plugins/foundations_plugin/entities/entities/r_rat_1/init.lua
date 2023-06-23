include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props_lab/binderblue.mdl"

		self:SetModel(model);
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetUseType(SIMPLE_USE);

		self.dispenser = ents.Create("prop_dynamic");
		self.dispenser:SetModel("models/props_combine/combine_dispenser.mdl");
		self.dispenser:SetPos(self:GetPos());
		self.dispenser:SetAngles(self:GetAngles() + Angle(0,90,0));
		self.dispenser:SetCollisionGroup( 20 );
		self.dispenser:SetParent(self)
		self.dispenser:Spawn();
			
		self.ration = ents.Create("prop_physics")
		self.ration:SetModel("models/weapons/w_package.mdl");
		self.ration:SetPos(self:GetPos())
		self.ration:SetAngles(self:GetAngles())
		self.ration:SetMoveType(MOVETYPE_NONE)
		self.ration:SetNotSolid(true)
		self.ration:SetNoDraw(true)
		self.ration:SetParent(self.dispenser, 1)
		self.ration:Spawn()
		self.ration:SetCollisionGroup(20)
		self.ration:Activate()
		self:DeleteOnRemove(self.ration)
				
		self:SetLevel(1);

		self.lvltbl = {
			"first_grade_ration",
			"second_grade_ration",
			"third_grade_ration"
		}
		self.ingredientsInside = {
			['paperitem'] = 0,
			['coloritem'] = 0
		}

		for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
			if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
				self:SetPos(v:GetPos());
				self:SetAngles(v:GetAngles());
				SafeRemoveEntity(v);

				return;
			end;
		end;
	end;

function ENT:DecreaseItems()
	local i = self.ingredientsInside;

	for k, v in pairs(i) do
		self.ingredientsInside[k] = mc(self.ingredientsInside[k] - 1, 0, 32);
	end;
end;

function ENT:IncreaseItem(uniqueID)
	if self.ingredientsInside[uniqueID] then
		self.ingredientsInside[uniqueID] = mc(self.ingredientsInside[uniqueID] + 1, 0, 32);
	end;
end;

function ENT:PureWorkable()
	local i = self.ingredientsInside;

	for k, v in pairs(i) do
		if v == 0 then
			return false;
		end;
	end;

	return true;
end;

function ENT:StartTouch(ent)
	
	if ent:GetClass() == 'ix_item' then
		local itemTable = ent:GetItemTable();
		local i = self.ingredientsInside;
		local ingr = i[itemTable.uniqueID];
		if ingr && ingr < 32 then
			self:IncreaseItem(itemTable.uniqueID)
			self:EmitSound('items/ammocrate_open.wav')
			ent:Remove();

			self:SetWorkable(self:PureWorkable())
		end;
	end;
end;

function ENT:Use(activator, caller)
	local lvl = self:GetLevel();
	local d = self.dispenser

	if !self:PureWorkable() then
		return; 
	end;

	if (self.ChangeType && self.ChangeType >= CurTime()) then
		return;
	end;

	local char = activator:GetCharacter();
	local inv = char:GetInventory()
	
		if activator:KeyDown( IN_SPEED ) && inv:HasItem('factory_card') then
		self:SetLevel(mc(self:GetLevel() + 1, 1, 3))
		self:EmitSound('buttons/button9.wav')
		if lvl == 3 then
			self:SetLevel(1)
		end;

		self.ChangeType = CurTime() + 1
		return;
	end;

	if !self.SpawnItemCoolDown or self.SpawnItemCoolDown <= CurTime() then
		self.ration:SetNoDraw(false)
		self.ration:SetModel(ix.item.list[self.lvltbl[lvl]].model)
		self.ration:Fire("SetParentAttachment", "package_attachment", 0);
		d:EmitSound("ambient/machines/combine_terminal_idle2.wav");
		d:Fire("SetAnimation", "dispense_package", 0);

		self:DecreaseItems()

		self:SetWorkable(self:PureWorkable())

		timer.Simple(1.5, function()
			if !IsValid(self) then return; end;

			local spawnration = ents.Create('factory_ration')
			spawnration.uniqueLevel = self.lvltbl[lvl];
			spawnration.level = lvl
			spawnration:SetModel(ix.item.list[self.lvltbl[lvl]].model)
			spawnration:SetPos(self.ration:GetPos());
			spawnration:SetAngles(self.ration:GetAngles());
			spawnration:Spawn();

			self.ration:SetNoDraw(true)
		end)

		self.SpawnItemCoolDown = CurTime() + 3
	end;

end;