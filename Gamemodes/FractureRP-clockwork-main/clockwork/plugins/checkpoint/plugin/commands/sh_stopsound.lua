
local COMMAND = Clockwork.command:New("StopSound");
COMMAND.tip = "Runs stopsound on all players.";
COMMAND.text = "[bool StopQueue]";
COMMAND.access = "s";
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.datastream:Start(nil, "stop_sound", {true});

	if (arguments and arguments[1]) then
		local bool = arguments[1];

		if (bool != "0" and bool != 0 and bool != "false" and bool != false) then
			Clockwork.datastream:Start(nil, "stop_queue", {true});
		end;
	end;
end;

if (CLIENT) then
	Clockwork.datastream:Hook("stop_sound", function(data)
		Clockwork.Client:ConCommand("stopsound");
	end);
end;

COMMAND:Register();