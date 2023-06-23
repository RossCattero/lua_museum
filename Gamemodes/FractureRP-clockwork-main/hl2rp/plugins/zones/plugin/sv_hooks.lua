
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity() 
	Clockwork.plugin:Call("RegisterZones");
	self:LoadZones();
end;

function PLUGIN:PlayerDataLoaded(player)
	self:SetupPlayer(player);
	Clockwork.datastream:Start(player, "Zones", self.clientZones);

	if (player:IsSuperAdmin()) then
		Clockwork.datastream:Start(player, "ESPZones", self.zones);
	end;
end;

function PLUGIN:PlayerThink(player, curTime)
	self:ZoneThink(player, curTime);

	for id, func in pairs(self.zonesFuncOnTick) do
		if (!self.playerNextZoneChecks[player][id] or self.playerNextZoneChecks[player][id] < curTime) then
			self.playerNextZoneChecks[player][id] = curTime + self.tickTimes[id];
			func(player, id, player:GetZoneValue(id));
		end;
	end;
end;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (firstSpawn) then
		self:SetupPlayer(player);
	end;
end;

Clockwork.datastream:Hook("PlayerZoneChange", function(player, data)
	local id, inZoneValue, areaData = data[1], data[2], data[3];
	if (PLUGIN.clientZones[id]) then
		if (PLUGIN.zonesFuncOnChange[id]) then
			PLUGIN.zonesFuncOnChange[id](player, id, player:GetZoneValue(id), inZoneValue, areaData);
		end;

		if (PLUGIN.clientZones[id].bSharedVar) then
			player:SetSharedVar(id, inZoneValue);
		end;
		PLUGIN.playerZones[player][id] = inZoneValue;
	end;
end);