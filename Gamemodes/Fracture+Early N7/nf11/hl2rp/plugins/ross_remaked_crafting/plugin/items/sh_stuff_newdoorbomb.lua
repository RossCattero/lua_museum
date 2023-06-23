local ITEM = Clockwork.item:New();
ITEM.name = "Дверная бомба";
ITEM.model = "models/Items/battery.mdl";
ITEM.weight = 0.6;
ITEM.category = "Прочее";
ITEM.uniqueID = "door_bomb_new"
ITEM.useText = "Установить";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	local notFalseDoor = !Clockwork.entity:IsDoorFalse(entity);
	local isdoor = Clockwork.entity:IsDoor(entity);
	local angles = player:GetAngles();
	local pos = trace.HitPos;
	pos.x = pos.x + 2

	if (isdoor) then
		if (notFalseDoor) then
			local doorBomb = ents.Create("door_bomb"); 
			doorBomb:SetPos(trace.HitPos);
			doorBomb:SetAngles(angles)
			doorBomb:SetParent(trace.Entity);
			doorBomb:Spawn();
			doorBomb:EmitSound('hl1/fvox/activated.wav');

			if IsValid(doorBomb) && IsValid(entity) then
				doorBomb:ActivateSmokeCharge((entity:GetPos() - player:GetPos()):GetNormal() * 10000, entity);
			end;

		end;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();