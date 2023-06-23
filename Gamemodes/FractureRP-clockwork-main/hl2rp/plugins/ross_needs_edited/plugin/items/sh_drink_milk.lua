local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Молоко";
ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "drink_milk";

ITEM.hunger = 0;
ITEM.thirst = 15;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "drink";
ITEM.useAmount = 4;
ITEM.canBeGarbaged = true;

ITEM:Register();