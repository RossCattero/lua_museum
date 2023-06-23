ITEM.name = "Чашка кофе"
ITEM.description = ""
ITEM.model = "models/props_office/coffee_mug_001.mdl"

ITEM.hunger = 0;
ITEM.thirst = 50;
ITEM.sleep = 50;

ITEM.weight = 0.6
ITEM.width = 1;
ITEM.height = 1;

ITEM.uses = 5;

ITEM.foodtype = 'drink'

ITEM.canGarbage = true;

ITEM.postHooks.DrinkDown = function(item, result)
	local ply = item.player;
	local char = ply:GetCharacter()
	local inv = char:GetInventory()

	inv:Add('coffee_cup')
	item:Remove();
end

ITEM.postHooks.DrinkABit = function(item, result)
	local uses = item:GetData('USES', 0);
	local ply = item.player;
	local char = ply:GetCharacter()
	local inv = char:GetInventory()

	
	if uses == 0 or uses == 1 then 
		inv:Add('coffee_cup')
		item:Remove();
	end;
end