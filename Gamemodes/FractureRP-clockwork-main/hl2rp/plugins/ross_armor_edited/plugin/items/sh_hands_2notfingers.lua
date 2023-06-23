local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Перчатки";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_hands_notfingers";

ITEM.armor = 10;
ITEM.quality = 100;
ITEM.warm = 10; -- Ross

ITEM.bid = 3;
ITEM.bstate = 2;
ITEM.clothesslot = "hands";
ITEM.combineOnly = false;

ITEM:Register();