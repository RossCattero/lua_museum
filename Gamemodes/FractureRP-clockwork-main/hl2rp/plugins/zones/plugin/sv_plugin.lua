
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

PLUGIN.clientZones = {};

local function sortFunc(a, b)
	return a.scale > b.scale;
end;

function PLUGIN:LoadZone(zone)
	local tbl = Clockwork.kernel:RestoreSchemaData("plugins/zones/"..game.GetMap().."/"..zone.id, {});
	zone.areas = tbl.areas or {};
	zone.excluded = (zone.bUseExclusionAreas and tbl.excluded) or {};

	if (zone.bZoneScale) then
		table.sort(zone.areas, sortFunc);
	end;
end;

-- A function to load the gas zones
function PLUGIN:LoadZones()
	for id, zone in pairs(self.zones) do
		self:LoadZone(zone);
	end;

	for id, zone in pairs(self.clientZones) do
		self:LoadZone(zone);
	end;
end;

-- A function to save the gas zones
function PLUGIN:SaveZone(zone)
	if (!zone) then return; end;

	local tbl = {}
	if (#zone.areas > 0) then
		tbl.areas = zone.areas;
	end;

	if (zone.bUseExclusionAreas and #zone.excluded > 0) then
		tbl.excluded = zone.excluded;
	end;

	Clockwork.kernel:SaveSchemaData("plugins/zones/"..game.GetMap().."/"..zone.id, tbl);

	if (zone.bIsClientSide) then
		Clockwork.datastream:Start(nil, "UpdateZone", {zone.id, zone.areas, zone.excluded});
	else
		local admins = {};
		for k, v in ipairs(player.GetAll()) do
			if (Clockwork.player:IsAdmin(v)) then
				admins[#admins + 1] = v;
			end;
		end;
		Clockwork.datastream:Start(admins, "UpdateESPZone", {zone.id, zone.areas, zone.excluded});
	end;
end;

function PLUGIN:SaveZones()
	for k, zone in pairs(self.zones) do
		self:SaveZone(zone);
	end;

	for k, zone in pairs(self.clientZones) do
		self:SaveZone(zone);
	end;
end;