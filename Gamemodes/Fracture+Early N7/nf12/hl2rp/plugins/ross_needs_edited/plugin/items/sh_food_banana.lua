local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Банан";
ITEM.model = "models/bioshockinfinite/hext_banana.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "food_banana";

ITEM.hunger = 6;
ITEM.thirst = 4;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 4;
ITEM.canBeGarbaged = !true;

ITEM:Register();