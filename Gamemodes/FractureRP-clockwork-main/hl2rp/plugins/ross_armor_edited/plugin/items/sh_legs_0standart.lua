local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Стандартные штаны серого цвета";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_legs_standart";

ITEM.quality = 100;

ITEM.bid = 2;
ITEM.bstate = 0;
ITEM.clothesslot = "legs";
ITEM.combineOnly = false;

ITEM:Register();