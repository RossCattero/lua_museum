local ATTRIBUTE = Clockwork.attribute:New();

ATTRIBUTE.name = "Восприимчимость к токсинам";
ATTRIBUTE.maximum = 20;
ATTRIBUTE.uniqueID = "tox_end";
ATTRIBUTE.description = "";
ATTRIBUTE.isOnCharScreen = false;

ATB_TOX = Clockwork.attribute:Register(ATTRIBUTE);