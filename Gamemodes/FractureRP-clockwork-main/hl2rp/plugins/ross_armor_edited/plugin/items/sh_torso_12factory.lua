local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Заводская Рабочая униформа";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_torso_factory";

ITEM.armor = 20;
ITEM.quality = 100;
ITEM.warm = 20; -- Ross
ITEM.addInventoryWeight = 5; -- Ross
ITEM.addInventorySpace = 5; -- Ross

ITEM.bid = 1;
ITEM.bstate = 12;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;

ITEM:Register();