local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Сладкая газировка";
ITEM.model = "models/props_cunk/popcan01a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "drink_sugar_soda";
ITEM.foodtype = 2;
ITEM.hasgarbage = true;

ITEM.portions = 5;
ITEM.dthirst = 15;

ITEM:Register();