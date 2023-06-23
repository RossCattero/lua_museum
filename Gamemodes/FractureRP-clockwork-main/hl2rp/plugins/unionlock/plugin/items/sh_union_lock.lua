local PLUGIN = PLUGIN;

local ITEM = Clockwork.item:New();
ITEM.name = "Замок союза";
ITEM.model = "models/props_combine/combine_lock01.mdl";
ITEM.weight = 4;
ITEM.category = "Замки";
ITEM.useText = "Поставить";
ITEM.description = "Замок для закрытия дверей, очень крепок.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if (IsValid(entity)) then
		if (entity:GetPos():Distance( player:GetPos() ) <= 192) then
			if (!IsValid(entity.unionLock)) then
				if (!Clockwork.entity:IsDoorFalse(entity)) then
					local angles = trace.HitNormal:Angle() + Angle(0, 270, 0);
					local position;
					
					if (string.lower( entity:GetClass() ) == "prop_door_rotating") then
						position = trace;
					else
						position = trace.HitPos + (trace.HitNormal * 4);
					end;
					
					if (!IsValid( PLUGIN:ApplyUnionLock(entity, position, angles) )) then
						return false;
					elseif (IsValid(entity.breach)) then
						entity.breach:CreateDummyBreach();
						entity.breach:Explode();
						entity.breach:Remove();
					end;
				else
					Clockwork.player:Notify(player, "This door cannot have a Combine lock!");
					
					return false;
				end;
			else
				Clockwork.player:Notify(player, "This entity already has a Combine lock!");
				
				return false;
			end;
		else
			Clockwork.player:Notify(player, "You are not close enough to the entity!");
			
			return false;
		end;
	else
		Clockwork.player:Notify(player, "That is not a valid entity!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();