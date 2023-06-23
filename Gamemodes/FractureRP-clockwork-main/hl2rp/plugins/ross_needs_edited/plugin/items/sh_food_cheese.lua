local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Сыр";
ITEM.model = "models/bioshockinfinite/pound_cheese.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "food_cheese";

ITEM.hunger = 5;
ITEM.thirst = 0;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 5;
ITEM.canBeGarbaged = !true;

ITEM:Register();