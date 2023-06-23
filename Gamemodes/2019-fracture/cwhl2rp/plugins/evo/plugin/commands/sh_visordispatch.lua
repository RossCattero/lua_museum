--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.
]]

local COMMAND = Clockwork.command:New("VisorDispatch");
COMMAND.tip = "Talk as Dispatch through the combine visor.";
COMMAND.text = "<string Text>";
COMMAND.alias = {"Vdis"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		if (Schema:IsPlayerCombineRank( player, {"SCN", "SeC", "CmD", "DvL", "CmR", "OfC", "EpU"} ) or player:GetFaction() == FACTION_OTA or player:GetFaction() == FACTION_ADMIN && player:GetCharacterData("GasMaskInfo") >= 2) then
			local text = table.concat(arguments, " ");
			
			if (text == "") then
				Clockwork.player:Notify(player, "Вы ввели недостаточное количество текста!");
				
				return;
			end;
			
			Schema:AddCombineDisplayLine( "!ДИСПЕТЧЕР: "..text, Color(255, 150, 0, 255) );
			BroadcastLua("LocalPlayer():ConCommand('virgil1')")
		else
			Clockwork.player:Notify(player, "Вы не можете этого сделать!");
		end;
	else
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!");
	end;
end;



COMMAND:Register();