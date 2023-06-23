local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Заводская рабочая маска";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_gmask_factory";

ITEM.armor = 50;
ITEM.quality = 100;

ITEM.bid = 7;
ITEM.bstate = 1;
ITEM.clothesslot = "gasmask";
ITEM.combineOnly = false;
ITEM.isRespirator = true;

ITEM:Register();