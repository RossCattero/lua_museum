
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

local math = math;
local mc = math.Clamp

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
end;

function IncSkill(player, index, inc)

	Clockwork.attributes:Update(player, index, inc)
	return;

end;

function BoostSkill(player, id, index, inc, dur)
	if !dur then
		dur = 360;
	end;

	Clockwork.attributes:Boost(player, id, index, inc, dur)
	return;

end;

function GetSkillValue(player, id)
	return Clockwork.attributes:Get(player, id, false)
end;