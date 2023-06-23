local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон Scorpion EVO";
ITEM.model = "models/frp/props/models/rif_aug_mag.mdl";
ITEM.weight = 0.4;
ITEM.maxClip = 30;
ITEM.ammoType = "smg1";
ITEM.uniqueID = "c_mag_scorpion"
ITEM.WeaponsCanUse = {
	'tfa_ins2_sc_evo'
};

ITEM:Register()