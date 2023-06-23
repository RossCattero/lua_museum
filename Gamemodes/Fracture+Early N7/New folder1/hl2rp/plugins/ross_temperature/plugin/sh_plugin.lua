
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)

    playerVars:Number("headtemp", true);
    playerVars:Number("bodytemp", true);
    playerVars:Number("legstemp", true);
    playerVars:Number("handstemp", true);
end;