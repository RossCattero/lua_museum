local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Домашнее блюдо из индейки";
ITEM.model = "models/foodnhouseholdaaaaa/combirationc.mdl";
ITEM.weight = 0.6;
ITEM.uniqueID = "food_ration_loyal";
ITEM.foodtype = 1;
ITEM.hasgarbage = true;

ITEM.portions = 4;
ITEM.dhunger = 16;
ITEM.addDirt = 1;

ITEM:Register();