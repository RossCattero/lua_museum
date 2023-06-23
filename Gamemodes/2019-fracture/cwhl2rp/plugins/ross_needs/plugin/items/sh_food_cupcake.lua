local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Кекс";
ITEM.model = "models/fallout 3/sweet_roll.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "food_cupcake";
ITEM.foodtype = 1;

ITEM.portions = 2;
ITEM.dhunger = 3;
ITEM.addDirt = math.random(1, 11);

ITEM:Register();