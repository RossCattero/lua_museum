local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Наколенники";
ITEM.model = "models/frp/props/models/kneepads.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_kneepads_standart";

ITEM.armor = 45;
ITEM.quality = 100;

ITEM.bid = 9;
ITEM.bstate = 1;
ITEM.clothesslot = "knee";
ITEM.combineOnly = false;

ITEM:Register();