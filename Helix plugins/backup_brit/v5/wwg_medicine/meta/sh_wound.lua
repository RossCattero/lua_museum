--- Wound;

-- @medical Wound

// Create a meta or load existant stored meta;
local WOUND = ix.meta.wound or {}

-- WOUND ATTRIBUTES

// Index for situation, when the object don't have access field;
WOUND.__index = WOUND

// Limb, where the wound is located;
WOUND.bone = "None"

// Time when the wound occured;
WOUND.time = 0

// Owner character's ID;
WOUND.charID = 0

// Name of wound in the global list;
WOUND.uniqueID = "none"

// ID of the wound in global instances list;
WOUND.id = 0;

// TODO: doc
WOUND.checkTime = 10;

/*
	Returns a string representation of this structure;
	@realm [shared]
	@return [string] String representation.
	@usage print( ix.wound.instances[1] )
	> "WOUND[bleed][1]"
*/
function WOUND:__tostring()
	return "WOUND["..self:UniqueID().."]["..self:GetID().."]"
end

/*
	Returns true if this structure is equal to another. Internally, this checks IDs;
	@realm [shared]
	@argument [other] [Wound object] Another structure compare to.
	@return [bool] Whether or not this structure is equal to the given structure.
	@usage print( ix.wound.instances[1] == ix.wound.instances[2] )
	> false
*/
function WOUND:__eq(other)
	return self:GetID() == other:GetID()
end

/*
	Return the actual global usigned integer ID of the wound instance;
	@realm [shared]
	@return [number] The ID of the wound.
	@usage print( ix.wound.instances[1]:GetID() )
	> 1
*/
function WOUND:GetID()
	return self.id
end

/*
	Return the string uniqueID of wound;
	@realm [shared]
	@return [string] The uniqueID of the wound;
	@usage print( ix.wound.instances[1]:UniqueID() )
	> bleed
*/
function WOUND:UniqueID()
	return self.uniqueID;
end;

/*
	Return the bone where this wound is located;
	@realm [shared]
	@return [string] The bone name;
	@usage print( ix.wound.instances[1]:GetBone() )
	> "torso"
*/
function WOUND:GetBone()
	return self.bone;
end;

/*
	Return the online owner player of this wound;
	@realm [shared]
	@return [player] The online player who owns this wound;
	@usage print( ix.wound.instances[1]:GetOwner() )
	> Player[1][Ross]
*/
function WOUND:GetOwner()
	return ix.char.loaded[ self.charID ] && ix.char.loaded[ self.charID ].player;
end;

/*
	Return the specified data if exists or return the default;
	@realm [shared]
	@argument [key] [string] The key in which the value is stored.
	@argument [default] [any] [opt=nil] The value to return if nothing is stored in this key.
	@return [any] The data is stored within this @key or @default if nothing found.
	@usage ix.wound.instances[1]:GetData("Key", 0)
	> 0
*/
function WOUND:GetData(key, default)
	return self.data && self.data[key] || default
end;

/*
	Check if this wound is located on legs;
	@realm [shared]
	@return [bool] Is the wound located on legs or not.
	@usage ix.wound.instances[1]:IsLegs()
	> false
*/
function WOUND:IsLegs()
	local bone = self:GetBone();

	return bone == "r_leg" || bone == "l_leg"
end;

if SERVER then
	/*
		Remove the wound instance and network remove to client;
		@realm [server]
		@usage ix.wound.instances[1]:Remove()
	*/
	function WOUND:Remove()
		local body, id = ix.body.instances[ self.charID ], self:GetID()

		if body then
			body:WoundRemove( self:GetBone(), id )
		end

		local receiver = self:GetOwner();
		if receiver then
			// Hook, used to callback a wound remove if owner is online.
			hook.Run("PreWoundRemove", receiver, id)

			net.Start("NETWORK_WOUND_REMOVE")
				net.WriteUInt( id, 16 )
			net.Send(receiver)
		end;

		ix.wound.instances[ id ] = nil;
	end;
	/*
		Set the data of the wound and network it to online owner client;
		@realm [server]
		@argument [key] [string] The key in which the value is stored.
		@argument [value] [any] The value to store.
		@usage ix.wound.instances[1]:SetData("Key", "Value")
	*/
	function WOUND:SetData( key, value )
		if !self.data then self.data = {} end;
		
		self.data[key] = value;

		local receiver = self:GetOwner();
		if receiver then
			net.Start("NETWORK_WOUND_DATA")
				net.WriteUInt( self:GetID(), 16 )
				net.WriteString( key )
				net.WriteType( value )
			net.Send(receiver)
		end
	end;

	/*
		Network the wound to specified receiver;
		@realm [server]
		@argument [player] [Player object] The player to whom send the wound on client.
		@usage ix.wound.instances[1]:Network( Entity(1) )
	*/
	function WOUND:Network( receiver )
		if receiver && receiver:IsValid() then
			local data = util.TableToJSON( self.data )
			data = util.Compress( data )
			local len = #data

			net.Start("NETWORK_WOUND")
				net.WriteString( self.uniqueID ) // Write uniqueID string
				net.WriteString( self.bone ) // Write string as bone name
				net.WriteUInt( self.time || 0, 32 ) // Write unsigned INT as wound occure time
				net.WriteUInt( self.id, 16 ) // Write unsigned INT as wound occure time
				net.WriteUInt( len, 16 )
				net.WriteData( data, len )
			net.Send(receiver)
		end;
	end;
end

ix.meta.wound = WOUND