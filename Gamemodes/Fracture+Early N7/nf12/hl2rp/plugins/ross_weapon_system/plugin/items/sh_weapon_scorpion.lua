local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Scorpion EVO";
	ITEM.model = "models/weapons/tfa_ins2/w_scorpion_evo.mdl";
	ITEM.weight = 2.3;
	ITEM.uniqueID = "tfa_ins2_sc_evo";
	ITEM.category = "Оружие";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine1";
	ITEM.attachmentOffsetAngles = Angle(360, 180, -10);
	ITEM.attachmentOffsetVector = Vector(3, 3, 8);

ITEM:Register();