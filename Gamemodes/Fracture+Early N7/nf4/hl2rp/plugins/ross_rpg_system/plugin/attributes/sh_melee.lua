local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Холодное оружие";
ATTRIBUTE.maximum = 10;
ATTRIBUTE.uniqueID = "melee";
ATTRIBUTE.description = "";
ATTRIBUTE.isOnCharScreen = false;

ATB_MELEE = Clockwork.attribute:Register(ATTRIBUTE);