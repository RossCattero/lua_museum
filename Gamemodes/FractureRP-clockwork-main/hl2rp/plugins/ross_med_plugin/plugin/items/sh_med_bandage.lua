local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Бинт";
ITEM.model = "models/zworld_health/bandages.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "med_bandage";
ITEM.usesound = 'usesound/bandage.mp3'

ITEM.healAmount = 15;
ITEM.healTime = 3;
ITEM.diseasesRem = {};
ITEM.symRem = {};

ITEM:Register();