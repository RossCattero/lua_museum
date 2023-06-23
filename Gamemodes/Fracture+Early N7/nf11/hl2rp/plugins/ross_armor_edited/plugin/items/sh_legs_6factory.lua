local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Заводские рабочие штаны";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "clothes_legs_factory";

ITEM.armor = 15;
ITEM.quality = 100;
ITEM.warm = 10; -- Ross
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 2;
ITEM.bstate = 6;
ITEM.clothesslot = "legs";
ITEM.combineOnly = false;

ITEM:Register();