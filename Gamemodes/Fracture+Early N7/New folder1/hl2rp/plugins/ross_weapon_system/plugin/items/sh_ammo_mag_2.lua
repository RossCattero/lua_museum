local ITEM = Clockwork.item:New("mag_base");

ITEM.name = "Магазин пистолетных патрон";
ITEM.model = "models/frp/props/models/pist_p228_mag.mdl";
ITEM.weight = 0.3;
ITEM.maxClip = 8;
ITEM.ammoType = "pistol";
ITEM.uniqueID = "c_mag_two"
ITEM.WeaponsCanUse = {
    "tfa_ins2_usp_match",
   	"tfa_ins2_tt33",
   	"tfa_ins2_p226",
   	"tfa_ins2_pm", 
	'tfa_ins2_usp45',
  	"tfa_ins2_p220",
   	"tfa_ins2_deagle",
   	"tfa_ins2_fiveseven"
};

ITEM:Register()