local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Домашнее блюдо из индейки";
ITEM.model = "models/foodnhouseholdaaaaa/combirationc.mdl";
ITEM.weight = 0.6;
ITEM.uniqueID = "food_ration_loyal";

ITEM.hunger = 16;
ITEM.type = "food";
ITEM.useAmount = 4;
ITEM.canBeGarbaged = true;

ITEM:Register();