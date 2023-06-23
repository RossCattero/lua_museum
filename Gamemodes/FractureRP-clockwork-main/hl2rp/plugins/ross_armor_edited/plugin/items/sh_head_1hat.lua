local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Серая шапка";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "clothes_head_hat";

ITEM.armor = 0;
ITEM.quality = 100;
ITEM.warm = 25; -- Ross

ITEM.bid = 8;
ITEM.bstate = 1;
ITEM.clothesslot = "head";
ITEM.combineOnly = false;

ITEM:Register();