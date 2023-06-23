--- Database manipulation for archived data;
function ix.archive.Load()
    local query;

    -- Create citizen data table if not exists;
    query = mysql:Create(ix.archive.civilians.database)
		query:Create("id", "INT(11) UNSIGNED NOT NULL")
		query:Create("name", "VARCHAR(255) NOT NULL")
		query:Create("apartment", "VARCHAR(16) DEFAULT 'Unknown'")
		query:Create("cid", "VARCHAR(8) NOT NULL")
		query:Create("loyality", "INT(11) DEFAULT 0")
		query:Create("criminal", "INT(11) DEFAULT 0")
		query:Create("notes", "VARCHAR(255) DEFAULT \"\"")
		query:Create("BOL", "VARCHAR(64) DEFAULT \"\"")
		query:PrimaryKey("id")
	query:Execute()

	-- Create CCA data table if not exists;
    query = mysql:Create(ix.archive.police.database)
		query:Create("id", "INT(11) UNSIGNED NOT NULL")
		query:Create("name", "VARCHAR(255) NOT NULL")
		query:Create("rank", "VARCHAR(16) DEFAULT '"..ix.ranks.default.."'")
		query:Create("sterilization", "INT(11) DEFAULT 0")
		query:Create("certifications", "TEXT DEFAULT \"\"")
		query:PrimaryKey("id")
    query:Execute()

	ix.archive.civilians.Load()
	ix.archive.police.Load()
end;

--- Save all the police, civilian data, clear the edited cache;
--- Called on SaveData hook;
function ix.archive.Save()
	ix.archive.civilians.Save()
	ix.archive.police.Save()

	ix.archive.edited = {}
end;