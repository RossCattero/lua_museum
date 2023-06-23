local ITEM = Clockwork.item:New("ration_base");
ITEM.name = "Рацион";
ITEM.model = "models/weapons/w_packate.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "ration_default";
ITEM.space = 1;
ITEM.rationContains = {
    cash = 10,
    items = {
        "food_ration_simple",
        "drink_simple_water"
    }
}

ITEM:Register();