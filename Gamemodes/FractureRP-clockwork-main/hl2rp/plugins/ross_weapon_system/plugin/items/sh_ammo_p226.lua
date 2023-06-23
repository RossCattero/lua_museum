local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Обойма патрон P226";
ITEM.model = "models/frp/props/models/pist_p228_mag.mdl";
ITEM.weight = 0.3;
ITEM.maxClip = 12;
ITEM.ammoType = "pistol";
ITEM.uniqueID = "c_mag_p226"
ITEM.WeaponsCanUse = {
   	"tfa_ins2_p226"
};

ITEM:Register()