local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Стетоскоп";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_acc_steto_cit";

ITEM.quality = 100;

ITEM.bid = 4;
ITEM.bstate = 1;
ITEM.clothesslot = "steto";
ITEM.combineOnly = false;

ITEM:Register();