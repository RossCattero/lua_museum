local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Таблетки от мигрени";
ITEM.model = "models/frp/props/models/antidote.mdl";
ITEM.weight = 0.2;
ITEM.uniqueID = "med_headache";
ITEM.usesound = 'usesound/pills.mp3'

ITEM.diseasesRem = {};
ITEM.symRem = {
    headache = 100
};

ITEM:Register();