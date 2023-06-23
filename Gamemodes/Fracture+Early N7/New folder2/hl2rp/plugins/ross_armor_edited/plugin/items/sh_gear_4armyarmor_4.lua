local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Армейский бронежилет 3";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_gear_armyarmor3";

ITEM.armor = 35;
ITEM.quality = 100;
ITEM.warm = 10; -- Ross
ITEM.reduceSpeed = 5; -- Ross
ITEM.addInventoryWeight = 5; -- Ross
ITEM.addInventorySpace = 5; -- Ross

ITEM.bid = 5;
ITEM.bstate = 4;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();