local ITEM = Clockwork.item:New("ration_base");
ITEM.name = "Отличный рацион";
ITEM.model = "models/weapons/w_packatl.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "ration_loyal_tier";
ITEM.space = 1;
ITEM.rationContains = {
    cash = 45,
    items = {
        "drink_sugar_soda",
        "food_ration_loyal"
    }
}

ITEM:Register();