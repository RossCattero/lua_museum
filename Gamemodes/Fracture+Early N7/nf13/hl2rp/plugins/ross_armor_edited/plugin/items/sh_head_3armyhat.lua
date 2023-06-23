local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Армейская фуражка";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "clothes_head_armyhat";

ITEM.armor = 5;
ITEM.quality = 100;
ITEM.warm = 5; -- Ross

ITEM.bid = 8;
ITEM.bstate = 3;
ITEM.clothesslot = "head";
ITEM.combineOnly = false;

ITEM:Register();