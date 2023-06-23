local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Униформа GRID";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "cp_clothing_3";

ITEM.armor = 50;
ITEM.quality = 100;
ITEM.warm = 100; -- Ross
ITEM.addInventoryWeight = 4; -- Ross
ITEM.addInventorySpace = 4; -- Ross

ITEM.allowBattery = true;

ITEM.bid = 6;
ITEM.bstate = 2;
ITEM.clothesslot = "body";
ITEM.combineOnly = true;

ITEM:Register();