local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон MP5K";
ITEM.model = "models/frp/props/models/smg_mp5_mag.mdl";
ITEM.weight = 0.5;
ITEM.maxClip = 30;
ITEM.ammoType = "smg1";
ITEM.uniqueID = "c_mag_mp5k"
ITEM.WeaponsCanUse = {
	'tfa_ins2_mp5k'
};

ITEM:Register()