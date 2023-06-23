-- CDATA library
ix.cdata = ix.cdata or {}

-- List of the characters data
ix.cdata.list = ix.cdata.list or {}

-- Category for citizens;
ix.cdata.list.citizens = ix.cdata.list.citizens or {}

-- Category for CCA;
ix.cdata.list.cca = ix.cdata.list.cca or {}

-- Create a database tables for citizens, CCA;
-- Sort and load characters to the tables if they're already not in tables;
function ix.cdata.Load()
    local query

	-- Create citizen data if not exists;
    query = mysql:Create("ix_datapad_citizens")
		query:Create("characterID", "INT(11) UNSIGNED NOT NULL")
		query:Create("name", "VARCHAR(255) NOT NULL")
		query:Create("cid", "VARCHAR(16) NOT NULL")
		query:Create("loyality", "INT(11)")
		query:Create("criminal", "INT(11)")
		query:Create("notes", "VARCHAR(255)")
		query:Create("BOL", "VARCHAR(128)")
		query:PrimaryKey("characterID")
	query:Execute()

	-- Create CCA data if not exists;
    query = mysql:Create("ix_datapad_cca")
		query:Create("characterID", "INT(11) UNSIGNED NOT NULL")
		query:Create("name", "VARCHAR(255) NOT NULL")
		query:Create("rank", "VARCHAR(16)")
		query:Create("sterilization", "INT(11)")
		query:Create("certifications", "TEXT")
		query:PrimaryKey("characterID")
    query:Execute()

	-- Insert all citizens who are not yet in citizens
	query = mysql:RawQuery(Format([[
		INSERT INTO ix_datapad_citizens
		SELECT
			id,
			name,
			"00000",
			0,
			0,
			'',
			''
		FROM ix_characters
		WHERE id not in (SELECT characterID FROM ix_datapad_citizens) AND
		faction not in (%s);
	]], ix.ranks.FactionsToString()))

	-- Insert all CCA who are not yet in CCA
	query = mysql:RawQuery(Format([[
		INSERT INTO ix_datapad_cca
		SELECT
			id,
			name,
			0,
			'%s',
			''
		FROM ix_characters
		WHERE id not in (SELECT characterID FROM ix_datapad_cca) AND
		faction in (%s);
	]], ix.ranks.default, ix.ranks.FactionsToString()))

	-- Load all citizen data
	query = mysql:Select("ix_datapad_citizens")
		query:Callback(function(result)
			if result then
				for k, v in ipairs(result) do
					
				end;
			end;
		end);
	query:Execute()
end;

function ix.cdata.New(characterID, name, cid, loyality_points, criminal_points, notes, bol)
	local citizen_data = setmetatable({}, ix.meta.citizen_data)
		citizen_data.characterID = characterID;
		citizen_data.name = name;
		citizen_data.cid = cid;
		citizen_data.loyality_points = tostring(loyality_points)
		citizen_data.criminal_ponits = tostring(criminal_points)
		citizen_data.notes = string.sub(notes, 1, 255);
		citizen_data.bol = string.sub(bol, 1, 128)
	return citizen_data
end