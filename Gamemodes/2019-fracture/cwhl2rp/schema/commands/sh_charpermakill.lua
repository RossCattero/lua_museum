--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CharPermaKill");
COMMAND.tip = "Permanently kill a character.";
COMMAND.text = "<string Name>";
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	
	if (target) then
		if (!target:GetCharacterData("permakilled")) then
			Schema:PermaKillPlayer(target, target:GetRagdollEntity());
		else
			Clockwork.player:Notify(player, "This character is already permanently killed!");
			
			return;
		end;
		
		Clockwork.player:NotifyAll(player:Name().." permanently killed the character '"..target:Name().."'.");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();