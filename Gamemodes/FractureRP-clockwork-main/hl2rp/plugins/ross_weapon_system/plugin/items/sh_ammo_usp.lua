local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Обойма патрон для USP";
ITEM.model = "models/frp/props/models/pist_p228_mag.mdl";
ITEM.weight = 0.3;
ITEM.maxClip = 12;
ITEM.ammoType = "pistol";
ITEM.uniqueID = "c_mag_usp"
ITEM.WeaponsCanUse = {
	'tfa_ins2_usp45'
};

ITEM:Register()