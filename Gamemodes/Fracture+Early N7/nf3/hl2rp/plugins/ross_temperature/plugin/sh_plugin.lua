
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)

    playerVars:Float("headtemp", true);
    playerVars:Float("bodytemp", true);
    playerVars:Float("legstemp", true);
    playerVars:Float("handstemp", true);
end;