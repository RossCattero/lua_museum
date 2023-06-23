local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Обычные Перчатки";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_hands_normal";

ITEM.armor = 5;
ITEM.quality = 100;
ITEM.warm = 25; -- Ross

ITEM.bid = 3;
ITEM.bstate = 1;
ITEM.clothesslot = "hands";
ITEM.combineOnly = false;


ITEM:Register();