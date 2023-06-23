local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин штурмовых патрон";
ITEM.model = "models/frp/props/models/rif_ak47_mag.mdl";
ITEM.weight = 0.6;
ITEM.maxClip = 30;
ITEM.ammoType = "ar2";
ITEM.uniqueID = "c_mag_one"
ITEM.WeaponsCanUse = {
    "tfa_ins2_akm",
    "tfa_ins2_ak12",
    "tfa_ins2_makm",
    "tfa_ins2_akz",
    "tfa_ins2_aks74u",
    "tfa_ins2_g36c",
    "tfa_ins2_galil",
    "tfa_ins2_mk18",
    "tfa_ins2_scarl",
    "tfa_ins2_sc_evo"
};

ITEM:Register()