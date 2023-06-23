local door_sector = ix.meta.door_sector or {}
door_sector.__index = door_sector

door_sector.name = "Unknown"
door_sector.uniqueID = "undefined"

function door_sector:__tostring()
	return "Door sector["..self.uniqueID.."]"
end

function door_sector:__eq(other)
	return self:UniqueID() == other:UniqueID()
end

function door_sector:UniqueID()
	return self.uniqueID;
end;

ix.meta.door_sector = door_sector
