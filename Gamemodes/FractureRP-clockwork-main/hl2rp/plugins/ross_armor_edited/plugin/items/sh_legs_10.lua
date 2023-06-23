local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Черные штаны";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_legs_brown2";

ITEM.armor = 5;
ITEM.quality = 100;
ITEM.warm = 5; -- Ross
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 2;
ITEM.bstate = 10;
ITEM.clothesslot = "legs";
ITEM.combineOnly = false;

ITEM:Register();