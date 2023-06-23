local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Серая униформа";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_torso_black";

ITEM.armor = 5;
ITEM.quality = 100;
ITEM.warm = 5; -- Ross
ITEM.reduceSpeed = 0; -- Ross
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 1;
ITEM.bstate = 13;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;

ITEM:Register();