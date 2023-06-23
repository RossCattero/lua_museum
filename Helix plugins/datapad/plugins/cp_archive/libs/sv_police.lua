--- CCA database table name
ix.archive.police.database = "ix_datapad_police"

--- Load police data to archive
---@param data table (Data table)
---@return table (New police data object)
function ix.archive.police.New(data)
	local police = setmetatable({}, ix.meta.police)
		police.id = tonumber(data.id)
		police.name = data.name
		police.rank = data.rank or ix.ranks.default
		police.sterilization = data.sterilization or 0
		police.certifications = data.certifications and util.JSONToTable(data.certifications) or {}
	return police
end;

--- Register new CCA member
---@param id number (character ID)
---@param name string (character name)
---@param rank string|nil (character rank)
function ix.archive.police.Register(id, name, rank)
	id = tonumber(id)
	rank = rank or ix.ranks.default
	
	local query = mysql:Insert(ix.archive.police.database)
		query:Insert("id", id)
		query:Insert("name", tostring(name))
		query:Insert("rank", tostring(rank))

		query:Callback(function()
			ix.archive.instances[id] = ix.archive.police.New({id = id, name = name})
		end);
	query:Execute()
end;

--- Delete a CCA member from table;
---@param id number|string (charcter ID)
function ix.archive.police.Delete(id)
	id = tonumber(id)
	
	if not ix.archive.Get(id) then
		ErrorNoHalt("Can't find character in characters list for data deletion!")
		return;
	end;

	local query = mysql:Delete(ix.archive.police.database)
		query:Where("id", id)

		query:Callback(function(result)
			ix.archive.instances[id] = nil;
		end);
	query:Execute()
end;

--- CCA database manipulation;
function ix.archive.police.Load()
	local civilians, police = ix.archive.FactionsToString();

	-- Check all characters and add all which not in police list
	local query;
	query = mysql:RawQuery([[
		INSERT INTO ]]..ix.archive.police.database..[[
		SELECT
			id,
			name,
			']]..ix.ranks.default..[[',
			0,
			'{}'
		FROM ix_characters
		WHERE 
		faction in (]]..police..[[) AND
		id not in (SELECT id FROM ]]..ix.archive.police.database..[[);
	]])

	-- Check all characters and delete ones which are deleted in ix_characters
	-- Just in case if character is somehow got deleted not by user.
	query = mysql:RawQuery([[
		DELETE 
		FROM ]]..ix.archive.police.database..[[
		WHERE id not in (SELECT id FROM ix_characters)
	]])

	-- Select all police from police table and load it into memory;
	query = mysql:Select(ix.archive.police.database)
	query:Callback(function(result)
		if result then
			for _, data in pairs(result) do
				ix.archive.instances[tonumber(data.id)] = ix.archive.police.New(data)
			end;
		end;
	end);
	query:Execute()
end;

--- Save all CCA members to database
function ix.archive.police.Save()
	for id, data in pairs(ix.archive.edited) do
		if data.rank then
			local query = mysql:Update(ix.archive.police.database)
				query:Update("name", data.name)
				query:Update("rank", data.rank)
				query:Update("sterilization", data.sterilization)
				query:Update("certifications", util.TableToJSON(data.certifications))
				query:Where("id", id)
			query:Execute()
		end;
	end;
end;