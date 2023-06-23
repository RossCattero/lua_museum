local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Простейшая маска юнита";
ITEM.model = "models/hl2rp/metropolice/suit/mask0.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "unit_gasmask_first";

ITEM.protection = 100;
ITEM.armor = 25;
ITEM.bid = 2;
ITEM.bstate = 1;
ITEM.type = 1;
ITEM.clothesslot = "gasmask";
ITEM.isGasmasked = true;
ITEM.MetrocopGasmask = 1
ITEM.combineOnly = true;

ITEM:Register();