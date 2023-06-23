local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Мясо";
ITEM.model = "models/fallout 3/meat.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_meat";
ITEM.foodtype = 1;

ITEM.cookingBlueprint = {
    ["Жарка"] = {
        hun = 30,
        thirst = 0,
        sleep = 0,
        dirt = 20,
        model = "models/mosi/fallout4/props/food/steak.mdl",
        time = 25
    },
    ["Варка"] = {
        hun = 10,
        thirst = 0,
        sleep = 0,
        dirt = 10,
        time = 35
    }
}

ITEM.portions = 4;
ITEM.dhunger = 2;
ITEM.addDirt = 15;

ITEM:Register();