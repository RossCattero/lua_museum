
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("GasMaskCheck", true);
	playerVars:Number("cid", true);

	globalVars:String("CityStatus", true);
end;