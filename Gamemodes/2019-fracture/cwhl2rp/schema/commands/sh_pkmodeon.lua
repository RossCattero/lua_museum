--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("PKModeOn");
COMMAND.tip = "Turn PK mode on for the given amount of minutes.";
COMMAND.text = "<number Minutes>";
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local minutes = tonumber( arguments[1] );
	
	if (minutes and minutes > 0) then
		Clockwork.kernel:SetSharedVar("PKMode", 1);
		Clockwork.kernel:CreateTimer("pk_mode", minutes * 60, 1, function()
			Clockwork.kernel:SetSharedVar("PKMode", 0);
			
			Clockwork.player:NotifyAll("Perma-kill mode has been turned off, you are safe now.");
		end);
		
		Clockwork.player:NotifyAll(player:Name().." has turned on perma-kill mode for "..minutes.." minute(s), try not to be killed.");
	else
		Clockwork.player:Notify(player, "This is not a valid amount of minutes!");
	end;
end;

COMMAND:Register();