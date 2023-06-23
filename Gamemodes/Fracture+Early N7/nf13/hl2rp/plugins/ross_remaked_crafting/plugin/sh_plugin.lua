
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function table.Compare( a, b )
	table.sort(a)
	table.sort(b)
 
	for k, v in pairs( a ) do
		if ( type(v) == "table" && type(b[k]) == "table" ) then
			if ( !table.Compare( v, b[k] ) ) then
				return false
			end;
		elseif ( v != b[k] ) then
			return false
		end;
	end;

	for k, v in pairs( b ) do
		if ( type(v) == "table" && type(a[k]) == "table" ) then
			if ( !table.Compare( v, a[k] ) ) then 
				return false 
			end;
		elseif ( v != a[k] ) then 
			return false 
		end;
	end;

	return true 
end;

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)

	globalVars:Number("RationPhase", true);
end;