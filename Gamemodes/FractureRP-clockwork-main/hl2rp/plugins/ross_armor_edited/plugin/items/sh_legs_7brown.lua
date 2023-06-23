local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Коричневые штаны";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "clothes_legs_brown";

ITEM.armor = 15;
ITEM.quality = 100;
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 2;
ITEM.bstate = 7;
ITEM.clothesslot = "legs";
ITEM.combineOnly = false;

ITEM:Register();