local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Картофель";
ITEM.model = "models/fallout 3/potato.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "food_potato";

ITEM.hunger = 5;
ITEM.thirst = 0;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 3;
ITEM.addDisease = {
    "vomit"
}
ITEM.canBeGarbaged = !true;

ITEM:Register();