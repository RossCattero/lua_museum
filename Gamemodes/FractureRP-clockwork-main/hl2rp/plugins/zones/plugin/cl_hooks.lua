
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

PLUGIN.espZones = {};

local surface = surface;
local Vector = Vector;

local zoneESP = Clockwork.kernel:CreateClientConVar("cwZoneEsp", 0, true, false);

Clockwork.setting:AddCheckBox("Framework", "Enable the zone ESP.", "cwZoneEsp", "Whether or not to show the zone admin ESP.", function()
	return Clockwork.Client:IsSuperAdmin();
end);

Clockwork.datastream:Hook("Zones", function(data)
	for k, v in pairs(data) do
		PLUGIN.zones[k].areas = v.areas;
		PLUGIN.zones[k].excluded = v.excluded;
	end;
end);

Clockwork.datastream:Hook("UpdateZone", function(data)
	PLUGIN.zones[data[1]].areas = data[2];
	PLUGIN.zones[data[1]].excluded = data[3];
end);

Clockwork.datastream:Hook("ESPZones", function(data)
	for k, v in pairs(data) do
		PLUGIN.espZones[k].areas = v.areas;
		PLUGIN.espZones[k].excluded = v.excluded;
	end;
end);

Clockwork.datastream:Hook("UpdateESPZone", function(data)
	PLUGIN.espZones[data[1]].areas = data[2];
	PLUGIN.espZones[data[1]].excluded = data[3];
end);

Clockwork.datastream:Hook("PlayerZoneChange", function(data)
	local id, inZoneValue, areaData = data[1], data[2], data[3];
	if (PLUGIN.zonesFuncOnChange[id]) then
		PLUGIN.zonesFuncOnChange[id](Clockwork.Client, id, player:GetZoneValue(id), inZoneValue, areaData);
	end;

	PLUGIN.playerZones[Clockwork.Client][id] = inZoneValue;
end);

local function DrawBox(min, max, color)
	local corner1 = min:ToScreen();
	local corner2 = Vector(min.x, max.y, min.z):ToScreen();
	local corner3 = Vector(max.x, max.y, min.z):ToScreen();
	local corner4 = Vector(max.x, min.y, min.z):ToScreen();
	local corner5 = Vector(min.x, min.y, max.z):ToScreen();
	local corner6 = Vector(min.x, max.y, max.z):ToScreen();
	local corner7 = max:ToScreen();
	local corner8 = Vector(max.x, min.y, max.z):ToScreen();

	surface.SetDrawColor(color);
	if (corner1.visible and corner2.visible) then
		surface.DrawLine(corner1.x, corner1.y, corner2.x, corner2.y);
	end;
	if (corner2.visible and corner3.visible) then
		surface.DrawLine(corner2.x, corner2.y, corner3.x, corner3.y);
	end;
	if (corner3.visible and corner4.visible) then
		surface.DrawLine(corner3.x, corner3.y, corner4.x, corner4.y);
	end;
	if (corner4.visible and corner1.visible) then
		surface.DrawLine(corner4.x, corner4.y, corner1.x, corner1.y);
	end;

	if (corner1.visible and corner5.visible) then
		surface.DrawLine(corner1.x, corner1.y, corner5.x, corner5.y);
	end;
	if (corner2.visible and corner6.visible) then
		surface.DrawLine(corner2.x, corner2.y, corner6.x, corner6.y);
	end;
	if (corner3.visible and corner7.visible) then
		surface.DrawLine(corner3.x, corner3.y, corner7.x, corner7.y);
	end;
	if (corner4.visible and corner8.visible) then
		surface.DrawLine(corner4.x, corner4.y, corner8.x, corner8.y);
	end;

	if (corner5.visible and corner6.visible) then
		surface.DrawLine(corner5.x, corner5.y, corner6.x, corner6.y);
	end;
	if (corner6.visible and corner7.visible) then
		surface.DrawLine(corner6.x, corner6.y, corner7.x, corner7.y);
	end;
	if (corner7.visible and corner8.visible) then
		surface.DrawLine(corner7.x, corner7.y, corner8.x, corner8.y);
	end;
	if (corner8.visible and corner5.visible) then
		surface.DrawLine(corner8.x, corner8.y, corner5.x, corner5.y);
	end;

	if (corner1.visible and corner7.visible) then
		surface.DrawLine(corner1.x, corner1.y, corner7.x, corner7.y);
	end;
end;

function PLUGIN:HUDPaintForeground()
	if (!Clockwork.Client:IsSuperAdmin() or zoneESP:GetInt() == 0 or !Clockwork.plugin:Call("PlayerCanSeeAdminESP")) then
		return;
	end;
	
	for id, zone in pairs(self.espZones) do
		for k, area in ipairs(zone.areas) do
			DrawBox(area.minimum, area.maximum, zone.areaColor);
		end;

		for k, area in ipairs(zone.excluded) do
			DrawBox(area.minimum, area.maximum, zone.exclusionColor);
		end;
	end;

	for id, zone in pairs(self.zones) do
		for k, area in ipairs(zone.areas) do
			DrawBox(area.minimum, area.maximum, zone.areaColor);
		end;

		for k, area in ipairs(zone.excluded) do
			DrawBox(area.minimum, area.maximum, zone.exclusionColor);
		end;
	end;
end;

function PLUGIN:GetAdminESPInfo(info)
	if (!Clockwork.Client:IsSuperAdmin() or zoneESP:GetInt() == 0) then
		return;
	end;
	
	for id, zone in pairs(self.espZones) do
		for k, area in ipairs(zone.areas) do
			if (self.zonesFuncESPText[id]) then
				info[#info + 1] = {
					position = (area.minimum + area.maximum) / 2,
					text = self.zonesFuncESPText[id](id, zone.zoneName, area.info, area.scale),
					color = zone.areaColor
				};
			elseif (!zone.bZoneScale) then
				info[#info + 1] = {
					position = (area.minimum + area.maximum) / 2,
					text = zone.zoneName,
					color = zone.areaColor
				};
			else
				info[#info + 1] = {
					position = (area.minimum + area.maximum) / 2,
					text = zone.zoneName.." (scale: "..area.scale..")",
					color = zone.areaColor
				};
			end;
		end;

		for k, area in ipairs(zone.excluded) do
			info[#info + 1] = {
				position = (area.minimum + area.maximum) / 2,
				text = zone.zoneName.." (exclusion area)",
				color = zone.exclusionColor
			};
		end;
	end;

	for id, zone in pairs(self.zones) do
		for k, area in ipairs(zone.areas) do
			if (self.zonesFuncESPText[id]) then
				info[#info + 1] = {
					position = (area.minimum + area.maximum) / 2,
					text = self.zonesFuncESPText[id](id, zone.zoneName, area.info, area.scale),
					color = zone.areaColor
				};
			elseif (!zone.bZoneScale) then
				info[#info + 1] = {
					position = (area.minimum + area.maximum) / 2,
					text = zone.zoneName,
					color = zone.areaColor
				};
			else
				info[#info + 1] = {
					position = (area.minimum + area.maximum) / 2,
					text = zone.zoneName.." (scale: "..area.scale..")",
					color = zone.areaColor
				};
			end;
		end;

		for k, area in ipairs(zone.excluded) do
			info[#info + 1] = {
				position = (area.minimum + area.maximum) / 2,
				text = zone.zoneName.." (exclusion area)",
				color = zone.exclusionColor
			};
		end;
	end;
end;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:InitPostEntity()
	self:SetupPlayer(Clockwork.Client);
end;

function PLUGIN:Initialize()
	Clockwork.plugin:Call("RegisterZones");
end;

function PLUGIN:Think()
	if (Clockwork.Client:HasInitialized()) then
		self:ZoneThink(Clockwork.Client);

		for id, func in pairs(self.zonesFuncOnTick) do
			if (!self.playerNextZoneChecks[player][id] or self.playerNextZoneChecks[player][id] < curTime) then
				self.playerNextZoneChecks[player][id] = curTime + self.tickTimes[id];
				func(player, id, player:GetZoneValue(id));
			end;
		end;
	end;
end;