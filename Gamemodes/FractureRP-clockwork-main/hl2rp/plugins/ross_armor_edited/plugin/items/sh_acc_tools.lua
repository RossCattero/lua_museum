local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Инструменты";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_acc_tools_cit";

ITEM.armor = 0;
ITEM.quality = 100;
ITEM.warm = 0; -- Ross
ITEM.reduceSpeed = 0; -- Ross
ITEM.addInventoryWeight = 3; -- Ross
ITEM.addInventorySpace = 3; -- Ross

ITEM.bid = 6;
ITEM.bstate = 1;
ITEM.clothesslot = "steto";
ITEM.combineOnly = false;

ITEM:Register();