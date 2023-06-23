local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Хлопья";
ITEM.model = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl";
ITEM.weight = 0.6;
ITEM.uniqueID = "food_cereals";

ITEM.hunger = 4;
ITEM.thirst = -6;
ITEM.sleep = 4;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 8;
ITEM.canBeGarbaged = true;

ITEM:Register();