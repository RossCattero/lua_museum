local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Банка сардин";
ITEM.model = "models/bioshockinfinite/cardine_can_open.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "food_cardines";

ITEM.hunger = 12;
ITEM.thirst = -7;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 4;
ITEM.canBeGarbaged = true;

ITEM:Register();