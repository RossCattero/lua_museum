local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Яйцо";
ITEM.model = "models/foodnhouseholditems/egg2.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "food_egg";
ITEM.foodtype = 1;

ITEM.portions = 1;
ITEM.dhunger = 10;
ITEM.dthirst = 10;
ITEM.dsleep = 0;
ITEM.canPickup = false;

ITEM:Register();