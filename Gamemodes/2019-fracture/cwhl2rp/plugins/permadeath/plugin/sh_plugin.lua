--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

Clockwork.flag:Add("d", "Death", "Flag for disable perma death.");

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("Lifes", true);
	playerVars:Bool("permakilled", true);
end;

Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");