local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Морковь";
ITEM.model = "models/fallout 3/carrot.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "food_carrot";

ITEM.hunger = 5;
ITEM.thirst = 5;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 3;
ITEM.addDisease = {
    "vomit"
}
ITEM.canBeGarbaged = !true;

ITEM:Register();