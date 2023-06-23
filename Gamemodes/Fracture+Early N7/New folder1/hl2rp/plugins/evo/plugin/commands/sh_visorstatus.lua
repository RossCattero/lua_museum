--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.
]]

local COMMAND = Clockwork.command:New("VisorStatus");
COMMAND.tip = "Send an update of the sociostability status via the visor.";
COMMAND.alias = {"Vstat"};
COMMAND.text = "<string green/yellow/red>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		if (Schema:IsPlayerCombineRank( player, {"SCN", "DvL", "SeC", "CmD", "EpU", "CmR"} ) or player:GetFaction() == FACTION_OTA or player:GetFaction() == FACTION_ADMIN or player:IsAdmin()) then
			local text = table.concat(arguments, " ");
			
			if (text == "ЗЕЛЕНЫЙ") then
				Schema:AddCombineDisplayLine( "!ВНМ: Изменение социостатуса: ЗЕЛЕНЫЙ.", Color(10, 255, 0, 255) );
				BroadcastLua("LocalPlayer():ConCommand('virgil1')")

			elseif (text == "ЖЕЛТЫЙ") then
				Schema:AddCombineDisplayLine( "!ВНМ: Изменение социостатуса: ЖЕЛТЫЙ.", Color(255, 255, 10, 255) );
				BroadcastLua("LocalPlayer():ConCommand('virgil1')")

			elseif (text == "КРАСНЫЙ") then
				Schema:AddCombineDisplayLine( "!ВНМ: Изменение социостатуса: КРАСНЫЙ.", Color(255, 10, 0, 255) );
				BroadcastLua("LocalPlayer():ConCommand('virgil2')")
				
			else
				Clockwork.player:Notify(player, "Не валидный статус!");
				
			end;
			
		else
			Clockwork.player:Notify(player, "Вы не можете это сделать!");
		end;
	else
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!");
	end;
end;



COMMAND:Register();