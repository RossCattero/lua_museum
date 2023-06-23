local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Бронежилет";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_gear_armor";

ITEM.armor = 25;
ITEM.quality = 100;
ITEM.warm = 5; -- Ross
ITEM.reduceSpeed = 5; -- Ross

ITEM.bid = 5;
ITEM.bstate = 1;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();