local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Противогаз";
ITEM.model = "models/tnb/items/gasmask.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "gasmask";

ITEM.protection = 50;
ITEM.armor = 0;
ITEM.bid = 3;
ITEM.bstate = 3;
ITEM.type = 1;
ITEM.clothesslot = "gasmask";
ITEM.isGasmasked = true;

ITEM:Register();