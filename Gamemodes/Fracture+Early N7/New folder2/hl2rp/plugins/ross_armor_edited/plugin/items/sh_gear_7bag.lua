local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Упрощенные ремни";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "clothes_gear_bag";

ITEM.armor = 2;
ITEM.quality = 100;
ITEM.warm = 2; -- Ross
ITEM.reduceSpeed = 2; -- Ross
ITEM.addInventoryWeight = 0.5; -- Ross
ITEM.addInventorySpace = 0.5; -- Ross

ITEM.bid = 5;
ITEM.bstate = 7;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = false;

ITEM:Register();