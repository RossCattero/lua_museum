local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Газировка";
ITEM.model = "models/props_lunk/popcan01a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "drink_soda";

ITEM.hunger = 0;
ITEM.thirst = 12;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "drink";
ITEM.useAmount = 5;
ITEM.canBeGarbaged = true;

ITEM:Register();