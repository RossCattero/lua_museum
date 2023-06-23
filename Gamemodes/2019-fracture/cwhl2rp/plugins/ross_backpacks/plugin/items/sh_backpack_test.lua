local mc = math.Clamp;
local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "BackPackTest";
ITEM.model = "models/pack/civil/backpack1.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "ross_backpack_base";
ITEM.useText = "Надеть";
ITEM.category = "Рюкзак";
ITEM.additionalWeight = 6;
ITEM.space = 6

ITEM:AddData("Used", false, true);
ITEM:AddData("HoldingItems", {}, true);

function ITEM:CanHolsterWeapon(player, forceHolster, bNoMsg)
	return true;
end;

function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
	return self:GetData("Used")
end;

function GetBackPackSlots(player, value)
	local backpackSlots = player:GetCharacterData("BackpacksComp")
	return backpackSlots[tostring(value)];
end;

function ITEM:AddBackPackToSlot(player, slotNum)
	local backpackSlots = player:GetCharacterData("BackpacksComp")

	if ((backpackSlots["min"] + slotNum) <= backpackSlots["max"]) && isnumber(slotNum) then
		backpackSlots["min"] = math.Clamp(backpackSlots["min"] + slotNum, 0, backpackSlots["max"])
	end;
	return;
end;

function ITEM:OnHandleUnequip(Callback)
	if (self.OnDrop) then
		local menu = DermaMenu();
			menu:SetMinimumWidth(100);
			menu:AddOption("Снять", function()
				Callback("takedown");
			end);
			menu:AddOption("Выбросить", function()
				Callback("drop");
            end);
		menu:Open();
	end;
end;

function ITEM:OnPlayerUnequipped(player, extraData)
	local trace = player:GetEyeTraceNoCursor();
	local items = Clockwork.inventory:GetAsItemsList(player:GetInventory());

	if extraData == "drop" && (player:GetShootPos():Distance(trace.HitPos) <= 192) then
		if player:GetMaxWeight() - self("additionalWeight") < player:GetInventoryWeight() then
			Clockwork.player:Notify(player, "Освободите место, чтобы снять рюкзак.");
			return;
		end;

		local entity = Clockwork.entity:CreateItem(player, self, trace.HitPos);
		if (IsValid(entity)) then
			Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
			player:TakeItem(self, true);
			self:AddBackPackToSlot(player, -self.space)
			self:SetData("Used", false)
			player:SetCharacterData("AddInvSpaceCode", mc(player:GetCharacterData("AddInvSpaceCode") - self("additionalWeight"), 0, 1000))
			player.backpack:Remove()
        end;    
	elseif extraData == "takedown" then

		if player:GetMaxWeight() - self("additionalWeight") < player:GetInventoryWeight() then
			return;
		end;
		if player:GiveItem(self) then
			self:AddBackPackToSlot(player, -self.space)
			self:SetData("Used", false)
			player:SetCharacterData("AddInvSpaceCode", mc(player:GetCharacterData("AddInvSpaceCode") - self("additionalWeight"), 0, 1000))
			player.backpack:Remove()
        end;
    else
        Clockwork.player:Notify(player, "Вы не можете выбросить одежду так далеко!");
        return;
    end;

end;

function ITEM:OnUse(player, itemEntity)

	if !self:GetData("Used") && (GetBackPackSlots(player, "min") + self.space) <= GetBackPackSlots(player, "max") then
		player:CreateBackpackEntity(self.model)
		self:AddBackPackToSlot(player, self.space)
		self:SetData("Used", true);
		player:SetCharacterData("AddInvSpaceCode", mc(player:GetCharacterData("AddInvSpaceCode") + self("additionalWeight"), 0, 1000))
    else
        Clockwork.player:Notify(player, "Этот слот уже чем-то занят.");
        return false;
    end;
    return true;

end;

function ITEM:OnHolster(player, bForced)
end;

function ITEM:OnDrop(player, position) 

end;

function ITEM:CanGiveStorage(player, storageTable)
	if (self:GetData("Used")) then
		Clockwork.player:Notify(player, "Вы не можете положить предмет в хранилище, нося его!");
		return false;
	end;
end;

function ITEM:CanTakeStorage(player, storageTable)
	local target = Clockwork.entity:GetPlayer(storageTable.entity);
	if (target) then
		if (target:GetInventoryWeight() > (target:GetMaxWeight() - self("additionalWeight"))) then
			return false;
		end;
	end;
end;

ITEM:Register();