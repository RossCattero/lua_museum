local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Шприц с морфином";
ITEM.model = "models/frp/props/models/w_eq_adrenaline.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "med_morphine_shot";
ITEM.usesound = 'usesound/properties.mp3'

ITEM.healAmount = 50;
ITEM.healTime = 2;
ITEM.MedattrBoost = {
    ATB_ENDURANCE2 = 6,
    ATB_SUSPECTING = 6,
    ATB_TOX = 7
};

ITEM:Register();