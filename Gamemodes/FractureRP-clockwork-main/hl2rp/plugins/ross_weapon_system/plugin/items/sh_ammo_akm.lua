local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон для АКМ";
ITEM.model = "models/frp/props/models/rif_ak47_mag.mdl";
ITEM.weight = 0.5;
ITEM.maxClip = 30;
ITEM.ammoType = "ar2";
ITEM.uniqueID = "c_mag_akm"
ITEM.WeaponsCanUse = {
    "tfa_ins2_akm",
    'tfa_ins2_makm',
    'tfa_ins2_akz'
};

ITEM:Register()