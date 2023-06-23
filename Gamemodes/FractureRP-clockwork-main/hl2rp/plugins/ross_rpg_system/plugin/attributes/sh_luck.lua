local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Удача";
ATTRIBUTE.maximum = 10;
ATTRIBUTE.uniqueID = "luck";
ATTRIBUTE.description = "";
ATTRIBUTE.isOnCharScreen = false;

ATB_LUCK = Clockwork.attribute:Register(ATTRIBUTE);