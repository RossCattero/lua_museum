local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Макароны";
ITEM.model = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_";

ITEM.hunger = 5;
ITEM.thirst = -6;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 5;
ITEM.canBeGarbaged = true;

ITEM:Register();