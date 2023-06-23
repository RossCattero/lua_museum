local COMMAND = Clockwork.command:New("VRoll");
COMMAND.tip = "";
COMMAND.flags = CMD_DEFAULT;

function CountDistance()
	-- Дистанция
end;

function CountStatistics()
	-- Аттрибуты жертвы и нападающего
end;

function CountAttributes()
	-- Аттрибуты нападющего
end;

function COMMAND:OnRun(player, arguments)
	local fac = player:GetFaction() == FACTION_VORTIGAUNT
	if !fac then
		Clockwork.player:Notify(player, 'Вы не вортигонт!')
		return;
	end;


	-- Clockwork.chatBox:AddInRadius(player, "roll", "кинул кубики и получил "..random.."/100", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
end;
COMMAND:Register();