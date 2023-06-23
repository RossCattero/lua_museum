--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.
]]

local COMMAND = Clockwork.command:FindByID("broadcast")
COMMAND.alias = {"Bro"};

function COMMAND:OnRun(player, arguments)
	if (player:GetFaction() == FACTION_ADMIN) then
		local text = table.concat(arguments, " ");
		
		if (text == "") then
			Clockwork.player:Notify(player, "Вы ввели недостаточное количество текста!");
			
			return;
		end;
		
		Schema:SayBroadcast(player, text);
		Schema:AddCombineDisplayLine("!ТРАНСЛЯЦИЯ: "..text, Color(212,111, 249, 255) );
	else
		Clockwork.player:Notify(player, "Вы не ГА!");
	end;
end;

COMMAND:Register();