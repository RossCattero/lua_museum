local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон MP7";
ITEM.model = "models/frp/props/models/rif_aug_mag.mdl";
ITEM.weight = 0.6;
ITEM.maxClip = 40;
ITEM.ammoType = "smg1";
ITEM.uniqueID = "c_mag_mp7"
ITEM.WeaponsCanUse = {
	'tfa_ins2_mp7'
};

ITEM:Register()