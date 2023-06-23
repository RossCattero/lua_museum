
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("NoRGasZoneRemove");
COMMAND.tip = "Remove a no-gas zone that you are in.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	
	local pos = player:GetShootPos();
	for k, v in pairs(PLUGIN.noGasZones) do
		if (PLUGIN:IsInBox(pos, v.minimum, v.maximum)) then
			Clockwork.player:Notify(player, "You removed a no-gas zone.");
			PLUGIN.noGasZones[k] = nil;
			PLUGIN:SaveNoGasZones();
			return;
		end;
	end;
	
	Clockwork.player:Notify(player, "There were no no-gas zones near your position.");
end;

COMMAND:Register();