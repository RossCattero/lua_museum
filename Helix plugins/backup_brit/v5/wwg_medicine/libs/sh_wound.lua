/*
	Wound manipulation and helper functions;
*/
-- @module ix.wound
ix.wound = ix.wound || {};

/*
	The list of all wounds which can be given to character;
	@table ix.wound.list
	@realm [shared]
	@usage print(ix.wound.list["bleed"])
	> WOUND["bleed"][0]
*/
ix.wound.list = ix.wound.list || {}

/*
	The list of all instanced wounds sorted by their ID;
	@table ix.wound.instances
	@realm [shared]
	@usage print(ix.wound.instances[1])
	> WOUND["uniqueID"][1]
*/
ix.wound.instances = ix.wound.instances || {}

/*
	Load from provided directory path all wounds objects;
	@realm [shared]
	@argument [directory] [string] The path to the wound.
*/
function ix.wound.LoadFromDir(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		ix.wound.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

/*
	Register the wound object and add it to global array.
	@realm [shared]
	@argument [uniqueID] [string] The uniqueID of wound.
	@argument [path] [string] The path to the wound.
*/
function ix.wound.Register(uniqueID, path)
	if (!uniqueID) then return; end
	
	WOUND = ix.wound.list[ uniqueID ] || setmetatable({}, ix.meta.wound)
	WOUND.uniqueID = uniqueID

	if (path) then ix.util.Include(path) end
	ix.wound.list[ uniqueID ] = WOUND;

	if (IX_RELOADED) then
		for _, v in pairs(ix.wound.list) do
			if (v.uniqueID == uniqueID) then
				table.Merge(v, WOUND)
			end
		end
	end

	WOUND = nil
end

/*
	Create a new instance of the wound;
	@realm [shared]
	@argument [uniuqeID] [string] The uniqueID of the wound.
	@argument [id] [number] [opt=nil] The ID of the wound object. If not provided - will apply new index to ID attribute.
	@return [Wound object] An already instanced wound object or new wound object.
	@usage ix.wound.New( "bleed", nil )
*/

function ix.wound.New( uniqueID, id )
	local instance = ix.wound.instances[id];

	if (instance && instance.uniqueID == uniqueID) then 
		return instance 
	end;

	local wound = ix.wound.list[ uniqueID ]

	if (wound) then
		id = id || #ix.wound.instances + 1;
		local wound = setmetatable(
		{
			id = id,
			data = {}
		}, 
		{
			__index = wound,
			__eq = wound.__eq,
			__tostring = wound.__tostring
		})

		ix.wound.instances[id] = wound

		return wound
	end
end;

/*
	Count the unsigned integer amount of specified wound by uniqueID;
	@realm [shared]
	@argument [characterID] [number] The number character ID to search in global list.
	@argument [uniqueID] [string] The string uniqueID of wound to search for.
	@argument [bone] [string] [opt=nil] If provided - searches in specified bone on character's body.
	@return [number] The amount of specified wound.
	@usage print(ix.wound.GetAmount( 1, "bleed", nil ))
	> 0
*/
function ix.wound.GetAmount( characterID, uniqueID, bone )
	local body, chars, i = ix.body.instances[ characterID ], ix.body.characters[ characterID ], 0;
	
	if (bone && !body) || !chars then return end;

	for id in pairs( !bone && chars || body:GetLimb(bone) ) do
		local wound = ix.wound.instances[id]

		if wound && wound:UniqueID() == uniqueID then
			i = i + 1;
		end;
	end

	return i;
end;

/*
	Find all wounds by uniqueID;
	@realm [shared]
	@argument [characterID] [number] The number character ID to search in global list.
	@argument [uniqueID] [string] The string uniqueID of wound to search for.
	@argument [bone] [string] [opt=nil] If provided - searches in specified bone on character's body.
	@return [table] The array of wounds found associated for this character ID.
	@usage print(ix.wound.FindByID( 1, "bleed" ))
	> table 0xdeadbeef
*/
function ix.wound.FindByID( characterID, uniqueID, bone )
	local body, chars, buffer = ix.body.instances[ characterID ], ix.body.characters[ characterID ], {}

	if (bone && !body) || !chars then return end;

	for id in pairs( !bone && chars || body:GetLimb(bone) ) do
		local wound = ix.wound.instances[id]
		
		if wound && wound:UniqueID() == uniqueID then
			buffer[#buffer + 1] = id
		end;
	end

	return buffer;
end;

if SERVER then
	/*
		Instance the new wound object and edit attributes;
		@realm [server]
		@argument [uniqueID] [string] The wound uniqueID in wound list.
		@argument [characterID] [number] The owner character's ID number.
		@argument [id] [number] [opt=nil] The new ID for the wound.
		@argument [bone] [string] The bone, where the wound is instanced.
		@argument [time] [number] The time, when the wound is occured.
		@argument [data] [table] [opt=nil] The table with custom data.
		@return [Wound object] The wound object, created or already instanced.
		@usage ix.wound.Instance( "bleed", 1, nil, "torso", os.time(), nil )
	*/
	function ix.wound.Instance( uniqueID, characterID, id, bone, time, data )
		// Instance a new wound object and apply all the data to it;
		local wound = ix.wound.New( uniqueID, id );
		wound.charID = characterID;
		wound.bone = bone;
		wound.time = time || os.time();
		wound.data = data || {}

		// Insert to bone;
		local body = ix.body.instances[ characterID ];
		body:WoundAdd(bone, wound:GetID())

		// Do something individually for wound if it have a specified function;
		if wound.OnInstance then
			wound:OnInstance()
		end

		// Hook for wound instance;
		hook.Run("WoundInstance", wound:GetOwner(), wound:GetID())

		return wound;
	end;

	/*
		Create a bleed wound instance on specified bone;
		@realm [server]
		@argument [client] [Player object] The client object for networking.
		@argument [bone] [string] Bone where the wound is occured.
		@return [Wound object] The instanced wound object.
		@usage ix.wound.CreateBleed( Entity(1), "torso" )
	*/
	function ix.wound.CreateBleed( client, bone )
		local characterID = client:GetCharacter():GetID()

		local wound = ix.wound.Instance( "bleed", characterID, nil, bone )
		wound:SetData( "damage", wound.config[ bone ] && wound.config[ bone ]["damage"] )
		wound:SetData( "time", os.time() + (wound.config[ bone ] && wound.config[ bone ]["time"] || 0) )
		wound:Network( client )

		client:Notify( "Your " .. ix.body.Name( bone, true ) .. " is bleeding!" )

		return wound;
	end;

	/*
		Create a infection wound instance on specified bone;
		@realm [server]
		@argument [client] [Player object] The client object for networking.
		@argument [bone] [string] Bone where the wound is occured.
		@argument [chance] [number] [opt=100] The % chance to apply the wound.
		@return [Wound object] The instanced wound object.
		@usage ix.wound.CreateInfection( Entity(1), "torso", 100 )
	*/
	function ix.wound.CreateInfection( client, bone, chance )
		local characterID = client:GetCharacter():GetID()

		if !chance then chance = 100 end;

		if math.random(100) < chance then
			local bodypart = ix.body.Name( bone, true )
			
			local wound = ix.wound.Instance( "infection", characterID, nil, bone )
			wound:SetData("time", os.time() + 600)
			wound:Network( client )

			client:Notify( "Your wound on " .. bodypart .. " is infected!" )

			return wound;
		end	
	end;

	/*
		Create a fracture wound instance on specified bone;
		@realm [server]
		@argument [client] [Player object] The client object for networking.
		@argument [bone] [string] Bone where the wound is occured.
		@argument [chance] [number] [opt=100] The % chance to apply the wound.
		@return [Wound object] The instanced wound object.
		@usage ix.wound.CreateFracture( Entity(1), "torso", 100 )
	*/
	function ix.wound.CreateFracture( client, bone, chance )
		local characterID = client:GetCharacter():GetID()

		if bone != "r_leg" && bone != "l_leg" then return end;
		if !chance then chance = 100 end;

		if math.random(100) < chance then
			local bodypart = ix.body.Name( bone, true )

			local wound = ix.wound.Instance( "fracture", characterID, nil, bone )
			wound:SetData("time", 900)
			wound:Network( client )

			client:Notify( "Your " .. bodypart .. " is fractured!" )
		end
	end;

	/*
		Create a burn wound instance on specified bone;
		@realm [server]
		@argument [client] [Player object] The client object for networking.
		@argument [bone] [string] Bone where the wound is occured.
		@argument [damage] [number] [opt=0] The damage dealt.
		@return [Wound object] The instanced wound object.
		@usage ix.wound.CreateBurn( Entity(1), "torso", 0 )
	*/
	function ix.wound.CreateBurn( client, bone, damage )
		local characterID = client:GetCharacter():GetID()

		if !damage then damage = 0 end;

		local bodypart = ix.body.Name( bone, true )

		local wound = ix.wound.Instance( "burn", characterID, nil, bone )
		wound:SetData("time", damage < 50 && 300 || 600)
		wound:SetData("damage", damage < 50 && 60 || 20)
		wound:Network( client )

		client:Notify( "Your " .. bodypart .. " is burned!" )
	end;
end