local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Яичница";
ITEM.model = "models/foodnhouseholditems/egg.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_friedeggs";
ITEM.foodtype = 1;

ITEM.portions = 2;
ITEM.dhunger = 15;
ITEM.dthirst = 3;
ITEM.dsleep = 0;
ITEM.canPickup = false;

ITEM:Register();