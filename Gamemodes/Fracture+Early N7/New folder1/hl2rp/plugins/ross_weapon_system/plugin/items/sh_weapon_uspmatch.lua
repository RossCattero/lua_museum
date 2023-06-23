local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "HK Usp match";
	ITEM.model = "models/weapons/tfa_ins2/w_usp_match.mdl";
	ITEM.weight = 1.2;
	ITEM.category = "Оружие";
	ITEM.uniqueID = "tfa_ins2_usp_match";
	ITEM.description = "";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine1";
	ITEM.attachmentOffsetAngles = Angle(360, 90, -10);
	ITEM.attachmentOffsetVector = Vector(-6, 3, 8);

ITEM:Register();