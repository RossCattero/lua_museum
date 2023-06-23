local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Спецназовская газовая маска";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_gmask_swat";

ITEM.armor = 100;
ITEM.quality = 100;

ITEM.bid = 7;
ITEM.bstate = 2;
ITEM.clothesslot = "gasmask";
ITEM.combineOnly = false;
ITEM.hasGasmask = true;

ITEM:Register();