local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Усиленные налокотники";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "clothes_elbowpads_standart2";

ITEM.armor = 35;
ITEM.quality = 100;
ITEM.reduceSpeed = 10; -- Ross

ITEM.bid = 10;
ITEM.bstate = 2;
ITEM.clothesslot = "elbow";
ITEM.combineOnly = false;

ITEM:Register();