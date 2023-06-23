local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Готовка";
ATTRIBUTE.maximum = 10;
ATTRIBUTE.uniqueID = "cooking";
ATTRIBUTE.description = "";
ATTRIBUTE.isOnCharScreen = false;

ATB_COOK = Clockwork.attribute:Register(ATTRIBUTE);