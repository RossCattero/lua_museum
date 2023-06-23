local door_category = ix.meta.door_category or {}
door_category.__index = door_category

door_category.name = "Unknown"
door_category.uniqueID = "undefined"
door_category.price = 0;

function door_category:__tostring()
	return "Door category["..self.uniqueID.."]"
end

function door_category:__eq(other)
	return self:UniqueID() == other:UniqueID()
end

function door_category:UniqueID()
	return self.uniqueID;
end;

ix.meta.door_category = door_category
