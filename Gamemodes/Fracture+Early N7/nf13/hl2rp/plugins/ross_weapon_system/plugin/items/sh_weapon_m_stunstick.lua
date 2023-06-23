local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Парализатор";
	ITEM.model = "models/weapons/w_stunbaton.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "cw_stunstick";
	ITEM.isMeleeWeapon = true;
	ITEM.category = "Оружие";
	ITEM.isAttachment = true;

	ITEM.attachmentBone = "ValveBiped.Bip01_Pelvis";
	ITEM.attachmentOffsetAngles = Angle(360, 290, 90);
	ITEM.attachmentOffsetVector = Vector(5, -3, -4);
ITEM:Register();