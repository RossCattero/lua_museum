local ITEM = Clockwork.item:New("med_base");
ITEM.name = "Аптечка";
ITEM.uniqueID = "medkit";
ITEM.model = "models/Items/HealthKit.mdl"
ITEM.weight = 0.3;
ITEM.useSound = "items/ammopickup.wav";
ITEM.remsympthoms = {};
ITEM.timereg = 5;
ITEM.amount = 2.5;
ITEM.toxrem = 100;

ITEM:Register();