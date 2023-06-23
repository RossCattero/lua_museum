local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Зеленая шапка";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_head_hat2";

ITEM.armor = 0;
ITEM.quality = 100;
ITEM.warm = 45; -- Ross

ITEM.bid = 8;
ITEM.bstate = 2;
ITEM.clothesslot = "head";
ITEM.combineOnly = false;

ITEM:Register();