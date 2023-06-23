local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Газировка";
ITEM.model = "models/props_lunk/popcan01a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "drink_soda";
ITEM.foodtype = 2;
ITEM.hasgarbage = true;

ITEM.portions = 5;
ITEM.dthirst = 12;

ITEM:Register();