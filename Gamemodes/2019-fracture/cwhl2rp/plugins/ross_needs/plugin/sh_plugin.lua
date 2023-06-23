
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("hunger", true);
	playerVars:Number("thirst", true);
	playerVars:Number("sleep", true);
	playerVars:Number("clean", true);

	playerVars:Bool("StartingSleep", true);
end;