local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Ремень ГО";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_civilp_straps_1";

ITEM.armor = 0;
ITEM.quality = 100;
ITEM.warm = 0; -- Ross
ITEM.reduceSpeed = 0; -- Ross

ITEM.bid = 3;
ITEM.bstate = 1;
ITEM.clothesslot = "elbow";
ITEM.combineOnly = true;


ITEM:Register();