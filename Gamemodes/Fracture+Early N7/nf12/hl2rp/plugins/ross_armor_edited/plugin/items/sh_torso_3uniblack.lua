local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Униформа темного цвета";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "clothes_torso_uniblack";

ITEM.armor = 2;
ITEM.quality = 100;
ITEM.warm = 2; -- Ross
ITEM.addInventoryWeight = 1; -- Ross
ITEM.addInventorySpace = 1; -- Ross

ITEM.bid = 1;
ITEM.bstate = 3;
ITEM.clothesslot = "body";
ITEM.combineOnly = false;

ITEM:Register();