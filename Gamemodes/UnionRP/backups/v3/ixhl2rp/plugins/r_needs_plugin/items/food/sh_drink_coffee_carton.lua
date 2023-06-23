ITEM.name = "Стаканчик кофе"
ITEM.description = ""
ITEM.model = "models/union/props/shibcuppyhold.mdl"

ITEM.hunger = 0;
ITEM.thirst = 45;
ITEM.sleep = 0;

ITEM.weight = 0.3
ITEM.width = 1;
ITEM.height = 1;

ITEM.uses = 5;

ITEM.foodtype = 'drink'

ITEM.canGarbage = true;

ITEM.postHooks.DrinkDown = function(item, result)
	local ply = item.player;
	local char = ply:GetCharacter()
	local inv = char:GetInventory()

	inv:Add('coffee_prop')
	item:Remove();
end

ITEM.postHooks.DrinkABit = function(item, result)
	local uses = item:GetData('USES', 0);
	local ply = item.player;
	local char = ply:GetCharacter()
	local inv = char:GetInventory()

	
	if uses == 0 or uses == 1 then 
		inv:Add('coffee_prop')
		item:Remove();
	end;
end