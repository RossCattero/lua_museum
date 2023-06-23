local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Медицинские штаны";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_legs_cwumedic";

ITEM.armor = 10;
ITEM.quality = 100;
ITEM.warm = 15; -- Ross
ITEM.addInventoryWeight = 3; -- Ross
ITEM.addInventorySpace = 3; -- Ross

ITEM.bid = 2;
ITEM.bstate = 8;
ITEM.clothesslot = "legs";
ITEM.combineOnly = false;

ITEM:Register();