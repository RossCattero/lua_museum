local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Гражданая униформа City-17 Хорошего качества";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_torso_city17_2";

ITEM.armor = 5;
ITEM.quality = 100;
ITEM.warm = 5; -- Ross
ITEM.reduceSpeed = 0; -- Ross
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 1;
ITEM.bstate = 5;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;

ITEM:Register();