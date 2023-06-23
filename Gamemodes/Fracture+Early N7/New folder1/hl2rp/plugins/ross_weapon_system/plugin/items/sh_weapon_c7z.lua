local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "C7Z";
	ITEM.model = "models/weapons/tfa_ins2/w_sai_gry.mdl";
	ITEM.weight = 2.1;
	ITEM.uniqueID = "tfa_ins2_c7e_redux";
	ITEM.category = "Оружие";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine1";
	ITEM.attachmentOffsetAngles = Angle(360, 180, -10);
	ITEM.attachmentOffsetVector = Vector(3, 3, 8);

ITEM:Register();