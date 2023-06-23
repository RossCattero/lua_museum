local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Чипсы";
ITEM.model = "models/bioshockinfinite/bag_of_hhips.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_chips";

ITEM.hunger = 3;
ITEM.thirst = 0;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 8;
ITEM.canBeGarbaged = true;

ITEM:Register();