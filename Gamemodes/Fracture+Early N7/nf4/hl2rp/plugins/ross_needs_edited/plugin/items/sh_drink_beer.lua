local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Пиво";
ITEM.model = "models/mosi/fallout4/props/alcohol/beer.mdl";
ITEM.weight = 0.6;
ITEM.uniqueID = "drink_beer";

ITEM.hunger = 5;
ITEM.thirst = 15;
ITEM.sleep = -15;
ITEM.damage = 0;
ITEM.type = "drink";
ITEM.useAmount = 5;
ITEM.canBeGarbaged = true;

ITEM:Register();