local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон ПП";
ITEM.model = "models/frp/props/models/rif_aug_mag.mdl";
ITEM.weight = 0.3;
ITEM.maxClip = 30;
ITEM.ammoType = "smg1";
ITEM.uniqueID = "c_mag_three"
ITEM.WeaponsCanUse = {
	'tfa_ins2_sai_gry',
	'tfa_ins2_uzi',
	'tfa_ins2_krissv',
	'tfa_ins2_mp5k',
	'tfa_ins2_mp7'
};

ITEM:Register()