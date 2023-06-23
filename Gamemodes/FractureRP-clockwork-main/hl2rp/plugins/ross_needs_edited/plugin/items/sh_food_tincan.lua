local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Мясная тушенка";
ITEM.model = "models/frp/props/models/can_spam.mdl";
ITEM.weight = 0.6;
ITEM.uniqueID = "food_tincan_meat";

ITEM.hunger = 10;
ITEM.thirst = 3;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 5;
ITEM.canBeGarbaged = true;

ITEM:Register();