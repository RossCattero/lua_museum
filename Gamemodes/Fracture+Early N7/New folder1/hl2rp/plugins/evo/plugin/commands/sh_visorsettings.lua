--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.
]]

local COMMAND = Clockwork.command:New("VisorSettings");
COMMAND.tip = "Open the visor settings menu to configure your EVO experience.";
COMMAND.text = "<none>";
COMMAND.alias = {"Visset"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player) && player:GetCharacterData("GasMaskInfo") >= 2) then
			player:ConCommand("evo_settings")
	else
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!");
	end;
end;



COMMAND:Register();