local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Барабан патронов РПК";
ITEM.model = "models/frp/props/models/mach_m249para_mag.mdl";
ITEM.weight = 0.6;
ITEM.maxClip = 75;
ITEM.ammoType = "ar2";
ITEM.uniqueID = "c_mag_rpk"
ITEM.WeaponsCanUse = {
    'tfa_ins2_rpk'
};

ITEM:Register()