
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("GasZoneAdd");
COMMAND.tip = "Add a gas area that will make the player take damage.";
COMMAND.text = "[number Scale]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.optionalArguments = 1;

function COMMAND:OnRun(player, arguments)
	local areaPointData = player.areaPointData;
	local trace = player:GetEyeTraceNoCursor();
	
	if (!areaPointData) then
		player.areaPointData = {
			first = trace.HitPos
		};

		Clockwork.player:Notify(player, "You have added point A of the gas area, now add point B.");
	else
		if (!arguments[1] or !tonumber(arguments[1])) then
			arguments[1] = 1;
		end;
		
		local first = areaPointData.first;
		local second = trace.HitPos;
		
		local data = {
			minimum = Vector(math.min(first.x, second.x), math.min(first.y, second.y), math.min(first.z, second.z)),
			maximum = Vector(math.max(first.x, second.x), math.max(first.y, second.y), math.max(first.z, second.z)),
			scale = tonumber(arguments[1])
		};
		
		PLUGIN.gasZones[#PLUGIN.gasZones + 1] = data;
		PLUGIN:SaveGasZones();

		player.areaPointData = nil;

		table.sort(PLUGIN.gasZones, function(a, b) return tonumber(a.scale) > tonumber(b.scale) end);
		
		Clockwork.player:Notify(player, "You have added a gas zone.");
	end;
end;

COMMAND:Register();