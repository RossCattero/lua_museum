local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Спецназовский бронежилет с подсумками";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.7;
ITEM.uniqueID = "clothes_gear_swatarmy";

ITEM.armor = 100;
ITEM.quality = 100;
ITEM.warm = 25; -- Ross
ITEM.reduceSpeed = 15; -- Ross
ITEM.addInventoryWeight = 5; -- Ross
ITEM.addInventorySpace = 5; -- Ross

ITEM.bid = 5;
ITEM.bstate = 10;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();