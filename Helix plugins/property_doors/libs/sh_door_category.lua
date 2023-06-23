ix.doors = ix.doors or {};
ix.doors.category = ix.doors.category or {};
ix.doors.category.list = ix.doors.category.list or {};

function ix.doors.category.Load(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		ix.doors.category.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

function ix.doors.category.Register(uniqueID, path)
	if (uniqueID) then
		door_category = ix.doors.category.list[uniqueID] or setmetatable({}, ix.meta.door_category)
			door_category.uniqueID = uniqueID;
			door_category.name = door_category.name or "unknown";
			door_category.price = door_category.price or 0;
			
			if (path) then ix.util.Include(path) end;

			ix.doors.category.list[uniqueID] = door_category;
		door_category = nil;
	end;
end