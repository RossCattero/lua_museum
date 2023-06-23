
--- Helper library for loading/getting faction information.
-- @module ix.faction

ix.faction = ix.faction or {}
ix.faction.teams = ix.faction.teams or {}
ix.faction.indices = ix.faction.indices or {}

local CITIZEN_MODELS = {}

for i = 1, 9 do 

	table.insert(CITIZEN_MODELS, "models/union/citizens/male_0"..i..".mdl");
	if i < 8 then
		table.insert(CITIZEN_MODELS, "models/union/citizens/female_0"..i..".mdl");
	end;

end;

for i = 10, 16 do
	table.insert(CITIZEN_MODELS, "models/union/citizens/male_"..i..".mdl");
end;

--- Loads factions from a directory.
-- @realm shared
-- @string directory The path to the factions files.
function ix.faction.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		FACTION = ix.faction.teams[niceName] or {index = table.Count(ix.faction.teams) + 1, isDefault = false}
			if (PLUGIN) then
				FACTION.plugin = PLUGIN.uniqueID
			end

			ix.util.Include(directory.."/"..v, "shared")

			if (!FACTION.name) then
				FACTION.name = "Unknown"
				ErrorNoHalt("Faction '"..niceName.."' is missing a name. You need to add a FACTION.name = \"Name\"\n")
			end

			if (!FACTION.description) then
				FACTION.description = "noDesc"
				ErrorNoHalt("Faction '"..niceName.."' is missing a description. You need to add a FACTION.description = \"Description\"\n")
			end

			if (!FACTION.color) then
				FACTION.color = Color(150, 150, 150)
				ErrorNoHalt("Faction '"..niceName.."' is missing a color. You need to add FACTION.color = Color(1, 2, 3)\n")
			end

			team.SetUp(FACTION.index, FACTION.name or "Unknown", FACTION.color or Color(125, 125, 125))

			FACTION.models = FACTION.models or CITIZEN_MODELS
			FACTION.uniqueID = FACTION.uniqueID or niceName

			for _, v2 in pairs(FACTION.models) do
				if (isstring(v2)) then
					util.PrecacheModel(v2)
				elseif (istable(v2)) then
					util.PrecacheModel(v2[1])
				end
			end

			if (!FACTION.GetModels) then
				function FACTION:GetModels(client)
					return self.models
				end
			end

			ix.faction.indices[FACTION.index] = FACTION
			ix.faction.teams[niceName] = FACTION
		FACTION = nil
	end
end

--- Retrieves a faction table.
-- @realm shared
-- @param identifier Index or name of the faction
-- @treturn table Faction table
-- @usage print(ix.faction.Get(Entity(1):Team()).name)
-- > "Citizen"
function ix.faction.Get(identifier)
	return ix.faction.indices[identifier] or ix.faction.teams[identifier]
end

--- Retrieves a faction index.
-- @realm shared
-- @string uniqueID Unique ID of the faction
-- @treturn number Faction index
function ix.faction.GetIndex(uniqueID)
	for k, v in ipairs(ix.faction.indices) do
		if (v.uniqueID == uniqueID) then
			return k
		end
	end
end

if (CLIENT) then
	--- Returns true if a faction requires a whitelist.
	-- @realm client
	-- @number faction Index of the faction
	-- @treturn bool Whether or not the faction requires a whitelist
	function ix.faction.HasWhitelist(faction)
		local data = ix.faction.indices[faction]

		if (data) then
			if (data.isDefault) then
				return true
			end

			local ixData = ix.localData and ix.localData.whitelists or {}

			return ixData[Schema.folder] and ixData[Schema.folder][data.uniqueID] == true or false
		end

		return false
	end
end
