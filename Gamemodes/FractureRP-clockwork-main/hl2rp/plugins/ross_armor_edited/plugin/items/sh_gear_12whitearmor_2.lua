local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Усиленный спецназовский бронежилет белого цвета";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_gear_whitearmy2";

ITEM.armor = 100;
ITEM.quality = 100;
ITEM.warm = 25; -- Ross
ITEM.reduceSpeed = 15; -- Ross
ITEM.addInventoryWeight = 3; -- Ross
ITEM.addInventorySpace = 3; -- Ross

ITEM.bid = 5;
ITEM.bstate = 12;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();