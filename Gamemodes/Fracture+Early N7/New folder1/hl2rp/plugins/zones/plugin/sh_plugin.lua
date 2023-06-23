
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local table = table;
local math = math;
local type = type;
local tonumber = tonumber;
local ipairs = ipairs;

PLUGIN.zones = {};
PLUGIN.tickTimes = {};

PLUGIN.zonesFuncOnChange = {};
PLUGIN.zonesFuncOnTick = {};
PLUGIN.zonesFuncShouldCheck = {};
PLUGIN.zonesFuncESPText = {};

PLUGIN.playerNextZoneChecks = {};
PLUGIN.playerZones = {};

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

local playerMeta = FindMetaTable("Player");

function playerMeta:IsInZone(id)
	if (PLUGIN.playerZones[self][id]) then
		if (isnumber(PLUGIN.playerZones[self][id])) then
			return PLUGIN.playerZones[self][id] != 0;
		else
			return PLUGIN.playerZones[self][id] == true;
		end;
	end;

	return false;
end;

function playerMeta:GetZoneValue(id)
	if (PLUGIN.playerZones[self][id] == nil) then
		if ((PLUGIN.zones[id] and PLUGIN.zones[id].bZoneScale) or
			(SERVER and PLUGIN.clientZones[id] and PLUGIN.clientZones[id].bZoneScale)) then
			return 0;
		else
			return false;
		end;
	end;

	return PLUGIN.playerZones[self][id];
end;

--[[
	--- ARGUMENT OVERVIEW ---
	id: internal id of the zone

	zoneName: the name of the zone (will be used in the ESP and commands)

	tickTime: how many seconds to wait in between checking the zone, aka a zoneTick. A lower tickTime updates zone changes faster, but also causes more load

	options: table with optional fields (see below for option descriptions and an example table)

	cmdArgs: table with command argument related options (see below for option descriptions and an example talbe)

	bUseExclusionAreas: allow this zone to have exclusion areas where the player will always be counted as not being in the zone

	bZoneScale: allow various zones to have a different strength. A higher scale gives a higher strength and thus a higher priority. If this is true

		then the scale number will be given as an indication if the player is in the zone or not (0 = not in the zone, something else = player is in a zone with that scale).
		The shared var will be a number as well instead of a boolean.

	bIsClientSide: do all calculations client-side

	bShared: makes the client update the server, allowing you to use funcOnTick and funcOnChange server-side even if bIsClientSide is true

	bSharedVar: makes the server set the shared var as well. Note that if bIsClientSide is true, bShared will be forced to true if bSharedVar is true

	funcOnTick: this function will be called every zone tick (see tickTime), using the following arguments: function(player, id, isInZone/zoneScale)

	funcOnChange: this function will be called whenever the player enters or leaves a zone, using the following arguments: function(player, id, oldValue, newValue)

	funcShouldCheck: this function will be called to determine if a zone check should happen. Returning false will skip zone checking for the given player for that tick.

	funcESPText: this function can be used to return your own ESP text.

	areaColor = ESP color for included areas

	exclusionColor = ESP color for excluded areas

	args = amount of arguments (this will be forced!)

	text = text with list of arguments to display (e.g. "<String AreaName> <Boolean Restricted>")
	
	funcOnAdd = this function will be called and should return true if the area can be added and optionally an info table with additional area info.
		Returning false will stop the area from being added, an error message to be printed to the player can be returned as second return-value in this case.

	--- EXAMPLE TABLES ---
	Options table: {bUseExclusionAreas = false, bZoneScale = false, bIsClientSide = false, bShared = false, bSharedVar = false,
		funcOnTick = function(player, id, InZone/Scale, [areaData]), funcOnChange = function(player, id, oldValue, newValue, [areaData]),
		funcShouldCheck = function(player, id), funcESPText = function(id, zoneName, areaInfo, [scale]),
		areaColor = Color(255, 255, 255), exclusionColor = Color(0, 0, 255)}
	CommandArgs table: {args = 0, text = "", funcOnAdd = function(player, arguments, id, areaData)}
]]
function Schema:RegisterZone(id, zoneName, tickTime, options, cmdArgs)
	if (!isstring(id) or !isstring(zoneName)) then
		local text = "'"..id.."'" or "with no id";
		ErrorNoHalt("Couldn't register zone "..text);
		return;
	end;

	local zone = {id = id, bUseExclusionAreas = options.bUseExclusionAreas,
		bZoneScale = options.bZoneScale, bIsClientSide = options.bIsClientSide,
		bShared = options.bShared, bSharedVar = options.bSharedVar};

	if (zone.bIsClientSide and zone.bSharedVar) then
		zone.bShared = true;
	end;

	PLUGIN.tickTimes[id] = tickTime;

	PLUGIN.zonesFuncOnChange[id] = options.funcOnChange;
	PLUGIN.zonesFuncOnTick[id] = options.funcOnTick;

	if ((zone.bIsClientSide and CLIENT) or (!zone.bIsClientSide and SERVER)) then
		PLUGIN.zonesFuncShouldCheck[id] = options.funcShouldCheck;
	end;

	if (CLIENT) then
		zone.zoneName = zoneName;
		zone.areaColor = options.areaColor or Color(255, 255, 255);
		zone.exclusionColor = options.exclusionColor or Color(0, 0, 255);
		PLUGIN.zonesFuncESPText[id] = options.funcESPText;

		if (zone.bIsClientSide) then
			PLUGIN.zones[id] = zone;
		else
			PLUGIN.espZones[id] = zone;
		end;
	else
		if (zone.bIsClientSide) then
			PLUGIN.clientZones[id] = zone;
		else
			PLUGIN.zones[id] = zone;
		end;
	end;

	do
		local COMMAND = Clockwork.command:New(id.."Add");
		COMMAND.tip = "Add a "..zoneName:lower().." area.";
		COMMAND.flags = CMD_DEFAULT;
		COMMAND.access = "s";

		if (cmdArgs) then
			COMMAND.arguments = cmdArgs.args;
			COMMAND.text = cmdArgs.text;
		end;

		if (zone.bZoneScale) then
			if (COMMAND.text) then
				COMMAND.text = COMMAND.text.." [number Scale|Default: 1]";
			else
				COMMAND.text = "[number Scale|Default: 1]";
			end;
			COMMAND.optionalArguments = 1;
		end;

		function COMMAND:OnRun(player, arguments)
			local trace = player:GetEyeTraceNoCursor();
			
			if (!player.areaPointData) then
				player.areaPointData = trace.HitPos

				Clockwork.player:Notify(player, "You have added point A of the area, now add point B.");
			else
				local first = player.areaPointData;
				local second = trace.HitPos;
				player.areaPointData = nil;
				
				local data = {
					minimum = Vector(math.min(first.x, second.x), math.min(first.y, second.y), math.min(first.z, second.z)),
					maximum = Vector(math.max(first.x, second.x), math.max(first.y, second.y), math.max(first.z, second.z))
				};

				if (zone.bZoneScale) then
					if (!arguments[self.arguments + 1] or !tonumber(arguments[self.arguments + 1])) then
						arguments[self.arguments + 1] = 1;
					end;
					data.scale = tonumber(arguments[self.arguments + 1]);
				end;

				if (cmdArgs) then
					local success, info = cmdArgs.funcOnAdd(player, arguments, id, data);
					if (success == false) then
						if (info) then
							Clockwork.player:Notify(player, info);
						else
							Clockwork.player:Notify(player, "The area couldn't be added.");
						end;
						return;
					else
						data.info = info;
					end;
				end;

				if (zone.bZoneScale) then
					local notAdded = true;
					for k, area in ipairs(zone.areas) do
						if (area.scale < data.scale) then
							table.insert(zone.areas, k, data);
							notAdded = false;
							break;
						end;
					end;

					if (notAdded) then
						zone.areas[#zone.areas + 1] = data;
					end;
				else
					zone.areas[#zone.areas + 1] = data;
				end;
				
				PLUGIN:SaveZone(zone);
				
				Clockwork.player:Notify(player, "You have added a "..zoneName:lower()..".");
			end;
		end;

		COMMAND:Register();
	end;

	if (options.bUseExclusionAreas) then
		local COMMAND = Clockwork.command:New(id.."AddExclusion");
		COMMAND.tip = "Add a "..zoneName:lower().." exclusion area.";
		COMMAND.flags = CMD_DEFAULT;
		COMMAND.access = "s";

		function COMMAND:OnRun(player, arguments)
			local trace = player:GetEyeTraceNoCursor();
			
			if (!player.areaPointData) then
				player.areaPointData = trace.HitPos

				Clockwork.player:Notify(player, "You have added point A of the area, now add point B.");
			else
				local first = player.areaPointData;
				local second = trace.HitPos;
				player.areaPointData = nil;
				
				local data = {
					minimum = Vector(math.min(first.x, second.x), math.min(first.y, second.y), math.min(first.z, second.z)),
					maximum = Vector(math.max(first.x, second.x), math.max(first.y, second.y), math.max(first.z, second.z))
				};
				
				zone.excluded[#zone.excluded + 1] = data;
				
				PLUGIN:SaveZone(zone);
				
				Clockwork.player:Notify(player, "You have added a "..zoneName:lower().." exclusion area.");
			end;
		end;

		COMMAND:Register();
	end;

	do
		local COMMAND = Clockwork.command:New(id.."Remove");
		if (zone.bZoneScale) then
			COMMAND.tip = "Remove the highest scale "..zoneName:lower().. " area you currently are standing in.";
		else
			COMMAND.tip = "Remove the "..zoneName:lower().." area you currently are standing in.";
		end;
		COMMAND.flags = CMD_DEFAULT;
		COMMAND.access = "s";

		-- Called when the command has been run.
		function COMMAND:OnRun(player, arguments)
			local pos = player:GetShootPos();
			for k, area in ipairs(zone.areas) do
				if (PLUGIN:IsInBox(pos, area.minimum, area.maximum)) then
					if (zone.bZoneScale) then
						Clockwork.player:Notify(player, "You removed a "..zoneName:lower().." area with scale "..area.scale..".");
					else
						Clockwork.player:Notify(player, "You removed a "..zoneName:lower().." area.");
					end;

					table.remove(zone.areas, k);
					PLUGIN:SaveZone(zone);
					return;
				end;
			end;
			
			Clockwork.player:Notify(player, "There were no "..zoneName:lower().." areas near your position.");
		end;

		COMMAND:Register();
	end;

	if (options.bUseExclusionAreas) then
		local COMMAND = Clockwork.command:New(id.."RemoveExclusion");
		COMMAND.tip = "Remove the "..zoneName:lower().." exclusion area you currently are standing in.";
		COMMAND.flags = CMD_DEFAULT;
		COMMAND.access = "s";

		-- Called when the command has been run.
		function COMMAND:OnRun(player, arguments)
			local pos = player:GetShootPos();
			for k, area in ipairs(zone.excluded) do
				if (PLUGIN:IsInBox(pos, area.minimum, area.maximum)) then
					Clockwork.player:Notify(player, "You removed a "..zoneName:lower().." exclusion area.");

					table.remove(zone.excluded, k);
					PLUGIN:SaveZone(zone);
					return;
				end;
			end;
			
			Clockwork.player:Notify(player, "There were no "..zoneName:lower().." exclusion areas near your position.");
		end;

		COMMAND:Register();
	end;
end;

-- A function to efficiently detect if a vector is in a box
-- Minimum already has all the minimum co-ordinates, maximum already has all the maximum co-ordinates
function PLUGIN:IsInBox(position, minimum, maximum)
	if ((position.x >= minimum.x and position.x <= maximum.x)
		and (position.y >= minimum.y and position.y <= maximum.y)
		and (position.z >= minimum.z and position.z <= maximum.z)) then
		return true;
	end;

	return false;
end;

function PLUGIN:SetupPlayer(player)
	self.playerNextZoneChecks[player] = {};
	self.playerZones[player] = {};
end;