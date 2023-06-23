--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("PKModeOff");
COMMAND.tip = "Turn PK mode off and cancel the timer.";
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.kernel:SetSharedVar("PKMode", 0);
	Clockwork.kernel:DestroyTimer("pk_mode");
	
	Clockwork.player:NotifyAll(player:Name().." has turned off perma-kill mode, you are safe now.");
end;

COMMAND:Register();