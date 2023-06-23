local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Армейский бронежилет 2";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_gear_armyarmor2";

ITEM.armor = 35;
ITEM.quality = 100;
ITEM.warm = 10; -- Ross
ITEM.reduceSpeed = 5; -- Ross
ITEM.addInventoryWeight = 6; -- Ross
ITEM.addInventorySpace = 6; -- Ross

ITEM.bid = 5;
ITEM.bstate = 3;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();