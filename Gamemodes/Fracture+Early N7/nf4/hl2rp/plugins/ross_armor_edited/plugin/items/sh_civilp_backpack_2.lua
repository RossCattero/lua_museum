local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Рюкзак ГО";
ITEM.model = "models/props_junk/cardboard_box003a.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "clothes_civilp_backpack_2";

ITEM.armor = 0;
ITEM.quality = 100;
ITEM.warm = 0; -- Ross
ITEM.reduceSpeed = 5; -- Ross
ITEM.addInventoryWeight = 9; -- Ross
ITEM.addInventorySpace = 10; -- Ross
ITEM.bid = 4;
ITEM.bstate = 2;
ITEM.clothesslot = "backpack";
ITEM.combineOnly = true;

ITEM:Register();