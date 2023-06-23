
local PLUGIN = PLUGIN;
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");


function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)

	playerVars:Bool("Eyeache", true);
	playerVars:Bool("DiseaseEyeache", true);
end;