local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин патрон для UZI";
ITEM.model = "models/frp/props/models/smg_mac10_mag.mdl";
ITEM.weight = 0.5;
ITEM.maxClip = 32;
ITEM.ammoType = "smg1";
ITEM.uniqueID = "c_mag_uzi"
ITEM.WeaponsCanUse = {
	'tfa_ins2_uzi'
};

ITEM:Register()