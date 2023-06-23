local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

-- A function to get if a faction is Vortigaunt.
function PLUGIN:IsVortigauntFaction(faction)
	return (faction == FACTION_VORT);
end;