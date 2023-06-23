--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.
]]

/*----------------------\
| Edited by Viomi       |
| viomi@openmailbox.org | // Removed all the god damn semi-colons
\----------------------*/

local COMMAND = Clockwork.command:New("VisorComms")
COMMAND.tip = "Send a notification to other online units via the visor."
COMMAND.text = "<string Text>"
COMMAND.alias = {"Vcom"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER)
COMMAND.arguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player) && player:GetCharacterData("GasMaskInfo") >= 2) then
		if (player:GetFaction() == FACTION_OTA or player:GetFaction() == FACTION_ADMIN or player:GetFaction() == FACTION_MPF) then
			local text = table.concat(arguments, " ")
			
			if (text == "") then
				Clockwork.player:Notify(player, "Вы ввели недостаточное количество текста!")
				
				return
			end
			Schema:AddCombineDisplayLine( "!СООБЩ: "..player:Name()..": "..utf8.sub(text, 1, 50).. "...", Color(0, 128, 255, 255) );
            if (utf8.len(text) > 50) then
            Schema:AddCombineDisplayLine( "..."..utf8.sub(text, 50, 100).."...", Color(0, 128, 255, 255) ); 
            end;
            if (utf8.len(text) > 100) then
            	Schema:AddCombineDisplayLine( "..."..utf8.sub(text, 100).."...", Color(0, 128, 255, 255) );
            end
			BroadcastLua("LocalPlayer():ConCommand('virgil1')")
		else
			Clockwork.player:Notify(player, "Вы не можете это сделать сейчас!")
		end
	else
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!")
	end
end



COMMAND:Register()