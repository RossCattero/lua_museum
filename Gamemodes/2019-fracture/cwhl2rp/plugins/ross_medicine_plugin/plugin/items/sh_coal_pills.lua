local ITEM = Clockwork.item:New("med_base");
ITEM.name = "Активированный уголь";
ITEM.uniqueID = "coal";
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.weight = 0.01;
ITEM.useSound = "items/ammopickup.wav";
ITEM.remsympthoms = {};
ITEM.timereg = 0;
ITEM.amount = 0;
ITEM.toxrem = 25;

ITEM:Register();