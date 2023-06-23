--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("PlyAddServerWhitelist");
COMMAND.tip = "Add a player to a server whitelist.";
COMMAND.text = "<string Name> <string ID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	local identity = string.lower( arguments[2] );
	
	if (target) then
		if (target:GetData("serverwhitelist")[identity]) then
			Clockwork.player:Notify(player, target:Name().." is already on the '"..identity.."' server whitelist!");
			
			return;
		else
			target:GetData("serverwhitelist")[identity] = true;
		end;
		
		Clockwork.player:SaveCharacter(target);
		
		Clockwork.player:NotifyAll(player:Name().." has added "..target:Name().." to the '"..identity.."' server whitelist.");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

COMMAND:Register();