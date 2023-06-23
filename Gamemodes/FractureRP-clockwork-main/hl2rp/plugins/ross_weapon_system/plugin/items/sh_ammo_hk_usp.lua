local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Обойма для HK Usp match";
ITEM.model = "models/frp/props/models/pist_p228_mag.mdl";
ITEM.weight = 0.3;
ITEM.maxClip = 15;
ITEM.ammoType = "pistol";
ITEM.uniqueID = "c_mag_hk_usp"
ITEM.WeaponsCanUse = {
    "tfa_ins2_usp_match"
};

ITEM:Register()