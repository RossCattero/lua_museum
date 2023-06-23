local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Простая вода";
ITEM.model = "models/props_nunk/popcan01a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "drink_simple_water";

ITEM.hunger = 0;
ITEM.thirst = 7;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "drink";
ITEM.useAmount = 5;
ITEM.canBeGarbaged = true;

ITEM:Register();