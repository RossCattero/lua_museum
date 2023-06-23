local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Защитный шлем 3 модели";
ITEM.model = "models/frp/props/models/headgear_3.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "clothes_head_blackhelmet3";

ITEM.armor = 65;
ITEM.quality = 100;

ITEM.bid = 8;
ITEM.bstate = 8;
ITEM.clothesslot = "head";
ITEM.combineOnly = false;

ITEM:Register();