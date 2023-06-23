local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Нагрудные подсумки";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_gear_gear";

ITEM.armor = 5;
ITEM.quality = 100;
ITEM.warm = 2; -- Ross
ITEM.reduceSpeed = 2; -- Ross
ITEM.addInventoryWeight = 5; -- Ross
ITEM.addInventorySpace = 5; -- Ross

ITEM.bid = 5;
ITEM.bstate = 5;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();