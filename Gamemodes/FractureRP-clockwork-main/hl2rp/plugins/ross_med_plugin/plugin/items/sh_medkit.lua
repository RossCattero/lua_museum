local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Аптечка";
ITEM.model = "models/zworld_health/healthkit.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "med_medkit_default";
ITEM.usesound = 'usesound/medkit.mp3'

ITEM.healAmount = 20;
ITEM.healTime = 3;
ITEM.diseasesRem = {
    infection = 60,
    poisoned = 60,
};
ITEM.symRem = {
    vomit = 90,
    bloodcough = 90
};

ITEM:Register();