local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Яблоко";
ITEM.model = "models/bioshockinfinite/hext_apple.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_apple";

ITEM.hunger = 5;
ITEM.thirst = 7;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 5;
ITEM.canBeGarbaged = !true;

ITEM:Register();