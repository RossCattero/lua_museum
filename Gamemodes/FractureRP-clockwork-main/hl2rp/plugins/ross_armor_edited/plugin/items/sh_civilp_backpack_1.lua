local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Радиорюкзак";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_civilp_backpack_1";

ITEM.armor = 0;
ITEM.quality = 100;
ITEM.warm = 0; -- Ross
ITEM.reduceSpeed = 15; -- Ross

ITEM.bid = 4;
ITEM.bstate = 1;
ITEM.clothesslot = "backpack";
ITEM.combineOnly = true;

ITEM:Register();