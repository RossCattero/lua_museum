include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props_office/coffeemachine.mdl"

		self:SetModel(model);
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
	    self:SetUseType(SIMPLE_USE);
		
		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(true);
			physObj:Wake()
		end;

		self.coffeePlace = ents.Create("prop_dynamic");
		self.coffeePlace:SetModel("models/union/props/shibcuppyhold.mdl");
		self.coffeePlace:SetPos(self:GetPos() + Vector(12, -5, 5));
		self.coffeePlace:SetAngles(self:GetAngles() + Angle(0, 90, 0));
		self.coffeePlace:SetCollisionGroup( 20 );
		self.coffeePlace:SetParent(self)
		self.coffeePlace:Spawn();
		self.coffeePlace:SetNoDraw(true);

		self.coffeeCupPlace = ents.Create("prop_dynamic");
		self.coffeeCupPlace:SetModel("models/props_office/coffee_mug_001.mdl");
		self.coffeeCupPlace:SetPos(self:GetPos() + Vector(12, -5, 2.6));
		self.coffeeCupPlace:SetAngles(self:GetAngles() + Angle(0, 90, 0));
		self.coffeeCupPlace:SetCollisionGroup( 20 );
		self.coffeeCupPlace:SetParent(self)
		self.coffeeCupPlace:Spawn();
		self.coffeeCupPlace:SetNoDraw(true);

		self:SetHasACup(false)
		self:SetTurnedOn(false)
		self:SetCoffeeReady( false )

		for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
			if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
				self:SetPos(v:GetPos());
				self:SetAngles(v:GetAngles());
				SafeRemoveEntity(v);

				return;
			end;
		end;
	end;

function ENT:StartTouch(entity)

	if entity:GetClass() == 'ix_item' && !self:GetHasACup() then
		local item = entity:GetItemTable()

		if item.uniqueID == 'coffee_prop' then
			self.coffeePlace:SetModel(entity:GetModel())
			self.coffeePlace:SetNoDraw(false)
			entity:Remove();
			self:SetHasACup(true);
			self:EmitSound('physics/cardboard/cardboard_box_impact_soft1.wav')
		elseif item.uniqueID == 'coffee_cup' then
			self.coffeeCupPlace:SetModel(entity:GetModel())
			self.coffeeCupPlace:SetNoDraw(false)
			entity:Remove();
			self:SetHasACup(true);
			self:EmitSound('physics/plaster/ceiling_tile_impact_hard3.wav')
		end;
	end;

end;

function ENT:Use(activator)
	if !self:GetTurnedOn() && self:GetHasACup() && !self:GetCoffeeReady() then
		self:SetTurnedOn(true);
		self:EmitSound('buttons/button1.wav')
		local loopingsound = self:StartLoopingSound('ambient/machines/engine1.wav')

		timer.Create(self:EntIndex() .. '- Coffee machine', 10, 1, function()
			if self:IsValid() then
				self:StopLoopingSound(loopingsound)
				self:SetTurnedOn(false)
				self:SetCoffeeReady( true )

				self:EmitSound('ambient/water/water_spray1.wav')
			end;
		end)
	end;

	if self:GetCoffeeReady() then
		local char = activator:GetCharacter();
		local inv = char:GetInventory();

		if !self.coffeePlace:GetNoDraw() then
			inv:Add('drink_coffee_carton')
			self.coffeePlace:SetNoDraw(true)
		elseif !self.coffeeCupPlace:GetNoDraw() then
			inv:Add('drink_coffee_cup')
			self.coffeeCupPlace:SetNoDraw(true)
		end;

		self:SetCoffeeReady( false )
		self:SetHasACup( false )
	end;
end;