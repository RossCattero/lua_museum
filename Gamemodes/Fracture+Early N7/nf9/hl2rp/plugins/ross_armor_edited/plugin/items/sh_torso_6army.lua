local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Армейская униформа";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_torso_army";

ITEM.armor = 25;
ITEM.quality = 100;
ITEM.warm = 15; -- Ross
ITEM.reduceSpeed = 0; -- Ross
ITEM.addInventoryWeight = 3; -- Ross
ITEM.addInventorySpace = 3; -- Ross

ITEM.bid = 1;
ITEM.bstate = 6;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;

ITEM:Register();