local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Ремни";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "clothes_gear_bag2";

ITEM.armor = 3;
ITEM.quality = 100;
ITEM.warm = 3; -- Ross
ITEM.addInventoryWeight = 1; -- Ross
ITEM.addInventorySpace = 1; -- Ross

ITEM.bid = 5;
ITEM.bstate = 8;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();