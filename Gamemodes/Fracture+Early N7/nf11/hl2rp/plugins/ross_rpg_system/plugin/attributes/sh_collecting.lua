local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Ремесло";
ATTRIBUTE.maximum = 10;
ATTRIBUTE.uniqueID = "collecting";
ATTRIBUTE.description = "";
ATTRIBUTE.isOnCharScreen = false;

ATB_COLLECTING = Clockwork.attribute:Register(ATTRIBUTE);