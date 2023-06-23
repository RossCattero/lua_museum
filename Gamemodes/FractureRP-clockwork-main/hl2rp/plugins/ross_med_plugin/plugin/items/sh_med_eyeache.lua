local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Глазные капли";
ITEM.model = "models/mosi/fallout4/props/aid/buffout.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "med_eyeache";
ITEM.usesound = 'usesound/properties.mp3'

ITEM.diseasesRem = {};
ITEM.symRem = {
    eyeache = 100
};

ITEM:Register();