local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон 7.62х54";
ITEM.model = "models/frp/props/models/rif_aug_mag.mdl";
ITEM.weight = 0.5;
ITEM.maxClip = 10;
ITEM.ammoType = "SniperPenetratedRound";
ITEM.uniqueID = "c_mag_svd_svt"
ITEM.WeaponsCanUse = {
    "tfa_ins2_svd",
    'tfa_ins2_svt40'
};

ITEM:Register()