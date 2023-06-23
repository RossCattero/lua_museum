local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "База постеров";
ITEM.uniqueID = "poster_base";
ITEM.model = "models/props_junk/garbage_bag001a.mdl";
ITEM.weight = 50;
ITEM.useText = "Повесить плакат";
ITEM.category = "Плакаты";
ITEM.description = "";
ITEM.useSound = "items/ammopickup.wav";
ITEM.postermodel = "";

function ITEM:OnUse(player, itemEntity)

local trace = player:GetEyeTraceNoCursor();
local tr = player:GetEyeTrace();
local action, percentage = Clockwork.player:GetAction(player, true);

	if (player:GetShootPos():Distance(trace.HitPos) <= 70 && action != "StickTo" && GetStuffNear(player, 90, "ross_create_poster") == false) then
		Clockwork.player:SetAction(player, "StickTo", 10, 5, function()
		if player:GetShootPos():Distance(trace.HitPos) <= 70 && GetStuffNear(player, 90) == false then
			local entity = ents.Create("ross_create_poster");
			entity:SetModel(self("postermodel"));
			entity:SetPos(tr.HitPos + tr.HitNormal);
			entity:SetAngles(player:GetAngles() + Angle(0, 180, 0));
			entity:SetCollisionGroup( 20 );
			entity:SetUniqueEIDI(self("uniqueID"))
			entity:Spawn();
			player:TakeItem(self)
		end;
			Clockwork.player:SetAction(player, "StickTo", false);
		end);
	else
		Clockwork.player:Notify(player, "Вы должны стоять близко к стене, чтобы сделать это(Или рядом есть постеры)!")
	end;
	return false;
end;

function ITEM:OnDrop(player, position) 

	return true
end;


function ITEM:GetClientSideInfo()
	if (!self:IsInstance()) then return; end;

	local clientSideInfo = "";

	clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, ".", Color(234, 112, 30));
		
	return (clientSideInfo != "" and clientSideInfo);
end;

Clockwork.item:Register(ITEM);