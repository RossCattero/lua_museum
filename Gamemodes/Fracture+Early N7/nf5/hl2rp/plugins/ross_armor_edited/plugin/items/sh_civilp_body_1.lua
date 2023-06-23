local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Офицерский плащ ГО";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_civilp_body_1";

ITEM.armor = 0;
ITEM.quality = 100;
ITEM.warm = 0; -- Ross

ITEM.bid = 5;
ITEM.bstate = 1;
ITEM.clothesslot = "knee";
ITEM.combineOnly = true;

ITEM:Register();