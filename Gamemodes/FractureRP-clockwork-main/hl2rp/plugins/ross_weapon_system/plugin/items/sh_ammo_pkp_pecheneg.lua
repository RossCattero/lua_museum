local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Коробка патронов для печенега";
ITEM.model = "models/frp/props/models/mach_m249para_mag.mdl";
ITEM.weight = 1;
ITEM.maxClip = 100;
ITEM.ammoType = "ar2";
ITEM.uniqueID = "c_mag_pkp_pech"
ITEM.WeaponsCanUse = {
    'tfa_ins2_pkp'
};

ITEM:Register()