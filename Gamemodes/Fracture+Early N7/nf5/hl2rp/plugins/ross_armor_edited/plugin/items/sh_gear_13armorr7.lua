local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Спецназовский бронежилет R7";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "clothes_gear_armorr7";

ITEM.armor = 75;
ITEM.quality = 100;
ITEM.warm = 35; -- Ross
ITEM.reduceSpeed = 35; -- Ross

ITEM.bid = 5;
ITEM.bstate = 13;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();