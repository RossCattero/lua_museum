local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Защитный шлем 2 модели";
ITEM.model = "models/frp/props/models/headgear_2.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_head_blackhelmet2";

ITEM.armor = 50;
ITEM.quality = 100;

ITEM.bid = 8;
ITEM.bstate = 7;
ITEM.clothesslot = "head";
ITEM.combineOnly = false;

ITEM:Register();