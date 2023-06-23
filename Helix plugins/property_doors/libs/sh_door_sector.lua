ix.doors = ix.doors or {};
ix.doors.sector = ix.doors.sector or {};
ix.doors.sector.list = ix.doors.sector.list or {};

function ix.doors.sector.Load(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		ix.doors.sector.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

function ix.doors.sector.Register(uniqueID, path)
	if (uniqueID) then
		door_sector = ix.doors.sector.list[uniqueID] or setmetatable({}, ix.meta.door_sector)
			door_sector.uniqueID = uniqueID;
			door_sector.name = door_sector.name or "unknown";
			
			if (path) then ix.util.Include(path) end;

			ix.doors.sector.list[uniqueID] = door_sector;
		door_sector = nil;
	end;
end