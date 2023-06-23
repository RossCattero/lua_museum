--- Civilians table name in sql database
ix.archive.civilians.database = "ix_datapad_civilian"

--- Load civilian data to archive
---@param data table (Data table)
---@return table (New civilian data object)
function ix.archive.civilians.New(data)
	local civilian = setmetatable({}, ix.meta.civilian)
		civilian.id = data.id
		civilian.name = data.name
		civilian.cid = data.cid
		civilian.apartment = data.apartment or "Unknown"
		civilian.loyality = data.loyality or 0
		civilian.criminal = data.criminal or 0
		civilian.notes = data.notes or ""
		civilian.bol = data.BOL or ""
	return civilian
end;

--- Register new civilian object
---@param id number (Character ID)
---@param name string (Character name)
---@param cid string|nil (Character CID)
function ix.archive.civilians.Register(id, name, cid)
	id = tonumber(id)

	if not cid then
		cid = ix.archive.civilians.CID()
	end;
	local query = mysql:Insert(ix.archive.civilians.database)
		query:Insert("id", id)
		query:Insert("name", tostring(name))
		query:Insert("cid", tonumber(cid))

		query:Callback(function()
			ix.archive.instances[id] = ix.archive.civilians.New({id = id, name = name, cid = cid})
		end);
	query:Execute()
end;

--- Delete character from archive table
---@param id number (character ID)
function ix.archive.civilians.Delete(id)
	id = tonumber(id)
	
	if not id or not ix.archive.Get(id) then
		ErrorNoHalt("Can't find character in characters list for data deletion!")
		return;
	end;
	local query = mysql:Delete(ix.archive.civilians.database)
		query:Where("id", id)

		query:Callback(function(result)
			ix.archive.instances[id] = nil;
		end);
	query:Execute()
end;

--- Civilians data manipulation;
function ix.archive.civilians.Load()
	local civilians, police = ix.archive.FactionsToString();

	-- Check all characters and add all which not in citizens list
	local query;
	query = mysql:RawQuery([[
		INSERT INTO ]]..ix.archive.civilians.database..[[
		SELECT
			id,
			name,
			'Unknown',
			"]]..ix.archive.civilians.CID()..[[",
			0,
			0,
			'',
			''
		FROM ix_characters
		WHERE 
		faction in (]]..civilians..[[) AND
		id not in (SELECT id FROM ]]..ix.archive.civilians.database..[[);
	]])

	-- Check all characters and delete ones which are deleted in ix_characters
	-- Just in case if character is somehow got deleted not by user.
	query = mysql:RawQuery([[
		DELETE 
		FROM ]]..ix.archive.civilians.database..[[
		WHERE id not in (SELECT id FROM ix_characters)
	]])

	-- Select all civilian data and load it into memory;
	query = mysql:Select(ix.archive.civilians.database)
	query:Callback(function(result)
		if result then
			for _, data in pairs(result) do
				ix.archive.instances[tonumber(data.id)] = ix.archive.civilians.New(data)
			end;
		end;
	end);
	query:Execute()
end;

--- Save civlians to the database
function ix.archive.civilians.Save()
	for id, data in pairs(ix.archive.edited) do
		if data.cid then
			local query = mysql:Update(ix.archive.civilians.database)
				query:Update("name", data.name)
				query:Update("cid", data.cid)
				query:Update("loyality", data.loyality)
				query:Update("criminal", data.criminal)
				query:Update("notes", data.notes)
				query:Update("bol", data.bol)
				query:Update("apartment", data.apartment)
				query:Where("id", id)
			query:Execute()
		end;
	end;
end;

--- Generate CID for character
---@return string (CID)
function ix.archive.civilians.CID()
	local digits = 5;
    local number = math.random(1, 99999);
		
    return string.rep("0", math.Clamp(digits - string.len(number), 0, digits))..number;
end;