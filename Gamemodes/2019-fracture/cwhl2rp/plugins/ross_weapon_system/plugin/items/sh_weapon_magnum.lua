local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "GOL Magnum sniper rifle";
	ITEM.model = "models/weapons/tfa_ins2/w_gol.mdl";
	ITEM.weight = 2.6;
	ITEM.uniqueID = "tfa_ins2_gol";
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