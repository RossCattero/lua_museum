local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Армейские штаны";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_legs_army";

ITEM.armor = 15;
ITEM.quality = 100;
ITEM.warm = 15; -- Ross
ITEM.reduceSpeed = 5; -- Ross
ITEM.addInventoryWeight = 3; -- Ross
ITEM.addInventorySpace = 3; -- Ross

ITEM.bid = 2;
ITEM.bstate = 3;
ITEM.clothesslot = "legs";
ITEM.combineOnly = false;

ITEM:Register();