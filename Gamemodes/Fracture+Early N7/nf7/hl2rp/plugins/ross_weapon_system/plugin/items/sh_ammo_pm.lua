local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Обойма патрон для ПМ";
ITEM.model = "models/frp/props/models/pist_p228_mag.mdl";
ITEM.weight = 0.3;
ITEM.maxClip = 8;
ITEM.ammoType = "pistol";
ITEM.uniqueID = "c_mag_pm"
ITEM.WeaponsCanUse = {
   	"tfa_ins2_pm"
};

ITEM:Register()