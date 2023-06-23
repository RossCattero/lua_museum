local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Простой наполнитель";
ITEM.model = "models/foodnhouseholdaaaaa/combirationa.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_ration_simple";

ITEM.hunger = 10;
ITEM.type = "food";
ITEM.useAmount = 4;
ITEM.canBeGarbaged = true;

ITEM.foodtype = 1;
ITEM.hasgarbage = true;

ITEM:Register();