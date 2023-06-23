local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон для АС ВАЛ";
ITEM.model = "models/frp/props/models/rif_aug_mag.mdl";
ITEM.weight = 0.5;
ITEM.maxClip = 20;
ITEM.ammoType = "ar2";
ITEM.uniqueID = "c_mag_asval"
ITEM.WeaponsCanUse = {
    "tfa_ins2_asval"
};

ITEM:Register()