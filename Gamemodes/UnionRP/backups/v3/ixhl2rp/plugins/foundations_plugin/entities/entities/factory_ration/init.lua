include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()

	local invalidBoundsMin = Vector(-8, -8, -8)
	local invalidBoundsMax = Vector(8, 8, 8)
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		
		self.FoodInside = {}

		local physObj = self:GetPhysicsObject();
		
		if (!IsValid(physObj)) then
			self:PhysicsInitBox(invalidBoundsMin, invalidBoundsMax)
			self:SetCollisionBounds(invalidBoundsMin, invalidBoundsMax)
		end		

		if (IsValid(physObj)) then
			physObj:EnableMotion(true);
			physObj:Wake()
		end;

		self:SetPacketUp(false)

		self:SetModel(ix.item.list[self.uniqueLevel].model);

		self.level = self.level or 1;
end;

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:StartTouch(ent)
	if table.Count(self.FoodInside) == 4 or self:GetPacketUp() then
		return;
	end;

	if ent:GetClass() == 'ix_item' then
		local itemTable = ent:GetItemTable();
		local uniqueID = itemTable.uniqueID
		local rationItem = self.FoodInside[uniqueID];
		
		if (!rationItem or (rationItem && rationItem < 2)) && itemTable.base == 'base_food' then
			self.FoodInside[uniqueID] = 1 or mc(self.FoodInside[uniqueID] + 1, 0, 2)
			self:EmitSound('physics/cardboard/cardboard_box_impact_hard2.wav')
			ent:Remove();
		end;
	end;
end;

function ENT:OnOptionSelected(player, option, data)
	local char = player:GetCharacter();
	local inv = char:GetInventory()
	if ( option == "Запаковать" && !self:GetPacketUp() ) then

		if inv:HasItem('work_tape') then
			player:SetAction('Запаковываю', 5)
			player:DoStaredAction(self, function()
				self:SetPacketUp(true);
				player:EmitSound('usesound/slot.wav')
			end, 5, function()
				player:SetAction(false)
			end)
		else
			player:Notify('** Мне нечем запаковать этот рацион.')
		end;

	end;
end;