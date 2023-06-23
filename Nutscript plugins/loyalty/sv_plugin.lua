local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedChar( client, character, prev )
	local charID = character:getID();
	if !nut.loyalty.instances[ charID ] then
		nut.loyalty.Instance( charID )
		nut.loyalty.instances[ charID ]:Sync()
	end;
end;

function PLUGIN:OnCharacterDelete(client, id)
	nut.loyalty.Remove( id )
end;

function PLUGIN:GetSalaryAmount( ply, faction )
	local loyalty = nut.loyalty.instances[ ply:getChar():getID() ]
	if loyalty then
		local tier = loyalty:GetTier();

		return tier && tier.benefit;
	end
end;

function PLUGIN:SaveData()
	for charID, loyaltyData in pairs( nut.loyalty.instances ) do
		query = mysql:Delete("nut_loyalty")
			query:Where("uniqueID", charID)
		query:Execute()

		query = mysql:Insert("nut_loyalty")
			query:Insert("uniqueID", charID)
			query:Insert("data", util.TableToJSON(loyaltyData))
		query:Execute()
	end;
end;

function PLUGIN:LoadData()
	local query = mysql:Create("nut_loyalty")
		query:Create("uniqueID", "VARCHAR(255) NOT NULL")		
		query:Create("data", "TEXT NOT NULL")
		query:PrimaryKey("uniqueID")
	query:Execute()

	local query = mysql:Select("nut_loyalty")
		query:Select("uniqueID")
		query:Select("data")

		query:Callback(function(result)
			if result then
				for k, v in pairs(result) do
					local uniqueID = tonumber( v.uniqueID )
					nut.loyalty.Instance(uniqueID, util.JSONToTable(v.data))
				end
			end;
		end);
	query:Execute()
end;