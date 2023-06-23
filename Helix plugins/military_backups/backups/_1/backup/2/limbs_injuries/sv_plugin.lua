local PLUGIN = PLUGIN

function PLUGIN:SaveData()
	local query;

	query = mysql:Delete("inj_list")
	query:Execute()

	for k, v in pairs( INJURIES.INSTANCES ) do
		query = mysql:Insert("inj_list")
			query:Insert("index", v.index)
			query:Insert("charID", v.charID)
			query:Insert("data", util.TableToJSON(v.data))
		query:Execute()
	end
end;

function PLUGIN:LoadData()
	local query;

	query = mysql:Create("inj_list")
		query:Create("id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("index", "INT(11) UNSIGNED NOT NULL")
		query:Create("charID", "INT(11) UNSIGNED NOT NULL")
		query:Create("data", "TEXT DEFAULT NULL")
		query:PrimaryKey("id")
	query:Execute()

	query = mysql:Select("inj_list")
		query:Select("id")
		query:Select("index")
		query:Select("data")
		query:Select("charID")

		query:Callback(function(result, status, lastID)
			result = result || {}

			for k, v in pairs( result ) do
				v.data = util.JSONToTable(v.data)
				local res = INJURIES.New( tonumber(v.index), tonumber(v.id), v.charID, v.data );

				INJURIES.INSTANCES[ k ] = res
			end

			INJURIES.INDEX = lastID
		end);
	query:Execute()
end;

function PLUGIN:CharacterDeleted(client, id)
	client:ResetInjuries(true, true, id)
end;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(.25, function()
		if prev then
			client:ResetInjuries(false, true, character:GetID())
		end
		for k, v in pairs( INJURIES.INSTANCES ) do
			if tonumber(v.charID) == character:GetID() then
				netstream.Start(client, "NETWORK_INJURY_INSTANCE", v.index, v:GetID(), v.data)
			end
		end
    end)
end