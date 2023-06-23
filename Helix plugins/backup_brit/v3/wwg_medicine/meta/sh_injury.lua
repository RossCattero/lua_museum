--- Injury;
-- @medical Injury

// Create a meta or load existant stored meta;
local INJURY = ix.meta.injury or {}

-- INJURY ATTRIBUTES

// Index for situation, when the object don't have access field;
INJURY.__index = INJURY

// uniqueID for injury.
INJURY.uniqueID = "none"

// Damage index to access this injury in injuries list.
INJURY.index = DMG_GENERIC

// Attribute for bleeding damage type.
INJURY.bleeding = false

// Attribute for damage types which causes the fractures.
INJURY.fracture = false

// Attribute for damage types which causes the burns.
INJURY.burn = false

/*
	Returns a string representation of this structure;
	@realm [shared]
	@return [string] String representation.
	@usage print( ix.injury.list[DMG_GENERIC] )
	> "INJURY[generic]"
*/
function INJURY:__tostring()
	return "INJURY["..self:UniqueID().."]"
end

/*
	Returns true if this structure is equal to another. Internally, this checks IDs;
	@realm [shared]
	@argument [other] [Injury object] Another structure compare to.
	@return [bool] Whether or not this structure is equal to the given structure.
	@usage print( ix.injury.list[DMG_GENERIC] == ix.injury.list[DMG_BULLET] )
	> false
*/
function INJURY:__eq(other)
	return self:GetIndex() == other:GetIndex()
end

/*
	Returns the string uniqueID of injury;
	@realm [shared]
	@return [string] The uniqueID of injury.
	@usage print( ix.injury.list[DMG_GENERIC]:UniqueID() )
	> "generic"
*/
function INJURY:UniqueID()
	return self.uniqueID
end

/*
	Returns the unsigned number index of injury;
	@realm [shared]
	@return [number] The index of injury.
	@usage print( ix.injury.list[DMG_GENERIC]:GetIndex() )
	> 0
*/
function INJURY:GetIndex()
	return self.index
end

ix.meta.injury = INJURY