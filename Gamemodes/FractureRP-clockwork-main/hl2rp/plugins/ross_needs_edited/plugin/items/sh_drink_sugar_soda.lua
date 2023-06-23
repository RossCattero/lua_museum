local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Сладкая газировка";
ITEM.model = "models/props_cunk/popcan01a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "drink_sugar_soda";

ITEM.thirst = 15;
ITEM.type = "drink";
ITEM.useAmount = 5;
ITEM.canBeGarbaged = true;

ITEM:Register();