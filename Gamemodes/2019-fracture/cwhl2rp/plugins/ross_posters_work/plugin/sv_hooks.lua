
local PLUGIN = PLUGIN;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local ec = entity:GetClass();

	if (ec == "ross_create_poster" && arguments == "r_poster_pinup") then
		Clockwork.player:SetAction(player, "TakeDownTheShit", 6);
			Clockwork.player:EntityConditionTimer(player, entity, entity, 6, 192, function()
				return player:Alive() and !player:IsRagdolled()
			end, function(success)
			if (success) then
				entity:EmitSound("physics/wood/wood_solid_impact_soft1.wav");
				Clockwork.entity:CreateItem(player, Clockwork.item:CreateInstance(entity:GetUniqueEIDI()), entity:GetPos() + Vector(-5, 0, 0));
				entity:Remove();
			end;
	
			Clockwork.player:SetAction(player, "TakeDownTheShit", false);
		end);
	end;

end;

function PLUGIN:PlayerThink(player, curTime, infoTable) 

    if (player:GetVelocity():Length() > 0) then
    	Clockwork.player:SetAction(player, "StickTo", false);
  	
    	return;
    end;

end;