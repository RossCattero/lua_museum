local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Черный защитный шлем 1 модели";
ITEM.model = "models/frp/props/models/headgear_1.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_head_blackhelmet";

ITEM.armor = 35;
ITEM.quality = 100;

ITEM.bid = 8;
ITEM.bstate = 6;
ITEM.clothesslot = "head";
ITEM.combineOnly = false;

ITEM:Register();