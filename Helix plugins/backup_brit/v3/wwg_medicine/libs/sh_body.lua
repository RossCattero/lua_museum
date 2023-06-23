/*
	Body manipulation and helper functions;
*/
-- @module ix.body
ix.body = ix.body || {}

/*
	List of characters with wound instaced list by character ID;
	@table ix.body.characters
	@realm [shared]
	@usage print(ix.body.characters[1])
	> table 0xdeadbeef
*/
ix.body.characters = ix.body.characters || {}

/*
	List of instanced body by character IDs;
	@table ix.body.instances
	@realm [shared]
	@usage print(ix.body.instances[1])
	> BODY[1]
*/
ix.body.instances = ix.body.instances || {}

/*
	List of limbs sorted by hitgroup ID;
	@realm [shared]
	@table ix.body.list
	@usage print(ix.body.list[1])
	> "head"
*/
ix.body.list = ix.body.list || {
	[1] = "head",
	[2] = "torso",
	[3] = "torso",
	[4] = "l_arm",
	[5] = "r_arm",
	[6] = "l_leg",
	[7] = "r_leg"
}

/*
	List of limb names sorted by limbs name;
	@realm [shared]
	@table ix.body.names
	@usage print(ix.body.names["head"])
	> "Head"
*/
ix.body.names = ix.body.names || {
	["head"] = "Head",
	["torso"] = "Torso",
	["l_arm"] = "Left arm",
	["r_arm"] = "Right arm",
	["l_leg"] = "Left leg",
	["r_leg"] = "Right leg"
}

/*
	Return the formatted name of the provided limb;
	@realm [shared]
	@argument [bone] [string] [opt=nil] The bone name.
	@argument [lower] [bool] [opt=nil] Lowercase the returned name.
	@return [string] The name of provided bone or lowercased.
	@usage ix.body.Name( "head", true )
	> "head"
*/
function ix.body.Name( bone, lower )
	local name = bone && ix.body.names[bone] || "bodypart"
	return !lower && name || name:lower()
end;

/*
	Creates a template body used for making new body instances;
	@realm [shared]
	@usage ix.body.CreateTemplate()
*/
function ix.body.CreateTemplate()
	BODY = ix.body.template || setmetatable({}, ix.meta.body)

	ix.body.template = BODY;

	BODY = nil
end

/*
	Create new body instance;
	@realm [shared]
	@argument [characterID] [number] The character ID used by any of characters.
	@return [Body object] The new body structure for character.
	@usage print(ix.body.New( 1 ))
	> BODY[1]
*/
function ix.body.New( characterID )
	local instance = ix.body.instances[ characterID ]

	if (instance) then
		return instance 
	end;

	local body = ix.body.template;

	if (body) then
		local body = setmetatable(
		{
			charID = characterID,
			limbs = body.limbs,
		}, 
		{
			__index = body,
			__eq = body.__eq,
			__tostring = body.__tostring
		})

		ix.body.instances[ characterID ] = body
		ix.body.characters[ characterID ] = {}

		return body
	end
end;

/*
	Create the trace for specified entity.
	@realm [shared]
	@argument [entity] [Entity object] The entity which provides a trace.
	@return [TraceData] The trace data object.
	@usage print(ix.body.trace(Entity(1)))
	> TraceData
*/
function ix.body.trace(entity)
	if !entity || !entity:IsValid() || !entity.GetShootPos then return end;
	local pos, angle = entity:GetShootPos(), entity:GetAimVector();

	return util.TraceLine({
		start = pos, 
		endpos = pos + (angle * 2048), 
		filter = entity
	});
end;

if SERVER then
	/*
		Load the body from the database for character and load all wounds associated;
		@realm [server]
		@argument [characterID] [number] The character ID used by any of characters.
		@usage ix.body.Load( 1 )
	*/
	function ix.body.Load( characterID )

		if !ix.body.instances[ characterID ] then
			ix.body.New( characterID )
		end;

		local query = mysql:Select("ix_wounds")
			query:Select("id")
			query:Select("uniqueID")
			query:Select("bone")
			query:Select("time")
			query:Select("charID")
			query:Select("data")

			query:Where("charID", characterID)

			query:Callback(function(result, status, lastID)
				for k, v in pairs( result || {} ) do
					local wound = ix.wound.Instance( v.uniqueID, characterID, tonumber(v.id), v.bone, v.time, util.JSONToTable(v.data) )
					// Body can be loaded only when character loaded, so we can network the wound to specified owner.
					wound:Network( wound:GetOwner() )
				end

				ix.wound.index = lastID
			end);
		query:Execute()
	end;

	/*
		Remove the provided body by character ID.
		@realm [server]
		@argument [characterID] [number] The character ID used by any of characters;
		@argument [erase] [bool] [opt=nil] Should the data be erased from the database;
		@usage ix.body.Remove( 1 )
	*/
	function ix.body.Remove( characterID, erase )
		if erase then
			for id, wound in pairs( ix.body.characters[ characterID ] ) do
				wound:Remove();
			end
			local query = mysql:Delete("ix_wounds")
				query:Where("charID", characterID)
			query:Execute()

			return;
		end;

		ix.body.instances[ characterID ] = nil;
		ix.body.characters[ characterID ] = nil;
	end;
end