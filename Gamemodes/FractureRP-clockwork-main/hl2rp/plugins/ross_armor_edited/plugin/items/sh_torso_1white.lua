local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Стандартная Гражданская униформа";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "clothes_torso_white";

ITEM.armor = 10;
ITEM.quality = 100;
ITEM.addInventoryWeight = 3; -- Ross
ITEM.addInventorySpace = 3; -- Ross

ITEM.bid = 1;
ITEM.bstate = 1;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;

ITEM:Register();