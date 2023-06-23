local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");

-- A function to get if a faction is an Antlion.
function PLUGIN:IsAntlionFaction(faction)
	return (faction == FACTION_ANTLION);
end;