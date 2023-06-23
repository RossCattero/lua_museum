local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Бекон";
ITEM.model = "models/foodnhouseholditems/bacon.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "food_bacon";
ITEM.foodtype = 1;

ITEM.portions = 2;
ITEM.dhunger = 5;
ITEM.addDirt = 2;

ITEM:Register();