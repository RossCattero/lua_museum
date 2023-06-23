local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Активированный уголь";
ITEM.model = "models/frp/props/models/rad_pills.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "med_active_coal";
ITEM.usesound = 'usesound/pills.mp3'

ITEM.diseasesRem = {};
ITEM.symRem = {
    vomit = 100
};

ITEM:Register();