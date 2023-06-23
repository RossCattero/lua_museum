local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Кусок хлеба";
ITEM.model = "models/foodnhouseholditems/bread_slice.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "food_breadslice";
ITEM.foodtype = 1;

ITEM.portions = 3;
ITEM.dhunger = 3;
ITEM.dthirst = 0;
ITEM.dsleep = 0;

ITEM:Register();