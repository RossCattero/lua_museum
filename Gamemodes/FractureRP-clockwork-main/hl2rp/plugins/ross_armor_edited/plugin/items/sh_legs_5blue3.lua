local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Обычные штаны голубого цвета";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_legs_blue3";

ITEM.armor = 15;
ITEM.quality = 100;
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 2;
ITEM.bstate = 5;
ITEM.clothesslot = "legs";
ITEM.combineOnly = false;

ITEM:Register();