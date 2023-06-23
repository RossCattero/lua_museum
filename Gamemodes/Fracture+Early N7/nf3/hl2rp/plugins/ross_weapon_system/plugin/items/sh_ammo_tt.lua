local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Обойма патрон для ТТ";
ITEM.model = "models/frp/props/models/pist_p228_mag.mdl";
ITEM.weight = 0.3;
ITEM.maxClip = 8;
ITEM.ammoType = "pistol";
ITEM.uniqueID = "c_mag_tt"
ITEM.WeaponsCanUse = {
   	"tfa_ins2_tt33"
};

ITEM:Register()