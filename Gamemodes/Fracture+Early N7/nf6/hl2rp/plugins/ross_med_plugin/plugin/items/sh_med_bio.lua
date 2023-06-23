local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Биогель";
ITEM.model = "models/healthvial.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "med_biogel";
ITEM.usesound = 'items/medshot4.wav'

ITEM.healAmount = 25;
ITEM.healTime = 5;
ITEM.diseasesRem = {
    infection = 50
};
ITEM.symRem = {};

ITEM:Register();