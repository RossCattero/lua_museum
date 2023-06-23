--- ix.archive module
ix.archive = ix.archive or {}

-- Instances list of all characters data;
--[[
	>> print(ix.archive.instances[1])
	>> returned: "Police/Civilian ID data";
]]
ix.archive.instances = ix.archive.instances or {}

-- List of edited characters to save it on server SaveData hook;
ix.archive.edited = ix.archive.edited or {}

--- Logs data;
ix.archive.logs = ix.archive.logs or {}

--- Get the character archived data from instances;
--- @param id number|string (character id)
function ix.archive.Get(id)
	return ix.archive.instances[tonumber(id)];
end;

--- Retrieve a rank factions as string
--- @return string, string (civilians, police uniqueIDs string list)
function ix.archive.FactionsToString()
	local civilians, police = "", ""
	for _, faction_index in pairs(ix.archive.civilians.list) do
		civilians = civilians .. "\"" .. ix.faction.Get(faction_index).uniqueID .. "\","
	end;
	for _, faction_index in pairs(ix.archive.police.list) do
		police = police .. "\"" .. ix.faction.Get(faction_index).uniqueID .. "\","
	end;
	
	return string.sub(civilians, 1, string.len(civilians) - 1), string.sub(police, 1, string.len(police) - 1)
end;