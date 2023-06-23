local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон 5.45мм";
ITEM.model = "models/frp/props/models/rif_ak47_mag.mdl";
ITEM.weight = 0.5;
ITEM.maxClip = 30;
ITEM.ammoType = "ar2";
ITEM.uniqueID = "c_mag_545"
ITEM.WeaponsCanUse = {
    "tfa_ins2_ak12",
    "tfa_ins2_aks74u"
};

ITEM:Register()