local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Поношенная Гражданская униформа";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "clothes_torso_standartbad";

ITEM.armor = 0;
ITEM.quality = 20;

ITEM.bid = 1;
ITEM.bstate = 2;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;

ITEM:Register();