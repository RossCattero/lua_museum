local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "SPAS-12";
	ITEM.model = "models/weapons/w_shotgun.mdl";
	ITEM.weight = 2.2;
	ITEM.uniqueID = "tfa_ins2_spas12";
	ITEM.category = "Оружие";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine1";
	ITEM.attachmentOffsetAngles = Angle(360, 180, -10);
	ITEM.attachmentOffsetVector = Vector(3, 3, 8);

ITEM:Register();