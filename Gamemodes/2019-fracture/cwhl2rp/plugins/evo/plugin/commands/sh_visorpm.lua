/*----------------------\
| Created by Viomi      |
| viomi@openmailbox.org |
\----------------------*/

local Clockwork = Clockwork

local COMMAND = Clockwork.command:New("VisorPM")
COMMAND.tip = "Send a private message to a unit using their visor."
COMMAND.text = "<string Name> <string Text>"
COMMAND.alias = {"Vpm"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER)
COMMAND.arguments = 2

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])

	if (Schema:PlayerIsCombine(player) && player:GetCharacterData("GasMaskInfo") >= 2) then
		if (player:GetFaction() == FACTION_OTA or player:GetFaction() == FACTION_ADMIN or player:GetFaction() == FACTION_MPF) then
			local text = table.concat(arguments, " ", 2)
			
			if (text == "") then
				Clockwork.player:Notify(player, "Вы не ввели текст!")
				
				return
			end
			
			if (target) then
				Schema:AddCombineDisplayLine( "!ПОЛУЧ: "..player:Name()..": "..text, Color(128, 0, 255, 255), target)
				Schema:AddCombineDisplayLine( "!ОТПРАВ: "..target:Name()..": "..text, Color(128, 255, 0, 255), player)
				BroadcastLua("LocalPlayer():ConCommand('virgil1')")
			else
				Clockwork.player:Notify(player, arguments[1].." не валидный юнит!")
			end
		else
			Clockwork.player:Notify(player, "Вы не можете делать это сейчас!")
		end
	else
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!")
	end
end

COMMAND:Register()