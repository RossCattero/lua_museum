local PLUGIN = PLUGIN

function PLUGIN:LoadData()
	local query;

	// Create table if not exists;
	query = mysql:Create("ix_wounds")
		query:Create("id", "INT(11) UNSIGNED NOT NULL")
		query:Create("index", "INT(11) UNSIGNED NOT NULL")
		query:Create("bone", "VARCHAR(255) NOT NULL")
		query:Create("occured", "INT(11) UNSIGNED NOT NULL")
		query:Create("charID", "INT(11) UNSIGNED NOT NULL")
		query:Create("data", "TEXT DEFAULT NULL")
		query:PrimaryKey("id")
	query:Execute()

	// Load everything
	query = mysql:Select("ix_wounds")
		query:Select("id")
		query:Select("index")
		query:Select("bone")
		query:Select("occured")
		query:Select("charID")
		query:Select("data")

		query:Callback(function(result, status)
			local lastID = 0;

			result = result || {}

			for k, v in pairs( result ) do
				v.charID = tonumber(v.charID)
				v.id = tonumber(v.id)

				local wound = ix.medical.New( tonumber(v.index), v.id )
				wound.data = util.JSONToTable(v.data);
				wound.occured = v.occured;
				wound.bone = v.bone;
				wound.charID = v.charID;

				if !ix.medical.FindBody( v.charID ) then
					ix.medical.CreateBody( v.charID )
				end;

				ix.medical.Insert( v.charID, v.bone, v.id )

				lastID = v.id;
			end

			ix.medical.index = tonumber(lastID);
		end);
	query:Execute()
end;

function PLUGIN:SaveData()
	local query;

	// Remove all wounds to save everything;
	query = mysql:Delete("ix_wounds")
	query:Execute()

	// Save everything in data-table;
	for k, v in pairs( ix.medical.instances ) do
		query = mysql:Insert("ix_wounds")
			query:Insert("id", v.id)
			query:Insert("index", v.index)
			query:Insert("bone", v.bone)
			query:Insert("occured", v.occured)
			query:Insert("charID", v.charID)
			query:Insert("data", util.TableToJSON(v.data))
		query:Execute()
	end

end;