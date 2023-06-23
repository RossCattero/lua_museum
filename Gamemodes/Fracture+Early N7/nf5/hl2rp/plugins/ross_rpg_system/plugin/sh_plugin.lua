
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

local math = math;
local mc = math.Clamp

function GetSkillValue(player, id)
	return Clockwork.attributes:Get(player, id, false)
end;