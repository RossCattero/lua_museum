local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "FORT 500";
	ITEM.model = "models/weapons/tfa_ins2/w_spas12_bri.mdl";
	ITEM.weight = 2.2;
	ITEM.uniqueID = "tfa_ins2_fort500";
	ITEM.category = "Оружие";
	ITEM.description = "";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine1";
	ITEM.attachmentOffsetAngles = Angle(360, 180, -10);
	ITEM.attachmentOffsetVector = Vector(3, 3, 8);

ITEM:Register();