local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Обычные штаны синего цвета";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_legs_blue2";

ITEM.armor = 10;
ITEM.quality = 100;
ITEM.warm = 10; -- Ross
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 2;
ITEM.bstate = 2;
ITEM.clothesslot = "legs";
ITEM.combineOnly = false;

ITEM:Register();