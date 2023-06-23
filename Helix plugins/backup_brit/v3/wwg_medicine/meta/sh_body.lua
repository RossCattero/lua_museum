--- Body;
-- @medical Body

// Create a meta or load existant stored meta;
local BODY = ix.meta.body or {}

-- BODY ATTRIBUTES

// Index for situation, when the object don't have access field;
BODY.__index = BODY

// Owner character's ID;
BODY.charID = 0;

// Limbs array. It will store all wounds created for character;
BODY.limbs = {
	head = {},
	torso = {},
	l_arm = {},
	r_arm = {},
	l_leg = {},
	r_leg = {}
}

/*
	Returns a string representation of this strcture;
	@realm [shared]
	@return [string] String representation.
	@usage print( ix.body.instances[1] )
	> "BODY[1]"
*/
function BODY:__tostring()
	return "BODY["..self:GetID().."]"
end

/*
	Returns true if this structure is equal to another. Internally, this checks IDs;
	@realm [shared]
	@argument [other] [Body object] Another structure compare to.
	@return [bool] Whether or not this structure is equal to the given structure.
	@usage print( ix.body.instances[1] == ix.body.instances[2] )
	> false
*/
function BODY:__eq(other)
	return self:GetID() == other:GetID()
end

/*
	Returns the unsigned integer ID of body;
	@realm [shared]
	@return [number] The ID of body (the id of character this body belongs to).
	@usage print( ix.body.instances[1]:GetID() )
	> 1;
*/
function BODY:GetID()
	return self.charID or 0
end

/*
	Returns the array of limbs of body;
	@realm [shared]
	@return [table] The list of limbs, attached to this body.
	@usage print( ix.body.instances[1]:GetLimbs() )
	> table 0xdeadbeef
*/
function BODY:GetLimbs()
	return self.limbs
end;

/*
	Returns the array of wounds, according to this limb;
	@realm [shared]
	@argument [bone] [string] The limb name attached to the body;
	@return [table] The list of wounds on this limb;
	@usage print( ix.body.instances[1]:GetLimb("r_arm") )
	> table 0xdeadbeef
*/
function BODY:GetLimb( bone )
	return self.limbs[bone]
end;

/*
	Return the online owner player of this body;
	@realm [shared]
	@return [player] The online player who owns this body;
	@usage print( ix.body.instances[1]:GetOwner() )
	> Player[1][Ross]
*/
function BODY:GetOwner()
	return ix.char.loaded[ self:GetID() ] && ix.char.loaded[ self:GetID() ].player;
end;

/*
	Insert wound to specified bone;
	@realm [shared]
	@argument [bone] [string] The string limb name.
	@argument [id] [number] The number id of wound.
	@usage ix.body.instances[1]:BoneInsert("torso", 1)
*/

function BODY:BoneInsert(bone, id)
	local wound = ix.wound.instances[ id ];
	if !wound then return end;

	// Apply this wound to character in list;
	ix.body.characters[ self:GetID() ][ id ] = id;
	
	// Apply this wound to body instance;
	ix.body.instances[ self:GetID() ][ "limbs" ][ bone ][ id ] = id;
end;

/*
	TODO: 
	documentation
*/

function BODY:BoneRemove(bone, id)
	local wound = ix.wound.instances[ id ];
	if !wound then return end;

	// Remove this wound from character in list;
	ix.body.characters[ self:GetID() ][ id ] = nil;
	
	// Remove this wound in body instance;
	ix.body.instances[ self:GetID() ][ "limbs" ][ bone ][ id ] = nil;
end;

ix.meta.body = BODY