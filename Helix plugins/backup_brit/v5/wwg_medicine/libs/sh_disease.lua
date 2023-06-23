/*
	Diseases manipulation and helper functions;
*/
-- @module ix.disease

ix.disease = ix.disease || {}

ix.disease.list = ix.disease.list || {}

ix.disease.instances = ix.disease.instances || {}

function ix.disease.FindByID( id )
	return ix.disease.instances[ id ];
end;

function ix.disease.LoadFromDir(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		ix.disease.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

function ix.disease.Register(uniqueID, path)
	if (!uniqueID) then return; end
	
	DISEASE = ix.disease.list[uniqueID] || setmetatable({}, ix.meta.disease)
	DISEASE.uniqueID = uniqueID

	if (path) then ix.util.Include(path) end
	ix.disease.list[ DISEASE.uniqueID ] = DISEASE;

	if (IX_RELOADED) then
		for _, v in pairs(ix.disease.list) do
			if (v.uniqueID == uniqueID) then
				table.Merge(v, DISEASE)
			end
		end
	end

	DISEASE = nil
end

function ix.disease.New( uniqueID, id )
	local instance = ix.disease.instances[id];

	if (instance && instance.uniqueID == uniqueID) then 
		return instance 
	end;

	local disease = ix.disease.list[ uniqueID ]

	if (disease) then
		id = id || #ix.disease.instances + 1;

		local disease = setmetatable(
		{
			id = id,
		}, 
		{
			__index = disease,
			__eq = disease.__eq,
			__tostring = disease.__tostring
		})

		ix.disease.instances[id] = disease

		return disease
	end
end;

function ix.disease.Instance( uniqueID, id, characterID, time )
	id = tonumber(id)
	
	local disease = ix.disease.New( uniqueID, id );
	disease.charID = characterID;
	disease.occured = time || os.time();

	local body = ix.body.instances[ characterID ]
	if body then body.diseases[uniqueID] = {id = disease:GetID()}; end;

	disease:Network()

	return disease;
end;

function ix.disease.Load( characterID )
	local body = ix.body.instances[ characterID ]

	if !body then return end;

	for k, v in pairs( ix.disease.list ) do
		body.diseases[ k ] = 0
	end

	local query = mysql:Select("ix_diseases")
		query:Select("id")
		query:Select("uniqueID")
		query:Select("occured")
		query:Select("charID")

		query:Where("charID", characterID)

		query:Callback(function(result)
			for k, v in pairs( result || {} ) do
				ix.disease.Instance( v.uniqueID, v.id, v.charID, v.occured )
				body.diseases[ v.uniqueID ] = {id = tonumber(v.id)};
			end
		end);
	query:Execute()
end;

function ix.disease.Remove( characterID, delete )
	if delete then
		local query = mysql:Delete("ix_diseases")
			query:Where("charID", characterID)
		query:Execute()
	end

	local body = ix.body.instances[ characterID ];

	if body then
		for num, diseaseID in pairs( body.diseases ) do
			ix.disease.instances[ diseaseID ]:Remove()
		end
	end;
end

function ix.disease.HasDisease( characterID, uniqueID )
	local body = ix.body.instances[ characterID ]
	local disease = body.diseases[ uniqueID ];
	
	return body && !isnumber(disease) && disease.id
end;
