local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон 5.56x45 НАТО";
ITEM.model = "models/frp/props/models/rif_m4a1_mag.mdl";
ITEM.weight = 0.6;
ITEM.maxClip = 30;
ITEM.ammoType = "ar2";
ITEM.uniqueID = "c_mag_556x45"
ITEM.WeaponsCanUse = {
    "tfa_ins2_g36c",
    "tfa_ins2_galil",
    "tfa_ins2_mk18",
    "tfa_ins2_scarl",
    'tfa_ins2_famas'
};

ITEM:Register()