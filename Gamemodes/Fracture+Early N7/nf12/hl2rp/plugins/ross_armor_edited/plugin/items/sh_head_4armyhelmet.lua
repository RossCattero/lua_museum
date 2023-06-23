local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Армейский шлем";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_head_armyhelmet";

ITEM.armor = 45;
ITEM.quality = 100;
ITEM.warm = 15; -- Ross

ITEM.bid = 8;
ITEM.bstate = 4;
ITEM.clothesslot = "head";
ITEM.combineOnly = false;

ITEM:Register();