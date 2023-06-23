local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Белый Спецназовский бронежилет";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.8;
ITEM.uniqueID = "clothes_gear_whitearmy";

ITEM.armor = 100;
ITEM.quality = 100;
ITEM.warm = 25; -- Ross
ITEM.reduceSpeed = 25; -- Ross

ITEM.bid = 5;
ITEM.bstate = 11;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();