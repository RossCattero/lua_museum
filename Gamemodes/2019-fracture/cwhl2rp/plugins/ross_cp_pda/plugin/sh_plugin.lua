
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:String("squad", true);
	playerVars:String("status", true);
	playerVars:String("info", true);
	playerVars:String("CombineRanke", true);

	playerVars:Number("ol", true);
	playerVars:Number("on", true);
	playerVars:String("work", true);
	playerVars:String("liveplace", true);
	playerVars:String("information", true);
end;