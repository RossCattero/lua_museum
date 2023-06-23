local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Легкие штаны синего цвета";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_legs_blue";

ITEM.armor = 5;
ITEM.quality = 100;
ITEM.warm = 5; -- Ross
ITEM.addInventoryWeight = 1; -- Ross
ITEM.addInventorySpace = 1; -- Ross

ITEM.bid = 2;
ITEM.bstate = 1;
ITEM.clothesslot = "legs";
ITEM.combineOnly = false;

ITEM:Register();