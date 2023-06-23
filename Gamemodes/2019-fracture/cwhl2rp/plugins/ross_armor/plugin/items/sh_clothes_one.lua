local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Рубашка";
ITEM.model = "models/tnb/items/shirt_citizen1.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "rub_one";

ITEM.protection = 35;
ITEM.armor = 0;
ITEM.bid = 1;
ITEM.bstate = 5;
ITEM.type = 1;
ITEM.skin = 0;
ITEM.clothesslot = "body";
ITEM.addInvSpace = 6;
ITEM.isGasmasked = false;
ITEM.reduceSpeed = 0;
ITEM.warmeing = ITEM.protection;

ITEM:Register();