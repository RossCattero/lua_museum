local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Томатный суп";
ITEM.model = "models/frp/props/models/can_soup.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_tomato_soup";

ITEM.hunger = 9;
ITEM.thirst = 3;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 4;
ITEM.canBeGarbaged = true;

ITEM:Register();