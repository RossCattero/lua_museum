local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Налокотники";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_elbowpads_standart";

ITEM.armor = 25;
ITEM.quality = 100;
ITEM.warm = 0; -- Ross

ITEM.bid = 10;
ITEM.bstate = 1;
ITEM.clothesslot = "elbow";
ITEM.combineOnly = false;

ITEM:Register();