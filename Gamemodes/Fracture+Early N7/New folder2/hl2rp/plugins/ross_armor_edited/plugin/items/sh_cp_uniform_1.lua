local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Униформа JURY";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "cp_clothing_1";

ITEM.armor = 100;
ITEM.quality = 100;
ITEM.warm = 35; -- Ross
ITEM.addInventoryWeight = 3; -- Ross
ITEM.addInventorySpace = 3; -- Ross

ITEM.allowBattery = true;

ITEM.bid = 6;
ITEM.bstate = 5;
ITEM.clothesslot = "body";
ITEM.combineOnly = true;

ITEM:Register();