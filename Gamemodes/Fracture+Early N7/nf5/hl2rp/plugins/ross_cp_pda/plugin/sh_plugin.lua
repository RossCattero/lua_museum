
local PLUGIN = PLUGIN;

PLUGIN:SetGlobalAlias("CP_PDA");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:String("squad");
	playerVars:String("status");
	playerVars:String("info");
	playerVars:String("CombineRanke");

	playerVars:Number("ol");
	playerVars:Number("on");
	playerVars:String("work");
	playerVars:String("liveplace");
	playerVars:String("information");
end;