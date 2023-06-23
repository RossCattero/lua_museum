local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Аптечка с биогелем";
ITEM.model = "models/Items/HealthKit.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "med_medkit_bio";
ITEM.usesound = 'items/smallmedkit1.wav'

ITEM.healAmount = 40;
ITEM.healTime = 3;
ITEM.diseasesRem = {
    infection = 70,
    poisoned = 70
};
ITEM.symRem = {
    vomit = 100,
    bloodcough = 100
};

ITEM:Register();