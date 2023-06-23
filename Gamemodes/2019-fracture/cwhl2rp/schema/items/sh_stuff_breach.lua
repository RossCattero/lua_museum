--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Взрывчатка";
ITEM.model = "models/Items/combine_rifle_ammo01.mdl";
ITEM.weight = 0.5;
ITEM.category = "Прочее";
ITEM.useText = "Установить";
ITEM.blacklist = {CLASS_MPR};
ITEM.description = "Заряд, с помощью которого можно что-нибудь взорвать.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if (IsValid(entity)) then
		if (entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
			if (!IsValid(entity.breach)) then
				if (Clockwork.plugin:Call("PlayerCanBreachEntity", player, entity)) then
					local breach = ents.Create("cw_breach"); breach:Spawn();
					
					breach:SetBreachEntity(entity, trace);
				else
					Clockwork.player:Notify(player, "Этот объект не может быть взорван!");
					
					return false;
				end;
			else
				Clockwork.player:Notify(player, "Этот объект уже взорван!");
				
				return false;
			end;
		else
			Clockwork.player:Notify(player, "Ты далеко от объекта!");
			
			return false;
		end;
	else
		Clockwork.player:Notify(player, "Это неподходящий объект!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();