local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Мясо";
ITEM.model = "models/fallout 3/meat.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "food_meat";

ITEM.hunger = 10;
ITEM.thirst = 0;
ITEM.sleep = 0;
ITEM.type = "food";
ITEM.useAmount = 2;
ITEM.addDisease = {
    "vomit"
}
ITEM.canBeGarbaged = !true;

ITEM.cookingBlueprint = {
    ["Жарка"] = {
        hun = 25,
        thirst = 0,
        sleep = 0,
        dirt = 0,
        model = "models/mosi/fallout4/props/food/moleratsteak.mdl",
        time = 5
    }
}

ITEM:Register();