
local PLUGIN = PLUGIN;
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)

	playerVars:Float("hunger", true);
	playerVars:Float("thirst", true);
	playerVars:Float("sleep", true);
end;

function PlayerIsSleeping(p)
    local action, percentage = Clockwork.player:GetAction(p, true);

    if action == "sleeping" then
        return true;
    end;

    return false;
end;