include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/maxofs2d/button_05.mdl"

		self:SetModel(model);
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetSolid(SOLID_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
	
		self.spawnItem = ents.Create("prop_dynamic");
		self.spawnItem:SetModel("models/hunter/blocks/cube025x025x025.mdl");
		self.spawnItem:SetPos(self:GetPos() + Vector(25, 0, 0));
		self.spawnItem:SetAngles(self:GetAngles());
		self.spawnItem:SetCollisionGroup( 20 );
		self.spawnItem:SetSolid(SOLID_BBOX);
	    self.spawnItem:PhysicsInit(SOLID_BBOX);
		self.spawnItem:SetMoveType(MOVETYPE_NONE)
		self.spawnItem.level = 1;
		self.spawnItem.type = "ration";
		self.spawnItem.inside = {
			[1] = {
				ration = "ration_default",
				water = "drink_simple_water",
				food = "food_ration_simple"
			},
			[2] = {
				ration = "ration_second_better",
				water = "drink_soda",
				food = "food_ration_porridge"
			},
			[3] = {
				ration = "ration_loyal_tier",
				water = "drink_sugar_soda",
				food = "food_ration_loyal"
			}
		}
		self.spawnItem:Spawn();
		self.spawnItem:DeleteOnRemove(self);

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

function ENT:Use(player, caller)
	if player:KeyDown( IN_SPEED ) && Clockwork.player:IsAdmin(player) then
		self.spawnItem.level = math.Clamp(self.spawnItem.level + 1, 1, 4)
		if self.spawnItem.level == 4 then
			self.spawnItem.level = 1;
		end;
		Clockwork.chatBox:SendColored(player, "Уровень: "..self.spawnItem.level)
		return;
	end;
	if player:KeyDown( IN_DUCK ) && Clockwork.player:IsAdmin(player) then
		if self.spawnItem.type == "ration" then
			self.spawnItem.type = "water"
		elseif self.spawnItem.type == "water" then
			self.spawnItem.type = "food"
		elseif self.spawnItem.type == "food" then
			self.spawnItem.type = "ration"	
		end;
		Clockwork.chatBox:SendColored(player, "Тип: "..self.spawnItem.type)
		return;
	end;

	if Clockwork.kernel:GetSharedVar("RationPhase") == 0 then
		self:EmitSound("buttons/combine_button_locked.wav")
		return;
	end;

	local foodtype = self.spawnItem.inside[self.spawnItem.level][self.spawnItem.type];

	if !self.spawnTime || CurTime() >= self.spawnTime then
		if self.spawnItem.type == "ration" then
			local ration_packet = ents.Create("ross_ration_pack");
			ration_packet:SetAngles( self.spawnItem:GetAngles() );
			ration_packet:SetPos(self.spawnItem:GetPos() + Vector(0,0,-10));
			ration_packet:SetModel(Clockwork.item:FindByID(foodtype).model)
			ration_packet.uniqueLevel = foodtype;
			ration_packet:Spawn();		
			local physObj = ration_packet:GetPhysicsObject();
			
			if (IsValid(physObj)) then
				physObj:EnableMotion(true);
				physObj:Wake();
			end;		
		elseif self.spawnItem.type == "food" || self.spawnItem.type == "water" then
			local itemTable = Clockwork.item:CreateInstance(foodtype);
			Clockwork.entity:CreateItem(player, itemTable, self.spawnItem:GetPos() + Vector(0,0,-10), self.spawnItem:GetAngles());
		end;
		self.spawnTime = CurTime() + 2;
	end;
	
end;