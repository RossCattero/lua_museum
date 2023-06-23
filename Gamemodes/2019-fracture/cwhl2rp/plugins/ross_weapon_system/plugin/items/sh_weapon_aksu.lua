local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "AK-74U";
	ITEM.model = "models/weapons/tfa_ins2/w_aks74u.mdl";
	ITEM.weight = 2.1;
	ITEM.uniqueID = "tfa_ins2_aks74u";
	ITEM.category = "Оружие";
	ITEM.description = "";
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
	ITEM.attachmentOffsetAngles = Angle(-160, 220, -10);
	ITEM.attachmentOffsetVector = Vector(-5, -10, 3);

function ITEM:AdjustAttachmentOffsetInfo(player, entity, info)
	if ( string.find(player:GetModel(), "female") ) then
		info.offsetAngle = Angle(-160, 220, -10);
		info.offsetVector = Vector(-5, -6, 3);
	end;
end;

ITEM:Register();