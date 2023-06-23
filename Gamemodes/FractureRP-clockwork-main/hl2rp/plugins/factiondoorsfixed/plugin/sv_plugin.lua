--[[
	Author: Cervidae Kosmonaut.
	Clockwork Version: 0.85.
	
	Credits: A small part of this code comes from kurozael's DoorCommands Plugin.
--]]

-- A function to load the door data.
function PLUGIN:LoadDoorData()
	self.factionDoors = {};
	
	local positions = {};
	local factionDoors = Clockwork.kernel:RestoreSchemaData("plugins/factiondoors/" .. game.GetMap());
	
	for k, v in pairs(ents.GetAll()) do
		if (IsValid(v)) then
			local position = v:GetPos();
			
			if (position) then
				positions[tostring(position)] = v;
			end;
		end;
	end;
	
	for k, v in pairs(factionDoors) do
		local entity = positions[tostring(v.position)];
		
		if (IsValid(entity) and !self.factionDoors[entity]) then
			if (Clockwork.entity:IsDoor(entity)) then
				local factions = {};
				
				for k2, v2 in pairs(v.factions)do
					local faction = Clockwork.faction:FindByID(v2);
					
					if(faction)then
						table.insert(factions, faction);
						
						if(not entity._OwningFactions)then
							entity._OwningFactions = {};
						end;
				
						entity._OwningFactions[string.lower(faction.name)] = true;
					else
						ErrorNoHalt("[FactionDoors Plugin] Faction with name '" .. v2 .. "' doesn't exist, could not allow door access!");
					end;
				end;
				
				v.factions = factions;
				
				self.factionDoors[entity] = v;
				
				if(v.startLocked)then
					entity:Fire("Lock", "", 0);
				else
					entity:Fire("Unlock", "", 0);
				end;
			end;
		end;
	end;
end;

-- A function to save the door data.
function PLUGIN:SaveDoorData()
	local factionDoors = {};
	
	for k, v in pairs(self.factionDoors) do
		local data = {
			factions = {},
			position = v.position,
			startLocked = v.startLocked
		};
		
		for k2, v2 in pairs(v.factions)do
			table.insert(data.factions, v2.name);
		end;
		
		factionDoors[#factionDoors + 1] = data;

	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/factiondoors/"..game.GetMap(), factionDoors);
end;