local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Армейский бронежилет";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "clothes_gear_armyarmor";

ITEM.armor = 10;
ITEM.quality = 100;
ITEM.warm = 10; -- Ross
ITEM.reduceSpeed = 5; -- Ross

ITEM.bid = 5;
ITEM.bstate = 2;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();