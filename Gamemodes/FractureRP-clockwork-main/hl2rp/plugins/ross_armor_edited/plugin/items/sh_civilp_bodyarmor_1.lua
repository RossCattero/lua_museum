local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Бронежилет ГО";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_civilp_bodyarmor_1";

ITEM.armor = 100;
ITEM.quality = 100;
ITEM.warm = 25; -- Ross
ITEM.reduceSpeed = 10; -- Ross
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 2;
ITEM.bstate = 1;
ITEM.clothesslot = "armorKevlar";
ITEM.combineOnly = true;

ITEM:Register();