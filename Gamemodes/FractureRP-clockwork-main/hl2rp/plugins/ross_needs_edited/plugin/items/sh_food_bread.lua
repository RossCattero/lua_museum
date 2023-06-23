local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Батон";
ITEM.model = "models/bioshockinfinite/dread_loaf.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "food_bread";

ITEM.hunger = 10;
ITEM.thirst = 0;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 3;
ITEM.canBeGarbaged = !true;

ITEM:Register();