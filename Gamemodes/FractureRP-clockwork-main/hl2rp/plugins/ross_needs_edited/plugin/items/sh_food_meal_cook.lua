local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Готовое блюдо";
ITEM.model = "models/foodnhouseholdaaaaa/combirationa.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_readymeal_cook";

ITEM.hunger = 0;
ITEM.thirst = 0;
ITEM.sleep = 0;
ITEM.type = "food";
ITEM.useAmount = 5;
ITEM.canBeGarbaged = !true;

ITEM:Register();