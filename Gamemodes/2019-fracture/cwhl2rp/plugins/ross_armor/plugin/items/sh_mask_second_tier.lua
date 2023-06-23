local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Улучшенная маска юнита";
ITEM.model = "models/hl2rp/metropolice/suit/mask2.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "unit_gasmask_two";

ITEM.protection = 100;
ITEM.armor = 50;
ITEM.bid = 2;
ITEM.bstate = 3;
ITEM.type = 1;
ITEM.clothesslot = "gasmask";
ITEM.isGasmasked = true;
ITEM.MetrocopGasmask = 2;
ITEM.combineOnly = true;

ITEM:Register();