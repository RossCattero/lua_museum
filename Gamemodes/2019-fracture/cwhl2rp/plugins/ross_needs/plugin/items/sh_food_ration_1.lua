local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Простой наполнитель";
ITEM.model = "models/foodnhouseholdaaaaa/combirationa.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_ration_simple";
ITEM.foodtype = 1;
ITEM.hasgarbage = true;

ITEM.portions = 4;
ITEM.dhunger = 10;
ITEM.addDirt = 3;

ITEM:Register();