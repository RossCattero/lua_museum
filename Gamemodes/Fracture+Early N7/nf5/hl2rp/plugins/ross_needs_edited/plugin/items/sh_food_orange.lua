local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Апельсин";
ITEM.model = "models/bioshockinfinite/hext_orange.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "food_orange";

ITEM.hunger = 4;
ITEM.thirst = 4;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 6;
ITEM.canBeGarbaged = !true;

ITEM:Register();