local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Вино";
ITEM.model = "models/bioshockinfinite/hext_bottle_lager.mdl";
ITEM.weight = 1;
ITEM.uniqueID = "drink_vine";

ITEM.hunger = 0;
ITEM.thirst = 25;
ITEM.sleep = -15;
ITEM.damage = 0;
ITEM.type = "drink";
ITEM.useAmount = 4;
ITEM.canBeGarbaged = true;

ITEM:Register();