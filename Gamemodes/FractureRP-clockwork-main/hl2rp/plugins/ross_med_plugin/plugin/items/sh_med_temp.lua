local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Ибупрофен";
ITEM.model = "models/frp/props/models/psy_pills.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "med_ibuprofen";
ITEM.usesound = 'usesound/pills.mp3'

ITEM.symRem = {
    temperature = 90
};

ITEM:Register();