--[[
	Author: Cervidae Kosmonaut.
	Clockwork Version: 0.85.
--]]

local PLUGIN = PLUGIN;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadDoorData();
end;

-- Called to check if a player does have door access.
function PLUGIN:PlayerDoesHaveDoorAccess(player, door, access, isAccurate)
	if(door._OwningFactions and access == DOOR_ACCESS_BASIC)then
		local faction = Clockwork.player:GetFactionTable(player);
		
		if(faction and door._OwningFactions[string.lower(faction.name)])then
			return true;
		end;
	end
end;