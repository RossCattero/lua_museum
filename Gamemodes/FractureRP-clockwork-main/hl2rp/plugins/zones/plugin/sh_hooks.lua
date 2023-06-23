
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

local ipairs = ipairs;
local CurTime = CurTime

-- Called when the Clockwork shared variables are added.
function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	for id, zone in pairs(self.zones) do
		if (zone.bSetSharedVar) then
			if (zone.bZoneScale) then
				playerVars:Number(id);
			else
				playerVars:Bool(id);
			end;
		end;
	end;
end;

function PLUGIN:ZoneThink(player, curTime)
	if (!curTime) then
		curTime = CurTime();
	end;
	
	for id, zone in pairs(self.zones) do
		if (!self.playerNextZoneChecks[player][id] or self.playerNextZoneChecks[player][id] < curTime) then
			self.playerNextZoneChecks[player][id] = curTime + self.tickTimes[id];

			local factionTable = Clockwork.faction:FindByID(player:GetFaction());
			-- Skip if noclipping, the faction doesn't need this zone checked or dead players do not have to be checked
			if (Clockwork.player:IsNoClipping(player) or (factionTable.excludeZone and factionTable.excludeZone[id])
				or (self.zonesFuncShouldCheck[id] and self.zonesFuncShouldCheck[id](player, id) == false)) then 
				continue; 
			end;

			local inZoneValue = false;
			local playerPos = player:GetShootPos();
			-- Loop over all exclusion zones
			local isInExclusionZone = false;
			if (zone.bUseExclusionAreas) then	
				for k, area in ipairs(zone.excluded) do
					if (self:IsInBox(playerPos, area.minimum, area.maximum)) then
						isInExclusionZone = true;
						break;
					end;
				end;
			end;

			local inArea;
			-- Check if a player is in a zone if he is not in an exclusion zone
			if (!isInExclusionZone) then
				for k, area in ipairs(zone.areas) do
					if (self:IsInBox(playerPos, area.minimum, area.maximum)) then
						inArea = area;
						break;
					end;
				end;
			end;

			if (inArea) then
				inZoneValue = (zone.bZoneScale and inArea.scale) or true;
			else
				inArea = {};
			end;

			if (inZoneValue == false and zone.bZoneScale) then
				inZoneValue = 0;
			end;

			local oldValue = player:GetZoneValue(id);
			if (oldValue == nil) then
				oldValue = (zone.bZoneScale and 0) or false;
			end;
			PLUGIN.playerZones[player][id] = inZoneValue;

			if (inZoneValue != oldValue) then
				if (zone.bShared) then
					if (CLIENT) then
						Clockwork.datastream:Start("PlayerZoneChange", {zone.id, inZoneValue, inArea.info});
					else
						Clockwork.datastream:Start(player, "PlayerZoneChange", {zone.id, inZoneValue, inArea.info});
					end;
				end;

				if (SERVER and zone.bSharedVar) then
					player:SetSharedVar(zone.id, inZoneValue);
				end;

				if (self.zonesFuncOnChange[id]) then
					self.zonesFuncOnChange[id](player, zone.id, oldValue, inZoneValue, inArea.info);
				end;
			end;

			if (self.zonesFuncOnTick[id]) then
				self.zonesFuncOnTick[id](player, zone.id, inZoneValue, inArea.info);
			end;
		end;
	end;
end;