local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Гражданская униформа City-17";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_torso_city17";

ITEM.armor = 5;
ITEM.quality = 100;
ITEM.warm = 5; -- Ross
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 1;
ITEM.bstate = 4;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;

ITEM:Register();