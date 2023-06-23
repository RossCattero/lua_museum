--[[
	Author: Cervidae Kosmonaut.
	Clockwork Version: 0.85.
--]]

local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("DoorSetFaction");
COMMAND.tip = "Allow a faction to have access a door.";
COMMAND.text = "<string Faction> [bool StartLocked]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local faction = Clockwork.faction:FindByID(arguments[1]);
	
	if (faction) then
		local door = player:GetEyeTraceNoCursor().Entity;
		local lowerName = string.lower(faction.name);
		
		if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
			if (not door._OwningFactions or not door._OwningFactions[lowerName]) then
				local factions = {};
				
				if(not door._OwningFactions)then
					door._OwningFactions = {};
				end;
				
				door._OwningFactions[lowerName] = true;
				
				if (not Clockwork.entity:IsDoorUnownable(door) )then
					Clockwork.entity:SetDoorUnownable(door, true);
				end;

				if(PLUGIN.factionDoors[door])then
					factions = PLUGIN.factionDoors[door].factions;	-- factions = PLUGIN.factionDoors[door], fixed by Viz.
				end;

				table.insert(factions, faction);
				
				PLUGIN.factionDoors[door] = {
					factions = factions,
					position = door:GetPos(),
					startLocked = Clockwork.kernel:ToBool(arguments[2])
				};

				PLUGIN:SaveDoorData();

				Clockwork.player:Notify(player, "You have allowed '".. faction.name .."' access to this door.");
			else
				Clockwork.player:Notify(player, "This faction already has access to this door!");
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid door!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid faction!");
	end;
end;

COMMAND:Register();