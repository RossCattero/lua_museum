local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Каша с добавками";
ITEM.model = "models/foodnhouseholdaaaaa/combirationb.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_ration_porridge";
ITEM.foodtype = 1;
ITEM.hasgarbage = true;

ITEM.portions = 4;
ITEM.dhunger = 13;
ITEM.addDirt = 2;

ITEM:Register();