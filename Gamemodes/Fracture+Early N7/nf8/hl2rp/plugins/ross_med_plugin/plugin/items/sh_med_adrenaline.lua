local ITEM = Clockwork.item:New("medic_base");
ITEM.name = "Адреналин";
ITEM.model = "models/frp/props/models/w_eq_adrenaline.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "med_adrenaline";
ITEM.usesound = 'usesound/properties.mp3'

ITEM.healAmount = 40;
ITEM.healTime = 4;
ITEM.MedattrBoost = {
    ATB_ENDURANCE2 = 4,
    ATB_SUSPECTING = 5,
    ATB_TOX = 5
};

ITEM:Register();