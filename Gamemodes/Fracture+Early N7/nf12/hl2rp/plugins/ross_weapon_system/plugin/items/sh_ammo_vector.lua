local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон для KRISS VECTOR";
ITEM.model = "models/frp/props/models/smg_ump45_mag.mdl";
ITEM.weight = 0.5;
ITEM.maxClip = 30;
ITEM.ammoType = "smg1";
ITEM.uniqueID = "c_mag_kriss"
ITEM.WeaponsCanUse = {
	'tfa_ins2_krissv'
};

ITEM:Register()