local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Белая униформа с красной повязкой";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_torso_white2";

ITEM.armor = 15;
ITEM.quality = 100;
ITEM.warm = 15; -- Ross
ITEM.addInventoryWeight = 2; -- Ross
ITEM.addInventorySpace = 2; -- Ross

ITEM.bid = 1;
ITEM.bstate = 7;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;

ITEM:Register();