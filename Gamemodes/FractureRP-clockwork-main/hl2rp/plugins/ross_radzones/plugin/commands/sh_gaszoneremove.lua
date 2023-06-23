
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("GasZoneRemove");
COMMAND.tip = "Remove the highest scale gas zone you currently are in.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	
	local pos = player:GetShootPos();
	for k, v in pairs(PLUGIN.gasZones) do
		if (PLUGIN:IsInBox(pos, v.minimum, v.maximum)) then
			Clockwork.player:Notify(player, "You removed a gas zone with scale "..v.scale..".");
			PLUGIN.gasZones[k] = nil;
			PLUGIN:SaveGasZones();
			return;
		end;
	end;
	
	Clockwork.player:Notify(player, "There were no gas zones near your position.");
end;

COMMAND:Register();