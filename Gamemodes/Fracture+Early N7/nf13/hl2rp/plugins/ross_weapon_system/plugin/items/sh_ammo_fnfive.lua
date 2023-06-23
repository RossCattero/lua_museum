local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Обойма патрон для Five Seven";
ITEM.model = "models/frp/props/models/pist_p228_mag.mdl";
ITEM.weight = 0.3;
ITEM.maxClip = 20;
ITEM.ammoType = "pistol";
ITEM.uniqueID = "c_mag_fn"
ITEM.WeaponsCanUse = {
   	"tfa_ins2_fiveseven"
};

ITEM:Register()