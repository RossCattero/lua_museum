local ITEM = Clockwork.item:New("ration_base");
ITEM.name = "Улучшенный рацион";
ITEM.model = "models/weapons/w_packatc.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "ration_second_better";
ITEM.space = 1;
ITEM.rationContains = {
    cash = 20,
    items = {
        "drink_soda",
        "food_ration_porridge"
    }
}

ITEM:Register();