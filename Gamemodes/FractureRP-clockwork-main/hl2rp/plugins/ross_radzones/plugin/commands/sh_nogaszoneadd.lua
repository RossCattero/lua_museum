
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("NoGasZoneAdd");
COMMAND.tip = "Adds an area that contains no gas at all.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
	local areaPointData = player.areaPointData;
	local trace = player:GetEyeTraceNoCursor();
	
	if (!areaPointData) then
		player.areaPointData = {
			first = trace.HitPos
		};

		Clockwork.player:Notify(player, "You have added point A of the no-gas area, now add point B.");
	else
		local first = areaPointData.first;
		local second = trace.HitPos;
		
		local data = {
			minimum = Vector(math.min(first.x, second.x), math.min(first.y, second.y), math.min(first.z, second.z)),
			maximum = Vector(math.max(first.x, second.x), math.max(first.y, second.y), math.max(first.z, second.z)),
		};
		
		PLUGIN.noGasZones[#PLUGIN.noGasZones + 1] = data;
		PLUGIN:SaveNoGasZones();
		
		Clockwork.player:Notify(player, "You have added a no-gas zone.");
		
		player.areaPointData = nil;
	end;
end;

COMMAND:Register();