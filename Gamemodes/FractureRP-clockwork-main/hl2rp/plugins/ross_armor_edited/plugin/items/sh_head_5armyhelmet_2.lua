local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Армейский шлем - улучшенная модель";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_head_armyhelmet2";

ITEM.armor = 65;
ITEM.quality = 100;
ITEM.warm = 35; -- Ross

ITEM.bid = 8;
ITEM.bstate = 5;
ITEM.clothesslot = "head";
ITEM.combineOnly = false;

ITEM:Register();