local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "MASK_ELITE";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "clothes_civilp_gmask_4";

ITEM.armor = 100;
ITEM.quality = 100;
ITEM.warm = 100; -- Ross

ITEM.MetrocopGasmask = 5;

ITEM.bid = 1;
ITEM.bstate = 5;
ITEM.clothesslot = "gasmask";
ITEM.combineOnly = true;
ITEM.isRespirator = true;

ITEM:Register();