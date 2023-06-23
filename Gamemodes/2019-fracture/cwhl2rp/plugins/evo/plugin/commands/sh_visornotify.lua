--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.
]]

local COMMAND = Clockwork.command:New("VisorNotify");
COMMAND.tip = "Notify other units of your '10-' status via the visor.";
COMMAND.text = "<string 10-8/10-7>";
COMMAND.alias = {"Vnot"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	
	if (Schema:PlayerIsCombine(player)) then
			local text = table.concat(arguments, " ");

			local CP = player:GetCharacterData("CombinedInfo")

			if text == "10-8" then
				CP["Status"] = text;
				Schema:AddCombineDisplayLine( "!УВЕД: "..player:Name().." теперь "..text, Color(20, 255, 20, 255) );
			elseif text == "10-7" then
				CP["Status"] = text;
				Schema:AddCombineDisplayLine( "!УВЕД: "..player:Name().." теперь "..text, Color(80, 255, 20, 255) );
			end;

	else
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!");
	end;
end;



COMMAND:Register();