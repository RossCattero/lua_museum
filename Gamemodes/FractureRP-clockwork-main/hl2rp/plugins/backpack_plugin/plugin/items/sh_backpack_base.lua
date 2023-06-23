local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "База рюкзаков";
ITEM.model = "models/pack/civil/backpack3.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "backpack_base_ross";
ITEM.category = "Рюкзаки";
ITEM.useSound = 'items/ammopickup.wav'
ITEM.backpackSlot = 0;

ITEM.addWeight = 0;
ITEM.addSlots = 0;

ITEM:AddData("Used", false, true)

function ITEM:OnHandleUnequip(Callback)

	if (self.OnDrop) then
		local menu = DermaMenu();
		menu:SetMinimumWidth(100);
		menu:AddOption("Снять", function()
			Callback("takedown");
        end);
		menu:Open();
	end;

end;
function ITEM:OnPlayerUnequipped(player, extraData)
	local bpTBL = player:GetCharacterData('BackPackTable');
	local clInfo = player:GetCharacterData('AdditionalClothesInfo');

	if extraData == "takedown" then

		if ( player:GetInventoryWeight() < (player:GetMaxWeight() - self("addWeight")) ) then
			self:SetData("Used", false);

			clInfo['incWeight'] = clInfo['incWeight'] - self.addWeight
			clInfo['incSpace'] = clInfo['incSpace'] - self.addSlots
			bpTBL['OccNum'] = math.Clamp(bpTBL['OccNum'] - self.backpackSlot, 0, bpTBL['NonOccNum'])
		end;
	end;
end;

function ITEM:OnUse(player, itemEntity)
	local bpTBL = player:GetCharacterData('BackPackTable');
	local clInfo = player:GetCharacterData('AdditionalClothesInfo');

	if bpTBL['OccNum'] + self.backpackSlot <= bpTBL['NonOccNum'] then
		self:SetData("Used", true);
		bpTBL['OccNum'] = math.Clamp(bpTBL['OccNum'] + self.backpackSlot, 0, bpTBL['NonOccNum'])
		clInfo['incWeight'] = clInfo['incWeight'] + self.addWeight
		clInfo['incSpace'] = clInfo['incSpace'] + self.addSlots
	elseif bpTBL['OccNum'] + self.backpackSlot > bpTBL['NonOccNum'] then
		Clockwork.player:Notify(player, "Вы не можете надеть больше!");
		return false;
	end;

	return true;
end;

function ITEM:OnDrop(player, position) end;

function ITEM:CanGiveStorage(player, storageTable)
	if (self:IsUsed()) then
		Clockwork.player:Notify(player, "Вы не можете положить предмет в хранилище, нося его!");
		return false;
	end;
end;
function ITEM:CanTakeStorage(player, storageTable)
	local target = Clockwork.entity:GetPlayer(storageTable.entity);
	if (target) then
		if (target:GetInventoryWeight() > (target:GetMaxWeight() - self("addWeight"))) then
			return false;
		end;
	end;
end;

function ITEM:IsUsed()
    return self:GetData("Used");
end;
function ITEM:CanHolsterWeapon(player, forceHolster, bNoMsg)
	return true;
end;
function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
	return self:IsUsed()
end

ITEM:Register();