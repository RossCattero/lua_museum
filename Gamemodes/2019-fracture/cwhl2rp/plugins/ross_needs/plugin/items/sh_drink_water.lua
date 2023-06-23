local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Простая вода";
ITEM.model = "models/props_nunk/popcan01a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "drink_simple_water";
ITEM.foodtype = 2;
ITEM.hasgarbage = true;

ITEM.portions = 5;
ITEM.dthirst = 5;

ITEM:Register();