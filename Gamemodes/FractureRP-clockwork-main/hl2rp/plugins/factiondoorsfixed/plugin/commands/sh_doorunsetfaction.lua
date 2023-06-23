--[[
	Author: Cervidae Kosmonaut.
	Clockwork Version: 0.85.
--]]

local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("DoorUnsetFaction");
COMMAND.tip = "Remove the ability for a faction to access a door.";
COMMAND.text = "[string Faction]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local faction = Clockwork.faction:FindByID(arguments[1]);
	local door = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(door) and Clockwork.entity:IsDoor(door) and PLUGIN.factionDoors[door]) then
		local msg = "all factions";
		
		if (faction) then
			door._OwningFactions[string.lower(faction.name)] = nil;
			
			for k, v in pairs(PLUGIN.factionDoors[door].factions)do
				if(v == faction)then
					table.remove(PLUGIN.factionDoors[door].factions, k);
					
					break;
				end;
			end;
			
			msg = "'" .. faction.name .. "'";
		else
			door._OwningFactions = nil;
			
			PLUGIN.factionDoors = {};
		end;
		
		if (Clockwork.entity:IsDoorUnownable(door) )then
			Clockwork.entity:SetDoorUnownable(door, false);
		end;
		
		PLUGIN:SaveDoorData();
		
		Clockwork.player:Notify(player, "You have removed the ability of " .. msg .. " to access this door!");
	else
		Clockwork.player:Notify(player, "This is not a valid door!");
	end;
end;

COMMAND:Register();