local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Каша с добавками";
ITEM.model = "models/foodnhouseholdaaaaa/combirationb.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_ration_porridge";

ITEM.hunger = 13;
ITEM.type = "food";
ITEM.useAmount = 4;
ITEM.canBeGarbaged = true;

ITEM:Register();