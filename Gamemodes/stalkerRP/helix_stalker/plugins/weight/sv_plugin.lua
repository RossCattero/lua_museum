function ix.weight.CalculateWeight(character) -- Calculates the total weight of all items a character is carrying.
	local inventory = character:GetInventory()

	local weight = 0

	for i, v in pairs(inventory:GetItems()) do
		if (v:GetWeight()) then
			weight = weight + v:GetWeight()
		end
	end
	return weight
end

function PLUGIN:OnCharacterCreated(client, character)
    character:SetData("additionalWeight", 0)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()

    if (IsValid(client)) then
        character:SetData("additionalWeight", character:GetData('additionalWeight'))
    end
end

function PLUGIN:CharacterLoaded(character) -- This is just a safety net to make sure the carry weight data is up-to-date.
	character:SetData("carry", ix.weight.CalculateWeight(character))
end

function PLUGIN:CanTransferItem(item, old, inv) -- When a player attempts to take an item out of a container.
	if (inv.owner and item:GetWeight() and (old and old.owner != inv.owner)) then
		local character = ix.char.loaded[inv.owner]

		if (!character:CanCarry(item)) then
			character:GetPlayer():NotifyLocalized("You are carrying too much weight to take that.")
			return false
		end
	end
end

function PLUGIN:OnItemTransferred(item, old, new)
	if (item:GetWeight()) then
		if (old.owner and !new.owner) then -- Removing item from inventory.
			ix.char.loaded[old.owner]:RemoveCarry(item)
		elseif (!old.owner and new.owner) then -- Adding item to inventory.
			ix.char.loaded[new.owner]:AddCarry(item)
		elseif old.owner && new.owner && new['vars'].isBag then
			local inv = old:GetOwner():GetCharacter():GetInventory()
			inv:HasItem(new['vars'].isBag):SetData('weight', math.Clamp(inv:HasItem(new['vars'].isBag):GetData('weight', 0.1) + item:GetWeight(), 0, 10000))
		elseif old.owner && new.owner && old['vars'].isBag then
			local inv = old:GetOwner():GetCharacter():GetInventory()
			inv:HasItem(old['vars'].isBag):SetData('weight', math.Clamp(inv:HasItem(old['vars'].isBag):GetData('weight', 0.1) - item:GetWeight(), 0, 10000))
		end
	end
end

function PLUGIN:InventoryItemAdded(old, new, item)
	if (item:GetWeight()) then
		if (!old and new.owner) then -- When an item is directly created in their inventory.
			ix.char.loaded[new.owner]:AddCarry(item)
		end
	end
end

function PLUGIN:CanPlayerTakeItem(client, item)
	local character = client:GetCharacter()

	local itm = item:GetItemTable()

	if (itm:GetWeight()) then
		if (!character:CanCarry(itm)) then
			client:NotifyLocalized("You are carrying too much weight to pick that up.")
			return false
		end
	end
end